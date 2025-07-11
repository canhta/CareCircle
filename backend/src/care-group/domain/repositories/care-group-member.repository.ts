import { CareGroupMemberEntity } from '../entities/care-group-member.entity';
import { MemberRole } from '@prisma/client';

export interface MemberQuery {
  groupId?: string;
  userId?: string;
  role?: MemberRole;
  isActive?: boolean;
  limit?: number;
  offset?: number;
}

export abstract class CareGroupMemberRepository {
  abstract create(
    member: CareGroupMemberEntity,
  ): Promise<CareGroupMemberEntity>;
  abstract findById(id: string): Promise<CareGroupMemberEntity | null>;
  abstract findMany(query: MemberQuery): Promise<CareGroupMemberEntity[]>;
  abstract findByGroupId(groupId: string): Promise<CareGroupMemberEntity[]>;
  abstract findByUserId(userId: string): Promise<CareGroupMemberEntity[]>;
  abstract findByGroupAndUser(
    groupId: string,
    userId: string,
  ): Promise<CareGroupMemberEntity | null>;
  abstract update(
    id: string,
    updates: Partial<CareGroupMemberEntity>,
  ): Promise<CareGroupMemberEntity>;
  abstract delete(id: string): Promise<void>;

  // Member role operations
  abstract findByRole(
    groupId: string,
    role: MemberRole,
  ): Promise<CareGroupMemberEntity[]>;
  abstract findAdmins(groupId: string): Promise<CareGroupMemberEntity[]>;
  abstract findCaregivers(groupId: string): Promise<CareGroupMemberEntity[]>;
  abstract findActiveMembers(groupId: string): Promise<CareGroupMemberEntity[]>;
  abstract findInactiveMembers(
    groupId: string,
  ): Promise<CareGroupMemberEntity[]>;

  // Permission operations
  abstract findMembersWithPermission(
    groupId: string,
    permission: string,
  ): Promise<CareGroupMemberEntity[]>;
  abstract findMembersCanInvite(
    groupId: string,
  ): Promise<CareGroupMemberEntity[]>;
  abstract findMembersCanManageTasks(
    groupId: string,
  ): Promise<CareGroupMemberEntity[]>;
  abstract findMembersCanViewHealthData(
    groupId: string,
  ): Promise<CareGroupMemberEntity[]>;

  // Member management operations
  abstract updateRole(
    id: string,
    role: MemberRole,
  ): Promise<CareGroupMemberEntity>;
  abstract updatePermissions(
    id: string,
    permissions: string[],
  ): Promise<CareGroupMemberEntity>;
  abstract activateMember(id: string): Promise<CareGroupMemberEntity>;
  abstract deactivateMember(id: string): Promise<CareGroupMemberEntity>;
  abstract updateLastActive(id: string): Promise<CareGroupMemberEntity>;

  // Activity tracking
  abstract findRecentlyActive(
    groupId: string,
    hoursThreshold: number,
  ): Promise<CareGroupMemberEntity[]>;
  abstract findInactiveMembersByThreshold(
    groupId: string,
    daysThreshold: number,
  ): Promise<CareGroupMemberEntity[]>;

  // Count operations
  abstract getMemberCount(groupId: string): Promise<number>;
  abstract getActiveMemberCount(groupId: string): Promise<number>;
  abstract getMemberCountByRole(
    groupId: string,
    role: MemberRole,
  ): Promise<number>;
  abstract getAdminCount(groupId: string): Promise<number>;
  abstract getCaregiverCount(groupId: string): Promise<number>;

  // Validation operations
  abstract checkMemberExists(groupId: string, userId: string): Promise<boolean>;
  abstract checkMemberHasPermission(
    groupId: string,
    userId: string,
    permission: string,
  ): Promise<boolean>;
  abstract checkMemberIsAdmin(
    groupId: string,
    userId: string,
  ): Promise<boolean>;
  abstract checkMemberCanInvite(
    groupId: string,
    userId: string,
  ): Promise<boolean>;

  // Bulk operations
  abstract bulkUpdatePermissions(
    memberIds: string[],
    permissions: string[],
  ): Promise<CareGroupMemberEntity[]>;
  abstract bulkDeactivateMembers(
    memberIds: string[],
  ): Promise<CareGroupMemberEntity[]>;

  // Analytics operations
  abstract getMemberStatistics(groupId: string): Promise<{
    totalMembers: number;
    activeMembers: number;
    adminCount: number;
    caregiverCount: number;
    memberCount: number;
    viewerCount: number;
    averageJoinDuration: number;
  }>;
  abstract getMemberActivitySummary(
    groupId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<
    Array<{
      memberId: string;
      userId: string;
      role: MemberRole;
      lastActiveAt: Date | null;
      activityCount: number;
    }>
  >;
}
