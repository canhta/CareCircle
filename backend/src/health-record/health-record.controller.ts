import {
  Controller,
  Get,
  Post,
  Body,
  Query,
  UseGuards,
  Req,
  BadRequestException,
  Delete,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { HealthRecordService } from './health-record.service';
import { HealthAnalysisService } from './health-analysis.service';
import {
  HealthDataSyncDto,
  HealthDataConsentDto,
  HealthMetricsQueryDto,
  HealthSyncStatusDto,
} from './dto/health-data.dto';
import { RequestWithUser } from '../common/interfaces/request.interfaces';
import {
  ApiResponse as ApiResponseType,
  SuccessResponse,
  NoContentResponse,
} from '../common/interfaces/response.interfaces';
import {
  HealthSummary,
  HealthAnalysisResult,
  HealthDataStatistics,
} from '../common/interfaces/health-data.interfaces';

@ApiTags('health-records')
@Controller('health-record')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class HealthRecordController {
  constructor(
    private readonly healthRecordService: HealthRecordService,
    private readonly healthAnalysisService: HealthAnalysisService,
  ) {}

  @Post('sync')
  @ApiOperation({ summary: 'Sync health data from mobile app' })
  @ApiResponse({ status: 201, description: 'Health data synced successfully' })
  @ApiResponse({ status: 400, description: 'Invalid health data format' })
  async syncHealthData(
    @Req() req: RequestWithUser,
    @Body() syncData: HealthDataSyncDto,
  ): Promise<SuccessResponse<{ recordsProcessed: number; syncId: string }>> {
    const userId = req.user.sub;

    try {
      const result = await this.healthRecordService.syncHealthData(
        userId,
        syncData,
      );
      return {
        success: true,
        message: 'Health data synced successfully',
        data: {
          recordsProcessed: result.recordsProcessed,
          syncId: result.syncId,
        },
      };
    } catch (error) {
      throw new BadRequestException(
        `Failed to sync health data: ${error.message}`,
      );
    }
  }

  @Post('sync-async')
  @ApiOperation({ summary: 'Sync health data asynchronously' })
  @ApiResponse({
    status: 201,
    description: 'Health data sync initiated successfully',
  })
  async syncHealthDataAsync(
    @Req() req: RequestWithUser,
    @Body() syncData: HealthDataSyncDto,
  ): Promise<
    SuccessResponse<{
      message: string;
      queueStats: {
        active: number;
        waiting: number;
        completed: number;
        failed: number;
      };
    }>
  > {
    const userId = req.user.sub;
    const result = await this.healthRecordService.syncHealthDataAsync(
      userId,
      syncData,
    );

    return {
      success: true,
      data: {
        message: result.message,
        queueStats: {
          active: result.queueStats.syncJobs || 0,
          waiting: result.queueStats.processingJobs || 0,
          completed: 0,
          failed: 0,
        },
      },
    };
  }

  @Get('metrics')
  @ApiOperation({ summary: 'Get health metrics for user' })
  @ApiResponse({
    status: 200,
    description: 'Health metrics retrieved successfully',
  })
  async getHealthMetrics(
    @Req() req: RequestWithUser,
    @Query() query: HealthMetricsQueryDto,
  ): Promise<SuccessResponse<HealthDataStatistics[]>> {
    const userId = req.user.sub;
    const result = await this.healthRecordService.getHealthMetrics(
      userId,
      query,
    );

    return {
      success: true,
      data: result.data as unknown as HealthDataStatistics[],
    };
  }

  @Get('sync-status')
  @ApiOperation({ summary: 'Get health data sync status' })
  @ApiResponse({ status: 200, type: [HealthSyncStatusDto] })
  async getSyncStatus(
    @Req() req: RequestWithUser,
  ): Promise<HealthSyncStatusDto[]> {
    const userId = req.user.sub;
    // The types between DataSource and DataSourceDto don't match
    // Need to convert here
    const statuses = await this.healthRecordService.getSyncStatus(userId);
    return statuses.map((status) => ({
      id: status.id,
      source: status.source as unknown as HealthSyncStatusDto['source'],
      lastSyncAt: status.lastSyncAt,
      syncStatus: status.syncStatus as string,
      recordsCount: status.recordsCount,
      errorMessage: status.errorMessage || undefined,
      syncFromDate: status.syncFromDate,
      syncToDate: status.syncToDate,
    }));
  }

  @Post('consent')
  @ApiOperation({ summary: 'Update health data consent preferences' })
  @ApiResponse({ status: 200, description: 'Consent updated successfully' })
  async updateConsent(
    @Req() req: RequestWithUser,
    @Body() consentData: HealthDataConsentDto,
  ): Promise<SuccessResponse<{ consentUpdated: boolean }>> {
    const userId = req.user.sub;
    const result = await this.healthRecordService.updateConsent(
      userId,
      consentData,
    );

    return {
      success: true,
      data: {
        consentUpdated: !!result,
      },
    };
  }

  @Get('consent')
  @ApiOperation({ summary: 'Get current health data consent status' })
  @ApiResponse({ status: 200, description: 'Consent status retrieved' })
  async getConsent(@Req() req: RequestWithUser): Promise<
    SuccessResponse<{
      dataTypes: string[];
      consentGranted: boolean;
      lastUpdated: Date;
    }>
  > {
    const userId = req.user.sub;
    const consent = await this.healthRecordService.getConsent(userId);

    return {
      success: true,
      data: {
        dataTypes: consent ? [consent.consentType] : [],
        consentGranted: !!consent,
        lastUpdated: consent ? consent.updatedAt : new Date(),
      },
    };
  }

  @Get('summary')
  @ApiOperation({ summary: 'Get health data summary and insights' })
  @ApiResponse({ status: 200, description: 'Health summary retrieved' })
  async getHealthSummary(
    @Req() req: RequestWithUser,
    @Query('period') period: 'week' | 'month' | 'year' = 'week',
  ): Promise<SuccessResponse<HealthSummary>> {
    const userId = req.user.sub;
    const summary = await this.healthRecordService.getHealthSummary(
      userId,
      period,
    );

    return {
      success: true,
      data: {
        userId: userId,
        date: summary.endDate,
        dailyStepCount: summary.averages?.steps || 0,
        avgHeartRate: summary.averages?.heartRateAvg || 0,
        sleepDuration: summary.averages?.sleepDuration || 0,
        activeMinutes: summary.averages?.activeMinutes || 0,
        caloriesBurned: summary.averages?.caloriesBurned || 0,
        trends: {
          stepTrend: summary.trends?.steps || 'stable',
          heartRateTrend: summary.trends?.heartRate || 'stable',
          sleepTrend: summary.trends?.sleep || 'stable',
        },
        insights: [],
      },
    };
  }

  @Post('manual-entry')
  @ApiOperation({ summary: 'Add manual health data entry' })
  @ApiResponse({ status: 201, description: 'Manual entry added successfully' })
  async addManualEntry(
    @Req() req: RequestWithUser,
    @Body() healthData: HealthDataSyncDto,
  ): Promise<SuccessResponse<{ recordId: string; timestamp: Date }>> {
    const userId = req.user.sub;

    // Ensure source is marked as manual
    healthData.source = 'MANUAL' as any;

    const result = await this.healthRecordService.addManualHealthData(
      userId,
      healthData,
    );

    return {
      success: true,
      data: {
        recordId: result.syncId,
        timestamp: new Date(),
      },
    };
  }

  @Get('queue-stats')
  @ApiOperation({ summary: 'Get health data queue statistics' })
  @ApiResponse({ status: 200, description: 'Queue statistics retrieved' })
  getQueueStats(): SuccessResponse<{
    active: number;
    waiting: number;
    completed: number;
    failed: number;
  }> {
    const stats = this.healthRecordService.getQueueStats();

    return {
      success: true,
      data: {
        active: stats.syncJobs || 0,
        waiting: stats.processingJobs || 0,
        completed: 0,
        failed: 0,
      },
    };
  }

  @Get('access-log')
  @ApiOperation({ summary: 'Get health data access log for transparency' })
  @ApiResponse({ status: 200, description: 'Access log retrieved' })
  async getAccessLog(@Req() req: RequestWithUser): Promise<
    SuccessResponse<{
      logs: Array<{
        timestamp: Date;
        action: string;
        dataType: string | null;
        actor: string;
        details: Record<string, unknown>;
      }>;
    }>
  > {
    const userId = req.user.sub;
    const logs = await this.healthRecordService.getAccessLog(userId);

    return {
      success: true,
      data: {
        logs: logs.map((log) => ({
          timestamp: log.accessedAt,
          action: log.action,
          dataType: log.dataType,
          actor: log.accessor,
          details: {
            ipAddress: log.ipAddress,
            userAgent: log.userAgent,
          },
        })),
      },
    };
  }

  @Post('export-data')
  @ApiOperation({ summary: 'Request data export for user transparency' })
  @ApiResponse({ status: 202, description: 'Data export request submitted' })
  async requestDataExport(@Req() req: RequestWithUser): Promise<
    SuccessResponse<{
      requestId: string;
      estimatedCompletionTime: Date;
    }>
  > {
    const userId = req.user.sub;
    const result = await this.healthRecordService.requestDataExport(userId);

    return {
      success: true,
      data: {
        requestId: result.requestId,
        estimatedCompletionTime: new Date(result.estimatedCompletionTime),
      },
    };
  }

  @Delete('delete-all-data')
  @ApiOperation({ summary: 'Request complete data deletion (GDPR compliance)' })
  @ApiResponse({ status: 202, description: 'Data deletion request submitted' })
  async requestDataDeletion(@Req() req: RequestWithUser): Promise<
    SuccessResponse<{
      requestId: string;
      estimatedCompletionTime: Date;
    }>
  > {
    const userId = req.user.sub;
    const result = await this.healthRecordService.requestDataDeletion(userId);

    return {
      success: true,
      data: {
        requestId: result.requestId,
        estimatedCompletionTime: result.scheduledDeletionDate,
      },
    };
  }

  @Post('revoke-consent')
  @ApiOperation({ summary: 'Revoke specific consent types' })
  @ApiResponse({ status: 200, description: 'Consent revoked successfully' })
  async revokeConsent(
    @Req() req: RequestWithUser,
    @Body() revokeData: { consentTypes: string[] },
  ): Promise<
    SuccessResponse<{
      revokedTypes: string[];
      timestamp: Date;
    }>
  > {
    const userId = req.user.sub;
    const result = await this.healthRecordService.revokeConsent(
      userId,
      revokeData.consentTypes,
    );

    return {
      success: true,
      data: {
        revokedTypes: result.revokedConsentTypes,
        timestamp: new Date(),
      },
    };
  }

  @Get('analysis')
  @ApiOperation({ summary: 'Get health data analysis and insights' })
  @ApiResponse({ status: 200, description: 'Health analysis data' })
  async getHealthAnalysis(
    @Req() req: RequestWithUser,
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
    @Query('period') period?: 'day' | 'week' | 'month' | 'year',
  ): Promise<SuccessResponse<HealthAnalysisResult>> {
    const userId = req.user.sub;

    // Default to last week if no dates provided
    const endDateObj = endDate ? new Date(endDate) : new Date();
    const startDateObj = startDate
      ? new Date(startDate)
      : new Date(endDateObj.getTime() - 7 * 24 * 60 * 60 * 1000);

    const analysisData = await this.healthAnalysisService.analyzeHealthData(
      userId,
      startDateObj,
      endDateObj,
      period || 'week',
    );

    // Convert period format to match HealthAnalysisResult
    const periodMapping = {
      day: 'daily',
      week: 'weekly',
      month: 'monthly',
      year: 'monthly', // No yearly in HealthAnalysisResult, default to monthly
    };

    return {
      success: true,
      data: {
        ...analysisData,
        period: periodMapping[analysisData.period] as
          | 'daily'
          | 'weekly'
          | 'monthly',
        risk: {
          riskLevel: 'low',
          riskScore: 0,
          primaryRiskFactors: [],
          recommendations: [],
        },
      } as unknown as HealthAnalysisResult,
    };
  }

  @Get('analysis/latest')
  @ApiOperation({ summary: 'Get latest health analysis for user' })
  @ApiResponse({ status: 200, description: 'Latest health analysis data' })
  async getLatestAnalysis(
    @Req() req: RequestWithUser,
  ): Promise<SuccessResponse<HealthAnalysisResult | null>> {
    const userId = req.user.sub;
    const analysisData =
      await this.healthAnalysisService.getLatestAnalysis(userId);

    if (!analysisData) {
      return {
        success: true,
        data: null,
      };
    }

    // Convert period format to match HealthAnalysisResult
    const periodMapping = {
      day: 'daily',
      week: 'weekly',
      month: 'monthly',
      year: 'monthly', // No yearly in HealthAnalysisResult, default to monthly
    };

    return {
      success: true,
      data: {
        ...analysisData,
        period: periodMapping[analysisData.period] as
          | 'daily'
          | 'weekly'
          | 'monthly',
        risk: {
          riskLevel: 'low',
          riskScore: 0,
          primaryRiskFactors: [],
          recommendations: [],
        },
      } as unknown as HealthAnalysisResult,
    };
  }
}
