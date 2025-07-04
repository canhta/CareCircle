import { Injectable, Logger } from '@nestjs/common';
import { InjectQueue } from '@nestjs/bullmq';
import { Queue, RepeatOptions } from 'bullmq';
import { PrismaService } from '../prisma/prisma.service';
import { NotificationType, NotificationPriority } from '@prisma/client';

export interface ScheduleOptions {
  pattern?: string; // Cron pattern
  every?: number; // Interval in milliseconds
  startDate?: Date;
  endDate?: Date;
  limit?: number; // Maximum number of executions
  immediately?: boolean; // Run immediately upon scheduling
}

export interface NotificationSchedule {
  id: string;
  name: string;
  type: NotificationType;
  pattern: string;
  isActive: boolean;
  description?: string;
  targetUsers?: string[]; // User IDs, empty for all users
  templateName?: string;
  context?: Record<string, any>;
  priority?: NotificationPriority;
  metadata?: Record<string, any>;
  createdAt: Date;
  updatedAt: Date;
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
    payload: Record<string, any> = {},
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

      await this.scheduleRepeatingNotification(
        jobName,
        NotificationType.MEDICATION_REMINDER,
        {
          pattern: this.timeToPattern(schedule.time),
          startDate: prescription.startDate || new Date(),
          endDate: prescription.endDate || undefined,
        },
        {
          prescriptionId,
          userId: prescription.userId,
          medicationName: prescription.medicationName,
          dosage: prescription.dosage,
          instructions: prescription.instructions,
        },
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

    await this.scheduleRepeatingNotification(
      jobName,
      NotificationType.CHECK_IN_REMINDER,
      { pattern },
      {
        userId,
        reminderType: 'daily_checkin',
      },
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

    await this.scheduleRepeatingNotification(
      jobName,
      NotificationType.AI_INSIGHT,
      { pattern },
      {
        userId,
        insightType: 'weekly_summary',
      },
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
  async getScheduledJobs(): Promise<any[]> {
    const jobs = await this.notificationQueue.getRepeatableJobs();
    return jobs.filter((job) => job.name === 'scheduled-notification');
  }

  /**
   * Update user notification schedule preferences
   */
  async updateUserSchedulePreferences(
    userId: string,
    preferences: {
      medicationReminders?: boolean;
      dailyCheckins?: boolean;
      weeklyInsights?: boolean;
      quietHours?: { start: string; end: string };
      timezone?: string;
    },
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

    await this.scheduleRepeatingNotification(
      jobName,
      NotificationType.CARE_GROUP_UPDATE,
      { pattern },
      {
        careGroupId,
        reminderType: type,
      },
    );

    this.logger.log(`Scheduled care group ${type} for group: ${careGroupId}`);
  }

  /**
   * Parse medication frequency to schedule objects
   */
  private parseFrequencyToSchedules(
    frequency: string,
  ): Array<{ time: string; label: string }> {
    const schedules: Array<{ time: string; label: string }> = [];

    // Parse common frequency patterns
    const freq = frequency.toLowerCase();

    if (
      freq.includes('once daily') ||
      freq.includes('1x daily') ||
      freq.includes('daily')
    ) {
      schedules.push({ time: '09:00', label: 'Morning dose' });
    } else if (
      freq.includes('twice daily') ||
      freq.includes('2x daily') ||
      freq.includes('bid')
    ) {
      schedules.push(
        { time: '09:00', label: 'Morning dose' },
        { time: '21:00', label: 'Evening dose' },
      );
    } else if (
      freq.includes('three times daily') ||
      freq.includes('3x daily') ||
      freq.includes('tid')
    ) {
      schedules.push(
        { time: '08:00', label: 'Morning dose' },
        { time: '14:00', label: 'Afternoon dose' },
        { time: '20:00', label: 'Evening dose' },
      );
    } else if (
      freq.includes('four times daily') ||
      freq.includes('4x daily') ||
      freq.includes('qid')
    ) {
      schedules.push(
        { time: '08:00', label: 'Morning dose' },
        { time: '12:00', label: 'Noon dose' },
        { time: '16:00', label: 'Afternoon dose' },
        { time: '20:00', label: 'Evening dose' },
      );
    } else if (freq.includes('every 6 hours') || freq.includes('q6h')) {
      schedules.push(
        { time: '06:00', label: 'Dose 1' },
        { time: '12:00', label: 'Dose 2' },
        { time: '18:00', label: 'Dose 3' },
        { time: '00:00', label: 'Dose 4' },
      );
    } else if (freq.includes('every 8 hours') || freq.includes('q8h')) {
      schedules.push(
        { time: '08:00', label: 'Dose 1' },
        { time: '16:00', label: 'Dose 2' },
        { time: '00:00', label: 'Dose 3' },
      );
    } else if (freq.includes('every 12 hours') || freq.includes('q12h')) {
      schedules.push(
        { time: '09:00', label: 'Morning dose' },
        { time: '21:00', label: 'Evening dose' },
      );
    } else {
      // Default to once daily if pattern not recognized
      schedules.push({ time: '09:00', label: 'Daily dose' });
    }

    return schedules;
  }

  /**
   * Convert time string to cron pattern
   */
  private timeToPattern(time: string, timezone?: string): string {
    const [hour, minute] = time.split(':').map(Number);

    // Basic cron pattern: second minute hour day month dayOfWeek
    // For daily: 0 minute hour * * *
    // Note: timezone handling could be implemented here if needed
    return `0 ${minute} ${hour} * * *`;
  }

  /**
   * Clean up expired or completed schedules
   */
  async cleanupExpiredSchedules(): Promise<void> {
    const jobs = await this.getScheduledJobs();
    const now = new Date();

    for (const job of jobs) {
      // Type guard to check if job has the expected structure
      if (
        job &&
        typeof job === 'object' &&
        'key' in job &&
        typeof job.key === 'string' &&
        'opts' in job &&
        job.opts &&
        typeof job.opts === 'object' &&
        'repeat' in job.opts &&
        job.opts.repeat &&
        typeof job.opts.repeat === 'object' &&
        'endDate' in job.opts.repeat &&
        job.opts.repeat.endDate
      ) {
        const endDate = new Date(
          job.opts.repeat.endDate as string | number | Date,
        );
        if (endDate < now) {
          await this.notificationQueue.removeRepeatableByKey(job.key);
          this.logger.log(`Cleaned up expired schedule: ${job.key}`);
        }
      }
    }
  }
}
