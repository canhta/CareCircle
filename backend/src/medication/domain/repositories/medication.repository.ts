import { Medication } from '../entities/medication.entity';
import { MedicationForm } from '@prisma/client';

export interface MedicationQuery {
  userId: string;
  isActive?: boolean;
  form?: MedicationForm;
  prescriptionId?: string;
  startDate?: Date;
  endDate?: Date;
  searchTerm?: string; // For name, genericName, or classification search
  limit?: number;
  offset?: number;
}

export interface MedicationStatistics {
  totalMedications: number;
  activeMedications: number;
  inactiveMedications: number;
  medicationsByForm: Record<MedicationForm, number>;
  prescriptionBasedCount: number;
  averageDurationDays: number;
}

export abstract class MedicationRepository {
  // Basic CRUD operations
  abstract create(medication: Medication): Promise<Medication>;
  abstract findById(id: string): Promise<Medication | null>;
  abstract findMany(query: MedicationQuery): Promise<Medication[]>;
  abstract update(id: string, updates: Partial<Medication>): Promise<Medication>;
  abstract delete(id: string): Promise<void>;

  // Bulk operations
  abstract createMany(medications: Medication[]): Promise<Medication[]>;
  abstract deleteMany(ids: string[]): Promise<void>;

  // User-specific queries
  abstract findByUserId(userId: string, includeInactive?: boolean): Promise<Medication[]>;
  abstract findActiveByUserId(userId: string): Promise<Medication[]>;
  abstract findInactiveByUserId(userId: string): Promise<Medication[]>;

  // Prescription-related queries
  abstract findByPrescriptionId(prescriptionId: string): Promise<Medication[]>;
  abstract findWithoutPrescription(userId: string): Promise<Medication[]>;

  // Search and filtering
  abstract searchByName(userId: string, searchTerm: string, limit?: number): Promise<Medication[]>;
  abstract findByForm(userId: string, form: MedicationForm): Promise<Medication[]>;
  abstract findByClassification(userId: string, classification: string): Promise<Medication[]>;

  // Date-based queries
  abstract findStartingInDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<Medication[]>;
  abstract findEndingInDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<Medication[]>;
  abstract findExpiredMedications(userId: string): Promise<Medication[]>;
  abstract findExpiringMedications(userId: string, withinDays: number): Promise<Medication[]>;

  // Drug identification queries
  abstract findByRxNormCode(rxNormCode: string): Promise<Medication[]>;
  abstract findByNdcCode(ndcCode: string): Promise<Medication[]>;
  abstract findSimilarMedications(
    userId: string,
    name: string,
    strength: string,
    form: MedicationForm,
  ): Promise<Medication[]>;

  // Statistics and analytics
  abstract getMedicationStatistics(userId: string): Promise<MedicationStatistics>;
  abstract getMedicationCount(userId: string, isActive?: boolean): Promise<number>;
  abstract getMedicationsByFormCount(userId: string): Promise<Record<MedicationForm, number>>;

  // Validation and compliance
  abstract findMedicationsNeedingReview(userId: string): Promise<Medication[]>;
  abstract findDuplicateMedications(userId: string): Promise<Medication[][]>;

  // Recent activity
  abstract findRecentlyAdded(userId: string, days: number, limit?: number): Promise<Medication[]>;
  abstract findRecentlyModified(userId: string, days: number, limit?: number): Promise<Medication[]>;
  abstract findRecentlyDeactivated(userId: string, days: number, limit?: number): Promise<Medication[]>;
}
