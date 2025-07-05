/**
 * Interface for health data record
 */
export interface HealthDataRecord {
  id: string;
  userId: string;
  source: string;
  dataType: string;
  value: number | string | boolean;
  unit?: string;
  timestamp: Date;
  metadata?: Record<string, unknown>;
}

/**
 * Interface for health risk assessment
 */
export interface HealthRiskAssessment {
  riskLevel: 'low' | 'medium' | 'high' | 'critical';
  riskScore: number; // 0-10
  primaryRiskFactors: string[];
  recommendations: string[];
}

/**
 * Interface for health analysis result
 */
export interface HealthAnalysisResult {
  userId: string;
  period: 'daily' | 'weekly' | 'monthly';
  startDate: Date;
  endDate: Date;
  metrics: {
    steps?: number;
    heartRateAvg?: number;
    sleepQuality?: number;
    activeMinutes?: number;
    [key: string]: number | undefined;
  };
  trends: {
    [key: string]: 'improving' | 'stable' | 'declining';
  };
  insights: string[];
  risk: HealthRiskAssessment;
}

/**
 * Interface for health data query parameters
 */
export interface HealthDataQueryParams {
  userId: string;
  startDate?: Date | string;
  endDate?: Date | string;
  dataTypes?: string[];
  source?: string;
  limit?: number;
  sortDirection?: 'asc' | 'desc';
}

/**
 * Interface for health data batch entry
 */
export interface HealthDataBatchEntry {
  userId: string;
  dataType: string;
  value: number | string | boolean;
  unit?: string;
  timestamp: Date;
  source: string;
  metadata?: Record<string, unknown>;
}

/**
 * Interface for health data statistics
 */
export interface HealthDataStatistics {
  userId: string;
  dataType: string;
  min: number;
  max: number;
  avg: number;
  count: number;
  lastUpdated: Date;
  period: 'day' | 'week' | 'month' | 'all';
}

/**
 * Interface for health summary
 */
export interface HealthSummary {
  userId: string;
  date: Date;
  dailyStepCount: number;
  avgHeartRate: number;
  sleepDuration: number;
  activeMinutes: number;
  caloriesBurned: number;
  trends: {
    stepTrend: 'up' | 'down' | 'stable';
    heartRateTrend: 'up' | 'down' | 'stable';
    sleepTrend: 'up' | 'down' | 'stable';
  };
  insights: string[];
}

/**
 * Interface for raw health data point - must import enum types from DTOs
 * This is used internally to match the DTO structure in the service
 */
export interface HealthDataPoint {
  type: string;
  value: number;
  unit?: string;
  timestamp: Date;
  source: string;
  deviceId?: string;
  metadata?: Record<string, unknown>;
}

/**
 * Interface for health metrics update object
 */
export interface HealthMetricsUpdate {
  steps?: number;
  heartRateAvg?: number;
  weight?: number;
  height?: number;
  bloodGlucose?: number;
  bodyTemperature?: number;
  oxygenSaturation?: number;
  caloriesBurned?: number;
  distance?: number;
  [key: string]: number | undefined;
}

/**
 * Interface for health data sync result
 */
export interface HealthDataSyncResult {
  syncId: string;
  recordsProcessed: number;
  errors: string[] | null;
}

/**
 * Interface for async sync response
 */
export interface AsyncSyncResponse {
  message: string;
  queueStats: QueueStats;
}

/**
 * Interface for queue statistics
 */
export interface QueueStats {
  syncJobs: number;
  processingJobs: number;
  isProcessing: boolean;
  waiting?: number;
  active?: number;
  completed?: number;
  failed?: number;
  delayed?: number;
}

/**
 * Interface for sync job options
 */
export interface SyncJobOptions {
  priority?: string;
  retryAttempts?: number;
  delay?: number;
}

/**
 * Interface for processing job options
 */
export interface ProcessingJobOptions {
  priority?: string;
  delay?: number;
}

/**
 * Interface for health data access log entry
 */
export interface HealthDataAccessLogEntry {
  id: string;
  userId: string;
  accessedAt: Date;
  action: string;
  dataType: string | null;
  accessedBy: string | null;
  metadata?: Record<string, unknown>;
}

/**
 * Health data sync job data
 */
export interface HealthDataSyncJobData {
  /** Source of the health data */
  source: string;

  /** Start date for the sync window */
  startDate: Date;

  /** End date for the sync window */
  endDate: Date;

  /** Specific data types to sync */
  dataTypes?: string[];

  /** Options for sync behavior */
  options?: {
    /** Force re-sync of existing data */
    forceResync?: boolean;
    /** Skip validation */
    skipValidation?: boolean;
    /** Maximum records to sync */
    maxRecords?: number;
  };
}

/**
 * Queue health data point structure
 */
export interface QueueHealthDataPoint {
  /** Type of health data */
  dataType: string;

  /** Numeric value */
  value: number;

  /** Unit of measurement */
  unit?: string;

  /** When this data point was recorded */
  timestamp: Date;

  /** Source of this data point */
  source: string;

  /** Device that recorded this data */
  deviceId?: string;

  /** Any additional metadata */
  metadata?: Record<string, unknown>;
}

/**
 * Health data processing options
 */
export interface HealthDataProcessingOptions {
  /** Priority level */
  priority?: 'low' | 'normal' | 'high';

  /** Maximum number of retry attempts */
  retryAttempts?: number;
}
