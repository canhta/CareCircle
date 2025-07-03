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

    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
    const request = context.switchToHttp().getRequest();
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
    const user = request.user as { sub: string; email: string };
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
    const careGroupId = (request.params?.careGroupId ||
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
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
      membership,
      requiredPermissions,
    );

    if (!hasPermissions) {
      throw new ForbiddenException(
        `User does not have required permissions: ${requiredPermissions.join(', ')}`,
      );
    }

    // Attach membership to request for use in controllers
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
    request.careGroupMembership = membership;

    return true;
  }

  private checkPermissions(
    membership: any,
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
    membership: any,
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
        // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-return
        return membership.canViewHealth;
      case 'receiveAlerts':
        // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-return
        return membership.canReceiveAlerts;
      case 'manageSettings':
        // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-return
        return membership.canManageSettings;
      case 'manageMembers':
        // Only owners and admins can manage members

        return (
          membership.role === CareRole.OWNER ||
          membership.role === CareRole.ADMIN
        );
      case 'viewMembers':
        // All members can view other members
        return true;
      default:
        return false;
    }
  }
}
