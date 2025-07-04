import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DailyCheckInService } from './daily-check-in.service';
import { DailyCheckInController } from './daily-check-in.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { AIModule } from '../ai/ai.module';
import { VectorModule } from '../vector/vector.module';
import { AnalyticsModule } from '../analytics/analytics.module';

@Module({
  imports: [
    ConfigModule,
    PrismaModule,
    AIModule,
    VectorModule,
    AnalyticsModule,
  ],
  providers: [DailyCheckInService],
  controllers: [DailyCheckInController],
  exports: [DailyCheckInService],
})
export class DailyCheckInModule {}
