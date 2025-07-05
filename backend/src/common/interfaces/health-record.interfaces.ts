import { DataQuality, DataSource, HealthDataType } from '@prisma/client';

/**
 * Interface for health insights
 */
export interface HealthInsight {
  type: 'warning' | 'improvement' | 'goal_achieved' | 'recommendation';
  title: string;
  description: string;
  severity: 'low' | 'medium' | 'high';
  confidence: number; // 0-100
  actionable: boolean;
  recommendations?: string[];
  trend?: {
    direction: 'up' | 'down' | 'stable';
    percentage: number;
    period: string;
  };
}

/**
 * Interface for health trends
 */
export interface HealthTrend {
  metric: string;
  currentValue: number;
  previousValue: number;
  change: number;
  changePercentage: number;
  direction: 'up' | 'down' | 'stable';
  period: 'daily' | 'weekly' | 'monthly';
  confidence: number;
}

/**
 * Interface for health goals
 */
export interface HealthGoal {
  type: string;
  title: string;
  current: number;
  target: number;
  timeframe: string;
  priority: string;
}

/**
 * Interface for aggregated health data
 */
export interface AggregatedHealthData {
  userId: string;
  period: 'day' | 'week' | 'month' | 'year';
  startDate: Date;
  endDate: Date;
  metrics: {
    steps: {
      total: number;
      average: number;
      min: number;
      max: number;
      daysWithData: number;
    };
    heartRate: {
      average: number;
      resting: number;
      max: number;
      variability: number;
    };
    sleep: {
      averageDuration: number; // minutes
      averageQuality: number; // 1-10
      deepSleepPercentage: number;
      remSleepPercentage: number;
    };
    activity: {
      activeMinutes: number;
      caloriesBurned: number;
      distance: number;
    };
    vitals: {
      weight?: number;
      bloodPressure?: {
        systolic: number;
        diastolic: number;
      };
      bloodGlucose?: number;
      bodyTemperature?: number;
    };
  };
  insights: HealthInsight[];
  trends: HealthTrend[];
  goals: HealthGoal[];
  dataQuality: DataQuality;
}

/**
 * Interface for health metric row data
 */
export interface HealthMetricRow {
  steps: number | null;
  heartRateAvg: number | null;
  heartRateResting: number | null;
  heartRateMax: number | null;
  sleepDuration: number | null;
  activeMinutes: number | null;
  caloriesBurned: number | null;
  distance: number | null;
  weight: number | null;
  bloodPressureSys: number | null;
  bloodPressureDia: number | null;
  bloodGlucose: number | null;
  bodyTemperature: number | null;
  sleepScore: number | null;
  deepSleepDuration: number | null;
  remSleepDuration: number | null;
  date: Date;
}

/**
 * Interface for health record data from database
 */
export interface HealthRecordData {
  id: string;
  userId: string;
  dataType: HealthDataType;
  value: number;
  unit: string;
  recordedAt: Date;
  source: DataSource;
  deviceId: string | null;
  confidence: number | null;
  notes: string | null;
  year: number;
  month: number;
  day: number;
  createdAt: Date;
  updatedAt: Date;
}
