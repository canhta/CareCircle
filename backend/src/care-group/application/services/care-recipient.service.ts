import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { CareRecipientRepository } from '../../domain/repositories/care-recipient.repository';
import { CareGroupMemberRepository } from '../../domain/repositories/care-group-member.repository';
import { CareRecipientEntity } from '../../domain/entities/care-recipient.entity';

export interface CreateRecipientDto {
  name: string;
  relationship: string;
  dateOfBirth?: Date;
  medicalConditions?: string[];
  allergies?: string[];
  medications?: string[];
  emergencyContacts?: Record<string, any>[];
  carePreferences?: Record<string, any>;
  notes?: string;
}

export interface RecipientResponse {
  id: string;
  groupId: string;
  name: string;
  relationship: string;
  dateOfBirth: string | null;
  medicalConditions: string[];
  allergies: string[];
  medications: string[];
  emergencyContacts: Record<string, any>[];
  carePreferences: Record<string, any>;
  notes: string | null;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface UpdateRecipientDto {
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
}

export interface RecipientFilters {
  isActive?: boolean;
  relationship?: string;
  hasConditions?: boolean;
  hasAllergies?: boolean;
}

@Injectable()
export class CareRecipientService {
  constructor(
    private readonly recipientRepository: CareRecipientRepository,
    private readonly memberRepository: CareGroupMemberRepository,
  ) {}

  /**
   * Create a new care recipient in a care group
   */
  async createRecipient(
    groupId: string,
    userId: string,
    createDto: CreateRecipientDto,
  ): Promise<CareRecipientEntity> {
    // Verify user has permission to manage recipients in this group
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (!member) {
      throw new ForbiddenException('User is not a member of this care group');
    }

    // Check if user has admin role or can manage tasks (recipients are part of task management)
    if (member.role !== 'ADMIN' && !member.canManageTasks) {
      throw new ForbiddenException(
        'User does not have permission to create care recipients',
      );
    }

    // Create recipient entity
    const recipientData = CareRecipientEntity.create({
      groupId,
      name: createDto.name,
      relationship: createDto.relationship,
      dateOfBirth: createDto.dateOfBirth,
      medicalConditions: createDto.medicalConditions || [],
      allergies: createDto.allergies || [],
      medications: createDto.medications || [],
      emergencyContacts: createDto.emergencyContacts || [],
      carePreferences: createDto.carePreferences || {},
      notes: createDto.notes,
    });

    return this.recipientRepository.create(recipientData);
  }

  /**
   * Get recipients for a care group
   */
  async getGroupRecipients(
    groupId: string,
    userId: string,
    filters?: RecipientFilters,
  ): Promise<CareRecipientEntity[]> {
    // Verify user has access to this group
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (!member) {
      throw new ForbiddenException('User is not a member of this care group');
    }

    return this.recipientRepository.findByGroupId(groupId, filters);
  }

  /**
   * Get a specific care recipient
   */
  async getRecipient(
    recipientId: string,
    groupId: string,
    userId: string,
  ): Promise<CareRecipientEntity> {
    // Verify user has access to this group
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (!member) {
      throw new ForbiddenException('User is not a member of this care group');
    }

    const recipient = await this.recipientRepository.findById(recipientId);
    if (!recipient || recipient.groupId !== groupId) {
      throw new NotFoundException(
        'Care recipient not found in this care group',
      );
    }

    return recipient;
  }

  /**
   * Update a care recipient
   */
  async updateRecipient(
    recipientId: string,
    groupId: string,
    userId: string,
    updateDto: UpdateRecipientDto,
  ): Promise<CareRecipientEntity> {
    const recipient = await this.getRecipient(recipientId, groupId, userId);

    // Verify user has permission to update recipients
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (member?.role !== 'ADMIN' && !member?.canManageTasks) {
      throw new ForbiddenException(
        'User does not have permission to update care recipients',
      );
    }

    return this.recipientRepository.update(recipientId, updateDto);
  }

  /**
   * Delete a care recipient
   */
  async deleteRecipient(
    recipientId: string,
    groupId: string,
    userId: string,
  ): Promise<void> {
    const recipient = await this.getRecipient(recipientId, groupId, userId);

    // Verify user has permission to delete recipients
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (member?.role !== 'ADMIN' && !member?.canManageTasks) {
      throw new ForbiddenException(
        'User does not have permission to delete care recipients',
      );
    }

    // Check if recipient has active tasks
    const hasActiveTasks =
      await this.recipientRepository.hasActiveTasks(recipientId);
    if (hasActiveTasks) {
      throw new BadRequestException(
        'Cannot delete recipient with active tasks. Complete or reassign tasks first.',
      );
    }

    await this.recipientRepository.delete(recipientId);
  }

  /**
   * Get care recipient with their tasks
   */
  async getRecipientWithTasks(
    recipientId: string,
    groupId: string,
    userId: string,
  ): Promise<{
    recipient: CareRecipientEntity;
    activeTasks: any[];
    completedTasks: any[];
  }> {
    const recipient = await this.getRecipient(recipientId, groupId, userId);

    const { activeTasks, completedTasks } =
      await this.recipientRepository.getRecipientTasks(recipientId);

    return {
      recipient,
      activeTasks,
      completedTasks,
    };
  }

  /**
   * Add medical condition to recipient
   */
  async addMedicalCondition(
    recipientId: string,
    groupId: string,
    userId: string,
    condition: string,
  ): Promise<CareRecipientEntity> {
    const recipient = await this.getRecipient(recipientId, groupId, userId);

    // Verify user has permission to update recipients
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (member?.role !== 'ADMIN' && !member?.canManageTasks) {
      throw new ForbiddenException(
        'User does not have permission to update care recipients',
      );
    }

    const updatedConditions = [...recipient.medicalConditions];
    if (!updatedConditions.includes(condition)) {
      updatedConditions.push(condition);
    }

    return this.recipientRepository.update(recipientId, {
      medicalConditions: updatedConditions,
    });
  }

  /**
   * Remove medical condition from recipient
   */
  async removeMedicalCondition(
    recipientId: string,
    groupId: string,
    userId: string,
    condition: string,
  ): Promise<CareRecipientEntity> {
    const recipient = await this.getRecipient(recipientId, groupId, userId);

    // Verify user has permission to update recipients
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (member?.role !== 'ADMIN' && !member?.canManageTasks) {
      throw new ForbiddenException(
        'User does not have permission to update care recipients',
      );
    }

    const updatedConditions = recipient.medicalConditions.filter(
      (c) => c !== condition,
    );

    return this.recipientRepository.update(recipientId, {
      medicalConditions: updatedConditions,
    });
  }

  /**
   * Add allergy to recipient
   */
  async addAllergy(
    recipientId: string,
    groupId: string,
    userId: string,
    allergy: string,
  ): Promise<CareRecipientEntity> {
    const recipient = await this.getRecipient(recipientId, groupId, userId);

    // Verify user has permission to update recipients
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (member?.role !== 'ADMIN' && !member?.canManageTasks) {
      throw new ForbiddenException(
        'User does not have permission to update care recipients',
      );
    }

    const updatedAllergies = [...recipient.allergies];
    if (!updatedAllergies.includes(allergy)) {
      updatedAllergies.push(allergy);
    }

    return this.recipientRepository.update(recipientId, {
      allergies: updatedAllergies,
    });
  }

  /**
   * Remove allergy from recipient
   */
  async removeAllergy(
    recipientId: string,
    groupId: string,
    userId: string,
    allergy: string,
  ): Promise<CareRecipientEntity> {
    const recipient = await this.getRecipient(recipientId, groupId, userId);

    // Verify user has permission to update recipients
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (member?.role !== 'ADMIN' && !member?.canManageTasks) {
      throw new ForbiddenException(
        'User does not have permission to update care recipients',
      );
    }

    const updatedAllergies = recipient.allergies.filter((a) => a !== allergy);

    return this.recipientRepository.update(recipientId, {
      allergies: updatedAllergies,
    });
  }

  /**
   * Get recipient statistics
   */
  async getRecipientStatistics(
    recipientId: string,
    groupId: string,
    userId: string,
  ): Promise<{
    totalTasks: number;
    completedTasks: number;
    activeTasks: number;
    overdueTasks: number;
    medicalConditionsCount: number;
    allergiesCount: number;
    medicationsCount: number;
  }> {
    await this.getRecipient(recipientId, groupId, userId); // Verify access

    return this.recipientRepository.getRecipientStatistics(recipientId);
  }
}
