import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from '../common/database/prisma.module';
import { HealthDataModule } from '../health-data/health-data.module';
import { IdentityAccessModule } from '../identity-access/identity-access.module';

// Domain modules
import { AgentsModule } from './domain/agents/agents.module';

// Controllers
import { ConversationController } from './presentation/controllers/conversation.controller';
import { ChatAgentController } from './presentation/controllers/chat-agent.controller';
import { VietnameseHealthcareAgentController } from './presentation/controllers/vietnamese-healthcare-agent.controller';

// Application services
import { ConversationService } from './application/services/conversation.service';
import { ChatAgentService } from './application/services/chat-agent.service';

// Infrastructure services
import { OpenAIService } from './infrastructure/services/openai.service';
import { HealthcareAgentOrchestratorService } from './infrastructure/services/healthcare-agent-orchestrator.service';
import { VectorDatabaseService } from './infrastructure/services/vector-database.service';
import { PHIProtectionService } from '../../common/compliance/phi-protection.service';
import { FirecrawlVietnameseHealthcareService } from './infrastructure/services/firecrawl-vietnamese-healthcare.service';

// Repositories
import { PrismaConversationRepository } from './infrastructure/repositories/prisma-conversation.repository';
import { PrismaAgentSessionRepository } from './infrastructure/repositories/prisma-agent-session.repository';

@Module({
  imports: [
    ConfigModule,
    PrismaModule,
    HealthDataModule,
    IdentityAccessModule,
    AgentsModule, // Import the new agents module
  ],
  controllers: [ConversationController, ChatAgentController, VietnameseHealthcareAgentController],
  providers: [
    // Application services
    ConversationService,
    ChatAgentService,

    // Infrastructure services
    OpenAIService,
    HealthcareAgentOrchestratorService,
    VectorDatabaseService,
    PHIProtectionService,
    FirecrawlVietnameseHealthcareService,

    // Repository providers
    {
      provide: 'ConversationRepository',
      useClass: PrismaConversationRepository,
    },
    {
      provide: 'AgentSessionRepository',
      useClass: PrismaAgentSessionRepository,
    },
  ],
  exports: [ConversationService, ChatAgentService],
})
export class AiAssistantModule {}
