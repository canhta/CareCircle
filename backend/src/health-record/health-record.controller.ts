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
import {
  HealthDataSyncDto,
  HealthDataConsentDto,
  HealthMetricsQueryDto,
  HealthSyncStatusDto,
} from './dto/health-data.dto';

@ApiTags('health-records')
@Controller('health-record')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class HealthRecordController {
  constructor(private readonly healthRecordService: HealthRecordService) {}

  @Post('sync')
  @ApiOperation({ summary: 'Sync health data from mobile app' })
  @ApiResponse({ status: 201, description: 'Health data synced successfully' })
  @ApiResponse({ status: 400, description: 'Invalid health data format' })
  async syncHealthData(@Req() req: any, @Body() syncData: HealthDataSyncDto) {
    const userId = req.user.sub;

    try {
      const result = await this.healthRecordService.syncHealthData(
        userId,
        syncData,
      );
      return {
        success: true,
        message: 'Health data synced successfully',
        recordsProcessed: result.recordsProcessed,
        syncId: result.syncId,
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
    @Req() req: any,
    @Body() syncData: HealthDataSyncDto,
  ) {
    const userId = req.user.sub;
    return this.healthRecordService.syncHealthDataAsync(userId, syncData);
  }

  @Get('metrics')
  @ApiOperation({ summary: 'Get health metrics for user' })
  @ApiResponse({
    status: 200,
    description: 'Health metrics retrieved successfully',
  })
  async getHealthMetrics(
    @Req() req: any,
    @Query() query: HealthMetricsQueryDto,
  ) {
    const userId = req.user.sub;
    return this.healthRecordService.getHealthMetrics(userId, query);
  }

  @Get('sync-status')
  @ApiOperation({ summary: 'Get health data sync status' })
  @ApiResponse({ status: 200, type: [HealthSyncStatusDto] })
  async getSyncStatus(@Req() req: any) {
    const userId = req.user.sub;
    return this.healthRecordService.getSyncStatus(userId);
  }

  @Post('consent')
  @ApiOperation({ summary: 'Update health data consent preferences' })
  @ApiResponse({ status: 200, description: 'Consent updated successfully' })
  async updateConsent(
    @Req() req: any,
    @Body() consentData: HealthDataConsentDto,
  ) {
    const userId = req.user.sub;
    return this.healthRecordService.updateConsent(userId, consentData);
  }

  @Get('consent')
  @ApiOperation({ summary: 'Get current health data consent status' })
  @ApiResponse({ status: 200, description: 'Consent status retrieved' })
  async getConsent(@Req() req: any) {
    const userId = req.user.sub;
    return this.healthRecordService.getConsent(userId);
  }

  @Get('summary')
  @ApiOperation({ summary: 'Get health data summary and insights' })
  @ApiResponse({ status: 200, description: 'Health summary retrieved' })
  async getHealthSummary(
    @Req() req: any,
    @Query('period') period: 'week' | 'month' | 'year' = 'week',
  ) {
    const userId = req.user.sub;
    return this.healthRecordService.getHealthSummary(userId, period);
  }

  @Post('manual-entry')
  @ApiOperation({ summary: 'Add manual health data entry' })
  @ApiResponse({ status: 201, description: 'Manual entry added successfully' })
  async addManualEntry(@Req() req: any, @Body() healthData: HealthDataSyncDto) {
    const userId = req.user.sub;

    // Ensure source is marked as manual
    healthData.source = 'MANUAL' as any;

    return this.healthRecordService.addManualHealthData(userId, healthData);
  }

  @Get('queue-stats')
  @ApiOperation({ summary: 'Get health data queue statistics' })
  @ApiResponse({ status: 200, description: 'Queue statistics retrieved' })
  getQueueStats() {
    return this.healthRecordService.getQueueStats();
  }

  @Get('access-log')
  @ApiOperation({ summary: 'Get health data access log for transparency' })
  @ApiResponse({ status: 200, description: 'Access log retrieved' })
  async getAccessLog(@Req() req: any) {
    const userId = req.user.sub;
    return this.healthRecordService.getAccessLog(userId);
  }

  @Post('export-data')
  @ApiOperation({ summary: 'Request data export for user transparency' })
  @ApiResponse({ status: 202, description: 'Data export request submitted' })
  async requestDataExport(@Req() req: any) {
    const userId = req.user.sub;
    return this.healthRecordService.requestDataExport(userId);
  }

  @Delete('delete-all-data')
  @ApiOperation({ summary: 'Request complete data deletion (GDPR compliance)' })
  @ApiResponse({ status: 202, description: 'Data deletion request submitted' })
  async requestDataDeletion(@Req() req: any) {
    const userId = req.user.sub;
    return this.healthRecordService.requestDataDeletion(userId);
  }

  @Post('revoke-consent')
  @ApiOperation({ summary: 'Revoke specific consent types' })
  @ApiResponse({ status: 200, description: 'Consent revoked successfully' })
  async revokeConsent(
    @Req() req: any,
    @Body() revokeData: { consentTypes: string[] },
  ) {
    const userId = req.user.sub;
    return this.healthRecordService.revokeConsent(
      userId,
      revokeData.consentTypes,
    );
  }
}
