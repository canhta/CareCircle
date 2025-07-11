import { Module } from '@nestjs/common';
import { BullModule } from '@nestjs/bull';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { QueueService } from './queue.service';
import { HealthcareAutomationProcessor } from './healthcare-automation.processor';
import { HealthcareAutomationService } from './healthcare-automation.service';

@Module({
  imports: [
    BullModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        redis: {
          host: configService.get('REDIS_HOST', 'localhost'),
          port: configService.get('REDIS_PORT', 6379),
          password: configService.get('REDIS_PASSWORD'),
          db: configService.get('REDIS_DB', 0),
        },
        defaultJobOptions: {
          removeOnComplete: 100, // Keep last 100 completed jobs
          removeOnFail: 50, // Keep last 50 failed jobs
          attempts: 3,
          backoff: {
            type: 'exponential',
            delay: 2000,
          },
        },
      }),
      inject: [ConfigService],
    }),
    // Register specific queues
    BullModule.registerQueue(
      { name: 'health-data-processing' },
      { name: 'health-analytics' },
      { name: 'notifications' },
      { name: 'ai-insights' },
    ),
  ],
  providers: [
    QueueService,
    HealthcareAutomationProcessor,
    HealthcareAutomationService,
  ],
  exports: [BullModule, QueueService, HealthcareAutomationService],
})
export class QueueModule {}
