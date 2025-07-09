import { Injectable, Inject } from '@nestjs/common';
import {
  HealthProfile,
  BaselineMetrics,
  HealthCondition,
  Allergy,
  RiskFactor,
  HealthGoal,
} from '../../domain/entities/health-profile.entity';
import { HealthProfileRepository } from '../../domain/repositories/health-profile.repository';

@Injectable()
export class HealthProfileService {
  constructor(
    @Inject('HealthProfileRepository')
    private readonly healthProfileRepository: HealthProfileRepository,
  ) {}

  async createProfile(data: {
    userId: string;
    baselineMetrics?: Partial<BaselineMetrics>;
    healthConditions?: HealthCondition[];
    allergies?: Allergy[];
    riskFactors?: RiskFactor[];
  }): Promise<HealthProfile> {
    const profile = HealthProfile.create({
      id: this.generateId(),
      ...data,
    });

    return this.healthProfileRepository.create(profile);
  }

  async getProfileByUserId(userId: string): Promise<HealthProfile | null> {
    return this.healthProfileRepository.findByUserId(userId);
  }

  async getProfileById(id: string): Promise<HealthProfile | null> {
    return this.healthProfileRepository.findById(id);
  }

  async updateProfile(
    id: string,
    updates: {
      baselineMetrics?: Partial<BaselineMetrics>;
      healthConditions?: HealthCondition[];
      allergies?: Allergy[];
      riskFactors?: RiskFactor[];
    },
  ): Promise<HealthProfile> {
    return this.healthProfileRepository.update(
      id,
      updates as Partial<HealthProfile>,
    );
  }

  async updateBaselineMetrics(
    userId: string,
    metrics: Partial<BaselineMetrics>,
  ): Promise<HealthProfile> {
    const profile = await this.getProfileByUserId(userId);
    if (!profile) {
      throw new Error('Health profile not found');
    }

    profile.updateBaseline(metrics);
    return this.healthProfileRepository.update(profile.id, {
      baselineMetrics: profile.baselineMetrics,
    });
  }

  async addHealthCondition(
    userId: string,
    condition: HealthCondition,
  ): Promise<HealthProfile> {
    const profile = await this.getProfileByUserId(userId);
    if (!profile) {
      throw new Error('Health profile not found');
    }

    return this.healthProfileRepository.addHealthCondition(
      profile.id,
      condition,
    );
  }

  async addAllergy(userId: string, allergy: Allergy): Promise<HealthProfile> {
    const profile = await this.getProfileByUserId(userId);
    if (!profile) {
      throw new Error('Health profile not found');
    }

    return this.healthProfileRepository.addAllergy(profile.id, allergy);
  }

  async addRiskFactor(
    userId: string,
    riskFactor: RiskFactor,
  ): Promise<HealthProfile> {
    const profile = await this.getProfileByUserId(userId);
    if (!profile) {
      throw new Error('Health profile not found');
    }

    return this.healthProfileRepository.addRiskFactor(profile.id, riskFactor);
  }

  async addHealthGoal(
    userId: string,
    goal: Omit<HealthGoal, 'id'>,
  ): Promise<HealthProfile> {
    const profile = await this.getProfileByUserId(userId);
    if (!profile) {
      throw new Error('Health profile not found');
    }

    const goalWithId = {
      ...goal,
      id: this.generateId(),
    } as HealthGoal;

    return this.healthProfileRepository.addHealthGoal(profile.id, goalWithId);
  }

  async updateHealthGoal(
    userId: string,
    goalId: string,
    updates: Partial<HealthGoal>,
  ): Promise<HealthProfile> {
    const profile = await this.getProfileByUserId(userId);
    if (!profile) {
      throw new Error('Health profile not found');
    }

    return this.healthProfileRepository.updateHealthGoal(
      profile.id,
      goalId,
      updates,
    );
  }

  async removeHealthGoal(
    userId: string,
    goalId: string,
  ): Promise<HealthProfile> {
    const profile = await this.getProfileByUserId(userId);
    if (!profile) {
      throw new Error('Health profile not found');
    }

    return this.healthProfileRepository.removeHealthGoal(profile.id, goalId);
  }

  async calculateHealthScore(userId: string): Promise<{
    score: number;
    factors: {
      baseline: number;
      conditions: number;
      goals: number;
      overall: number;
    };
  }> {
    const profile = await this.getProfileByUserId(userId);
    if (!profile) {
      throw new Error('Health profile not found');
    }

    // Simple health score calculation
    let baselineScore = 100;
    let conditionsScore = 100;
    let goalsScore = 100;

    // Baseline metrics scoring
    const bmi = profile.calculateBMI();
    if (bmi > 0) {
      if (bmi < 18.5 || bmi > 30) baselineScore -= 20;
      else if (bmi > 25) baselineScore -= 10;
    }

    // Health conditions impact
    const severeConditions = profile.healthConditions.filter(
      (c) => c.severity === 'severe',
    ).length;
    const moderateConditions = profile.healthConditions.filter(
      (c) => c.severity === 'moderate',
    ).length;
    conditionsScore -= severeConditions * 15 + moderateConditions * 8;

    // Goals achievement scoring
    const activeGoals = profile.getActiveGoals();
    if (activeGoals.length > 0) {
      const averageProgress =
        activeGoals.reduce((sum, goal) => sum + goal.progress, 0) /
        activeGoals.length;
      goalsScore = Math.max(50, averageProgress);
    }

    const overallScore = Math.max(
      0,
      Math.min(100, (baselineScore + conditionsScore + goalsScore) / 3),
    );

    return {
      score: Math.round(overallScore),
      factors: {
        baseline: Math.max(0, baselineScore),
        conditions: Math.max(0, conditionsScore),
        goals: Math.max(0, goalsScore),
        overall: Math.round(overallScore),
      },
    };
  }

  async deleteProfile(id: string): Promise<void> {
    return this.healthProfileRepository.delete(id);
  }

  private generateId(): string {
    return `hp_${Date.now()}_${Math.random().toString(36).substring(2, 11)}`;
  }
}
