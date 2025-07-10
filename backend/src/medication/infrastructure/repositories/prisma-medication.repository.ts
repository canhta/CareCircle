import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { Medication } from '../../domain/entities/medication.entity';
import {
  MedicationRepository,
  MedicationQuery,
  MedicationStatistics,
} from '../../domain/repositories/medication.repository';
import {
  Medication as PrismaMedication,
  MedicationForm,
  Prisma,
} from '@prisma/client';

@Injectable()
export class PrismaMedicationRepository extends MedicationRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async create(medication: Medication): Promise<Medication> {
    const data = await this.prisma.medication.create({
      data: {
        id: medication.id,
        userId: medication.userId,
        name: medication.name,
        genericName: medication.genericName,
        strength: medication.strength,
        form: medication.form,
        manufacturer: medication.manufacturer,
        rxNormCode: medication.rxNormCode,
        ndcCode: medication.ndcCode,
        classification: medication.classification,
        isActive: medication.isActive,
        startDate: medication.startDate,
        endDate: medication.endDate,
        prescriptionId: medication.prescriptionId,
        notes: medication.notes,
        createdAt: medication.createdAt,
        updatedAt: medication.updatedAt,
      },
    });

    return this.mapToEntity(data);
  }

  async createMany(medications: Medication[]): Promise<Medication[]> {
    await this.prisma.medication.createMany({
      data: medications.map((medication) => ({
        id: medication.id,
        userId: medication.userId,
        name: medication.name,
        genericName: medication.genericName,
        strength: medication.strength,
        form: medication.form,
        manufacturer: medication.manufacturer,
        rxNormCode: medication.rxNormCode,
        ndcCode: medication.ndcCode,
        classification: medication.classification,
        isActive: medication.isActive,
        startDate: medication.startDate,
        endDate: medication.endDate,
        prescriptionId: medication.prescriptionId,
        notes: medication.notes,
        createdAt: medication.createdAt,
        updatedAt: medication.updatedAt,
      })),
    });

    // Return the created medications by finding them
    const createdMedications = await this.prisma.medication.findMany({
      where: {
        id: { in: medications.map((m) => m.id) },
      },
    });

    return createdMedications.map((data) => this.mapToEntity(data));
  }

  async findById(id: string): Promise<Medication | null> {
    const data = await this.prisma.medication.findUnique({
      where: { id },
    });

    return data ? this.mapToEntity(data) : null;
  }

  async findMany(query: MedicationQuery): Promise<Medication[]> {
    const where: Prisma.MedicationWhereInput = {
      userId: query.userId,
    };

    if (query.isActive !== undefined) {
      where.isActive = query.isActive;
    }

    if (query.form) {
      where.form = query.form;
    }

    if (query.prescriptionId) {
      where.prescriptionId = query.prescriptionId;
    }

    if (query.startDate || query.endDate) {
      where.startDate = {};
      if (query.startDate) where.startDate.gte = query.startDate;
      if (query.endDate) where.startDate.lte = query.endDate;
    }

    if (query.searchTerm) {
      where.OR = [
        { name: { contains: query.searchTerm, mode: 'insensitive' } },
        { genericName: { contains: query.searchTerm, mode: 'insensitive' } },
        { classification: { contains: query.searchTerm, mode: 'insensitive' } },
      ];
    }

    const data = await this.prisma.medication.findMany({
      where,
      orderBy: { createdAt: 'desc' },
      take: query.limit,
      skip: query.offset,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async update(id: string, updates: Partial<Medication>): Promise<Medication> {
    const data = await this.prisma.medication.update({
      where: { id },
      data: {
        name: updates.name,
        genericName: updates.genericName,
        strength: updates.strength,
        form: updates.form,
        manufacturer: updates.manufacturer,
        rxNormCode: updates.rxNormCode,
        ndcCode: updates.ndcCode,
        classification: updates.classification,
        isActive: updates.isActive,
        endDate: updates.endDate,
        notes: updates.notes,
        updatedAt: new Date(),
      },
    });

    return this.mapToEntity(data);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.medication.delete({
      where: { id },
    });
  }

  async deleteMany(ids: string[]): Promise<void> {
    await this.prisma.medication.deleteMany({
      where: {
        id: { in: ids },
      },
    });
  }

  async findByUserId(
    userId: string,
    includeInactive?: boolean,
  ): Promise<Medication[]> {
    const where: Prisma.MedicationWhereInput = { userId };

    if (!includeInactive) {
      where.isActive = true;
    }

    const data = await this.prisma.medication.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findActiveByUserId(userId: string): Promise<Medication[]> {
    const data = await this.prisma.medication.findMany({
      where: {
        userId,
        isActive: true,
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findInactiveByUserId(userId: string): Promise<Medication[]> {
    const data = await this.prisma.medication.findMany({
      where: {
        userId,
        isActive: false,
      },
      orderBy: { updatedAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByPrescriptionId(prescriptionId: string): Promise<Medication[]> {
    const data = await this.prisma.medication.findMany({
      where: { prescriptionId },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findWithoutPrescription(userId: string): Promise<Medication[]> {
    const data = await this.prisma.medication.findMany({
      where: {
        userId,
        prescriptionId: null,
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async searchByName(
    userId: string,
    searchTerm: string,
    limit?: number,
  ): Promise<Medication[]> {
    const data = await this.prisma.medication.findMany({
      where: {
        userId,
        OR: [
          { name: { contains: searchTerm, mode: 'insensitive' } },
          { genericName: { contains: searchTerm, mode: 'insensitive' } },
        ],
      },
      orderBy: { name: 'asc' },
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByForm(
    userId: string,
    form: MedicationForm,
  ): Promise<Medication[]> {
    const data = await this.prisma.medication.findMany({
      where: {
        userId,
        form,
      },
      orderBy: { name: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByClassification(
    userId: string,
    classification: string,
  ): Promise<Medication[]> {
    const data = await this.prisma.medication.findMany({
      where: {
        userId,
        classification: { contains: classification, mode: 'insensitive' },
      },
      orderBy: { name: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findStartingInDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<Medication[]> {
    const data = await this.prisma.medication.findMany({
      where: {
        userId,
        startDate: {
          gte: startDate,
          lte: endDate,
        },
      },
      orderBy: { startDate: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findEndingInDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<Medication[]> {
    const data = await this.prisma.medication.findMany({
      where: {
        userId,
        endDate: {
          gte: startDate,
          lte: endDate,
        },
      },
      orderBy: { endDate: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findExpiredMedications(userId: string): Promise<Medication[]> {
    const now = new Date();
    const data = await this.prisma.medication.findMany({
      where: {
        userId,
        endDate: {
          lt: now,
        },
      },
      orderBy: { endDate: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findExpiringMedications(
    userId: string,
    withinDays: number,
  ): Promise<Medication[]> {
    const now = new Date();
    const futureDate = new Date(
      now.getTime() + withinDays * 24 * 60 * 60 * 1000,
    );

    const data = await this.prisma.medication.findMany({
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

  async findByRxNormCode(rxNormCode: string): Promise<Medication[]> {
    const data = await this.prisma.medication.findMany({
      where: { rxNormCode },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByNdcCode(ndcCode: string): Promise<Medication[]> {
    const data = await this.prisma.medication.findMany({
      where: { ndcCode },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findSimilarMedications(
    userId: string,
    name: string,
    strength: string,
    form: MedicationForm,
  ): Promise<Medication[]> {
    const data = await this.prisma.medication.findMany({
      where: {
        userId,
        OR: [
          {
            name: { contains: name, mode: 'insensitive' },
            strength,
            form,
          },
          {
            genericName: { contains: name, mode: 'insensitive' },
            strength,
            form,
          },
        ],
      },
      orderBy: { name: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async getMedicationStatistics(userId: string): Promise<MedicationStatistics> {
    const [total, active, inactive, formCounts, prescriptionBased] =
      await Promise.all([
        this.prisma.medication.count({ where: { userId } }),
        this.prisma.medication.count({ where: { userId, isActive: true } }),
        this.prisma.medication.count({ where: { userId, isActive: false } }),
        this.getMedicationsByFormCount(userId),
        this.prisma.medication.count({
          where: {
            userId,
            prescriptionId: { not: null },
          },
        }),
      ]);

    // Calculate average duration for medications with end dates
    const medicationsWithDuration = await this.prisma.medication.findMany({
      where: {
        userId,
        endDate: { not: null },
      },
      select: {
        startDate: true,
        endDate: true,
      },
    });

    const averageDurationDays =
      medicationsWithDuration.length > 0
        ? medicationsWithDuration.reduce((sum, med) => {
            const duration = med.endDate!.getTime() - med.startDate.getTime();
            return sum + Math.ceil(duration / (1000 * 60 * 60 * 24));
          }, 0) / medicationsWithDuration.length
        : 0;

    return {
      totalMedications: total,
      activeMedications: active,
      inactiveMedications: inactive,
      medicationsByForm: formCounts,
      prescriptionBasedCount: prescriptionBased,
      averageDurationDays: Math.round(averageDurationDays),
    };
  }

  async getMedicationCount(
    userId: string,
    isActive?: boolean,
  ): Promise<number> {
    const where: Prisma.MedicationWhereInput = { userId };
    if (isActive !== undefined) where.isActive = isActive;

    return this.prisma.medication.count({ where });
  }

  async getMedicationsByFormCount(
    userId: string,
  ): Promise<Record<MedicationForm, number>> {
    const result = await this.prisma.medication.groupBy({
      by: ['form'],
      where: { userId },
      _count: { form: true },
    });

    const formCounts = {} as Record<MedicationForm, number>;

    // Initialize all forms with 0
    Object.values(MedicationForm).forEach((form) => {
      formCounts[form] = 0;
    });

    // Fill in actual counts
    result.forEach((item) => {
      formCounts[item.form] = item._count.form;
    });

    return formCounts;
  }

  async findMedicationsNeedingReview(userId: string): Promise<Medication[]> {
    const data = await this.prisma.medication.findMany({
      where: {
        userId,
        OR: [
          { rxNormCode: null },
          { classification: null },
          { genericName: null },
        ],
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findDuplicateMedications(userId: string): Promise<Medication[][]> {
    // Find medications with same name, strength, and form
    const duplicateGroups = await this.prisma.medication.groupBy({
      by: ['name', 'strength', 'form'],
      where: { userId },
      having: {
        name: { _count: { gt: 1 } },
      },
    });

    const duplicates: Medication[][] = [];

    for (const group of duplicateGroups) {
      const medications = await this.prisma.medication.findMany({
        where: {
          userId,
          name: group.name,
          strength: group.strength,
          form: group.form,
        },
        orderBy: { createdAt: 'asc' },
      });

      if (medications.length > 1) {
        duplicates.push(medications.map((item) => this.mapToEntity(item)));
      }
    }

    return duplicates;
  }

  async findRecentlyAdded(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<Medication[]> {
    const cutoffDate = new Date(Date.now() - days * 24 * 60 * 60 * 1000);

    const data = await this.prisma.medication.findMany({
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
  ): Promise<Medication[]> {
    const cutoffDate = new Date(Date.now() - days * 24 * 60 * 60 * 1000);

    const data = await this.prisma.medication.findMany({
      where: {
        userId,
        updatedAt: { gte: cutoffDate },
        createdAt: { not: { gte: cutoffDate } }, // Exclude recently created
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
  ): Promise<Medication[]> {
    const cutoffDate = new Date(Date.now() - days * 24 * 60 * 60 * 1000);

    const data = await this.prisma.medication.findMany({
      where: {
        userId,
        isActive: false,
        updatedAt: { gte: cutoffDate },
      },
      orderBy: { updatedAt: 'desc' },
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  private mapToEntity(data: PrismaMedication): Medication {
    return new Medication(
      data.id,
      data.userId,
      data.name,
      data.genericName,
      data.strength,
      data.form,
      data.manufacturer,
      data.rxNormCode,
      data.ndcCode,
      data.classification,
      data.isActive,
      data.startDate,
      data.endDate,
      data.prescriptionId,
      data.notes,
      data.createdAt,
      data.updatedAt,
    );
  }
}
