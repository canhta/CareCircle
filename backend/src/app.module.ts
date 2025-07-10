import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './common/database/prisma.module';
import { QueueModule } from './common/queue/queue.module';
import { IdentityAccessModule } from './identity-access/identity-access.module';
import { AiAssistantModule } from './ai-assistant/ai-assistant.module';
import { HealthDataModule } from './health-data/health-data.module';
import { MedicationModule } from './medication/medication.module';
import { NotificationModule } from './notification/notification.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    PrismaModule,
    QueueModule,
    IdentityAccessModule,
    AiAssistantModule,
    HealthDataModule,
    MedicationModule,
    NotificationModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
