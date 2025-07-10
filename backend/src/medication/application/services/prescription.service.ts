import { Injectable, Inject } from '@nestjs/common';
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

@Injectable()
export class PrescriptionService {
  constructor(
    @Inject('PrescriptionRepository')
    private readonly prescriptionRepository: PrescriptionRepository,
  ) {}

  async createPrescription(data: {
    userId: string;
    prescribedBy: string;
    prescribedDate: Date;
    pharmacy?: string;
    ocrData?: OCRData;
    imageUrl?: string;
    isVerified?: boolean;
    verifiedAt?: Date;
    verifiedBy?: string;
    medications?: PrescriptionMedication[];
  }): Promise<Prescription> {
    const prescription = Prescription.create({
      id: this.generateId(),
      ...data,
    });

    // Validate the prescription
    if (!prescription.validate()) {
      throw new Error('Invalid prescription data');
    }

    return this.prescriptionRepository.create(prescription);
  }

  async createPrescriptions(
    prescriptions: Array<{
      userId: string;
      prescribedBy: string;
      prescribedDate: Date;
      pharmacy?: string;
      ocrData?: OCRData;
      imageUrl?: string;
      isVerified?: boolean;
      verifiedAt?: Date;
      verifiedBy?: string;
      medications?: PrescriptionMedication[];
    }>,
  ): Promise<Prescription[]> {
    const prescriptionEntities = prescriptions.map((data) => {
      const prescription = Prescription.create({
        id: this.generateId(),
        ...data,
      });

      if (!prescription.validate()) {
        throw new Error(`Invalid prescription data for ${data.prescribedBy}`);
      }

      return prescription;
    });

    return this.prescriptionRepository.createMany(prescriptionEntities);
  }

  async getPrescription(id: string): Promise<Prescription | null> {
    return this.prescriptionRepository.findById(id);
  }

  async updatePrescription(
    id: string,
    updates: {
      prescribedBy?: string;
      prescribedDate?: Date;
      pharmacy?: string;
      ocrData?: OCRData;
      imageUrl?: string;
      isVerified?: boolean;
      verifiedAt?: Date;
      verifiedBy?: string;
      medications?: PrescriptionMedication[];
    },
  ): Promise<Prescription> {
    const existingPrescription = await this.prescriptionRepository.findById(id);
    if (!existingPrescription) {
      throw new Error('Prescription not found');
    }

    return this.prescriptionRepository.update(id, updates);
  }

  async deletePrescription(id: string): Promise<void> {
    const prescription = await this.prescriptionRepository.findById(id);
    if (!prescription) {
      throw new Error('Prescription not found');
    }

    await this.prescriptionRepository.delete(id);
  }

  async verifyPrescription(
    id: string,
    verifiedBy: string,
  ): Promise<Prescription> {
    const prescription = await this.prescriptionRepository.findById(id);
    if (!prescription) {
      throw new Error('Prescription not found');
    }

    prescription.verify(verifiedBy);
    return this.prescriptionRepository.update(id, {
      isVerified: prescription.isVerified,
      verifiedAt: prescription.verifiedAt,
      verifiedBy: prescription.verifiedBy,
    });
  }

  async unverifyPrescription(id: string): Promise<Prescription> {
    const prescription = await this.prescriptionRepository.findById(id);
    if (!prescription) {
      throw new Error('Prescription not found');
    }

    prescription.unverify();
    return this.prescriptionRepository.update(id, {
      isVerified: prescription.isVerified,
      verifiedAt: prescription.verifiedAt,
      verifiedBy: prescription.verifiedBy,
    });
  }

  async addMedicationToPrescription(
    id: string,
    medication: PrescriptionMedication,
  ): Promise<Prescription> {
    const prescription = await this.prescriptionRepository.findById(id);
    if (!prescription) {
      throw new Error('Prescription not found');
    }

    prescription.addMedication(medication);
    return this.prescriptionRepository.update(id, {
      medications: prescription.medications,
    });
  }

  async removeMedicationFromPrescription(
    id: string,
    medicationName: string,
  ): Promise<Prescription> {
    const prescription = await this.prescriptionRepository.findById(id);
    if (!prescription) {
      throw new Error('Prescription not found');
    }

    prescription.removeMedication(medicationName);
    return this.prescriptionRepository.update(id, {
      medications: prescription.medications,
    });
  }

  async updateMedicationInPrescription(
    id: string,
    medicationName: string,
    updates: Partial<PrescriptionMedication>,
  ): Promise<Prescription> {
    const prescription = await this.prescriptionRepository.findById(id);
    if (!prescription) {
      throw new Error('Prescription not found');
    }

    prescription.updateMedication(medicationName, updates);
    return this.prescriptionRepository.update(id, {
      medications: prescription.medications,
    });
  }

  async setOCRData(id: string, ocrData: OCRData): Promise<Prescription> {
    const prescription = await this.prescriptionRepository.findById(id);
    if (!prescription) {
      throw new Error('Prescription not found');
    }

    prescription.setOCRData(ocrData);
    return this.prescriptionRepository.update(id, {
      prescribedBy: prescription.prescribedBy,
      prescribedDate: prescription.prescribedDate,
      pharmacy: prescription.pharmacy,
      ocrData: prescription.ocrData,
      medications: prescription.medications,
    });
  }

  async setImageUrl(id: string, imageUrl: string): Promise<Prescription> {
    const prescription = await this.prescriptionRepository.findById(id);
    if (!prescription) {
      throw new Error('Prescription not found');
    }

    prescription.setImageUrl(imageUrl);
    return this.prescriptionRepository.update(id, {
      imageUrl: prescription.imageUrl,
    });
  }

  async getUserPrescriptions(userId: string): Promise<Prescription[]> {
    return this.prescriptionRepository.findByUserId(userId);
  }

  async getRecentPrescriptions(
    userId: string,
    limit?: number,
  ): Promise<Prescription[]> {
    return this.prescriptionRepository.findRecentByUserId(userId, limit);
  }

  async searchPrescriptions(query: PrescriptionQuery): Promise<Prescription[]> {
    return this.prescriptionRepository.findMany(query);
  }

  async getUnverifiedPrescriptions(userId?: string): Promise<Prescription[]> {
    return this.prescriptionRepository.findUnverified(userId);
  }

  async getVerifiedPrescriptions(userId?: string): Promise<Prescription[]> {
    return this.prescriptionRepository.findVerified(userId);
  }

  async getPendingVerificationPrescriptions(
    userId: string,
  ): Promise<Prescription[]> {
    return this.prescriptionRepository.findPendingVerification(userId);
  }

  async getPrescriptionsWithOCR(userId?: string): Promise<Prescription[]> {
    return this.prescriptionRepository.findWithOCRData(userId);
  }

  async getPrescriptionsWithoutOCR(userId?: string): Promise<Prescription[]> {
    return this.prescriptionRepository.findWithoutOCRData(userId);
  }

  async getPrescriptionsWithImages(userId?: string): Promise<Prescription[]> {
    return this.prescriptionRepository.findWithImages(userId);
  }

  async getPrescriptionsWithoutImages(
    userId?: string,
  ): Promise<Prescription[]> {
    return this.prescriptionRepository.findWithoutImages(userId);
  }

  async getPrescriptionsByPrescriber(
    userId: string,
    prescriberName: string,
  ): Promise<Prescription[]> {
    return this.prescriptionRepository.findByPrescriber(userId, prescriberName);
  }

  async getPrescriptionsByPharmacy(
    userId: string,
    pharmacyName: string,
  ): Promise<Prescription[]> {
    return this.prescriptionRepository.findByPharmacy(userId, pharmacyName);
  }

  async getUniquePrescribers(userId: string): Promise<string[]> {
    return this.prescriptionRepository.getUniquePrescribers(userId);
  }

  async getUniquePharmacies(userId: string): Promise<string[]> {
    return this.prescriptionRepository.getUniquePharmacies(userId);
  }

  async getPrescriptionsByDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<Prescription[]> {
    return this.prescriptionRepository.findByDateRange(
      userId,
      startDate,
      endDate,
    );
  }

  async getExpiredPrescriptions(
    userId: string,
    expirationMonths?: number,
  ): Promise<Prescription[]> {
    return this.prescriptionRepository.findExpired(userId, expirationMonths);
  }

  async searchPrescriptionsByTerm(
    userId: string,
    searchTerm: string,
    limit?: number,
  ): Promise<Prescription[]> {
    return this.prescriptionRepository.searchPrescriptions(
      userId,
      searchTerm,
      limit,
    );
  }

  async findPrescriptionsByMedication(
    userId: string,
    medicationName: string,
  ): Promise<Prescription[]> {
    return this.prescriptionRepository.findByMedicationName(
      userId,
      medicationName,
    );
  }

  async getPrescriptionStatistics(
    userId: string,
  ): Promise<PrescriptionStatistics> {
    return this.prescriptionRepository.getPrescriptionStatistics(userId);
  }

  async validatePrescriptionData(prescription: Prescription): Promise<{
    isValid: boolean;
    errors: string[];
    warnings: string[];
  }> {
    const errors: string[] = [];
    const warnings: string[] = [];

    // Basic validation
    if (!prescription.validate()) {
      errors.push('Basic prescription validation failed');
    }

    // Check if prescription is expired
    if (prescription.isExpired()) {
      warnings.push('Prescription is expired');
    }

    // Check OCR confidence if available
    if (prescription.hasOCRData() && !prescription.isHighConfidenceOCR()) {
      warnings.push('OCR confidence is low, manual verification recommended');
    }

    // Check if prescription requires verification
    if (prescription.requiresVerification()) {
      warnings.push('Prescription requires verification');
    }

    // Check for missing medications
    if (prescription.getMedicationCount() === 0) {
      warnings.push('No medications found in prescription');
    }

    return {
      isValid: errors.length === 0,
      errors,
      warnings,
    };
  }

  private generateId(): string {
    return `presc_${Date.now()}_${Math.random().toString(36).substring(2, 11)}`;
  }
}
