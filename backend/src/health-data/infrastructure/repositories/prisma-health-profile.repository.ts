import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import {
  HealthProfile,
  BaselineMetrics,
  HealthCondition,
  Allergy,
  RiskFactor,
  HealthGoal,
} from '../../domain/entities/health-profile.entity';
import { HealthProfile as PrismaHealthProfile } from '@prisma/client';
import { HealthProfileRepository } from '../../domain/repositories/health-profile.repository';

@Injectable()
export class PrismaHealthProfileRepository extends HealthProfileRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async create(profile: HealthProfile): Promise<HealthProfile> {
    const data = await this.prisma.healthProfile.create({
      data: {
        id: profile.id,
        userId: profile.userId,
        baselineMetrics: profile.baselineMetrics,
        healthConditions: profile.healthConditions,
        allergies: profile.allergies,
        riskFactors: profile.riskFactors,
        healthGoals: profile.healthGoals,
        lastUpdated: profile.lastUpdated,
        createdAt: profile.createdAt,
      },
    });

    return this.mapToEntity(data);
  }

  async findById(id: string): Promise<HealthProfile | null> {
    const data = await this.prisma.healthProfile.findUnique({
      where: { id },
    });

    return data ? this.mapToEntity(data) : null;
  }

  async findByUserId(userId: string): Promise<HealthProfile | null> {
    const data = await this.prisma.healthProfile.findUnique({
      where: { userId },
    });

    return data ? this.mapToEntity(data) : null;
  }

  async update(
    id: string,
    updates: Partial<HealthProfile>,
  ): Promise<HealthProfile> {
    const data = await this.prisma.healthProfile.update({
      where: { id },
      data: {
        ...(updates.baselineMetrics && {
          baselineMetrics: updates.baselineMetrics,
        }),
        ...(updates.healthConditions && {
          healthConditions: updates.healthConditions,
        }),
        ...(updates.allergies && {
          allergies: updates.allergies,
        }),
        ...(updates.riskFactors && {
          riskFactors: updates.riskFactors,
        }),
        ...(updates.healthGoals && {
          healthGoals: updates.healthGoals,
        }),
        lastUpdated: new Date(),
      },
    });

    return this.mapToEntity(data);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.healthProfile.delete({
      where: { id },
    });
  }

  async addHealthGoal(profileId: string, goal: any): Promise<HealthProfile> {
    const profile = await this.findById(profileId);
    if (!profile) {
      throw new Error('Profile not found');
    }

    profile.addHealthGoal(goal);
    return this.update(profileId, { healthGoals: profile.healthGoals });
  }

  async updateHealthGoal(
    profileId: string,
    goalId: string,
    updates: any,
  ): Promise<HealthProfile> {
    const profile = await this.findById(profileId);
    if (!profile) {
      throw new Error('Profile not found');
    }

    profile.updateHealthGoal(goalId, updates);
    return this.update(profileId, { healthGoals: profile.healthGoals });
  }

  async removeHealthGoal(
    profileId: string,
    goalId: string,
  ): Promise<HealthProfile> {
    const profile = await this.findById(profileId);
    if (!profile) {
      throw new Error('Profile not found');
    }

    profile.removeHealthGoal(goalId);
    return this.update(profileId, { healthGoals: profile.healthGoals });
  }

  async addHealthCondition(
    profileId: string,
    condition: HealthCondition,
  ): Promise<HealthProfile> {
    const profile = await this.findById(profileId);
    if (!profile) {
      throw new Error('Profile not found');
    }

    profile.addHealthCondition(condition);
    return this.update(profileId, {
      healthConditions: profile.healthConditions,
    });
  }

  async updateHealthCondition(
    profileId: string,
    conditionId: string,
    updates: Partial<HealthCondition>,
  ): Promise<HealthProfile> {
    const profile = await this.findById(profileId);
    if (!profile) {
      throw new Error('Profile not found');
    }

    const conditionIndex = profile.healthConditions.findIndex(
      (c) => c.name === conditionId,
    );
    if (conditionIndex !== -1) {
      profile.healthConditions[conditionIndex] = {
        ...profile.healthConditions[conditionIndex],
        ...updates,
      };
      return this.update(profileId, {
        healthConditions: profile.healthConditions,
      });
    }

    throw new Error('Health condition not found');
  }

  async removeHealthCondition(
    profileId: string,
    conditionId: string,
  ): Promise<HealthProfile> {
    const profile = await this.findById(profileId);
    if (!profile) {
      throw new Error('Profile not found');
    }

    profile.healthConditions = profile.healthConditions.filter(
      (c) => c.name !== conditionId,
    );
    return this.update(profileId, {
      healthConditions: profile.healthConditions,
    });
  }

  async addAllergy(
    profileId: string,
    allergy: Allergy,
  ): Promise<HealthProfile> {
    const profile = await this.findById(profileId);
    if (!profile) {
      throw new Error('Profile not found');
    }

    profile.addAllergy(allergy);
    return this.update(profileId, { allergies: profile.allergies });
  }

  async removeAllergy(
    profileId: string,
    allergen: string,
  ): Promise<HealthProfile> {
    const profile = await this.findById(profileId);
    if (!profile) {
      throw new Error('Profile not found');
    }

    profile.allergies = profile.allergies.filter(
      (a) => a.allergen !== allergen,
    );
    return this.update(profileId, { allergies: profile.allergies });
  }

  async addRiskFactor(
    profileId: string,
    riskFactor: RiskFactor,
  ): Promise<HealthProfile> {
    const profile = await this.findById(profileId);
    if (!profile) {
      throw new Error('Profile not found');
    }

    profile.addRiskFactor(riskFactor);
    return this.update(profileId, { riskFactors: profile.riskFactors });
  }

  async removeRiskFactor(
    profileId: string,
    riskFactorType: string,
  ): Promise<HealthProfile> {
    const profile = await this.findById(profileId);
    if (!profile) {
      throw new Error('Profile not found');
    }

    profile.riskFactors = profile.riskFactors.filter(
      (rf) => rf.type !== riskFactorType,
    );
    return this.update(profileId, { riskFactors: profile.riskFactors });
  }

  private mapToEntity(data: PrismaHealthProfile): HealthProfile {
    return new HealthProfile(
      data.id,
      data.userId,
      data.baselineMetrics as BaselineMetrics,
      data.healthConditions as HealthCondition[],
      data.allergies as Allergy[],
      data.riskFactors as RiskFactor[],
      data.healthGoals as HealthGoal[],
      data.createdAt,
      data.lastUpdated,
    );
  }
}
