# CareCircle Multi-Agent System Technical Specifications

## Agent Interface Specifications

### Core Agent Interface

```typescript
interface HealthcareAgent {
  // Agent identification
  readonly name: string;
  readonly version: string;
  readonly capabilities: AgentCapability[];
  
  // Core methods
  canHandle(query: string, context: UserContext): Promise<boolean>;
  process(query: string, context: UserContext, session: AgentSession): Promise<AgentResponse>;
  getModelPreference(complexity: QueryComplexity): ModelConfig;
  
  // Lifecycle methods
  initialize(): Promise<void>;
  cleanup(): Promise<void>;
  
  // Health and monitoring
  getHealthStatus(): AgentHealthStatus;
  getPerformanceMetrics(): AgentMetrics;
}

interface AgentResponse {
  response: string;
  confidence: number;
  metadata: AgentResponseMetadata;
  nextActions?: AgentAction[];
  escalationRequired?: boolean;
  complianceFlags?: ComplianceFlag[];
}

interface UserContext {
  userId: string;
  isGuest: boolean;
  healthProfile?: HealthProfile;
  medications?: Medication[];
  recentMetrics?: HealthMetric[];
  preferences: UserPreferences;
  emergencyContacts?: EmergencyContact[];
}
```

## Specialized Agent Specifications

### 1. Health Advisor Agent

```typescript
@Injectable()
export class HealthAdvisorAgent implements HealthcareAgent {
  readonly name = 'HealthAdvisor';
  readonly version = '1.0.0';
  readonly capabilities = [
    AgentCapability.GENERAL_HEALTH_ADVICE,
    AgentCapability.WELLNESS_COACHING,
    AgentCapability.PREVENTIVE_CARE,
    AgentCapability.SYMPTOM_ASSESSMENT,
  ];

  constructor(
    private readonly openAIService: OpenAIService,
    private readonly healthDataService: HealthDataService,
    private readonly complianceService: HIPAAComplianceService,
  ) {}

  async canHandle(query: string, context: UserContext): Promise<boolean> {
    const analysis = await this.analyzeQuery(query);
    return analysis.categories.includes('general_health') ||
           analysis.categories.includes('wellness') ||
           analysis.categories.includes('symptoms');
  }

  async process(
    query: string,
    context: UserContext,
    session: AgentSession,
  ): Promise<AgentResponse> {
    // Build health-specific context
    const healthContext = await this.buildHealthContext(context);
    
    // Generate personalized response
    const systemPrompt = this.buildSystemPrompt(healthContext);
    const messages = [
      { role: 'system', content: systemPrompt },
      { role: 'user', content: query },
    ];

    const modelConfig = this.getModelPreference(
      await this.assessComplexity(query)
    );

    const response = await this.openAIService.generateResponse(
      messages,
      modelConfig
    );

    // Apply compliance checks
    const complianceResult = await this.complianceService.validateResponse(
      response,
      query,
      context
    );

    return {
      response: complianceResult.sanitizedResponse,
      confidence: await this.calculateConfidence(query, response, context),
      metadata: {
        agent: this.name,
        modelUsed: modelConfig.model,
        tokensUsed: response.usage?.total_tokens || 0,
        processingTime: Date.now() - session.startTime,
      },
      complianceFlags: complianceResult.flags,
    };
  }

  getModelPreference(complexity: QueryComplexity): ModelConfig {
    switch (complexity) {
      case QueryComplexity.SIMPLE:
        return { model: 'gpt-3.5-turbo', maxTokens: 500, temperature: 0.7 };
      case QueryComplexity.MODERATE:
        return { model: 'gpt-3.5-turbo', maxTokens: 800, temperature: 0.6 };
      case QueryComplexity.COMPLEX:
        return { model: 'gpt-4', maxTokens: 1000, temperature: 0.5 };
      default:
        return { model: 'gpt-3.5-turbo', maxTokens: 600, temperature: 0.7 };
    }
  }

  private buildSystemPrompt(healthContext: HealthContext): string {
    return `You are a knowledgeable healthcare advisor assistant for CareCircle.

ROLE: Provide evidence-based health advice and wellness guidance while maintaining appropriate medical boundaries.

CAPABILITIES:
- General health and wellness questions
- Symptom assessment and guidance
- Preventive care recommendations
- Lifestyle and wellness coaching
- Health education and information

HEALTH CONTEXT:
${healthContext.summary}

GUIDELINES:
- Always include appropriate medical disclaimers
- Encourage professional consultation for serious concerns
- Provide empathetic, supportive responses
- Use evidence-based information
- Respect user privacy and confidentiality

LIMITATIONS:
- Cannot diagnose medical conditions
- Cannot prescribe medications
- Cannot replace professional medical advice
- Must escalate emergency situations

Respond in a ${healthContext.preferences.tone} tone with ${healthContext.preferences.responseLength} responses at a ${healthContext.preferences.technicalLevel} technical level.`;
  }
}
```

### 2. Emergency Triage Agent

```typescript
@Injectable()
export class EmergencyTriageAgent implements HealthcareAgent {
  readonly name = 'EmergencyTriage';
  readonly version = '1.0.0';
  readonly capabilities = [
    AgentCapability.EMERGENCY_ASSESSMENT,
    AgentCapability.URGENCY_CLASSIFICATION,
    AgentCapability.ESCALATION_PROTOCOLS,
  ];

  private readonly emergencyKeywords = [
    'chest pain', 'difficulty breathing', 'severe bleeding',
    'loss of consciousness', 'stroke symptoms', 'heart attack',
    'severe allergic reaction', 'poisoning', 'severe injury'
  ];

  async canHandle(query: string, context: UserContext): Promise<boolean> {
    const urgencyScore = await this.assessUrgency(query);
    return urgencyScore >= 0.7; // High urgency threshold
  }

  async process(
    query: string,
    context: UserContext,
    session: AgentSession,
  ): Promise<AgentResponse> {
    const urgencyAssessment = await this.performUrgencyAssessment(query, context);
    
    if (urgencyAssessment.isEmergency) {
      // Immediate escalation for true emergencies
      await this.triggerEmergencyEscalation(context, urgencyAssessment);
      
      return {
        response: this.generateEmergencyResponse(urgencyAssessment),
        confidence: 0.95,
        escalationRequired: true,
        metadata: {
          agent: this.name,
          urgencyLevel: urgencyAssessment.urgencyLevel,
          emergencyType: urgencyAssessment.emergencyType,
          escalationTriggered: true,
        },
        complianceFlags: [
          {
            type: 'EMERGENCY_ESCALATION',
            message: 'Emergency protocols activated',
            timestamp: new Date(),
          }
        ],
      };
    }

    // High urgency but not immediate emergency
    const response = await this.generateTriageResponse(query, context, urgencyAssessment);
    
    return {
      response,
      confidence: urgencyAssessment.confidence,
      metadata: {
        agent: this.name,
        urgencyLevel: urgencyAssessment.urgencyLevel,
        recommendedAction: urgencyAssessment.recommendedAction,
      },
      nextActions: urgencyAssessment.recommendedActions,
    };
  }

  getModelPreference(complexity: QueryComplexity): ModelConfig {
    // Always use GPT-4 for emergency triage - accuracy is critical
    return {
      model: 'gpt-4',
      maxTokens: 800,
      temperature: 0.1, // Very low temperature for consistent emergency assessment
    };
  }

  private async assessUrgency(query: string): Promise<number> {
    // Keyword-based initial screening
    const hasEmergencyKeywords = this.emergencyKeywords.some(keyword =>
      query.toLowerCase().includes(keyword.toLowerCase())
    );

    if (hasEmergencyKeywords) {
      return 0.9; // High urgency
    }

    // AI-based urgency assessment
    const urgencyPrompt = `Assess the urgency of this health query on a scale of 0.0 to 1.0:
    
Query: "${query}"

Urgency levels:
- 0.0-0.3: General wellness questions
- 0.4-0.6: Health concerns for monitoring
- 0.7-0.8: Symptoms requiring medical consultation
- 0.9-1.0: Emergency situations requiring immediate attention

Respond with only a number between 0.0 and 1.0.`;

    const response = await this.openAIService.generateResponse([
      { role: 'system', content: urgencyPrompt },
    ], { model: 'gpt-4', temperature: 0.1, maxTokens: 10 });

    const urgencyScore = parseFloat(response.trim());
    return isNaN(urgencyScore) ? 0.5 : Math.max(0, Math.min(1, urgencyScore));
  }

  private async triggerEmergencyEscalation(
    context: UserContext,
    assessment: UrgencyAssessment,
  ): Promise<void> {
    // Log emergency event
    await this.complianceService.logEmergencyEvent({
      userId: context.userId,
      emergencyType: assessment.emergencyType,
      urgencyLevel: assessment.urgencyLevel,
      timestamp: new Date(),
    });

    // Notify emergency contacts if available
    if (context.emergencyContacts?.length > 0) {
      await this.notificationService.sendEmergencyAlert({
        contacts: context.emergencyContacts,
        message: 'Emergency health situation detected',
        userContext: context,
      });
    }

    // Trigger healthcare provider notification if configured
    await this.healthcareProviderService.notifyEmergency({
      userId: context.userId,
      emergencyDetails: assessment,
    });
  }
}
```

### 3. Medication Assistant Agent

```typescript
@Injectable()
export class MedicationAssistantAgent implements HealthcareAgent {
  readonly name = 'MedicationAssistant';
  readonly version = '1.0.0';
  readonly capabilities = [
    AgentCapability.MEDICATION_INFORMATION,
    AgentCapability.DRUG_INTERACTIONS,
    AgentCapability.DOSAGE_GUIDANCE,
    AgentCapability.ADHERENCE_SUPPORT,
  ];

  constructor(
    private readonly medicationService: MedicationService,
    private readonly drugInteractionService: DrugInteractionService,
    private readonly openAIService: OpenAIService,
  ) {}

  async canHandle(query: string, context: UserContext): Promise<boolean> {
    const medicationKeywords = [
      'medication', 'drug', 'pill', 'prescription', 'dosage',
      'side effect', 'interaction', 'pharmacy', 'refill'
    ];

    return medicationKeywords.some(keyword =>
      query.toLowerCase().includes(keyword.toLowerCase())
    );
  }

  async process(
    query: string,
    context: UserContext,
    session: AgentSession,
  ): Promise<AgentResponse> {
    // Get user's current medications
    const userMedications = await this.medicationService.getUserMedications(context.userId);
    
    // Analyze query for medication-related intent
    const queryAnalysis = await this.analyzeMedicationQuery(query);
    
    let response: string;
    let confidence: number;
    const metadata: any = {
      agent: this.name,
      queryType: queryAnalysis.type,
    };

    switch (queryAnalysis.type) {
      case 'drug_interaction':
        const interactionResult = await this.checkDrugInteractions(
          queryAnalysis.medications,
          userMedications
        );
        response = await this.generateInteractionResponse(interactionResult);
        confidence = interactionResult.confidence;
        metadata.interactionsFound = interactionResult.interactions.length;
        break;

      case 'medication_info':
        response = await this.generateMedicationInfo(queryAnalysis.medications[0]);
        confidence = 0.9;
        break;

      case 'dosage_question':
        response = await this.generateDosageGuidance(query, userMedications);
        confidence = 0.8;
        break;

      case 'adherence_support':
        response = await this.generateAdherenceSupport(query, context);
        confidence = 0.85;
        break;

      default:
        response = await this.generateGeneralMedicationResponse(query, context);
        confidence = 0.7;
    }

    return {
      response,
      confidence,
      metadata,
      complianceFlags: [
        {
          type: 'MEDICATION_DISCLAIMER',
          message: 'Medication information provided for educational purposes only',
          timestamp: new Date(),
        }
      ],
    };
  }

  getModelPreference(complexity: QueryComplexity): ModelConfig {
    // Use GPT-4 for drug interactions (critical accuracy)
    // GPT-3.5-turbo for general medication information
    return complexity === QueryComplexity.CRITICAL
      ? { model: 'gpt-4', maxTokens: 1000, temperature: 0.2 }
      : { model: 'gpt-3.5-turbo', maxTokens: 800, temperature: 0.5 };
  }

  private async checkDrugInteractions(
    queryMedications: string[],
    userMedications: Medication[],
  ): Promise<DrugInteractionResult> {
    const allMedications = [
      ...queryMedications,
      ...userMedications.map(med => med.name),
    ];

    return await this.drugInteractionService.checkInteractions(allMedications);
  }
}
```

## Agent Orchestrator Specification

```typescript
@Injectable()
export class AgentOrchestrator {
  private readonly agents = new Map<string, HealthcareAgent>();
  private readonly routingRules: RoutingRule[] = [];

  constructor(
    private readonly langGraphService: LangGraphService,
    private readonly contextManager: ContextManager,
    private readonly costOptimizer: CostOptimizer,
    private readonly complianceMonitor: HIPAAComplianceService,
    private readonly sessionManager: SessionManager,
  ) {
    this.initializeAgents();
    this.setupRoutingRules();
  }

  async processQuery(
    query: string,
    userId: string,
    conversationId: string,
  ): Promise<AgentResponse> {
    // 1. Load or create session
    const session = await this.sessionManager.getOrCreateSession(
      userId,
      conversationId
    );

    // 2. Build user context
    const context = await this.contextManager.buildUserContext(userId);

    // 3. Classify query and select agent
    const selectedAgent = await this.selectAgent(query, context);

    // 4. Check cost constraints
    const costCheck = await this.costOptimizer.checkBudget(userId, selectedAgent);
    if (!costCheck.allowed) {
      return this.generateBudgetExceededResponse(costCheck);
    }

    // 5. Process with selected agent
    const response = await selectedAgent.process(query, context, session);

    // 6. Update session and track costs
    await this.sessionManager.updateSession(session, {
      lastAgent: selectedAgent.name,
      lastQuery: query,
      lastResponse: response,
    });

    await this.costOptimizer.trackUsage(userId, response.metadata.tokensUsed);

    // 7. Compliance monitoring
    await this.complianceMonitor.logAIInteraction({
      userId,
      agent: selectedAgent.name,
      query: await this.complianceMonitor.sanitizeForLogging(query),
      response: await this.complianceMonitor.sanitizeForLogging(response.response),
      metadata: response.metadata,
    });

    return response;
  }

  private async selectAgent(
    query: string,
    context: UserContext,
  ): Promise<HealthcareAgent> {
    // Check each agent's capability to handle the query
    const agentScores = await Promise.all(
      Array.from(this.agents.values()).map(async agent => ({
        agent,
        canHandle: await agent.canHandle(query, context),
        score: await this.calculateAgentScore(agent, query, context),
      }))
    );

    // Filter agents that can handle the query
    const capableAgents = agentScores.filter(item => item.canHandle);

    if (capableAgents.length === 0) {
      // Fallback to Health Advisor for general queries
      return this.agents.get('HealthAdvisor')!;
    }

    // Select agent with highest score
    const bestAgent = capableAgents.reduce((best, current) =>
      current.score > best.score ? current : best
    );

    return bestAgent.agent;
  }

  private async calculateAgentScore(
    agent: HealthcareAgent,
    query: string,
    context: UserContext,
  ): Promise<number> {
    // Base score from agent's confidence in handling the query
    let score = 0.5;

    // Boost score based on agent specialization
    const queryAnalysis = await this.analyzeQuery(query);
    const agentCapabilities = agent.capabilities;

    // Calculate capability match score
    const capabilityMatch = queryAnalysis.categories.filter(category =>
      agentCapabilities.some(cap => cap.includes(category))
    ).length / queryAnalysis.categories.length;

    score += capabilityMatch * 0.4;

    // Consider user context and preferences
    if (context.preferences.preferredAgents?.includes(agent.name)) {
      score += 0.1;
    }

    return Math.min(1.0, score);
  }
}
```

## Performance and Monitoring Specifications

### Agent Health Monitoring

```typescript
interface AgentHealthStatus {
  status: 'healthy' | 'degraded' | 'unhealthy';
  lastHealthCheck: Date;
  responseTime: {
    average: number;
    p95: number;
    p99: number;
  };
  errorRate: number;
  successRate: number;
  memoryUsage: number;
}

interface AgentMetrics {
  totalQueries: number;
  successfulQueries: number;
  failedQueries: number;
  averageConfidence: number;
  averageResponseTime: number;
  costPerQuery: number;
  userSatisfactionScore: number;
}
```

### Cost Tracking Specifications

```typescript
interface CostTrackingInfo {
  userId: string;
  monthlyBudget: number;
  currentMonthUsage: number;
  remainingBudget: number;
  averageCostPerQuery: number;
  projectedMonthlyUsage: number;
  budgetAlertThreshold: number;
}

interface ModelConfig {
  model: string;
  maxTokens: number;
  temperature: number;
  estimatedCost?: number;
}
```

---

*These technical specifications provide the detailed implementation guidelines for building robust, healthcare-compliant AI agents within the CareCircle ecosystem.*
