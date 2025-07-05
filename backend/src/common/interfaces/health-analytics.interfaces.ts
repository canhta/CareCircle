/**
 * Interface for historical health pattern data
 */
export interface HistoricalPatternData {
  userId: string;
  checkIns: CheckInData[];
  patternType?: string;
  timeframe?: string;
  metricAverages?: MetricAverages;
}

/**
 * Interface for check-in data
 */
export interface CheckInData {
  id: string;
  userId: string;
  date: Date;
  moodScore: number;
  energyLevel: number;
  sleepQuality: number;
  painLevel: number;
  stressLevel: number;
  notes?: string;
  symptoms?: string[];
  medications?: MedicationLogData[];
}

/**
 * Interface for medication log data
 */
export interface MedicationLogData {
  medicationId: string;
  medicationName: string;
  taken: boolean;
  timeOfDay?: string;
  notes?: string;
}

/**
 * Interface for metric averages
 */
export interface MetricAverages {
  avgMoodScore: number;
  avgEnergyLevel: number;
  avgSleepQuality: number;
  avgPainLevel: number;
  avgStressLevel: number;
  daysTracked?: number;
}
