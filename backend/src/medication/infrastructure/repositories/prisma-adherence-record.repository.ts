import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { AdherenceRecord } from '../../domain/entities/adherence-record.entity';
import {
  AdherenceRecordRepository,
  AdherenceQuery,
  AdherenceStatistics,
  AdherenceTrend,
} from '../../domain/repositories/adherence-record.repository';
import {
  MedicationDose as PrismaMedicationDose,
  DoseStatus,
  Prisma,
} from '@prisma/client';

@Injectable()
export class PrismaAdherenceRecordRepository extends AdherenceRecordRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async create(record: AdherenceRecord): Promise<AdherenceRecord> {
    const data = await this.prisma.medicationDose.create({
      data: {
        id: record.id,
        medicationId: record.medicationId,
        scheduleId: record.scheduleId,
        userId: record.userId,
        scheduledTime: record.scheduledTime,
        dosage: record.dosage,
        unit: record.unit,
        status: record.status,
        takenAt: record.takenAt,
        skippedReason: record.skippedReason,
        notes: record.notes,
        reminderId: record.reminderId,
        createdAt: record.createdAt,
      },
    });

    return this.mapToEntity(data);
  }

  async createMany(records: AdherenceRecord[]): Promise<AdherenceRecord[]> {
    await this.prisma.medicationDose.createMany({
      data: records.map((record) => ({
        id: record.id,
        medicationId: record.medicationId,
        scheduleId: record.scheduleId,
        userId: record.userId,
        scheduledTime: record.scheduledTime,
        dosage: record.dosage,
        unit: record.unit,
        status: record.status,
        takenAt: record.takenAt,
        skippedReason: record.skippedReason,
        notes: record.notes,
        reminderId: record.reminderId,
        createdAt: record.createdAt,
      })),
    });

    // Return the created records by finding them
    const createdRecords = await this.prisma.medicationDose.findMany({
      where: {
        id: { in: records.map((r) => r.id) },
      },
    });

    return createdRecords.map((data) => this.mapToEntity(data));
  }

  async findById(id: string): Promise<AdherenceRecord | null> {
    const data = await this.prisma.medicationDose.findUnique({
      where: { id },
    });

    return data ? this.mapToEntity(data) : null;
  }

  async findMany(query: AdherenceQuery): Promise<AdherenceRecord[]> {
    const where: Prisma.MedicationDoseWhereInput = {
      userId: query.userId,
    };

    if (query.medicationId) {
      where.medicationId = query.medicationId;
    }

    if (query.scheduleId) {
      where.scheduleId = query.scheduleId;
    }

    if (query.status) {
      where.status = query.status;
    }

    if (query.startDate || query.endDate) {
      where.scheduledTime = {};
      if (query.startDate) where.scheduledTime.gte = query.startDate;
      if (query.endDate) where.scheduledTime.lte = query.endDate;
    }

    const data = await this.prisma.medicationDose.findMany({
      where,
      orderBy: { scheduledTime: 'desc' },
      take: query.limit,
      skip: query.offset,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async update(
    id: string,
    updates: Partial<AdherenceRecord>,
  ): Promise<AdherenceRecord> {
    const data = await this.prisma.medicationDose.update({
      where: { id },
      data: {
        status: updates.status,
        takenAt: updates.takenAt,
        skippedReason: updates.skippedReason,
        notes: updates.notes,
        reminderId: updates.reminderId,
      },
    });

    return this.mapToEntity(data);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.medicationDose.delete({
      where: { id },
    });
  }

  async deleteMany(ids: string[]): Promise<void> {
    await this.prisma.medicationDose.deleteMany({
      where: {
        id: { in: ids },
      },
    });
  }

  async findByUserId(userId: string): Promise<AdherenceRecord[]> {
    const data = await this.prisma.medicationDose.findMany({
      where: { userId },
      orderBy: { scheduledTime: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByUserIdAndDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<AdherenceRecord[]> {
    const data = await this.prisma.medicationDose.findMany({
      where: {
        userId,
        scheduledTime: {
          gte: startDate,
          lte: endDate,
        },
      },
      orderBy: { scheduledTime: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByMedicationId(medicationId: string): Promise<AdherenceRecord[]> {
    const data = await this.prisma.medicationDose.findMany({
      where: { medicationId },
      orderBy: { scheduledTime: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByScheduleId(scheduleId: string): Promise<AdherenceRecord[]> {
    const data = await this.prisma.medicationDose.findMany({
      where: { scheduleId },
      orderBy: { scheduledTime: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByMedicationAndDateRange(
    medicationId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<AdherenceRecord[]> {
    const data = await this.prisma.medicationDose.findMany({
      where: {
        medicationId,
        scheduledTime: {
          gte: startDate,
          lte: endDate,
        },
      },
      orderBy: { scheduledTime: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByStatus(
    userId: string,
    status: DoseStatus,
  ): Promise<AdherenceRecord[]> {
    const data = await this.prisma.medicationDose.findMany({
      where: {
        userId,
        status,
      },
      orderBy: { scheduledTime: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findTakenDoses(
    userId: string,
    startDate?: Date,
    endDate?: Date,
  ): Promise<AdherenceRecord[]> {
    const where: Prisma.MedicationDoseWhereInput = {
      userId,
      status: DoseStatus.TAKEN,
    };

    if (startDate || endDate) {
      where.scheduledTime = {};
      if (startDate) where.scheduledTime.gte = startDate;
      if (endDate) where.scheduledTime.lte = endDate;
    }

    const data = await this.prisma.medicationDose.findMany({
      where,
      orderBy: { takenAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findMissedDoses(
    userId: string,
    startDate?: Date,
    endDate?: Date,
  ): Promise<AdherenceRecord[]> {
    const where: Prisma.MedicationDoseWhereInput = {
      userId,
      status: DoseStatus.MISSED,
    };

    if (startDate || endDate) {
      where.scheduledTime = {};
      if (startDate) where.scheduledTime.gte = startDate;
      if (endDate) where.scheduledTime.lte = endDate;
    }

    const data = await this.prisma.medicationDose.findMany({
      where,
      orderBy: { scheduledTime: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findSkippedDoses(
    userId: string,
    startDate?: Date,
    endDate?: Date,
  ): Promise<AdherenceRecord[]> {
    const where: Prisma.MedicationDoseWhereInput = {
      userId,
      status: DoseStatus.SKIPPED,
    };

    if (startDate || endDate) {
      where.scheduledTime = {};
      if (startDate) where.scheduledTime.gte = startDate;
      if (endDate) where.scheduledTime.lte = endDate;
    }

    const data = await this.prisma.medicationDose.findMany({
      where,
      orderBy: { scheduledTime: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findScheduledDoses(userId: string): Promise<AdherenceRecord[]> {
    const data = await this.prisma.medicationDose.findMany({
      where: {
        userId,
        status: DoseStatus.SCHEDULED,
      },
      orderBy: { scheduledTime: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findOverdueDoses(userId: string): Promise<AdherenceRecord[]> {
    const now = new Date();
    const overdueThreshold = new Date(now.getTime() - 2 * 60 * 60 * 1000); // 2 hours ago

    const data = await this.prisma.medicationDose.findMany({
      where: {
        userId,
        status: DoseStatus.SCHEDULED,
        scheduledTime: { lt: overdueThreshold },
      },
      orderBy: { scheduledTime: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  private mapToEntity(data: PrismaMedicationDose): AdherenceRecord {
    return new AdherenceRecord(
      data.id,
      data.medicationId,
      data.scheduleId,
      data.userId,
      data.scheduledTime,
      data.dosage,
      data.unit,
      data.status,
      data.takenAt,
      data.skippedReason,
      data.notes,
      data.reminderId,
      data.createdAt,
    );
  }

  // Time-based queries
  async findDosesForDate(
    userId: string,
    date: Date,
  ): Promise<AdherenceRecord[]> {
    const startOfDay = new Date(date);
    startOfDay.setHours(0, 0, 0, 0);
    const endOfDay = new Date(date);
    endOfDay.setHours(23, 59, 59, 999);

    const data = await this.prisma.medicationDose.findMany({
      where: {
        userId,
        scheduledTime: {
          gte: startOfDay,
          lte: endOfDay,
        },
      },
      orderBy: { scheduledTime: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findUpcomingDoses(
    userId: string,
    withinHours: number,
  ): Promise<AdherenceRecord[]> {
    const now = new Date();
    const futureTime = new Date(now.getTime() + withinHours * 60 * 60 * 1000);

    const data = await this.prisma.medicationDose.findMany({
      where: {
        userId,
        status: DoseStatus.SCHEDULED,
        scheduledTime: {
          gte: now,
          lte: futureTime,
        },
      },
      orderBy: { scheduledTime: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findDueNow(userId: string): Promise<AdherenceRecord[]> {
    const now = new Date();
    const gracePeriod = new Date(now.getTime() + 15 * 60 * 1000); // 15 minutes grace

    const data = await this.prisma.medicationDose.findMany({
      where: {
        userId,
        status: DoseStatus.SCHEDULED,
        scheduledTime: {
          lte: gracePeriod,
        },
      },
      orderBy: { scheduledTime: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findTodaysDoses(userId: string): Promise<AdherenceRecord[]> {
    const today = new Date();
    return this.findDosesForDate(userId, today);
  }

  // Adherence analytics
  async getAdherenceStatistics(
    userId: string,
    startDate?: Date,
    endDate?: Date,
  ): Promise<AdherenceStatistics> {
    const where: Prisma.MedicationDoseWhereInput = { userId };

    if (startDate || endDate) {
      where.scheduledTime = {};
      if (startDate) where.scheduledTime.gte = startDate;
      if (endDate) where.scheduledTime.lte = endDate;
    }

    const [totalDoses, takenDoses, missedDoses, skippedDoses] =
      await Promise.all([
        this.prisma.medicationDose.count({ where }),
        this.prisma.medicationDose.count({
          where: { ...where, status: DoseStatus.TAKEN },
        }),
        this.prisma.medicationDose.count({
          where: { ...where, status: DoseStatus.MISSED },
        }),
        this.prisma.medicationDose.count({
          where: { ...where, status: DoseStatus.SKIPPED },
        }),
      ]);

    const adherenceRate = totalDoses > 0 ? (takenDoses / totalDoses) * 100 : 0;

    return {
      totalDoses,
      takenDoses,
      missedDoses,
      skippedDoses,
      adherenceRate: Number(adherenceRate.toFixed(2)),
      averageAdherenceScore: adherenceRate,
      streakDays: 0, // Would require complex calculation
      longestStreak: 0, // Would require complex calculation
    };
  }

  async getAdherenceRate(
    userId: string,
    medicationId?: string,
    startDate?: Date,
    endDate?: Date,
  ): Promise<number> {
    const stats = await this.getAdherenceStatistics(userId, startDate, endDate);
    return stats.adherenceRate;
  }

  async getAdherenceTrend(
    _userId: string,
    _days: number,
    _medicationId?: string,
  ): Promise<AdherenceTrend[]> {
    // This would require complex trend calculation
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  // Streak calculations
  async getCurrentAdherenceStreak(
    _userId: string,
    _medicationId?: string,
  ): Promise<number> {
    // This would require complex streak calculation
    // For now, return 0 as placeholder
    return Promise.resolve(0);
  }

  async getLongestAdherenceStreak(
    _userId: string,
    _medicationId?: string,
  ): Promise<number> {
    // This would require complex streak calculation
    // For now, return 0 as placeholder
    return Promise.resolve(0);
  }

  async getStreakHistory(
    _userId: string,
    _medicationId?: string,
  ): Promise<
    Array<{
      startDate: Date;
      endDate: Date;
      streakDays: number;
    }>
  > {
    // This would require complex streak history calculation
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  // Pattern analysis
  async findAdherencePatterns(_userId: string): Promise<
    Array<{
      dayOfWeek: number;
      timeOfDay: number;
      adherenceRate: number;
      totalDoses: number;
    }>
  > {
    // This would require complex pattern analysis
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  async findMissedDosePatterns(_userId: string): Promise<
    Array<{
      medicationId: string;
      commonReasons: string[];
      timePatterns: Array<{ hour: number; count: number }>;
      dayPatterns: Array<{ dayOfWeek: number; count: number }>;
    }>
  > {
    // This would require complex pattern analysis
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  // Medication-specific adherence
  async getMedicationAdherenceRanking(_userId: string): Promise<
    Array<{
      medicationId: string;
      adherenceRate: number;
      totalDoses: number;
      takenDoses: number;
    }>
  > {
    // This would require complex ranking calculation
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  async findPoorAdherenceMedications(
    _userId: string,
    _adherenceThreshold: number,
  ): Promise<string[]> {
    // This would require complex adherence calculation per medication
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  // Recent activity
  async findRecentActivity(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<AdherenceRecord[]> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);

    const data = await this.prisma.medicationDose.findMany({
      where: {
        userId,
        OR: [
          { takenAt: { gte: cutoffDate } },
          { scheduledTime: { gte: cutoffDate } },
        ],
      },
      orderBy: [{ takenAt: 'desc' }, { scheduledTime: 'desc' }],
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findRecentlyTaken(
    userId: string,
    hours: number,
    limit?: number,
  ): Promise<AdherenceRecord[]> {
    const cutoffTime = new Date();
    cutoffTime.setHours(cutoffTime.getHours() - hours);

    const data = await this.prisma.medicationDose.findMany({
      where: {
        userId,
        status: DoseStatus.TAKEN,
        takenAt: { gte: cutoffTime },
      },
      orderBy: { takenAt: 'desc' },
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findRecentlyMissed(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<AdherenceRecord[]> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);

    const data = await this.prisma.medicationDose.findMany({
      where: {
        userId,
        status: DoseStatus.MISSED,
        scheduledTime: { gte: cutoffDate },
      },
      orderBy: { scheduledTime: 'desc' },
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  // Reminder-related queries
  async findRecordsWithReminders(userId: string): Promise<AdherenceRecord[]> {
    const data = await this.prisma.medicationDose.findMany({
      where: {
        userId,
        reminderId: { not: null },
      },
      orderBy: { scheduledTime: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findRecordsNeedingReminders(
    userId: string,
  ): Promise<AdherenceRecord[]> {
    const now = new Date();
    const reminderWindow = new Date(now.getTime() + 30 * 60 * 1000); // 30 minutes ahead

    const data = await this.prisma.medicationDose.findMany({
      where: {
        userId,
        status: DoseStatus.SCHEDULED,
        scheduledTime: {
          gte: now,
          lte: reminderWindow,
        },
        reminderId: null,
      },
      orderBy: { scheduledTime: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  // Count operations
  async getAdherenceCount(
    userId: string,
    status?: DoseStatus,
    startDate?: Date,
    endDate?: Date,
  ): Promise<number> {
    const where: Prisma.MedicationDoseWhereInput = { userId };

    if (status) where.status = status;

    if (startDate || endDate) {
      where.scheduledTime = {};
      if (startDate) where.scheduledTime.gte = startDate;
      if (endDate) where.scheduledTime.lte = endDate;
    }

    return this.prisma.medicationDose.count({ where });
  }

  async getDailyAdherenceCount(
    userId: string,
    date: Date,
  ): Promise<{
    scheduled: number;
    taken: number;
    missed: number;
    skipped: number;
  }> {
    const startOfDay = new Date(date);
    startOfDay.setHours(0, 0, 0, 0);
    const endOfDay = new Date(date);
    endOfDay.setHours(23, 59, 59, 999);

    const where = {
      userId,
      scheduledTime: {
        gte: startOfDay,
        lte: endOfDay,
      },
    };

    const [scheduled, taken, missed, skipped] = await Promise.all([
      this.prisma.medicationDose.count({
        where: { ...where, status: DoseStatus.SCHEDULED },
      }),
      this.prisma.medicationDose.count({
        where: { ...where, status: DoseStatus.TAKEN },
      }),
      this.prisma.medicationDose.count({
        where: { ...where, status: DoseStatus.MISSED },
      }),
      this.prisma.medicationDose.count({
        where: { ...where, status: DoseStatus.SKIPPED },
      }),
    ]);

    return { scheduled, taken, missed, skipped };
  }
}
