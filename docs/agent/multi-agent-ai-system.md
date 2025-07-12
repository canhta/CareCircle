# CareCircle Multi-Agent AI System Architecture (2025 Edition)

## Executive Summary

This document outlines the state-of-the-art architecture for integrating a sophisticated multi-agent AI system into the CareCircle backend, leveraging the latest LangGraph.js patterns and healthcare AI best practices. The system serves as a production-ready, HIPAA-compliant healthcare assistant with advanced multi-agent orchestration, semantic memory, and containerized deployment.

## 1. System Overview

### 1.1 Core Objectives
- **Stateful Multi-Agent Orchestration** with LangGraph.js StateGraph and persistent memory
- **Healthcare-Specialized Agents** with domain expertise and handoff capabilities
- **Semantic Memory Integration** with vector database for contextual health insights
- **Real-time Streaming Responses** with human-in-the-loop workflows
- **Advanced Cost Optimization** through intelligent model routing and caching
- **Production-Grade HIPAA Compliance** with comprehensive audit trails
- **Containerized Deployment** with Docker and Kubernetes orchestration
- **Dual Authentication Support** (Firebase users + guest demo sessions)

### 1.2 Architecture Principles
- **Domain-Driven Design (DDD)** - Maintains existing bounded context patterns
- **Clean Architecture** - Separation of concerns across layers
- **Healthcare-First** - HIPAA compliance and patient safety prioritized
- **Container-Native** - Docker-first approach with Kubernetes orchestration
- **Observable** - Comprehensive monitoring and audit trails
- **Scalable** - Horizontal scaling with distributed state management

## 2. State-of-the-Art Multi-Agent Architecture

### 2.1 LangGraph.js StateGraph Orchestration
The system leverages LangGraph.js for stateful agent workflows with persistent memory:

```typescript
import { StateGraph, MessagesAnnotation, MemorySaver, START, END } from "@langchain/langgraph";
import { Command } from "@langchain/langgraph/types";

// Healthcare conversation state with medical context
const HealthcareStateAnnotation = Annotation.Root({
  ...MessagesAnnotation.spec,
  userContext: Annotation<UserHealthContext>(),
  activeAgent: Annotation<string>(),
  agentContext: Annotation<Record<string, any>>(),
  costTracking: Annotation<CostTrackingInfo>(),
  complianceFlags: Annotation<ComplianceFlag[]>(),
  emergencyStatus: Annotation<EmergencyStatus>(),
});

// Multi-agent orchestrator with LangGraph StateGraph
const healthcareAgentGraph = new StateGraph(HealthcareStateAnnotation)
  .addNode("supervisor", supervisorAgent)
  .addNode("healthAdvisor", healthAdvisorAgent)
  .addNode("medicationAssistant", medicationAssistantAgent)
  .addNode("emergencyTriage", emergencyTriageAgent)
  .addNode("dataInterpreter", dataInterpreterAgent)
  .addNode("careCoordinator", careCoordinatorAgent)
  .addConditionalEdges("supervisor", routingLogic)
  .compile({
    checkpointer: new MemorySaver(), // Production: Redis-based checkpointer
    interruptBefore: ["emergencyTriage"] // Human-in-the-loop for emergencies
  });
```

### 2.2 Healthcare-Specialized Agents with Handoff Capabilities

#### 2.2.1 Supervisor Agent (Central Orchestrator)
```typescript
import { createReactAgent } from "@langchain/langgraph/prebuilt";

const supervisorAgent = createReactAgent({
  llm: new ChatOpenAI({ model: "gpt-4", temperature: 0.1 }),
  tools: [
    transferToHealthAdvisor,
    transferToMedicationAssistant,
    transferToEmergencyTriage,
    transferToDataInterpreter,
    transferToCareCoordinator
  ],
  prompt: `You are a healthcare AI supervisor managing specialized medical agents.
  Route queries to appropriate specialists based on medical context and urgency.
  ALWAYS prioritize patient safety and emergency situations.`,
  name: "supervisor"
});
```

#### 2.2.2 Health Advisor Agent
```typescript
const healthAdvisorAgent = createReactAgent({
  llm: new ChatOpenAI({ model: "gpt-3.5-turbo", temperature: 0.7 }),
  tools: [
    getHealthRecommendations,
    analyzeSymptoms,
    transferToEmergencyTriage,
    transferToMedicationAssistant
  ],
  prompt: `You are a knowledgeable healthcare advisor specializing in:
  - General health and wellness guidance
  - Symptom assessment and health education
  - Preventive care recommendations
  - Lifestyle and wellness coaching

  IMPORTANT: Always include medical disclaimers and escalate emergencies.`,
  name: "healthAdvisor"
});
```

#### 2.2.3 Emergency Triage Agent (Critical Priority)
```typescript
const emergencyTriageAgent = createReactAgent({
  llm: new ChatOpenAI({ model: "gpt-4", temperature: 0.1 }), // Highest accuracy
  tools: [
    assessUrgency,
    triggerEmergencyProtocols,
    notifyEmergencyContacts,
    escalateToHealthcareProvider
  ],
  prompt: `You are an emergency triage specialist with critical responsibilities:
  - Immediate assessment of health emergencies
  - Activation of emergency protocols
  - Coordination with emergency services
  - Patient safety is PARAMOUNT - err on the side of caution`,
  name: "emergencyTriage"
});
```

### 2.3 Supporting Components

#### 2.3.1 Context Manager
Aggregates and manages user-specific context:
- Personal health data from health-data module
- Medication history from medication module
- User preferences and communication style
- Historical conversation patterns

#### 2.3.2 Memory Manager
Handles persistent conversation state:
- LangGraph MemorySaver integration
- Redis-based session persistence for production
- User preference learning and adaptation
- Conversation history management

#### 2.3.3 Compliance Monitor
Ensures HIPAA compliance throughout:
- PHI detection and masking in logs
- Audit trail for all AI interactions
- Content filtering and medical disclaimers
- Emergency escalation protocols

#### 2.3.4 Cost Optimizer
Manages AI usage costs:
- Dynamic model selection based on query complexity
- Per-user budget tracking and limits
- Real-time cost monitoring and alerts
- Usage analytics and optimization recommendations

#### 2.3.5 Vector Knowledge Base
Enhanced medical knowledge retrieval:
- Integration with planned Milvus vector database
- Medical knowledge embeddings
- Personalized health insights storage
- Semantic search capabilities

## 3. Technical Integration

### 3.1 Technology Stack Extensions
- **LangChain.js**: Multi-agent orchestration and conversation management
- **LangGraph**: Stateful agent workflows with persistent memory
- **OpenAI Node.js**: Multi-model support and cost optimization
- **Redis**: Production-grade session persistence
- **Existing Stack**: NestJS, Firebase Auth, Prisma, PostgreSQL

### 3.2 Database Schema Extensions

```sql
-- Agent Sessions (extends existing conversations)
CREATE TABLE agent_sessions (
  id UUID PRIMARY KEY,
  conversation_id UUID REFERENCES conversations(id),
  thread_id VARCHAR(255) NOT NULL, -- LangGraph thread ID
  active_agent VARCHAR(100),
  agent_context JSONB DEFAULT '{}',
  session_metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Agent Interactions (detailed logging for compliance)
CREATE TABLE agent_interactions (
  id UUID PRIMARY KEY,
  session_id UUID REFERENCES agent_sessions(id),
  agent_name VARCHAR(100) NOT NULL,
  input_tokens INTEGER,
  output_tokens INTEGER,
  model_used VARCHAR(50),
  cost_usd DECIMAL(10,6),
  processing_time_ms INTEGER,
  confidence_score DECIMAL(3,2),
  compliance_flags JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT NOW()
);

-- User Agent Preferences
CREATE TABLE user_agent_preferences (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES user_accounts(id),
  preferred_tone VARCHAR(50) DEFAULT 'professional',
  response_length VARCHAR(20) DEFAULT 'detailed',
  technical_level VARCHAR(20) DEFAULT 'simple',
  language VARCHAR(10) DEFAULT 'en',
  emergency_contacts JSONB DEFAULT '[]',
  cost_budget_monthly DECIMAL(8,2) DEFAULT 50.00,
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Vector Knowledge Base (for Milvus integration)
CREATE TABLE knowledge_vectors (
  id UUID PRIMARY KEY,
  content_hash VARCHAR(64) UNIQUE,
  content_type VARCHAR(50),
  user_id UUID REFERENCES user_accounts(id), -- For personalized knowledge
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT NOW()
);
```

### 3.3 Module Integration Points

#### 3.3.1 Enhanced AI Assistant Module
```typescript
@Module({
  imports: [
    ConfigModule,
    PrismaModule,
    HealthDataModule,
    MedicationModule,
    NotificationModule,
    CareGroupModule,
    IdentityAccessModule,
  ],
  controllers: [
    ConversationController,
    AgentController, // New controller for agent management
  ],
  providers: [
    // Core Services
    AgentOrchestrator,
    ConversationService, // Enhanced with agent support
    
    // Specialized Agents
    HealthAdvisorAgent,
    MedicationAssistantAgent,
    EmergencyTriageAgent,
    DataInterpreterAgent,
    CareCoordinatorAgent,
    LifestyleCoachAgent,
    
    // Supporting Services
    ContextManager,
    MemoryManager,
    ComplianceMonitor,
    CostOptimizer,
    VectorKnowledgeService,
    
    // Infrastructure
    LangGraphService,
    OpenAIService, // Enhanced with multi-model support
    RedisService,
    
    // Repositories
    AgentSessionRepository,
    AgentInteractionRepository,
    UserAgentPreferencesRepository,
  ],
  exports: [
    AgentOrchestrator,
    ConversationService,
  ],
})
export class AiAssistantModule {}
```

## 4. Cost Optimization Strategy

### 4.1 Multi-Model Routing Logic

```typescript
interface ModelSelectionStrategy {
  // Query complexity analysis
  analyzeComplexity(query: string): QueryComplexity;
  
  // Model selection based on complexity and budget
  selectOptimalModel(complexity: QueryComplexity, budget: UserBudget): ModelConfig;
  
  // Cost prediction and monitoring
  predictCost(query: string, model: string): Promise<number>;
  trackUsage(userId: string, cost: number): Promise<void>;
}

enum QueryComplexity {
  SIMPLE = 'simple',        // Greetings, basic info → GPT-3.5-turbo
  MODERATE = 'moderate',    // General health questions → GPT-3.5-turbo
  COMPLEX = 'complex',      // Medical analysis → GPT-4
  CRITICAL = 'critical',    // Emergency triage → GPT-4
}
```

### 4.2 Budget Management
- **Per-user monthly token limits** with configurable tiers
- **Real-time cost tracking** with usage alerts
- **Automatic model downgrading** when approaching limits
- **Usage analytics** and optimization recommendations

## 5. Healthcare Compliance Framework

### 5.1 HIPAA Compliance Measures

#### 5.1.1 Data Handling
- **PHI Encryption**: All health data encrypted at rest and in transit
- **Audit Logging**: Comprehensive logging of all AI interactions
- **Data Minimization**: Only necessary health context included in AI queries
- **Automatic PHI Detection**: Masking of sensitive information in logs

#### 5.1.2 Access Controls
- **Role-based Access**: Different agent capabilities based on user roles
- **Session Authentication**: Firebase-based authentication with automatic timeout
- **Guest Mode Support**: Limited data access for demo sessions
- **Consent Management**: Explicit consent for AI health analysis

#### 5.1.3 Content Filtering
- **Medical Disclaimers**: Automatic injection of appropriate disclaimers
- **Emergency Detection**: Automatic escalation for urgent health situations
- **Professional Boundaries**: Clear limitations on AI medical advice
- **Content Moderation**: Inappropriate content detection and filtering

### 5.2 Compliance Monitoring

```typescript
class HIPAAComplianceService {
  // PHI detection and sanitization
  async sanitizeForLogging(content: string): Promise<string> {
    // Remove/mask personal health information
    // Apply data minimization principles
  }
  
  // Comprehensive audit logging
  async logAIInteraction(interaction: AIInteractionLog): Promise<void> {
    // User consent tracking
    // Data access logging
    // Compliance flag monitoring
  }
  
  // Emergency escalation protocols
  async handleEmergencyDetection(
    query: string, 
    userId: string
  ): Promise<EmergencyResponse> {
    // Immediate healthcare provider notification
    // Emergency contact alerts
    // Compliance with emergency protocols
  }
}
```

## 6. Session Management Architecture

### 6.1 LangGraph Integration

```typescript
// Healthcare conversation state definition
const HealthcareConversationState = Annotation.Root({
  messages: Annotation<BaseMessage[]>({
    reducer: messagesStateReducer,
    default: () => [],
  }),
  userContext: Annotation<UserHealthContext>(),
  activeAgent: Annotation<string>(),
  agentContext: Annotation<Record<string, any>>(),
  costTracking: Annotation<CostTrackingInfo>(),
  complianceFlags: Annotation<ComplianceFlags>(),
});

// Multi-agent workflow with memory persistence
const agentWorkflow = new StateGraph(HealthcareConversationState)
  .addNode("orchestrator", orchestratorNode)
  .addNode("healthAdvisor", healthAdvisorNode)
  .addNode("medicationAssistant", medicationAssistantNode)
  .addNode("emergencyTriage", emergencyTriageNode)
  .addNode("dataInterpreter", dataInterpreterNode)
  .addNode("careCoordinator", careCoordinatorNode)
  .addNode("lifestyleCoach", lifestyleCoachNode)
  .addConditionalEdges("orchestrator", routingLogic)
  .compile({ 
    checkpointer: new MemorySaver() // Redis-based for production
  });
```

### 6.2 Session Persistence
- **Thread-based Sessions**: Each user conversation gets unique thread ID
- **Cross-Agent Context**: Shared context maintained across agent switches
- **User Preference Learning**: Adaptive responses based on interaction history
- **Guest Session Support**: Anonymous sessions with limited persistence

## 7. Vector Database Integration

### 7.1 Medical Knowledge Base
- **Embeddings Storage**: Medical knowledge and guidelines as vectors
- **Semantic Search**: Context-aware information retrieval
- **Personalized Insights**: User-specific health pattern storage
- **Multilingual Support**: Healthcare content in multiple languages

### 7.2 Implementation Plan
- **Phase 1**: Basic vector storage with Milvus integration
- **Phase 2**: Medical knowledge base population
- **Phase 3**: Personalized health insights generation
- **Phase 4**: Advanced semantic search and recommendations

## 8. Performance and Scalability

### 8.1 Architecture Scalability
- **Horizontal Scaling**: Multiple agent instances with load balancing
- **Redis Clustering**: Distributed session state management
- **Database Optimization**: Efficient queries with proper indexing
- **Caching Strategy**: Frequently accessed health data caching

### 8.2 Performance Targets
- **Response Time**: <2 seconds for 95% of queries
- **Concurrent Users**: Support for 1000+ simultaneous sessions
- **Availability**: 99.9% uptime with failover mechanisms
- **Cost Efficiency**: 50% reduction in AI costs through optimization

## 9. Security Considerations

### 9.1 Authentication Integration
- **Firebase Authentication**: Seamless integration with existing auth system
- **JWT Token Validation**: Secure API access with token verification
- **Role-Based Access**: Different capabilities based on user permissions
- **Session Security**: Automatic timeout and secure session management

### 9.2 Data Protection
- **Encryption**: End-to-end encryption for all health data
- **Access Logging**: Comprehensive audit trail for data access
- **Data Retention**: Configurable retention policies for compliance
- **Backup Security**: Encrypted backups with access controls

## 10. Monitoring and Analytics

### 10.1 System Monitoring
- **Real-time Metrics**: Agent performance and response times
- **Cost Tracking**: Detailed usage and cost analytics
- **Error Monitoring**: Comprehensive error tracking and alerting
- **Compliance Auditing**: Automated compliance report generation

### 10.2 User Analytics
- **Satisfaction Scoring**: User feedback and satisfaction metrics
- **Usage Patterns**: Analysis of user interaction patterns
- **Agent Effectiveness**: Performance metrics for each specialized agent
- **Optimization Insights**: Data-driven recommendations for improvements

---

*This architecture document provides the foundation for implementing a sophisticated, HIPAA-compliant multi-agent AI system that enhances CareCircle's healthcare platform while maintaining cost efficiency and user safety.*
