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
import { NotificationAuditLoggingService } from './audit-logging.service';
import { UserBehaviorAnalyticsService } from './user-behavior-analytics.service';
import { AdaptiveNotificationEngineService } from './adaptive-notification-engine.service';
import { NotificationBehaviorService } from './notification-behavior.service';
import { InteractiveNotificationService } from './interactive-notification.service';
import { NotificationRuleEngine } from './notification-rule-engine.service';
import { PrismaModule } from '../prisma/prisma.module';
import { VectorModule } from '../vector/vector.module';
import { AIModule } from '../ai/ai.module';

@Module({
  imports: [
    PrismaModule,
    VectorModule,
    AIModule,
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
    NotificationAuditLoggingService,
    UserBehaviorAnalyticsService,
    AdaptiveNotificationEngineService,
    NotificationBehaviorService,
    InteractiveNotificationService,
    NotificationRuleEngine,
  ],
  controllers: [NotificationController],
  exports: [
    NotificationService,
    NotificationTemplateService,
    NotificationSchedulingService,
    NotificationAuditLoggingService,
    UserBehaviorAnalyticsService,
    AdaptiveNotificationEngineService,
    NotificationBehaviorService,
    InteractiveNotificationService,
    NotificationRuleEngine,
  ],
})
export class NotificationModule {}
