# AI Assistant Context (AAC)

## Module Overview

The AI Assistant Context is responsible for providing intelligent health-related interactions, personalized insights, and conversational interfaces powered by advanced AI models. This context leverages user health data to deliver contextually relevant guidance while maintaining privacy and medical accuracy.

### Responsibilities

- Conversational health assistant functionality
- Personalized health insights generation
- Natural language processing of health queries
- Voice interaction processing
- Health knowledge base management
- Context-aware response generation
- Privacy-preserving AI processing
- Medical accuracy validation

### Role in Overall Architecture

The AI Assistant Context serves as the intelligent layer of the CareCircle platform, providing an intuitive interface for users to interact with their health data. It consumes information from multiple other contexts to build a comprehensive understanding of the user's health situation and deliver personalized guidance. This context enhances the user experience by making complex health information more accessible and actionable.

## Technical Specification

### Key Data Models and Interfaces

#### Domain Entities

1. **Conversation**

   ```typescript
   interface Conversation {
     id: string;
     userId: string;
     title: string;
     createdAt: Date;
     updatedAt: Date;
     messages: Message[];
     metadata: ConversationMetadata;
     status: ConversationStatus;
   }
   ```

2. **Message**

   ```typescript
   interface Message {
     id: string;
     conversationId: string;
     role: MessageRole;
     content: string;
     timestamp: Date;
     metadata: MessageMetadata;
     references?: Reference[];
     attachments?: Attachment[];
     isHidden: boolean;
   }
   ```

3. **HealthInsight**

   ```typescript
   interface HealthInsight {
     id: string;
     userId: string;
     type: InsightType;
     title: string;
     description: string;
     relatedMetrics: string[];
     severity: InsightSeverity;
     recommendations: string[];
     generatedAt: Date;
     expiresAt: Date;
     isAcknowledged: boolean;
     confidence: number;
     sourceData: any;
   }
   ```

4. **KnowledgeItem**

   ```typescript
   interface KnowledgeItem {
     id: string;
     topic: string;
     content: string;
     tags: string[];
     sources: Source[];
     lastVerified: Date;
     verificationLevel: VerificationLevel;
     relevanceScore: number;
   }
   ```

5. **UserQuery**
   ```typescript
   interface UserQuery {
     id: string;
     userId: string;
     originalText: string;
     normalizedText: string;
     detectedIntent: QueryIntent;
     entities: Entity[];
     timestamp: Date;
     conversationId?: string;
     responseId?: string;
   }
   ```

#### Value Objects

```typescript
enum MessageRole {
  USER = "user",
  ASSISTANT = "assistant",
  SYSTEM = "system",
}

enum ConversationStatus {
  ACTIVE = "active",
  COMPLETED = "completed",
  ARCHIVED = "archived",
}

enum InsightType {
  TREND = "trend",
  ANOMALY = "anomaly",
  CORRELATION = "correlation",
  RECOMMENDATION = "recommendation",
  REMINDER = "reminder",
  EDUCATIONAL = "educational",
}

enum InsightSeverity {
  INFORMATIONAL = "informational",
  LOW = "low",
  MEDIUM = "medium",
  HIGH = "high",
  CRITICAL = "critical",
}

enum VerificationLevel {
  UNVERIFIED = "unverified",
  ALGORITHM_VERIFIED = "algorithm_verified",
  EXPERT_REVIEWED = "expert_reviewed",
  CLINICALLY_VALIDATED = "clinically_validated",
}

enum QueryIntent {
  GENERAL_QUESTION = "general_question",
  SYMPTOM_INQUIRY = "symptom_inquiry",
  MEDICATION_QUESTION = "medication_question",
  DATA_REQUEST = "data_request",
  ACTION_REQUEST = "action_request",
  CLARIFICATION = "clarification",
  EMERGENCY = "emergency",
  SMALL_TALK = "small_talk",
}

interface ConversationMetadata {
  healthContextIncluded: boolean;
  medicationContextIncluded: boolean;
  userPreferences: {
    language: string;
    responseLength: "concise" | "detailed";
    technicalLevel: "simple" | "moderate" | "technical";
  };
  aiModelUsed: string;
  tokensUsed: number;
}

interface MessageMetadata {
  processingTime: number;
  confidence: number;
  tokensUsed: number;
  modelVersion: string;
  flagged: boolean;
  flagReason?: string;
}

interface Reference {
  type: "medical_literature" | "user_data" | "health_guideline";
  title: string;
  description: string;
  url?: string;
  confidence: number;
}

interface Attachment {
  type: "image" | "document" | "audio" | "chart";
  url: string;
  contentType: string;
  size: number;
  metadata: any;
}

interface Source {
  name: string;
  url?: string;
  publicationDate?: Date;
  authorityLevel: "peer_reviewed" | "medical_authority" | "general";
}

interface Entity {
  type: "medication" | "symptom" | "condition" | "metric" | "time" | "person";
  value: string;
  startPosition: number;
  endPosition: number;
  confidence: number;
}
```

### Key APIs

#### Conversation API

```typescript
interface ConversationService {
  // Conversation management
  createConversation(
    userId: string,
    initialMessage?: string,
    metadata?: Partial<ConversationMetadata>,
  ): Promise<Conversation>;
  getConversation(conversationId: string): Promise<Conversation>;
  getUserConversations(
    userId: string,
    status?: ConversationStatus,
  ): Promise<Conversation[]>;
  updateConversationStatus(
    conversationId: string,
    status: ConversationStatus,
  ): Promise<void>;
  deleteConversation(conversationId: string): Promise<void>;

  // Message interactions
  sendMessage(
    conversationId: string,
    message: string,
    attachments?: Attachment[],
  ): Promise<Message>;
  getMessages(
    conversationId: string,
    limit?: number,
    beforeId?: string,
  ): Promise<Message[]>;

  // Voice interaction
  processVoiceInput(conversationId: string, audioData: Blob): Promise<Message>;
  generateVoiceResponse(messageId: string): Promise<Blob>;

  // Context management
  includeHealthContext(
    conversationId: string,
    includeHealth: boolean,
  ): Promise<void>;
  includeMedicationContext(
    conversationId: string,
    includeMedication: boolean,
  ): Promise<void>;
  setUserPreferences(
    conversationId: string,
    preferences: Partial<ConversationMetadata["userPreferences"]>,
  ): Promise<void>;
}
```

#### Health Insights API

```typescript
interface HealthInsightsService {
  // Insights generation
  generateHealthInsights(userId: string): Promise<HealthInsight[]>;
  getInsightsForUser(
    userId: string,
    type?: InsightType,
  ): Promise<HealthInsight[]>;
  getInsightById(insightId: string): Promise<HealthInsight>;
  acknowledgeInsight(insightId: string): Promise<void>;
  dismissInsight(insightId: string): Promise<void>;

  // Personalization
  setInsightPreferences(
    userId: string,
    preferences: InsightPreferences,
  ): Promise<void>;
  getInsightPreferences(userId: string): Promise<InsightPreferences>;

  // Insight delivery
  scheduleInsightGeneration(
    userId: string,
    frequency: "daily" | "weekly",
  ): Promise<void>;
  deliverInsightNotification(insightId: string): Promise<void>;
}
```

#### Knowledge Management API

```typescript
interface KnowledgeService {
  // Knowledge base
  addKnowledgeItem(item: Omit<KnowledgeItem, "id">): Promise<KnowledgeItem>;
  getKnowledgeItem(itemId: string): Promise<KnowledgeItem>;
  searchKnowledge(query: string): Promise<KnowledgeItem[]>;
  updateKnowledgeItem(
    itemId: string,
    updates: Partial<KnowledgeItem>,
  ): Promise<KnowledgeItem>;

  // Vector search
  findSimilarKnowledge(
    text: string,
    threshold?: number,
  ): Promise<KnowledgeItem[]>;
  getRelatedKnowledge(topics: string[]): Promise<KnowledgeItem[]>;

  // Verification
  verifyKnowledgeItem(
    itemId: string,
    level: VerificationLevel,
    verifierInfo: any,
  ): Promise<KnowledgeItem>;
}
```

#### NLP Processing API

```typescript
interface NlpService {
  // Query analysis
  analyzeQuery(text: string, userId: string): Promise<UserQuery>;
  detectIntent(text: string): Promise<QueryIntent>;
  extractEntities(text: string): Promise<Entity[]>;

  // Response generation
  generateResponse(
    query: UserQuery,
    includeHealthContext: boolean,
  ): Promise<string>;
  validateResponseAccuracy(response: string): Promise<ValidationResult>;

  // Context management
  buildUserContext(userId: string): Promise<UserContext>;
  estimateQueryUrgency(text: string): Promise<number>; // 0-1 scale
}
```

### Dependencies and Interactions

- **OpenAI API**: Core dependency for LLM capabilities
- **Identity & Access Context**: For user authentication and permission verification
- **Health Data Context**: Provides health metrics and profile for personalization
- **Medication Context**: Supplies medication data for contextualized responses
- **Care Group Context**: Enables awareness of care relationships
- **Notification Context**: For delivering insights and follow-ups
- **Milvus/Qdrant**: Vector database for semantic search functionality
- **Text-to-Speech Services**: For voice response generation
- **Speech-to-Text Services**: For voice input processing

### Backend Implementation Notes

1. **LLM Integration Architecture**
   - Implement a secure OpenAI API client with retry and fallback mechanisms
   - Create context management service for constructing optimal prompts
   - Develop caching strategies to minimize API calls and costs
   - Implement streaming responses for better user experience

2. **Context Construction**
   - Create a health context builder that prioritizes relevant metrics
   - Develop a privacy-preserving context filter to remove unnecessary PHI
   - Implement context summarization to stay within token limits
   - Design conversational memory management with forgetting strategies

3. **Response Validation**
   - Create a medical accuracy validator that checks responses against knowledge base
   - Implement content filtering for potential harmful suggestions
   - Develop disclaimer injection for appropriate medical guidance
   - Build citation system for verifiable information

4. **Insight Generation**
   - Implement scheduled batch processing for insights
   - Create metric correlation detection algorithms
   - Design notification priority system based on insight severity
   - Develop feedback loop to improve insight quality

5. **Voice Processing Pipeline**
   - Implement audio preprocessing for noise reduction
   - Create voice recognition service with dialect support
   - Develop text-to-speech service with natural intonation
   - Design voice biometric recognition for enhanced security

### Mobile Implementation Notes

1. **Conversational UI**
   - Design a chat interface with message threading
   - Implement typing indicators and loading states
   - Create rich message formatting for health insights
   - Develop message grouping for related information

2. **Voice Interaction**
   - Implement voice recording with audio quality optimization
   - Create voice activation triggers
   - Design accessibility-focused voice controls
   - Implement offline voice command recognition

3. **Insight Presentation**
   - Design insight cards with actionable information
   - Create interactive visualizations for health correlations
   - Implement priority indicators for critical insights
   - Develop swipe gestures for insight management

4. **Offline Capabilities**
   - Create offline response caching for common queries
   - Implement query queueing for offline periods
   - Design sync mechanisms for conversation history
   - Develop local NLP processing for basic offline functionality

## To-do Checklist

### Backend Tasks

- [ ] BE: Design conversation and knowledge domain models
- [ ] BE: Set up OpenAI API integration with secure credential management
- [ ] BE: Create prompt engineering service with templating system
- [ ] BE: Implement context management for health data inclusion
- [ ] BE: Build health knowledge base with medical validation
- [ ] BE: Develop vector storage for semantic search capabilities
- [ ] BE: Implement personalized response generation logic
- [ ] BE: Create conversation history management with privacy controls
- [ ] BE: Develop voice-to-text and text-to-speech processing services
- [ ] BE: Implement health insights generation algorithms
- [ ] BE: Create conversation analytics and improvement system
- [ ] BE: Build secure PHI handling for AI contexts
- [ ] BE: Implement cost optimization strategies for API usage
- [ ] BE: Develop fallback mechanisms for API failures
- [ ] BE: Create comprehensive logging for AI interactions

### Mobile Tasks

- [ ] Mobile: Design and implement conversational UI with chat interface
- [ ] Mobile: Create message bubble components with support for rich content
- [ ] Mobile: Implement voice interaction system with recording and playback
- [ ] Mobile: Build contextual suggestion UI for common queries
- [ ] Mobile: Develop health insight cards with actionable controls
- [ ] Mobile: Implement conversation history management
- [ ] Mobile: Create voice activation features with wake word detection
- [ ] Mobile: Build accessibility features for assistant interactions
- [ ] Mobile: Develop offline capabilities with cached responses
- [ ] Mobile: Implement typing indicators and loading states
- [ ] Mobile: Create feedback mechanisms for response quality
- [ ] Mobile: Build emergency detection with escalation
- [ ] Mobile: Develop personalization settings for assistant behavior
- [ ] Mobile: Implement multi-language support for conversations
- [ ] Mobile: Create onboarding for AI capabilities and limitations

## References

### Libraries and Services

- **OpenAI API**: Core AI capabilities for conversational interfaces
  - Documentation: [OpenAI API](https://platform.openai.com/docs/api-reference)
  - Features: GPT models, embedding generation, fine-tuning

- **Milvus**: Open-source vector database for semantic search
  - Documentation: [Milvus Documentation](https://milvus.io/docs)
  - Features: High-performance similarity search, scalable vector indexing

- **NestJS OpenAI**: NestJS integration for OpenAI
  - Package: [@nestjs/openai](https://www.npmjs.com/package/@nestjs/openai)
  - Features: Injectable OpenAI service, configuration, request management

- **Flutter Chat UI**: UI components for chat interfaces
  - Package: [flutter_chat_ui](https://pub.dev/packages/flutter_chat_ui)
  - Features: Message bubbles, typing indicators, message lists

- **Google Speech-to-Text**: Cloud speech recognition service
  - Documentation: [Google Speech-to-Text](https://cloud.google.com/speech-to-text)
  - Features: Multi-language support, punctuation, speaker diarization

- **Azure Text-to-Speech**: Natural voice synthesis service
  - Documentation: [Azure Text-to-Speech](https://azure.microsoft.com/en-us/services/cognitive-services/text-to-speech/)
  - Features: Neural voices, SSML support, customization

### Standards and Best Practices

- **OWASP AI Security Principles**
  - Documentation: [OWASP AI Security](https://owasp.org/www-project-ai-security-and-privacy-guide/)
  - Focus areas: Data protection, model security, output validation

- **IEEE 7000-2021**: Addressing ethical concerns in system design
  - Standard for incorporating ethical considerations in system design
  - Guidelines for responsible AI development

- **HL7 FHIR**: Healthcare data interoperability
  - Standard for healthcare information exchange
  - Structured approach to medical data representation

## Logging Specifications

### AI Assistant Context Logging

The AI Assistant bounded context implements comprehensive logging for conversation management, voice interactions, and emergency detection while maintaining strict healthcare privacy compliance.

**Logger Instance**: `BoundedContextLoggers.aiAssistant`

**Log Categories**:

- **Conversation Management**: Message sending, receiving, and processing
- **Voice Interactions**: Speech-to-text and text-to-speech operations
- **Emergency Detection**: Critical health event identification and escalation
- **Context Integration**: Health data context retrieval and processing
- **Performance Monitoring**: Response times and system resource usage

**Privacy Protection**:

- All user messages are sanitized before logging
- Health context data is anonymized with user IDs hashed
- Voice audio data is never logged, only metadata
- Emergency keywords are logged for compliance but user content is redacted

**Critical Logging Points**:

1. **Message Processing**: Log message initiation, processing time, and completion
2. **Emergency Detection**: Log emergency keyword detection and escalation actions
3. **Voice Operations**: Log speech recognition accuracy and TTS generation
4. **API Interactions**: Log backend communication and response handling
5. **Error Handling**: Comprehensive error logging with context preservation

**Example Implementation**:

```dart
class AiAssistantService {
  static final _logger = BoundedContextLoggers.aiAssistant;

  Future<AiResponse> sendMessage(String message) async {
    _logger.i('AI message processing initiated', extra: {
      'messageLength': message.length,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      final sanitizedMessage = LogSanitizer.sanitizeUserMessage(message);
      final response = await _processMessage(message);

      _logger.i('AI response generated successfully', extra: {
        'responseLength': response.message.length,
        'processingTimeMs': response.processingTime,
        'emergencyDetected': response.isEmergency,
      });

      return response;
    } catch (e) {
      _logger.e('AI message processing failed', error: e, extra: {
        'errorType': e.runtimeType.toString(),
        'messageLength': message.length,
      });
      rethrow;
    }
  }
}
```

**Compliance Requirements**:

- All health-related conversations must be logged for audit purposes
- Emergency detection events require immediate audit trail creation
- Voice interaction metadata must be retained for quality assurance
- Performance metrics must be tracked for system optimization
