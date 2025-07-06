import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { HealthDataQueueService } from './health-data-queue.service';
import {
  HealthDataSyncDto,
  HealthDataConsentDto,
  HealthMetricsQueryDto,
  HealthDataTypeDto,
  DataSourceDto,
  HealthDataPointDto,
} from './dto/health-data.dto';
import {
  HealthDataType,
  DataSource,
  SyncStatus,
  ConsentType,
  Prisma,
  HealthMetrics,
} from '@prisma/client';
import {
  HealthDataPoint,
  HealthMetricsUpdate,
  HealthDataSyncResult,
  AsyncSyncResponse,
  QueueStats,
} from '../common/interfaces/health-data.interfaces';
import {
  HealthSummary,
  HealthSummaryPeriod,
  MetricCalculationData,
  MetricTrend,
} from '../common/interfaces/health-summary.interfaces';
import {
  HealthDataSyncJobData,
  QueueHealthDataPoint,
} from '../common/interfaces/health-data.interfaces';

@Injectable()
export class HealthRecordService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly queueService: HealthDataQueueService,
  ) {}

  async syncHealthData(
    userId: string,
    syncData: HealthDataSyncDto,
  ): Promise<HealthDataSyncResult> {
    // Create sync record
    const syncRecord = await this.prisma.healthDataSync.create({
      data: {
        userId,
        source: this.mapDataSource(syncData.source),
        lastSyncAt: new Date(),
        syncStatus: SyncStatus.IN_PROGRESS,
        syncFromDate: syncData.syncStartDate,
        syncToDate: syncData.syncEndDate,
        recordsCount: syncData.data.length,
      },
    });

    let processedCount = 0;
    const errors: string[] = [];

    try {
      // Process health data points
      for (const dataPoint of syncData.data) {
        try {
          await this.processHealthDataPoint(userId, dataPoint, syncRecord.id);
          processedCount++;
        } catch (error) {
          if (error instanceof BadRequestException) {
            errors.push(`Error processing data point: ${error.message}`);
          }
        }
      }

      // Update sync status
      await this.prisma.healthDataSync.update({
        where: { id: syncRecord.id },
        data: {
          syncStatus:
            errors.length > 0 ? SyncStatus.PARTIAL : SyncStatus.COMPLETED,
          recordsCount: processedCount,
          errorMessage: errors.length > 0 ? errors.join('; ') : null,
        },
      });

      return {
        syncId: syncRecord.id,
        recordsProcessed: processedCount,
        errors: errors.length > 0 ? errors : null,
      };
    } catch (error) {
      // Update sync status to failed
      await this.prisma.healthDataSync.update({
        where: { id: syncRecord.id },
        data: {
          syncStatus: SyncStatus.FAILED,
          errorMessage: error.message,
        },
      });
      throw error;
    }
  }

  async syncHealthDataAsync(
    userId: string,
    syncData: HealthDataSyncDto,
  ): Promise<AsyncSyncResponse> {
    // Create a HealthDataSyncJobData object from the DTO
    const syncJobData: HealthDataSyncJobData = {
      source: syncData.source,
      startDate: syncData.syncStartDate,
      endDate: syncData.syncEndDate,
      dataTypes: [], // No dataTypes in DTO
      options: {
        forceResync: false,
        skipValidation: false,
      },
    };

    // Add sync job to queue for asynchronous processing
    await this.queueService.addSyncJob(userId, syncJobData, {
      priority: 'normal',
      retryAttempts: 3,
    });

    // Convert HealthDataPointDto to QueueHealthDataPoint
    if (syncData.data && syncData.data.length > 0) {
      const queueDataPoints: QueueHealthDataPoint[] = syncData.data.map(
        (point) => ({
          dataType: point.type, // Add the required dataType field
          value: point.value,
          unit: point.unit,
          timestamp: new Date(point.timestamp),
          source: point.source,
          deviceId: point.deviceId,
          metadata: point.metadata,
        }),
      );

      // Also add data processing jobs for aggregation and analysis
      await this.queueService.addProcessingJob(
        userId,
        'health_metrics',
        queueDataPoints,
        'aggregate',
        { priority: 'low' },
      );

      await this.queueService.addProcessingJob(
        userId,
        'health_metrics',
        queueDataPoints,
        'analyze',
        { priority: 'low' },
      );
    }

    return {
      message: 'Health data sync queued for processing',
      queueStats: this.queueService.getQueueStats(),
    };
  }

  private async processHealthDataPoint(
    userId: string,
    dataPoint: HealthDataPointDto,
    syncId: string,
  ): Promise<void> {
    const date = new Date(dataPoint.timestamp);
    const dateOnly = new Date(
      date.getFullYear(),
      date.getMonth(),
      date.getDate(),
    );

    // Map health data to our metrics structure
    const updateData = this.mapHealthDataToMetrics(dataPoint);

    // Upsert health metrics for the date
    await this.prisma.healthMetrics.upsert({
      where: {
        userId_date: {
          userId,
          date: dateOnly,
        },
      },
      update: {
        ...updateData,
        lastSyncAt: new Date(),
        syncSource: this.mapDataSource(dataPoint.source),
      },
      create: {
        userId,
        date: dateOnly,
        lastSyncAt: new Date(),
        syncSource: this.mapDataSource(dataPoint.source),
        ...updateData,
      },
    });

    // Create detailed health record entry
    await this.prisma.healthRecord.create({
      data: {
        userId,
        dataType: this.mapHealthDataType(dataPoint.type),
        value: dataPoint.value,
        unit: dataPoint.unit || '',
        recordedAt: new Date(dataPoint.timestamp),
        source: this.mapDataSource(dataPoint.source),
        deviceId: dataPoint.deviceId,
        year: date.getFullYear(),
        month: date.getMonth() + 1,
        day: date.getDate(),
        notes: JSON.stringify({
          source: dataPoint.source,
          timestamp: dataPoint.timestamp,
          metadata: dataPoint.metadata,
          syncId,
        }),
      },
    });
  }

  private mapHealthDataToMetrics(
    dataPoint: HealthDataPointDto,
  ): HealthMetricsUpdate {
    const updates: HealthMetricsUpdate = {};

    switch (dataPoint.type) {
      case HealthDataTypeDto.STEPS:
        updates.steps = Math.round(dataPoint.value);
        break;
      case HealthDataTypeDto.HEART_RATE:
        updates.heartRateAvg = Math.round(dataPoint.value);
        break;
      case HealthDataTypeDto.WEIGHT:
        updates.weight = dataPoint.value;
        break;
      case HealthDataTypeDto.HEIGHT:
        updates.height = dataPoint.value;
        break;
      case HealthDataTypeDto.BLOOD_GLUCOSE:
        updates.bloodGlucose = dataPoint.value;
        break;
      case HealthDataTypeDto.BODY_TEMPERATURE:
        updates.bodyTemperature = dataPoint.value;
        break;
      case HealthDataTypeDto.OXYGEN_SATURATION:
        updates.oxygenSaturation = dataPoint.value;
        break;
      case HealthDataTypeDto.ACTIVE_ENERGY_BURNED:
        updates.caloriesBurned = Math.round(dataPoint.value);
        break;
      case HealthDataTypeDto.DISTANCE_WALKING_RUNNING:
        updates.distance = dataPoint.value;
        break;
      // Add more mappings as needed
    }

    return updates;
  }

  private mapDataSource(source: DataSourceDto): DataSource {
    switch (source) {
      case DataSourceDto.APPLE_HEALTH:
        return DataSource.APPLE_HEALTH;
      case DataSourceDto.GOOGLE_FIT:
        return DataSource.GOOGLE_FIT;
      case DataSourceDto.HEALTH_CONNECT:
        return DataSource.GOOGLE_FIT; // Map Health Connect to Google Fit
      case DataSourceDto.MANUAL:
        return DataSource.MANUAL;
      case DataSourceDto.DEVICE:
        return DataSource.DEVICE_SYNC; // Map Device to Device Sync
      default:
        return DataSource.MANUAL;
    }
  }

  private mapHealthDataType(type: HealthDataTypeDto): HealthDataType {
    switch (type) {
      case HealthDataTypeDto.STEPS:
        return HealthDataType.STEPS;
      case HealthDataTypeDto.HEART_RATE:
        return HealthDataType.HEART_RATE;
      case HealthDataTypeDto.BLOOD_PRESSURE:
        return HealthDataType.BLOOD_PRESSURE_SYSTOLIC;
      case HealthDataTypeDto.WEIGHT:
        return HealthDataType.WEIGHT;
      case HealthDataTypeDto.HEIGHT:
        return HealthDataType.HEIGHT;
      case HealthDataTypeDto.SLEEP_ANALYSIS:
        return HealthDataType.SLEEP_HOURS;
      case HealthDataTypeDto.BLOOD_GLUCOSE:
        return HealthDataType.BLOOD_GLUCOSE;
      case HealthDataTypeDto.BODY_TEMPERATURE:
        return HealthDataType.BODY_TEMPERATURE;
      case HealthDataTypeDto.OXYGEN_SATURATION:
        return HealthDataType.OXYGEN_SATURATION;
      case HealthDataTypeDto.ACTIVE_ENERGY_BURNED:
        return HealthDataType.CALORIES_BURNED;
      case HealthDataTypeDto.DISTANCE_WALKING_RUNNING:
        return HealthDataType.DISTANCE;
      default:
        throw new BadRequestException(
          `Unsupported health data type: ${String(type)}`,
        );
    }
  }

  async getHealthMetrics(userId: string, query: HealthMetricsQueryDto) {
    const where: Prisma.HealthMetricsWhereInput = { userId };

    if (query.startDate || query.endDate) {
      where.date = {};
      if (query.startDate) where.date.gte = query.startDate;
      if (query.endDate) where.date.lte = query.endDate;
    }

    const metrics = await this.prisma.healthMetrics.findMany({
      where,
      orderBy: { date: 'desc' },
      take: query.limit || 100,
      skip: query.offset || 0,
    });

    return {
      data: metrics,
      total: await this.prisma.healthMetrics.count({ where }),
    };
  }

  async getSyncStatus(userId: string) {
    return this.prisma.healthDataSync.findMany({
      where: { userId },
      orderBy: { lastSyncAt: 'desc' },
      take: 10,
    });
  }

  async updateConsent(userId: string, consentData: HealthDataConsentDto) {
    // Revoke previous consent if exists
    await this.prisma.healthDataConsent.updateMany({
      where: {
        userId,
        consentType: ConsentType.DATA_SHARING,
        revokedAt: null,
      },
      data: {
        revokedAt: new Date(),
      },
    });

    // Create new consent record
    return this.prisma.healthDataConsent.create({
      data: {
        userId,
        consentType: ConsentType.DATA_SHARING,
        dataCategories: consentData.dataTypes,
        purpose: consentData.purpose,
        consentGranted: consentData.consentGranted,
        consentDate: new Date(),
        consentVersion: '1.0',
        legalBasis: consentData.legalBasis || 'Consent (GDPR Art. 6(1)(a))',
      },
    });
  }

  async getConsent(userId: string) {
    return this.prisma.healthDataConsent.findFirst({
      where: {
        userId,
        consentType: ConsentType.DATA_SHARING,
        revokedAt: null,
      },
      orderBy: { consentDate: 'desc' },
    });
  }

  async getHealthSummary(
    userId: string,
    period: HealthSummaryPeriod,
  ): Promise<HealthSummary> {
    const now = new Date();
    let startDate: Date;

    switch (period) {
      case 'week':
        startDate = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
        break;
      case 'month':
        startDate = new Date(
          now.getFullYear(),
          now.getMonth() - 1,
          now.getDate(),
        );
        break;
      case 'year':
        startDate = new Date(
          now.getFullYear() - 1,
          now.getMonth(),
          now.getDate(),
        );
        break;
    }

    const metrics = await this.prisma.healthMetrics.findMany({
      where: {
        userId,
        date: {
          gte: startDate,
          lte: now,
        },
      },
      orderBy: { date: 'asc' },
    });

    // Calculate aggregated data
    const summary: HealthSummary = {
      period,
      startDate,
      endDate: now,
      totalDays: metrics.length,
      averages: this.calculateAverages(metrics),
      trends: this.calculateTrends(metrics),
      lastUpdated: new Date(),
    };

    return summary;
  }

  private calculateAverages(metrics: HealthMetrics[]): Record<string, number> {
    if (metrics.length === 0) return {};

    const sums: MetricCalculationData = {};
    const counts: MetricCalculationData = {};

    metrics.forEach((metric) => {
      Object.keys(metric).forEach((key) => {
        if (typeof metric[key] === 'number' && metric[key] !== null) {
          sums[key] = (sums[key] || 0) + metric[key];
          counts[key] = (counts[key] || 0) + 1;
        }
      });
    });

    const averages: MetricCalculationData = {};
    Object.keys(sums).forEach((key) => {
      averages[key] = sums[key] / counts[key];
    });

    return averages;
  }

  private calculateTrends(
    metrics: HealthMetrics[],
  ): Record<string, MetricTrend> {
    // Simple trend calculation - compare first half vs second half
    if (metrics.length < 4) return {};

    const midpoint = Math.floor(metrics.length / 2);
    const firstHalf = metrics.slice(0, midpoint);
    const secondHalf = metrics.slice(midpoint);

    const firstAvg = this.calculateAverages(firstHalf);
    const secondAvg = this.calculateAverages(secondHalf);

    const trends: Record<string, MetricTrend> = {};
    Object.keys(firstAvg).forEach((key) => {
      if (secondAvg[key] && firstAvg[key]) {
        const change = ((secondAvg[key] - firstAvg[key]) / firstAvg[key]) * 100;
        trends[key] = {
          change: change.toFixed(2),
          direction: change > 0 ? 'up' : change < 0 ? 'down' : 'stable',
        };
      }
    });

    return trends;
  }

  async addManualHealthData(
    userId: string,
    healthData: HealthDataSyncDto,
  ): Promise<HealthDataSyncResult> {
    // Ensure all data points are marked as manual
    const manualData = {
      ...healthData,
      source: DataSourceDto.MANUAL,
      data: healthData.data.map((point) => ({
        ...point,
        source: DataSourceDto.MANUAL,
      })),
    };

    return this.syncHealthData(userId, manualData);
  }

  getQueueStats(): QueueStats {
    return this.queueService.getQueueStats();
  }

  async getAccessLog(userId: string) {
    // Get health data access log for transparency
    return this.prisma.healthDataAccess.findMany({
      where: { userId },
      orderBy: { accessedAt: 'desc' },
      take: 100, // Limit to last 100 access events
      select: {
        id: true,
        action: true,
        accessor: true,
        dataType: true,
        accessedAt: true,
        ipAddress: true,
        userAgent: true,
      },
    });
  }

  async requestDataExport(userId: string) {
    // Create data export request
    const exportRequest = await this.prisma.dataExportRequest.create({
      data: {
        userId,
        requestedAt: new Date(),
        status: 'PENDING',
        exportType: 'FULL_DATA',
      },
    });

    // TODO: Queue background job to generate export file
    // For now, return success message
    return {
      message: 'Data export request submitted successfully',
      requestId: exportRequest.id,
      estimatedCompletionTime: '24 hours',
    };
  }

  async requestDataDeletion(userId: string) {
    // Create data deletion request
    const deletionRequest = await this.prisma.dataDeletionRequest.create({
      data: {
        userId,
        requestedAt: new Date(),
        status: 'PENDING',
        scheduledDeletionDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days from now
      },
    });

    // TODO: Queue background job to handle data deletion
    // For now, return success message
    return {
      message: 'Data deletion request submitted successfully',
      requestId: deletionRequest.id,
      scheduledDeletionDate: deletionRequest.scheduledDeletionDate,
      note: 'Your data will be permanently deleted within 30 days. You can cancel this request during this period.',
    };
  }

  async revokeConsent(userId: string, consentTypes: string[]) {
    // Revoke multiple consent types
    const revokedConsents: string[] = [];

    for (const consentType of consentTypes) {
      await this.prisma.healthDataConsent.updateMany({
        where: {
          userId,
          consentType: consentType as ConsentType,
          revokedAt: null,
        },
        data: {
          revokedAt: new Date(),
        },
      });
      revokedConsents.push(consentType);
    }

    // Log the consent revocation
    await this.logDataAccess(userId, 'CONSENT_REVOKED', null, {
      revokedConsentTypes: consentTypes,
    });

    return {
      message: 'Consent revoked successfully',
      revokedConsentTypes: revokedConsents,
    };
  }

  private async logDataAccess(
    userId: string,
    action: string,
    dataType: string | null,
    metadata?: Record<string, unknown>,
  ): Promise<void> {
    try {
      await this.prisma.healthDataAccess.create({
        data: {
          userId,
          action,
          accessor: 'SYSTEM', // This could be enhanced to track actual accessor
          dataType,
          accessedAt: new Date(),
          metadata: metadata ? JSON.stringify(metadata) : null,
        },
      });
    } catch (error) {
      // Log error but don't fail the main operation
      console.error('Failed to log data access:', error);
    }
  }
}
