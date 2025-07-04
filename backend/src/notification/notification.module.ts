import { Module } from '@nestjs/common';
import { BullModule } from '@nestjs/bullmq';
import { ScheduleModule } from '@nestjs/schedule';
import { CacheModule } from '@nestjs/cache-manager';
import { NotificationService } from './notification.service';
import { NotificationController } from './notification.controller';
import { NotificationProcessor } from './processors/notification.processor';
import { ReminderProcessor } from './processors/reminder.processor';
import { TemplateRenderingService } from './template-rendering.service';
import { NotificationTemplateService } from './notification-template.service';
import { NotificationSchedulingService } from './notification-scheduling.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [
    PrismaModule,
    ScheduleModule.forRoot(),
    CacheModule.register({
      ttl: 300, // 5 minutes
      max: 100, // maximum number of items in cache
    }),
    BullModule.registerQueue(
      {
        name: 'notification',
      },
      {
        name: 'reminder',
      },
    ),
  ],
  providers: [
    NotificationService,
    NotificationProcessor,
    ReminderProcessor,
    TemplateRenderingService,
    NotificationTemplateService,
    NotificationSchedulingService,
  ],
  controllers: [NotificationController],
  exports: [
    NotificationService,
    NotificationTemplateService,
    NotificationSchedulingService,
  ],
})
export class NotificationModule {}
