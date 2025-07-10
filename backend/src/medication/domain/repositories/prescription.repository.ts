import { Prescription } from '../entities/prescription.entity';

export interface PrescriptionQuery {
  userId: string;
  prescribedBy?: string;
  pharmacy?: string;
  isVerified?: boolean;
  hasOCRData?: boolean;
  hasImage?: boolean;
  startDate?: Date;
  endDate?: Date;
  searchTerm?: string; // For prescriber name or pharmacy search
  limit?: number;
  offset?: number;
}

export interface PrescriptionStatistics {
  totalPrescriptions: number;
  verifiedPrescriptions: number;
  unverifiedPrescriptions: number;
  prescriptionsWithOCR: number;
  prescriptionsWithImages: number;
  averageProcessingTime: number; // in hours
  topPrescribers: Array<{ name: string; count: number }>;
  topPharmacies: Array<{ name: string; count: number }>;
}

export abstract class PrescriptionRepository {
  // Basic CRUD operations
  abstract create(prescription: Prescription): Promise<Prescription>;
  abstract findById(id: string): Promise<Prescription | null>;
  abstract findMany(query: PrescriptionQuery): Promise<Prescription[]>;
  abstract update(
    id: string,
    updates: Partial<Prescription>,
  ): Promise<Prescription>;
  abstract delete(id: string): Promise<void>;

  // Bulk operations
  abstract createMany(prescriptions: Prescription[]): Promise<Prescription[]>;
  abstract deleteMany(ids: string[]): Promise<void>;

  // User-specific queries
  abstract findByUserId(userId: string): Promise<Prescription[]>;
  abstract findRecentByUserId(
    userId: string,
    limit?: number,
  ): Promise<Prescription[]>;

  // Verification queries
  abstract findUnverified(userId?: string): Promise<Prescription[]>;
  abstract findVerified(userId?: string): Promise<Prescription[]>;
  abstract findPendingVerification(userId: string): Promise<Prescription[]>;

  // OCR and image queries
  abstract findWithOCRData(userId?: string): Promise<Prescription[]>;
  abstract findWithoutOCRData(userId?: string): Promise<Prescription[]>;
  abstract findWithImages(userId?: string): Promise<Prescription[]>;
  abstract findWithoutImages(userId?: string): Promise<Prescription[]>;

  // Prescriber and pharmacy queries
  abstract findByPrescriber(
    userId: string,
    prescriberName: string,
  ): Promise<Prescription[]>;
  abstract findByPharmacy(
    userId: string,
    pharmacyName: string,
  ): Promise<Prescription[]>;
  abstract getUniquePrescribers(userId: string): Promise<string[]>;
  abstract getUniquePharmacies(userId: string): Promise<string[]>;

  // Date-based queries
  abstract findByDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<Prescription[]>;
  abstract findExpired(
    userId: string,
    expirationMonths?: number,
  ): Promise<Prescription[]>;
  abstract findExpiringMedications(
    userId: string,
    withinMonths: number,
  ): Promise<Prescription[]>;

  // Search functionality
  abstract searchPrescriptions(
    userId: string,
    searchTerm: string,
    limit?: number,
  ): Promise<Prescription[]>;
  abstract findByMedicationName(
    userId: string,
    medicationName: string,
  ): Promise<Prescription[]>;

  // Statistics and analytics
  abstract getPrescriptionStatistics(
    userId: string,
  ): Promise<PrescriptionStatistics>;
  abstract getPrescriptionCount(
    userId: string,
    isVerified?: boolean,
  ): Promise<number>;
  abstract getProcessingTimeStatistics(userId: string): Promise<{
    averageHours: number;
    medianHours: number;
    minHours: number;
    maxHours: number;
  }>;

  // Quality and compliance
  abstract findLowConfidenceOCR(
    userId: string,
    confidenceThreshold?: number,
  ): Promise<Prescription[]>;
  abstract findIncompleteData(userId: string): Promise<Prescription[]>;
  abstract findDuplicatePrescriptions(
    userId: string,
  ): Promise<Prescription[][]>;

  // Recent activity
  abstract findRecentlyAdded(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<Prescription[]>;
  abstract findRecentlyVerified(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<Prescription[]>;
  abstract findRecentlyProcessed(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<Prescription[]>;
}
