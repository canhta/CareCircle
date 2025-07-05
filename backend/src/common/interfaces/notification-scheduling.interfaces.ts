import { NotificationType, NotificationPriority } from '@prisma/client';

/**
 * Interface for schedule options
 */
export interface ScheduleOptions {
  pattern?: string; // Cron pattern
  every?: number; // Interval in milliseconds
  startDate?: Date;
  endDate?: Date;
  limit?: number; // Maximum number of executions
  immediately?: boolean; // Run immediately upon scheduling
}

/**
 * Interface for notification schedule
 */
export interface NotificationSchedule {
  id: string;
  name: string;
  type: NotificationType;
  pattern: string;
  isActive: boolean;
  description?: string;
  targetUsers?: string[]; // User IDs, empty for all users
  templateName?: string;
  context?: Record<string, unknown>;
  priority?: NotificationPriority;
  metadata?: Record<string, unknown>;
  createdAt: Date;
  updatedAt: Date;
}

/**
 * Interface for schedule payload
 */
export type SchedulePayload = Record<string, unknown>;

/**
 * Interface for medication reminder data
 */
export interface MedicationReminderData extends SchedulePayload {
  prescriptionId: string;
  userId: string;
  medicationName: string;
  dosage: string;
  instructions?: string;
}

/**
 * Interface for daily check-in reminder data
 */
export interface CheckInReminderData extends SchedulePayload {
  userId: string;
  reminderType: 'daily_checkin';
}

/**
 * Interface for health insights data
 */
export interface HealthInsightsData extends SchedulePayload {
  userId: string;
  insightType: 'weekly_summary' | 'monthly_report' | 'goal_progress';
}

/**
 * Interface for care group reminder data
 */
export interface CareGroupReminderData extends SchedulePayload {
  careGroupId: string;
  reminderType: 'weekly_summary' | 'activity_digest' | 'member_update';
}

/**
 * Interface for user schedule preferences
 */
export interface UserSchedulePreferences {
  medicationReminders?: boolean;
  dailyCheckins?: boolean;
  weeklyInsights?: boolean;
  quietHours?: {
    start: string;
    end: string;
  };
  timezone?: string;
}

/**
 * Interface for time-based schedule
 */
export interface TimeSchedule {
  time: string;
  label: string;
}
