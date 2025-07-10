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

  async update(id: string, updates: Partial<AdherenceRecord>): Promise<AdherenceRecord> {
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

  async findByStatus(userId: string, status: DoseStatus): Promise<AdherenceRecord[]> {
    const data = await this.prisma.medicationDose.findMany({
      where: {
        userId,
        status,
      },
      orderBy: { scheduledTime: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findTakenDoses(userId: string, startDate?: Date, endDate?: Date): Promise<AdherenceRecord[]> {
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

  async findMissedDoses(userId: string, startDate?: Date, endDate?: Date): Promise<AdherenceRecord[]> {
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

  async findSkippedDoses(userId: string, startDate?: Date, endDate?: Date): Promise<AdherenceRecord[]> {
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
}
