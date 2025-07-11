import { Injectable } from '@nestjs/common';
import { MemberRole, Prisma } from '@prisma/client';
import { PrismaService } from '../../../common/database/prisma.service';
import { CareGroupMemberRepository } from '../../domain/repositories/care-group-member.repository';
import { CareGroupMemberEntity } from '../../domain/entities/care-group-member.entity';
import { CareGroupMemberQuery } from '../../domain/types/repository-query.types';

@Injectable()
export class PrismaCareGroupMemberRepository extends CareGroupMemberRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async create(member: CareGroupMemberEntity): Promise<CareGroupMemberEntity> {
    const prismaData = member.toPrisma();
    const data = await this.prisma.careGroupMember.create({
      data: {
        ...prismaData,
        notificationPreferences: prismaData.notificationPreferences || {},
        permissions: prismaData.permissions || [],
      },
    });

    return CareGroupMemberEntity.fromPrisma(data);
  }

  async findById(id: string): Promise<CareGroupMemberEntity | null> {
    const data = await this.prisma.careGroupMember.findUnique({
      where: { id },
    });

    return data ? CareGroupMemberEntity.fromPrisma(data) : null;
  }

  async findMany(
    query: CareGroupMemberQuery,
  ): Promise<CareGroupMemberEntity[]> {
    const where: Prisma.CareGroupMemberWhereInput = {};

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
        permissions: updates.permissions,
        lastActive: new Date(),
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

  async findInactiveMembersByThreshold(
    groupId: string,
    daysThreshold: number,
  ): Promise<CareGroupMemberEntity[]> {
    const thresholdDate = new Date(
      Date.now() - daysThreshold * 24 * 60 * 60 * 1000,
    );

    const data = await this.prisma.careGroupMember.findMany({
      where: {
        groupId,
        OR: [{ lastActive: { lt: thresholdDate } }, { lastActive: null }],
      },
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
          path: [],
          array_contains: permission,
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
      where: {
        groupId,
        isActive: true,
        permissions: {
          path: [],
          array_contains: 'invite_members',
        },
      },
      orderBy: { joinedAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  async findMembersCanManageTasks(
    groupId: string,
  ): Promise<CareGroupMemberEntity[]> {
    const data = await this.prisma.careGroupMember.findMany({
      where: {
        groupId,
        isActive: true,
        permissions: {
          path: [],
          array_contains: 'manage_tasks',
        },
      },
      orderBy: { joinedAt: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }

  async findMembersCanViewHealthData(
    groupId: string,
  ): Promise<CareGroupMemberEntity[]> {
    const data = await this.prisma.careGroupMember.findMany({
      where: {
        groupId,
        isActive: true,
        permissions: {
          path: [],
          array_contains: 'view_health_data',
        },
      },
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
      data: { role, lastActive: new Date() },
    });

    return CareGroupMemberEntity.fromPrisma(data);
  }

  async updatePermissions(
    id: string,
    permissions: string[],
  ): Promise<CareGroupMemberEntity> {
    const data = await this.prisma.careGroupMember.update({
      where: { id },
      data: { permissions, lastActive: new Date() },
    });

    return CareGroupMemberEntity.fromPrisma(data);
  }

  async activateMember(id: string): Promise<CareGroupMemberEntity> {
    const data = await this.prisma.careGroupMember.update({
      where: { id },
      data: { isActive: true, lastActive: new Date() },
    });

    return CareGroupMemberEntity.fromPrisma(data);
  }

  async deactivateMember(id: string): Promise<CareGroupMemberEntity> {
    const data = await this.prisma.careGroupMember.update({
      where: { id },
      data: { isActive: false, lastActive: new Date() },
    });

    return CareGroupMemberEntity.fromPrisma(data);
  }

  async updateLastActive(id: string): Promise<CareGroupMemberEntity> {
    const data = await this.prisma.careGroupMember.update({
      where: { id },
      data: { lastActive: new Date() },
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
          path: [],
          array_contains: permission,
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
      where: {
        groupId,
        userId,
        isActive: true,
        permissions: {
          path: [],
          array_contains: 'invite_members',
        },
      },
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
      data: { permissions, lastActive: new Date() },
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
      data: { isActive: false, lastActive: new Date() },
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
      familyMemberCount,
      observerCount,
    ] = await Promise.all([
      this.getMemberCount(groupId),
      this.getActiveMemberCount(groupId),
      this.getMemberCountByRole(groupId, MemberRole.ADMIN),
      this.getMemberCountByRole(groupId, MemberRole.CAREGIVER),
      this.getMemberCountByRole(groupId, MemberRole.FAMILY_MEMBER),
      this.getMemberCountByRole(groupId, MemberRole.OBSERVER),
    ]);

    return {
      totalMembers,
      activeMembers,
      adminCount,
      caregiverCount,
      memberCount: familyMemberCount,
      viewerCount: observerCount,
      averageJoinDuration: 0, // TODO: Calculate actual average
    };
  }

  async getMemberActivitySummary(
    groupId: string,
    _startDate: Date,
    _endDate: Date,
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
      lastActiveAt: member.lastActive,
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
        lastActive: {
          gte: thresholdDate,
        },
      },
      orderBy: { lastActive: 'desc' },
    });

    return data.map((item) => CareGroupMemberEntity.fromPrisma(item));
  }
}
