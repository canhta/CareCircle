import { HealthProfile, HealthGoal } from '../entities/health-profile.entity';

export abstract class HealthProfileRepository {
  abstract create(profile: HealthProfile): Promise<HealthProfile>;
  abstract findById(id: string): Promise<HealthProfile | null>;
  abstract findByUserId(userId: string): Promise<HealthProfile | null>;
  abstract update(
    id: string,
    updates: Partial<HealthProfile>,
  ): Promise<HealthProfile>;
  abstract delete(id: string): Promise<void>;

  // Health goals operations
  abstract addHealthGoal(
    profileId: string,
    goal: HealthGoal,
  ): Promise<HealthProfile>;
  abstract updateHealthGoal(
    profileId: string,
    goalId: string,
    updates: Partial<HealthGoal>,
  ): Promise<HealthProfile>;
  abstract removeHealthGoal(
    profileId: string,
    goalId: string,
  ): Promise<HealthProfile>;

  // Health conditions operations
  abstract addHealthCondition(
    profileId: string,
    condition: any,
  ): Promise<HealthProfile>;
  abstract updateHealthCondition(
    profileId: string,
    conditionId: string,
    updates: any,
  ): Promise<HealthProfile>;
  abstract removeHealthCondition(
    profileId: string,
    conditionId: string,
  ): Promise<HealthProfile>;

  // Allergies operations
  abstract addAllergy(profileId: string, allergy: any): Promise<HealthProfile>;
  abstract removeAllergy(
    profileId: string,
    allergen: string,
  ): Promise<HealthProfile>;

  // Risk factors operations
  abstract addRiskFactor(
    profileId: string,
    riskFactor: any,
  ): Promise<HealthProfile>;
  abstract removeRiskFactor(
    profileId: string,
    riskFactorType: string,
  ): Promise<HealthProfile>;
}
