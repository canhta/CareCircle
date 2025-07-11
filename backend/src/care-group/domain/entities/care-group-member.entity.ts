import {
  CareGroupMember as PrismaCareGroupMember,
  MemberRole,
  Prisma,
} from '@prisma/client';

/**
 * Simplified Care Group Member Entity matching actual Prisma schema
 */
export class CareGroupMemberEntity {
  constructor(
    public readonly id: string,
    public readonly groupId: string,
    public readonly userId: string,
    public readonly role: MemberRole,
    public readonly customTitle: string | null,
    public readonly isActive: boolean,
    public readonly joinedAt: Date,
    public readonly invitedBy: string | null,
    public readonly lastActive: Date | null,
    public readonly notificationPreferences: Record<string, any>,
    public readonly permissions: string[],
  ) {}

  static create(data: {
    groupId: string;
    userId: string;
    role: MemberRole;
    customTitle?: string;
    invitedBy?: string;
    permissions?: string[];
  }) {
    return {
      groupId: data.groupId,
      userId: data.userId,
      role: data.role,
      customTitle: data.customTitle?.trim() || null,
      isActive: true,
      invitedBy: data.invitedBy || null,
      notificationPreferences: {},
      permissions: data.permissions || this.getDefaultPermissions(data.role),
    };
  }

  static fromPrisma(prisma: PrismaCareGroupMember): CareGroupMemberEntity {
    const permissions = Array.isArray(prisma.permissions)
      ? (prisma.permissions as string[])
      : [];

    return new CareGroupMemberEntity(
      prisma.id,
      prisma.groupId,
      prisma.userId,
      prisma.role,
      prisma.customTitle,
      prisma.isActive,
      prisma.joinedAt,
      prisma.invitedBy,
      prisma.lastActive,
      prisma.notificationPreferences as Record<string, any>,
      permissions,
    );
  }

  toPrisma(): Omit<PrismaCareGroupMember, 'id' | 'joinedAt' | 'lastActive'> {
    return {
      groupId: this.groupId,
      userId: this.userId,
      role: this.role,
      customTitle: this.customTitle,
      isActive: this.isActive,
      invitedBy: this.invitedBy,
      notificationPreferences: this.notificationPreferences as Prisma.JsonValue,
      permissions: this.permissions,
    };
  }

  update(data: {
    role?: MemberRole;
    customTitle?: string;
    isActive?: boolean;
    permissions?: string[];
  }): CareGroupMemberEntity {
    return new CareGroupMemberEntity(
      this.id,
      this.groupId,
      this.userId,
      data.role ?? this.role,
      data.customTitle?.trim() ?? this.customTitle,
      data.isActive ?? this.isActive,
      this.joinedAt,
      this.invitedBy,
      new Date(), // lastActive
      this.notificationPreferences,
      data.permissions ?? this.permissions,
    );
  }

  hasPermission(permission: string): boolean {
    return this.permissions.includes(permission);
  }

  isAdmin(): boolean {
    return this.role === MemberRole.ADMIN;
  }

  isCaregiver(): boolean {
    return this.role === MemberRole.CAREGIVER || this.role === MemberRole.ADMIN;
  }

  canInviteMembers(): boolean {
    return this.hasPermission('INVITE_MEMBERS') && this.isActive;
  }

  canManageTasks(): boolean {
    return this.hasPermission('MANAGE_TASKS') && this.isActive;
  }

  canViewHealthData(): boolean {
    return this.hasPermission('VIEW_HEALTH_DATA') && this.isActive;
  }

  private static getDefaultPermissions(role: MemberRole): string[] {
    switch (role) {
      case MemberRole.ADMIN:
        return [
          'INVITE_MEMBERS',
          'MANAGE_TASKS',
          'VIEW_HEALTH_DATA',
          'MANAGE_SETTINGS',
        ];
      case MemberRole.CAREGIVER:
        return ['MANAGE_TASKS', 'VIEW_HEALTH_DATA'];
      case MemberRole.FAMILY_MEMBER:
        return ['VIEW_TASKS'];
      case MemberRole.HEALTHCARE_PROVIDER:
        return ['MANAGE_TASKS', 'VIEW_HEALTH_DATA'];
      case MemberRole.OBSERVER:
        return ['VIEW_TASKS'];
      default:
        return [];
    }
  }

  toJSON(): Record<string, any> {
    return {
      id: this.id,
      groupId: this.groupId,
      userId: this.userId,
      role: this.role,
      customTitle: this.customTitle,
      isActive: this.isActive,
      joinedAt: this.joinedAt.toISOString(),
      invitedBy: this.invitedBy,
      lastActive: this.lastActive?.toISOString() || null,
      notificationPreferences: this.notificationPreferences,
      permissions: this.permissions,
      canInviteMembers: this.canInviteMembers(),
      canManageTasks: this.canManageTasks(),
      canViewHealthData: this.canViewHealthData(),
    };
  }
}
