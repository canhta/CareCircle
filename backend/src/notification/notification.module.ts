import { Module } from '@nestjs/common';
import { PrismaModule } from '../common/database/prisma.module';
import { IdentityAccessModule } from '../identity-access/identity-access.module';

// Domain
import { NotificationRepository } from './domain/repositories/notification.repository';

// Infrastructure
import { PrismaNotificationRepository } from './infrastructure/repositories/prisma-notification.repository';
import { PushNotificationService } from './infrastructure/services/push-notification.service';
import { EmailNotificationService } from './infrastructure/services/email-notification.service';
import { TemplateEngineService } from './infrastructure/services/template-engine.service';
import { TemplateRepository } from './infrastructure/repositories/template.repository';

// Application
import { NotificationService } from './application/services/notification.service';
import { DeliveryOrchestrationService } from './application/services/delivery-orchestration.service';
import { SmartTimingService } from './application/services/smart-timing.service';
import { NotificationBatchingService } from './application/services/batching.service';
import { HIPAAComplianceService } from './application/services/hipaa-compliance.service';
import { EmergencyEscalationService } from './application/services/emergency-escalation.service';

// Presentation
import { NotificationController } from './presentation/controllers/notification.controller';

@Module({
  imports: [PrismaModule, IdentityAccessModule],
  controllers: [NotificationController],
  providers: [
    // Core Services
    NotificationService,

    // Phase 1: Multi-Channel Delivery Enhancement
    PushNotificationService,
    EmailNotificationService,
    DeliveryOrchestrationService,

    // Phase 2: Template System Implementation
    TemplateEngineService,
    TemplateRepository,

    // Phase 3: Smart Timing & AI Features
    SmartTimingService,
    NotificationBatchingService,

    // Phase 4: Healthcare Compliance Enhancement
    HIPAAComplianceService,
    EmergencyEscalationService,

    // Repositories
    {
      provide: NotificationRepository,
      useClass: PrismaNotificationRepository,
    },
  ],
  exports: [
    NotificationService,
    PushNotificationService,
    EmailNotificationService,
    DeliveryOrchestrationService,
    TemplateEngineService,
    SmartTimingService,
    NotificationBatchingService,
    HIPAAComplianceService,
    EmergencyEscalationService,
  ],
})
export class NotificationModule {}
