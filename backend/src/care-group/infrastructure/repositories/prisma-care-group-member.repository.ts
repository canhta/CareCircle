import { Injectable } from '@nestjs/common';
import { MemberRole } from '@prisma/client';
import { PrismaService } from '../../../common/database/prisma.service';
import {
  CareGroupMemberRepository,
  MemberQuery,
} from '../../domain/repositories/care-group-member.repository';
import { CareGroupMemberEntity } from '../../domain/entities/care-group-member.entity';

@Injectable()
export class PrismaCareGroupMemberRepository extends CareGroupMemberRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async create(member: CareGroupMemberEntity): Promise<CareGroupMemberEntity> {
    const data = await this.prisma.careGroupMember.create({
      data: member.toPrisma(),
    });

    return CareGroupMemberEntity.fromPrisma(data);
  }

  async findById(id: string): Promise<CareGroupMemberEntity | null> {
    const data = await this.prisma.careGroupMember.findUnique({
      where: { id },
    });

    return data ? CareGroupMemberEntity.fromPrisma(data) : null;
  }

  async findMany(query: MemberQuery): Promise<CareGroupMemberEntity[]> {
    const where: any = {};

    if (query.groupId) where.groupId = query.groupId;
    if (query.userId) where.userId = query.userId;
    if (query.role) where.role = query.role;
    if (query.isActive !== undefined) where.isActive = query.isActive;

    const data = await this.prisma.careGroupMember.findMany({
      where,
      take: query.limit,
      skip: query.offset,
      orderBy: { joinedAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  async findByGroupId(groupId: string): Promise<CareGroupMemberEntity[]> {
    const data = await this.prisma.careGroupMember.findMany({
      where: { groupId },
      orderBy: { joinedAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  async findByUserId(userId: string): Promise<CareGroupMemberEntity[]> {
    const data = await this.prisma.careGroupMember.findMany({
      where: { userId },
      orderBy: { joinedAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  async findByGroupAndUser(
    groupId: string,
    userId: string,
  ): Promise<CareGroupMemberEntity | null> {
    const data = await this.prisma.careGroupMember.findFirst({
      where: { groupId, userId },
    });

    return data ? CareGroupMemberEntity.fromPrisma(data) : null;
  }

  async update(
    id: string,
    updates: Partial<CareGroupMemberEntity>,
  ): Promise<CareGroupMemberEntity> {
    const data = await this.prisma.careGroupMember.update({
      where: { id },
      data: {
        role: updates.role,
        customTitle: updates.customTitle,
        isActive: updates.isActive,
        canInviteMembers: updates.canInviteMembers,
        canManageTasks: updates.canManageTasks,
        canViewHealthData: updates.canViewHealthData,
        permissions: updates.permissions,
        lastActiveAt: new Date(),
      },
    });

    return CareGroupMemberEntity.fromPrisma(data);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.careGroupMember.delete({
      where: { id },
    });
  }

  // Member role operations
  async findByRole(
    groupId: string,
    role: MemberRole,
  ): Promise<CareGroupMemberEntity[]> {
    const data = await this.prisma.careGroupMember.findMany({
      where: { groupId, role },
      orderBy: { joinedAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  async findAdmins(groupId: string): Promise<CareGroupMemberEntity[]> {
    return this.findByRole(groupId, MemberRole.ADMIN);
  }

  async findCaregivers(groupId: string): Promise<CareGroupMemberEntity[]> {
    const data = await this.prisma.careGroupMember.findMany({
      where: {
        groupId,
        role: { in: [MemberRole.ADMIN, MemberRole.CAREGIVER] },
      },
      orderBy: { joinedAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  async findActiveMembers(groupId: string): Promise<CareGroupMemberEntity[]> {
    const data = await this.prisma.careGroupMember.findMany({
      where: { groupId, isActive: true },
      orderBy: { joinedAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  async findInactiveMembers(groupId: string): Promise<CareGroupMemberEntity[]> {
    const data = await this.prisma.careGroupMember.findMany({
      where: { groupId, isActive: false },
      orderBy: { joinedAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  // Permission operations
  async findMembersWithPermission(
    groupId: string,
    permission: string,
  ): Promise<CareGroupMemberEntity[]> {
    const data = await this.prisma.careGroupMember.findMany({
      where: {
        groupId,
        permissions: {
          has: permission,
        },
      },
      orderBy: { joinedAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  async findMembersCanInvite(
    groupId: string,
  ): Promise<CareGroupMemberEntity[]> {
    const data = await this.prisma.careGroupMember.findMany({
      where: { groupId, canInviteMembers: true, isActive: true },
      orderBy: { joinedAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  async findMembersCanManageTasks(
    groupId: string,
  ): Promise<CareGroupMemberEntity[]> {
    const data = await this.prisma.careGroupMember.findMany({
      where: { groupId, canManageTasks: true, isActive: true },
      orderBy: { joinedAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  async findMembersCanViewHealthData(
    groupId: string,
  ): Promise<CareGroupMemberEntity[]> {
    const data = await this.prisma.careGroupMember.findMany({
      where: { groupId, canViewHealthData: true, isActive: true },
      orderBy: { joinedAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  // Member management operations
  async updateRole(
    id: string,
    role: MemberRole,
  ): Promise<CareGroupMemberEntity> {
    const data = await this.prisma.careGroupMember.update({
      where: { id },
      data: { role, lastActiveAt: new Date() },
    });

    return CareGroupMemberEntity.fromPrisma(data);
  }

  async updatePermissions(
    id: string,
    permissions: string[],
  ): Promise<CareGroupMemberEntity> {
    const data = await this.prisma.careGroupMember.update({
      where: { id },
      data: { permissions, lastActiveAt: new Date() },
    });

    return CareGroupMemberEntity.fromPrisma(data);
  }

  async activateMember(id: string): Promise<CareGroupMemberEntity> {
    const data = await this.prisma.careGroupMember.update({
      where: { id },
      data: { isActive: true, lastActiveAt: new Date() },
    });

    return CareGroupMemberEntity.fromPrisma(data);
  }

  async deactivateMember(id: string): Promise<CareGroupMemberEntity> {
    const data = await this.prisma.careGroupMember.update({
      where: { id },
      data: { isActive: false, lastActiveAt: new Date() },
    });

    return CareGroupMemberEntity.fromPrisma(data);
  }

  async updateLastActive(id: string): Promise<CareGroupMemberEntity> {
    const data = await this.prisma.careGroupMember.update({
      where: { id },
      data: { lastActiveAt: new Date() },
    });

    return CareGroupMemberEntity.fromPrisma(data);
  }

  // Count operations
  async getMemberCount(groupId: string): Promise<number> {
    return this.prisma.careGroupMember.count({
      where: { groupId },
    });
  }

  async getActiveMemberCount(groupId: string): Promise<number> {
    return this.prisma.careGroupMember.count({
      where: { groupId, isActive: true },
    });
  }

  async getMemberCountByRole(
    groupId: string,
    role: MemberRole,
  ): Promise<number> {
    return this.prisma.careGroupMember.count({
      where: { groupId, role },
    });
  }

  async getAdminCount(groupId: string): Promise<number> {
    return this.getMemberCountByRole(groupId, MemberRole.ADMIN);
  }

  async getCaregiverCount(groupId: string): Promise<number> {
    return this.prisma.careGroupMember.count({
      where: {
        groupId,
        role: { in: [MemberRole.ADMIN, MemberRole.CAREGIVER] },
      },
    });
  }

  // Validation operations
  async checkMemberExists(groupId: string, userId: string): Promise<boolean> {
    const count = await this.prisma.careGroupMember.count({
      where: { groupId, userId },
    });
    return count > 0;
  }

  async checkMemberHasPermission(
    groupId: string,
    userId: string,
    permission: string,
  ): Promise<boolean> {
    const count = await this.prisma.careGroupMember.count({
      where: {
        groupId,
        userId,
        permissions: {
          has: permission,
        },
      },
    });
    return count > 0;
  }

  async checkMemberIsAdmin(groupId: string, userId: string): Promise<boolean> {
    const count = await this.prisma.careGroupMember.count({
      where: { groupId, userId, role: MemberRole.ADMIN },
    });
    return count > 0;
  }

  async checkMemberCanInvite(
    groupId: string,
    userId: string,
  ): Promise<boolean> {
    const count = await this.prisma.careGroupMember.count({
      where: { groupId, userId, canInviteMembers: true, isActive: true },
    });
    return count > 0;
  }

  // Bulk operations
  async bulkUpdatePermissions(
    memberIds: string[],
    permissions: string[],
  ): Promise<CareGroupMemberEntity[]> {
    await this.prisma.careGroupMember.updateMany({
      where: { id: { in: memberIds } },
      data: { permissions, lastActiveAt: new Date() },
    });

    const data = await this.prisma.careGroupMember.findMany({
      where: { id: { in: memberIds } },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  async bulkDeactivateMembers(
    memberIds: string[],
  ): Promise<CareGroupMemberEntity[]> {
    await this.prisma.careGroupMember.updateMany({
      where: { id: { in: memberIds } },
      data: { isActive: false, lastActiveAt: new Date() },
    });

    const data = await this.prisma.careGroupMember.findMany({
      where: { id: { in: memberIds } },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  // Analytics operations (simplified for now)
  async getMemberStatistics(groupId: string): Promise<{
    totalMembers: number;
    activeMembers: number;
    adminCount: number;
    caregiverCount: number;
    memberCount: number;
    viewerCount: number;
    averageJoinDuration: number;
  }> {
    const [
      totalMembers,
      activeMembers,
      adminCount,
      caregiverCount,
      memberCount,
      viewerCount,
    ] = await Promise.all([
      this.getMemberCount(groupId),
      this.getActiveMemberCount(groupId),
      this.getMemberCountByRole(groupId, MemberRole.ADMIN),
      this.getMemberCountByRole(groupId, MemberRole.CAREGIVER),
      this.getMemberCountByRole(groupId, MemberRole.MEMBER),
      this.getMemberCountByRole(groupId, MemberRole.VIEWER),
    ]);

    return {
      totalMembers,
      activeMembers,
      adminCount,
      caregiverCount,
      memberCount,
      viewerCount,
      averageJoinDuration: 0, // TODO: Calculate actual average
    };
  }

  async getMemberActivitySummary(
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
  > {
    // Simplified implementation - can be enhanced later
    const members = await this.findByGroupId(groupId);

    return members.map((member) => ({
      memberId: member.id,
      userId: member.userId,
      role: member.role,
      lastActiveAt: member.lastActiveAt,
      activityCount: 0, // TODO: Calculate actual activity count
    }));
  }

  // Additional required methods (simplified implementations)
  async findRecentlyActive(
    groupId: string,
    hoursThreshold: number,
  ): Promise<CareGroupMemberEntity[]> {
    const thresholdDate = new Date(
      Date.now() - hoursThreshold * 60 * 60 * 1000,
    );

    const data = await this.prisma.careGroupMember.findMany({
      where: {
        groupId,
        lastActiveAt: {
          gte: thresholdDate,
        },
      },
      orderBy: { lastActiveAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  async findInactiveMembers(
    groupId: string,
    daysThreshold: number,
  ): Promise<CareGroupMemberEntity[]> {
    const thresholdDate = new Date(
      Date.now() - daysThreshold * 24 * 60 * 60 * 1000,
    );

    const data = await this.prisma.careGroupMember.findMany({
      where: {
        groupId,
        OR: [{ lastActiveAt: { lt: thresholdDate } }, { lastActiveAt: null }],
      },
      orderBy: { joinedAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }
}
