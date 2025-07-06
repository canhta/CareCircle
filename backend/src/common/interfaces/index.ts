// Import and re-export non-conflicting interfaces
export * from './request.interfaces';
export * from './response.interfaces';
export * from './error.interfaces';
export * from './notification.interfaces';
export * from './notification-tracking.interfaces';
export * from './notification-behavior.interfaces';
export * from './user.interfaces';
export * from './ai.interfaces';

// Explicitly re-export from models.interfaces to avoid conflicts
import {
  AnalyticsDataPoint,
  HealthMetrics,
  TimeSeriesDataPoint,
} from './models.interfaces';

export { AnalyticsDataPoint, HealthMetrics, TimeSeriesDataPoint };

// Explicitly re-export from daily-check-in.interfaces to avoid conflicts
import {
  CheckInInsight,
  WeeklyInsightsSummary,
  CheckInInsightEntry,
  NotificationResponseData,
} from './daily-check-in.interfaces';

export {
  CheckInInsight,
  WeeklyInsightsSummary,
  CheckInInsightEntry,
  NotificationResponseData,
};

// Explicitly re-export from health-data.interfaces
import {
  HealthDataRecord,
  HealthRiskAssessment,
  HealthAnalysisResult,
  HealthDataQueryParams,
  HealthDataBatchEntry,
  HealthDataStatistics,
  HealthSummary,
  HealthDataPoint,
  HealthMetricsUpdate,
  HealthDataSyncResult,
  AsyncSyncResponse,
  QueueStats,
  SyncJobOptions,
  ProcessingJobOptions,
  HealthDataAccessLogEntry,
  HealthDataSyncJobData,
  QueueHealthDataPoint,
  HealthDataProcessingOptions,
} from './health-data.interfaces';

export {
  HealthDataRecord,
  HealthRiskAssessment,
  HealthAnalysisResult,
  HealthDataQueryParams,
  HealthDataBatchEntry,
  HealthDataStatistics,
  HealthSummary,
  HealthDataPoint,
  HealthMetricsUpdate,
  HealthDataSyncResult,
  AsyncSyncResponse,
  QueueStats,
  SyncJobOptions,
  ProcessingJobOptions,
  HealthDataAccessLogEntry,
  HealthDataSyncJobData,
  QueueHealthDataPoint,
  HealthDataProcessingOptions,
};

// Explicitly re-export from analytics.interfaces
import {
  BaselineMetrics,
  MetricAccumulator,
  HealthTrend,
  AnomalyDetection,
  ResponseAnalysisResult,
} from './analytics.interfaces';

export {
  BaselineMetrics,
  MetricAccumulator,
  HealthTrend,
  AnomalyDetection,
  ResponseAnalysisResult,
};

// Export CheckInResponse from analytics.interfaces explicitly
export { CheckInResponse as AnalyticsCheckInResponse } from './analytics.interfaces';

// Export CheckInResponse from daily-check-in.interfaces explicitly
export { CheckInResponse as DailyCheckInResponse } from './daily-check-in.interfaces';

// Export HistoricalContext from models.interfaces explicitly
export { HistoricalContext as ModelsHistoricalContext } from './models.interfaces';

// Export HistoricalContext from analytics.interfaces explicitly
export { HistoricalContext as AnalyticsHistoricalContext } from './analytics.interfaces';

/**
 * Default page size for pagination
 */
export const DEFAULT_PAGE_SIZE = 20;

/**
 * Maximum allowed page size for pagination
 */
export const MAX_PAGE_SIZE = 100;

/**
 * Default timeout for requests in milliseconds
 */
export const DEFAULT_TIMEOUT = 30000; // 30 seconds
