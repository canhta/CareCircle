import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { PrescriptionOCRService } from './services/prescription-ocr.service';
import {
  PrescriptionOCRResponseDto,
  PrescriptionExtractedDataDto,
  PrescriptionValidationDto,
} from './dto/prescription-ocr.dto';
import {
  CreatePrescriptionDto,
  UpdatePrescriptionDto,
} from './dto/prescription-crud.dto';

@Injectable()
export class PrescriptionService {
  constructor(
    private readonly ocrService: PrescriptionOCRService,
    private readonly prisma: PrismaService,
  ) {}

  /**
   * Processes an image buffer using OCR and returns structured prescription data
   */
  async processImageBuffer(
    imageBuffer: Buffer,
  ): Promise<PrescriptionOCRResponseDto> {
    // Process the image with OCR
    const ocrResult = await this.ocrService.processImageBuffer(imageBuffer);

    // Validate the extracted data
    const validation = this.ocrService.validatePrescriptionData(ocrResult);

    // Map the results to the response DTO
    const extractedData: PrescriptionExtractedDataDto = {
      drugName: ocrResult.extractedData.drugName,
      dosage: ocrResult.extractedData.dosage,
      frequency: ocrResult.extractedData.frequency,
      quantity: ocrResult.extractedData.quantity,
      prescriber: ocrResult.extractedData.prescriber,
      instructions: ocrResult.extractedData.instructions,
    };

    const validationResult: PrescriptionValidationDto = {
      isValid: validation.isValid,
      confidence: validation.confidence,
      issues: validation.issues,
    };

    return {
      text: ocrResult.text,
      confidence: ocrResult.confidence,
      extractedData,
      validation: validationResult,
      processedAt: new Date().toISOString(),
    };
  }

  /**
   * Creates a new prescription in the database
   */
  async createPrescription(
    userId: string,
    prescriptionData: CreatePrescriptionDto,
  ) {
    return this.prisma.prescription.create({
      data: {
        userId,
        medicationName: prescriptionData.medicationName,
        dosage: prescriptionData.dosage,
        frequency: prescriptionData.frequency,
        instructions: prescriptionData.instructions,
        startDate: prescriptionData.startDate,
        endDate: prescriptionData.endDate,
        ocrImageUrl: prescriptionData.ocrImageUrl,
        ocrConfidence: prescriptionData.ocrConfidence,
        isVerified: prescriptionData.isVerified || false,
        refillsLeft: prescriptionData.refillsLeft,
        pharmacy: prescriptionData.pharmacy,
        prescribedBy: prescriptionData.prescribedBy,
      },
    });
  }

  /**
   * Gets all prescriptions for a user
   */
  async getPrescriptionsByUser(userId: string) {
    return this.prisma.prescription.findMany({
      where: {
        userId,
        isActive: true,
      },
      orderBy: {
        startDate: 'desc',
      },
      include: {
        reminders: {
          where: {
            status: 'PENDING',
          },
          orderBy: {
            scheduledAt: 'asc',
          },
        },
      },
    });
  }

  /**
   * Gets a specific prescription by ID
   */
  async getPrescriptionById(id: string, userId: string) {
    const prescription = await this.prisma.prescription.findFirst({
      where: {
        id,
        userId,
        isActive: true,
      },
      include: {
        reminders: {
          orderBy: {
            scheduledAt: 'asc',
          },
        },
      },
    });

    if (!prescription) {
      throw new NotFoundException('Prescription not found');
    }

    return prescription;
  }

  /**
   * Updates an existing prescription
   */
  async updatePrescription(
    id: string,
    userId: string,
    updateData: UpdatePrescriptionDto,
  ) {
    const prescription = await this.prisma.prescription.findFirst({
      where: {
        id,
        userId,
        isActive: true,
      },
    });

    if (!prescription) {
      throw new NotFoundException('Prescription not found');
    }

    return this.prisma.prescription.update({
      where: { id },
      data: {
        ...updateData,
        updatedAt: new Date(),
      },
    });
  }

  /**
   * Soft deletes a prescription
   */
  async deletePrescription(id: string, userId: string) {
    const prescription = await this.prisma.prescription.findFirst({
      where: {
        id,
        userId,
        isActive: true,
      },
    });

    if (!prescription) {
      throw new NotFoundException('Prescription not found');
    }

    return this.prisma.prescription.update({
      where: { id },
      data: {
        isActive: false,
        updatedAt: new Date(),
      },
    });
  }

  /**
   * Creates a prescription from OCR data
   */
  async createPrescriptionFromOCR(
    userId: string,
    ocrData: PrescriptionOCRResponseDto,
    imageUrl?: string,
  ) {
    const prescriptionData: CreatePrescriptionDto = {
      medicationName: ocrData.extractedData.drugName || 'Unknown Medication',
      dosage: ocrData.extractedData.dosage || 'Unknown Dosage',
      frequency: ocrData.extractedData.frequency || 'As prescribed',
      instructions: ocrData.extractedData.instructions,
      startDate: new Date(),
      prescribedBy: ocrData.extractedData.prescriber,
      ocrImageUrl: imageUrl,
      ocrConfidence: ocrData.confidence,
      isVerified: ocrData.validation.isValid && ocrData.confidence > 0.8,
    };

    return this.createPrescription(userId, prescriptionData);
  }

  /**
   * Gets prescription statistics for a user
   */
  async getPrescriptionStats(userId: string) {
    const totalPrescriptions = await this.prisma.prescription.count({
      where: { userId, isActive: true },
    });

    const activePrescriptions = await this.prisma.prescription.count({
      where: {
        userId,
        isActive: true,
        OR: [{ endDate: null }, { endDate: { gte: new Date() } }],
      },
    });

    const verifiedPrescriptions = await this.prisma.prescription.count({
      where: {
        userId,
        isActive: true,
        isVerified: true,
      },
    });

    const ocrPrescriptions = await this.prisma.prescription.count({
      where: {
        userId,
        isActive: true,
        ocrImageUrl: { not: null },
      },
    });

    return {
      total: totalPrescriptions,
      active: activePrescriptions,
      verified: verifiedPrescriptions,
      fromOCR: ocrPrescriptions,
    };
  }
}
