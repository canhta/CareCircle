import { CareRecipientEntity } from '../entities/care-recipient.entity';

export interface RecipientQuery {
  groupId?: string;
  isActive?: boolean;
  relationship?: string;
  ageMin?: number;
  ageMax?: number;
  hasMedicalConditions?: boolean;
  hasAllergies?: boolean;
  limit?: number;
  offset?: number;
}

export abstract class CareRecipientRepository {
  abstract create(recipientData: {
    groupId: string;
    name: string;
    relationship: string;
    dateOfBirth: Date | null;
    healthSummary: any;
    carePreferences: any;
    isActive: boolean;
  }): Promise<CareRecipientEntity>;
  abstract findById(id: string): Promise<CareRecipientEntity | null>;
  abstract findMany(query: RecipientQuery): Promise<CareRecipientEntity[]>;
  abstract findByGroupId(
    groupId: string,
    filters?: {
      isActive?: boolean;
      relationship?: string;
      hasConditions?: boolean;
      hasAllergies?: boolean;
    },
  ): Promise<CareRecipientEntity[]>;
  abstract update(
    id: string,
    updates: Partial<{
      name: string;
      relationship: string;
      dateOfBirth: Date;
      medicalConditions: string[];
      allergies: string[];
      medications: string[];
      emergencyContacts: Record<string, any>[];
      carePreferences: Record<string, any>;
      notes: string;
      isActive: boolean;
    }>,
  ): Promise<CareRecipientEntity>;
  abstract delete(id: string): Promise<void>;

  // Task-related operations
  abstract hasActiveTasks(recipientId: string): Promise<boolean>;
  abstract getRecipientTasks(recipientId: string): Promise<{
    activeTasks: any[];
    completedTasks: any[];
  }>;
  abstract getRecipientStatistics(recipientId: string): Promise<{
    totalTasks: number;
    completedTasks: number;
    activeTasks: number;
    overdueTasks: number;
    medicalConditionsCount: number;
    allergiesCount: number;
    medicationsCount: number;
  }>;

  // Recipient management operations
  abstract findActiveRecipients(
    groupId: string,
  ): Promise<CareRecipientEntity[]>;
  abstract findInactiveRecipients(
    groupId: string,
  ): Promise<CareRecipientEntity[]>;
  abstract activateRecipient(id: string): Promise<CareRecipientEntity>;
  abstract deactivateRecipient(id: string): Promise<CareRecipientEntity>;

  // Health information operations
  abstract findByMedicalCondition(
    groupId: string,
    condition: string,
  ): Promise<CareRecipientEntity[]>;
  abstract findByAllergy(
    groupId: string,
    allergy: string,
  ): Promise<CareRecipientEntity[]>;
  abstract findByMedication(
    groupId: string,
    medication: string,
  ): Promise<CareRecipientEntity[]>;
  abstract findWithMedicalConditions(
    groupId: string,
  ): Promise<CareRecipientEntity[]>;
  abstract findWithAllergies(groupId: string): Promise<CareRecipientEntity[]>;
  abstract findWithMedications(groupId: string): Promise<CareRecipientEntity[]>;

  // Age-based operations
  abstract findMinors(groupId: string): Promise<CareRecipientEntity[]>;
  abstract findElderly(groupId: string): Promise<CareRecipientEntity[]>;
  abstract findByAgeRange(
    groupId: string,
    minAge: number,
    maxAge: number,
  ): Promise<CareRecipientEntity[]>;

  // Relationship operations
  abstract findByRelationship(
    groupId: string,
    relationship: string,
  ): Promise<CareRecipientEntity[]>;
  abstract getUniqueRelationships(groupId: string): Promise<string[]>;

  // Emergency contact operations
  abstract findWithEmergencyContacts(
    groupId: string,
  ): Promise<CareRecipientEntity[]>;
  abstract findWithoutEmergencyContacts(
    groupId: string,
  ): Promise<CareRecipientEntity[]>;
  abstract updateEmergencyContacts(
    id: string,
    emergencyContacts: Record<string, any>[],
  ): Promise<CareRecipientEntity>;

  // Care preferences operations
  abstract updateCarePreferences(
    id: string,
    carePreferences: Record<string, any>,
  ): Promise<CareRecipientEntity>;
  abstract findByCarePreference(
    groupId: string,
    preferenceKey: string,
    preferenceValue: any,
  ): Promise<CareRecipientEntity[]>;

  // Search operations
  abstract searchByName(
    groupId: string,
    searchTerm: string,
  ): Promise<CareRecipientEntity[]>;
  abstract searchByNotes(
    groupId: string,
    searchTerm: string,
  ): Promise<CareRecipientEntity[]>;

  // Count operations
  abstract getRecipientCount(groupId: string): Promise<number>;
  abstract getActiveRecipientCount(groupId: string): Promise<number>;
  abstract getMinorCount(groupId: string): Promise<number>;
  abstract getElderlyCount(groupId: string): Promise<number>;
  abstract getRecipientCountByRelationship(
    groupId: string,
    relationship: string,
  ): Promise<number>;

  // Health statistics operations
  abstract getHealthStatistics(groupId: string): Promise<{
    totalRecipients: number;
    activeRecipients: number;
    minors: number;
    elderly: number;
    withMedicalConditions: number;
    withAllergies: number;
    withMedications: number;
    withEmergencyContacts: number;
  }>;
  abstract getMedicalConditionStatistics(groupId: string): Promise<
    Array<{
      condition: string;
      count: number;
    }>
  >;
  abstract getAllergyStatistics(groupId: string): Promise<
    Array<{
      allergy: string;
      count: number;
    }>
  >;
  abstract getMedicationStatistics(groupId: string): Promise<
    Array<{
      medication: string;
      count: number;
    }>
  >;

  // Validation operations
  abstract checkRecipientExists(
    groupId: string,
    recipientId: string,
  ): Promise<boolean>;
  abstract checkRecipientBelongsToGroup(
    recipientId: string,
    groupId: string,
  ): Promise<boolean>;

  // Bulk operations
  abstract bulkUpdateMedicalConditions(
    recipientIds: string[],
    medicalConditions: string[],
  ): Promise<CareRecipientEntity[]>;
  abstract bulkUpdateAllergies(
    recipientIds: string[],
    allergies: string[],
  ): Promise<CareRecipientEntity[]>;
  abstract bulkDeactivateRecipients(
    recipientIds: string[],
  ): Promise<CareRecipientEntity[]>;

  // Analytics operations
  abstract getRecipientTrends(
    groupId: string,
    days: number,
  ): Promise<
    Array<{
      date: Date;
      newRecipients: number;
      activeRecipients: number;
    }>
  >;
  abstract getAgeDistribution(groupId: string): Promise<
    Array<{
      ageRange: string;
      count: number;
    }>
  >;
}
