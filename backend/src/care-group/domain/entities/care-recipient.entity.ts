import { CareRecipient as PrismaCareRecipient } from '@prisma/client';
import {
  HealthSummary,
  CarePreferences,
  defaultHealthSummary,
  defaultCarePreferences,
  isHealthSummary,
  isCarePreferences,
} from '../types/healthcare-data.types';

/**
 * Care Recipient Domain Entity
 *
 * Represents a person who receives care within a care group.
 * Uses JSON fields for flexible healthcare data storage.
 */
export class CareRecipientEntity {
  constructor(
    public readonly id: string,
    public readonly groupId: string,
    public readonly name: string,
    public readonly relationship: string,
    public readonly dateOfBirth: Date | null,
    public readonly healthSummary: HealthSummary,
    public readonly carePreferences: CarePreferences,
    public readonly isActive: boolean,
    public readonly createdAt: Date,
    public readonly updatedAt: Date,
  ) {}

  /**
   * Create a new Care Recipient entity
   */
  static create(data: {
    groupId: string;
    name: string;
    relationship: string;
    dateOfBirth?: Date;
    medicalConditions?: string[];
    allergies?: string[];
    medications?: string[];
    emergencyContacts?: Record<string, any>[];
    carePreferences?: Record<string, any>;
    notes?: string;
  }): {
    groupId: string;
    name: string;
    relationship: string;
    dateOfBirth: Date | null;
    healthSummary: HealthSummary;
    carePreferences: CarePreferences;
    isActive: boolean;
  } {
    // Validate business rules
    this.validateName(data.name);
    this.validateRelationship(data.relationship);
    this.validateDateOfBirth(data.dateOfBirth);

    // Create health summary from provided data
    const healthSummary: HealthSummary = {
      medicalConditions: data.medicalConditions || [],
      allergies: data.allergies || [],
      medications: data.medications || [],
      notes: data.notes,
      lastUpdated: new Date().toISOString(),
    };

    // Create care preferences from provided data
    const carePreferences: CarePreferences = {
      emergencyContacts: (data.emergencyContacts || []) as Array<{
        id?: string;
        name: string;
        phone: string;
        email?: string;
        relationship: string;
        isPrimary?: boolean;
        notes?: string;
      }>,
      careSettings: defaultCarePreferences().careSettings,
      ...data.carePreferences,
    };

    return {
      groupId: data.groupId,
      name: data.name.trim(),
      relationship: data.relationship.trim(),
      dateOfBirth: data.dateOfBirth || null,
      healthSummary,
      carePreferences,
      isActive: true,
    };
  }

  /**
   * Create entity from Prisma model
   */
  static fromPrisma(prisma: PrismaCareRecipient): CareRecipientEntity {
    // Parse healthSummary JSON field
    let healthSummary: HealthSummary;
    try {
      const parsed =
        typeof prisma.healthSummary === 'string'
          ? (JSON.parse(prisma.healthSummary) as unknown)
          : prisma.healthSummary;
      healthSummary = isHealthSummary(parsed) ? parsed : defaultHealthSummary();
    } catch {
      healthSummary = defaultHealthSummary();
    }

    // Parse carePreferences JSON field
    let carePreferences: CarePreferences;
    try {
      const parsed =
        typeof prisma.carePreferences === 'string'
          ? (JSON.parse(prisma.carePreferences) as unknown)
          : prisma.carePreferences;
      carePreferences = isCarePreferences(parsed)
        ? parsed
        : defaultCarePreferences();
    } catch {
      carePreferences = defaultCarePreferences();
    }

    return new CareRecipientEntity(
      prisma.id,
      prisma.groupId,
      prisma.name,
      prisma.relationship,
      prisma.dateOfBirth,
      healthSummary,
      carePreferences,
      prisma.isActive,
      prisma.createdAt,
      prisma.updatedAt,
    );
  }

  /**
   * Convert to Prisma format for database operations
   */
  toPrisma(): Omit<PrismaCareRecipient, 'id' | 'createdAt' | 'updatedAt'> {
    return {
      groupId: this.groupId,
      name: this.name,
      relationship: this.relationship,
      dateOfBirth: this.dateOfBirth,
      healthSummary: this.healthSummary,
      carePreferences: this.carePreferences,
      isActive: this.isActive,
    };
  }

  /**
   * Update care recipient information
   */
  update(data: {
    name?: string;
    relationship?: string;
    dateOfBirth?: Date;
    medicalConditions?: string[];
    allergies?: string[];
    medications?: string[];
    emergencyContacts?: Record<string, any>[];
    carePreferences?: Record<string, any>;
    notes?: string;
    isActive?: boolean;
  }): CareRecipientEntity {
    if (data.name !== undefined) {
      CareRecipientEntity.validateName(data.name);
    }
    if (data.relationship !== undefined) {
      CareRecipientEntity.validateRelationship(data.relationship);
    }
    if (data.dateOfBirth !== undefined) {
      CareRecipientEntity.validateDateOfBirth(data.dateOfBirth);
    }

    // Update health summary if any health-related fields are provided
    let updatedHealthSummary = this.healthSummary;
    if (
      data.medicalConditions ||
      data.allergies ||
      data.medications ||
      data.notes
    ) {
      updatedHealthSummary = {
        ...this.healthSummary,
        medicalConditions:
          data.medicalConditions ?? this.healthSummary.medicalConditions,
        allergies: data.allergies ?? this.healthSummary.allergies,
        medications: data.medications ?? this.healthSummary.medications,
        notes: data.notes?.trim() ?? this.healthSummary.notes,
        lastUpdated: new Date().toISOString(),
      };
    }

    // Update care preferences if provided
    let updatedCarePreferences = this.carePreferences;
    if (data.emergencyContacts || data.carePreferences) {
      updatedCarePreferences = {
        ...this.carePreferences,
        emergencyContacts: (data.emergencyContacts ??
          this.carePreferences.emergencyContacts) as Array<{
          id?: string;
          name: string;
          phone: string;
          email?: string;
          relationship: string;
          isPrimary?: boolean;
          notes?: string;
        }>,
        ...data.carePreferences,
      };
    }

    return new CareRecipientEntity(
      this.id,
      this.groupId,
      data.name?.trim() ?? this.name,
      data.relationship?.trim() ?? this.relationship,
      data.dateOfBirth ?? this.dateOfBirth,
      updatedHealthSummary,
      updatedCarePreferences,
      data.isActive ?? this.isActive,
      this.createdAt,
      new Date(), // updatedAt
    );
  }

  /**
   * Convenience getters for accessing JSON data as arrays (for API compatibility)
   */
  get medicalConditions(): string[] {
    return this.healthSummary.medicalConditions;
  }

  get allergies(): string[] {
    return this.healthSummary.allergies;
  }

  get medications(): string[] {
    return this.healthSummary.medications;
  }

  get emergencyContacts(): Record<string, any>[] {
    return this.carePreferences.emergencyContacts;
  }

  get notes(): string | null {
    return this.healthSummary.notes || null;
  }

  /**
   * Calculate age from date of birth
   */
  getAge(): number | null {
    if (!this.dateOfBirth) return null;

    const today = new Date();
    const birthDate = new Date(this.dateOfBirth);
    let age = today.getFullYear() - birthDate.getFullYear();
    const monthDiff = today.getMonth() - birthDate.getMonth();

    if (
      monthDiff < 0 ||
      (monthDiff === 0 && today.getDate() < birthDate.getDate())
    ) {
      age--;
    }

    return age;
  }

  /**
   * Check if recipient has specific medical condition
   */
  hasMedicalCondition(condition: string): boolean {
    return this.medicalConditions.some((c) =>
      c.toLowerCase().includes(condition.toLowerCase()),
    );
  }

  /**
   * Check if recipient has specific allergy
   */
  hasAllergy(allergy: string): boolean {
    return this.allergies.some((a) =>
      a.toLowerCase().includes(allergy.toLowerCase()),
    );
  }

  /**
   * Check if recipient is on specific medication
   */
  isOnMedication(medication: string): boolean {
    return this.medications.some((m) =>
      m.toLowerCase().includes(medication.toLowerCase()),
    );
  }

  /**
   * Add medical condition
   */
  addMedicalCondition(condition: string): CareRecipientEntity {
    if (this.hasMedicalCondition(condition)) {
      return this; // Already exists
    }

    return this.update({
      medicalConditions: [...this.medicalConditions, condition.trim()],
    });
  }

  /**
   * Add allergy
   */
  addAllergy(allergy: string): CareRecipientEntity {
    if (this.hasAllergy(allergy)) {
      return this; // Already exists
    }

    return this.update({
      allergies: [...this.allergies, allergy.trim()],
    });
  }

  /**
   * Add medication
   */
  addMedication(medication: string): CareRecipientEntity {
    if (this.isOnMedication(medication)) {
      return this; // Already exists
    }

    return this.update({
      medications: [...this.medications, medication.trim()],
    });
  }

  /**
   * Get emergency contact by type
   */
  getEmergencyContact(type: string): Record<string, any> | null {
    return (
      this.emergencyContacts.find((contact) => contact.type === type) || null
    );
  }

  /**
   * Check if recipient is a minor (under 18)
   */
  isMinor(): boolean {
    const age = this.getAge();
    return age !== null && age < 18;
  }

  /**
   * Check if recipient is elderly (over 65)
   */
  isElderly(): boolean {
    const age = this.getAge();
    return age !== null && age >= 65;
  }

  /**
   * Validate recipient name
   */
  private static validateName(name: string): void {
    if (!name || name.trim().length === 0) {
      throw new Error('Care recipient name is required');
    }
    if (name.trim().length < 2) {
      throw new Error('Care recipient name must be at least 2 characters long');
    }
    if (name.trim().length > 100) {
      throw new Error('Care recipient name must be less than 100 characters');
    }
  }

  /**
   * Validate relationship
   */
  private static validateRelationship(relationship: string): void {
    if (!relationship || relationship.trim().length === 0) {
      throw new Error('Relationship is required');
    }
    if (relationship.trim().length > 50) {
      throw new Error('Relationship must be less than 50 characters');
    }
  }

  /**
   * Validate date of birth
   */
  private static validateDateOfBirth(dateOfBirth?: Date): void {
    if (dateOfBirth && dateOfBirth > new Date()) {
      throw new Error('Date of birth cannot be in the future');
    }
    if (dateOfBirth && dateOfBirth < new Date('1900-01-01')) {
      throw new Error('Date of birth cannot be before 1900');
    }
  }

  /**
   * Convert to JSON representation for API responses
   */
  toJSON(): Record<string, any> {
    return {
      id: this.id,
      groupId: this.groupId,
      name: this.name,
      relationship: this.relationship,
      dateOfBirth: this.dateOfBirth?.toISOString() || null,
      age: this.getAge(),
      medicalConditions: this.medicalConditions,
      allergies: this.allergies,
      medications: this.medications,
      emergencyContacts: this.emergencyContacts,
      carePreferences: this.carePreferences,
      notes: this.notes,
      isActive: this.isActive,
      isMinor: this.isMinor(),
      isElderly: this.isElderly(),
      createdAt: this.createdAt.toISOString(),
      updatedAt: this.updatedAt.toISOString(),
    };
  }
}
