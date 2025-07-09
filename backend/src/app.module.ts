import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './common/database/prisma.module';
import { IdentityAccessModule } from './identity-access/identity-access.module';
import { AiAssistantModule } from './ai-assistant/ai-assistant.module';
import { HealthDataModule } from './health-data/health-data.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    PrismaModule,
    IdentityAccessModule,
    AiAssistantModule,
    HealthDataModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
