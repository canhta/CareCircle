# CareCircle AI Assistant to Multi-Agent System Migration Guide

## Overview

This guide provides a comprehensive migration path from CareCircle's current AI assistant implementation to the new state-of-the-art multi-agent system. The migration maintains backward compatibility while introducing advanced healthcare-specific capabilities.

## Current System Analysis

### Existing Architecture
```
Current AI Assistant (Single Agent)
├── ConversationService (Single OpenAI integration)
├── OpenAIService (Basic GPT-4 calls)
├── Basic health context building
├── Simple conversation management
└── Flutter mobile integration
```

### New Multi-Agent Architecture
```
Multi-Agent AI System (LangGraph Orchestration)
├── Agent Orchestrator (LangGraph StateGraph)
├── Healthcare Specialized Agents (6 agents)
├── Advanced health context with PHI protection
├── Real-time streaming and human-in-the-loop
└── Enhanced mobile integration with WebSocket
```

## Migration Strategy

### Phase 1: Parallel Deployment (Week 1-2)
Deploy the new multi-agent system alongside the existing AI assistant to ensure zero downtime.

### Phase 2: Gradual Migration (Week 3-4)
Migrate users progressively with feature flags and A/B testing.

### Phase 3: Full Cutover (Week 5-6)
Complete migration with legacy system deprecation.

## 1. Database Schema Migration

### 1.1 New Tables for Multi-Agent System

```sql
-- Migration: Add multi-agent specific tables
-- File: prisma/migrations/add_multi_agent_tables.sql

-- Agent Sessions (extends existing conversations)
CREATE TABLE agent_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    thread_id VARCHAR(255) NOT NULL, -- LangGraph thread ID
    active_agent VARCHAR(100) NOT NULL,
    agent_context JSONB DEFAULT '{}',
    cost_tracking JSONB DEFAULT '{}',
    compliance_flags JSONB DEFAULT '[]',
    emergency_status VARCHAR(50) DEFAULT 'normal',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(conversation_id, thread_id)
);

-- Agent Interactions (detailed logging)
CREATE TABLE agent_interactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES agent_sessions(id) ON DELETE CASCADE,
    agent_name VARCHAR(100) NOT NULL,
    query_hash VARCHAR(64) NOT NULL, -- SHA-256 of sanitized query
    response_hash VARCHAR(64) NOT NULL, -- SHA-256 of sanitized response
    model_used VARCHAR(100) NOT NULL,
    tokens_used INTEGER NOT NULL,
    processing_time INTEGER NOT NULL, -- milliseconds
    cost_usd DECIMAL(10, 6) NOT NULL,
    urgency_level DECIMAL(3, 2) DEFAULT 0.0,
    phi_detected BOOLEAN DEFAULT FALSE,
    phi_types JSONB DEFAULT '[]',
    compliance_level VARCHAR(50) DEFAULT 'standard',
    emergency_escalation BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    
    -- Audit trail indexes
    INDEX idx_agent_interactions_session (session_id),
    INDEX idx_agent_interactions_agent (agent_name),
    INDEX idx_agent_interactions_created (created_at),
    INDEX idx_agent_interactions_phi (phi_detected),
    INDEX idx_agent_interactions_emergency (emergency_escalation)
);

-- Cost Tracking (per user budget management)
CREATE TABLE user_ai_budgets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES user_accounts(id) ON DELETE CASCADE,
    monthly_limit DECIMAL(10, 2) NOT NULL DEFAULT 100.00,
    current_usage DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    billing_period_start DATE NOT NULL,
    billing_period_end DATE NOT NULL,
    alert_threshold DECIMAL(3, 2) DEFAULT 0.8,
    budget_exceeded BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(user_id, billing_period_start)
);

-- Emergency Escalations (HIPAA compliance)
CREATE TABLE emergency_escalations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES agent_sessions(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES user_accounts(id) ON DELETE CASCADE,
    urgency_level VARCHAR(20) NOT NULL,
    emergency_type VARCHAR(100) NOT NULL,
    escalation_triggered_at TIMESTAMP NOT NULL,
    response_time_limit INTEGER NOT NULL, -- seconds
    emergency_contacts_notified JSONB DEFAULT '[]',
    healthcare_provider_notified BOOLEAN DEFAULT FALSE,
    emergency_services_contacted BOOLEAN DEFAULT FALSE,
    resolution_status VARCHAR(50) DEFAULT 'active',
    resolved_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
```

### 1.2 Extend Existing Tables

```sql
-- Add multi-agent support to existing conversations table
ALTER TABLE conversations 
ADD COLUMN agent_session_id UUID NULL REFERENCES agent_sessions(id),
ADD COLUMN migration_status VARCHAR(50) DEFAULT 'legacy',
ADD COLUMN agent_version VARCHAR(20) DEFAULT 'v1';

-- Add multi-agent metadata to existing messages table
ALTER TABLE messages
ADD COLUMN agent_name VARCHAR(100) NULL,
ADD COLUMN model_used VARCHAR(100) NULL,
ADD COLUMN cost_usd DECIMAL(10, 6) NULL,
ADD COLUMN urgency_level DECIMAL(3, 2) DEFAULT 0.0,
ADD COLUMN phi_detected BOOLEAN DEFAULT FALSE;
```

## 2. Backend Service Migration

### 2.1 Create Multi-Agent Module

```typescript
// src/multi-agent/multi-agent.module.ts
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from '../common/database/prisma.module';
import { HealthDataModule } from '../health-data/health-data.module';
import { AiAssistantModule } from '../ai-assistant/ai-assistant.module';

// New multi-agent services
import { AgentOrchestrator } from './services/agent-orchestrator.service';
import { HealthcareAgentService } from './services/healthcare-agent.service';
import { ComplianceService } from './services/compliance.service';
import { CostOptimizationService } from './services/cost-optimization.service';

// Controllers
import { MultiAgentController } from './controllers/multi-agent.controller';

@Module({
  imports: [
    ConfigModule,
    PrismaModule,
    HealthDataModule,
    AiAssistantModule, // Import existing for gradual migration
  ],
  controllers: [MultiAgentController],
  providers: [
    AgentOrchestrator,
    HealthcareAgentService,
    ComplianceService,
    CostOptimizationService,
  ],
  exports: [AgentOrchestrator],
})
export class MultiAgentModule {}
```

### 2.2 Migration Service

```typescript
// src/multi-agent/services/migration.service.ts
@Injectable()
export class MigrationService {
  constructor(
    private readonly conversationService: ConversationService, // Existing
    private readonly agentOrchestrator: AgentOrchestrator, // New
    private readonly prisma: PrismaService,
  ) {}

  async migrateConversation(conversationId: string): Promise<void> {
    // 1. Get existing conversation
    const conversation = await this.conversationService.getConversationById(conversationId);
    if (!conversation) {
      throw new Error('Conversation not found');
    }

    // 2. Create agent session
    const agentSession = await this.prisma.agentSession.create({
      data: {
        conversationId: conversation.id,
        threadId: `migrated_${conversation.id}`,
        activeAgent: 'supervisor',
        agentContext: {},
        costTracking: { migratedFrom: 'legacy' },
        complianceFlags: [],
      },
    });

    // 3. Update conversation with migration status
    await this.prisma.conversation.update({
      where: { id: conversationId },
      data: {
        agentSessionId: agentSession.id,
        migrationStatus: 'migrated',
        agentVersion: 'v2',
      },
    });

    // 4. Migrate existing messages to new format
    await this.migrateMessages(conversation.id, agentSession.id);
  }

  private async migrateMessages(conversationId: string, sessionId: string): Promise<void> {
    const messages = await this.prisma.message.findMany({
      where: { conversationId },
      orderBy: { timestamp: 'asc' },
    });

    for (const message of messages) {
      if (message.role === 'assistant') {
        // Create agent interaction record for assistant messages
        await this.prisma.agentInteraction.create({
          data: {
            sessionId,
            agentName: 'legacy_assistant',
            queryHash: 'migrated',
            responseHash: 'migrated',
            modelUsed: 'gpt-4', // Default from legacy system
            tokensUsed: message.metadata?.tokensUsed || 0,
            processingTime: message.metadata?.processingTime || 0,
            costUsd: 0, // Legacy system didn't track costs
            urgencyLevel: 0.1,
            phiDetected: false,
            complianceLevel: 'standard',
            emergencyEscalation: false,
          },
        });

        // Update message with agent metadata
        await this.prisma.message.update({
          where: { id: message.id },
          data: {
            agentName: 'legacy_assistant',
            modelUsed: 'gpt-4',
            costUsd: 0,
            urgencyLevel: 0.1,
            phiDetected: false,
          },
        });
      }
    }
  }
}
```

### 2.3 Backward Compatibility Layer

```typescript
// src/multi-agent/services/compatibility.service.ts
@Injectable()
export class CompatibilityService {
  constructor(
    private readonly agentOrchestrator: AgentOrchestrator,
    private readonly migrationService: MigrationService,
  ) {}

  async handleLegacyRequest(
    conversationId: string,
    message: string,
    userId: string,
  ): Promise<any> {
    // Check if conversation is already migrated
    const conversation = await this.prisma.conversation.findUnique({
      where: { id: conversationId },
      include: { agentSession: true },
    });

    if (conversation?.migrationStatus === 'legacy') {
      // Auto-migrate on first new interaction
      await this.migrationService.migrateConversation(conversationId);
    }

    // Route to new multi-agent system
    return this.agentOrchestrator.processHealthcareQuery(
      message,
      userId,
      conversation.agentSession.threadId,
    );
  }
}
```

## 3. Mobile App Migration

### 3.1 Feature Flag Implementation

```dart
// mobile/lib/features/ai-assistant/config/feature_flags.dart
class AIAssistantFeatureFlags {
  static const bool enableMultiAgentSystem = true;
  static const bool enableLegacyFallback = true;
  static const bool enableWebSocketStreaming = true;
  static const bool enableVoiceInput = true;
  static const bool enableEmergencyTriage = true;
  
  // Migration flags
  static const bool autoMigrateConversations = true;
  static const double migrationRolloutPercentage = 0.5; // 50% rollout
}
```

### 3.2 Enhanced AI Assistant Service

```dart
// mobile/lib/features/ai-assistant/infrastructure/services/multi_agent_service.dart
@RestApi(baseUrl: AppConfig.apiBaseUrl)
abstract class MultiAgentService {
  factory MultiAgentService(Dio dio, {String baseUrl}) = _MultiAgentService;

  // New multi-agent endpoints
  @POST('/api/v1/agents/conversations')
  Future<AgentConversationResponse> startAgentConversation(
    @Body() StartConversationRequest request,
  );

  @POST('/api/v1/agents/conversations/{conversationId}/messages')
  Future<AgentMessageResponse> sendAgentMessage(
    @Path('conversationId') String conversationId,
    @Body() SendAgentMessageRequest request,
  );

  @GET('/api/v1/agents/conversations/{conversationId}/stream')
  Stream<AgentStreamEvent> streamAgentConversation(
    @Path('conversationId') String conversationId,
  );

  // Backward compatibility
  @POST('/ai-assistant/conversations/{id}/messages/legacy')
  Future<SendMessageResponseDto> sendLegacyMessage(
    @Path('id') String conversationId,
    @Body() Map<String, dynamic> request,
  );
}
```

### 3.3 Migration-Aware Repository

```dart
// mobile/lib/features/ai-assistant/infrastructure/repositories/ai_assistant_repository.dart
class AIAssistantRepository {
  final AiAssistantService _legacyService;
  final MultiAgentService _multiAgentService;
  final WebSocketService _webSocketService;

  AIAssistantRepository(Dio dio) 
    : _legacyService = AiAssistantService(dio),
      _multiAgentService = MultiAgentService(dio),
      _webSocketService = WebSocketService();

  Future<ConversationResponse> sendMessage({
    required String conversationId,
    required String message,
    required String userId,
  }) async {
    if (AIAssistantFeatureFlags.enableMultiAgentSystem) {
      // Use new multi-agent system
      return _sendMultiAgentMessage(conversationId, message, userId);
    } else {
      // Fallback to legacy system
      return _sendLegacyMessage(conversationId, message);
    }
  }

  Future<ConversationResponse> _sendMultiAgentMessage(
    String conversationId,
    String message,
    String userId,
  ) async {
    try {
      final response = await _multiAgentService.sendAgentMessage(
        conversationId,
        SendAgentMessageRequest(
          message: message,
          messageType: 'text',
          metadata: MessageMetadata(
            timestamp: DateTime.now(),
            urgencyLevel: _calculateUrgencyLevel(message),
          ),
        ),
      );
      
      return ConversationResponse.fromAgentResponse(response);
    } catch (e) {
      if (AIAssistantFeatureFlags.enableLegacyFallback) {
        // Fallback to legacy system on error
        return _sendLegacyMessage(conversationId, message);
      }
      rethrow;
    }
  }

  Stream<AgentStreamEvent> streamConversation(String conversationId) {
    if (AIAssistantFeatureFlags.enableWebSocketStreaming) {
      return _webSocketService.streamConversation(conversationId);
    } else {
      // Fallback to polling for legacy system
      return _pollConversationUpdates(conversationId);
    }
  }
}
```

## 4. Migration Execution Plan

### 4.1 Pre-Migration Checklist

```bash
# 1. Backup existing data
pg_dump carecircle_prod > backup_pre_migration_$(date +%Y%m%d).sql

# 2. Run database migrations
npx prisma migrate deploy

# 3. Deploy new multi-agent services (parallel deployment)
docker-compose -f docker-compose.ai-agents.yml up -d

# 4. Verify health checks
curl http://localhost:3001/health
curl http://localhost:3002/health

# 5. Run migration tests
npm run test:migration
```

### 4.2 Migration Commands

```bash
# Migration script: scripts/migrate-ai-assistant.sh
#!/bin/bash

echo "🚀 Starting CareCircle AI Assistant Migration..."

# 1. Enable feature flags
kubectl patch configmap carecircle-config -p '{"data":{"ENABLE_MULTI_AGENT":"true"}}'

# 2. Deploy multi-agent services
kubectl apply -f k8s/multi-agent-deployment.yaml

# 3. Migrate conversations in batches
node scripts/migrate-conversations.js --batch-size=100

# 4. Update mobile app configuration
kubectl patch configmap mobile-config -p '{"data":{"AI_MULTI_AGENT_ENABLED":"true"}}'

# 5. Monitor migration progress
kubectl logs -f deployment/agent-orchestrator

echo "✅ Migration completed successfully!"
```

### 4.3 Rollback Plan

```bash
# Rollback script: scripts/rollback-migration.sh
#!/bin/bash

echo "🔄 Rolling back AI Assistant migration..."

# 1. Disable multi-agent system
kubectl patch configmap carecircle-config -p '{"data":{"ENABLE_MULTI_AGENT":"false"}}'

# 2. Restore legacy endpoints
kubectl apply -f k8s/legacy-ai-assistant.yaml

# 3. Update conversation status
psql -c "UPDATE conversations SET migration_status = 'legacy' WHERE migration_status = 'migrated';"

# 4. Verify legacy system
curl http://localhost:3000/ai-assistant/health

echo "✅ Rollback completed successfully!"
```

## 5. Testing Strategy

### 5.1 Migration Testing

```typescript
// test/migration/ai-assistant-migration.test.ts
describe('AI Assistant Migration', () => {
  it('should migrate legacy conversation to multi-agent system', async () => {
    // Create legacy conversation
    const conversation = await createLegacyConversation();
    
    // Migrate to multi-agent
    await migrationService.migrateConversation(conversation.id);
    
    // Verify migration
    const migratedConversation = await prisma.conversation.findUnique({
      where: { id: conversation.id },
      include: { agentSession: true },
    });
    
    expect(migratedConversation.migrationStatus).toBe('migrated');
    expect(migratedConversation.agentSession).toBeDefined();
  });

  it('should maintain backward compatibility', async () => {
    const legacyRequest = {
      conversationId: 'test-conversation',
      content: 'I have a headache',
    };

    const response = await compatibilityService.handleLegacyRequest(
      legacyRequest.conversationId,
      legacyRequest.content,
      'test-user',
    );

    expect(response).toBeDefined();
    expect(response.agentResponse).toBeDefined();
  });
});
```

This migration guide ensures a smooth transition from the current AI assistant to the new multi-agent system while maintaining backward compatibility and zero downtime.
