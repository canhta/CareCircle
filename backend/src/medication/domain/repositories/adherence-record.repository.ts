import { AdherenceRecord } from '../entities/adherence-record.entity';
import { DoseStatus } from '@prisma/client';

export interface AdherenceQuery {
  userId: string;
  medicationId?: string;
  scheduleId?: string;
  status?: DoseStatus;
  startDate?: Date;
  endDate?: Date;
  limit?: number;
  offset?: number;
}

export interface AdherenceStatistics {
  totalDoses: number;
  takenDoses: number;
  missedDoses: number;
  skippedDoses: number;
  adherenceRate: number; // Percentage
  averageAdherenceScore: number;
  streakDays: number; // Current streak of adherent days
  longestStreak: number; // Longest adherence streak
}

export interface AdherenceTrend {
  date: Date;
  scheduledDoses: number;
  takenDoses: number;
  adherenceRate: number;
}

export abstract class AdherenceRecordRepository {
  // Basic CRUD operations
  abstract create(record: AdherenceRecord): Promise<AdherenceRecord>;
  abstract findById(id: string): Promise<AdherenceRecord | null>;
  abstract findMany(query: AdherenceQuery): Promise<AdherenceRecord[]>;
  abstract update(id: string, updates: Partial<AdherenceRecord>): Promise<AdherenceRecord>;
  abstract delete(id: string): Promise<void>;

  // Bulk operations
  abstract createMany(records: AdherenceRecord[]): Promise<AdherenceRecord[]>;
  abstract deleteMany(ids: string[]): Promise<void>;

  // User-specific queries
  abstract findByUserId(userId: string): Promise<AdherenceRecord[]>;
  abstract findByUserIdAndDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<AdherenceRecord[]>;

  // Medication and schedule queries
  abstract findByMedicationId(medicationId: string): Promise<AdherenceRecord[]>;
  abstract findByScheduleId(scheduleId: string): Promise<AdherenceRecord[]>;
  abstract findByMedicationAndDateRange(
    medicationId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<AdherenceRecord[]>;

  // Status-based queries
  abstract findByStatus(userId: string, status: DoseStatus): Promise<AdherenceRecord[]>;
  abstract findTakenDoses(userId: string, startDate?: Date, endDate?: Date): Promise<AdherenceRecord[]>;
  abstract findMissedDoses(userId: string, startDate?: Date, endDate?: Date): Promise<AdherenceRecord[]>;
  abstract findSkippedDoses(userId: string, startDate?: Date, endDate?: Date): Promise<AdherenceRecord[]>;
  abstract findScheduledDoses(userId: string): Promise<AdherenceRecord[]>;
  abstract findOverdueDoses(userId: string): Promise<AdherenceRecord[]>;

  // Time-based queries
  abstract findDosesForDate(userId: string, date: Date): Promise<AdherenceRecord[]>;
  abstract findUpcomingDoses(userId: string, withinHours: number): Promise<AdherenceRecord[]>;
  abstract findDueNow(userId: string): Promise<AdherenceRecord[]>;
  abstract findTodaysDoses(userId: string): Promise<AdherenceRecord[]>;

  // Adherence analytics
  abstract getAdherenceStatistics(
    userId: string,
    startDate?: Date,
    endDate?: Date,
  ): Promise<AdherenceStatistics>;
  abstract getAdherenceRate(
    userId: string,
    medicationId?: string,
    startDate?: Date,
    endDate?: Date,
  ): Promise<number>;
  abstract getAdherenceTrend(
    userId: string,
    days: number,
    medicationId?: string,
  ): Promise<AdherenceTrend[]>;

  // Streak calculations
  abstract getCurrentAdherenceStreak(userId: string, medicationId?: string): Promise<number>;
  abstract getLongestAdherenceStreak(userId: string, medicationId?: string): Promise<number>;
  abstract getStreakHistory(userId: string, medicationId?: string): Promise<Array<{
    startDate: Date;
    endDate: Date;
    streakDays: number;
  }>>;

  // Pattern analysis
  abstract findAdherencePatterns(userId: string): Promise<Array<{
    dayOfWeek: number;
    timeOfDay: number;
    adherenceRate: number;
    totalDoses: number;
  }>>;
  abstract findMissedDosePatterns(userId: string): Promise<Array<{
    medicationId: string;
    commonReasons: string[];
    timePatterns: Array<{ hour: number; count: number }>;
    dayPatterns: Array<{ dayOfWeek: number; count: number }>;
  }>>;

  // Medication-specific adherence
  abstract getMedicationAdherenceRanking(userId: string): Promise<Array<{
    medicationId: string;
    adherenceRate: number;
    totalDoses: number;
    takenDoses: number;
  }>>;
  abstract findPoorAdherenceMedications(
    userId: string,
    adherenceThreshold: number,
  ): Promise<string[]>; // Returns medication IDs

  // Recent activity
  abstract findRecentActivity(userId: string, days: number, limit?: number): Promise<AdherenceRecord[]>;
  abstract findRecentlyTaken(userId: string, hours: number, limit?: number): Promise<AdherenceRecord[]>;
  abstract findRecentlyMissed(userId: string, days: number, limit?: number): Promise<AdherenceRecord[]>;

  // Reminder-related queries
  abstract findRecordsWithReminders(userId: string): Promise<AdherenceRecord[]>;
  abstract findRecordsNeedingReminders(userId: string): Promise<AdherenceRecord[]>;

  // Count operations
  abstract getAdherenceCount(
    userId: string,
    status?: DoseStatus,
    startDate?: Date,
    endDate?: Date,
  ): Promise<number>;
  abstract getDailyAdherenceCount(userId: string, date: Date): Promise<{
    scheduled: number;
    taken: number;
    missed: number;
    skipped: number;
  }>;
}
