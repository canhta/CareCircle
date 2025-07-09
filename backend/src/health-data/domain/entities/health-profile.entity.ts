export interface BaselineMetrics {
  height: number;
  weight: number;
  bmi: number;
  restingHeartRate: number;
  bloodPressure: {
    systolic: number;
    diastolic: number;
  };
  bloodGlucose: number;
  [key: string]: any; // Add index signature for JSON compatibility
}

export interface HealthCondition {
  name: string;
  diagnosisDate?: Date;
  isCurrent: boolean;
  severity: 'mild' | 'moderate' | 'severe';
  medications?: string[];
  notes?: string;
  [key: string]: any; // Add index signature for JSON compatibility
}

export interface Allergy {
  allergen: string;
  reactionType: string;
  severity: 'mild' | 'moderate' | 'severe';
  [key: string]: any; // Add index signature for JSON compatibility
}

export interface RiskFactor {
  type: string;
  description: string;
  riskLevel: 'low' | 'medium' | 'high';
  [key: string]: any; // Add index signature for JSON compatibility
}

export interface HealthGoal {
  id: string;
  metricType: string;
  targetValue: number;
  unit: string;
  startDate: Date;
  targetDate: Date;
  currentValue: number;
  progress: number; // 0-100%
  status: 'active' | 'achieved' | 'behind' | 'abandoned';
  recurrence: 'once' | 'daily' | 'weekly' | 'monthly';
  [key: string]: any; // Add index signature for JSON compatibility
}

export class HealthProfile {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public baselineMetrics: BaselineMetrics,
    public healthConditions: HealthCondition[],
    public allergies: Allergy[],
    public riskFactors: RiskFactor[],
    public healthGoals: HealthGoal[],
    public readonly createdAt: Date,
    public lastUpdated: Date,
  ) {}

  static create(data: {
    id: string;
    userId: string;
    baselineMetrics?: Partial<BaselineMetrics>;
    healthConditions?: HealthCondition[];
    allergies?: Allergy[];
    riskFactors?: RiskFactor[];
    healthGoals?: HealthGoal[];
  }): HealthProfile {
    const defaultBaseline: BaselineMetrics = {
      height: 0,
      weight: 0,
      bmi: 0,
      restingHeartRate: 0,
      bloodPressure: { systolic: 0, diastolic: 0 },
      bloodGlucose: 0,
    };

    return new HealthProfile(
      data.id,
      data.userId,
      { ...defaultBaseline, ...data.baselineMetrics },
      data.healthConditions || [],
      data.allergies || [],
      data.riskFactors || [],
      data.healthGoals || [],
      new Date(),
      new Date(),
    );
  }

  updateBaseline(metrics: Partial<BaselineMetrics>): void {
    this.baselineMetrics = { ...this.baselineMetrics, ...metrics };
    this.lastUpdated = new Date();
  }

  addHealthCondition(condition: HealthCondition): void {
    this.healthConditions.push(condition);
    this.lastUpdated = new Date();
  }

  addAllergy(allergy: Allergy): void {
    this.allergies.push(allergy);
    this.lastUpdated = new Date();
  }

  addRiskFactor(riskFactor: RiskFactor): void {
    this.riskFactors.push(riskFactor);
    this.lastUpdated = new Date();
  }

  addHealthGoal(goal: HealthGoal): void {
    this.healthGoals.push(goal);
    this.lastUpdated = new Date();
  }

  updateHealthGoal(goalId: string, updates: Partial<HealthGoal>): void {
    const goalIndex = this.healthGoals.findIndex((g) => g.id === goalId);
    if (goalIndex !== -1) {
      this.healthGoals[goalIndex] = {
        ...this.healthGoals[goalIndex],
        ...updates,
      };
      this.lastUpdated = new Date();
    }
  }

  removeHealthGoal(goalId: string): void {
    this.healthGoals = this.healthGoals.filter((g) => g.id !== goalId);
    this.lastUpdated = new Date();
  }

  calculateBMI(): number {
    if (this.baselineMetrics.height > 0 && this.baselineMetrics.weight > 0) {
      const heightInMeters = this.baselineMetrics.height / 100;
      return this.baselineMetrics.weight / (heightInMeters * heightInMeters);
    }
    return 0;
  }

  getActiveGoals(): HealthGoal[] {
    return this.healthGoals.filter((goal) => goal.status === 'active');
  }

  getAchievedGoals(): HealthGoal[] {
    return this.healthGoals.filter((goal) => goal.status === 'achieved');
  }
}
