/**
 * Interface for analytics data point
 */
export interface AnalyticsDataPoint {
  timestamp: Date;
  value: number;
  metric: string;
  userId?: string;
  metadata?: Record<string, unknown>;
}

/**
 * Interface for health metrics
 */
export interface HealthMetrics {
  steps?: number;
  heartRateAvg?: number;
  heartRateResting?: number;
  heartRateMax?: number;
  sleepDuration?: number; // in minutes
  sleepQuality?: number; // scale 1-10
  activeMinutes?: number;
  caloriesBurned?: number;
  distance?: number; // in meters
  weight?: number;
  bloodPressureSys?: number;
  bloodPressureDia?: number;
  bloodGlucose?: number;
  bodyTemperature?: number;
  date: Date;
}

/**
 * Interface for a time series data point
 */
export interface TimeSeriesDataPoint<T> {
  timestamp: Date;
  value: T;
  metadata?: Record<string, unknown>;
}

/**
 * Interface for historical context data
 */
export interface HistoricalContext {
  userId: string;
  startDate: Date;
  endDate: Date;
  dataPoints: number;
  metrics: HealthMetrics[];
  averages: {
    moodScore?: number;
    energyLevel?: number;
    sleepQuality?: number;
    painLevel?: number;
    stressLevel?: number;
  };
  trends: {
    moodTrend?: 'improving' | 'stable' | 'declining';
    energyTrend?: 'improving' | 'stable' | 'declining';
    sleepTrend?: 'improving' | 'stable' | 'declining';
    painTrend?: 'improving' | 'stable' | 'declining';
    stressTrend?: 'improving' | 'stable' | 'declining';
  };
  commonSymptoms: string[];
  userProfile: {
    age?: number;
    gender?: string;
    conditions?: string[];
    prescriptions?: {
      medicationName: string;
      dosage: string;
      frequency: string;
    }[];
  };
}
