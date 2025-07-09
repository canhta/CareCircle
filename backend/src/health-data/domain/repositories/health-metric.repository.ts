import { HealthMetric } from '../entities/health-metric.entity';
import { MetricType, DataSource } from '@prisma/client';

export interface MetricQuery {
  userId: string;
  metricType?: MetricType;
  startDate?: Date;
  endDate?: Date;
  source?: DataSource;
  deviceId?: string;
  limit?: number;
  offset?: number;
}

export interface MetricStatistics {
  count: number;
  average: number;
  minimum: number;
  maximum: number;
  standardDeviation: number;
  trend: 'increasing' | 'decreasing' | 'stable';
}

export abstract class HealthMetricRepository {
  abstract create(metric: HealthMetric): Promise<HealthMetric>;
  abstract findById(id: string): Promise<HealthMetric | null>;
  abstract findMany(query: MetricQuery): Promise<HealthMetric[]>;
  abstract update(
    id: string,
    updates: Partial<HealthMetric>,
  ): Promise<HealthMetric>;
  abstract delete(id: string): Promise<void>;

  // Bulk operations
  abstract createMany(metrics: HealthMetric[]): Promise<HealthMetric[]>;
  abstract deleteMany(ids: string[]): Promise<void>;

  // Query operations
  abstract getLatestMetric(
    userId: string,
    metricType: MetricType,
  ): Promise<HealthMetric | null>;
  abstract getMetricsByDateRange(
    userId: string,
    metricType: MetricType,
    startDate: Date,
    endDate: Date,
  ): Promise<HealthMetric[]>;
  abstract getMetricsByDevice(
    deviceId: string,
    limit?: number,
  ): Promise<HealthMetric[]>;
  abstract getMetricsBySource(
    userId: string,
    source: DataSource,
    limit?: number,
  ): Promise<HealthMetric[]>;

  // Analytics operations
  abstract getMetricStatistics(
    userId: string,
    metricType: MetricType,
    startDate: Date,
    endDate: Date,
  ): Promise<MetricStatistics>;
  abstract getMetricTrend(
    userId: string,
    metricType: MetricType,
    days: number,
  ): Promise<{ date: Date; value: number }[]>;
  abstract getDailyAverages(
    userId: string,
    metricType: MetricType,
    startDate: Date,
    endDate: Date,
  ): Promise<{ date: Date; average: number }[]>;

  // Validation operations
  abstract getPendingValidation(userId: string): Promise<HealthMetric[]>;
  abstract getInvalidMetrics(userId: string): Promise<HealthMetric[]>;
  abstract getSuspiciousMetrics(userId: string): Promise<HealthMetric[]>;

  // Count operations
  abstract getMetricCount(
    userId: string,
    metricType?: MetricType,
  ): Promise<number>;
  abstract getMetricCountByDateRange(
    userId: string,
    metricType: MetricType,
    startDate: Date,
    endDate: Date,
  ): Promise<number>;
}
