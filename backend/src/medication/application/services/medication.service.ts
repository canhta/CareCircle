import { Injectable, Inject } from '@nestjs/common';
import { Medication } from '../../domain/entities/medication.entity';
import { MedicationForm } from '@prisma/client';
import {
  MedicationRepository,
  MedicationQuery,
  MedicationStatistics,
} from '../../domain/repositories/medication.repository';

@Injectable()
export class MedicationService {
  constructor(
    @Inject('MedicationRepository')
    private readonly medicationRepository: MedicationRepository,
  ) {}

  async createMedication(data: {
    userId: string;
    name: string;
    genericName?: string;
    strength: string;
    form: MedicationForm;
    manufacturer?: string;
    rxNormCode?: string;
    ndcCode?: string;
    classification?: string;
    isActive?: boolean;
    startDate: Date;
    endDate?: Date;
    prescriptionId?: string;
    notes?: string;
  }): Promise<Medication> {
    const medication = Medication.create({
      id: this.generateId(),
      ...data,
    });

    // Validate the medication
    if (!medication.validate()) {
      throw new Error('Invalid medication data');
    }

    return this.medicationRepository.create(medication);
  }

  async createMedications(
    medications: Array<{
      userId: string;
      name: string;
      genericName?: string;
      strength: string;
      form: MedicationForm;
      manufacturer?: string;
      rxNormCode?: string;
      ndcCode?: string;
      classification?: string;
      isActive?: boolean;
      startDate: Date;
      endDate?: Date;
      prescriptionId?: string;
      notes?: string;
    }>,
  ): Promise<Medication[]> {
    const medicationEntities = medications.map((data) => {
      const medication = Medication.create({
        id: this.generateId(),
        ...data,
      });

      if (!medication.validate()) {
        throw new Error(`Invalid medication data for ${data.name}`);
      }

      return medication;
    });

    return this.medicationRepository.createMany(medicationEntities);
  }

  async getMedication(id: string): Promise<Medication | null> {
    return this.medicationRepository.findById(id);
  }

  async updateMedication(
    id: string,
    updates: {
      name?: string;
      genericName?: string;
      strength?: string;
      form?: MedicationForm;
      manufacturer?: string;
      rxNormCode?: string;
      ndcCode?: string;
      classification?: string;
      endDate?: Date;
      notes?: string;
    },
  ): Promise<Medication> {
    const existingMedication = await this.medicationRepository.findById(id);
    if (!existingMedication) {
      throw new Error('Medication not found');
    }

    // Create updated medication for validation
    const updatedMedication = Medication.create({
      id: existingMedication.id,
      userId: existingMedication.userId,
      name: updates.name || existingMedication.name,
      genericName: updates.genericName !== undefined ? updates.genericName : existingMedication.genericName,
      strength: updates.strength || existingMedication.strength,
      form: updates.form || existingMedication.form,
      manufacturer: updates.manufacturer !== undefined ? updates.manufacturer : existingMedication.manufacturer,
      rxNormCode: updates.rxNormCode !== undefined ? updates.rxNormCode : existingMedication.rxNormCode,
      ndcCode: updates.ndcCode !== undefined ? updates.ndcCode : existingMedication.ndcCode,
      classification: updates.classification !== undefined ? updates.classification : existingMedication.classification,
      isActive: existingMedication.isActive,
      startDate: existingMedication.startDate,
      endDate: updates.endDate !== undefined ? updates.endDate : existingMedication.endDate,
      prescriptionId: existingMedication.prescriptionId,
      notes: updates.notes !== undefined ? updates.notes : existingMedication.notes,
    });

    if (!updatedMedication.validate()) {
      throw new Error('Invalid medication update data');
    }

    return this.medicationRepository.update(id, updates);
  }

  async deactivateMedication(id: string, reason?: string): Promise<Medication> {
    const medication = await this.medicationRepository.findById(id);
    if (!medication) {
      throw new Error('Medication not found');
    }

    medication.deactivate(reason);
    return this.medicationRepository.update(id, {
      isActive: medication.isActive,
      endDate: medication.endDate,
      notes: medication.notes,
    });
  }

  async reactivateMedication(id: string): Promise<Medication> {
    const medication = await this.medicationRepository.findById(id);
    if (!medication) {
      throw new Error('Medication not found');
    }

    medication.reactivate();
    return this.medicationRepository.update(id, {
      isActive: medication.isActive,
      endDate: medication.endDate,
    });
  }

  async deleteMedication(id: string): Promise<void> {
    const medication = await this.medicationRepository.findById(id);
    if (!medication) {
      throw new Error('Medication not found');
    }

    await this.medicationRepository.delete(id);
  }

  async getUserMedications(
    userId: string,
    includeInactive?: boolean,
  ): Promise<Medication[]> {
    return this.medicationRepository.findByUserId(userId, includeInactive);
  }

  async getActiveMedications(userId: string): Promise<Medication[]> {
    return this.medicationRepository.findActiveByUserId(userId);
  }

  async getInactiveMedications(userId: string): Promise<Medication[]> {
    return this.medicationRepository.findInactiveByUserId(userId);
  }

  async searchMedications(query: MedicationQuery): Promise<Medication[]> {
    return this.medicationRepository.findMany(query);
  }

  async searchMedicationsByName(
    userId: string,
    searchTerm: string,
    limit?: number,
  ): Promise<Medication[]> {
    return this.medicationRepository.searchByName(userId, searchTerm, limit);
  }

  async getMedicationsByForm(
    userId: string,
    form: MedicationForm,
  ): Promise<Medication[]> {
    return this.medicationRepository.findByForm(userId, form);
  }

  async getMedicationsByClassification(
    userId: string,
    classification: string,
  ): Promise<Medication[]> {
    return this.medicationRepository.findByClassification(userId, classification);
  }

  async getMedicationsByPrescription(
    prescriptionId: string,
  ): Promise<Medication[]> {
    return this.medicationRepository.findByPrescriptionId(prescriptionId);
  }

  async getMedicationsWithoutPrescription(
    userId: string,
  ): Promise<Medication[]> {
    return this.medicationRepository.findWithoutPrescription(userId);
  }

  async getExpiredMedications(userId: string): Promise<Medication[]> {
    return this.medicationRepository.findExpiredMedications(userId);
  }

  async getExpiringMedications(
    userId: string,
    withinDays: number,
  ): Promise<Medication[]> {
    return this.medicationRepository.findExpiringMedications(userId, withinDays);
  }

  async findSimilarMedications(
    userId: string,
    name: string,
    strength: string,
    form: MedicationForm,
  ): Promise<Medication[]> {
    return this.medicationRepository.findSimilarMedications(
      userId,
      name,
      strength,
      form,
    );
  }

  async getMedicationStatistics(userId: string): Promise<MedicationStatistics> {
    return this.medicationRepository.getMedicationStatistics(userId);
  }

  async getMedicationCount(
    userId: string,
    isActive?: boolean,
  ): Promise<number> {
    return this.medicationRepository.getMedicationCount(userId, isActive);
  }

  async getMedicationsNeedingReview(userId: string): Promise<Medication[]> {
    return this.medicationRepository.findMedicationsNeedingReview(userId);
  }

  async findDuplicateMedications(userId: string): Promise<Medication[][]> {
    return this.medicationRepository.findDuplicateMedications(userId);
  }

  async getRecentMedications(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<{
    recentlyAdded: Medication[];
    recentlyModified: Medication[];
    recentlyDeactivated: Medication[];
  }> {
    const [recentlyAdded, recentlyModified, recentlyDeactivated] =
      await Promise.all([
        this.medicationRepository.findRecentlyAdded(userId, days, limit),
        this.medicationRepository.findRecentlyModified(userId, days, limit),
        this.medicationRepository.findRecentlyDeactivated(userId, days, limit),
      ]);

    return {
      recentlyAdded,
      recentlyModified,
      recentlyDeactivated,
    };
  }

  async validateMedicationData(medication: Medication): Promise<{
    isValid: boolean;
    errors: string[];
    warnings: string[];
  }> {
    const errors: string[] = [];
    const warnings: string[] = [];

    // Basic validation
    if (!medication.validate()) {
      errors.push('Basic medication validation failed');
    }

    // Check for duplicates
    const duplicates = await this.findSimilarMedications(
      medication.userId,
      medication.name,
      medication.strength,
      medication.form,
    );

    if (duplicates.length > 0 && !duplicates.some(d => d.id === medication.id)) {
      warnings.push('Similar medication already exists');
    }

    // Check for missing standardized codes
    if (!medication.hasRxNormCode()) {
      warnings.push('Missing RxNorm code for standardization');
    }

    if (!medication.hasNdcCode()) {
      warnings.push('Missing NDC code for identification');
    }

    // Check for missing classification
    if (!medication.classification) {
      warnings.push('Missing medication classification');
    }

    return {
      isValid: errors.length === 0,
      errors,
      warnings,
    };
  }

  private generateId(): string {
    return `med_${Date.now()}_${Math.random().toString(36).substring(2, 11)}`;
  }
}
