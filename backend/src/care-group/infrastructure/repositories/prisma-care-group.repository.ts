import { Injectable } from '@nestjs/common';
import { CareGroup as PrismaCareGroup, CareGroupType } from '@prisma/client';
import { PrismaService } from '../../../common/database/prisma.service';
import { CareGroupRepository, CareGroupQuery } from '../../domain/repositories/care-group.repository';
import { CareGroupEntity } from '../../domain/entities/care-group.entity';

@Injectable()
export class PrismaCareGroupRepository extends CareGroupRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async create(careGroup: CareGroupEntity): Promise<CareGroupEntity> {
    const data = await this.prisma.careGroup.create({
      data: careGroup.toPrisma(),
    });

    return CareGroupEntity.fromPrisma(data);
  }

  async findById(id: string): Promise<CareGroupEntity | null> {
    const data = await this.prisma.careGroup.findUnique({
      where: { id },
    });

    return data ? CareGroupEntity.fromPrisma(data) : null;
  }

  async findMany(query: CareGroupQuery): Promise<CareGroupEntity[]> {
    const where: any = {};

    if (query.type) {
      where.type = query.type;
    }
    if (query.isActive !== undefined) {
      where.isActive = query.isActive;
    }

    // Filter by user membership
    if (query.userId) {
      where.members = {
        some: {
          userId: query.userId,
          isActive: true,
        },
      };
    }

    const data = await this.prisma.careGroup.findMany({
      where,
      take: query.limit,
      skip: query.offset,
      orderBy: { createdAt: 'desc' },
    });

    return data.map(item => CareGroupEntity.fromPrisma(item));
  }

  async findByUserId(userId: string): Promise<CareGroupEntity[]> {
    const data = await this.prisma.careGroup.findMany({
      where: {
        members: {
          some: {
            userId,
            isActive: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map(item => CareGroupEntity.fromPrisma(item));
  }

  async findByCreatedBy(createdBy: string): Promise<CareGroupEntity[]> {
    const data = await this.prisma.careGroup.findMany({
      where: { createdBy },
      orderBy: { createdAt: 'desc' },
    });

    return data.map(item => CareGroupEntity.fromPrisma(item));
  }

  async update(
    id: string,
    updates: Partial<CareGroupEntity>,
  ): Promise<CareGroupEntity> {
    const data = await this.prisma.careGroup.update({
      where: { id },
      data: {
        name: updates.name,
        description: updates.description,
        type: updates.type,
        isActive: updates.isActive,
        settings: updates.settings,
        emergencyContact: updates.emergencyContact,
        updatedAt: new Date(),
      },
    });

    return CareGroupEntity.fromPrisma(data);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.careGroup.delete({
      where: { id },
    });
  }

  // Care group specific operations
  async findByMemberId(memberId: string): Promise<CareGroupEntity[]> {
    const data = await this.prisma.careGroup.findMany({
      where: {
        members: {
          some: {
            userId: memberId,
            isActive: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map(item => CareGroupEntity.fromPrisma(item));
  }

  async findActiveGroups(userId: string): Promise<CareGroupEntity[]> {
    const data = await this.prisma.careGroup.findMany({
      where: {
        isActive: true,
        members: {
          some: {
            userId,
            isActive: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map(item => CareGroupEntity.fromPrisma(item));
  }

  async findInactiveGroups(userId: string): Promise<CareGroupEntity[]> {
    const data = await this.prisma.careGroup.findMany({
      where: {
        isActive: false,
        members: {
          some: {
            userId,
            isActive: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map(item => CareGroupEntity.fromPrisma(item));
  }

  async findByType(
    userId: string,
    type: CareGroupType,
  ): Promise<CareGroupEntity[]> {
    const data = await this.prisma.careGroup.findMany({
      where: {
        type,
        members: {
          some: {
            userId,
            isActive: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map(item => CareGroupEntity.fromPrisma(item));
  }

  // Group management operations
  async activateGroup(id: string): Promise<CareGroupEntity> {
    const data = await this.prisma.careGroup.update({
      where: { id },
      data: { isActive: true, updatedAt: new Date() },
    });

    return CareGroupEntity.fromPrisma(data);
  }

  async deactivateGroup(id: string): Promise<CareGroupEntity> {
    const data = await this.prisma.careGroup.update({
      where: { id },
      data: { isActive: false, updatedAt: new Date() },
    });

    return CareGroupEntity.fromPrisma(data);
  }

  async updateSettings(
    id: string,
    settings: Record<string, any>,
  ): Promise<CareGroupEntity> {
    const data = await this.prisma.careGroup.update({
      where: { id },
      data: { settings, updatedAt: new Date() },
    });

    return CareGroupEntity.fromPrisma(data);
  }

  async updateEmergencyContact(
    id: string,
    emergencyContact: Record<string, any>,
  ): Promise<CareGroupEntity> {
    const data = await this.prisma.careGroup.update({
      where: { id },
      data: { emergencyContact, updatedAt: new Date() },
    });

    return CareGroupEntity.fromPrisma(data);
  }

  // Search operations
  async searchByName(
    userId: string,
    searchTerm: string,
  ): Promise<CareGroupEntity[]> {
    const data = await this.prisma.careGroup.findMany({
      where: {
        name: {
          contains: searchTerm,
          mode: 'insensitive',
        },
        members: {
          some: {
            userId,
            isActive: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map(item => CareGroupEntity.fromPrisma(item));
  }

  async findGroupsWithRecentActivity(
    userId: string,
    hoursThreshold: number,
  ): Promise<CareGroupEntity[]> {
    const thresholdDate = new Date(Date.now() - hoursThreshold * 60 * 60 * 1000);

    const data = await this.prisma.careGroup.findMany({
      where: {
        members: {
          some: {
            userId,
            isActive: true,
          },
        },
        activities: {
          some: {
            createdAt: {
              gte: thresholdDate,
            },
          },
        },
      },
      orderBy: { updatedAt: 'desc' },
    });

    return data.map(item => CareGroupEntity.fromPrisma(item));
  }

  // Count operations
  async getGroupCount(userId: string): Promise<number> {
    return this.prisma.careGroup.count({
      where: {
        members: {
          some: {
            userId,
            isActive: true,
          },
        },
      },
    });
  }

  async getActiveGroupCount(userId: string): Promise<number> {
    return this.prisma.careGroup.count({
      where: {
        isActive: true,
        members: {
          some: {
            userId,
            isActive: true,
          },
        },
      },
    });
  }

  async getGroupCountByType(
    userId: string,
    type: CareGroupType,
  ): Promise<number> {
    return this.prisma.careGroup.count({
      where: {
        type,
        members: {
          some: {
            userId,
            isActive: true,
          },
        },
      },
    });
  }

  // Validation operations
  async checkGroupExists(id: string): Promise<boolean> {
    const count = await this.prisma.careGroup.count({
      where: { id },
    });
    return count > 0;
  }

  async checkUserHasAccess(groupId: string, userId: string): Promise<boolean> {
    const count = await this.prisma.careGroupMember.count({
      where: {
        groupId,
        userId,
        isActive: true,
      },
    });
    return count > 0;
  }

  async checkGroupCapacity(
    groupId: string,
    maxMembers: number,
  ): Promise<boolean> {
    const memberCount = await this.prisma.careGroupMember.count({
      where: {
        groupId,
        isActive: true,
      },
    });
    return memberCount < maxMembers;
  }

  // Analytics operations
  async getGroupStatistics(groupId: string): Promise<{
    memberCount: number;
    taskCount: number;
    completedTaskCount: number;
    activityCount: number;
    recipientCount: number;
  }> {
    const [
      memberCount,
      taskCount,
      completedTaskCount,
      activityCount,
      recipientCount,
    ] = await Promise.all([
      this.prisma.careGroupMember.count({
        where: { groupId, isActive: true },
      }),
      this.prisma.careTask.count({
        where: { groupId },
      }),
      this.prisma.careTask.count({
        where: { groupId, status: 'COMPLETED' },
      }),
      this.prisma.careActivity.count({
        where: { groupId },
      }),
      this.prisma.careRecipient.count({
        where: { groupId, isActive: true },
      }),
    ]);

    return {
      memberCount,
      taskCount,
      completedTaskCount,
      activityCount,
      recipientCount,
    };
  }

  async getGroupsCreatedInPeriod(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<CareGroupEntity[]> {
    const data = await this.prisma.careGroup.findMany({
      where: {
        createdAt: {
          gte: startDate,
          lte: endDate,
        },
        members: {
          some: {
            userId,
            isActive: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map(item => CareGroupEntity.fromPrisma(item));
  }
}
