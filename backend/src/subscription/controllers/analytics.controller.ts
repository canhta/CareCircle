import {
  Controller,
  Get,
  Query,
  UseGuards,
  ParseIntPipe,
  DefaultValuePipe,
  Logger,
} from '@nestjs/common';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { SubscriptionAnalyticsService } from '../services/subscription-analytics.service';
import { RequireSubscriptionFeature } from '../guards/subscription-feature.guard';

@Controller('subscription-analytics')
@UseGuards(JwtAuthGuard)
export class SubscriptionAnalyticsController {
  private readonly logger = new Logger(SubscriptionAnalyticsController.name);

  constructor(
    private readonly subscriptionAnalyticsService: SubscriptionAnalyticsService,
  ) {}

  @Get('metrics')
  @RequireSubscriptionFeature('ANALYTICS_ACCESS')
  async getSubscriptionMetrics(
    @Query('startDate') startDateStr: string,
    @Query('endDate') endDateStr: string,
  ) {
    const startDate = startDateStr
      ? new Date(startDateStr)
      : new Date(Date.now() - 30 * 24 * 60 * 60 * 1000); // Default to last 30 days
    const endDate = endDateStr ? new Date(endDateStr) : new Date();

    this.logger.log(
      `Fetching subscription metrics from ${startDate.toISOString()} to ${endDate.toISOString()}`,
    );

    return this.subscriptionAnalyticsService.getSubscriptionMetrics(
      startDate,
      endDate,
    );
  }

  @Get('payment-metrics')
  @RequireSubscriptionFeature('ANALYTICS_ACCESS')
  async getPaymentMetrics(
    @Query('startDate') startDateStr: string,
    @Query('endDate') endDateStr: string,
  ) {
    const startDate = startDateStr
      ? new Date(startDateStr)
      : new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
    const endDate = endDateStr ? new Date(endDateStr) : new Date();

    this.logger.log(
      `Fetching payment metrics from ${startDate.toISOString()} to ${endDate.toISOString()}`,
    );

    return this.subscriptionAnalyticsService.getPaymentMetrics(
      startDate,
      endDate,
    );
  }

  @Get('subscriptions-by-plan')
  @RequireSubscriptionFeature('ANALYTICS_ACCESS')
  async getSubscriptionsByPlan(
    @Query('startDate') startDateStr: string,
    @Query('endDate') endDateStr: string,
  ) {
    const startDate = startDateStr
      ? new Date(startDateStr)
      : new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
    const endDate = endDateStr ? new Date(endDateStr) : new Date();

    this.logger.log(
      `Fetching subscriptions by plan from ${startDate.toISOString()} to ${endDate.toISOString()}`,
    );

    return this.subscriptionAnalyticsService.getSubscriptionsByPlan(
      startDate,
      endDate,
    );
  }

  @Get('user-retention')
  @RequireSubscriptionFeature('ANALYTICS_ACCESS')
  async getUserRetentionMetrics(
    @Query('startDate') startDateStr: string,
    @Query('endDate') endDateStr: string,
  ) {
    const startDate = startDateStr
      ? new Date(startDateStr)
      : new Date(Date.now() - 90 * 24 * 60 * 60 * 1000); // Default to last 90 days
    const endDate = endDateStr ? new Date(endDateStr) : new Date();

    this.logger.log(
      `Fetching user retention metrics from ${startDate.toISOString()} to ${endDate.toISOString()}`,
    );

    return this.subscriptionAnalyticsService.getUserRetentionMetrics(
      startDate,
      endDate,
    );
  }

  @Get('revenue-trend')
  @RequireSubscriptionFeature('ANALYTICS_ACCESS')
  async getRevenueTrend(
    @Query('startDate') startDateStr: string,
    @Query('endDate') endDateStr: string,
    @Query('interval', new DefaultValuePipe('day'))
    interval: 'day' | 'week' | 'month',
  ) {
    const startDate = startDateStr
      ? new Date(startDateStr)
      : new Date(Date.now() - 90 * 24 * 60 * 60 * 1000);
    const endDate = endDateStr ? new Date(endDateStr) : new Date();

    this.logger.log(
      `Fetching revenue trend from ${startDate.toISOString()} to ${endDate.toISOString()} with interval ${interval}`,
    );

    return this.subscriptionAnalyticsService.getRevenueTrend(
      startDate,
      endDate,
      interval,
    );
  }
}
