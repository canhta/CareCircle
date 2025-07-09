import { Injectable, Inject } from '@nestjs/common';
import { HealthMetric } from '../../domain/entities/health-metric.entity';
import { MetricType, DataSource, ValidationStatus } from '@prisma/client';
import {
  HealthMetricRepository,
  MetricQuery,
  MetricStatistics,
} from '../../domain/repositories/health-metric.repository';

@Injectable()
export class HealthMetricService {
  constructor(
    @Inject('HealthMetricRepository')
    private readonly healthMetricRepository: HealthMetricRepository,
  ) {}

  async addMetric(data: {
    userId: string;
    metricType: MetricType;
    value: number;
    unit: string;
    timestamp?: Date;
    source: DataSource;
    deviceId?: string;
    notes?: string;
    isManualEntry?: boolean;
    metadata?: Record<string, any>;
  }): Promise<HealthMetric> {
    const metric = HealthMetric.create({
      id: this.generateId(),
      ...data,
    });

    // Validate the metric
    if (metric.validate()) {
      metric.markAsValid();
    } else {
      metric.markAsSuspicious();
    }

    return this.healthMetricRepository.create(metric);
  }

  async addMetrics(
    metrics: Array<{
      userId: string;
      metricType: MetricType;
      value: number;
      unit: string;
      timestamp?: Date;
      source: DataSource;
      deviceId?: string;
      notes?: string;
      isManualEntry?: boolean;
      metadata?: Record<string, any>;
    }>,
  ): Promise<HealthMetric[]> {
    const healthMetrics = metrics.map((data) => {
      const metric = HealthMetric.create({
        id: this.generateId(),
        ...data,
      });

      if (metric.validate()) {
        metric.markAsValid();
      } else {
        metric.markAsSuspicious();
      }

      return metric;
    });

    return this.healthMetricRepository.createMany(healthMetrics);
  }

  async getMetric(id: string): Promise<HealthMetric | null> {
    return this.healthMetricRepository.findById(id);
  }

  async getMetrics(query: MetricQuery): Promise<HealthMetric[]> {
    return this.healthMetricRepository.findMany(query);
  }

  async getLatestMetric(
    userId: string,
    metricType: MetricType,
  ): Promise<HealthMetric | null> {
    return this.healthMetricRepository.getLatestMetric(userId, metricType);
  }

  async getMetricsByDateRange(
    userId: string,
    metricType: MetricType,
    startDate: Date,
    endDate: Date,
  ): Promise<HealthMetric[]> {
    return this.healthMetricRepository.getMetricsByDateRange(
      userId,
      metricType,
      startDate,
      endDate,
    );
  }

  async getMetricStatistics(
    userId: string,
    metricType: MetricType,
    startDate: Date,
    endDate: Date,
  ): Promise<MetricStatistics> {
    return this.healthMetricRepository.getMetricStatistics(
      userId,
      metricType,
      startDate,
      endDate,
    );
  }

  async getMetricTrend(
    userId: string,
    metricType: MetricType,
    days: number,
  ): Promise<{ date: Date; value: number }[]> {
    return this.healthMetricRepository.getMetricTrend(userId, metricType, days);
  }

  async getDailyAverages(
    userId: string,
    metricType: MetricType,
    startDate: Date,
    endDate: Date,
  ): Promise<{ date: Date; average: number }[]> {
    return this.healthMetricRepository.getDailyAverages(
      userId,
      metricType,
      startDate,
      endDate,
    );
  }

  async updateMetric(
    id: string,
    updates: {
      value?: number;
      unit?: string;
      notes?: string;
      validationStatus?: ValidationStatus;
      metadata?: Record<string, any>;
    },
  ): Promise<HealthMetric> {
    return this.healthMetricRepository.update(id, updates);
  }

  async validateMetric(id: string): Promise<HealthMetric> {
    const metric = await this.healthMetricRepository.findById(id);
    if (!metric) {
      throw new Error('Metric not found');
    }

    const validationStatus = metric.validate()
      ? ValidationStatus.VALIDATED
      : ValidationStatus.REJECTED;
    return this.healthMetricRepository.update(id, { validationStatus });
  }

  async getPendingValidation(userId: string): Promise<HealthMetric[]> {
    return this.healthMetricRepository.getPendingValidation(userId);
  }

  async getSuspiciousMetrics(userId: string): Promise<HealthMetric[]> {
    return this.healthMetricRepository.getSuspiciousMetrics(userId);
  }

  async getInvalidMetrics(userId: string): Promise<HealthMetric[]> {
    return this.healthMetricRepository.getInvalidMetrics(userId);
  }

  async deleteMetric(id: string): Promise<void> {
    return this.healthMetricRepository.delete(id);
  }

  async deleteMetrics(ids: string[]): Promise<void> {
    return this.healthMetricRepository.deleteMany(ids);
  }

  async getMetricCount(
    userId: string,
    metricType?: MetricType,
  ): Promise<number> {
    return this.healthMetricRepository.getMetricCount(userId, metricType);
  }

  async detectAnomalies(
    userId: string,
    metricType: MetricType,
    days: number = 30,
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
    // Use TimescaleDB anomaly detection function for better performance
    return this.healthMetricRepository.detectAnomalies(
      userId,
      metricType,
      days,
      2.0, // 2 standard deviations threshold
    );
  }

  private generateId(): string {
    return `hm_${Date.now()}_${Math.random().toString(36).substring(2, 11)}`;
  }
}
