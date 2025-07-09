import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { HealthMetric } from '../../domain/entities/health-metric.entity';
import {
  HealthMetricRepository,
  MetricQuery,
  MetricStatistics,
} from '../../domain/repositories/health-metric.repository';
import {
  HealthMetric as PrismaHealthMetric,
  MetricType,
  DataSource,
  ValidationStatus,
  Prisma,
} from '@prisma/client';

@Injectable()
export class PrismaHealthMetricRepository extends HealthMetricRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async create(metric: HealthMetric): Promise<HealthMetric> {
    const data = await this.prisma.healthMetric.create({
      data: {
        id: metric.id,
        userId: metric.userId,
        metricType: metric.metricType,
        value: metric.value,
        unit: metric.unit,
        timestamp: metric.timestamp,
        source: metric.source,
        deviceId: metric.deviceId,
        notes: metric.notes,
        isManualEntry: metric.isManualEntry,
        validationStatus: metric.validationStatus,
        metadata: metric.metadata,
        createdAt: metric.createdAt,
      },
    });

    return this.mapToEntity(data);
  }

  async createMany(metrics: HealthMetric[]): Promise<HealthMetric[]> {
    await this.prisma.healthMetric.createMany({
      data: metrics.map((metric) => ({
        id: metric.id,
        userId: metric.userId,
        metricType: metric.metricType,
        value: metric.value,
        unit: metric.unit,
        timestamp: metric.timestamp,
        source: metric.source,
        deviceId: metric.deviceId,
        notes: metric.notes,
        isManualEntry: metric.isManualEntry,
        validationStatus: metric.validationStatus,
        metadata: metric.metadata,
        createdAt: metric.createdAt,
      })),
    });

    // Return the created metrics by finding them
    const createdMetrics = await this.prisma.healthMetric.findMany({
      where: {
        id: { in: metrics.map((m) => m.id) },
      },
    });

    return createdMetrics.map((data) => this.mapToEntity(data));
  }

  async findById(id: string): Promise<HealthMetric | null> {
    const data = await this.prisma.healthMetric.findUnique({
      where: { id },
    });

    return data ? this.mapToEntity(data) : null;
  }

  async findMany(query: MetricQuery): Promise<HealthMetric[]> {
    const where: Prisma.HealthMetricWhereInput = {
      userId: query.userId,
    };

    if (query.metricType) where.metricType = query.metricType;
    if (query.source) where.source = query.source;
    if (query.deviceId) where.deviceId = query.deviceId;
    if (query.startDate || query.endDate) {
      where.timestamp = {};
      if (query.startDate) where.timestamp.gte = query.startDate;
      if (query.endDate) where.timestamp.lte = query.endDate;
    }

    const data = await this.prisma.healthMetric.findMany({
      where,
      orderBy: { timestamp: 'desc' },
      take: query.limit,
      skip: query.offset,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async update(
    id: string,
    updates: Partial<HealthMetric>,
  ): Promise<HealthMetric> {
    const data = await this.prisma.healthMetric.update({
      where: { id },
      data: {
        ...(updates.value !== undefined && { value: updates.value }),
        ...(updates.unit && { unit: updates.unit }),
        ...(updates.notes !== undefined && { notes: updates.notes }),
        ...(updates.validationStatus && {
          validationStatus: updates.validationStatus,
        }),
        ...(updates.metadata && {
          metadata: updates.metadata,
        }),
      },
    });

    return this.mapToEntity(data);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.healthMetric.delete({
      where: { id },
    });
  }

  async deleteMany(ids: string[]): Promise<void> {
    await this.prisma.healthMetric.deleteMany({
      where: { id: { in: ids } },
    });
  }

  async getLatestMetric(
    userId: string,
    metricType: MetricType,
  ): Promise<HealthMetric | null> {
    const data = await this.prisma.healthMetric.findFirst({
      where: {
        userId,
        metricType: metricType,
      },
      orderBy: { timestamp: 'desc' },
    });

    return data ? this.mapToEntity(data) : null;
  }

  async getMetricsByDateRange(
    userId: string,
    metricType: MetricType,
    startDate: Date,
    endDate: Date,
  ): Promise<HealthMetric[]> {
    const data = await this.prisma.healthMetric.findMany({
      where: {
        userId,
        metricType: metricType,
        timestamp: {
          gte: startDate,
          lte: endDate,
        },
      },
      orderBy: { timestamp: 'asc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async getMetricsByDevice(
    deviceId: string,
    limit?: number,
  ): Promise<HealthMetric[]> {
    const data = await this.prisma.healthMetric.findMany({
      where: { deviceId },
      orderBy: { timestamp: 'desc' },
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async getMetricsBySource(
    userId: string,
    source: DataSource,
    limit?: number,
  ): Promise<HealthMetric[]> {
    const data = await this.prisma.healthMetric.findMany({
      where: {
        userId,
        source: source,
      },
      orderBy: { timestamp: 'desc' },
      take: limit,
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async getMetricStatistics(
    userId: string,
    metricType: MetricType,
    startDate: Date,
    endDate: Date,
  ): Promise<MetricStatistics> {
    // Use TimescaleDB continuous aggregates for better performance
    const result = await this.prisma.$queryRaw<
      Array<{
        count: bigint;
        avg_value: number;
        min_value: number;
        max_value: number;
        std_deviation: number;
      }>
    >`
      SELECT
        COUNT(*) as count,
        AVG(avg_value) as avg_value,
        MIN(min_value) as min_value,
        MAX(max_value) as max_value,
        AVG(std_deviation) as std_deviation
      FROM health_metrics_daily_avg
      WHERE "userId" = ${userId}
        AND "metricType" = ${metricType}::"MetricType"
        AND day >= ${startDate}
        AND day <= ${endDate}
    `;

    if (result.length === 0 || result[0].count === 0n) {
      return {
        count: 0,
        average: 0,
        minimum: 0,
        maximum: 0,
        standardDeviation: 0,
        trend: 'stable',
      };
    }

    const stats = result[0];

    // Calculate trend using TimescaleDB function
    const trendResult = await this.prisma.$queryRaw<
      Array<{
        trend_direction: string;
        trend_strength: number;
        correlation_coefficient: number;
      }>
    >`
      SELECT * FROM calculate_metric_trend(
        ${userId},
        ${metricType}::text,
        ${Math.ceil((endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24))}
      )
    `;

    const trend =
      trendResult.length > 0
        ? (trendResult[0].trend_direction as
            | 'increasing'
            | 'decreasing'
            | 'stable')
        : 'stable';

    return {
      count: Number(stats.count),
      average: stats.avg_value || 0,
      minimum: stats.min_value || 0,
      maximum: stats.max_value || 0,
      standardDeviation: stats.std_deviation || 0,
      trend,
    };
  }

  async getMetricTrend(
    userId: string,
    metricType: MetricType,
    days: number,
  ): Promise<{ date: Date; value: number }[]> {
    // Use TimescaleDB daily aggregates for better performance
    const result = await this.prisma.$queryRaw<
      Array<{
        day: Date;
        avg_value: number;
      }>
    >`
      SELECT day, avg_value
      FROM health_metrics_daily_avg
      WHERE "userId" = ${userId}
        AND "metricType" = ${metricType}::"MetricType"
        AND day >= NOW() - INTERVAL '${days} days'
      ORDER BY day ASC
    `;

    return result.map((row) => ({
      date: row.day,
      value: row.avg_value,
    }));
  }

  async getDailyAverages(
    userId: string,
    metricType: MetricType,
    startDate: Date,
    endDate: Date,
  ): Promise<{ date: Date; average: number }[]> {
    // This would be more efficiently done with SQL aggregation
    // For now, implementing a basic version
    const metrics = await this.getMetricsByDateRange(
      userId,
      metricType,
      startDate,
      endDate,
    );

    const dailyGroups: { [key: string]: number[] } = {};

    metrics.forEach((metric) => {
      const dateKey = metric.timestamp.toISOString().split('T')[0];
      if (!dailyGroups[dateKey]) {
        dailyGroups[dateKey] = [];
      }
      dailyGroups[dateKey].push(metric.value);
    });

    return Object.entries(dailyGroups).map(([dateStr, values]) => ({
      date: new Date(dateStr),
      average: values.reduce((a, b) => a + b, 0) / values.length,
    }));
  }

  async getPendingValidation(userId: string): Promise<HealthMetric[]> {
    const data = await this.prisma.healthMetric.findMany({
      where: {
        userId,
        validationStatus: ValidationStatus.PENDING,
      },
      orderBy: { timestamp: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async getInvalidMetrics(userId: string): Promise<HealthMetric[]> {
    const data = await this.prisma.healthMetric.findMany({
      where: {
        userId,
        validationStatus: ValidationStatus.REJECTED,
      },
      orderBy: { timestamp: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async getSuspiciousMetrics(userId: string): Promise<HealthMetric[]> {
    const data = await this.prisma.healthMetric.findMany({
      where: {
        userId,
        validationStatus: ValidationStatus.FLAGGED,
      },
      orderBy: { timestamp: 'desc' },
    });

    return data.map((item) => this.mapToEntity(item));
  }

  async getMetricCount(
    userId: string,
    metricType?: MetricType,
  ): Promise<number> {
    const where: Prisma.HealthMetricWhereInput = { userId };
    if (metricType) where.metricType = metricType;

    return this.prisma.healthMetric.count({ where });
  }

  async getMetricCountByDateRange(
    userId: string,
    metricType: MetricType,
    startDate: Date,
    endDate: Date,
  ): Promise<number> {
    return this.prisma.healthMetric.count({
      where: {
        userId,
        metricType: metricType,
        timestamp: {
          gte: startDate,
          lte: endDate,
        },
      },
    });
  }

  // TimescaleDB-specific operations
  async detectAnomalies(
    userId: string,
    metricType: MetricType,
    days: number,
    stdThreshold: number = 2.0,
  ): Promise<{
    anomalies: Array<{
      timestamp: Date;
      value: number;
      zScore: number;
      isAnomaly: boolean;
    }>;
    totalAnomalies: number;
    anomalyRate: number;
  }> {
    const result = await this.prisma.$queryRaw<
      Array<{
        timestamp: Date;
        value: number;
        z_score: number;
        is_anomaly: boolean;
      }>
    >`
      SELECT * FROM detect_metric_anomalies(
        ${userId},
        ${metricType}::text,
        ${days},
        ${stdThreshold}
      )
    `;

    const anomalies = result.map((row) => ({
      timestamp: row.timestamp,
      value: row.value,
      zScore: row.z_score,
      isAnomaly: row.is_anomaly,
    }));

    const totalAnomalies = anomalies.filter((a) => a.isAnomaly).length;
    const anomalyRate = result.length > 0 ? totalAnomalies / result.length : 0;

    return {
      anomalies,
      totalAnomalies,
      anomalyRate,
    };
  }

  async getLatestMetricValue(
    userId: string,
    metricType: MetricType,
  ): Promise<{
    value: number;
    unit: string;
    timestamp: Date;
    source: string;
  } | null> {
    const result = await this.prisma.$queryRaw<
      Array<{
        value: number;
        unit: string;
        timestamp: Date;
        source: string;
      }>
    >`
      SELECT * FROM get_latest_metric_value(
        ${userId},
        ${metricType}::text
      )
    `;

    return result.length > 0 ? result[0] : null;
  }

  async calculateTrendAnalysis(
    userId: string,
    metricType: MetricType,
    days: number,
  ): Promise<{
    trendDirection:
      | 'increasing'
      | 'decreasing'
      | 'stable'
      | 'insufficient_data';
    trendStrength: number;
    correlationCoefficient: number;
  }> {
    const result = await this.prisma.$queryRaw<
      Array<{
        trend_direction: string;
        trend_strength: number;
        correlation_coefficient: number;
      }>
    >`
      SELECT * FROM calculate_metric_trend(
        ${userId},
        ${metricType}::text,
        ${days}
      )
    `;

    if (result.length === 0) {
      return {
        trendDirection: 'insufficient_data',
        trendStrength: 0,
        correlationCoefficient: 0,
      };
    }

    const trend = result[0];
    return {
      trendDirection: trend.trend_direction as
        | 'increasing'
        | 'decreasing'
        | 'stable'
        | 'insufficient_data',
      trendStrength: trend.trend_strength,
      correlationCoefficient: trend.correlation_coefficient,
    };
  }

  private mapToEntity(data: PrismaHealthMetric): HealthMetric {
    return new HealthMetric(
      data.id,
      data.userId,
      data.metricType,
      data.value,
      data.unit,
      data.timestamp,
      data.source,
      data.deviceId,
      data.notes,
      data.isManualEntry,
      data.validationStatus,
      data.metadata as Record<string, any>,
      data.createdAt,
    );
  }
}
