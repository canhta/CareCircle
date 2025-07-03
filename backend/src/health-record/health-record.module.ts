import { Module } from '@nestjs/common';
import { HealthRecordService } from './health-record.service';
import { HealthRecordController } from './health-record.controller';
import { HealthDataQueueService } from './health-data-queue.service';
import { HealthAnalysisService } from './health-analysis.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [
    HealthRecordService,
    HealthDataQueueService,
    HealthAnalysisService,
  ],
  controllers: [HealthRecordController],
  exports: [HealthRecordService, HealthDataQueueService, HealthAnalysisService],
})
export class HealthRecordModule {}
