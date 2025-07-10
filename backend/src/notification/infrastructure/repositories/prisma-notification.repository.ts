import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { NotificationRepository } from '../../domain/repositories/notification.repository';
import { Notification } from '../../domain/entities/notification.entity';
import {
  NotificationType,
  NotificationPriority,
  NotificationStatus,
  Notification as PrismaNotification,
} from '@prisma/client';

@Injectable()
export class PrismaNotificationRepository extends NotificationRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async create(notification: Notification): Promise<Notification> {
    const data = await this.prisma.notification.create({
      data: {
        userId: notification.userId,
        title: notification.title,
        message: notification.message,
        type: notification.type,
        priority: notification.priority,
        channel: notification.channel,
        status: notification.status,
        scheduledFor: notification.scheduledFor,
        expiresAt: notification.expiresAt,
        context: notification.context || {},
        createdAt: notification.createdAt,
      },
    });

    return this.mapToEntity(data);
  }

  async findById(id: string): Promise<Notification | null> {
    const data = await this.prisma.notification.findUnique({
      where: { id },
    });

    return data ? this.mapToEntity(data) : null;
  }

  async findByUserId(
    userId: string,
    limit: number = 50,
    offset: number = 0,
  ): Promise<Notification[]> {
    const data = await this.prisma.notification.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: limit,
      skip: offset,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async update(
    id: string,
    updates: Partial<Notification>,
  ): Promise<Notification> {
    const data = await this.prisma.notification.update({
      where: { id },
      data: {
        ...(updates.title && { title: updates.title }),
        ...(updates.message && { message: updates.message }),
        ...(updates.type && { type: updates.type }),
        ...(updates.priority && { priority: updates.priority }),
        ...(updates.channel && { channel: updates.channel }),
        ...(updates.status && { status: updates.status }),
        ...(updates.scheduledFor !== undefined && {
          scheduledFor: updates.scheduledFor,
        }),
        ...(updates.deliveredAt !== undefined && {
          deliveredAt: updates.deliveredAt,
        }),
        ...(updates.readAt !== undefined && { readAt: updates.readAt }),
        ...(updates.expiresAt !== undefined && {
          expiresAt: updates.expiresAt,
        }),
        ...(updates.context && { context: updates.context }),
      },
    });

    return this.mapToEntity(data);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.notification.delete({
      where: { id },
    });
  }

  async markAsDelivered(id: string): Promise<Notification> {
    const data = await this.prisma.notification.update({
      where: { id },
      data: {
        status: NotificationStatus.DELIVERED,
        deliveredAt: new Date(),
      },
    });

    return this.mapToEntity(data);
  }

  async markAsRead(id: string): Promise<Notification> {
    const data = await this.prisma.notification.update({
      where: { id },
      data: {
        status: NotificationStatus.READ,
        readAt: new Date(),
      },
    });

    return this.mapToEntity(data);
  }

  async markAsFailed(id: string): Promise<Notification> {
    const data = await this.prisma.notification.update({
      where: { id },
      data: {
        status: NotificationStatus.FAILED,
      },
    });

    return this.mapToEntity(data);
  }

  async findByStatus(
    userId: string,
    status: NotificationStatus,
  ): Promise<Notification[]> {
    const data = await this.prisma.notification.findMany({
      where: { userId, status },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByType(
    userId: string,
    type: NotificationType,
  ): Promise<Notification[]> {
    const data = await this.prisma.notification.findMany({
      where: { userId, type },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByPriority(
    userId: string,
    priority: NotificationPriority,
  ): Promise<Notification[]> {
    const data = await this.prisma.notification.findMany({
      where: { userId, priority },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findUnread(userId: string): Promise<Notification[]> {
    const data = await this.prisma.notification.findMany({
      where: {
        userId,
        status: {
          in: [NotificationStatus.PENDING, NotificationStatus.DELIVERED],
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findScheduled(): Promise<Notification[]> {
    const data = await this.prisma.notification.findMany({
      where: {
        status: NotificationStatus.PENDING,
        scheduledFor: {
          lte: new Date(),
        },
      },
      orderBy: { scheduledFor: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findExpired(): Promise<Notification[]> {
    const data = await this.prisma.notification.findMany({
      where: {
        expiresAt: {
          lte: new Date(),
        },
        status: {
          not: NotificationStatus.EXPIRED,
        },
      },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async getUnreadCount(userId: string): Promise<number> {
    return this.prisma.notification.count({
      where: {
        userId,
        status: {
          in: [NotificationStatus.PENDING, NotificationStatus.DELIVERED],
        },
      },
    });
  }

  async getTotalCount(userId: string): Promise<number> {
    return this.prisma.notification.count({
      where: { userId },
    });
  }

  async deleteExpired(): Promise<number> {
    const result = await this.prisma.notification.deleteMany({
      where: {
        expiresAt: {
          lte: new Date(),
        },
      },
    });

    return result.count;
  }

  async deleteOldNotifications(olderThanDays: number): Promise<number> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - olderThanDays);

    const result = await this.prisma.notification.deleteMany({
      where: {
        createdAt: {
          lte: cutoffDate,
        },
        status: {
          in: [NotificationStatus.READ, NotificationStatus.FAILED],
        },
      },
    });

    return result.count;
  }

  private mapToEntity(data: PrismaNotification): Notification {
    return new Notification(
      data.id,
      data.userId,
      data.title,
      data.message,
      data.type,
      data.priority,
      data.channel,
      data.status,
      data.createdAt,
      data.scheduledFor || undefined,
      data.deliveredAt || undefined,
      data.readAt || undefined,
      data.expiresAt || undefined,
      data.context as Record<string, any>,
    );
  }
}
