import { Injectable, Logger } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { InjectQueue } from '@nestjs/bullmq';
import { Queue } from 'bullmq';
import { PrismaService } from '../prisma/prisma.service';
import { NotificationTemplateService } from './notification-template.service';
import { NotificationAuditLoggingService } from './audit-logging.service';
import {
  TemplateContext,
  TemplateRenderingService,
} from './template-rendering.service';
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
    private readonly templateService: NotificationTemplateService,
    private readonly templateRenderer: TemplateRenderingService,
    private readonly auditLoggingService: NotificationAuditLoggingService,
    @InjectQueue('notification') private notificationQueue: Queue,
    @InjectQueue('reminder') private reminderQueue: Queue,
  ) {}

  /**
   * Send immediate notification
   */
  async sendNotification(payload: NotificationPayload): Promise<Notification> {
    const startTime = Date.now();
    
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

    // Log notification creation
    const creationTime = Date.now() - startTime;
    await this.auditLoggingService.logNotificationCreated(
      notification.id,
      payload.channels,
      creationTime,
    );

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

    // Log notification queued
    await this.auditLoggingService.logNotificationQueued(
      notification.id,
      payload.channels,
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

  /**
   * Send templated notification
   */
  async sendTemplatedNotification(
    userId: string,
    templateName: string,
    context: TemplateContext,
    options?: {
      scheduledFor?: Date;
      actionUrl?: string;
      priority?: NotificationPriority;
      channels?: NotificationChannel[];
    },
  ): Promise<Notification> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new Error(`User not found: ${userId}`);
    }

    // Create personalized context
    const personalizedContext = this.templateRenderer.createUserContext(
      user,
      context,
    );

    // Render template
    const rendered = await this.templateService.renderTemplateByName(
      templateName,
      personalizedContext,
    );

    // Create notification payload
    const payload: NotificationPayload = {
      userId,
      title: rendered.title,
      message: rendered.message,
      type: NotificationType.SYSTEM_NOTIFICATION, // Default type
      channels: options?.channels || rendered.channels,
      priority: options?.priority || rendered.priority,
      actionUrl: options?.actionUrl,
      scheduledFor: options?.scheduledFor,
      templateData: context,
    };

    // Send or schedule the notification
    if (options?.scheduledFor) {
      return this.scheduleNotification(payload);
    } else {
      return this.sendNotification(payload);
    }
  }

  /**
   * Send templated medication reminder
   */
  async sendTemplatedMedicationReminder(
    reminderData: ReminderData,
  ): Promise<void> {
    const user = await this.prisma.user.findUnique({
      where: { id: reminderData.userId },
    });

    if (!user) {
      this.logger.error(`User not found: ${reminderData.userId}`);
      return;
    }

    // Get the best template for medication reminders
    const template = await this.templateService.getBestTemplate(
      NotificationType.MEDICATION_REMINDER,
      { language: 'en' }, // Default to English for now
    );

    if (!template) {
      // Fallback to the original method if no template is found
      await this.sendMedicationReminder(reminderData);
      return;
    }

    // Create medication context
    const prescription = await this.prisma.prescription.findUnique({
      where: { id: reminderData.prescriptionId },
    });

    if (!prescription) {
      this.logger.error(
        `Prescription not found: ${reminderData.prescriptionId}`,
      );
      return;
    }

    const context = this.templateService.createMedicationContext(
      user,
      prescription,
      {
        scheduledTime: reminderData.scheduledAt.toLocaleTimeString(),
        isOverdue: reminderData.scheduledAt < new Date(),
      },
    );

    // Render template
    const rendered = await this.templateService.renderTemplate(
      template.id,
      context,
    );

    // Send notification
    const payload: NotificationPayload = {
      userId: reminderData.userId,
      title: rendered.title,
      message: rendered.message,
      type: NotificationType.MEDICATION_REMINDER,
      channels: rendered.channels,
      priority: rendered.priority,
      actionUrl: `/medications/${reminderData.prescriptionId}`,
      templateData: context,
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
   * Send templated care group notification
   */
  async sendTemplatedCareGroupNotification(
    userId: string,
    careGroupId: string,
    context: TemplateContext,
  ): Promise<void> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    const careGroup = await this.prisma.careGroup.findUnique({
      where: { id: careGroupId },
      include: {
        members: true,
      },
    });

    if (!user || !careGroup) {
      this.logger.error(
        `User or care group not found: ${userId}, ${careGroupId}`,
      );
      return;
    }

    // Get the best template for care group notifications
    const template = await this.templateService.getBestTemplate(
      NotificationType.CARE_GROUP_UPDATE,
      { language: 'en' }, // Default to English for now
    );

    if (!template) {
      // Fallback notification
      await this.sendNotification({
        userId,
        title: 'Care Group Update',
        message: 'There is an update in your care group.',
        type: NotificationType.CARE_GROUP_UPDATE,
        channels: [NotificationChannel.PUSH, NotificationChannel.IN_APP],
        priority: NotificationPriority.NORMAL,
        actionUrl: `/care-groups/${careGroupId}`,
        templateData: context,
      });
      return;
    }

    // Create care group context
    const careGroupContext = this.templateService.createCareGroupContext(
      user,
      careGroup,
      context,
    );

    // Render template
    const rendered = await this.templateService.renderTemplate(
      template.id,
      careGroupContext,
    );

    // Send notification
    const payload: NotificationPayload = {
      userId,
      title: rendered.title,
      message: rendered.message,
      type: NotificationType.CARE_GROUP_UPDATE,
      channels: rendered.channels,
      priority: rendered.priority,
      actionUrl: `/care-groups/${careGroupId}`,
      templateData: careGroupContext,
    };

    await this.sendNotification(payload);
  }

  /**
   * Enhanced cron job to process BullMQ scheduled notifications
   * This works alongside the BullMQ repeatable jobs
   */
  @Cron('0 */5 * * * *') // Every 5 minutes
  async processScheduledNotifications(): Promise<void> {
    try {
      // This will be handled by BullMQ processors, but we can add monitoring here
      const waitingJobs = await this.notificationQueue.getWaiting();
      const delayedJobs = await this.notificationQueue.getDelayed();

      this.logger.debug(
        `Queue status: ${waitingJobs.length} waiting, ${delayedJobs.length} delayed`,
      );

      // Check for stuck jobs and retry if needed
      const stuckJobs = waitingJobs.filter(
        (job) => job.timestamp && Date.now() - job.timestamp > 300000, // 5 minutes
      );

      for (const stuckJob of stuckJobs) {
        this.logger.warn(`Retrying stuck job: ${stuckJob.id}`);
        await stuckJob.retry();
      }
    } catch (error) {
      this.logger.error('Error processing scheduled notifications:', error);
    }
  }

  /**
   * Cron job to clean up completed and failed jobs
   */
  @Cron('0 0 3 * * *') // Every day at 3 AM
  async cleanupOldJobs(): Promise<void> {
    try {
      // Clean up completed jobs older than 7 days
      await this.notificationQueue.clean(
        7 * 24 * 60 * 60 * 1000,
        10,
        'completed',
      );
      // Clean up failed jobs older than 30 days
      await this.notificationQueue.clean(
        30 * 24 * 60 * 60 * 1000,
        50,
        'failed',
      );

      await this.reminderQueue.clean(7 * 24 * 60 * 60 * 1000, 10, 'completed');
      await this.reminderQueue.clean(30 * 24 * 60 * 60 * 1000, 50, 'failed');

      this.logger.log('Cleaned up old notification jobs');
    } catch (error) {
      this.logger.error('Error cleaning up old jobs:', error);
    }
  }

  /**
   * Cron job to sync user schedules with their prescriptions
   * This ensures medication reminders are updated when prescriptions change
   */
  @Cron('0 0 2 * * *') // Every day at 2 AM
  async syncMedicationSchedules(): Promise<void> {
    try {
      const activePrescriptions = await this.prisma.prescription.findMany({
        where: {
          isActive: true,
          startDate: { lte: new Date() },
          OR: [{ endDate: null }, { endDate: { gte: new Date() } }],
        },
      });

      for (const prescription of activePrescriptions) {
        // Check if there are existing reminders for this prescription
        const existingReminders = await this.prisma.reminder.findMany({
          where: {
            prescriptionId: prescription.id,
            status: ReminderStatus.PENDING,
          },
        });

        // If no reminders exist, create them based on frequency
        if (existingReminders.length === 0) {
          await this.createRemindersForPrescription(prescription);
        }
      }

      this.logger.log('Synced medication schedules');
    } catch (error) {
      this.logger.error('Error syncing medication schedules:', error);
    }
  }

  /**
   * Cron job to generate and send weekly health insights
   */
  @Cron('0 0 10 * * 1') // Every Monday at 10 AM
  async sendWeeklyHealthInsights(): Promise<void> {
    try {
      const users = await this.prisma.user.findMany({
        where: {
          isActive: true,
          // Add condition for users who want weekly insights
        },
        select: {
          id: true,
          firstName: true,
          email: true,
        },
      });

      for (const user of users) {
        try {
          // Generate weekly insights (placeholder - implement with AI service)
          const insights = await this.generateWeeklyInsights(user.id);

          if (insights) {
            await this.sendTemplatedNotification(user.id, 'ai_insight_weekly', {
              userName: user.firstName,
              insightSummary: insights.summary,
              keyMetrics: insights.metrics,
            });
          }
        } catch (userError) {
          this.logger.error(
            `Error sending weekly insights to user ${user.id}:`,
            userError,
          );
        }
      }

      this.logger.log('Sent weekly health insights');
    } catch (error) {
      this.logger.error('Error sending weekly health insights:', error);
    }
  }

  /**
   * Cron job to process care group notifications
   */
  @Cron('0 0 18 * * 0') // Every Sunday at 6 PM
  async sendCareGroupWeeklySummaries(): Promise<void> {
    try {
      const careGroups = await this.prisma.careGroup.findMany({
        where: { isActive: true },
        include: {
          members: {
            include: { user: true },
          },
        },
      });

      for (const careGroup of careGroups) {
        try {
          const summary = await this.generateCareGroupSummary(careGroup.id);

          // Send to all members
          for (const member of careGroup.members) {
            await this.sendTemplatedCareGroupNotification(
              member.userId,
              careGroup.id,
              {
                summaryType: 'weekly',
                activityCount: summary.activities,
                newMembers: summary.newMembers,
              },
            );
          }
        } catch (groupError) {
          this.logger.error(
            `Error sending care group summary for ${careGroup.id}:`,
            groupError,
          );
        }
      }

      this.logger.log('Sent care group weekly summaries');
    } catch (error) {
      this.logger.error('Error sending care group summaries:', error);
    }
  }

  /**
   * Helper method to create reminders for a prescription
   */
  private async createRemindersForPrescription(
    prescription: any,
  ): Promise<void> {
    // This is a simplified version - in a real implementation,
    // you would parse the frequency and create appropriate reminder schedules
    const schedules = this.parseFrequencyToTimes(prescription.frequency);

    for (const schedule of schedules) {
      await this.prisma.reminder.create({
        data: {
          prescriptionId: prescription.id,
          scheduledAt: schedule.nextDose,
          frequency: prescription.frequency,
          status: ReminderStatus.PENDING,
        },
      });
    }
  }

  /**
   * Helper method to parse frequency into reminder times
   */
  private parseFrequencyToTimes(frequency: string): Array<{ nextDose: Date }> {
    const now = new Date();
    const schedules: Array<{ nextDose: Date }> = [];

    // Simplified parsing - in reality you'd want more sophisticated logic
    if (frequency.toLowerCase().includes('daily')) {
      const tomorrow = new Date(now);
      tomorrow.setDate(tomorrow.getDate() + 1);
      tomorrow.setHours(9, 0, 0, 0); // 9 AM
      schedules.push({ nextDose: tomorrow });
    }

    return schedules;
  }

  /**
   * Helper method to generate weekly insights (placeholder)
   */
  private async generateWeeklyInsights(userId: string): Promise<{
    summary: string;
    metrics: Record<string, any>;
  } | null> {
    try {
      // This would integrate with your AI/analytics service
      // For now, return a simple placeholder
      const lastWeek = new Date();
      lastWeek.setDate(lastWeek.getDate() - 7);

      const checkIns = await this.prisma.dailyCheckIn.count({
        where: {
          userId,
          createdAt: { gte: lastWeek },
        },
      });

      return {
        summary: `This week you completed ${checkIns} health check-ins. Keep up the great work!`,
        metrics: {
          checkIns,
          weekStartDate: lastWeek.toISOString(),
        },
      };
    } catch (error) {
      this.logger.error(`Error generating insights for user ${userId}:`, error);
      return null;
    }
  }

  /**
   * Helper method to generate care group summary
   */
  private async generateCareGroupSummary(careGroupId: string): Promise<{
    activities: number;
    newMembers: number;
  }> {
    const lastWeek = new Date();
    lastWeek.setDate(lastWeek.getDate() - 7);

    // Count activities in the last week (placeholder logic)
    const activities = await this.prisma.notification.count({
      where: {
        type: NotificationType.CARE_GROUP_UPDATE,
        createdAt: { gte: lastWeek },
      },
    });

    const newMembers = await this.prisma.careGroupMember.count({
      where: {
        careGroupId,
        joinedAt: { gte: lastWeek },
      },
    });

    return { activities, newMembers };
  }
}
