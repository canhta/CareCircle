import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import {
  Prescription,
  OCRData,
  PrescriptionMedication,
} from '../../domain/entities/prescription.entity';
import {
  PrescriptionRepository,
  PrescriptionQuery,
  PrescriptionStatistics,
} from '../../domain/repositories/prescription.repository';
import { Prescription as PrismaPrescription, Prisma } from '@prisma/client';

@Injectable()
export class PrismaPrescriptionRepository extends PrescriptionRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async create(prescription: Prescription): Promise<Prescription> {
    const data = await this.prisma.prescription.create({
      data: {
        id: prescription.id,
        userId: prescription.userId,
        prescribedBy: prescription.prescribedBy,
        prescribedDate: prescription.prescribedDate,
        pharmacy: prescription.pharmacy,
        ocrData: prescription.ocrData as unknown as Prisma.InputJsonValue,
        imageUrl: prescription.imageUrl,
        isVerified: prescription.isVerified,
        verifiedAt: prescription.verifiedAt,
        verifiedBy: prescription.verifiedBy,
        medications:
          prescription.medications as unknown as Prisma.InputJsonValue,
        createdAt: prescription.createdAt,
        updatedAt: prescription.updatedAt,
      },
    });

    return this.mapToEntity(data);
  }

  async createMany(prescriptions: Prescription[]): Promise<Prescription[]> {
    await this.prisma.prescription.createMany({
      data: prescriptions.map((prescription) => ({
        id: prescription.id,
        userId: prescription.userId,
        prescribedBy: prescription.prescribedBy,
        prescribedDate: prescription.prescribedDate,
        pharmacy: prescription.pharmacy,
        ocrData: prescription.ocrData as unknown as Prisma.InputJsonValue,
        imageUrl: prescription.imageUrl,
        isVerified: prescription.isVerified,
        verifiedAt: prescription.verifiedAt,
        verifiedBy: prescription.verifiedBy,
        medications:
          prescription.medications as unknown as Prisma.InputJsonValue,
        createdAt: prescription.createdAt,
        updatedAt: prescription.updatedAt,
      })),
    });

    // Return the created prescriptions by finding them
    const createdPrescriptions = await this.prisma.prescription.findMany({
      where: {
        id: { in: prescriptions.map((p) => p.id) },
      },
    });

    return createdPrescriptions.map((data) => this.mapToEntity(data));
  }

  async findById(id: string): Promise<Prescription | null> {
    const data = await this.prisma.prescription.findUnique({
      where: { id },
    });

    return data ? this.mapToEntity(data) : null;
  }

  async findMany(query: PrescriptionQuery): Promise<Prescription[]> {
    const where: Prisma.PrescriptionWhereInput = {
      userId: query.userId,
    };

    if (query.prescribedBy) {
      where.prescribedBy = {
        contains: query.prescribedBy,
        mode: 'insensitive',
      };
    }

    if (query.pharmacy) {
      where.pharmacy = { contains: query.pharmacy, mode: 'insensitive' };
    }

    if (query.isVerified !== undefined) {
      where.isVerified = query.isVerified;
    }

    if (query.hasOCRData !== undefined) {
      where.ocrData = query.hasOCRData
        ? { not: Prisma.JsonNull }
        : { equals: Prisma.JsonNull };
    }

    if (query.hasImage !== undefined) {
      where.imageUrl = query.hasImage ? { not: null } : null;
    }

    if (query.startDate || query.endDate) {
      where.prescribedDate = {};
      if (query.startDate) where.prescribedDate.gte = query.startDate;
      if (query.endDate) where.prescribedDate.lte = query.endDate;
    }

    if (query.searchTerm) {
      where.OR = [
        { prescribedBy: { contains: query.searchTerm, mode: 'insensitive' } },
        { pharmacy: { contains: query.searchTerm, mode: 'insensitive' } },
      ];
    }

    const data = await this.prisma.prescription.findMany({
      where,
      orderBy: { prescribedDate: 'desc' },
      take: query.limit,
      skip: query.offset,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async update(
    id: string,
    updates: Partial<Prescription>,
  ): Promise<Prescription> {
    const data = await this.prisma.prescription.update({
      where: { id },
      data: {
        prescribedBy: updates.prescribedBy,
        prescribedDate: updates.prescribedDate,
        pharmacy: updates.pharmacy,
        ocrData: updates.ocrData as unknown as Prisma.InputJsonValue,
        imageUrl: updates.imageUrl,
        isVerified: updates.isVerified,
        verifiedAt: updates.verifiedAt,
        verifiedBy: updates.verifiedBy,
        medications: updates.medications as unknown as Prisma.InputJsonValue,
        updatedAt: new Date(),
      },
    });

    return this.mapToEntity(data);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.prescription.delete({
      where: { id },
    });
  }

  async deleteMany(ids: string[]): Promise<void> {
    await this.prisma.prescription.deleteMany({
      where: {
        id: { in: ids },
      },
    });
  }

  async findByUserId(userId: string): Promise<Prescription[]> {
    const data = await this.prisma.prescription.findMany({
      where: { userId },
      orderBy: { prescribedDate: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findRecentByUserId(
    userId: string,
    limit?: number,
  ): Promise<Prescription[]> {
    const data = await this.prisma.prescription.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findUnverified(userId?: string): Promise<Prescription[]> {
    const where: Prisma.PrescriptionWhereInput = {
      isVerified: false,
    };

    if (userId) {
      where.userId = userId;
    }

    const data = await this.prisma.prescription.findMany({
      where,
      orderBy: { createdAt: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findVerified(userId?: string): Promise<Prescription[]> {
    const where: Prisma.PrescriptionWhereInput = {
      isVerified: true,
    };

    if (userId) {
      where.userId = userId;
    }

    const data = await this.prisma.prescription.findMany({
      where,
      orderBy: { verifiedAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findPendingVerification(userId: string): Promise<Prescription[]> {
    const data = await this.prisma.prescription.findMany({
      where: {
        userId,
        isVerified: false,
        OR: [
          { ocrData: { not: Prisma.JsonNull } },
          { imageUrl: { not: null } },
        ],
      },
      orderBy: { createdAt: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findWithOCRData(userId?: string): Promise<Prescription[]> {
    const where: Prisma.PrescriptionWhereInput = {
      ocrData: { not: Prisma.JsonNull },
    };

    if (userId) {
      where.userId = userId;
    }

    const data = await this.prisma.prescription.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findWithoutOCRData(userId?: string): Promise<Prescription[]> {
    const where: Prisma.PrescriptionWhereInput = {
      ocrData: { equals: Prisma.JsonNull },
    };

    if (userId) {
      where.userId = userId;
    }

    const data = await this.prisma.prescription.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findWithImages(userId?: string): Promise<Prescription[]> {
    const where: Prisma.PrescriptionWhereInput = {
      imageUrl: { not: null },
    };

    if (userId) {
      where.userId = userId;
    }

    const data = await this.prisma.prescription.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findWithoutImages(userId?: string): Promise<Prescription[]> {
    const where: Prisma.PrescriptionWhereInput = {
      imageUrl: null,
    };

    if (userId) {
      where.userId = userId;
    }

    const data = await this.prisma.prescription.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByPrescriber(
    userId: string,
    prescriberName: string,
  ): Promise<Prescription[]> {
    const data = await this.prisma.prescription.findMany({
      where: {
        userId,
        prescribedBy: { contains: prescriberName, mode: 'insensitive' },
      },
      orderBy: { prescribedDate: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByPharmacy(
    userId: string,
    pharmacyName: string,
  ): Promise<Prescription[]> {
    const data = await this.prisma.prescription.findMany({
      where: {
        userId,
        pharmacy: { contains: pharmacyName, mode: 'insensitive' },
      },
      orderBy: { prescribedDate: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async getUniquePrescribers(userId: string): Promise<string[]> {
    const result = await this.prisma.prescription.findMany({
      where: { userId },
      select: { prescribedBy: true },
      distinct: ['prescribedBy'],
      orderBy: { prescribedBy: 'asc' },
    });

    return result.map((item) => item.prescribedBy);
  }

  async getUniquePharmacies(userId: string): Promise<string[]> {
    const result = await this.prisma.prescription.findMany({
      where: {
        userId,
        pharmacy: { not: null },
      },
      select: { pharmacy: true },
      distinct: ['pharmacy'],
      orderBy: { pharmacy: 'asc' },
    });

    return result.map((item) => item.pharmacy!);
  }

  async findByDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<Prescription[]> {
    const data = await this.prisma.prescription.findMany({
      where: {
        userId,
        prescribedDate: {
          gte: startDate,
          lte: endDate,
        },
      },
      orderBy: { prescribedDate: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findExpired(
    userId: string,
    expirationMonths: number = 12,
  ): Promise<Prescription[]> {
    const expirationDate = new Date();
    expirationDate.setMonth(expirationDate.getMonth() - expirationMonths);

    const data = await this.prisma.prescription.findMany({
      where: {
        userId,
        prescribedDate: { lt: expirationDate },
      },
      orderBy: { prescribedDate: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findExpiringMedications(
    userId: string,
    withinMonths: number,
  ): Promise<Prescription[]> {
    const now = new Date();
    const futureDate = new Date();
    futureDate.setMonth(futureDate.getMonth() + withinMonths);

    // Find prescriptions that will expire within the specified months
    const expirationDate = new Date();
    expirationDate.setMonth(expirationDate.getMonth() - 12 + withinMonths);

    const data = await this.prisma.prescription.findMany({
      where: {
        userId,
        prescribedDate: {
          gte: expirationDate,
          lt: now,
        },
      },
      orderBy: { prescribedDate: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async searchPrescriptions(
    userId: string,
    searchTerm: string,
    limit?: number,
  ): Promise<Prescription[]> {
    const data = await this.prisma.prescription.findMany({
      where: {
        userId,
        OR: [
          { prescribedBy: { contains: searchTerm, mode: 'insensitive' } },
          { pharmacy: { contains: searchTerm, mode: 'insensitive' } },
          // Search in medications JSON array would require raw SQL for complex queries
        ],
      },
      orderBy: { prescribedDate: 'desc' },
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findByMedicationName(
    userId: string,
    medicationName: string,
  ): Promise<Prescription[]> {
    // This requires a more complex query to search within the JSON medications array
    // For now, we'll use a simple approach and filter in memory
    const allPrescriptions = await this.findByUserId(userId);

    return allPrescriptions.filter((prescription) =>
      prescription.medications.some((med) =>
        med.name.toLowerCase().includes(medicationName.toLowerCase()),
      ),
    );
  }

  async getPrescriptionStatistics(
    userId: string,
  ): Promise<PrescriptionStatistics> {
    const [total, verified, unverified, withOCR, withImages] =
      await Promise.all([
        this.prisma.prescription.count({ where: { userId } }),
        this.prisma.prescription.count({ where: { userId, isVerified: true } }),
        this.prisma.prescription.count({
          where: { userId, isVerified: false },
        }),
        this.prisma.prescription.count({
          where: { userId, ocrData: { not: Prisma.JsonNull } },
        }),
        this.prisma.prescription.count({
          where: { userId, imageUrl: { not: null } },
        }),
      ]);

    // Calculate average processing time for verified prescriptions
    const verifiedPrescriptions = await this.prisma.prescription.findMany({
      where: {
        userId,
        isVerified: true,
        verifiedAt: { not: null },
      },
      select: {
        createdAt: true,
        verifiedAt: true,
      },
    });

    const averageProcessingTime =
      verifiedPrescriptions.length > 0
        ? verifiedPrescriptions.reduce((sum, prescription) => {
            const processingTime =
              prescription.verifiedAt!.getTime() -
              prescription.createdAt.getTime();
            return sum + processingTime / (1000 * 60 * 60); // Convert to hours
          }, 0) / verifiedPrescriptions.length
        : 0;

    // Get top prescribers
    const prescriberCounts = await this.prisma.prescription.groupBy({
      by: ['prescribedBy'],
      where: { userId },
      _count: { prescribedBy: true },
      orderBy: { _count: { prescribedBy: 'desc' } },
      take: 5,
    });

    const topPrescribers = prescriberCounts.map((item) => ({
      name: item.prescribedBy,
      count: item._count.prescribedBy,
    }));

    // Get top pharmacies
    const pharmacyCounts = await this.prisma.prescription.groupBy({
      by: ['pharmacy'],
      where: {
        userId,
        pharmacy: { not: null },
      },
      _count: { pharmacy: true },
      orderBy: { _count: { pharmacy: 'desc' } },
      take: 5,
    });

    const topPharmacies = pharmacyCounts.map((item) => ({
      name: item.pharmacy!,
      count: item._count.pharmacy,
    }));

    return {
      totalPrescriptions: total,
      verifiedPrescriptions: verified,
      unverifiedPrescriptions: unverified,
      prescriptionsWithOCR: withOCR,
      prescriptionsWithImages: withImages,
      averageProcessingTime: Math.round(averageProcessingTime * 100) / 100,
      topPrescribers,
      topPharmacies,
    };
  }

  private mapToEntity(data: PrismaPrescription): Prescription {
    return new Prescription(
      data.id,
      data.userId,
      data.prescribedBy,
      data.prescribedDate,
      data.pharmacy,
      data.ocrData as OCRData | null,
      data.imageUrl,
      data.isVerified,
      data.verifiedAt,
      data.verifiedBy,
      data.medications as unknown as PrescriptionMedication[],
      data.createdAt,
      data.updatedAt,
    );
  }

  async getPrescriptionCount(
    userId: string,
    isVerified?: boolean,
  ): Promise<number> {
    const where: Prisma.PrescriptionWhereInput = { userId };
    if (isVerified !== undefined) {
      where.isVerified = isVerified;
    }
    return this.prisma.prescription.count({ where });
  }

  async getProcessingTimeStatistics(userId: string): Promise<{
    averageHours: number;
    medianHours: number;
    minHours: number;
    maxHours: number;
  }> {
    const prescriptions = await this.prisma.prescription.findMany({
      where: {
        userId,
        isVerified: true,
        verifiedAt: { not: null },
      },
      select: {
        createdAt: true,
        verifiedAt: true,
      },
    });

    if (prescriptions.length === 0) {
      return {
        averageHours: 0,
        medianHours: 0,
        minHours: 0,
        maxHours: 0,
      };
    }

    const processingTimes = prescriptions
      .filter((p) => p.verifiedAt)
      .map((p) => {
        const diffMs = p.verifiedAt!.getTime() - p.createdAt.getTime();
        return diffMs / (1000 * 60 * 60); // Convert to hours
      })
      .sort((a, b) => a - b);

    const sum = processingTimes.reduce((acc, time) => acc + time, 0);
    const average = sum / processingTimes.length;
    const median = processingTimes[Math.floor(processingTimes.length / 2)];
    const min = processingTimes[0];
    const max = processingTimes[processingTimes.length - 1];

    return {
      averageHours: Number(average.toFixed(2)),
      medianHours: Number(median.toFixed(2)),
      minHours: Number(min.toFixed(2)),
      maxHours: Number(max.toFixed(2)),
    };
  }

  async findLowConfidenceOCR(
    _userId: string,
    _confidenceThreshold: number = 0.7,
  ): Promise<Prescription[]> {
    // This would require implementing confidence scoring in OCR data
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  async findIncompleteData(userId: string): Promise<Prescription[]> {
    const data = await this.prisma.prescription.findMany({
      where: {
        userId,
        OR: [
          { prescribedBy: { equals: '' } },
          { medications: { equals: [] } },
          {
            AND: [{ ocrData: { not: Prisma.JsonNull } }, { isVerified: false }],
          },
        ],
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findDuplicatePrescriptions(_userId: string): Promise<Prescription[][]> {
    // This would require complex duplicate detection logic
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  async findRecentlyAdded(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<Prescription[]> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);

    const data = await this.prisma.prescription.findMany({
      where: {
        userId,
        createdAt: { gte: cutoffDate },
      },
      orderBy: { createdAt: 'desc' },
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findRecentlyVerified(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<Prescription[]> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);

    const data = await this.prisma.prescription.findMany({
      where: {
        userId,
        isVerified: true,
        verifiedAt: { gte: cutoffDate },
      },
      orderBy: { verifiedAt: 'desc' },
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async findRecentlyProcessed(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<Prescription[]> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);

    const data = await this.prisma.prescription.findMany({
      where: {
        userId,
        updatedAt: { gte: cutoffDate },
        OR: [{ ocrData: { not: Prisma.JsonNull } }, { isVerified: true }],
      },
      orderBy: { updatedAt: 'desc' },
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }
}
