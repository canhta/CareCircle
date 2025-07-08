import { PermissionSet } from '../entities/user.entity';
import { Role, DataAccessLevel } from '@prisma/client';

export abstract class PermissionRepository {
  abstract findByUserId(userId: string): Promise<PermissionSet | null>;
  abstract create(permissionSet: PermissionSet): Promise<PermissionSet>;
  abstract update(
    userId: string,
    updates: Partial<PermissionSet>,
  ): Promise<PermissionSet>;
  abstract delete(userId: string): Promise<void>;
  abstract findUsersByRole(role: Role): Promise<string[]>;
  abstract findUsersByDataAccessLevel(
    level: DataAccessLevel,
  ): Promise<string[]>;
}
