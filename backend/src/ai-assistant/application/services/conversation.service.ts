import { Injectable, Inject } from '@nestjs/common';
import { Conversation } from '../../domain/entities/conversation.entity';
import { Message } from '../../domain/entities/message.entity';
import { ConversationRepository } from '../../domain/repositories/conversation.repository';
import { ConversationMetadata } from '../../domain/value-objects/conversation.value-objects';
import { ConversationStatus } from '@prisma/client';
import { MessageMetadata } from '../../domain/value-objects/message.value-objects';
import { OpenAIService } from '../../infrastructure/services/openai.service';
import { HealthProfileService } from '../../../health-data/application/services/health-profile.service';
import { HealthMetricService } from '../../../health-data/application/services/health-metric.service';
import { HealthAnalyticsService } from '../../../health-data/application/services/health-analytics.service';
import { MessageRole } from '@prisma/client';

@Injectable()
export class ConversationService {
  constructor(
    @Inject('ConversationRepository')
    private readonly conversationRepository: ConversationRepository,
    private readonly openAIService: OpenAIService,
    private readonly healthProfileService: HealthProfileService,
    private readonly healthMetricService: HealthMetricService,
    private readonly healthAnalyticsService: HealthAnalyticsService,
  ) {}

  async createConversation(data: {
    userId: string;
    title?: string;
    metadata?: Partial<ConversationMetadata>;
  }): Promise<Conversation> {
    const conversation = Conversation.create({
      id: this.generateId(),
      ...data,
    });

    return this.conversationRepository.create(conversation);
  }

  async getConversationById(id: string): Promise<Conversation | null> {
    return this.conversationRepository.findById(id);
  }

  async getUserConversations(
    userId: string,
    status?: ConversationStatus,
  ): Promise<Conversation[]> {
    return this.conversationRepository.findByUserId(userId, status);
  }

  async updateConversation(
    id: string,
    updates: {
      title?: string;
      status?: ConversationStatus;
      metadata?: Partial<ConversationMetadata>;
    },
  ): Promise<Conversation> {
    const conversation = await this.conversationRepository.findById(id);
    if (!conversation) {
      throw new Error('Conversation not found');
    }

    if (updates.title) {
      conversation.updateTitle(updates.title);
    }
    if (updates.status) {
      conversation.updateStatus(updates.status);
    }
    if (updates.metadata) {
      conversation.updateMetadata(updates.metadata);
    }

    return this.conversationRepository.update(id, conversation);
  }

  async deleteConversation(id: string): Promise<void> {
    return this.conversationRepository.delete(id);
  }

  async addMessage(
    conversationId: string,
    data: {
      role: MessageRole;
      content: string;
      metadata?: Partial<MessageMetadata>;
      references?: any[];
      attachments?: any[];
    },
  ): Promise<Message> {
    const message = Message.create({
      id: this.generateId(),
      conversationId,
      ...data,
    });

    return this.conversationRepository.addMessage(conversationId, message);
  }

  async getConversationMessages(
    conversationId: string,
    limit?: number,
  ): Promise<Message[]> {
    return this.conversationRepository.getMessages(conversationId, limit);
  }

  async updateMessage(
    messageId: string,
    updates: {
      content?: string;
      metadata?: Partial<MessageMetadata>;
      references?: any[];
      attachments?: any[];
      isHidden?: boolean;
    },
  ): Promise<Message> {
    return this.conversationRepository.updateMessage(
      messageId,
      updates as Partial<Message>,
    );
  }

  async deleteMessage(messageId: string): Promise<void> {
    return this.conversationRepository.deleteMessage(messageId);
  }

  async getConversationCount(userId: string): Promise<number> {
    return this.conversationRepository.getConversationCount(userId);
  }

  async getMessageCount(conversationId: string): Promise<number> {
    return this.conversationRepository.getMessageCount(conversationId);
  }

  async archiveConversation(id: string): Promise<Conversation> {
    return this.updateConversation(id, {
      status: ConversationStatus.ARCHIVED,
    });
  }

  async restoreConversation(id: string): Promise<Conversation> {
    return this.updateConversation(id, {
      status: ConversationStatus.ACTIVE,
    });
  }

  async sendMessage(data: {
    conversationId: string;
    content: string;
    userId: string;
  }): Promise<{
    userMessage: Message;
    assistantMessage: Message;
    conversation: Conversation;
  }> {
    const startTime = Date.now();

    // Add user message
    const userMessage = Message.create({
      id: this.generateId(),
      conversationId: data.conversationId,
      role: MessageRole.user,
      content: data.content,
    });

    const savedUserMessage = await this.conversationRepository.addMessage(
      data.conversationId,
      userMessage,
    );

    try {
      // Build conversation history for OpenAI
      const conversationHistory = await this.buildConversationHistory(
        data.conversationId,
      );

      // Build health context for personalized responses
      const healthContext = await this.buildHealthContext(data.userId);

      // Generate AI response using OpenAI
      const messages: Array<{ role: MessageRole; content: string }> = [
        {
          role: MessageRole.system,
          content: this.buildSystemPrompt(healthContext),
        },
        ...conversationHistory,
        {
          role: MessageRole.user,
          content: data.content,
        },
      ];

      const aiResponse = await this.openAIService.generateResponse(messages);

      const processingTime = Date.now() - startTime;

      // Create assistant message with metadata
      const assistantMessage = Message.create({
        id: this.generateId(),
        conversationId: data.conversationId,
        role: MessageRole.assistant,
        content: aiResponse,
        metadata: {
          processingTime,
          confidence: 0.9, // TODO: Implement confidence scoring
          tokensUsed: this.estimateTokens(aiResponse),
          modelVersion: 'gpt-4',
          flagged: false,
        },
      });

      const savedAssistantMessage =
        await this.conversationRepository.addMessage(
          data.conversationId,
          assistantMessage,
        );

      // Get updated conversation
      const conversation = await this.getConversationById(data.conversationId);

      return {
        userMessage: savedUserMessage,
        assistantMessage: savedAssistantMessage,
        conversation: conversation!,
      };
    } catch (error) {
      console.error('Failed to generate AI response:', error);

      // Fallback response in case of AI service failure
      const fallbackMessage = Message.create({
        id: this.generateId(),
        conversationId: data.conversationId,
        role: MessageRole.assistant,
        content:
          "I apologize, but I'm experiencing technical difficulties right now. Please try again in a moment. If you have a medical emergency, please contact your healthcare provider or emergency services immediately.",
        metadata: {
          processingTime: Date.now() - startTime,
          confidence: 0.0,
          tokensUsed: 0,
          modelVersion: 'fallback',
          flagged: false,
        },
      });

      const savedFallbackMessage = await this.conversationRepository.addMessage(
        data.conversationId,
        fallbackMessage,
      );

      const conversation = await this.getConversationById(data.conversationId);

      return {
        userMessage: savedUserMessage,
        assistantMessage: savedFallbackMessage,
        conversation: conversation!,
      };
    }
  }

  async sendMessageStream(data: {
    conversationId: string;
    content: string;
    userId: string;
  }): Promise<
    AsyncGenerator<{
      content: string;
      isComplete: boolean;
      metadata?: {
        tokensUsed?: number;
        processingTime?: number;
        confidence?: number;
      };
    }>
  > {
    const startTime = Date.now();

    // Add user message
    const userMessage = Message.create({
      id: this.generateId(),
      conversationId: data.conversationId,
      role: MessageRole.user,
      content: data.content,
    });

    await this.conversationRepository.addMessage(
      data.conversationId,
      userMessage,
    );

    try {
      // Build conversation history for OpenAI
      const conversationHistory = await this.buildConversationHistory(
        data.conversationId,
      );

      // Build health context for personalized responses
      const healthContext = await this.buildHealthContext(data.userId);

      // Generate AI response using OpenAI streaming
      const messages: Array<{ role: MessageRole; content: string }> = [
        {
          role: MessageRole.system,
          content: this.buildSystemPrompt(healthContext),
        },
        ...conversationHistory,
        {
          role: MessageRole.user,
          content: data.content,
        },
      ];

      const streamGenerator =
        this.openAIService.generateStreamingResponse(messages);
      const fullContent = '';

      return this.createStreamGenerator(
        streamGenerator,
        data,
        fullContent,
        startTime,
      );
    } catch (error) {
      console.error('Failed to initialize streaming response:', error);

      // Return fallback generator
      return this.createFallbackGenerator(startTime);
    }
  }

  private async *createStreamGenerator(
    streamGenerator: AsyncGenerator<{
      content: string;
      isComplete: boolean;
      metadata?: {
        tokensUsed?: number;
        processingTime?: number;
        confidence?: number;
      };
    }>,
    data: { conversationId: string; userId: string; content: string },
    fullContent: string,
    startTime: number,
  ) {
    try {
      for await (const chunk of streamGenerator) {
        if (!chunk.isComplete) {
          fullContent += chunk.content;
        }

        yield {
          content: chunk.content,
          isComplete: chunk.isComplete,
          metadata: chunk.metadata,
        };

        // If streaming is complete, save the full assistant message
        if (chunk.isComplete) {
          const assistantMessage = Message.create({
            id: this.generateId(),
            conversationId: data.conversationId,
            role: MessageRole.assistant,
            content: fullContent,
            metadata: {
              processingTime: Date.now() - startTime,
              confidence: chunk.metadata?.confidence || 0.9,
              tokensUsed:
                chunk.metadata?.tokensUsed || this.estimateTokens(fullContent),
              modelVersion: 'gpt-4',
              flagged: false,
              streamingEnabled: true,
            },
          });

          await this.conversationRepository.addMessage(
            data.conversationId,
            assistantMessage,
          );
        }
      }
    } catch (error) {
      console.error('Streaming error:', error);
      // Yield error completion
      yield {
        content:
          "I apologize, but I'm experiencing technical difficulties. Please try again.",
        isComplete: true,
        metadata: {
          processingTime: Date.now() - startTime,
          confidence: 0.0,
          tokensUsed: 0,
        },
      };
    }
  }

  private async *createFallbackGenerator(startTime: number) {
    yield {
      content:
        "I apologize, but I'm experiencing technical difficulties right now. Please try again in a moment. If you have a medical emergency, please contact your healthcare provider or emergency services immediately.",
      isComplete: true,
      metadata: {
        processingTime: Date.now() - startTime,
        confidence: 0.0,
        tokensUsed: 0,
      },
    };
  }

  async getMessages(
    conversationId: string,
    limit?: number,
    beforeId?: string,
  ): Promise<Message[]> {
    return this.conversationRepository.getMessages(
      conversationId,
      limit,
      beforeId,
    );
  }

  private generateId(): string {
    return `conv_${Date.now()}_${Math.random().toString(36).substring(2, 11)}`;
  }

  /**
   * Build conversation history for OpenAI API
   */
  private async buildConversationHistory(
    conversationId: string,
  ): Promise<Array<{ role: MessageRole; content: string }>> {
    const messages = await this.conversationRepository.getMessages(
      conversationId,
      20, // Limit to last 20 messages for context
    );

    return messages
      .filter((msg) => msg.role !== MessageRole.system)
      .map((msg) => ({
        role: msg.role,
        content: msg.content,
      }))
      .reverse(); // Ensure chronological order
  }

  /**
   * Build health context for personalized AI responses
   */
  private async buildHealthContext(userId: string): Promise<string> {
    try {
      const contextParts: string[] = [];

      // 1. Health Profile Information
      try {
        const healthProfile =
          await this.healthProfileService.getProfileByUserId(userId);
        if (healthProfile) {
          contextParts.push(`HEALTH PROFILE:
- BMI: ${healthProfile.calculateBMI().toFixed(1)}
- Health Conditions: ${healthProfile.healthConditions.map((c) => c.name).join(', ') || 'None reported'}
- Allergies: ${healthProfile.allergies.map((a) => a.allergen).join(', ') || 'None reported'}
- Risk Factors: ${healthProfile.riskFactors.map((r) => r.type).join(', ') || 'None reported'}
- Active Health Goals: ${healthProfile.getActiveGoals().length} goals`);
        }
      } catch (error) {
        console.warn('Failed to fetch health profile:', error);
      }

      // 2. Recent Health Metrics
      try {
        const endDate = new Date();
        const startDate = new Date();
        startDate.setDate(endDate.getDate() - 7); // Last 7 days

        const recentMetrics = await this.healthMetricService.getMetrics({
          userId,
          startDate,
          endDate,
          limit: 10,
        });

        if (recentMetrics.length > 0) {
          const metricSummary = recentMetrics
            .map((m) => `${m.metricType}: ${m.value} ${m.unit}`)
            .join(', ');
          contextParts.push(`RECENT HEALTH METRICS (Last 7 days):
${metricSummary}`);
        }
      } catch (error) {
        console.warn('Failed to fetch recent metrics:', error);
      }

      // 3. Health Analytics and Insights
      try {
        const healthAnalytics =
          await this.healthAnalyticsService.generateHealthReport(
            userId,
            new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // 30 days ago
            new Date(),
          );

        if (healthAnalytics.insights.length > 0) {
          const insightSummary = healthAnalytics.insights
            .slice(0, 3) // Top 3 insights
            .map((i) => `${i.title}: ${i.description}`)
            .join('; ');
          contextParts.push(`HEALTH INSIGHTS:
${insightSummary}`);
        }

        if (healthAnalytics.summary.healthScore > 0) {
          contextParts.push(
            `HEALTH SCORE: ${healthAnalytics.summary.healthScore}/100`,
          );
        }
      } catch (error) {
        console.warn('Failed to fetch health analytics:', error);
      }

      // 4. Medication Context (Placeholder - will be implemented when Medication Context is available)
      contextParts.push(
        `MEDICATION CONTEXT: Integration with Medication Context pending implementation`,
      );

      // 5. Care Group Context (Placeholder - will be implemented when Care Group Context is available)
      contextParts.push(
        `CARE GROUP CONTEXT: Integration with Care Group Context pending implementation`,
      );

      // 6. Privacy and Safety Notes
      contextParts.push(`PRIVACY NOTES:
- All health data is confidential and should be handled with appropriate medical disclaimers
- Encourage professional healthcare consultation for medical decisions
- Be supportive and empathetic in responses
- Avoid making definitive medical diagnoses or treatment recommendations`);

      return contextParts.length > 0
        ? contextParts.join('\n\n')
        : `User ID: ${userId}. No health context available at this time.`;
    } catch (error) {
      console.error('Failed to build health context:', error);
      return `User ID: ${userId}. Health context temporarily unavailable due to technical issues.`;
    }
  }

  /**
   * Build system prompt with health context
   */
  private buildSystemPrompt(healthContext: string): string {
    return `You are CareCircle AI, a compassionate healthcare assistant designed to support users and their families in managing health and wellness.

CORE PRINCIPLES:
- Always prioritize user safety and well-being
- Provide empathetic, supportive responses
- Include appropriate medical disclaimers
- Encourage professional healthcare consultation when appropriate
- Respect privacy and maintain confidentiality

CAPABILITIES:
- Answer general health and wellness questions
- Provide medication reminders and information
- Offer lifestyle and wellness suggestions
- Support family caregiving coordination
- Detect potential emergencies and escalate appropriately

LIMITATIONS:
- Cannot diagnose medical conditions
- Cannot prescribe medications
- Cannot replace professional medical advice
- Cannot access real-time medical records without explicit permission

HEALTH CONTEXT:
${healthContext}

RESPONSE GUIDELINES:
- Be conversational and warm, but professional
- Use simple, clear language appropriate for all ages
- Include relevant disclaimers for medical advice
- Suggest consulting healthcare providers for serious concerns
- Offer practical, actionable suggestions when appropriate

Remember: You are a supportive companion in the user's healthcare journey, not a replacement for professional medical care.`;
  }

  /**
   * Estimate token count for content (rough approximation)
   */
  private estimateTokens(content: string): number {
    // Rough estimation: ~4 characters per token for English text
    return Math.ceil(content.length / 4);
  }
}
