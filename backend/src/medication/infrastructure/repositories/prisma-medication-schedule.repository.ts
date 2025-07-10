import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { MedicationSchedule } from '../../domain/entities/medication-schedule.entity';
import {
  MedicationScheduleRepository,
  ScheduleQuery,
} from '../../domain/repositories/medication-schedule.repository';
import {
  MedicationSchedule as PrismaMedicationSchedule,
  Prisma,
} from '@prisma/client';

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
        schedule: schedule.schedule,
        reminderTimes: schedule.reminderTimes,
        reminderSettings: schedule.reminderSettings,
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
        schedule: schedule.schedule,
        reminderTimes: schedule.reminderTimes,
        reminderSettings: schedule.reminderSettings,
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
        schedule: updates.schedule,
        reminderTimes: updates.reminderTimes,
        reminderSettings: updates.reminderSettings,
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
      data.schedule,
      data.reminderTimes,
      data.reminderSettings,
      data.createdAt,
      data.updatedAt,
    );
  }
}
