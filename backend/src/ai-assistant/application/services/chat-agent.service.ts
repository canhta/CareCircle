import { Injectable, Inject, Logger } from '@nestjs/common';
import {
  HealthcareAgentOrchestratorService,
  HealthcareContext,
  AgentResponse,
} from '../../infrastructure/services/healthcare-agent-orchestrator.service';
import {
  AgentSession,
  AgentSessionType,
  AgentSessionStatus,
} from '../../domain/entities/agent-session.entity';
import {
  AgentInteraction,
  AgentType,
  AgentInteractionType,
  UrgencyLevel,
} from '../../domain/entities/agent-interaction.entity';
import { AgentSessionRepository } from '../../domain/repositories/agent-session.repository';
import { ConversationService } from './conversation.service';
import { HealthProfileService } from '../../../health-data/application/services/health-profile.service';

export interface ChatAgentRequest {
  message: string;
  sessionId?: string;
  patientContext?: HealthcareContext;
  urgencyOverride?: boolean;
  agentPreference?: string;
  streamResponse?: boolean;
}

export interface ChatAgentResponse {
  response: string;
  urgencyLevel: 'routine' | 'urgent' | 'emergency';
  agentType: string;
  recommendedActions?: string[];
  escalationTriggered: boolean;
  sessionId: string;
  interactionId: string;
  complianceFlags: string[];
  costInfo: {
    tokensUsed: number;
    estimatedCost: number;
    modelUsed: string;
  };
  metadata: {
    processingTimeMs: number;
    phiDetected: boolean;
    confidenceScore: number;
    agentsInvolved: string[];
    culturalContext: string;
    languagePreference: string;
  };
}

export interface ChatAgentStreamChunk {
  type: 'agent_start' | 'agent_response' | 'agent_complete' | 'error';
  agentType?: string;
  content?: string;
  metadata?: Record<string, any>;
}

@Injectable()
export class ChatAgentService {
  private readonly logger = new Logger(ChatAgentService.name);

  constructor(
    private readonly orchestrator: HealthcareAgentOrchestratorService,
    @Inject('AgentSessionRepository')
    private readonly agentSessionRepository: AgentSessionRepository,
    private readonly conversationService: ConversationService,
    private readonly healthProfileService: HealthProfileService,
  ) {}

  async processChat(
    userId: string,
    request: ChatAgentRequest,
  ): Promise<ChatAgentResponse> {
    const startTime = Date.now();

    try {
      this.logger.log(
        `Processing chat for user ${userId}: ${request.message.substring(0, 100)}...`,
      );

      // Get or create agent session
      const session = await this.getOrCreateSession(userId, request);

      // Enhance context with user health data
      const enhancedContext = await this.enhanceHealthcareContext(
        userId,
        request.patientContext || {},
      );

      // Process the query through the agent orchestrator
      const agentResponse = await this.orchestrator.processHealthcareQuery(
        request.message,
        enhancedContext,
      );

      // Calculate processing time and costs
      const processingTime = Date.now() - startTime;
      const costInfo = this.calculateCosts(agentResponse);

      // Create interaction record
      const interaction = await this.createInteraction(
        session.id,
        request.message,
        agentResponse,
        processingTime,
        costInfo,
      );

      // Update session metadata
      await this.updateSessionMetadata(session, agentResponse, interaction);

      // Check for escalation needs
      const escalationTriggered = await this.checkEscalation(
        session,
        agentResponse,
      );

      // Create conversation record for compatibility
      await this.createConversationRecord(
        userId,
        request.message,
        agentResponse.response,
      );

      // Build response
      const response: ChatAgentResponse = {
        response: agentResponse.response,
        urgencyLevel: this.mapUrgencyLevel(agentResponse.metadata.urgencyLevel),
        agentType: agentResponse.agentType,
        recommendedActions: this.generateRecommendedActions(agentResponse),
        escalationTriggered,
        sessionId: session.id,
        interactionId: interaction.id,
        complianceFlags: agentResponse.metadata.complianceFlags || [],
        costInfo,
        metadata: {
          processingTimeMs: processingTime,
          phiDetected: agentResponse.metadata.complianceFlags?.length > 0,
          confidenceScore: agentResponse.confidence,
          agentsInvolved: agentResponse.metadata.agentsInvolved || [
            agentResponse.agentType,
          ],
          culturalContext: session.metadata.culturalContext,
          languagePreference: session.metadata.languagePreference,
        },
      };

      this.logger.log(
        `Chat processed successfully for user ${userId}, agent: ${agentResponse.agentType}`,
      );
      return response;
    } catch (error) {
      this.logger.error(`Error processing chat for user ${userId}:`, error);
      throw new Error('Failed to process chat request');
    }
  }

  async *streamChat(
    userId: string,
    request: ChatAgentRequest,
  ): AsyncGenerator<ChatAgentStreamChunk, void, unknown> {
    try {
      yield {
        type: 'agent_start',
        metadata: { userId, timestamp: new Date() },
      };

      // Get or create session
      const session = await this.getOrCreateSession(userId, request);

      // Enhance context
      const enhancedContext = await this.enhanceHealthcareContext(
        userId,
        request.patientContext || {},
      );

      yield {
        type: 'agent_response',
        agentType: 'supervisor',
        content: 'Analyzing your healthcare query...',
      };

      // Process through orchestrator
      const agentResponse = await this.orchestrator.processHealthcareQuery(
        request.message,
        enhancedContext,
      );

      yield {
        type: 'agent_response',
        agentType: agentResponse.agentType,
        content: agentResponse.response,
        metadata: {
          confidence: agentResponse.confidence,
          urgencyLevel: agentResponse.metadata.urgencyLevel,
        },
      };

      // Create interaction record
      const interaction = await this.createInteraction(
        session.id,
        request.message,
        agentResponse,
        Date.now(),
        this.calculateCosts(agentResponse),
      );

      yield {
        type: 'agent_complete',
        metadata: {
          sessionId: session.id,
          interactionId: interaction.id,
          agentType: agentResponse.agentType,
        },
      };
    } catch (error) {
      this.logger.error(`Error streaming chat for user ${userId}:`, error);
      yield {
        type: 'error',
        content: 'An error occurred while processing your request.',
        metadata: { error: error.message },
      };
    }
  }

  async getSessionHistory(
    userId: string,
    sessionId: string,
    limit: number = 50,
  ): Promise<{
    session: AgentSession;
    interactions: AgentInteraction[];
    summary: {
      totalInteractions: number;
      agentsUsed: string[];
      totalCost: number;
      averageConfidence: number;
    };
  }> {
    const session = await this.agentSessionRepository.findById(sessionId);
    if (!session || session.userId !== userId) {
      throw new Error('Session not found or access denied');
    }

    const interactionsResult =
      await this.agentSessionRepository.getSessionInteractions(sessionId, {
        page: 1,
        limit,
      });

    const summary = {
      totalInteractions: interactionsResult.total,
      agentsUsed: [...new Set(interactionsResult.data.map((i) => i.agentType))],
      totalCost: interactionsResult.data.reduce(
        (sum, i) => sum + i.metadata.costUsd,
        0,
      ),
      averageConfidence:
        interactionsResult.data.reduce(
          (sum, i) => sum + i.metadata.confidence,
          0,
        ) / interactionsResult.data.length,
    };

    return {
      session,
      interactions: interactionsResult.data,
      summary,
    };
  }

  async getUserSessions(
    userId: string,
    filters?: {
      sessionType?: AgentSessionType;
      status?: AgentSessionStatus;
      timeRange?: { start: Date; end: Date };
    },
  ): Promise<AgentSession[]> {
    const result = await this.agentSessionRepository.findByUserId(
      userId,
      filters,
    );
    return result.data;
  }

  private async getOrCreateSession(
    userId: string,
    request: ChatAgentRequest,
  ): Promise<AgentSession> {
    if (request.sessionId) {
      const existingSession = await this.agentSessionRepository.findById(
        request.sessionId,
      );
      if (
        existingSession &&
        existingSession.userId === userId &&
        existingSession.isActive()
      ) {
        return existingSession;
      }
    }

    // Create new session
    const sessionType = this.determineSessionType(request);
    const session = AgentSession.create({
      id: this.generateId(),
      userId,
      patientId: request.patientContext?.patientId,
      sessionType,
      healthcareContext: request.patientContext || {},
    });

    return await this.agentSessionRepository.create(session);
  }

  private async enhanceHealthcareContext(
    userId: string,
    baseContext: HealthcareContext,
  ): Promise<HealthcareContext> {
    try {
      // Get user's health profile
      const healthProfile =
        await this.healthProfileService.getProfileByUserId(userId);

      return {
        ...baseContext,
        medicalHistory:
          baseContext.medicalHistory ||
          healthProfile?.healthConditions?.map((c) => c.name) ||
          [],
        currentMedications:
          baseContext.currentMedications ||
          healthProfile?.healthConditions?.flatMap(
            (c) => c.medications || [],
          ) ||
          [],
        allergies:
          baseContext.allergies ||
          healthProfile?.allergies?.map((a) => a.allergen) ||
          [],
        vitalSigns: {
          bloodPressure: healthProfile?.baselineMetrics?.bloodPressure
            ? `${healthProfile.baselineMetrics.bloodPressure.systolic}/${healthProfile.baselineMetrics.bloodPressure.diastolic}`
            : baseContext.vitalSigns?.bloodPressure,
          heartRate:
            healthProfile?.baselineMetrics?.restingHeartRate ||
            baseContext.vitalSigns?.heartRate,
          temperature: baseContext.vitalSigns?.temperature,
        },
      };
    } catch (error) {
      this.logger.warn(
        `Could not enhance healthcare context for user ${userId}:`,
        error,
      );
      return baseContext;
    }
  }

  private async createInteraction(
    sessionId: string,
    userQuery: string,
    agentResponse: AgentResponse,
    processingTime: number,
    costInfo: any,
  ): Promise<AgentInteraction> {
    const interaction = AgentInteraction.create({
      id: this.generateId(),
      sessionId,
      agentType: this.mapAgentType(agentResponse.agentType),
      interactionType: AgentInteractionType.QUERY,
      userQuery,
      agentResponse: agentResponse.response,
      urgencyLevel: this.mapUrgencyLevelToEnum(
        agentResponse.metadata.urgencyLevel,
      ),
      metadata: {
        processingTimeMs: processingTime,
        modelUsed: 'gpt-4',
        tokensConsumed: costInfo.tokensUsed,
        costUsd: costInfo.estimatedCost,
        confidence: agentResponse.confidence,
        phiDetected: agentResponse.metadata.complianceFlags?.length > 0,
        phiMaskedFields: agentResponse.metadata.complianceFlags || [],
        complianceScore:
          agentResponse.metadata.complianceFlags?.length > 0 ? 0.8 : 1.0,
        medicalEntities: [],
        clinicalFlags: [],
        medicationMentioned: agentResponse.agentType === 'medication',
        symptomsMentioned: this.detectSymptoms(userQuery),
        emergencyKeywords: this.detectEmergencyKeywords(userQuery),
        vietnameseTermsDetected: this.detectVietnameseTerms(userQuery),
        traditionalMedicineReferences:
          this.detectTraditionalMedicine(userQuery),
      },
    });

    return await this.agentSessionRepository.addInteraction(
      sessionId,
      interaction,
    );
  }

  private async updateSessionMetadata(
    session: AgentSession,
    agentResponse: AgentResponse,
    interaction: AgentInteraction,
  ): Promise<void> {
    session.addAgent(agentResponse.agentType);
    session.addProcessingTime(interaction.metadata.processingTimeMs);
    session.addTokensUsed(interaction.metadata.tokensConsumed);
    session.updateConfidence(agentResponse.confidence);

    if (agentResponse.metadata.complianceFlags?.length > 0) {
      agentResponse.metadata.complianceFlags.forEach((flag: string) => {
        session.addComplianceFlag(flag);
      });
    }

    await this.agentSessionRepository.update(session.id, session);
  }

  private async checkEscalation(
    session: AgentSession,
    agentResponse: AgentResponse,
  ): Promise<boolean> {
    if (
      agentResponse.requiresEscalation ||
      agentResponse.metadata.urgencyLevel > 0.8
    ) {
      session.triggerEscalation();
      await this.agentSessionRepository.update(session.id, session);
      return true;
    }
    return false;
  }

  private async createConversationRecord(
    userId: string,
    userMessage: string,
    _assistantResponse: string,
  ): Promise<void> {
    try {
      // Create conversation for compatibility with existing system
      const conversation = await this.conversationService.createConversation({
        userId,
        title: 'AI Agent Chat',
        metadata: { source: 'chat-agent' },
      });

      await this.conversationService.sendMessage({
        conversationId: conversation.id,
        content: userMessage,
        userId,
      });
    } catch (error) {
      this.logger.warn('Failed to create conversation record:', error);
    }
  }

  // Helper methods
  private determineSessionType(request: ChatAgentRequest): AgentSessionType {
    if (request.agentPreference === 'emergency')
      return AgentSessionType.EMERGENCY;
    if (request.agentPreference === 'medication')
      return AgentSessionType.MEDICATION;
    if (this.detectVietnameseTerms(request.message).length > 0) {
      return AgentSessionType.VIETNAMESE_HEALTHCARE;
    }
    return AgentSessionType.CONSULTATION;
  }

  private mapAgentType(agentType: string): AgentType {
    const mapping: Record<string, AgentType> = {
      supervisor: AgentType.SUPERVISOR,
      medication: AgentType.MEDICATION,
      emergency: AgentType.EMERGENCY,
      clinical: AgentType.CLINICAL,
      vietnamese_medical: AgentType.VIETNAMESE_MEDICAL,
    };
    return mapping[agentType] || AgentType.SUPERVISOR;
  }

  private mapUrgencyLevel(level: number): 'routine' | 'urgent' | 'emergency' {
    if (level >= 0.8) return 'emergency';
    if (level >= 0.5) return 'urgent';
    return 'routine';
  }

  private mapUrgencyLevelToEnum(level: number): UrgencyLevel {
    if (level >= 0.8) return UrgencyLevel.EMERGENCY;
    if (level >= 0.5) return UrgencyLevel.URGENT;
    return UrgencyLevel.ROUTINE;
  }

  private calculateCosts(agentResponse: AgentResponse): {
    tokensUsed: number;
    estimatedCost: number;
    modelUsed: string;
  } {
    const tokensUsed = this.estimateTokens(agentResponse.response);
    const costPerToken = 0.00003; // GPT-4 pricing estimate

    return {
      tokensUsed,
      estimatedCost: tokensUsed * costPerToken,
      modelUsed: 'gpt-4',
    };
  }

  private estimateTokens(text: string): number {
    // Rough estimation: ~4 characters per token
    return Math.ceil(text.length / 4);
  }

  private generateRecommendedActions(agentResponse: AgentResponse): string[] {
    const actions: string[] = [];

    if (agentResponse.requiresEscalation) {
      actions.push('Seek immediate medical attention');
    }

    if (agentResponse.agentType === 'medication') {
      actions.push('Consult with your pharmacist or healthcare provider');
    }

    if (agentResponse.agentType === 'vietnamese_medical') {
      actions.push('Consider traditional medicine consultation');
    }

    return actions;
  }

  private detectSymptoms(text: string): boolean {
    const symptomKeywords = [
      'pain',
      'fever',
      'headache',
      'nausea',
      'fatigue',
      'cough',
    ];
    return symptomKeywords.some((keyword) =>
      text.toLowerCase().includes(keyword),
    );
  }

  private detectEmergencyKeywords(text: string): string[] {
    const emergencyKeywords = [
      'chest pain',
      'difficulty breathing',
      'severe bleeding',
      'unconscious',
      'stroke',
      'heart attack',
      'allergic reaction',
      'overdose',
    ];
    return emergencyKeywords.filter((keyword) =>
      text.toLowerCase().includes(keyword),
    );
  }

  private detectVietnameseTerms(text: string): string[] {
    // Simple Vietnamese detection - in production, use proper NLP
    const vietnamesePattern =
      /[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]/i;
    return vietnamesePattern.test(text) ? ['vietnamese_text_detected'] : [];
  }

  private detectTraditionalMedicine(text: string): string[] {
    const traditionalTerms = [
      'thuốc nam',
      'đông y',
      'thảo dược',
      'y học cổ truyền',
    ];
    return traditionalTerms.filter((term) => text.toLowerCase().includes(term));
  }

  private generateId(): string {
    return `agent_${Date.now()}_${Math.random().toString(36).substring(2, 11)}`;
  }
}
