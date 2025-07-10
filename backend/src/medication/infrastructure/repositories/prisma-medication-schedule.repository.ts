import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { MedicationSchedule } from '../../domain/entities/medication-schedule.entity';
import {
  MedicationScheduleRepository,
  ScheduleQuery,
  ScheduleStatistics,
} from '../../domain/repositories/medication-schedule.repository';
import {
  MedicationSchedule as PrismaMedicationSchedule,
  Prisma,
} from '@prisma/client';
import {
  DosageSchedule,
  Time,
  ReminderSettings,
} from '../../domain/entities/medication-schedule.entity';

@Injectable()
export class PrismaMedicationScheduleRepository extends MedicationScheduleRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async create(schedule: MedicationSchedule): Promise<MedicationSchedule> {
    const data = await this.prisma.medicationSchedule.create({
      data: {
        id: schedule.id,
        medicationId: schedule.medicationId,
        userId: schedule.userId,
        instructions: schedule.instructions,
        remindersEnabled: schedule.remindersEnabled,
        startDate: schedule.startDate,
        endDate: schedule.endDate,
        schedule: schedule.schedule as unknown as Prisma.InputJsonValue,
        reminderTimes:
          schedule.reminderTimes as unknown as Prisma.InputJsonValue,
        reminderSettings:
          schedule.reminderSettings as unknown as Prisma.InputJsonValue,
        createdAt: schedule.createdAt,
        updatedAt: schedule.updatedAt,
      },
    });

    return this.mapToEntity(data);
  }

  async createMany(
    schedules: MedicationSchedule[],
  ): Promise<MedicationSchedule[]> {
    await this.prisma.medicationSchedule.createMany({
      data: schedules.map((schedule) => ({
        id: schedule.id,
        medicationId: schedule.medicationId,
        userId: schedule.userId,
        instructions: schedule.instructions,
        remindersEnabled: schedule.remindersEnabled,
        startDate: schedule.startDate,
        endDate: schedule.endDate,
        schedule: schedule.schedule as unknown as Prisma.InputJsonValue,
        reminderTimes:
          schedule.reminderTimes as unknown as Prisma.InputJsonValue,
        reminderSettings:
          schedule.reminderSettings as unknown as Prisma.InputJsonValue,
        createdAt: schedule.createdAt,
        updatedAt: schedule.updatedAt,
      })),
    });

    // Return the created schedules by finding them
    const createdSchedules = await this.prisma.medicationSchedule.findMany({
      where: {
        id: { in: schedules.map((s) => s.id) },
      },
    });

    return createdSchedules.map((data) => this.mapToEntity(data));
  }

  async findById(id: string): Promise<MedicationSchedule | null> {
    const data = await this.prisma.medicationSchedule.findUnique({
      where: { id },
    });

    return data ? this.mapToEntity(data) : null;
  }

  async findMany(query: ScheduleQuery): Promise<MedicationSchedule[]> {
    const where: Prisma.MedicationScheduleWhereInput = {
      userId: query.userId,
    };

    if (query.medicationId) {
      where.medicationId = query.medicationId;
    }

    if (query.remindersEnabled !== undefined) {
      where.remindersEnabled = query.remindersEnabled;
    }

    if (query.startDate || query.endDate) {
      where.startDate = {};
      if (query.startDate) where.startDate.gte = query.startDate;
      if (query.endDate) where.startDate.lte = query.endDate;
    }

    // Filter by active status (schedules that haven't ended)
    if (query.isActive !== undefined) {
      if (query.isActive) {
        where.OR = [{ endDate: null }, { endDate: { gt: new Date() } }];
      } else {
        where.endDate = { lte: new Date() };
      }
    }

    const data = await this.prisma.medicationSchedule.findMany({
      where,
      orderBy: { createdAt: 'desc' },
      take: query.limit,
      skip: query.offset,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async update(
    id: string,
    updates: Partial<MedicationSchedule>,
  ): Promise<MedicationSchedule> {
    const data = await this.prisma.medicationSchedule.update({
      where: { id },
      data: {
        instructions: updates.instructions,
        remindersEnabled: updates.remindersEnabled,
        endDate: updates.endDate,
        schedule: updates.schedule as unknown as Prisma.InputJsonValue,
        reminderTimes:
          updates.reminderTimes as unknown as Prisma.InputJsonValue,
        reminderSettings:
          updates.reminderSettings as unknown as Prisma.InputJsonValue,
        updatedAt: new Date(),
      },
    });

    return this.mapToEntity(data);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.medicationSchedule.delete({
      where: { id },
    });
  }

  async deleteMany(ids: string[]): Promise<void> {
    await this.prisma.medicationSchedule.deleteMany({
      where: {
        id: { in: ids },
      },
    });
  }

  async findByUserId(
    userId: string,
    includeInactive?: boolean,
  ): Promise<MedicationSchedule[]> {
    const where: Prisma.MedicationScheduleWhereInput = { userId };

    if (!includeInactive) {
      where.OR = [{ endDate: null }, { endDate: { gt: new Date() } }];
    }

    const data = await this.prisma.medicationSchedule.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findActiveByUserId(userId: string): Promise<MedicationSchedule[]> {
    const now = new Date();
    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        userId,
        startDate: { lte: now },
        OR: [{ endDate: null }, { endDate: { gt: now } }],
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findInactiveByUserId(userId: string): Promise<MedicationSchedule[]> {
    const now = new Date();
    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        userId,
        endDate: { lte: now },
      },
      orderBy: { endDate: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByMedicationId(
    medicationId: string,
  ): Promise<MedicationSchedule[]> {
    const data = await this.prisma.medicationSchedule.findMany({
      where: { medicationId },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findActiveMedicationSchedules(
    medicationId: string,
  ): Promise<MedicationSchedule[]> {
    const now = new Date();
    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        medicationId,
        startDate: { lte: now },
        OR: [{ endDate: null }, { endDate: { gt: now } }],
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findWithRemindersEnabled(
    userId: string,
  ): Promise<MedicationSchedule[]> {
    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        userId,
        remindersEnabled: true,
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findWithRemindersDisabled(
    userId: string,
  ): Promise<MedicationSchedule[]> {
    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        userId,
        remindersEnabled: false,
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findSchedulesNeedingReminders(
    userId: string,
    _withinMinutes: number,
  ): Promise<MedicationSchedule[]> {
    // This is a complex query that would need to examine the schedule JSON
    // For now, return active schedules with reminders enabled
    const now = new Date();
    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        userId,
        remindersEnabled: true,
        startDate: { lte: now },
        OR: [{ endDate: null }, { endDate: { gt: now } }],
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  private mapToEntity(data: PrismaMedicationSchedule): MedicationSchedule {
    return new MedicationSchedule(
      data.id,
      data.medicationId,
      data.userId,
      data.instructions,
      data.remindersEnabled,
      data.startDate,
      data.endDate,
      data.schedule as unknown as DosageSchedule,
      data.reminderTimes as unknown as Time[],
      data.reminderSettings as unknown as ReminderSettings,
      data.createdAt,
      data.updatedAt,
    );
  }

  // Time-based queries
  async findSchedulesForDate(
    userId: string,
    date: Date,
  ): Promise<MedicationSchedule[]> {
    const startOfDay = new Date(date);
    startOfDay.setHours(0, 0, 0, 0);
    const endOfDay = new Date(date);
    endOfDay.setHours(23, 59, 59, 999);

    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        userId,
        startDate: { lte: endOfDay },
        OR: [{ endDate: null }, { endDate: { gte: startOfDay } }],
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findSchedulesForDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<MedicationSchedule[]> {
    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        userId,
        startDate: { lte: endDate },
        OR: [{ endDate: null }, { endDate: { gte: startDate } }],
      },
      orderBy: { startDate: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findUpcomingSchedules(
    userId: string,
    withinHours: number,
  ): Promise<MedicationSchedule[]> {
    const now = new Date();
    const futureTime = new Date(now.getTime() + withinHours * 60 * 60 * 1000);

    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        userId,
        startDate: { lte: futureTime },
        OR: [{ endDate: null }, { endDate: { gte: now } }],
        remindersEnabled: true,
      },
      orderBy: { startDate: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  // Frequency-based queries
  async findDailySchedules(userId: string): Promise<MedicationSchedule[]> {
    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        userId,
        // This would require checking the schedule JSON field for frequency
        // For now, return all active schedules
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findWeeklySchedules(_userId: string): Promise<MedicationSchedule[]> {
    // Placeholder implementation
    return Promise.resolve([]);
  }

  async findMonthlySchedules(_userId: string): Promise<MedicationSchedule[]> {
    // Placeholder implementation
    return Promise.resolve([]);
  }

  async findAsNeededSchedules(_userId: string): Promise<MedicationSchedule[]> {
    // Placeholder implementation
    return Promise.resolve([]);
  }

  // Status queries
  async findExpiredSchedules(userId: string): Promise<MedicationSchedule[]> {
    const now = new Date();
    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        userId,
        endDate: { lt: now },
      },
      orderBy: { endDate: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findExpiringSchedules(
    userId: string,
    withinDays: number,
  ): Promise<MedicationSchedule[]> {
    const now = new Date();
    const futureDate = new Date(
      now.getTime() + withinDays * 24 * 60 * 60 * 1000,
    );

    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        userId,
        endDate: {
          gte: now,
          lte: futureDate,
        },
      },
      orderBy: { endDate: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findOverdueSchedules(_userId: string): Promise<MedicationSchedule[]> {
    // This would require complex logic to determine overdue schedules
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  // Statistics and analytics
  async getScheduleStatistics(userId: string): Promise<ScheduleStatistics> {
    const [totalSchedules, activeSchedules, schedulesWithReminders] =
      await Promise.all([
        this.prisma.medicationSchedule.count({ where: { userId } }),
        this.prisma.medicationSchedule.count({
          where: {
            userId,
            OR: [{ endDate: null }, { endDate: { gte: new Date() } }],
          },
        }),
        this.prisma.medicationSchedule.count({
          where: { userId, remindersEnabled: true },
        }),
      ]);

    return {
      totalSchedules,
      activeSchedules,
      inactiveSchedules: totalSchedules - activeSchedules,
      schedulesWithReminders,
      schedulesByFrequency: {},
      averageDurationDays: 0,
      upcomingDoses: 0,
    };
  }

  async getScheduleCount(userId: string, isActive?: boolean): Promise<number> {
    const where: Prisma.MedicationScheduleWhereInput = { userId };

    if (isActive !== undefined) {
      if (isActive) {
        where.OR = [{ endDate: null }, { endDate: { gte: new Date() } }];
      } else {
        where.endDate = { lt: new Date() };
      }
    }

    return this.prisma.medicationSchedule.count({ where });
  }

  async getSchedulesByFrequencyCount(
    _userId: string,
  ): Promise<Record<string, number>> {
    // This would require parsing the schedule JSON field
    // For now, return empty object as placeholder
    return Promise.resolve({});
  }

  // Adherence-related queries
  async findSchedulesWithPoorAdherence(
    _userId: string,
    _adherenceThreshold: number,
    _days: number,
  ): Promise<MedicationSchedule[]> {
    // This would require complex adherence calculation
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  async findMostAdherentSchedules(
    _userId: string,
    _limit?: number,
  ): Promise<MedicationSchedule[]> {
    // This would require complex adherence calculation
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  // Conflict detection
  async findConflictingSchedules(
    _userId: string,
    _newSchedule: MedicationSchedule,
  ): Promise<MedicationSchedule[]> {
    // This would require complex schedule conflict detection
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  async findOverlappingSchedules(
    _userId: string,
  ): Promise<MedicationSchedule[][]> {
    // This would require complex overlap detection
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  // Recent activity
  async findRecentlyAdded(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<MedicationSchedule[]> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);

    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        userId,
        createdAt: { gte: cutoffDate },
      },
      orderBy: { createdAt: 'desc' },
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findRecentlyModified(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<MedicationSchedule[]> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);

    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        userId,
        updatedAt: { gte: cutoffDate },
      },
      orderBy: { updatedAt: 'desc' },
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findRecentlyDeactivated(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<MedicationSchedule[]> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);

    const data = await this.prisma.medicationSchedule.findMany({
      where: {
        userId,
        endDate: {
          gte: cutoffDate,
          lt: new Date(),
        },
      },
      orderBy: { endDate: 'desc' },
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }
}
