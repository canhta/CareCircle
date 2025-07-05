/**
 * Interfaces for AI services
 */

/**
 * Interface for AI generated personalized question
 */
export interface AIGeneratedQuestion {
  id: string;
  question: string;
  type: 'scale' | 'multiple_choice' | 'text' | 'boolean';
  options?: string[];
  minValue?: number;
  maxValue?: number;
  category: string;
  priority: number;
  followUpQuestions?: string[];
}

/**
 * Interface for parsed AI response
 */
export interface ParsedAIResponse {
  questions: AIGeneratedQuestion[];
}

/**
 * Interface for health metrics data used in calculations
 */
export interface HealthMetricsData {
  moodScore?: number;
  energyLevel?: number;
  sleepQuality?: number;
  painLevel?: number;
  stressLevel?: number;
  symptoms?: string[];
  notes?: string;
  date?: string;
}

/**
 * Interface for daily check-in data with metadata
 */
export interface CheckInDataWithMetadata {
  id: string;
  userId: string;
  date: Date;
  moodScore?: number | null;
  energyLevel?: number | null;
  sleepQuality?: number | null;
  painLevel?: number | null;
  stressLevel?: number | null;
  symptoms?: string[] | null;
  notes?: string | null;
  completed?: boolean | null;
  completedAt?: Date | null;
  createdAt: Date;
  updatedAt: Date;
}

/**
 * Interface for health metrics with averages
 */
export interface HealthMetricsAverages {
  averageMoodScore?: number;
  averageEnergyLevel?: number;
  averageSleepQuality?: number;
  averagePainLevel?: number;
  averageStressLevel?: number;
  commonSymptoms?: string[];
}

/**
 * Interface for user health profile
 */
export interface UserHealthProfile {
  age?: number;
  gender?: string;
  recentHealthMetrics?: HealthMetricsAverages;
  prescriptions?: {
    medicationName: string;
    dosage: string;
    frequency: string;
  }[];
  recentCheckIns?: HealthMetricsData[];
  careGroupContext?: {
    hasCaregivers: boolean;
    caregiverConcerns?: string[];
  };
}

/**
 * Interface for metric accumulator used in calculating averages
 */
export interface AIMetricAccumulator {
  moodScore: number;
  energyLevel: number;
  sleepQuality: number;
  painLevel: number;
  stressLevel: number;
  symptomCount: number;
  count: number;
}
