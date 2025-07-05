import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { CareRole } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import {
  CARE_GROUP_PERMISSIONS_KEY,
  CareGroupPermission,
} from '../decorators/permissions.decorator';
import {
  CareGroupMembership,
  RequestWithCareGroup,
} from '../../common/interfaces/care-group.interfaces';

@Injectable()
export class CareGroupPermissionsGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const requiredPermissions = this.reflector.getAllAndOverride<
      CareGroupPermission[]
    >(CARE_GROUP_PERMISSIONS_KEY, [context.getHandler(), context.getClass()]);

    if (!requiredPermissions || requiredPermissions.length === 0) {
      return true;
    }

    const request = context.switchToHttp().getRequest<RequestWithCareGroup>();
    const user = request.user;
    const careGroupId = (request.params?.careGroupId ||
      request.body?.careGroupId) as string;

    if (!careGroupId) {
      throw new BadRequestException('Care group ID is required');
    }

    if (!user) {
      throw new ForbiddenException('User not authenticated');
    }

    // Get user's membership and permissions
    const membership = await this.prisma.careGroupMember.findUnique({
      where: {
        careGroupId_userId: {
          careGroupId,
          userId: user.sub,
        },
      },
    });

    if (!membership || !membership.isActive) {
      throw new ForbiddenException('User is not a member of this care group');
    }

    // Check permissions based on role and explicit permissions
    const hasPermissions = this.checkPermissions(
      membership as CareGroupMembership,
      requiredPermissions,
    );

    if (!hasPermissions) {
      throw new ForbiddenException(
        `User does not have required permissions: ${requiredPermissions.join(', ')}`,
      );
    }

    // Attach membership to request for use in controllers
    request.careGroupMembership = membership as CareGroupMembership;

    return true;
  }

  private checkPermissions(
    membership: CareGroupMembership,
    requiredPermissions: CareGroupPermission[],
  ): boolean {
    for (const permission of requiredPermissions) {
      if (!this.hasPermission(membership, permission)) {
        return false;
      }
    }
    return true;
  }

  private hasPermission(
    membership: CareGroupMembership,
    permission: CareGroupPermission,
  ): boolean {
    // Owners and admins have all permissions
    if (
      membership.role === CareRole.OWNER ||
      membership.role === CareRole.ADMIN
    ) {
      return true;
    }

    // Check specific permissions
    switch (permission) {
      case 'viewHealth':
        return membership.canViewHealth;
      case 'receiveAlerts':
        return membership.canReceiveAlerts;
      case 'manageSettings':
        return membership.canManageSettings;
      case 'manageMembers':
        // Only owners and admins can manage members
        return false; // Already checked above, owners and admins return true
      case 'viewMembers':
        // All members can view other members
        return true;
      default:
        return false;
    }
  }
}
