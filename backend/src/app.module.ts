import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './common/database/prisma.module';
import { QueueModule } from './common/queue/queue.module';
import { IdentityAccessModule } from './identity-access/identity-access.module';
import { AiAssistantModule } from './ai-assistant/ai-assistant.module';
import { HealthDataModule } from './health-data/health-data.module';
import { MedicationModule } from './medication/medication.module';
import { NotificationModule } from './notification/notification.module';
import { CareGroupModule } from './care-group/care-group.module';
import { RequestLoggerMiddleware } from './common/middleware/logger.middleware';

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
    CareGroupModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(RequestLoggerMiddleware).forRoutes('*');
  }
}
