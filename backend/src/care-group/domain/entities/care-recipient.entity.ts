import { CareRecipient as PrismaCareRecipient } from '@prisma/client';

/**
 * Care Recipient Domain Entity
 * 
 * Represents a person who receives care within a care group.
 * Contains personal information, care preferences, and health-related metadata.
 */
export class CareRecipientEntity {
  constructor(
    public readonly id: string,
    public readonly groupId: string,
    public readonly name: string,
    public readonly relationship: string,
    public readonly dateOfBirth: Date | null,
    public readonly medicalConditions: string[],
    public readonly allergies: string[],
    public readonly medications: string[],
    public readonly emergencyContacts: Record<string, any>[],
    public readonly carePreferences: Record<string, any>,
    public readonly notes: string | null,
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
  }): Omit<CareRecipientEntity, 'id' | 'createdAt' | 'updatedAt'> {
    // Validate business rules
    this.validateName(data.name);
    this.validateRelationship(data.relationship);
    this.validateDateOfBirth(data.dateOfBirth);

    return {
      groupId: data.groupId,
      name: data.name.trim(),
      relationship: data.relationship.trim(),
      dateOfBirth: data.dateOfBirth || null,
      medicalConditions: data.medicalConditions || [],
      allergies: data.allergies || [],
      medications: data.medications || [],
      emergencyContacts: data.emergencyContacts || [],
      carePreferences: data.carePreferences || {},
      notes: data.notes?.trim() || null,
      isActive: true,
    };
  }

  /**
   * Create entity from Prisma model
   */
  static fromPrisma(prisma: PrismaCareRecipient): CareRecipientEntity {
    const medicalConditions = Array.isArray(prisma.medicalConditions) 
      ? prisma.medicalConditions as string[]
      : [];
    const allergies = Array.isArray(prisma.allergies) 
      ? prisma.allergies as string[]
      : [];
    const medications = Array.isArray(prisma.medications) 
      ? prisma.medications as string[]
      : [];
    const emergencyContacts = Array.isArray(prisma.emergencyContacts) 
      ? prisma.emergencyContacts as Record<string, any>[]
      : [];

    return new CareRecipientEntity(
      prisma.id,
      prisma.groupId,
      prisma.name,
      prisma.relationship,
      prisma.dateOfBirth,
      medicalConditions,
      allergies,
      medications,
      emergencyContacts,
      prisma.carePreferences as Record<string, any>,
      prisma.notes,
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
      medicalConditions: this.medicalConditions,
      allergies: this.allergies,
      medications: this.medications,
      emergencyContacts: this.emergencyContacts,
      carePreferences: this.carePreferences,
      notes: this.notes,
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

    return new CareRecipientEntity(
      this.id,
      this.groupId,
      data.name?.trim() ?? this.name,
      data.relationship?.trim() ?? this.relationship,
      data.dateOfBirth ?? this.dateOfBirth,
      data.medicalConditions ?? this.medicalConditions,
      data.allergies ?? this.allergies,
      data.medications ?? this.medications,
      data.emergencyContacts ?? this.emergencyContacts,
      data.carePreferences ?? this.carePreferences,
      data.notes?.trim() ?? this.notes,
      data.isActive ?? this.isActive,
      this.createdAt,
      new Date(), // updatedAt
    );
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
    
    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
      age--;
    }
    
    return age;
  }

  /**
   * Check if recipient has specific medical condition
   */
  hasMedicalCondition(condition: string): boolean {
    return this.medicalConditions.some(c => 
      c.toLowerCase().includes(condition.toLowerCase())
    );
  }

  /**
   * Check if recipient has specific allergy
   */
  hasAllergy(allergy: string): boolean {
    return this.allergies.some(a => 
      a.toLowerCase().includes(allergy.toLowerCase())
    );
  }

  /**
   * Check if recipient is on specific medication
   */
  isOnMedication(medication: string): boolean {
    return this.medications.some(m => 
      m.toLowerCase().includes(medication.toLowerCase())
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
    return this.emergencyContacts.find(contact => contact.type === type) || null;
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
