import { Injectable, Logger } from '@nestjs/common';
import { InjectQueue } from '@nestjs/bullmq';
import { Queue, RepeatOptions } from 'bullmq';
import { PrismaService } from '../prisma/prisma.service';
import { NotificationType } from '@prisma/client';
import {
  CareGroupReminderData,
  CheckInReminderData,
  HealthInsightsData,
  MedicationReminderData,
  NotificationSchedule,
  ScheduleOptions,
  SchedulePayload,
  TimeSchedule,
  UserSchedulePreferences,
} from '../common/interfaces/notification-scheduling.interfaces';

interface RepeatableJobWithData {
  id: string;
  name: string;
  pattern?: string;
  data?: Record<string, unknown>;
  timestamp?: number;
}

@Injectable()
export class NotificationSchedulingService {
  private readonly logger = new Logger(NotificationSchedulingService.name);

  constructor(
    private readonly prisma: PrismaService,
    @InjectQueue('notification') private notificationQueue: Queue,
    @InjectQueue('reminder') private reminderQueue: Queue,
  ) {}

  /**
   * Schedule a repeating notification job
   */
  async scheduleRepeatingNotification(
    jobName: string,
    type: NotificationType,
    options: ScheduleOptions,
    payload: SchedulePayload = {},
  ): Promise<void> {
    const repeatOptions: RepeatOptions = {
      pattern: options.pattern,
      every: options.every,
      startDate: options.startDate,
      endDate: options.endDate,
      limit: options.limit,
      immediately: options.immediately,
    };

    await this.notificationQueue.add(
      'scheduled-notification',
      {
        type,
        jobName,
        ...payload,
      },
      {
        repeat: repeatOptions,
        removeOnComplete: 10, // Keep last 10 completed jobs
        removeOnFail: 50, // Keep last 50 failed jobs
      },
    );

    this.logger.debug(`Scheduled repeating notification job: ${jobName}`);
  }

  /**
   * Schedule medication reminders based on prescription frequency
   */
  async scheduleMedicationReminders(prescriptionId: string): Promise<void> {
    const prescription = await this.prisma.prescription.findUnique({
      where: { id: prescriptionId },
      include: { user: true },
    });

    if (!prescription) {
      throw new Error(`Prescription not found: ${prescriptionId}`);
    }

    // Parse frequency and create schedules
    const schedules = this.parseFrequencyToSchedules(prescription.frequency);

    for (const schedule of schedules) {
      const jobName = `medication-reminder-${prescriptionId}-${schedule.time}`;

      const reminderData: MedicationReminderData = {
        prescriptionId,
        userId: prescription.userId,
        medicationName: prescription.medicationName,
        dosage: prescription.dosage,
        instructions: prescription.instructions || undefined,
      };

      await this.scheduleRepeatingNotification(
        jobName,
        NotificationType.MEDICATION_REMINDER,
        {
          pattern: this.timeToPattern(schedule.time),
          startDate: prescription.startDate || new Date(),
          endDate: prescription.endDate || undefined,
        },
        reminderData,
      );
    }

    this.logger.log(
      `Scheduled medication reminders for prescription: ${prescriptionId}`,
    );
  }

  /**
   * Schedule daily check-in reminders for a user
   */
  async scheduleDailyCheckInReminder(
    userId: string,
    time: string = '09:00', // Default 9 AM
    timezone: string = 'UTC',
  ): Promise<void> {
    const jobName = `daily-checkin-${userId}`;
    const pattern = this.timeToPattern(time, timezone);

    const reminderData: CheckInReminderData = {
      userId,
      reminderType: 'daily_checkin',
    };

    await this.scheduleRepeatingNotification(
      jobName,
      NotificationType.CHECK_IN_REMINDER,
      { pattern },
      reminderData,
    );

    this.logger.log(
      `Scheduled daily check-in reminder for user: ${userId} at ${time}`,
    );
  }

  /**
   * Schedule weekly health insights
   */
  async scheduleWeeklyHealthInsights(
    userId: string,
    dayOfWeek: number = 1, // Monday
    time: string = '10:00',
  ): Promise<void> {
    const jobName = `weekly-insights-${userId}`;
    const [hour, minute] = time.split(':').map(Number);
    const pattern = `0 ${minute} ${hour} * * ${dayOfWeek}`; // Weekly pattern

    const insightData: HealthInsightsData = {
      userId,
      insightType: 'weekly_summary',
    };

    await this.scheduleRepeatingNotification(
      jobName,
      NotificationType.AI_INSIGHT,
      { pattern },
      insightData,
    );

    this.logger.log(`Scheduled weekly health insights for user: ${userId}`);
  }

  /**
   * Remove a scheduled job
   */
  async removeScheduledJob(jobName: string): Promise<void> {
    const jobs = await this.notificationQueue.getRepeatableJobs();
    const job = jobs.find(
      (j) => j.name === 'scheduled-notification' && j.key.includes(jobName),
    );

    if (job) {
      await this.notificationQueue.removeRepeatableByKey(job.key);
      this.logger.log(`Removed scheduled job: ${jobName}`);
    }
  }

  /**
   * List all scheduled jobs
   */
  async getScheduledJobs(): Promise<NotificationSchedule[]> {
    const jobs =
      (await this.notificationQueue.getRepeatableJobs()) as RepeatableJobWithData[];
    return jobs
      .filter((job) => job.name === 'scheduled-notification')
      .map((job) => ({
        id: job.id,
        name: job.name,
        type:
          (job.data?.type as NotificationType) ||
          NotificationType.SYSTEM_NOTIFICATION,
        pattern: job.pattern || '',
        isActive: true,
        createdAt: job.timestamp ? new Date(job.timestamp) : new Date(),
        updatedAt: new Date(),
      })) as NotificationSchedule[];
  }

  /**
   * Update user notification schedule preferences
   */
  async updateUserSchedulePreferences(
    userId: string,
    preferences: UserSchedulePreferences,
  ): Promise<void> {
    // Store preferences in user profile or separate table
    // This is a placeholder - implement based on your user preferences model

    if (preferences.dailyCheckins === false) {
      await this.removeScheduledJob(`daily-checkin-${userId}`);
    } else if (preferences.dailyCheckins === true) {
      await this.scheduleDailyCheckInReminder(
        userId,
        '09:00',
        preferences.timezone,
      );
    }

    if (preferences.weeklyInsights === false) {
      await this.removeScheduledJob(`weekly-insights-${userId}`);
    } else if (preferences.weeklyInsights === true) {
      await this.scheduleWeeklyHealthInsights(userId);
    }

    this.logger.log(`Updated schedule preferences for user: ${userId}`);
  }

  /**
   * Schedule care group reminder
   */
  async scheduleCareGroupReminder(
    careGroupId: string,
    type: 'weekly_summary' | 'activity_digest' | 'member_update',
    dayOfWeek: number = 0, // Sunday
    time: string = '18:00',
  ): Promise<void> {
    const jobName = `care-group-${type}-${careGroupId}`;
    const [hour, minute] = time.split(':').map(Number);
    const pattern = `0 ${minute} ${hour} * * ${dayOfWeek}`;

    const reminderData: CareGroupReminderData = {
      careGroupId,
      reminderType: type,
    };

    await this.scheduleRepeatingNotification(
      jobName,
      NotificationType.CARE_GROUP_UPDATE,
      { pattern },
      reminderData,
    );

    this.logger.log(
      `Scheduled care group ${type} reminder for group: ${careGroupId}`,
    );
  }

  /**
   * Parse medication frequency string into specific time schedules
   */
  private parseFrequencyToSchedules(frequency: string): TimeSchedule[] {
    const schedules: TimeSchedule[] = [];

    if (frequency.includes('daily') || frequency.includes('day')) {
      if (frequency.includes('morning')) {
        schedules.push({ time: '08:00', label: 'Morning' });
      }
      if (frequency.includes('noon')) {
        schedules.push({ time: '12:00', label: 'Noon' });
      }
      if (frequency.includes('evening')) {
        schedules.push({ time: '18:00', label: 'Evening' });
      }
      if (frequency.includes('night') || frequency.includes('bedtime')) {
        schedules.push({ time: '21:00', label: 'Night' });
      }
    }

    // Look for specific times (e.g., "at 14:30")
    const timeMatches = frequency.match(/at\s+(\d{1,2}):(\d{2})/g);
    if (timeMatches) {
      for (const match of timeMatches) {
        const [hour, minute] = match
          .replace('at', '')
          .trim()
          .split(':')
          .map(Number);
        const formattedTime = `${hour.toString().padStart(2, '0')}:${minute
          .toString()
          .padStart(2, '0')}`;
        schedules.push({ time: formattedTime, label: `At ${formattedTime}` });
      }
    }

    // Default to morning if no specific time found
    if (schedules.length === 0) {
      schedules.push({ time: '08:00', label: 'Default' });
    }

    return schedules;
  }

  /**
   * Convert time string to cron pattern
   */
  private timeToPattern(time: string, timezone?: string): string {
    const [hour, minute] = time.split(':').map(Number);
    return `0 ${minute} ${hour} * * *`; // Run daily at the specified time
  }

  /**
   * Clean up expired schedules
   */
  async cleanupExpiredSchedules(): Promise<void> {
    const now = new Date();

    // Get all schedules from database or other storage
    // This is a placeholder - implement based on how you store schedules
    const schedules = await this.getScheduledJobs();

    // For example:
    for (const schedule of schedules) {
      if (!schedule.isActive) {
        await this.removeScheduledJob(schedule.name);
      }
    }

    this.logger.log('Cleaned up expired notification schedules');
  }
}
