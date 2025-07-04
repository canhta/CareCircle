import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  UserBehaviorAnalyticsService,
  UserEngagementPattern,
} from './user-behavior-analytics.service';
import {
  NotificationService,
  NotificationPayload,
} from './notification.service';
import { NotificationTemplateService } from './notification-template.service';
import { MilvusService } from './milvus.service';
import OpenAI from 'openai';
import { ConfigService } from '@nestjs/config';

export interface AdaptiveNotificationRequest {
  userId: string;
  notificationType: string;
  medicationName?: string;
  context?: Record<string, any>;
  urgencyLevel?: 'low' | 'medium' | 'high' | 'critical';
}

export interface NotificationRecommendation {
  optimalTime: Date;
  messageContent: string;
  title: string;
  tone: string;
  channels: string[];
  reasoning: string;
  confidence: number; // 0-1
}

@Injectable()
export class AdaptiveNotificationEngineService {
  private readonly logger = new Logger(AdaptiveNotificationEngineService.name);
  private readonly openai: OpenAI;

  constructor(
    private readonly prisma: PrismaService,
    private readonly behaviorAnalytics: UserBehaviorAnalyticsService,
    private readonly notificationService: NotificationService,
    private readonly templateService: NotificationTemplateService,
    private readonly configService: ConfigService,
    private readonly milvusService: MilvusService,
  ) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('OPENAI_API_KEY'),
    });
  }

  /**
   * Generate adaptive notification recommendation using LLM
   */
  async generateNotificationRecommendation(
    request: AdaptiveNotificationRequest,
  ): Promise<NotificationRecommendation> {
    try {
      // Get user engagement pattern
      const engagementPattern =
        await this.behaviorAnalytics.getUserEngagementPattern(request.userId);

      // Get user profile and preferences
      const user = await this.prisma.user.findUnique({
        where: { id: request.userId },
        include: {
          notifications: {
            take: 10,
            orderBy: { createdAt: 'desc' },
          },
        },
      });

      if (!user) {
        throw new Error(`User not found: ${request.userId}`);
      }

      // Prepare context for LLM
      const context = this.prepareUserContext(
        user,
        engagementPattern || null,
        request,
      );

      // Generate recommendation using OpenAI
      const recommendation = await this.generateLLMRecommendation(context);

      this.logger.debug(
        `Generated adaptive notification recommendation for user ${request.userId}`,
      );

      return recommendation;
    } catch (error) {
      this.logger.error(
        `Failed to generate notification recommendation: ${error.message}`,
        error.stack,
      );

      // Fallback to default recommendation
      return this.generateFallbackRecommendation(request);
    }
  }

  /**
   * Send adaptive notification using LLM recommendations
   */
  async sendAdaptiveNotification(
    request: AdaptiveNotificationRequest,
  ): Promise<void> {
    try {
      const recommendation =
        await this.generateNotificationRecommendation(request);

      const payload: NotificationPayload = {
        userId: request.userId,
        title: recommendation.title,
        message: recommendation.messageContent,
        type: request.notificationType as any,
        channels: recommendation.channels as any[],
        priority: this.mapUrgencyToPriority(request.urgencyLevel),
        scheduledFor: recommendation.optimalTime,
        templateData: {
          ...request.context,
          tone: recommendation.tone,
          reasoning: recommendation.reasoning,
        },
      };

      await this.notificationService.scheduleNotification(payload);

      this.logger.log(
        `Sent adaptive notification to user ${request.userId} scheduled for ${recommendation.optimalTime.toISOString()}`,
      );
    } catch (error) {
      this.logger.error(
        `Failed to send adaptive notification: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  /**
   * Analyze notification effectiveness and update recommendations
   */
  async analyzeNotificationEffectiveness(userId: string): Promise<void> {
    try {
      // Get recent notifications and their engagement data
      const notifications = await this.prisma.notification.findMany({
        where: {
          userId,
          createdAt: { gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000) },
        },
        include: {
          behaviors: true,
        },
      });

      if (notifications.length < 5) {
        this.logger.debug(
          `Not enough notification data for analysis for user ${userId}`,
        );
        return;
      }

      // Prepare effectiveness data
      const effectivenessData = this.prepareEffectivenessData(notifications);

      // Use LLM to analyze effectiveness
      const analysis = await this.analyzeLLMEffectiveness(effectivenessData);

      // Store insights
      await this.storeEffectivenessInsights(userId, analysis);

      this.logger.log(`Analyzed notification effectiveness for user ${userId}`);
    } catch (error) {
      this.logger.error(
        `Failed to analyze notification effectiveness: ${error.message}`,
        error.stack,
      );
    }
  }

  /**
   * Get optimal notification time for user
   */
  async getOptimalNotificationTime(
    userId: string,
    notificationType: string,
  ): Promise<Date> {
    try {
      const engagementPattern =
        await this.behaviorAnalytics.getUserEngagementPattern(userId);

      if (!engagementPattern || !engagementPattern.preferredTimes.length) {
        // Default to 9 AM if no pattern available
        const defaultTime = new Date();
        defaultTime.setHours(9, 0, 0, 0);
        defaultTime.setDate(
          defaultTime.getDate() + (defaultTime.getHours() >= 9 ? 1 : 0),
        );
        return defaultTime;
      }

      // Get the best preferred time for today or tomorrow
      const now = new Date();
      const currentHour = now.getHours();

      // Find next optimal time
      const sortedTimes = engagementPattern.preferredTimes.sort(
        (a, b) => a - b,
      );
      const nextOptimalHour =
        sortedTimes.find((hour) => hour > currentHour) || sortedTimes[0];

      const optimalTime = new Date();
      optimalTime.setHours(nextOptimalHour, 0, 0, 0);

      // If the optimal time is in the past, schedule for tomorrow
      if (optimalTime <= now) {
        optimalTime.setDate(optimalTime.getDate() + 1);
      }

      return optimalTime;
    } catch (error) {
      this.logger.error(
        `Failed to get optimal notification time: ${error.message}`,
        error.stack,
      );

      // Fallback to default time
      const defaultTime = new Date();
      defaultTime.setHours(9, 0, 0, 0);
      return defaultTime;
    }
  }

  /**
   * Prepare user context for LLM analysis
   */
  private prepareUserContext(
    user: any,
    engagementPattern: UserEngagementPattern | null,
    request: AdaptiveNotificationRequest,
  ): string {
    const context = {
      user_profile: {
        age: user.dateOfBirth
          ? Math.floor(
              (Date.now() - new Date(user.dateOfBirth).getTime()) /
                (365.25 * 24 * 60 * 60 * 1000),
            )
          : null,
        timezone: user.timezone,
        first_name: user.firstName,
      },
      engagement_pattern: engagementPattern
        ? {
            preferred_times: engagementPattern.preferredTimes,
            response_rate: engagementPattern.responseRate,
            average_response_time: engagementPattern.averageResponseTime,
            best_notification_types: engagementPattern.bestNotificationTypes,
            worst_notification_types: engagementPattern.worstNotificationTypes,
            engagement_trend: engagementPattern.engagementTrend,
          }
        : null,
      notification_request: {
        type: request.notificationType,
        medication_name: request.medicationName,
        urgency_level: request.urgencyLevel,
        context: request.context,
      },
      current_time: new Date().toISOString(),
      recent_notifications: user.notifications.map((n: any) => ({
        type: n.type,
        sent_at: n.sentAt,
        read_at: n.readAt,
      })),
    };

    return JSON.stringify(context, null, 2);
  }

  /**
   * Generate LLM-based notification recommendation
   */
  private async generateLLMRecommendation(
    context: string,
  ): Promise<NotificationRecommendation> {
    const prompt = `
Analyze the following user context and generate an optimal notification recommendation:

${context}

Based on this data, provide a JSON response with the following structure:
{
  "optimalTime": "ISO 8601 timestamp for when to send the notification",
  "messageContent": "personalized message content",
  "title": "notification title",
  "tone": "communication tone (supportive, direct, casual, urgent)",
  "channels": ["array of recommended delivery channels: push, email, sms"],
  "reasoning": "brief explanation of why these recommendations were made",
  "confidence": number between 0-1 representing confidence in recommendations
}

Consider:
- User's historical engagement patterns and preferred times
- Notification type and urgency level
- Time zone and current time
- Recent notification history to avoid fatigue
- Personalization based on user profile
- Medication adherence context if applicable

Optimize for maximum engagement while respecting user preferences and avoiding notification fatigue.
`;

    const completion = await this.openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content:
            'You are an expert healthcare notification optimization system. Generate personalized, effective notification recommendations that maximize user engagement while respecting their preferences and avoiding notification fatigue.',
        },
        { role: 'user', content: prompt },
      ],
      temperature: 0.3,
      response_format: { type: 'json_object' },
    });

    const recommendation = JSON.parse(
      completion.choices[0].message.content || '{}',
    );

    return {
      optimalTime: new Date(recommendation.optimalTime),
      messageContent: recommendation.messageContent,
      title: recommendation.title,
      tone: recommendation.tone,
      channels: recommendation.channels,
      reasoning: recommendation.reasoning,
      confidence: recommendation.confidence,
    };
  }

  /**
   * Generate fallback recommendation when LLM fails
   */
  private generateFallbackRecommendation(
    request: AdaptiveNotificationRequest,
  ): NotificationRecommendation {
    const defaultTime = new Date();
    defaultTime.setHours(9, 0, 0, 0);

    return {
      optimalTime: defaultTime,
      messageContent: `Don't forget to take your ${request.medicationName || 'medication'}!`,
      title: '💊 Medication Reminder',
      tone: 'supportive',
      channels: ['push'],
      reasoning: 'Using fallback recommendation due to analysis failure',
      confidence: 0.5,
    };
  }

  /**
   * Map urgency level to notification priority
   */
  private mapUrgencyToPriority(urgencyLevel?: string): any {
    switch (urgencyLevel) {
      case 'critical':
        return 'CRITICAL';
      case 'high':
        return 'HIGH';
      case 'medium':
        return 'NORMAL';
      case 'low':
      default:
        return 'LOW';
    }
  }

  /**
   * Prepare effectiveness data for analysis
   */
  private prepareEffectivenessData(notifications: any[]): string {
    const data = notifications.map((notification) => ({
      id: notification.id,
      type: notification.type,
      sent_at: notification.sentAt,
      read_at: notification.readAt,
      behaviors: notification.behaviors.map((b: any) => ({
        action: b.action,
        timestamp: b.timestamp,
        time_to_action: b.timeToAction,
      })),
    }));

    return JSON.stringify(data, null, 2);
  }

  /**
   * Analyze effectiveness using LLM
   */
  private async analyzeLLMEffectiveness(data: string): Promise<any> {
    const prompt = `
Analyze the following notification effectiveness data:

${data}

Provide insights and recommendations for improving notification effectiveness in JSON format:
{
  "overall_effectiveness": number between 0-1,
  "key_insights": ["array of key insights"],
  "recommendations": ["array of specific recommendations"],
  "optimal_patterns": {
    "best_times": ["array of optimal sending times"],
    "best_types": ["most effective notification types"],
    "engagement_factors": ["factors that improve engagement"]
  }
}
`;

    const completion = await this.openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content:
            'You are an expert data analyst specializing in notification effectiveness analysis for healthcare applications.',
        },
        { role: 'user', content: prompt },
      ],
      temperature: 0.1,
      response_format: { type: 'json_object' },
    });

    return JSON.parse(completion.choices[0].message.content || '{}');
  }

  /**
   * Store effectiveness insights
   */
  private async storeEffectivenessInsights(
    userId: string,
    analysis: any,
  ): Promise<void> {
    await this.prisma.userEngagementPattern.upsert({
      where: { userId },
      update: {
        insights: JSON.stringify(analysis),
        lastAnalysisDate: new Date(),
      },
      create: {
        userId,
        preferredTimes: analysis.optimal_patterns?.best_times || [9],
        responseRate: analysis.overall_effectiveness || 0.5,
        averageResponseTime: 300000, // 5 minutes default
        bestNotificationTypes: analysis.optimal_patterns?.best_types || [],
        worstNotificationTypes: [],
        engagementTrend: 'stable',
        insights: JSON.stringify(analysis),
      },
    });
  }
}
