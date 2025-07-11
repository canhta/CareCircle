import { Module } from '@nestjs/common';
import { PrismaModule } from '../common/database/prisma.module';
import { IdentityAccessModule } from '../identity-access/identity-access.module';

// Domain
import { NotificationRepository } from './domain/repositories/notification.repository';

// Infrastructure
import { PrismaNotificationRepository } from './infrastructure/repositories/prisma-notification.repository';

// Application
import { NotificationService } from './application/services/notification.service';

// Presentation
import { NotificationController } from './presentation/controllers/notification.controller';

@Module({
  imports: [PrismaModule, IdentityAccessModule],
  controllers: [NotificationController],
  providers: [
    // Services
    NotificationService,

    // Repositories
    {
      provide: NotificationRepository,
      useClass: PrismaNotificationRepository,
    },
  ],
  exports: [NotificationService],
})
export class NotificationModule {}
