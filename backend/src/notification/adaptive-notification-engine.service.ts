import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  UserBehaviorAnalyticsService,
  UserEngagementPattern,
} from './user-behavior-analytics.service';
import { NotificationService } from './notification.service';
import { NotificationTemplateService } from './notification-template.service';
import { NotificationBehaviorService } from './notification-behavior.service';
import { OpenAIService } from '../ai/openai.service';
import { ConfigService } from '@nestjs/config';
import {
  AdaptiveNotificationRequest,
  NotificationRecommendation,
  NotificationPriorityLevel,
  NotificationEffectivenessAnalysis,
  UserNotificationContext,
  NotificationSummary,
  NotificationPayload,
} from '../common/interfaces/notification.interfaces';
import { Notification, NotificationPriority, User } from '@prisma/client';

// Extended User type with notifications for internal use
interface UserWithNotifications extends User {
  notifications: Notification[];
}

@Injectable()
export class AdaptiveNotificationEngineService {
  private readonly logger = new Logger(AdaptiveNotificationEngineService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly behaviorAnalytics: UserBehaviorAnalyticsService,
    private readonly notificationService: NotificationService,
    private readonly templateService: NotificationTemplateService,
    private readonly configService: ConfigService,
    private readonly notificationBehaviorService: NotificationBehaviorService,
    private readonly openaiService: OpenAIService,
  ) {}

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
        user as UserWithNotifications,
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
        type: request.notificationType as any, // Temporary cast until we update schema
        channels: recommendation.channels as any[], // Temporary cast until we update schema
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
   * Prepare user context for LLM recommendation
   */
  private prepareUserContext(
    user: UserWithNotifications,
    engagementPattern: UserEngagementPattern | null,
    request: AdaptiveNotificationRequest,
  ): UserNotificationContext {
    // Format recent notifications for context
    const recentNotifications: NotificationSummary[] = user.notifications.map(
      (notification) => ({
        id: notification.id,
        type: notification.type,
        sent_at: notification.sentAt || notification.createdAt,
        read_at: notification.readAt,
        title: notification.title,
        message: notification.message,
      }),
    );

    return {
      userId: user.id,
      name: `${user.firstName || ''} ${user.lastName || ''}`.trim(),
      age: user.dateOfBirth
        ? Math.floor(
            (new Date().getTime() - user.dateOfBirth.getTime()) /
              (365.25 * 24 * 60 * 60 * 1000),
          )
        : undefined,
      preferences: {
        language: user.timezone?.split('/')[1] || 'en', // Using timezone region as a fallback for language
        timezone: user.timezone || 'UTC',
        notificationPreferences: {}, // Empty object since not in schema
      },
      recent_notifications: recentNotifications,
      engagement_pattern: engagementPattern
        ? {
            preferred_times: engagementPattern.preferredTimes,
            response_rate: engagementPattern.responseRate,
            average_response_time: engagementPattern.averageResponseTime,
            best_notification_types: engagementPattern.bestNotificationTypes,
          }
        : undefined,
      notification_request: {
        type: request.notificationType,
        urgency: request.urgencyLevel || 'medium',
        medication_name: request.medicationName,
        context: request.context,
      },
    };
  }

  /**
   * Generate notification recommendation using LLM
   */
  private async generateLLMRecommendation(
    context: UserNotificationContext,
  ): Promise<NotificationRecommendation> {
    const prompt = `
You are an adaptive notification system for a healthcare app that helps patients manage their medications and health.

USER CONTEXT:
${JSON.stringify(context, null, 2)}

Based on this context, generate a personalized notification recommendation in the following JSON format:

{
  "optimalTime": "ISO date string for the best time to send this notification",
  "messageContent": "The message content that will resonate with this user",
  "title": "A brief, engaging title",
  "tone": "warm/urgent/informative/encouraging",
  "channels": ["app", "sms", "email"],
  "reasoning": "Explanation of why this recommendation was made",
  "confidence": 0.95
}

Consider:
1. User's engagement patterns and preferred times
2. Type and urgency of the notification
3. User's past response behavior
4. Best tone and approach based on notification type
5. Appropriate channels based on urgency and content
`;

    const completion = await this.openaiService.createCompletion(prompt, {
      model: 'gpt-4o-mini',
      temperature: 0.2,
    });

    const recommendation = JSON.parse(completion || '{}');

    // Ensure optimal time is a Date object
    if (
      recommendation.optimalTime &&
      typeof recommendation.optimalTime === 'string'
    ) {
      recommendation.optimalTime = new Date(recommendation.optimalTime);
    }

    return recommendation as NotificationRecommendation;
  }

  /**
   * Generate fallback recommendation when LLM fails
   */
  private generateFallbackRecommendation(
    request: AdaptiveNotificationRequest,
  ): NotificationRecommendation {
    // Set a default time at 9 AM tomorrow
    const optimalTime = new Date();
    optimalTime.setHours(9, 0, 0, 0);
    optimalTime.setDate(optimalTime.getDate() + 1);

    // Default message content based on notification type
    let title = 'Important Health Notification';
    let messageContent =
      'Please check your healthcare app for an important update.';

    if (
      request.notificationType === 'medication_reminder' &&
      request.medicationName
    ) {
      title = 'Medication Reminder';
      messageContent = `Time to take your ${request.medicationName}. Don't forget!`;
    } else if (request.notificationType === 'health_check') {
      title = 'Daily Health Check';
      messageContent = 'Please complete your daily health check-in.';
    }

    // Default channels based on urgency
    const channels =
      request.urgencyLevel === 'critical' || request.urgencyLevel === 'high'
        ? ['app', 'sms', 'email']
        : ['app'];

    return {
      optimalTime,
      messageContent,
      title,
      tone:
        request.urgencyLevel === 'critical' || request.urgencyLevel === 'high'
          ? 'urgent'
          : 'friendly',
      channels,
      reasoning: 'Fallback recommendation due to error in LLM processing',
      confidence: 0.5,
    };
  }

  /**
   * Map urgency level to notification priority
   */
  private mapUrgencyToPriority(
    urgencyLevel?: NotificationPriorityLevel,
  ): NotificationPriority {
    switch (urgencyLevel) {
      case 'critical':
        return NotificationPriority.CRITICAL;
      case 'high':
        return NotificationPriority.HIGH;
      case 'medium':
        return NotificationPriority.NORMAL;
      case 'low':
      default:
        return NotificationPriority.LOW;
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
  private async analyzeLLMEffectiveness(
    data: string,
  ): Promise<NotificationEffectivenessAnalysis> {
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

    const completion = await this.openaiService.createCompletion(prompt, {
      model: 'gpt-4o-mini',
      temperature: 0.1,
    });

    return JSON.parse(completion || '{}') as NotificationEffectivenessAnalysis;
  }

  /**
   * Store effectiveness insights
   */
  private async storeEffectivenessInsights(
    userId: string,
    analysis: NotificationEffectivenessAnalysis,
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
