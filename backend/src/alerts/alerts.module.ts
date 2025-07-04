import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { NotificationModule } from '../notification/notification.module';
import { CaregiverAlertService } from './caregiver-alert.service';

@Module({
  imports: [PrismaModule, NotificationModule],
  providers: [CaregiverAlertService],
  exports: [CaregiverAlertService],
})
export class AlertsModule {}
