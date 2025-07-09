import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from '../common/database/prisma.module';

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

// Repositories
import { PrismaHealthProfileRepository } from './infrastructure/repositories/prisma-health-profile.repository';
import { PrismaHealthMetricRepository } from './infrastructure/repositories/prisma-health-metric.repository';
import { PrismaHealthDeviceRepository } from './infrastructure/repositories/prisma-health-device.repository';

@Module({
  imports: [ConfigModule, PrismaModule],
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
