import { Injectable, NotFoundException } from '@nestjs/common';
import { PermissionRepository } from '../../domain/repositories/permission.repository';
import { PermissionSet } from '../../domain/entities/user.entity';
import { Role, DataAccessLevel, Permission } from '@prisma/client';

@Injectable()
export class PermissionService {
  constructor(private readonly permissionRepository: PermissionRepository) {}

  async getUserPermissions(userId: string): Promise<PermissionSet> {
    const permissions = await this.permissionRepository.findByUserId(userId);
    if (!permissions) {
      throw new NotFoundException('User permissions not found');
    }
    return permissions;
  }

  async getUserRoles(userId: string): Promise<Role[]> {
    const permissions = await this.getUserPermissions(userId);
    return permissions.roles;
  }

  async hasRole(userId: string, role: Role): Promise<boolean> {
    try {
      const permissions = await this.getUserPermissions(userId);
      return permissions.hasRole(role);
    } catch {
      return false;
    }
  }

  async assignRole(userId: string, role: Role): Promise<PermissionSet> {
    const permissions = await this.getUserPermissions(userId);
    permissions.addRole(role);

    return this.permissionRepository.update(userId, {
      roles: permissions.roles,
    });
  }

  async removeRole(userId: string, role: Role): Promise<PermissionSet> {
    const permissions = await this.getUserPermissions(userId);
    permissions.removeRole(role);

    return this.permissionRepository.update(userId, {
      roles: permissions.roles,
    });
  }

  async hasPermission(
    userId: string,
    permission: Permission,
  ): Promise<boolean> {
    try {
      const permissions = await this.getUserPermissions(userId);
      return permissions.hasPermission(permission);
    } catch {
      return false;
    }
  }

  async grantPermission(
    userId: string,
    permission: Permission,
  ): Promise<PermissionSet> {
    const permissions = await this.getUserPermissions(userId);
    permissions.grantPermission(permission);

    return this.permissionRepository.update(userId, {
      customPermissions: permissions.customPermissions,
    });
  }

  async revokePermission(
    userId: string,
    permission: Permission,
  ): Promise<PermissionSet> {
    const permissions = await this.getUserPermissions(userId);
    permissions.revokePermission(permission);

    return this.permissionRepository.update(userId, {
      customPermissions: permissions.customPermissions,
    });
  }

  async getDataAccessLevel(userId: string): Promise<DataAccessLevel> {
    const permissions = await this.getUserPermissions(userId);
    return permissions.dataAccessLevel;
  }

  async setDataAccessLevel(
    userId: string,
    level: DataAccessLevel,
  ): Promise<PermissionSet> {
    const permissions = await this.getUserPermissions(userId);
    permissions.setDataAccessLevel(level);

    return this.permissionRepository.update(userId, {
      dataAccessLevel: level,
    });
  }

  async makeAdmin(userId: string): Promise<PermissionSet> {
    const permissions = await this.getUserPermissions(userId);
    permissions.makeAdmin();

    return this.permissionRepository.update(userId, {
      isAdmin: true,
      roles: permissions.roles,
    });
  }

  async removeAdmin(userId: string): Promise<PermissionSet> {
    const permissions = await this.getUserPermissions(userId);
    permissions.removeAdmin();

    return this.permissionRepository.update(userId, {
      isAdmin: false,
      roles: permissions.roles,
    });
  }

  async isAdmin(userId: string): Promise<boolean> {
    try {
      const permissions = await this.getUserPermissions(userId);
      return permissions.isAdmin;
    } catch {
      return false;
    }
  }

  async findUsersByRole(role: Role): Promise<string[]> {
    return this.permissionRepository.findUsersByRole(role);
  }

  async findUsersByDataAccessLevel(level: DataAccessLevel): Promise<string[]> {
    return this.permissionRepository.findUsersByDataAccessLevel(level);
  }

  async canAccessHealthData(userId: string): Promise<boolean> {
    const level = await this.getDataAccessLevel(userId);
    return level !== DataAccessLevel.NONE;
  }

  async canManageCareGroup(userId: string): Promise<boolean> {
    const hasRole = await this.hasRole(userId, Role.FAMILY_ADMIN);
    const hasPermission = await this.hasPermission(
      userId,
      Permission.MANAGE_CARE_GROUP,
    );
    return hasRole || hasPermission;
  }

  async canWriteHealthData(userId: string): Promise<boolean> {
    const level = await this.getDataAccessLevel(userId);
    const hasPermission = await this.hasPermission(
      userId,
      Permission.WRITE_HEALTH_DATA,
    );
    return level === DataAccessLevel.FULL || hasPermission;
  }
}
