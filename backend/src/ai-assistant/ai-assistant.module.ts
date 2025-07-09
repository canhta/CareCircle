import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from '../common/database/prisma.module';
import { HealthDataModule } from '../health-data/health-data.module';
import { IdentityAccessModule } from '../identity-access/identity-access.module';

// Controllers
import { ConversationController } from './presentation/controllers/conversation.controller';

// Application services
import { ConversationService } from './application/services/conversation.service';

// Infrastructure
import { OpenAIService } from './infrastructure/services/openai.service';

// Repositories
import { PrismaConversationRepository } from './infrastructure/repositories/prisma-conversation.repository';

@Module({
  imports: [ConfigModule, PrismaModule, HealthDataModule, IdentityAccessModule],
  controllers: [ConversationController],
  providers: [
    ConversationService,
    OpenAIService,
    {
      provide: 'ConversationRepository',
      useClass: PrismaConversationRepository,
    },
  ],
  exports: [ConversationService],
})
export class AiAssistantModule {}
