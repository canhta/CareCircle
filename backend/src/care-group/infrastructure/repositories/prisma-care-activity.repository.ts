import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { CareActivityRepository } from '../../domain/repositories/care-activity.repository';
import { CareActivityEntity } from '../../domain/entities/care-activity.entity';
import { ActivityType } from '@prisma/client';

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
    filters?: {
      type?: ActivityType;
      userId?: string;
      fromDate?: Date;
      toDate?: Date;
      limit?: number;
    },
  ): Promise<CareActivityEntity[]> {
    const where: any = { groupId };

    if (filters?.type) {
      where.type = filters.type;
    }
    if (filters?.userId) {
      where.userId = filters.userId;
    }
    if (filters?.fromDate || filters?.toDate) {
      where.createdAt = {};
      if (filters.fromDate) {
        where.createdAt.gte = filters.fromDate;
      }
      if (filters.toDate) {
        where.createdAt.lte = filters.toDate;
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

  async findByUserId(
    userId: string,
    filters?: {
      type?: ActivityType;
      fromDate?: Date;
      toDate?: Date;
      limit?: number;
    },
  ): Promise<CareActivityEntity[]> {
    const where: any = { userId };

    if (filters?.type) {
      where.type = filters.type;
    }
    if (filters?.fromDate || filters?.toDate) {
      where.createdAt = {};
      if (filters.fromDate) {
        where.createdAt.gte = filters.fromDate;
      }
      if (filters.toDate) {
        where.createdAt.lte = filters.toDate;
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

  async getActivityStatistics(
    groupId: string,
    fromDate?: Date,
    toDate?: Date,
  ): Promise<{
    totalActivities: number;
    activitiesByType: Record<string, number>;
    activitiesByUser: Record<string, number>;
    dailyActivityCount: Record<string, number>;
  }> {
    const where: any = { groupId };

    if (fromDate || toDate) {
      where.createdAt = {};
      if (fromDate) {
        where.createdAt.gte = fromDate;
      }
      if (toDate) {
        where.createdAt.lte = toDate;
      }
    }

    // Get total count
    const totalActivities = await this.prisma.careActivity.count({ where });

    // Get activities by type
    const activitiesByTypeRaw = await this.prisma.careActivity.groupBy({
      by: ['type'],
      where,
      _count: { type: true },
    });

    const activitiesByType: Record<string, number> = {};
    activitiesByTypeRaw.forEach((item) => {
      activitiesByType[item.type] = item._count.type;
    });

    // Get activities by user
    const activitiesByUserRaw = await this.prisma.careActivity.groupBy({
      by: ['userId'],
      where,
      _count: { userId: true },
    });

    const activitiesByUser: Record<string, number> = {};
    activitiesByUserRaw.forEach((item) => {
      activitiesByUser[item.userId] = item._count.userId;
    });

    // Get daily activity count (simplified - just return empty for now)
    const dailyActivityCount: Record<string, number> = {};

    return {
      totalActivities,
      activitiesByType,
      activitiesByUser,
      dailyActivityCount,
    };
  }

  async markAsRead(activityIds: string[], userId: string): Promise<void> {
    // This would typically involve a separate table for read status
    // For now, we'll implement this as a metadata update
    await this.prisma.careActivity.updateMany({
      where: {
        id: { in: activityIds },
      },
      data: {
        metadata: {
          readBy: {
            [userId]: new Date().toISOString(),
          },
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
        userId: { not: userId }, // Don't count user's own activities
        metadata: {
          path: ['readBy', userId],
          equals: null,
        },
      },
    });

    return count;
  }
}
