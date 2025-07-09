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
    const metrics = await this.getMetricsByDateRange(
      userId,
      metricType,
      startDate,
      endDate,
    );

    if (metrics.length === 0) {
      return {
        count: 0,
        average: 0,
        minimum: 0,
        maximum: 0,
        standardDeviation: 0,
        trend: 'stable',
      };
    }

    const values = metrics.map((m) => m.value);
    const count = values.length;
    const sum = values.reduce((a, b) => a + b, 0);
    const average = sum / count;
    const minimum = Math.min(...values);
    const maximum = Math.max(...values);

    // Calculate standard deviation
    const variance =
      values.reduce((acc, val) => acc + Math.pow(val - average, 2), 0) / count;
    const standardDeviation = Math.sqrt(variance);

    // Simple trend calculation
    const firstHalf = values.slice(0, Math.floor(count / 2));
    const secondHalf = values.slice(Math.floor(count / 2));
    const firstAvg = firstHalf.reduce((a, b) => a + b, 0) / firstHalf.length;
    const secondAvg = secondHalf.reduce((a, b) => a + b, 0) / secondHalf.length;
    const change = ((secondAvg - firstAvg) / firstAvg) * 100;

    const trend =
      change > 5 ? 'increasing' : change < -5 ? 'decreasing' : 'stable';

    return {
      count,
      average,
      minimum,
      maximum,
      standardDeviation,
      trend,
    };
  }

  async getMetricTrend(
    userId: string,
    metricType: MetricType,
    days: number,
  ): Promise<{ date: Date; value: number }[]> {
    const endDate = new Date();
    const startDate = new Date();
    startDate.setDate(endDate.getDate() - days);

    const metrics = await this.getMetricsByDateRange(
      userId,
      metricType,
      startDate,
      endDate,
    );
    return metrics.map((m) => ({ date: m.timestamp, value: m.value }));
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
