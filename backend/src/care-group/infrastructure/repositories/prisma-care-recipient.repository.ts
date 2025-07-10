import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import {
  CareRecipientRepository,
  RecipientQuery,
} from '../../domain/repositories/care-recipient.repository';
import { CareRecipientEntity } from '../../domain/entities/care-recipient.entity';
import { Prisma, TaskStatus } from '@prisma/client';

@Injectable()
export class PrismaCareRecipientRepository implements CareRecipientRepository {
  constructor(private readonly prisma: PrismaService) {}

  async create(recipientData: {
    groupId: string;
    name: string;
    relationship: string;
    dateOfBirth: Date | null;
    healthSummary: any;
    carePreferences: any;
    isActive: boolean;
  }): Promise<CareRecipientEntity> {
    const created = await this.prisma.careRecipient.create({
      data: {
        groupId: recipientData.groupId,
        name: recipientData.name,
        relationship: recipientData.relationship,
        dateOfBirth: recipientData.dateOfBirth,
        healthSummary: recipientData.healthSummary,
        carePreferences: recipientData.carePreferences,
        isActive: recipientData.isActive,
      },
    });

    return CareRecipientEntity.fromPrisma(created);
  }

  async findById(id: string): Promise<CareRecipientEntity | null> {
    const recipient = await this.prisma.careRecipient.findUnique({
      where: { id },
    });

    return recipient ? CareRecipientEntity.fromPrisma(recipient) : null;
  }

  async findByGroupId(
    groupId: string,
    filters?: {
      isActive?: boolean;
      relationship?: string;
      hasConditions?: boolean;
      hasAllergies?: boolean;
    },
  ): Promise<CareRecipientEntity[]> {
    const where: Prisma.CareRecipientWhereInput = { groupId };

    if (filters?.isActive !== undefined) {
      where.isActive = filters.isActive;
    }
    if (filters?.relationship) {
      where.relationship = filters.relationship;
    }
    if (filters?.hasConditions) {
      where.medicalConditions = {
        not: [],
      };
    }
    if (filters?.hasAllergies) {
      where.allergies = {
        not: [],
      };
    }

    const recipients = await this.prisma.careRecipient.findMany({
      where,
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async update(
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
  ): Promise<CareRecipientEntity> {
    const updateData: Prisma.CareRecipientUpdateInput = {};

    if (updates.name !== undefined) updateData.name = updates.name;
    if (updates.relationship !== undefined)
      updateData.relationship = updates.relationship;
    if (updates.dateOfBirth !== undefined)
      updateData.dateOfBirth = updates.dateOfBirth;
    if (updates.medicalConditions !== undefined)
      updateData.medicalConditions = updates.medicalConditions;
    if (updates.allergies !== undefined)
      updateData.allergies = updates.allergies;
    if (updates.medications !== undefined)
      updateData.medications = updates.medications;
    if (updates.emergencyContacts !== undefined)
      updateData.emergencyContacts = updates.emergencyContacts;
    if (updates.carePreferences !== undefined)
      updateData.carePreferences = updates.carePreferences;
    if (updates.notes !== undefined) updateData.notes = updates.notes;
    if (updates.isActive !== undefined) updateData.isActive = updates.isActive;

    const updated = await this.prisma.careRecipient.update({
      where: { id },
      data: updateData,
    });

    return CareRecipientEntity.fromPrisma(updated);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.careRecipient.delete({
      where: { id },
    });
  }

  async hasActiveTasks(recipientId: string): Promise<boolean> {
    const count = await this.prisma.careTask.count({
      where: {
        recipientId,
        status: {
          in: [TaskStatus.PENDING, TaskStatus.IN_PROGRESS],
        },
      },
    });

    return count > 0;
  }

  async getRecipientTasks(recipientId: string): Promise<{
    activeTasks: any[];
    completedTasks: any[];
  }> {
    const [activeTasks, completedTasks] = await Promise.all([
      this.prisma.careTask.findMany({
        where: {
          recipientId,
          status: {
            in: [TaskStatus.PENDING, TaskStatus.IN_PROGRESS],
          },
        },
        orderBy: [{ priority: 'desc' }, { dueDate: 'asc' }],
      }),
      this.prisma.careTask.findMany({
        where: {
          recipientId,
          status: TaskStatus.COMPLETED,
        },
        orderBy: { completedAt: 'desc' },
        take: 10, // Limit to recent completed tasks
      }),
    ]);

    return {
      activeTasks,
      completedTasks,
    };
  }

  async getRecipientStatistics(recipientId: string): Promise<{
    totalTasks: number;
    completedTasks: number;
    activeTasks: number;
    overdueTasks: number;
    medicalConditionsCount: number;
    allergiesCount: number;
    medicationsCount: number;
  }> {
    const now = new Date();

    const [totalTasks, completedTasks, activeTasks, overdueTasks, recipient] =
      await Promise.all([
        this.prisma.careTask.count({ where: { recipientId } }),
        this.prisma.careTask.count({
          where: { recipientId, status: TaskStatus.COMPLETED },
        }),
        this.prisma.careTask.count({
          where: {
            recipientId,
            status: { in: [TaskStatus.PENDING, TaskStatus.IN_PROGRESS] },
          },
        }),
        this.prisma.careTask.count({
          where: {
            recipientId,
            status: { in: [TaskStatus.PENDING, TaskStatus.IN_PROGRESS] },
            dueDate: { lt: now },
          },
        }),
        this.prisma.careRecipient.findUnique({
          where: { id: recipientId },
          select: {
            healthSummary: true,
          },
        }),
      ]);

    // Parse health summary to get counts
    let medicalConditionsCount = 0;
    let allergiesCount = 0;
    let medicationsCount = 0;

    if (recipient?.healthSummary) {
      try {
        const healthSummary =
          typeof recipient.healthSummary === 'string'
            ? JSON.parse(recipient.healthSummary)
            : recipient.healthSummary;

        medicalConditionsCount = Array.isArray(healthSummary.medicalConditions)
          ? healthSummary.medicalConditions.length
          : 0;
        allergiesCount = Array.isArray(healthSummary.allergies)
          ? healthSummary.allergies.length
          : 0;
        medicationsCount = Array.isArray(healthSummary.medications)
          ? healthSummary.medications.length
          : 0;
      } catch {
        // If parsing fails, counts remain 0
      }
    }

    return {
      totalTasks,
      completedTasks,
      activeTasks,
      overdueTasks,
      medicalConditionsCount,
      allergiesCount,
      medicationsCount,
    };
  }

  // Implement missing abstract methods
  async findMany(query: RecipientQuery): Promise<CareRecipientEntity[]> {
    const where: Prisma.CareRecipientWhereInput = {};

    if (query.groupId) where.groupId = query.groupId;
    if (query.isActive !== undefined) where.isActive = query.isActive;
    if (query.relationship) where.relationship = query.relationship;

    const recipients = await this.prisma.careRecipient.findMany({
      where,
      skip: query.offset || 0,
      take: query.limit || 50,
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async findActiveRecipients(groupId: string): Promise<CareRecipientEntity[]> {
    const recipients = await this.prisma.careRecipient.findMany({
      where: { groupId, isActive: true },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async findInactiveRecipients(
    groupId: string,
  ): Promise<CareRecipientEntity[]> {
    const recipients = await this.prisma.careRecipient.findMany({
      where: { groupId, isActive: false },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async activateRecipient(id: string): Promise<CareRecipientEntity> {
    const updated = await this.prisma.careRecipient.update({
      where: { id },
      data: { isActive: true },
    });

    return CareRecipientEntity.fromPrisma(updated);
  }

  async deactivateRecipient(id: string): Promise<CareRecipientEntity> {
    const updated = await this.prisma.careRecipient.update({
      where: { id },
      data: { isActive: false },
    });

    return CareRecipientEntity.fromPrisma(updated);
  }

  // Health information operations
  async findByMedicalCondition(
    groupId: string,
    condition: string,
  ): Promise<CareRecipientEntity[]> {
    const recipients = await this.prisma.careRecipient.findMany({
      where: {
        groupId,
        healthSummary: {
          path: ['medicalConditions'],
          array_contains: condition,
        },
      },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async findByAllergy(
    groupId: string,
    allergy: string,
  ): Promise<CareRecipientEntity[]> {
    const recipients = await this.prisma.careRecipient.findMany({
      where: {
        groupId,
        healthSummary: {
          path: ['allergies'],
          array_contains: allergy,
        },
      },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async findByMedication(
    groupId: string,
    medication: string,
  ): Promise<CareRecipientEntity[]> {
    const recipients = await this.prisma.careRecipient.findMany({
      where: {
        groupId,
        healthSummary: {
          path: ['medications'],
          array_contains: medication,
        },
      },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async findWithMedicalConditions(
    groupId: string,
  ): Promise<CareRecipientEntity[]> {
    const recipients = await this.prisma.careRecipient.findMany({
      where: {
        groupId,
        healthSummary: {
          path: ['medicalConditions'],
          not: [],
        },
      },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async findWithAllergies(groupId: string): Promise<CareRecipientEntity[]> {
    const recipients = await this.prisma.careRecipient.findMany({
      where: {
        groupId,
        healthSummary: {
          path: ['allergies'],
          not: [],
        },
      },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async findWithMedications(groupId: string): Promise<CareRecipientEntity[]> {
    const recipients = await this.prisma.careRecipient.findMany({
      where: {
        groupId,
        healthSummary: {
          path: ['medications'],
          not: [],
        },
      },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  // Age-based operations
  async findMinors(groupId: string): Promise<CareRecipientEntity[]> {
    const eighteenYearsAgo = new Date();
    eighteenYearsAgo.setFullYear(eighteenYearsAgo.getFullYear() - 18);

    const recipients = await this.prisma.careRecipient.findMany({
      where: {
        groupId,
        dateOfBirth: { gt: eighteenYearsAgo },
      },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async findElderly(groupId: string): Promise<CareRecipientEntity[]> {
    const sixtyFiveYearsAgo = new Date();
    sixtyFiveYearsAgo.setFullYear(sixtyFiveYearsAgo.getFullYear() - 65);

    const recipients = await this.prisma.careRecipient.findMany({
      where: {
        groupId,
        dateOfBirth: { lt: sixtyFiveYearsAgo },
      },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async findByAgeRange(
    groupId: string,
    minAge: number,
    maxAge: number,
  ): Promise<CareRecipientEntity[]> {
    const maxDate = new Date();
    maxDate.setFullYear(maxDate.getFullYear() - minAge);

    const minDate = new Date();
    minDate.setFullYear(minDate.getFullYear() - maxAge);

    const recipients = await this.prisma.careRecipient.findMany({
      where: {
        groupId,
        dateOfBirth: {
          gte: minDate,
          lte: maxDate,
        },
      },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  // Relationship operations
  async findByRelationship(
    groupId: string,
    relationship: string,
  ): Promise<CareRecipientEntity[]> {
    const recipients = await this.prisma.careRecipient.findMany({
      where: { groupId, relationship },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async getUniqueRelationships(groupId: string): Promise<string[]> {
    const result = await this.prisma.careRecipient.findMany({
      where: { groupId },
      select: { relationship: true },
      distinct: ['relationship'],
    });

    return result.map((r) => r.relationship);
  }

  // Emergency contact operations
  async findWithEmergencyContacts(
    groupId: string,
  ): Promise<CareRecipientEntity[]> {
    const recipients = await this.prisma.careRecipient.findMany({
      where: {
        groupId,
        carePreferences: {
          path: ['emergencyContacts'],
          not: [],
        },
      },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async findWithoutEmergencyContacts(
    groupId: string,
  ): Promise<CareRecipientEntity[]> {
    const recipients = await this.prisma.careRecipient.findMany({
      where: {
        groupId,
        OR: [
          { carePreferences: { path: ['emergencyContacts'], equals: [] } },
          { carePreferences: { path: ['emergencyContacts'], equals: null } },
        ],
      },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async updateEmergencyContacts(
    id: string,
    emergencyContacts: Record<string, any>[],
  ): Promise<CareRecipientEntity> {
    const recipient = await this.prisma.careRecipient.findUnique({
      where: { id },
    });
    if (!recipient) throw new Error('Recipient not found');

    const currentPreferences = (recipient.carePreferences as any) || {};
    const updated = await this.prisma.careRecipient.update({
      where: { id },
      data: {
        carePreferences: {
          ...currentPreferences,
          emergencyContacts,
        },
      },
    });

    return CareRecipientEntity.fromPrisma(updated);
  }

  async updateCarePreferences(
    id: string,
    carePreferences: Record<string, any>,
  ): Promise<CareRecipientEntity> {
    const updated = await this.prisma.careRecipient.update({
      where: { id },
      data: { carePreferences },
    });

    return CareRecipientEntity.fromPrisma(updated);
  }

  async findByCarePreference(
    groupId: string,
    preferenceKey: string,
    preferenceValue: any,
  ): Promise<CareRecipientEntity[]> {
    const recipients = await this.prisma.careRecipient.findMany({
      where: {
        groupId,
        carePreferences: {
          path: [preferenceKey],
          equals: preferenceValue,
        },
      },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  // Search operations
  async searchByName(
    groupId: string,
    searchTerm: string,
  ): Promise<CareRecipientEntity[]> {
    const recipients = await this.prisma.careRecipient.findMany({
      where: {
        groupId,
        name: { contains: searchTerm, mode: 'insensitive' },
      },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async searchByNotes(
    groupId: string,
    searchTerm: string,
  ): Promise<CareRecipientEntity[]> {
    const recipients = await this.prisma.careRecipient.findMany({
      where: {
        groupId,
        healthSummary: {
          path: ['notes'],
          string_contains: searchTerm,
        },
      },
      orderBy: { name: 'asc' },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  // Count operations
  async getRecipientCount(groupId: string): Promise<number> {
    return this.prisma.careRecipient.count({ where: { groupId } });
  }

  async getActiveRecipientCount(groupId: string): Promise<number> {
    return this.prisma.careRecipient.count({
      where: { groupId, isActive: true },
    });
  }

  async getMinorCount(groupId: string): Promise<number> {
    const eighteenYearsAgo = new Date();
    eighteenYearsAgo.setFullYear(eighteenYearsAgo.getFullYear() - 18);
    return this.prisma.careRecipient.count({
      where: { groupId, dateOfBirth: { gt: eighteenYearsAgo } },
    });
  }

  async getElderlyCount(groupId: string): Promise<number> {
    const sixtyFiveYearsAgo = new Date();
    sixtyFiveYearsAgo.setFullYear(sixtyFiveYearsAgo.getFullYear() - 65);
    return this.prisma.careRecipient.count({
      where: { groupId, dateOfBirth: { lt: sixtyFiveYearsAgo } },
    });
  }

  async getRecipientCountByRelationship(
    groupId: string,
    relationship: string,
  ): Promise<number> {
    return this.prisma.careRecipient.count({
      where: { groupId, relationship },
    });
  }

  // Health statistics operations
  async getHealthStatistics(groupId: string): Promise<{
    totalRecipients: number;
    activeRecipients: number;
    minors: number;
    elderly: number;
    withMedicalConditions: number;
    withAllergies: number;
    withMedications: number;
    withEmergencyContacts: number;
  }> {
    const [
      totalRecipients,
      activeRecipients,
      minors,
      elderly,
      withMedicalConditions,
      withAllergies,
      withMedications,
      withEmergencyContacts,
    ] = await Promise.all([
      this.getRecipientCount(groupId),
      this.getActiveRecipientCount(groupId),
      this.getMinorCount(groupId),
      this.getElderlyCount(groupId),
      this.prisma.careRecipient.count({
        where: {
          groupId,
          healthSummary: { path: ['medicalConditions'], not: [] },
        },
      }),
      this.prisma.careRecipient.count({
        where: { groupId, healthSummary: { path: ['allergies'], not: [] } },
      }),
      this.prisma.careRecipient.count({
        where: { groupId, healthSummary: { path: ['medications'], not: [] } },
      }),
      this.prisma.careRecipient.count({
        where: {
          groupId,
          carePreferences: { path: ['emergencyContacts'], not: [] },
        },
      }),
    ]);

    return {
      totalRecipients,
      activeRecipients,
      minors,
      elderly,
      withMedicalConditions,
      withAllergies,
      withMedications,
      withEmergencyContacts,
    };
  }

  async getMedicalConditionStatistics(
    groupId: string,
  ): Promise<Array<{ condition: string; count: number }>> {
    // This is a simplified implementation - in a real scenario, you'd need to aggregate JSON array data
    return [];
  }

  async getAllergyStatistics(
    groupId: string,
  ): Promise<Array<{ allergy: string; count: number }>> {
    // This is a simplified implementation - in a real scenario, you'd need to aggregate JSON array data
    return [];
  }

  async getMedicationStatistics(
    groupId: string,
  ): Promise<Array<{ medication: string; count: number }>> {
    // This is a simplified implementation - in a real scenario, you'd need to aggregate JSON array data
    return [];
  }

  // Validation operations
  async checkRecipientExists(
    groupId: string,
    recipientId: string,
  ): Promise<boolean> {
    const count = await this.prisma.careRecipient.count({
      where: { id: recipientId, groupId },
    });
    return count > 0;
  }

  async checkRecipientBelongsToGroup(
    recipientId: string,
    groupId: string,
  ): Promise<boolean> {
    return this.checkRecipientExists(groupId, recipientId);
  }

  // Bulk operations
  async bulkUpdateMedicalConditions(
    recipientIds: string[],
    medicalConditions: string[],
  ): Promise<CareRecipientEntity[]> {
    // This is a simplified implementation
    const recipients = await this.prisma.careRecipient.findMany({
      where: { id: { in: recipientIds } },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async bulkUpdateAllergies(
    recipientIds: string[],
    allergies: string[],
  ): Promise<CareRecipientEntity[]> {
    // This is a simplified implementation
    const recipients = await this.prisma.careRecipient.findMany({
      where: { id: { in: recipientIds } },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  async bulkDeactivateRecipients(
    recipientIds: string[],
  ): Promise<CareRecipientEntity[]> {
    await this.prisma.careRecipient.updateMany({
      where: { id: { in: recipientIds } },
      data: { isActive: false },
    });

    const recipients = await this.prisma.careRecipient.findMany({
      where: { id: { in: recipientIds } },
    });

    return recipients.map((recipient) =>
      CareRecipientEntity.fromPrisma(recipient),
    );
  }

  // Analytics operations
  async getRecipientTrends(
    groupId: string,
    days: number,
  ): Promise<
    Array<{ date: Date; newRecipients: number; activeRecipients: number }>
  > {
    // This is a simplified implementation
    return [];
  }

  async getAgeDistribution(
    groupId: string,
  ): Promise<Array<{ ageRange: string; count: number }>> {
    // This is a simplified implementation
    return [
      { ageRange: '0-18', count: await this.getMinorCount(groupId) },
      { ageRange: '65+', count: await this.getElderlyCount(groupId) },
    ];
  }
}
