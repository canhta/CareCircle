import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { CareActivityRepository } from '../../domain/repositories/care-activity.repository';
import { CareActivityEntity } from '../../domain/entities/care-activity.entity';
import { ActivityType, Prisma } from '@prisma/client';
import {
  CareActivityQuery,
  CareActivityFilters,
  ActivityStatistics,
  ActivityTrend,
  UserActivitySummary,
  MostActiveUser,
} from '../../domain/types/repository-query.types';

@Injectable()
export class PrismaCareActivityRepository implements CareActivityRepository {
  constructor(private readonly prisma: PrismaService) {}

  async create(activityData: {
    groupId: string;
    memberId: string;
    activityType: ActivityType;
    description: string;
    data?: Record<string, any>;
  }): Promise<CareActivityEntity> {
    const created = await this.prisma.careActivity.create({
      data: {
        groupId: activityData.groupId,
        memberId: activityData.memberId,
        activityType: activityData.activityType,
        description: activityData.description,
        data: activityData.data || {},
      },
    });

    return CareActivityEntity.fromPrisma(created);
  }

  async findById(id: string): Promise<CareActivityEntity | null> {
    const activity = await this.prisma.careActivity.findUnique({
      where: { id },
    });

    return activity ? CareActivityEntity.fromPrisma(activity) : null;
  }

  async findByGroupId(
    groupId: string,
    filters?: CareActivityFilters,
  ): Promise<CareActivityEntity[]> {
    const where: Prisma.CareActivityWhereInput = { groupId };

    if (filters?.activityType) {
      where.activityType = filters.activityType;
    }
    if (filters?.memberId) {
      where.memberId = filters.memberId;
    }
    if (filters?.fromDate || filters?.toDate) {
      where.timestamp = {};
      if (filters.fromDate) {
        where.timestamp.gte = filters.fromDate;
      }
      if (filters.toDate) {
        where.timestamp.lte = filters.toDate;
      }
    }

    const activities = await this.prisma.careActivity.findMany({
      where,
      orderBy: { timestamp: 'desc' },
      take: filters?.limit || 50,
    });

    return activities.map((activity) =>
      CareActivityEntity.fromPrisma(activity),
    );
  }

  async findByMemberId(
    memberId: string,
    filters?: CareActivityFilters,
  ): Promise<CareActivityEntity[]> {
    const where: Prisma.CareActivityWhereInput = { memberId };

    if (filters?.activityType) {
      where.activityType = filters.activityType;
    }
    if (filters?.fromDate || filters?.toDate) {
      where.timestamp = {};
      if (filters.fromDate) {
        where.timestamp.gte = filters.fromDate;
      }
      if (filters.toDate) {
        where.timestamp.lte = filters.toDate;
      }
    }

    const activities = await this.prisma.careActivity.findMany({
      where,
      orderBy: { timestamp: 'desc' },
      take: filters?.limit || 50,
    });

    return activities.map((activity) =>
      CareActivityEntity.fromPrisma(activity),
    );
  }

  // Implement missing abstract methods
  async findMany(query: CareActivityQuery): Promise<CareActivityEntity[]> {
    const where: Prisma.CareActivityWhereInput = {};

    if (query.groupId) where.groupId = query.groupId;
    if (query.memberId) where.memberId = query.memberId;
    if (query.activityType) where.activityType = query.activityType;
    if (query.fromDate || query.toDate) {
      where.timestamp = {};
      if (query.fromDate) where.timestamp.gte = query.fromDate;
      if (query.toDate) where.timestamp.lte = query.toDate;
    }

    const data = await this.prisma.careActivity.findMany({
      where,
      orderBy: { timestamp: 'desc' },
      take: query.limit || 50,
      skip: query.offset || 0,
    });

    return data.map((item) => CareActivityEntity.fromPrisma(item));
  }

  async findByUserId(
    userId: string,
    filters?: CareActivityFilters,
  ): Promise<CareActivityEntity[]> {
    return this.findByMemberId(userId, filters);
  }

  async findByType(
    groupId: string,
    type: ActivityType,
  ): Promise<CareActivityEntity[]> {
    const data = await this.prisma.careActivity.findMany({
      where: { groupId, activityType: type },
      orderBy: { timestamp: 'desc' },
    });

    return data.map((item) => CareActivityEntity.fromPrisma(item));
  }

  async findTaskActivities(groupId: string): Promise<CareActivityEntity[]> {
    const data = await this.prisma.careActivity.findMany({
      where: {
        groupId,
        activityType: { in: ['TASK_CREATED', 'TASK_COMPLETED'] },
      },
      orderBy: { timestamp: 'desc' },
    });

    return data.map((item) => CareActivityEntity.fromPrisma(item));
  }

  async findMemberActivities(groupId: string): Promise<CareActivityEntity[]> {
    const data = await this.prisma.careActivity.findMany({
      where: {
        groupId,
        activityType: { in: ['MEMBER_JOINED', 'MEMBER_LEFT'] },
      },
      orderBy: { timestamp: 'desc' },
    });

    return data.map((item) => CareActivityEntity.fromPrisma(item));
  }

  async findRecipientActivities(
    groupId: string,
  ): Promise<CareActivityEntity[]> {
    const data = await this.prisma.careActivity.findMany({
      where: {
        groupId,
        activityType: 'HEALTH_UPDATE',
      },
      orderBy: { timestamp: 'desc' },
    });

    return data.map((item) => CareActivityEntity.fromPrisma(item));
  }

  async findSystemActivities(groupId: string): Promise<CareActivityEntity[]> {
    const data = await this.prisma.careActivity.findMany({
      where: {
        groupId,
        activityType: { in: ['MEDICATION_TAKEN', 'EMERGENCY_ALERT'] },
      },
      orderBy: { timestamp: 'desc' },
    });

    return data.map((item) => CareActivityEntity.fromPrisma(item));
  }

  async findRecentByGroupId(
    groupId: string,
    limit: number = 20,
  ): Promise<CareActivityEntity[]> {
    const activities = await this.prisma.careActivity.findMany({
      where: { groupId },
      orderBy: { timestamp: 'desc' },
      take: limit,
    });

    return activities.map((activity) =>
      CareActivityEntity.fromPrisma(activity),
    );
  }

  async delete(id: string): Promise<void> {
    await this.prisma.careActivity.delete({
      where: { id },
    });
  }

  async getActivityStatistics(groupId: string): Promise<ActivityStatistics> {
    const where: Prisma.CareActivityWhereInput = { groupId };

    // Get total count
    const totalActivities = await this.prisma.careActivity.count({ where });

    // Get counts by activity type
    const taskActivities = await this.prisma.careActivity.count({
      where: {
        groupId,
        activityType: {
          in: [ActivityType.TASK_CREATED, ActivityType.TASK_COMPLETED],
        },
      },
    });

    const memberActivities = await this.prisma.careActivity.count({
      where: {
        groupId,
        activityType: {
          in: [ActivityType.MEMBER_JOINED, ActivityType.MEMBER_LEFT],
        },
      },
    });

    const recipientActivities = await this.prisma.careActivity.count({
      where: {
        groupId,
        activityType: ActivityType.HEALTH_UPDATE,
      },
    });

    const systemActivities = await this.prisma.careActivity.count({
      where: {
        groupId,
        activityType: {
          in: [ActivityType.MEDICATION_TAKEN, ActivityType.EMERGENCY_ALERT],
        },
      },
    });

    // Recent activities (last 24 hours)
    const yesterday = new Date(Date.now() - 24 * 60 * 60 * 1000);
    const recentActivities = await this.prisma.careActivity.count({
      where: {
        groupId,
        timestamp: { gte: yesterday },
      },
    });

    return {
      totalActivities,
      taskActivities,
      memberActivities,
      recipientActivities,
      systemActivities,
      recentActivities,
    };
  }

  async markAsRead(activityIds: string[], userId: string): Promise<void> {
    // This would typically involve a separate table for read status
    // For now, we'll implement this as a data field update
    const readByData = { [userId]: new Date().toISOString() };

    await this.prisma.careActivity.updateMany({
      where: {
        id: { in: activityIds },
      },
      data: {
        data: {
          readBy: readByData,
        },
      },
    });
  }

  async getUnreadCount(groupId: string, userId: string): Promise<number> {
    // This is a simplified implementation
    // In a real system, you'd have a separate read_status table
    const count = await this.prisma.careActivity.count({
      where: {
        groupId,
        memberId: { not: userId }, // Don't count user's own activities
        data: {
          path: ['readBy', userId],
          equals: Prisma.JsonNull,
        },
      },
    });

    return count;
  }

  // Time-based operations
  async findRecentActivities(
    groupId: string,
    hoursThreshold: number,
  ): Promise<CareActivityEntity[]> {
    const thresholdDate = new Date(
      Date.now() - hoursThreshold * 60 * 60 * 1000,
    );

    const data = await this.prisma.careActivity.findMany({
      where: {
        groupId,
        timestamp: { gte: thresholdDate },
      },
      orderBy: { timestamp: 'desc' },
    });

    return data.map((item) => CareActivityEntity.fromPrisma(item));
  }

  async findActivitiesInDateRange(
    groupId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<CareActivityEntity[]> {
    const data = await this.prisma.careActivity.findMany({
      where: {
        groupId,
        timestamp: {
          gte: startDate,
          lte: endDate,
        },
      },
      orderBy: { timestamp: 'desc' },
    });

    return data.map((item) => CareActivityEntity.fromPrisma(item));
  }

  async findTodaysActivities(groupId: string): Promise<CareActivityEntity[]> {
    const today = new Date();
    const startOfDay = new Date(
      today.getFullYear(),
      today.getMonth(),
      today.getDate(),
    );
    const endOfDay = new Date(
      today.getFullYear(),
      today.getMonth(),
      today.getDate(),
      23,
      59,
      59,
    );

    return this.findActivitiesInDateRange(groupId, startOfDay, endOfDay);
  }

  async findThisWeeksActivities(
    groupId: string,
  ): Promise<CareActivityEntity[]> {
    const today = new Date();
    const startOfWeek = new Date(
      today.getFullYear(),
      today.getMonth(),
      today.getDate() - today.getDay(),
    );
    const endOfWeek = new Date(
      today.getFullYear(),
      today.getMonth(),
      today.getDate() + (6 - today.getDay()),
      23,
      59,
      59,
    );

    return this.findActivitiesInDateRange(groupId, startOfWeek, endOfWeek);
  }

  // Related entity operations
  async findByTaskId(taskId: string): Promise<CareActivityEntity[]> {
    const data = await this.prisma.careActivity.findMany({
      where: {
        data: {
          path: ['taskId'],
          equals: taskId,
        },
      },
      orderBy: { timestamp: 'desc' },
    });

    return data.map((item) => CareActivityEntity.fromPrisma(item));
  }

  async findByRecipientId(recipientId: string): Promise<CareActivityEntity[]> {
    const data = await this.prisma.careActivity.findMany({
      where: {
        data: {
          path: ['recipientId'],
          equals: recipientId,
        },
      },
      orderBy: { timestamp: 'desc' },
    });

    return data.map((item) => CareActivityEntity.fromPrisma(item));
  }

  async findTaskCompletionActivities(
    groupId: string,
  ): Promise<CareActivityEntity[]> {
    return this.findByType(groupId, ActivityType.TASK_COMPLETED);
  }

  async findTaskAssignmentActivities(
    groupId: string,
  ): Promise<CareActivityEntity[]> {
    return this.findByType(groupId, ActivityType.TASK_CREATED);
  }

  // User activity operations
  async findUserActivitiesInGroup(
    groupId: string,
    userId: string,
  ): Promise<CareActivityEntity[]> {
    const data = await this.prisma.careActivity.findMany({
      where: {
        groupId,
        memberId: userId,
      },
      orderBy: { timestamp: 'desc' },
    });

    return data.map((item) => CareActivityEntity.fromPrisma(item));
  }

  async findMostActiveUsers(
    groupId: string,
    limit: number,
  ): Promise<MostActiveUser[]> {
    const result = await this.prisma.careActivity.groupBy({
      by: ['memberId'],
      where: { groupId },
      _count: { memberId: true },
      _max: { timestamp: true },
      orderBy: { _count: { memberId: 'desc' } },
      take: limit,
    });

    return result.map((item) => ({
      userId: item.memberId,
      activityCount: item._count.memberId,
      lastActivityAt: item._max.timestamp || new Date(),
    }));
  }

  // Search operations
  async searchActivities(
    groupId: string,
    searchTerm: string,
  ): Promise<CareActivityEntity[]> {
    const data = await this.prisma.careActivity.findMany({
      where: {
        groupId,
        description: {
          contains: searchTerm,
          mode: 'insensitive',
        },
      },
      orderBy: { timestamp: 'desc' },
    });

    return data.map((item) => CareActivityEntity.fromPrisma(item));
  }

  // Count operations
  async getActivityCount(groupId: string): Promise<number> {
    return this.prisma.careActivity.count({ where: { groupId } });
  }

  async getActivityCountByType(
    groupId: string,
    type: ActivityType,
  ): Promise<number> {
    return this.prisma.careActivity.count({
      where: { groupId, activityType: type },
    });
  }

  async getActivityCountByUser(
    groupId: string,
    userId: string,
  ): Promise<number> {
    return this.prisma.careActivity.count({
      where: { groupId, memberId: userId },
    });
  }

  async getRecentActivityCount(
    groupId: string,
    hoursThreshold: number,
  ): Promise<number> {
    const thresholdDate = new Date(
      Date.now() - hoursThreshold * 60 * 60 * 1000,
    );
    return this.prisma.careActivity.count({
      where: {
        groupId,
        timestamp: { gte: thresholdDate },
      },
    });
  }

  // Analytics operations
  async getActivityTrends(
    _groupId: string,
    _days: number,
  ): Promise<ActivityTrend[]> {
    // This would require complex aggregation queries
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  async getUserActivitySummary(
    groupId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<UserActivitySummary[]> {
    const result = await this.prisma.careActivity.groupBy({
      by: ['memberId'],
      where: {
        groupId,
        timestamp: {
          gte: startDate,
          lte: endDate,
        },
      },
      _count: { memberId: true },
      _max: { timestamp: true },
    });

    // Get activity types for each user with counts
    const summaries = await Promise.all(
      result.map(async (item) => {
        const activityTypeCounts = await this.prisma.careActivity.groupBy({
          by: ['activityType'],
          where: {
            groupId,
            memberId: item.memberId,
            timestamp: {
              gte: startDate,
              lte: endDate,
            },
          },
          _count: { activityType: true },
        });

        return {
          userId: item.memberId,
          activityCount: item._count.memberId,
          lastActivityAt: item._max.timestamp || new Date(),
          activityTypes: activityTypeCounts.map((typeCount) => ({
            type: typeCount.activityType,
            count: typeCount._count.activityType,
          })),
        };
      }),
    );

    return summaries;
  }

  // Cleanup operations
  async deleteOldActivities(
    groupId: string,
    olderThanDays: number,
  ): Promise<number> {
    const cutoffDate = new Date(
      Date.now() - olderThanDays * 24 * 60 * 60 * 1000,
    );

    const result = await this.prisma.careActivity.deleteMany({
      where: {
        groupId,
        timestamp: { lt: cutoffDate },
      },
    });

    return result.count;
  }

  async deleteActivitiesByType(
    groupId: string,
    type: ActivityType,
  ): Promise<number> {
    const result = await this.prisma.careActivity.deleteMany({
      where: {
        groupId,
        activityType: type,
      },
    });

    return result.count;
  }

  // Bulk operations
  async createBulkActivities(
    activities: CareActivityEntity[],
  ): Promise<CareActivityEntity[]> {
    const prismaData = activities.map((activity) => ({
      groupId: activity.groupId,
      memberId: activity.memberId,
      activityType: activity.activityType,
      description: activity.description,
      data: (activity.data as any) || {},
      timestamp: activity.timestamp,
    }));

    await this.prisma.careActivity.createMany({
      data: prismaData,
    });

    // Since createMany doesn't return the created records with IDs,
    // we'll need to fetch them back. This is a simplified approach.
    const createdActivities = await this.prisma.careActivity.findMany({
      where: {
        groupId: { in: activities.map((a) => a.groupId) },
        timestamp: {
          gte: new Date(
            Math.min(...activities.map((a) => a.timestamp.getTime())),
          ),
          lte: new Date(
            Math.max(...activities.map((a) => a.timestamp.getTime())),
          ),
        },
      },
      orderBy: { timestamp: 'desc' },
      take: activities.length,
    });

    return createdActivities.map((item) => CareActivityEntity.fromPrisma(item));
  }
}
