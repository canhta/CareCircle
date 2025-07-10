import { MedicationSchedule } from '../entities/medication-schedule.entity';

export interface ScheduleQuery {
  userId: string;
  medicationId?: string;
  isActive?: boolean;
  remindersEnabled?: boolean;
  frequency?: 'daily' | 'weekly' | 'monthly' | 'as_needed';
  startDate?: Date;
  endDate?: Date;
  limit?: number;
  offset?: number;
}

export interface ScheduleStatistics {
  totalSchedules: number;
  activeSchedules: number;
  inactiveSchedules: number;
  schedulesWithReminders: number;
  schedulesByFrequency: Record<string, number>;
  averageDurationDays: number;
  upcomingDoses: number;
}

export abstract class MedicationScheduleRepository {
  // Basic CRUD operations
  abstract create(schedule: MedicationSchedule): Promise<MedicationSchedule>;
  abstract findById(id: string): Promise<MedicationSchedule | null>;
  abstract findMany(query: ScheduleQuery): Promise<MedicationSchedule[]>;
  abstract update(
    id: string,
    updates: Partial<MedicationSchedule>,
  ): Promise<MedicationSchedule>;
  abstract delete(id: string): Promise<void>;

  // Bulk operations
  abstract createMany(
    schedules: MedicationSchedule[],
  ): Promise<MedicationSchedule[]>;
  abstract deleteMany(ids: string[]): Promise<void>;

  // User-specific queries
  abstract findByUserId(
    userId: string,
    includeInactive?: boolean,
  ): Promise<MedicationSchedule[]>;
  abstract findActiveByUserId(userId: string): Promise<MedicationSchedule[]>;
  abstract findInactiveByUserId(userId: string): Promise<MedicationSchedule[]>;

  // Medication-specific queries
  abstract findByMedicationId(
    medicationId: string,
  ): Promise<MedicationSchedule[]>;
  abstract findActiveMedicationSchedules(
    medicationId: string,
  ): Promise<MedicationSchedule[]>;

  // Reminder queries
  abstract findWithRemindersEnabled(
    userId: string,
  ): Promise<MedicationSchedule[]>;
  abstract findWithRemindersDisabled(
    userId: string,
  ): Promise<MedicationSchedule[]>;
  abstract findSchedulesNeedingReminders(
    userId: string,
    withinMinutes: number,
  ): Promise<MedicationSchedule[]>;

  // Time-based queries
  abstract findSchedulesForDate(
    userId: string,
    date: Date,
  ): Promise<MedicationSchedule[]>;
  abstract findSchedulesForDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<MedicationSchedule[]>;
  abstract findUpcomingSchedules(
    userId: string,
    withinHours: number,
  ): Promise<MedicationSchedule[]>;

  // Frequency-based queries
  abstract findDailySchedules(userId: string): Promise<MedicationSchedule[]>;
  abstract findWeeklySchedules(userId: string): Promise<MedicationSchedule[]>;
  abstract findMonthlySchedules(userId: string): Promise<MedicationSchedule[]>;
  abstract findAsNeededSchedules(userId: string): Promise<MedicationSchedule[]>;

  // Status queries
  abstract findExpiredSchedules(userId: string): Promise<MedicationSchedule[]>;
  abstract findExpiringSchedules(
    userId: string,
    withinDays: number,
  ): Promise<MedicationSchedule[]>;
  abstract findOverdueSchedules(userId: string): Promise<MedicationSchedule[]>;

  // Statistics and analytics
  abstract getScheduleStatistics(userId: string): Promise<ScheduleStatistics>;
  abstract getScheduleCount(
    userId: string,
    isActive?: boolean,
  ): Promise<number>;
  abstract getSchedulesByFrequencyCount(
    userId: string,
  ): Promise<Record<string, number>>;

  // Adherence-related queries
  abstract findSchedulesWithPoorAdherence(
    userId: string,
    adherenceThreshold: number,
    days: number,
  ): Promise<MedicationSchedule[]>;
  abstract findMostAdherentSchedules(
    userId: string,
    limit?: number,
  ): Promise<MedicationSchedule[]>;

  // Conflict detection
  abstract findConflictingSchedules(
    userId: string,
    newSchedule: MedicationSchedule,
  ): Promise<MedicationSchedule[]>;
  abstract findOverlappingSchedules(
    userId: string,
  ): Promise<MedicationSchedule[][]>;

  // Recent activity
  abstract findRecentlyAdded(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<MedicationSchedule[]>;
  abstract findRecentlyModified(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<MedicationSchedule[]>;
  abstract findRecentlyDeactivated(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<MedicationSchedule[]>;
}
