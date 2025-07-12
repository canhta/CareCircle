# CareCircle AI Agent API Specifications

## Overview

This document provides comprehensive API specifications for CareCircle's multi-agent AI system, including REST endpoints, WebSocket connections, and integration patterns with the existing NestJS backend.

## Base Configuration

```typescript
// API Base URLs
const API_BASE_URL = process.env.NODE_ENV === 'production' 
  ? 'https://ai-api.carecircle.app'
  : 'http://localhost:3001';

const WEBSOCKET_URL = process.env.NODE_ENV === 'production'
  ? 'wss://ai-api.carecircle.app/ws'
  : 'ws://localhost:3001/ws';
```

## Authentication

All AI agent endpoints require Firebase authentication tokens:

```typescript
interface AuthHeaders {
  'Authorization': `Bearer ${firebaseIdToken}`;
  'Content-Type': 'application/json';
  'X-Client-Version': string;
  'X-Request-ID': string; // For audit trails
}
```

## 1. Agent Orchestrator API

### 1.1 Start Conversation

**Endpoint**: `POST /api/v1/agents/conversations`

**Description**: Initialize a new conversation with the AI agent system

```typescript
interface StartConversationRequest {
  userId: string;
  initialMessage: string;
  conversationType: 'general' | 'emergency' | 'medication' | 'wellness';
  userContext?: {
    healthProfile?: HealthProfile;
    currentMedications?: Medication[];
    recentMetrics?: HealthMetric[];
    emergencyContacts?: EmergencyContact[];
  };
  preferences?: {
    tone: 'professional' | 'friendly' | 'empathetic';
    responseLength: 'brief' | 'detailed' | 'comprehensive';
    technicalLevel: 'simple' | 'moderate' | 'advanced';
  };
}

interface StartConversationResponse {
  conversationId: string;
  threadId: string; // LangGraph thread ID
  initialResponse: AgentResponse;
  recommendedAgent: string;
  estimatedCost: number;
  complianceFlags: ComplianceFlag[];
}

// Example Usage
const response = await fetch(`${API_BASE_URL}/api/v1/agents/conversations`, {
  method: 'POST',
  headers: authHeaders,
  body: JSON.stringify({
    userId: 'user_123',
    initialMessage: 'I have been experiencing chest pain for the last hour',
    conversationType: 'emergency',
    userContext: {
      healthProfile: userHealthProfile,
      emergencyContacts: userEmergencyContacts
    }
  })
});
```

### 1.2 Continue Conversation

**Endpoint**: `POST /api/v1/agents/conversations/{conversationId}/messages`

**Description**: Send a message to continue an existing conversation

```typescript
interface ContinueConversationRequest {
  message: string;
  messageType: 'text' | 'voice_transcript' | 'image_description';
  metadata?: {
    location?: GeoLocation;
    timestamp?: Date;
    urgencyLevel?: number;
  };
}

interface ContinueConversationResponse {
  messageId: string;
  agentResponse: AgentResponse;
  agentHandoff?: {
    fromAgent: string;
    toAgent: string;
    reason: string;
  };
  costIncurred: number;
  complianceFlags: ComplianceFlag[];
}
```

### 1.3 Stream Conversation

**Endpoint**: `GET /api/v1/agents/conversations/{conversationId}/stream`

**Description**: Server-Sent Events for real-time conversation streaming

```typescript
interface StreamEvent {
  type: 'message_chunk' | 'agent_thinking' | 'agent_handoff' | 'emergency_alert' | 'complete';
  data: {
    content?: string;
    agent?: string;
    metadata?: any;
    timestamp: Date;
  };
}

// Example Usage
const eventSource = new EventSource(
  `${API_BASE_URL}/api/v1/agents/conversations/${conversationId}/stream`,
  { headers: authHeaders }
);

eventSource.onmessage = (event) => {
  const streamEvent: StreamEvent = JSON.parse(event.data);
  handleStreamEvent(streamEvent);
};
```

## 2. Healthcare Agent Endpoints

### 2.1 Health Advisor Agent

**Endpoint**: `POST /api/v1/agents/health-advisor`

```typescript
interface HealthAdvisorRequest {
  query: string;
  userContext: UserHealthContext;
  sessionId: string;
  preferences?: AgentPreferences;
}

interface HealthAdvisorResponse {
  advice: string;
  confidence: number;
  sources: HealthInformationSource[];
  recommendations: HealthRecommendation[];
  followUpQuestions: string[];
  disclaimers: string[];
  escalationRequired: boolean;
}
```

### 2.2 Medication Assistant Agent

**Endpoint**: `POST /api/v1/agents/medication-assistant`

```typescript
interface MedicationAssistantRequest {
  query: string;
  currentMedications: Medication[];
  userContext: UserHealthContext;
  queryType: 'interaction_check' | 'dosage_info' | 'side_effects' | 'adherence';
}

interface MedicationAssistantResponse {
  response: string;
  interactions?: DrugInteraction[];
  warnings: MedicationWarning[];
  recommendations: MedicationRecommendation[];
  adherenceSupport?: AdherenceGuidance;
  pharmacyIntegration?: PharmacyInfo;
}
```

### 2.3 Emergency Triage Agent

**Endpoint**: `POST /api/v1/agents/emergency-triage`

```typescript
interface EmergencyTriageRequest {
  symptoms: string;
  urgencyIndicators: string[];
  userContext: UserHealthContext;
  location?: GeoLocation;
  vitalSigns?: VitalSigns;
}

interface EmergencyTriageResponse {
  urgencyLevel: 'low' | 'medium' | 'high' | 'critical';
  urgencyScore: number;
  recommendedActions: EmergencyAction[];
  escalationTriggered: boolean;
  emergencyServices?: {
    contacted: boolean;
    estimatedArrival?: number;
  };
  immediateInstructions: string[];
  warningFlags: string[];
}
```

## 3. Integration with Existing CareCircle Backend

### 3.1 Health Data Integration

**Endpoint**: `GET /api/v1/agents/context/health-data/{userId}`

```typescript
interface HealthDataContext {
  recentMetrics: HealthMetric[];
  trends: HealthTrend[];
  anomalies: HealthAnomaly[];
  riskFactors: RiskFactor[];
  insights: HealthInsight[];
}

// Integration with existing health-data module
@Controller('agents/context')
export class AgentContextController {
  constructor(
    private readonly healthDataService: HealthDataService,
    private readonly agentContextBuilder: AgentContextBuilder
  ) {}

  @Get('health-data/:userId')
  @UseGuards(FirebaseAuthGuard)
  async getHealthDataContext(@Param('userId') userId: string): Promise<HealthDataContext> {
    const healthMetrics = await this.healthDataService.getRecentMetrics(userId);
    const trends = await this.healthDataService.analyzeTrends(userId);
    
    return this.agentContextBuilder.buildHealthDataContext({
      metrics: healthMetrics,
      trends,
      userId
    });
  }
}
```

### 3.2 Medication Integration

**Endpoint**: `GET /api/v1/agents/context/medications/{userId}`

```typescript
interface MedicationContext {
  currentMedications: Medication[];
  medicationHistory: MedicationHistory[];
  adherenceData: AdherenceData[];
  interactions: KnownInteraction[];
  allergies: Allergy[];
}

// Integration with existing medication module
@Controller('agents/context')
export class AgentMedicationController {
  constructor(
    private readonly medicationService: MedicationService,
    private readonly agentContextBuilder: AgentContextBuilder
  ) {}

  @Get('medications/:userId')
  @UseGuards(FirebaseAuthGuard)
  async getMedicationContext(@Param('userId') userId: string): Promise<MedicationContext> {
    const medications = await this.medicationService.getUserMedications(userId);
    const history = await this.medicationService.getMedicationHistory(userId);
    
    return this.agentContextBuilder.buildMedicationContext({
      medications,
      history,
      userId
    });
  }
}
```

### 3.3 Care Group Integration

**Endpoint**: `GET /api/v1/agents/context/care-group/{userId}`

```typescript
interface CareGroupContext {
  careGroups: CareGroup[];
  familyMembers: CareGroupMember[];
  careRecipients: CareRecipient[];
  sharedTasks: CareTask[];
  communicationPreferences: CommunicationPreference[];
}
```

## 4. WebSocket Real-Time Communication

### 4.1 WebSocket Connection

```typescript
interface WebSocketMessage {
  type: 'agent_message' | 'user_message' | 'agent_handoff' | 'emergency_alert' | 'typing_indicator';
  conversationId: string;
  data: any;
  timestamp: Date;
  metadata?: {
    agent?: string;
    urgencyLevel?: number;
    complianceFlags?: ComplianceFlag[];
  };
}

class CareCircleAIWebSocket {
  private ws: WebSocket;
  private conversationId: string;

  constructor(conversationId: string, authToken: string) {
    this.conversationId = conversationId;
    this.ws = new WebSocket(`${WEBSOCKET_URL}?token=${authToken}&conversation=${conversationId}`);
    this.setupEventHandlers();
  }

  private setupEventHandlers() {
    this.ws.onmessage = (event) => {
      const message: WebSocketMessage = JSON.parse(event.data);
      this.handleMessage(message);
    };

    this.ws.onopen = () => {
      console.log('Connected to CareCircle AI WebSocket');
    };

    this.ws.onerror = (error) => {
      console.error('WebSocket error:', error);
    };
  }

  sendMessage(content: string, type: 'text' | 'voice' = 'text') {
    const message: WebSocketMessage = {
      type: 'user_message',
      conversationId: this.conversationId,
      data: { content, type },
      timestamp: new Date()
    };
    
    this.ws.send(JSON.stringify(message));
  }

  private handleMessage(message: WebSocketMessage) {
    switch (message.type) {
      case 'agent_message':
        this.onAgentMessage(message.data);
        break;
      case 'agent_handoff':
        this.onAgentHandoff(message.data);
        break;
      case 'emergency_alert':
        this.onEmergencyAlert(message.data);
        break;
      case 'typing_indicator':
        this.onTypingIndicator(message.data);
        break;
    }
  }
}
```

## 5. Error Handling and Status Codes

### 5.1 HTTP Status Codes

```typescript
enum AIAgentStatusCodes {
  // Success
  OK = 200,
  CREATED = 201,
  
  // Client Errors
  BAD_REQUEST = 400,
  UNAUTHORIZED = 401,
  FORBIDDEN = 403,
  NOT_FOUND = 404,
  RATE_LIMITED = 429,
  
  // Healthcare-Specific Errors
  PHI_VIOLATION = 451, // Unavailable for Legal Reasons
  EMERGENCY_ESCALATION = 452, // Custom: Emergency protocols activated
  
  // Server Errors
  INTERNAL_ERROR = 500,
  AI_SERVICE_UNAVAILABLE = 503,
  BUDGET_EXCEEDED = 507 // Insufficient Storage (repurposed for budget)
}

interface APIError {
  code: AIAgentStatusCodes;
  message: string;
  details?: any;
  complianceInfo?: {
    auditId: string;
    timestamp: Date;
    action: string;
  };
}
```

### 5.2 Error Response Format

```typescript
interface ErrorResponse {
  error: APIError;
  requestId: string;
  timestamp: Date;
  supportInfo?: {
    contactMethod: string;
    escalationRequired: boolean;
  };
}
```

## 6. Rate Limiting and Quotas

### 6.1 Rate Limits

```typescript
interface RateLimits {
  conversationsPerHour: 50;
  messagesPerMinute: 20;
  emergencyRequestsPerHour: 10; // Higher priority, separate limit
  costPerMonth: number; // Based on user tier
}

// Rate limit headers
interface RateLimitHeaders {
  'X-RateLimit-Limit': string;
  'X-RateLimit-Remaining': string;
  'X-RateLimit-Reset': string;
  'X-Cost-Limit': string;
  'X-Cost-Remaining': string;
}
```

This API specification provides a comprehensive interface for integrating CareCircle's AI agent system with the existing platform while maintaining healthcare compliance and optimal user experience.
