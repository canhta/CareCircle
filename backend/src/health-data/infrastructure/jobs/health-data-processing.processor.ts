import { Processor, Process } from '@nestjs/bull';
import { Logger } from '@nestjs/common';
import { Job } from 'bull';
import {
  HealthDataValidationService,
  Gender,
} from '../services/health-data-validation.service';
import { ValidationMetricsService } from '../services/validation-metrics.service';
import { CriticalAlertService } from '../services/critical-alert.service';
import { HealthAnalyticsService } from '../../application/services/health-analytics.service';
import { QueueService } from '../../../common/queue/queue.service';

import { MetricType, DataSource, ValidationStatus } from '@prisma/client';
import { HealthMetric } from '../../domain/entities/health-metric.entity';
import { CriticalAlert } from '../services/critical-alert.service';
import {
  CriticalAlertJobData,
  HealthcareProviderNotificationData,
} from '../../../common/types';

export interface HealthDataProcessingJob {
  userId: string;
  metricId: string;
  metricType: MetricType;
  value: number;
  timestamp: Date;
  patientAge?: number;
  patientGender?: Gender;
  healthConditions?: string[];
}

export interface HealthAnalyticsJob {
  userId: string;
  metricType?: string;
  startDate?: Date;
  endDate?: Date;
}

@Processor('health-data-processing')
export class HealthDataProcessingProcessor {
  private readonly logger = new Logger(HealthDataProcessingProcessor.name);

  constructor(
    private readonly validationService: HealthDataValidationService,
    private readonly validationMetricsService: ValidationMetricsService,
    private readonly criticalAlertService: CriticalAlertService,
    private readonly analyticsService: HealthAnalyticsService,
    private readonly queueService: QueueService,
  ) {}

  @Process('validate-metric')
  async validateHealthMetric(job: Job<HealthDataProcessingJob>) {
    const { userId, metricId, metricType, value, timestamp } = job.data;

    this.logger.log(
      `Processing health metric validation for user ${userId}, metric ${metricId}`,
    );

    try {
      // Create a health metric entity for validation
      const healthMetric = HealthMetric.create({
        id: metricId,
        userId,
        metricType,
        value,
        unit: this.getDefaultUnit(metricType),
        timestamp,
        source: DataSource.MANUAL_ENTRY,
        deviceId: undefined,
        notes: undefined,
        isManualEntry: true,
        validationStatus: ValidationStatus.PENDING,
        metadata: {},
      });

      // Enhanced validation with patient context if available
      const patientAge = job.data.patientAge;
      const patientGender = job.data.patientGender;
      const healthConditions = job.data.healthConditions;

      const validationResult =
        patientAge || patientGender || healthConditions
          ? this.validationService.validateMetricEnhanced(
              healthMetric,
              patientAge,
              patientGender,
              healthConditions,
            )
          : this.validationService.validateMetric(healthMetric);

      this.logger.log(
        `Health metric validation completed for ${metricId}: ${validationResult.isValid ? 'VALID' : 'INVALID'}`,
      );

      // Record validation metrics for tracking
      this.validationMetricsService.recordValidationResult(
        userId,
        metricType,
        validationResult,
      );

      // Check for critical alerts
      const criticalAlerts =
        this.criticalAlertService.evaluateForCriticalAlerts(
          healthMetric,
          validationResult,
          patientAge,
          patientGender,
          healthConditions,
        );

      // Process critical alerts
      for (const alert of criticalAlerts) {
        await this.processCriticalAlert(alert);
      }

      // If validation fails, trigger appropriate notifications
      if (!validationResult.isValid) {
        this.logger.warn(
          `Invalid health metric detected for user ${userId}: ${validationResult.errors.join(', ')}`,
        );

        // Add validation failure notification to queue
        await this.queueService.addValidationMetricsTracking({
          userId,
          metricType: metricType.toString(),
          validationResult,
        });
      }

      return validationResult;
    } catch (error) {
      this.logger.error(
        `Failed to validate health metric ${metricId}:`,
        (error as Error).stack,
      );
      throw error;
    }
  }

  /**
   * Process critical alert by sending appropriate notifications
   */
  private async processCriticalAlert(alert: CriticalAlert): Promise<void> {
    try {
      // Add critical alert notification to queue
      const criticalAlertData: CriticalAlertJobData = {
        userId: alert.userId,
        alertId: alert.id,
        alertType: alert.type,
        priority: alert.priority,
        message: alert.message,
        healthcareProviderAlert: alert.healthcareProviderAlert,
        emergencyServicesAlert: alert.emergencyServicesAlert,
        immediateActions: alert.immediateActions,
      };

      await this.queueService.addCriticalAlertNotification(criticalAlertData);

      // If healthcare provider alert is required, add to provider notification queue
      if (alert.healthcareProviderAlert) {
        const providerNotificationData: HealthcareProviderNotificationData = {
          userId: alert.userId,
          alertType: alert.type,
          message: alert.message,
          urgency: alert.priority,
          patientData: {
            metricType: alert.metricType.toString(),
            value: alert.value,
            unit: alert.unit,
            timestamp: alert.timestamp,
            medicalGuidance: alert.medicalGuidance,
            immediateActions: alert.immediateActions,
          },
        };

        await this.queueService.addHealthcareProviderNotification(
          providerNotificationData,
        );
      }

      this.logger.log(
        `Processed critical alert ${alert.id} for user ${alert.userId}`,
      );
    } catch (error) {
      this.logger.error(
        `Failed to process critical alert ${alert.id}:`,
        (error as Error).stack,
      );
      throw error;
    }
  }

  @Process('generate-insights')
  async generateHealthInsights(job: Job<HealthAnalyticsJob>) {
    const { userId } = job.data;

    this.logger.log(`Generating health insights for user ${userId}`);

    try {
      // Generate analytics and insights using the available method
      const insights =
        await this.analyticsService.generateHealthInsights(userId);

      this.logger.log(
        `Generated ${insights.length} health insights for user ${userId}`,
      );

      return insights;
    } catch (error) {
      this.logger.error(
        `Failed to generate health insights for user ${userId}:`,
        (error as Error).stack,
      );
      throw error;
    }
  }

  @Process('generate-health-report')
  async generateHealthReport(job: Job<HealthAnalyticsJob>) {
    const { userId, startDate, endDate } = job.data;

    this.logger.log(`Generating health report for user ${userId}`);

    try {
      // Generate health report using the available method
      const report = await this.analyticsService.generateHealthReport(
        userId,
        startDate || new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // Default to 30 days ago
        endDate || new Date(),
      );

      this.logger.log(`Generated health report for user ${userId}`);

      return report;
    } catch (error) {
      this.logger.error(
        `Failed to generate health report for user ${userId}:`,
        (error as Error).stack,
      );
      throw error;
    }
  }

  /**
   * Get default unit for a metric type
   */
  private getDefaultUnit(metricType: MetricType): string {
    switch (metricType) {
      case MetricType.BLOOD_PRESSURE:
        return 'mmHg';
      case MetricType.HEART_RATE:
        return 'bpm';
      case MetricType.BLOOD_GLUCOSE:
        return 'mg/dL';
      case MetricType.TEMPERATURE:
        return '°C';
      case MetricType.WEIGHT:
        return 'kg';
      case MetricType.OXYGEN_SATURATION:
        return '%';
      case MetricType.STEPS:
        return 'steps';
      case MetricType.SLEEP_DURATION:
        return 'hours';
      case MetricType.EXERCISE_MINUTES:
        return 'minutes';
      case MetricType.MOOD:
        return 'scale';
      case MetricType.PAIN_LEVEL:
        return 'scale';
      default:
        return 'unit';
    }
  }
}
