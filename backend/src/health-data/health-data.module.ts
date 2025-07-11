import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from '../common/database/prisma.module';
import { QueueModule } from '../common/queue/queue.module';
import { IdentityAccessModule } from '../identity-access/identity-access.module';

// Controllers
import { HealthProfileController } from './presentation/controllers/health-profile.controller';
import { HealthMetricController } from './presentation/controllers/health-metric.controller';
import { HealthDeviceController } from './presentation/controllers/health-device.controller';

// Application services
import { HealthProfileService } from './application/services/health-profile.service';
import { HealthMetricService } from './application/services/health-metric.service';
import { HealthDeviceService } from './application/services/health-device.service';
import { HealthAnalyticsService } from './application/services/health-analytics.service';

// Infrastructure services
import { HealthDataValidationService } from './infrastructure/services/health-data-validation.service';
import { ValidationMetricsService } from './infrastructure/services/validation-metrics.service';
import { CriticalAlertService } from './infrastructure/services/critical-alert.service';

// Repositories
import { PrismaHealthProfileRepository } from './infrastructure/repositories/prisma-health-profile.repository';
import { PrismaHealthMetricRepository } from './infrastructure/repositories/prisma-health-metric.repository';
import { PrismaHealthDeviceRepository } from './infrastructure/repositories/prisma-health-device.repository';

// Queue processors
import { HealthDataProcessingProcessor } from './infrastructure/jobs/health-data-processing.processor';

// Queue service
import { QueueService } from '../common/queue/queue.service';

@Module({
  imports: [ConfigModule, PrismaModule, QueueModule, IdentityAccessModule],
  controllers: [
    HealthProfileController,
    HealthMetricController,
    HealthDeviceController,
  ],
  providers: [
    HealthProfileService,
    HealthMetricService,
    HealthDeviceService,
    HealthAnalyticsService,
    HealthDataValidationService,
    ValidationMetricsService,
    CriticalAlertService,
    QueueService,
    HealthDataProcessingProcessor,
    {
      provide: 'HealthProfileRepository',
      useClass: PrismaHealthProfileRepository,
    },
    {
      provide: 'HealthMetricRepository',
      useClass: PrismaHealthMetricRepository,
    },
    {
      provide: 'HealthDeviceRepository',
      useClass: PrismaHealthDeviceRepository,
    },
  ],
  exports: [
    HealthProfileService,
    HealthMetricService,
    HealthDeviceService,
    HealthAnalyticsService,
  ],
})
export class HealthDataModule {}
