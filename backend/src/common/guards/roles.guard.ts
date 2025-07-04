import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Logger,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { PrismaService } from '../../prisma/prisma.service';
import { AuditService } from '../services/audit.service';
import {
  ROLES_KEY,
  PERMISSIONS_KEY,
  SystemRole,
  Permission,
  ROLE_PERMISSIONS,
} from '../decorators/roles.decorator';
import {
  UserWithRoles,
  GuardRequest,
  AuthFailureDetails,
} from '../interfaces/guards.interfaces';

@Injectable()
export class RolesGuard implements CanActivate {
  private readonly logger = new Logger(RolesGuard.name);

  constructor(
    private readonly reflector: Reflector,
    private readonly prisma: PrismaService,
    private readonly auditService: AuditService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    // Get required roles and permissions from metadata
    const requiredRoles = this.reflector.getAllAndOverride<SystemRole[]>(
      ROLES_KEY,
      [context.getHandler(), context.getClass()],
    );

    const requiredPermissions = this.reflector.getAllAndOverride<Permission[]>(
      PERMISSIONS_KEY,
      [context.getHandler(), context.getClass()],
    );

    // If no roles or permissions are required, allow access
    if (!requiredRoles && !requiredPermissions) {
      return true;
    }

    const request = context.switchToHttp().getRequest<GuardRequest>();
    const user = request.user;

    if (!user) {
      throw new ForbiddenException('Authentication required');
    }

    const userId = user.id || (user.sub as string);

    try {
      // Get user with roles and permissions
      const userWithRoles = await this.getUserWithRoles(userId);

      if (!userWithRoles) {
        throw new ForbiddenException('User not found');
      }

      // Check if user is active
      if (!userWithRoles.isActive) {
        throw new ForbiddenException('User account is inactive');
      }

      // Check role requirements
      if (
        requiredRoles &&
        !this.hasRequiredRoles(userWithRoles, requiredRoles)
      ) {
        const userRolesArray = Array.isArray(userWithRoles.roles)
          ? userWithRoles.roles
          : [userWithRoles.roles];

        await this.auditAuthorizationFailure(
          userId,
          'INSUFFICIENT_ROLE',
          request,
          { requiredRoles, userRoles: userRolesArray },
        );
        throw new ForbiddenException(
          `Insufficient role. Required: ${requiredRoles.join(', ')}, Has: ${userRolesArray.join(', ')}`,
        );
      }

      // Check permission requirements
      if (
        requiredPermissions &&
        !this.hasRequiredPermissions(userWithRoles, requiredPermissions)
      ) {
        const userPermissions = this.getUserPermissions(userWithRoles);
        await this.auditAuthorizationFailure(
          userId,
          'INSUFFICIENT_PERMISSIONS',
          request,
          {
            requiredPermissions,
            userPermissions,
          },
        );
        throw new ForbiddenException(
          `Insufficient permissions. Required: ${requiredPermissions.join(', ')}`,
        );
      }

      // Audit successful authorization for sensitive operations
      if (this.isSensitiveOperation(requiredRoles, requiredPermissions)) {
        const userRolesArray = Array.isArray(userWithRoles.roles)
          ? userWithRoles.roles
          : [userWithRoles.roles];

        await this.auditService.logSecurityEvent({
          userId,
          action: 'AUTHORIZATION_SUCCESS',
          resource: `${request.method} ${request.url}`,
          details: {
            requiredRoles,
            requiredPermissions,
            userRoles: userRolesArray,
          },
          timestamp: new Date(),
          severity: 'LOW',
          eventType: 'AUTHORIZATION',
        });
      }

      return true;
    } catch (error) {
      this.logger.error(
        `Authorization failed for user ${userId}: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  private async getUserWithRoles(
    userId: string,
  ): Promise<UserWithRoles | null> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        isActive: true,
        roles: true, // Assuming roles are stored as an array or enum
        // If roles are in a separate table, include them here
      },
    });

    return user as UserWithRoles | null;
  }

  private hasRequiredRoles(
    user: UserWithRoles,
    requiredRoles: SystemRole[],
  ): boolean {
    const userRoles = Array.isArray(user.roles) ? user.roles : [user.roles];
    return requiredRoles.some((role) => userRoles.includes(role));
  }

  private hasRequiredPermissions(
    user: UserWithRoles,
    requiredPermissions: Permission[],
  ): boolean {
    const userPermissions = this.getUserPermissions(user);
    return requiredPermissions.every((permission) =>
      userPermissions.includes(permission),
    );
  }

  private getUserPermissions(user: UserWithRoles): Permission[] {
    const userRoles = Array.isArray(user.roles) ? user.roles : [user.roles];
    const permissions = new Set<Permission>();

    userRoles.forEach((role: SystemRole) => {
      const rolePermissions = ROLE_PERMISSIONS[role] || [];
      rolePermissions.forEach((permission) => permissions.add(permission));
    });

    return Array.from(permissions);
  }

  private isSensitiveOperation(
    roles?: SystemRole[],
    permissions?: Permission[],
  ): boolean {
    const sensitiveRoles = [SystemRole.SUPER_ADMIN, SystemRole.ADMIN];
    const sensitivePermissions = [
      Permission.DELETE_USER,
      Permission.DELETE_HEALTH_RECORD,
      Permission.DELETE_PRESCRIPTION,
      Permission.ACCESS_AUDIT_LOGS,
      Permission.MANAGE_SYSTEM_SETTINGS,
    ];

    const hasSensitiveRole = roles?.some((role) =>
      sensitiveRoles.includes(role),
    );
    const hasSensitivePermission = permissions?.some((permission) =>
      sensitivePermissions.includes(permission),
    );

    return hasSensitiveRole || hasSensitivePermission || false;
  }

  private async auditAuthorizationFailure(
    userId: string,
    failureReason: string,
    request: GuardRequest,
    details: AuthFailureDetails,
  ): Promise<void> {
    await this.auditService.logSecurityEvent({
      userId,
      action: 'AUTHORIZATION_FAILURE',
      resource: `${request.method} ${request.url}`,
      details: {
        reason: failureReason,
        ...details,
        ip: request.ip,
        userAgent: request.get('User-Agent'),
      },
      timestamp: new Date(),
      severity: 'MEDIUM',
      eventType: 'AUTHORIZATION',
    });
  }
}
