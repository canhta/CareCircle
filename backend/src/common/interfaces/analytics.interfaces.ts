/**
 * Interfaces for analytics data
 */

/**
 * Historical check-in data with baseline metrics
 */
export interface HistoricalContext {
  recentCheckIns: Array<{
    id: string;
    userId: string;
    date: Date;
    moodScore?: number;
    energyLevel?: number;
    sleepQuality?: number;
    painLevel?: number;
    stressLevel?: number;
    notes?: string;
    [key: string]: unknown;
  }>;
  userProfile: {
    dateOfBirth?: Date;
    gender?: string;
    age?: number;
    prescriptions?: Array<{
      medicationName: string;
      dosage: string;
      frequency: string;
    }>;
  } | null;
  baseline: {
    avgMoodScore: number;
    avgEnergyLevel: number;
    avgSleepQuality: number;
    avgPainLevel: number;
    avgStressLevel: number;
  } | null;
  historicalAverage?: {
    avgMoodScore: number;
    avgEnergyLevel: number;
    avgSleepQuality: number;
    avgPainLevel: number;
    avgStressLevel: number;
  } | null;
}

/**
 * Baseline health metrics
 */
export interface BaselineMetrics {
  avgMoodScore: number;
  avgEnergyLevel: number;
  avgSleepQuality: number;
  avgPainLevel: number;
  avgStressLevel: number;
}

/**
 * Health metric accumulator for calculating averages
 */
export interface MetricAccumulator {
  moodScore: number;
  energyLevel: number;
  sleepQuality: number;
  painLevel: number;
  stressLevel: number;
  count: number;
}

/**
 * Health trend information
 */
export interface HealthTrend {
  metric: string;
  direction: 'improving' | 'declining' | 'stable';
  significance: 'low' | 'medium' | 'high';
  timeframe: string;
  description: string;
}

/**
 * Anomaly detection result
 */
export interface AnomalyDetection {
  type: 'mood' | 'energy' | 'sleep' | 'pain' | 'stress' | 'symptoms';
  description: string;
  severity: 'low' | 'medium' | 'high';
  confidence: number; // 0-1
  suggestedAction: string;
}

/**
 * Result of check-in response analysis
 */
export interface ResponseAnalysisResult {
  sentimentScore: number; // -1 (very negative) to 1 (very positive)
  sentimentLabel: 'positive' | 'neutral' | 'negative';
  healthConcerns: string[];
  emotionalIndicators: string[];
  riskLevel: 'low' | 'medium' | 'high';
  riskScore: number; // 0-10 scale
  keyInsights: string[];
  recommendedActions: string[];
  anomalies: AnomalyDetection[];
  trends: HealthTrend[];
}

/**
 * Check-in response data
 */
export interface CheckInResponse {
  questionId: string;
  questionText: string;
  answer: string | number | boolean | string[];
  category: string;
  timestamp: Date;
}
