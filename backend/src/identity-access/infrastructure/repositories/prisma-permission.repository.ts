import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { PermissionRepository } from '../../domain/repositories/permission.repository';
import { PermissionSet } from '../../domain/entities/user.entity';
import { Role, DataAccessLevel } from '@prisma/client';

@Injectable()
export class PrismaPermissionRepository implements PermissionRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findByUserId(userId: string): Promise<PermissionSet | null> {
    const permissions = await this.prisma.permissionSet.findUnique({
      where: { userId },
    });

    if (!permissions) return null;

    return new PermissionSet(
      permissions.id,
      permissions.userId,
      permissions.roles,
      permissions.customPermissions,
      permissions.dataAccessLevel,
      permissions.isAdmin,
      permissions.createdAt,
      permissions.updatedAt,
    );
  }

  async create(permissionSet: PermissionSet): Promise<PermissionSet> {
    const created = await this.prisma.permissionSet.create({
      data: {
        id: permissionSet.id,
        userId: permissionSet.userId,
        roles: permissionSet.roles,
        customPermissions: permissionSet.customPermissions,
        dataAccessLevel: permissionSet.dataAccessLevel,
        isAdmin: permissionSet.isAdmin,
      },
    });

    return new PermissionSet(
      created.id,
      created.userId,
      created.roles,
      created.customPermissions,
      created.dataAccessLevel,
      created.isAdmin,
      created.createdAt,
      created.updatedAt,
    );
  }

  async update(
    userId: string,
    updates: Partial<PermissionSet>,
  ): Promise<PermissionSet> {
    const updated = await this.prisma.permissionSet.update({
      where: { userId },
      data: {
        roles: updates.roles,
        customPermissions: updates.customPermissions,
        dataAccessLevel: updates.dataAccessLevel,
        isAdmin: updates.isAdmin,
      },
    });

    return new PermissionSet(
      updated.id,
      updated.userId,
      updated.roles,
      updated.customPermissions,
      updated.dataAccessLevel,
      updated.isAdmin,
      updated.createdAt,
      updated.updatedAt,
    );
  }

  async delete(userId: string): Promise<void> {
    await this.prisma.permissionSet.delete({
      where: { userId },
    });
  }

  async findUsersByRole(role: Role): Promise<string[]> {
    const permissions = await this.prisma.permissionSet.findMany({
      where: {
        roles: {
          has: role,
        },
      },
      select: {
        userId: true,
      },
    });

    return permissions.map((p) => p.userId);
  }

  async findUsersByDataAccessLevel(level: DataAccessLevel): Promise<string[]> {
    const permissions = await this.prisma.permissionSet.findMany({
      where: {
        dataAccessLevel: level,
      },
      select: {
        userId: true,
      },
    });

    return permissions.map((p) => p.userId);
  }
}
