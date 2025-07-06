/**
 * Interfaces for health summary functionality
 */

/**
 * Represents a period for health data summary
 */
export type HealthSummaryPeriod = 'week' | 'month' | 'year';

/**
 * Trend direction for health metrics
 */
export type TrendDirection = 'up' | 'down' | 'stable';

/**
 * Detailed trend information for a metric
 */
export interface MetricTrend {
  change: string;
  direction: TrendDirection;
}

/**
 * Health summary data structure
 */
export interface HealthSummary {
  period: HealthSummaryPeriod;
  startDate: Date;
  endDate: Date;
  totalDays: number;
  averages: Record<string, number>;
  trends: Record<string, MetricTrend>;
  lastUpdated: Date;
}

/**
 * Metric calculation helpers
 */
export interface MetricCalculationData {
  [key: string]: number;
}
