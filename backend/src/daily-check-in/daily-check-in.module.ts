import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DailyCheckInService } from './daily-check-in.service';
import { DailyCheckInController } from './daily-check-in.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { AIModule } from '../ai/ai.module';
import { VectorModule } from '../vector/vector.module';
import { AnalyticsModule } from '../analytics/analytics.module';
import { InsightsModule } from '../insights/insights.module';
import { NotificationModule } from '../notification/notification.module';

@Module({
  imports: [
    ConfigModule,
    PrismaModule,
    AIModule,
    VectorModule,
    AnalyticsModule,
    InsightsModule,
    NotificationModule,
  ],
  providers: [DailyCheckInService],
  controllers: [DailyCheckInController],
  exports: [DailyCheckInService],
})
export class DailyCheckInModule {}
