# CareCircle AI Agent Testing Strategy

## Overview

This document outlines a comprehensive testing strategy for CareCircle's multi-agent AI system, ensuring healthcare compliance, patient safety, and system reliability through rigorous testing methodologies.

## Testing Pyramid

```
                    E2E Tests (Healthcare Scenarios)
                   /                                \
              Integration Tests (Agent Interactions)
             /                                      \
        Unit Tests (Individual Components)
       /                                            \
  Healthcare Compliance Tests    Performance Tests
```

## 1. Unit Testing Strategy

### 1.1 Agent Component Testing

```typescript
// test/unit/agents/health-advisor.test.ts
import { HealthAdvisorAgent } from '../../../src/agents/health-advisor.agent';
import { MockLLMService } from '../../mocks/llm.service.mock';
import { MockHealthContext } from '../../mocks/health-context.mock';

describe('HealthAdvisorAgent', () => {
  let healthAdvisor: HealthAdvisorAgent;
  let mockLLM: MockLLMService;

  beforeEach(() => {
    mockLLM = new MockLLMService();
    healthAdvisor = new HealthAdvisorAgent(mockLLM);
  });

  describe('General Health Queries', () => {
    it('should provide appropriate health advice for common symptoms', async () => {
      const query = 'I have been experiencing mild headaches for the past few days';
      const context = MockHealthContext.createBasicProfile();

      const response = await healthAdvisor.processQuery(query, context);

      expect(response.advice).toContain('headache');
      expect(response.recommendations).toHaveLength.greaterThan(0);
      expect(response.disclaimers).toContain('medical professional');
      expect(response.escalationRequired).toBe(false);
    });

    it('should escalate severe symptoms to emergency triage', async () => {
      const query = 'I am experiencing severe chest pain and difficulty breathing';
      const context = MockHealthContext.createBasicProfile();

      const response = await healthAdvisor.processQuery(query, context);

      expect(response.escalationRequired).toBe(true);
      expect(response.recommendedAgent).toBe('emergencyTriage');
      expect(response.urgencyLevel).toBeGreaterThan(0.8);
    });

    it('should handle Vietnamese health queries appropriately', async () => {
      const query = 'Tôi bị đau đầu và sốt nhẹ';
      const context = MockHealthContext.createVietnameseProfile();

      const response = await healthAdvisor.processQuery(query, context);

      expect(response.advice).toBeDefined();
      expect(response.culturalConsiderations).toContain('Vietnamese');
    });
  });

  describe('PHI Protection', () => {
    it('should detect and mask PHI in health queries', async () => {
      const query = 'My name is John Doe, DOB 01/15/1985, and I have diabetes';
      const context = MockHealthContext.createBasicProfile();

      const response = await healthAdvisor.processQuery(query, context);

      expect(response.phiDetected).toBe(true);
      expect(response.sanitizedQuery).not.toContain('John Doe');
      expect(response.sanitizedQuery).not.toContain('01/15/1985');
    });
  });
});
```

### 1.2 Cost Optimization Testing

```typescript
// test/unit/services/cost-optimization.test.ts
describe('CostOptimizationService', () => {
  let costService: CostOptimizationService;

  beforeEach(() => {
    costService = new CostOptimizationService();
  });

  it('should select GPT-4 for critical healthcare queries', async () => {
    const analysis = {
      complexity: HealthcareQueryComplexity.CRITICAL,
      urgencyLevel: 0.9,
      complianceLevel: 'emergency'
    };

    const modelConfig = await costService.selectHealthcareModel(
      analysis,
      mockUserBudget,
      'emergencyTriage',
      mockStateContext
    );

    expect(modelConfig.model).toBe('gpt-4');
    expect(modelConfig.temperature).toBeLessThan(0.2);
  });

  it('should respect budget constraints while maintaining safety', async () => {
    const lowBudget = { monthlyLimit: 10, currentUsage: 9.5 };
    const analysis = {
      complexity: HealthcareQueryComplexity.MODERATE,
      urgencyLevel: 0.3,
      complianceLevel: 'standard'
    };

    const modelConfig = await costService.selectHealthcareModel(
      analysis,
      lowBudget,
      'healthAdvisor',
      mockStateContext
    );

    expect(modelConfig.model).toBe('gpt-3.5-turbo');
    expect(modelConfig.reasoning).toContain('budget');
  });
});
```

## 2. Integration Testing

### 2.1 Agent Handoff Testing

```typescript
// test/integration/agent-handoff.test.ts
describe('Agent Handoff Integration', () => {
  let orchestrator: AgentOrchestrator;
  let testContainer: TestingModule;

  beforeAll(async () => {
    testContainer = await Test.createTestingModule({
      imports: [MultiAgentModule],
      providers: [MockHealthcareServices],
    }).compile();

    orchestrator = testContainer.get<AgentOrchestrator>(AgentOrchestrator);
  });

  it('should hand off from health advisor to emergency triage', async () => {
    const conversationId = 'test-conversation-123';
    const userId = 'test-user-456';

    // Start with health advisor
    const initialResponse = await orchestrator.processHealthcareQuery(
      'I have been feeling tired lately',
      userId,
      conversationId
    );

    expect(initialResponse.activeAgent).toBe('healthAdvisor');

    // Escalate to emergency
    const emergencyResponse = await orchestrator.processHealthcareQuery(
      'Actually, I am now experiencing severe chest pain',
      userId,
      conversationId
    );

    expect(emergencyResponse.activeAgent).toBe('emergencyTriage');
    expect(emergencyResponse.handoffReason).toContain('emergency');
    expect(emergencyResponse.urgencyLevel).toBeGreaterThan(0.8);
  });

  it('should maintain context across agent handoffs', async () => {
    const conversationId = 'test-conversation-789';
    const userId = 'test-user-101';

    // Health advisor interaction
    await orchestrator.processHealthcareQuery(
      'I am taking Lisinopril for high blood pressure',
      userId,
      conversationId
    );

    // Hand off to medication assistant
    const medicationResponse = await orchestrator.processHealthcareQuery(
      'Can I take ibuprofen with my current medication?',
      userId,
      conversationId
    );

    expect(medicationResponse.activeAgent).toBe('medicationAssistant');
    expect(medicationResponse.context.currentMedications).toContain('Lisinopril');
  });
});
```

### 2.2 Database Integration Testing

```typescript
// test/integration/database.test.ts
describe('Database Integration', () => {
  let prisma: PrismaService;
  let agentService: AgentOrchestrator;

  beforeAll(async () => {
    // Use test database
    prisma = new PrismaService({
      datasources: { db: { url: process.env.TEST_DATABASE_URL } }
    });
  });

  it('should persist agent interactions with HIPAA compliance', async () => {
    const sessionData = {
      conversationId: 'test-conv-123',
      threadId: 'test-thread-456',
      activeAgent: 'healthAdvisor',
      userId: 'test-user-789'
    };

    const interaction = await agentService.processHealthcareQuery(
      'I have a question about my blood pressure',
      sessionData.userId,
      sessionData.threadId
    );

    // Verify agent session creation
    const session = await prisma.agentSession.findFirst({
      where: { threadId: sessionData.threadId }
    });

    expect(session).toBeDefined();
    expect(session.activeAgent).toBe('healthAdvisor');

    // Verify agent interaction logging
    const interactions = await prisma.agentInteraction.findMany({
      where: { sessionId: session.id }
    });

    expect(interactions).toHaveLength(1);
    expect(interactions[0].queryHash).toBeDefined();
    expect(interactions[0].responseHash).toBeDefined();
    expect(interactions[0].phiDetected).toBe(false);
  });
});
```

## 3. Healthcare Compliance Testing

### 3.1 HIPAA Compliance Testing

```typescript
// test/compliance/hipaa.test.ts
describe('HIPAA Compliance', () => {
  let complianceService: ComplianceService;
  let auditService: HIPAAAuditService;

  beforeEach(() => {
    complianceService = new ComplianceService();
    auditService = new HIPAAAuditService();
  });

  describe('PHI Detection and Masking', () => {
    it('should detect and mask Social Security Numbers', async () => {
      const content = 'My SSN is 123-45-6789 and I need help';
      
      const result = await complianceService.detectAndMaskPHI(content, 'logging');
      
      expect(result.detectedPHI).toHaveLength(1);
      expect(result.detectedPHI[0].type).toBe('ssn');
      expect(result.maskedContent).toContain('[SSN-REDACTED]');
      expect(result.maskedContent).not.toContain('123-45-6789');
    });

    it('should detect medical record numbers', async () => {
      const content = 'My medical record number is MRN123456789';
      
      const result = await complianceService.detectAndMaskPHI(content, 'storage');
      
      expect(result.detectedPHI.some(phi => phi.type === 'mrn')).toBe(true);
      expect(result.maskedContent).not.toContain('MRN123456789');
    });

    it('should handle Vietnamese names and addresses', async () => {
      const content = 'Tôi tên là Nguyễn Văn An, địa chỉ 123 Đường Lê Lợi, TP.HCM';
      
      const result = await complianceService.detectAndMaskPHI(content, 'transmission');
      
      expect(result.detectedPHI.length).toBeGreaterThan(0);
      expect(result.maskedContent).toContain('[ENCRYPTED]');
    });
  });

  describe('Audit Trail', () => {
    it('should log all AI interactions with proper audit trail', async () => {
      const interaction = {
        userId: 'test-user-123',
        sessionId: 'test-session-456',
        agentName: 'healthAdvisor',
        query: 'I have a headache',
        response: 'Try rest and hydration',
        modelUsed: 'gpt-3.5-turbo',
        tokensUsed: 150,
        processingTime: 2500,
        costUSD: 0.0003,
        complianceFlags: [],
        emergencyEscalation: false,
        ipAddress: '192.168.1.1',
        userAgent: 'CareCircle Mobile App'
      };

      await auditService.logAIInteraction(interaction);

      const auditRecord = await prisma.auditLog.findFirst({
        where: { sessionId: interaction.sessionId }
      });

      expect(auditRecord).toBeDefined();
      expect(auditRecord.retentionDate).toBeDefined();
      expect(auditRecord.auditHash).toBeDefined();
      expect(auditRecord.encryptedData).toBeDefined();
    });
  });
});
```

### 3.2 Emergency Protocol Testing

```typescript
// test/compliance/emergency-protocols.test.ts
describe('Emergency Protocol Compliance', () => {
  let emergencyService: EmergencyEscalationService;
  let notificationService: NotificationService;

  beforeEach(() => {
    emergencyService = new EmergencyEscalationService();
    notificationService = jest.mocked(NotificationService);
  });

  it('should trigger emergency protocols for critical symptoms', async () => {
    const query = 'I am having severe chest pain and cannot breathe';
    const context = {
      userId: 'test-user-123',
      emergencyContacts: [
        { name: 'John Doe', phone: '+1234567890', relationship: 'spouse' }
      ],
      primaryCareProvider: { id: 'provider-456', name: 'Dr. Smith' }
    };

    const assessment = await emergencyService.assessEmergencyStatus(query, context);

    expect(assessment.urgencyLevel).toBe('CRITICAL');
    expect(assessment.escalationRequired).toBe(true);
    expect(assessment.responseTimeLimit).toBeLessThanOrEqual(30); // 30 seconds

    // Verify emergency notifications were triggered
    expect(notificationService.sendEmergencyAlert).toHaveBeenCalled();
  });

  it('should comply with Vietnamese emergency service protocols', async () => {
    const query = 'Tôi đang bị đau tim và khó thở';
    const context = {
      userId: 'test-user-vn',
      location: { country: 'VN', city: 'Ho Chi Minh City' },
      emergencyContacts: []
    };

    const assessment = await emergencyService.assessEmergencyStatus(query, context);

    expect(assessment.emergencyType).toContain('cardiac');
    expect(assessment.recommendedActions).toContain('115'); // Vietnamese emergency number
  });
});
```

## 4. Performance Testing

### 4.1 Load Testing

```typescript
// test/performance/load.test.ts
describe('AI Agent Load Testing', () => {
  it('should handle concurrent healthcare queries', async () => {
    const concurrentUsers = 100;
    const queriesPerUser = 10;
    
    const promises = Array.from({ length: concurrentUsers }, async (_, userIndex) => {
      const userId = `load-test-user-${userIndex}`;
      const queries = Array.from({ length: queriesPerUser }, (_, queryIndex) => 
        `Health query ${queryIndex} from user ${userIndex}`
      );

      const startTime = Date.now();
      
      for (const query of queries) {
        await agentOrchestrator.processHealthcareQuery(query, userId, `thread-${userIndex}`);
      }
      
      return Date.now() - startTime;
    });

    const results = await Promise.all(promises);
    const averageTime = results.reduce((sum, time) => sum + time, 0) / results.length;
    const maxTime = Math.max(...results);

    expect(averageTime).toBeLessThan(30000); // 30 seconds average
    expect(maxTime).toBeLessThan(60000); // 60 seconds max
  });

  it('should maintain response times under healthcare SLA', async () => {
    const healthcareQueries = [
      { query: 'I have a mild headache', expectedTime: 5000 },
      { query: 'Can I take aspirin with my medication?', expectedTime: 8000 },
      { query: 'I am having chest pain', expectedTime: 3000 }, // Emergency - faster
    ];

    for (const { query, expectedTime } of healthcareQueries) {
      const startTime = Date.now();
      
      await agentOrchestrator.processHealthcareQuery(query, 'test-user', 'test-thread');
      
      const responseTime = Date.now() - startTime;
      expect(responseTime).toBeLessThan(expectedTime);
    }
  });
});
```

## 5. End-to-End Testing

### 5.1 Healthcare Scenario Testing

```typescript
// test/e2e/healthcare-scenarios.test.ts
describe('Healthcare Scenarios E2E', () => {
  let app: INestApplication;
  let request: supertest.SuperTest<supertest.Test>;

  beforeAll(async () => {
    const moduleFixture = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
    request = supertest(app.getHttpServer());
  });

  it('should handle complete medication consultation workflow', async () => {
    // 1. Start conversation
    const conversationResponse = await request
      .post('/api/v1/agents/conversations')
      .set('Authorization', `Bearer ${testToken}`)
      .send({
        userId: 'test-user-123',
        initialMessage: 'I need help with my medications',
        conversationType: 'medication'
      })
      .expect(201);

    const conversationId = conversationResponse.body.conversationId;

    // 2. Ask about drug interactions
    const interactionResponse = await request
      .post(`/api/v1/agents/conversations/${conversationId}/messages`)
      .set('Authorization', `Bearer ${testToken}`)
      .send({
        message: 'I am taking Lisinopril. Can I take ibuprofen?',
        messageType: 'text'
      })
      .expect(201);

    expect(interactionResponse.body.agentResponse.agentName).toBe('medicationAssistant');
    expect(interactionResponse.body.agentResponse.response).toContain('interaction');
    expect(interactionResponse.body.agentResponse.warnings).toBeDefined();

    // 3. Follow up with dosage question
    const dosageResponse = await request
      .post(`/api/v1/agents/conversations/${conversationId}/messages`)
      .set('Authorization', `Bearer ${testToken}`)
      .send({
        message: 'What is the safe dosage of ibuprofen for me?',
        messageType: 'text'
      })
      .expect(201);

    expect(dosageResponse.body.agentResponse.recommendations).toBeDefined();
    expect(dosageResponse.body.costIncurred).toBeGreaterThan(0);
  });

  it('should handle emergency escalation workflow', async () => {
    // 1. Start with general health query
    const conversationResponse = await request
      .post('/api/v1/agents/conversations')
      .set('Authorization', `Bearer ${testToken}`)
      .send({
        userId: 'test-user-emergency',
        initialMessage: 'I am not feeling well',
        conversationType: 'general'
      })
      .expect(201);

    // 2. Escalate to emergency
    const emergencyResponse = await request
      .post(`/api/v1/agents/conversations/${conversationResponse.body.conversationId}/messages`)
      .set('Authorization', `Bearer ${testToken}`)
      .send({
        message: 'I am having severe chest pain and difficulty breathing',
        messageType: 'text'
      })
      .expect(201);

    expect(emergencyResponse.body.agentHandoff.toAgent).toBe('emergencyTriage');
    expect(emergencyResponse.body.agentResponse.urgencyLevel).toBeGreaterThan(0.8);
    
    // Verify emergency protocols were triggered
    const escalationRecord = await prisma.emergencyEscalation.findFirst({
      where: { sessionId: emergencyResponse.body.sessionId }
    });
    
    expect(escalationRecord).toBeDefined();
    expect(escalationRecord.urgencyLevel).toBe('CRITICAL');
  });
});
```

## 6. Test Execution Strategy

### 6.1 Continuous Integration Pipeline

```yaml
# .github/workflows/ai-agent-tests.yml
name: AI Agent Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '22'
      - run: npm ci
      - run: npm run test:unit
      - run: npm run test:compliance

  integration-tests:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
      redis:
        image: redis:7
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '22'
      - run: npm ci
      - run: npm run test:integration
      - run: npm run test:e2e

  performance-tests:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '22'
      - run: npm ci
      - run: npm run test:performance
```

This comprehensive testing strategy ensures CareCircle's AI agent system meets the highest standards of healthcare compliance, patient safety, and system reliability.
