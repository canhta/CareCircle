import { Injectable, NotFoundException } from '@nestjs/common';
import { NotificationRepository } from '../../domain/repositories/notification.repository';
import { Notification } from '../../domain/entities/notification.entity';
import {
  NotificationType,
  NotificationPriority,
  NotificationChannel,
} from '@prisma/client';

export interface CreateNotificationDto {
  userId: string;
  title: string;
  message: string;
  type: NotificationType;
  priority?: NotificationPriority;
  channel?: NotificationChannel;
  scheduledFor?: Date;
  expiresAt?: Date;
  context?: Record<string, any>;
}

export interface NotificationSummary {
  total: number;
  unread: number;
  byType: Record<NotificationType, number>;
  byPriority: Record<NotificationPriority, number>;
}

@Injectable()
export class NotificationService {
  constructor(
    private readonly notificationRepository: NotificationRepository,
  ) {}

  async createNotification(data: CreateNotificationDto): Promise<Notification> {
    const notification = Notification.create(data);
    return this.notificationRepository.create(notification);
  }

  async findById(id: string): Promise<Notification> {
    const notification = await this.notificationRepository.findById(id);
    if (!notification) {
      throw new NotFoundException(`Notification with ID ${id} not found`);
    }
    return notification;
  }

  async findByUserId(
    userId: string,
    limit?: number,
    offset?: number,
  ): Promise<Notification[]> {
    return this.notificationRepository.findByUserId(userId, limit, offset);
  }

  async markAsRead(id: string): Promise<Notification> {
    const _notification = await this.findById(id);
    return this.notificationRepository.markAsRead(id);
  }

  async markAsDelivered(id: string): Promise<Notification> {
    const _notification = await this.findById(id);
    return this.notificationRepository.markAsDelivered(id);
  }

  async markAsFailed(id: string): Promise<Notification> {
    const _notification = await this.findById(id);
    return this.notificationRepository.markAsFailed(id);
  }

  async findUnread(userId: string): Promise<Notification[]> {
    return this.notificationRepository.findUnread(userId);
  }

  async findByType(
    userId: string,
    type: NotificationType,
  ): Promise<Notification[]> {
    return this.notificationRepository.findByType(userId, type);
  }

  async findByPriority(
    userId: string,
    priority: NotificationPriority,
  ): Promise<Notification[]> {
    return this.notificationRepository.findByPriority(userId, priority);
  }

  async getNotificationSummary(userId: string): Promise<NotificationSummary> {
    const [total, unread, allNotifications] = await Promise.all([
      this.notificationRepository.getTotalCount(userId),
      this.notificationRepository.getUnreadCount(userId),
      this.notificationRepository.findByUserId(userId),
    ]);

    const byType: Record<NotificationType, number> = {
      HEALTH_ALERT: 0,
      MEDICATION_REMINDER: 0,
      APPOINTMENT_REMINDER: 0,
      TASK_REMINDER: 0,
      CARE_GROUP_UPDATE: 0,
      SYSTEM_NOTIFICATION: 0,
      EMERGENCY_ALERT: 0,
    };

    const byPriority: Record<NotificationPriority, number> = {
      LOW: 0,
      NORMAL: 0,
      HIGH: 0,
      URGENT: 0,
    };

    allNotifications.forEach((notification) => {
      byType[notification.type]++;
      byPriority[notification.priority]++;
    });

    return {
      total,
      unread,
      byType,
      byPriority,
    };
  }

  async deleteNotification(id: string): Promise<void> {
    const _notification = await this.findById(id);
    await this.notificationRepository.delete(id);
  }

  async processScheduledNotifications(): Promise<Notification[]> {
    const scheduledNotifications =
      await this.notificationRepository.findScheduled();

    const processedNotifications: Notification[] = [];

    for (const notification of scheduledNotifications) {
      try {
        // Mark as delivered (in a real implementation, this would trigger actual delivery)
        const delivered = await this.notificationRepository.markAsDelivered(
          notification.id,
        );
        processedNotifications.push(delivered);
      } catch (_error) {
        // Mark as failed if delivery fails
        await this.notificationRepository.markAsFailed(notification.id);
      }
    }

    return processedNotifications;
  }

  async cleanupExpiredNotifications(): Promise<number> {
    return this.notificationRepository.deleteExpired();
  }

  async cleanupOldNotifications(olderThanDays: number = 30): Promise<number> {
    return this.notificationRepository.deleteOldNotifications(olderThanDays);
  }

  // Healthcare-specific notification helpers
  async createHealthAlert(
    userId: string,
    title: string,
    message: string,
    priority: NotificationPriority = NotificationPriority.HIGH,
    context?: Record<string, any>,
  ): Promise<Notification> {
    return this.createNotification({
      userId,
      title,
      message,
      type: NotificationType.HEALTH_ALERT,
      priority,
      context,
    });
  }

  async createMedicationReminder(
    userId: string,
    medicationName: string,
    dosage: string,
    scheduledFor: Date,
    context?: Record<string, any>,
  ): Promise<Notification> {
    return this.createNotification({
      userId,
      title: 'Medication Reminder',
      message: `Time to take ${medicationName} - ${dosage}`,
      type: NotificationType.MEDICATION_REMINDER,
      priority: NotificationPriority.HIGH,
      scheduledFor,
      context,
    });
  }

  async createEmergencyAlert(
    userId: string,
    title: string,
    message: string,
    context?: Record<string, any>,
  ): Promise<Notification> {
    return this.createNotification({
      userId,
      title,
      message,
      type: NotificationType.EMERGENCY_ALERT,
      priority: NotificationPriority.URGENT,
      context,
    });
  }
}
