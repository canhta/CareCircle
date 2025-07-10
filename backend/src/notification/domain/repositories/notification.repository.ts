import { Notification } from '../entities/notification.entity';
import {
  NotificationType,
  NotificationPriority,
  NotificationStatus,
} from '@prisma/client';

export abstract class NotificationRepository {
  abstract create(notification: Notification): Promise<Notification>;
  abstract findById(id: string): Promise<Notification | null>;
  abstract findByUserId(
    userId: string,
    limit?: number,
    offset?: number,
  ): Promise<Notification[]>;
  abstract update(
    id: string,
    updates: Partial<Notification>,
  ): Promise<Notification>;
  abstract delete(id: string): Promise<void>;

  // Status operations
  abstract markAsDelivered(id: string): Promise<Notification>;
  abstract markAsRead(id: string): Promise<Notification>;
  abstract markAsFailed(id: string): Promise<Notification>;

  // Query operations
  abstract findByStatus(
    userId: string,
    status: NotificationStatus,
  ): Promise<Notification[]>;
  abstract findByType(
    userId: string,
    type: NotificationType,
  ): Promise<Notification[]>;
  abstract findByPriority(
    userId: string,
    priority: NotificationPriority,
  ): Promise<Notification[]>;
  abstract findUnread(userId: string): Promise<Notification[]>;
  abstract findScheduled(): Promise<Notification[]>;
  abstract findExpired(): Promise<Notification[]>;

  // Count operations
  abstract getUnreadCount(userId: string): Promise<number>;
  abstract getTotalCount(userId: string): Promise<number>;

  // Cleanup operations
  abstract deleteExpired(): Promise<number>;
  abstract deleteOldNotifications(olderThanDays: number): Promise<number>;
}
