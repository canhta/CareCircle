# CareCircle Multi-Agent AI System Architecture

## Executive Summary

This document outlines the comprehensive architecture for integrating a sophisticated multi-agent AI system into the CareCircle backend, creating an intelligent healthcare assistant that serves as a lightweight, self-hosted alternative to Dify.ai while maintaining full HIPAA compliance and seamless integration with existing infrastructure.

## 1. System Overview

### 1.1 Core Objectives
- **Multi-turn conversation management** with persistent session state
- **Personal health data integration** for personalized recommendations
- **Custom tone adaptation** based on user preferences and healthcare context
- **Vector database integration** for enhanced medical knowledge retrieval
- **Multi-model routing** for cost optimization (GPT-4 for complex queries, GPT-3.5 for simple responses)
- **Healthcare compliance** (HIPAA) throughout implementation
- **Dual authentication support** (Firebase users + guest demo sessions)

### 1.2 Architecture Principles
- **Domain-Driven Design (DDD)** - Maintains existing bounded context patterns
- **Clean Architecture** - Separation of concerns across layers
- **Healthcare-First** - HIPAA compliance and patient safety prioritized
- **Cost-Optimized** - Intelligent model selection and usage monitoring
- **Scalable** - Horizontal scaling with Redis-based persistence

## 2. Multi-Agent Architecture

### 2.1 Agent Orchestrator (Core Coordinator)
The central intelligence that manages the entire multi-agent ecosystem:

```typescript
interface AgentOrchestrator {
  // Route queries to appropriate specialized agents
  routeQuery(query: string, context: UserContext): Promise<AgentResponse>;
  
  // Manage conversation flow and context across agents
  manageConversationFlow(session: AgentSession): Promise<void>;
  
  // Handle multi-model cost optimization
  optimizeModelSelection(query: QueryAnalysis): ModelConfig;
  
  // Maintain session state across agents
  persistSessionState(session: AgentSession): Promise<void>;
}
```

### 2.2 Specialized Healthcare Agents

#### 2.2.1 Health Advisor Agent
- **Purpose**: General health questions, wellness advice, preventive care
- **Model Preference**: GPT-3.5-turbo for general queries, GPT-4 for complex health analysis
- **Integration**: health-data module for personalized recommendations
- **Capabilities**: Symptom assessment, wellness coaching, health education

#### 2.2.2 Medication Assistant Agent
- **Purpose**: Drug interactions, medication reminders, dosage information
- **Model Preference**: GPT-4 for drug interaction analysis (critical accuracy)
- **Integration**: medication module for prescription management
- **Capabilities**: Medication scheduling, interaction checking, adherence support

#### 2.2.3 Emergency Triage Agent
- **Purpose**: Urgent health situations, emergency escalation protocols
- **Model Preference**: GPT-4 (critical accuracy required)
- **Integration**: notification module for emergency alerts
- **Capabilities**: Symptom urgency assessment, emergency contact notification

#### 2.2.4 Data Interpreter Agent
- **Purpose**: Health metrics analysis, trend interpretation, insights generation
- **Model Preference**: GPT-4 for complex data analysis
- **Integration**: health-data analytics service
- **Capabilities**: Trend analysis, anomaly detection, personalized insights

#### 2.2.5 Care Coordinator Agent
- **Purpose**: Family/caregiver communication, care plan coordination
- **Model Preference**: GPT-3.5-turbo for communication tasks
- **Integration**: care-group module for family coordination
- **Capabilities**: Care plan updates, family notifications, coordination tasks

#### 2.2.6 Lifestyle Coach Agent
- **Purpose**: Exercise recommendations, nutrition advice, lifestyle optimization
- **Model Preference**: GPT-3.5-turbo (sufficient for lifestyle advice)
- **Integration**: health-data module for activity tracking
- **Capabilities**: Personalized fitness plans, nutrition guidance, habit formation

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
