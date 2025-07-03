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
import { SetMetadata } from '@nestjs/common';

export const CARE_GROUP_ROLES_KEY = 'careGroupRoles';
export const CareGroupRoles = (...roles: CareRole[]) =>
  SetMetadata(CARE_GROUP_ROLES_KEY, roles);

@Injectable()
export class CareGroupRolesGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const requiredRoles = this.reflector.getAllAndOverride<CareRole[]>(
      CARE_GROUP_ROLES_KEY,
      [context.getHandler(), context.getClass()],
    );

    if (!requiredRoles) {
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

    // Check if user is a member of the care group with required role
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

    if (!requiredRoles.includes(membership.role)) {
      throw new ForbiddenException(
        `User does not have required role. Required: ${requiredRoles.join(', ')}, Has: ${membership.role}`,
      );
    }

    // Attach membership to request for use in controllers
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
    request.careGroupMembership = membership;

    return true;
  }
}
