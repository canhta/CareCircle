import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  Request,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { HealthMetricService } from '../../application/services/health-metric.service';
import { MetricType, DataSource } from '@prisma/client';
import { FirebaseUserPayload } from 'src/identity-access/presentation/guards/firebase-auth.guard';

@Controller('health-data/metrics')
export class HealthMetricController {
  constructor(private readonly healthMetricService: HealthMetricService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async addMetric(
    @Body()
    metricDto: {
      metricType: MetricType;
      value: number;
      unit: string;
      timestamp?: string;
      source: DataSource;
      deviceId?: string;
      notes?: string;
      isManualEntry?: boolean;
      metadata?: Record<string, any>;
    },
    @Request() req: { user: FirebaseUserPayload },
  ) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }

    return this.healthMetricService.addMetric({
      userId,
      ...metricDto,
      timestamp: metricDto.timestamp
        ? new Date(metricDto.timestamp)
        : undefined,
    });
  }

  @Post('bulk')
  @HttpCode(HttpStatus.CREATED)
  async addMetrics(
    @Body()
    metricsDto: {
      metrics: Array<{
        metricType: MetricType;
        value: number;
        unit: string;
        timestamp?: string;
        source: DataSource;
        deviceId?: string;
        notes?: string;
        isManualEntry?: boolean;
        metadata?: Record<string, any>;
      }>;
    },
    @Request() req: { user: FirebaseUserPayload },
  ) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }

    const metrics = metricsDto.metrics.map((metric) => ({
      userId,
      ...metric,
      timestamp: metric.timestamp ? new Date(metric.timestamp) : undefined,
    }));

    return this.healthMetricService.addMetrics(metrics);
  }

  @Get()
  async getMetrics(
    @Request() req: { user: FirebaseUserPayload },
    @Query('metricType') metricType?: MetricType,
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
    @Query('source') source?: DataSource,
    @Query('deviceId') deviceId?: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }

    return this.healthMetricService.getMetrics({
      userId,
      metricType,
      startDate: startDate ? new Date(startDate) : undefined,
      endDate: endDate ? new Date(endDate) : undefined,
      source,
      deviceId,
      limit: limit ? parseInt(limit) : undefined,
      offset: offset ? parseInt(offset) : undefined,
    });
  }

  @Get('latest/:metricType')
  async getLatestMetric(
    @Param('metricType') metricType: MetricType,
    @Request() req: { user: FirebaseUserPayload },
  ) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    return this.healthMetricService.getLatestMetric(userId, metricType);
  }

  @Get('statistics/:metricType')
  async getMetricStatistics(
    @Request() req: { user: FirebaseUserPayload },
    @Param('metricType') metricType: MetricType,
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing

    return this.healthMetricService.getMetricStatistics(
      userId,
      metricType,
      new Date(startDate),
      new Date(endDate),
    );
  }

  @Get('trend/:metricType')
  async getMetricTrend(
    @Request() req: { user: FirebaseUserPayload },
    @Param('metricType') metricType: MetricType,
    @Query('days') days?: string,
  ) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    const daysCount = days ? parseInt(days) : 30;

    return this.healthMetricService.getMetricTrend(
      userId,
      metricType,
      daysCount,
    );
  }

  @Get('daily-averages/:metricType')
  async getDailyAverages(
    @Request() req: { user: FirebaseUserPayload },
    @Param('metricType') metricType: MetricType,
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
  ) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }

    return this.healthMetricService.getDailyAverages(
      userId,
      metricType,
      new Date(startDate),
      new Date(endDate),
    );
  }

  @Get('anomalies/:metricType')
  async detectAnomalies(
    @Request() req: { user: FirebaseUserPayload },
    @Param('metricType') metricType: MetricType,
    @Query('days') days?: string,
  ) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    const daysCount = days ? parseInt(days) : 30;

    return this.healthMetricService.detectAnomalies(
      userId,
      metricType,
      daysCount,
    );
  }

  @Get('validation/pending')
  async getPendingValidation(@Request() req: { user: FirebaseUserPayload }) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    return this.healthMetricService.getPendingValidation(userId);
  }

  @Get('validation/suspicious')
  async getSuspiciousMetrics(@Request() req: { user: FirebaseUserPayload }) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    return this.healthMetricService.getSuspiciousMetrics(userId);
  }

  @Get('validation/invalid')
  async getInvalidMetrics(@Request() req: { user: FirebaseUserPayload }) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    return this.healthMetricService.getInvalidMetrics(userId);
  }

  @Get('count')
  async getMetricCount(
    @Request() req: { user: FirebaseUserPayload },
    @Query('metricType') metricType?: MetricType,
  ) {
    const userId = req.user?.id;
    if (!userId) {
      throw new Error('User not found');
    }
    return this.healthMetricService.getMetricCount(userId, metricType);
  }

  @Get(':id')
  async getMetric(@Param('id') id: string) {
    return this.healthMetricService.getMetric(id);
  }

  @Put(':id')
  async updateMetric(
    @Param('id') id: string,
    @Body()
    updateDto: {
      value?: number;
      unit?: string;
      notes?: string;
      metadata?: Record<string, any>;
    },
  ) {
    return this.healthMetricService.updateMetric(id, updateDto);
  }

  @Put(':id/validate')
  async validateMetric(@Param('id') id: string) {
    return this.healthMetricService.validateMetric(id);
  }

  @Delete(':id')
  async deleteMetric(@Param('id') id: string) {
    return this.healthMetricService.deleteMetric(id);
  }

  @Delete('bulk')
  async deleteMetrics(@Body() deleteDto: { ids: string[] }) {
    return this.healthMetricService.deleteMetrics(deleteDto.ids);
  }
}
