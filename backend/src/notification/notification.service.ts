import { Injectable, Logger } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { InjectQueue } from '@nestjs/bullmq';
import { Queue } from 'bullmq';
import { PrismaService } from '../prisma/prisma.service';
import {
  NotificationType,
  NotificationChannel,
  NotificationPriority,
  ReminderStatus,
  Notification,
} from '@prisma/client';

export interface NotificationPayload {
  userId: string;
  title: string;
  message: string;
  type: NotificationType;
  channels: NotificationChannel[];
  priority?: NotificationPriority;
  actionUrl?: string;
  scheduledFor?: Date;
  templateData?: Record<string, any>;
}

export interface ReminderData {
  id: string;
  prescriptionId: string;
  userId: string;
  medicationName: string;
  dosage: string;
  scheduledAt: Date;
  frequency: string;
}

@Injectable()
export class NotificationService {
  private readonly logger = new Logger(NotificationService.name);

  constructor(
    private readonly prisma: PrismaService,
    @InjectQueue('notification') private notificationQueue: Queue,
    @InjectQueue('reminder') private reminderQueue: Queue,
  ) {}

  /**
   * Send immediate notification
   */
  async sendNotification(payload: NotificationPayload): Promise<Notification> {
    const notification = await this.prisma.notification.create({
      data: {
        userId: payload.userId,
        title: payload.title,
        message: payload.message,
        type: payload.type,
        channel: payload.channels,
        priority: payload.priority || NotificationPriority.NORMAL,
        actionUrl: payload.actionUrl,
      },
    });

    // Queue for immediate delivery
    await this.notificationQueue.add(
      'send-notification',
      {
        notificationId: notification.id,
        ...payload,
      },
      {
        priority: this.getPriorityValue(
          payload.priority || NotificationPriority.NORMAL,
        ),
        attempts: 3,
        backoff: {
          type: 'exponential',
          delay: 2000,
        },
      },
    );

    this.logger.debug(
      `Notification queued for user ${payload.userId}: ${payload.title}`,
    );
    return notification;
  }

  /**
   * Schedule notification for later delivery
   */
  async scheduleNotification(
    payload: NotificationPayload,
  ): Promise<Notification> {
    if (!payload.scheduledFor) {
      throw new Error('Scheduled notifications must have a scheduledFor date');
    }

    const notification = await this.prisma.notification.create({
      data: {
        userId: payload.userId,
        title: payload.title,
        message: payload.message,
        type: payload.type,
        channel: payload.channels,
        priority: payload.priority || NotificationPriority.NORMAL,
        actionUrl: payload.actionUrl,
      },
    });

    // Queue for scheduled delivery
    await this.notificationQueue.add(
      'send-notification',
      {
        notificationId: notification.id,
        ...payload,
      },
      {
        delay: payload.scheduledFor.getTime() - Date.now(),
        priority: this.getPriorityValue(
          payload.priority || NotificationPriority.NORMAL,
        ),
        attempts: 3,
        backoff: {
          type: 'exponential',
          delay: 2000,
        },
      },
    );

    this.logger.debug(
      `Notification scheduled for ${payload.scheduledFor.toISOString()}: ${payload.title}`,
    );
    return notification;
  }

  /**
   * Send medication reminder
   */
  async sendMedicationReminder(reminderData: ReminderData): Promise<void> {
    const user = await this.prisma.user.findUnique({
      where: { id: reminderData.userId },
    });

    if (!user) {
      this.logger.error(`User not found: ${reminderData.userId}`);
      return;
    }

    const payload: NotificationPayload = {
      userId: reminderData.userId,
      title: `💊 Time for your medication`,
      message: `Don't forget to take your ${reminderData.medicationName} (${reminderData.dosage})`,
      type: NotificationType.MEDICATION_REMINDER,
      channels: [NotificationChannel.PUSH, NotificationChannel.IN_APP],
      priority: NotificationPriority.HIGH,
      actionUrl: `/medications/${reminderData.prescriptionId}`,
      templateData: {
        medicationName: reminderData.medicationName,
        dosage: reminderData.dosage,
        frequency: reminderData.frequency,
        userName: user.firstName,
      },
    };

    await this.sendNotification(payload);

    // Update reminder status
    await this.prisma.reminder.update({
      where: { id: reminderData.id },
      data: {
        status: ReminderStatus.SENT,
        sentAt: new Date(),
      },
    });
  }

  /**
   * Send health check-in reminder
   */
  async sendCheckInReminder(userId: string): Promise<void> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      this.logger.error(`User not found: ${userId}`);
      return;
    }

    const payload: NotificationPayload = {
      userId,
      title: `🏥 Daily Health Check-in`,
      message: `Hi ${user.firstName}, how are you feeling today? Take a moment to log your health status.`,
      type: NotificationType.CHECK_IN_REMINDER,
      channels: [NotificationChannel.PUSH, NotificationChannel.IN_APP],
      priority: NotificationPriority.NORMAL,
      actionUrl: '/check-in',
      templateData: {
        userName: user.firstName,
      },
    };

    await this.sendNotification(payload);
  }

  /**
   * Send AI-powered health insight
   */
  async sendHealthInsight(
    userId: string,
    insight: string,
    severity: 'low' | 'medium' | 'high',
  ): Promise<void> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      this.logger.error(`User not found: ${userId}`);
      return;
    }

    const priorityMap = {
      low: NotificationPriority.LOW,
      medium: NotificationPriority.NORMAL,
      high: NotificationPriority.HIGH,
    };

    const payload: NotificationPayload = {
      userId,
      title: `🤖 AI Health Insight`,
      message: insight,
      type: NotificationType.AI_INSIGHT,
      channels: [NotificationChannel.PUSH, NotificationChannel.IN_APP],
      priority: priorityMap[severity],
      actionUrl: '/insights',
      templateData: {
        userName: user.firstName,
        insight,
        severity,
      },
    };

    await this.sendNotification(payload);
  }

  /**
   * Mark notification as read
   */
  async markAsRead(notificationId: string, userId: string): Promise<void> {
    await this.prisma.notification.updateMany({
      where: {
        id: notificationId,
        userId,
        readAt: null,
      },
      data: {
        readAt: new Date(),
      },
    });
  }

  /**
   * Get user notifications with pagination
   */
  async getUserNotifications(
    userId: string,
    page: number = 1,
    limit: number = 20,
    unreadOnly: boolean = false,
  ) {
    const skip = (page - 1) * limit;

    const where = {
      userId,
      ...(unreadOnly && { readAt: null }),
    };

    const [notifications, total] = await Promise.all([
      this.prisma.notification.findMany({
        where,
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      this.prisma.notification.count({ where }),
    ]);

    return {
      notifications,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    };
  }

  /**
   * Get notification preferences for user
   */
  async getNotificationPreferences(userId: string) {
    // This would typically come from a user preferences table
    // For now, return default preferences
    return {
      medicationReminders: true,
      checkInReminders: true,
      aiInsights: true,
      careGroupUpdates: true,
      channels: {
        push: true,
        email: true,
        sms: false,
        inApp: true,
      },
      quietHours: {
        enabled: true,
        start: '22:00',
        end: '08:00',
      },
    };
  }

  /**
   * Check if notification should be sent based on user preferences and quiet hours
   */
  async shouldSendNotification(
    userId: string,
    type: NotificationType,
    scheduledFor?: Date,
  ): Promise<boolean> {
    const preferences = await this.getNotificationPreferences(userId);
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) return false;

    // Check type-specific preferences
    const typePreferences = {
      [NotificationType.MEDICATION_REMINDER]: preferences.medicationReminders,
      [NotificationType.CHECK_IN_REMINDER]: preferences.checkInReminders,
      [NotificationType.AI_INSIGHT]: preferences.aiInsights,
      [NotificationType.CARE_GROUP_UPDATE]: preferences.careGroupUpdates,
      [NotificationType.HEALTH_ALERT]: true, // Always send health alerts
      [NotificationType.SYSTEM_NOTIFICATION]: true, // Always send system notifications
    };

    if (!typePreferences[type]) return false;

    // Check quiet hours
    if (preferences.quietHours.enabled && scheduledFor) {
      const userTime = new Date(
        scheduledFor.toLocaleString('en-US', { timeZone: user.timezone }),
      );
      const hour = userTime.getHours();
      const minute = userTime.getMinutes();
      const currentTime = hour * 60 + minute;

      const [startHour, startMinute] = preferences.quietHours.start
        .split(':')
        .map(Number);
      const [endHour, endMinute] = preferences.quietHours.end
        .split(':')
        .map(Number);
      const quietStart = startHour * 60 + startMinute;
      const quietEnd = endHour * 60 + endMinute;

      // Handle quiet hours that span midnight
      if (quietStart > quietEnd) {
        if (currentTime >= quietStart || currentTime <= quietEnd) {
          return false;
        }
      } else {
        if (currentTime >= quietStart && currentTime <= quietEnd) {
          return false;
        }
      }
    }

    return true;
  }

  /**
   * Cron job to process pending medication reminders
   */
  @Cron('0 * * * * *') // Every minute
  async processPendingReminders(): Promise<void> {
    const now = new Date();
    const reminders = await this.prisma.reminder.findMany({
      where: {
        status: ReminderStatus.PENDING,
        scheduledAt: {
          lte: now,
        },
      },
      include: {
        prescription: {
          include: {
            user: true,
          },
        },
      },
    });

    for (const reminder of reminders) {
      try {
        const reminderData: ReminderData = {
          id: reminder.id,
          prescriptionId: reminder.prescriptionId,
          userId: reminder.prescription.userId,
          medicationName: reminder.prescription.medicationName,
          dosage: reminder.prescription.dosage,
          scheduledAt: reminder.scheduledAt,
          frequency: reminder.frequency || 'daily',
        };

        await this.sendMedicationReminder(reminderData);
        this.logger.debug(`Processed reminder ${reminder.id}`);
      } catch (error) {
        this.logger.error(`Failed to process reminder ${reminder.id}:`, error);

        // Update retry count
        await this.prisma.reminder.update({
          where: { id: reminder.id },
          data: {
            retryCount: reminder.retryCount + 1,
            status:
              reminder.retryCount + 1 >= reminder.maxRetries
                ? ReminderStatus.FAILED
                : ReminderStatus.PENDING,
          },
        });
      }
    }
  }

  /**
   * Cron job to send daily check-in reminders
   */
  @Cron('0 0 9 * * *') // Every day at 9 AM
  async sendDailyCheckInReminders(): Promise<void> {
    const users = await this.prisma.user.findMany({
      where: {
        isActive: true,
      },
      select: {
        id: true,
        timezone: true,
      },
    });

    for (const user of users) {
      try {
        // Check if user wants check-in reminders
        const shouldSend = await this.shouldSendNotification(
          user.id,
          NotificationType.CHECK_IN_REMINDER,
          new Date(),
        );

        if (shouldSend) {
          await this.sendCheckInReminder(user.id);
        }
      } catch (error) {
        this.logger.error(
          `Failed to send check-in reminder to user ${user.id}:`,
          error,
        );
      }
    }
  }

  /**
   * Clean up old notifications
   */
  @Cron('0 0 0 * * 0') // Every Sunday at midnight
  async cleanupOldNotifications(): Promise<void> {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const result = await this.prisma.notification.deleteMany({
      where: {
        createdAt: {
          lt: thirtyDaysAgo,
        },
        readAt: {
          not: null,
        },
      },
    });

    this.logger.log(`Cleaned up ${result.count} old notifications`);
  }

  /**
   * Convert priority enum to numeric value for queue priority
   */
  private getPriorityValue(priority: NotificationPriority): number {
    const priorityMap = {
      [NotificationPriority.LOW]: 10,
      [NotificationPriority.NORMAL]: 5,
      [NotificationPriority.HIGH]: 2,
      [NotificationPriority.CRITICAL]: 1,
    };
    return priorityMap[priority];
  }
}
