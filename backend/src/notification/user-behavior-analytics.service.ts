import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { NotificationBehaviorService } from './notification-behavior.service';
import { OpenAIService } from '../ai/openai.service';
import { ConfigService } from '@nestjs/config';
import { Prisma, UserNotificationBehavior } from '@prisma/client';
import {
  BehaviorNotificationContextData,
  BehaviorSummaryData,
  BehaviorVectorResult,
  BehaviorVectorParameters,
} from '../common/interfaces/notification-behavior.interfaces';

export interface UserBehaviorData {
  userId: string;
  notificationId: string;
  action: 'opened' | 'dismissed' | 'snoozed' | 'clicked' | 'ignored';
  timestamp: Date;
  timeToAction?: number; // milliseconds from notification sent to action
  deviceType?: string;
  timeOfDay: number; // hour of day (0-23)
  dayOfWeek: number; // 0 = Sunday, 6 = Saturday
  notificationType: string;
  contextData?: Prisma.JsonValue;
}

export interface UserEngagementPattern {
  userId: string;
  preferredTimes: number[]; // hours when user is most responsive
  responseRate: number; // percentage of notifications acted upon
  averageResponseTime: number; // average time to respond in milliseconds
  bestNotificationTypes: string[];
  worstNotificationTypes: string[];
  engagementTrend: 'improving' | 'declining' | 'stable';
  lastAnalysisDate: Date;
}

@Injectable()
export class UserBehaviorAnalyticsService {
  private readonly logger = new Logger(UserBehaviorAnalyticsService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly configService: ConfigService,
    private readonly notificationBehaviorService: NotificationBehaviorService,
    private readonly openaiService: OpenAIService,
  ) {}

  /**
   * Track user interaction with a notification
   */
  async trackUserBehavior(behaviorData: UserBehaviorData): Promise<void> {
    try {
      // Store the behavior data in the database
      await this.prisma.userNotificationBehavior.create({
        data: {
          userId: behaviorData.userId,
          notificationId: behaviorData.notificationId,
          action: behaviorData.action,
          timestamp: behaviorData.timestamp,
          timeToAction: behaviorData.timeToAction,
          deviceType: behaviorData.deviceType,
          timeOfDay: behaviorData.timeOfDay,
          dayOfWeek: behaviorData.dayOfWeek,
          notificationType: behaviorData.notificationType,
          contextData: behaviorData.contextData as Prisma.InputJsonValue,
        },
      });

      // Create behavior vector for Milvus
      const behaviorVector = this.createBehaviorVector(behaviorData);
      if (behaviorVector) {
        await this.notificationBehaviorService.storeNotificationBehavior({
          id: `${behaviorData.userId}_${behaviorData.notificationId}_${Date.now()}`,
          userId: behaviorData.userId,
          notificationId: behaviorData.notificationId,
          action: behaviorData.action,
          timestamp: behaviorData.timestamp,
          metadata: {
            timeToAction: behaviorData.timeToAction,
            deviceType: behaviorData.deviceType,
            timeOfDay: behaviorData.timeOfDay,
            dayOfWeek: behaviorData.dayOfWeek,
            notificationType: behaviorData.notificationType,
            contextData: behaviorData.contextData as Record<string, unknown>,
          },
        });
      }

      this.logger.debug(
        `Tracked behavior for user ${behaviorData.userId}: ${behaviorData.action}`,
      );

      // Trigger pattern analysis if we have enough data
      await this.analyzeUserPatternsIfNeeded(behaviorData.userId);
    } catch (error) {
      this.logger.error(
        `Failed to track user behavior: ${error.message}`,
        error.stack,
      );
    }
  }

  /**
   * Get user engagement patterns
   */
  async getUserEngagementPattern(
    userId: string,
  ): Promise<UserEngagementPattern | null> {
    try {
      const pattern = await this.prisma.userEngagementPattern.findUnique({
        where: { userId },
      });

      if (!pattern) {
        return null;
      }

      return {
        userId: pattern.userId,
        preferredTimes: pattern.preferredTimes as number[],
        responseRate: pattern.responseRate,
        averageResponseTime: pattern.averageResponseTime,
        bestNotificationTypes: pattern.bestNotificationTypes as string[],
        worstNotificationTypes: pattern.worstNotificationTypes as string[],
        engagementTrend: pattern.engagementTrend as
          | 'improving'
          | 'declining'
          | 'stable',
        lastAnalysisDate: pattern.lastAnalysisDate,
      };
    } catch (error) {
      this.logger.error(
        `Failed to get user engagement pattern: ${error.message}`,
        error.stack,
      );
      return null;
    }
  }

  /**
   * Analyze user patterns using OpenAI if we have enough data
   */
  private async analyzeUserPatternsIfNeeded(userId: string): Promise<void> {
    const behaviorCount = await this.prisma.userNotificationBehavior.count({
      where: { userId },
    });

    // Analyze patterns every 10 interactions or weekly
    const lastPattern = await this.prisma.userEngagementPattern.findUnique({
      where: { userId },
    });

    const shouldAnalyze =
      behaviorCount >= 10 &&
      (behaviorCount % 10 === 0 ||
        !lastPattern ||
        Date.now() - lastPattern.lastAnalysisDate.getTime() >
          7 * 24 * 60 * 60 * 1000);

    if (shouldAnalyze) {
      await this.analyzeUserPatterns(userId);
    }
  }

  /**
   * Analyze user patterns using OpenAI
   */
  async analyzeUserPatterns(
    userId: string,
  ): Promise<UserEngagementPattern | null> {
    try {
      // Get recent behavior data (last 30 days)
      const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
      const behaviors = await this.prisma.userNotificationBehavior.findMany({
        where: {
          userId,
          timestamp: { gte: thirtyDaysAgo },
        },
        orderBy: { timestamp: 'desc' },
      });

      if (behaviors.length < 5) {
        this.logger.debug(
          `Not enough data to analyze patterns for user ${userId}`,
        );
        return null;
      }

      // Prepare data for OpenAI analysis
      const behaviorSummary = this.prepareBehaviorSummary(behaviors);

      // Use OpenAI to analyze patterns
      const analysisPrompt = `
Analyze the following user notification behavior data and extract engagement patterns:

${behaviorSummary}

Based on this data, provide a JSON response with the following structure:
{
  "preferredTimes": [array of hours 0-23 when user is most responsive],
  "responseRate": number between 0-1 representing overall engagement,
  "averageResponseTime": number in milliseconds,
  "bestNotificationTypes": [array of notification types with highest engagement],
  "worstNotificationTypes": [array of notification types with lowest engagement],
  "engagementTrend": "improving" | "declining" | "stable",
  "insights": "brief analysis of user behavior patterns"
}

Focus on identifying optimal timing, notification preferences, and engagement trends.
`;

      const completion = await this.openaiService.createCompletion(
        analysisPrompt,
        {
          model: 'gpt-4o-mini',
          temperature: 0.1,
        },
      );

      const analysis = JSON.parse(completion || '{}');

      // Save the analysis
      const pattern = await this.prisma.userEngagementPattern.upsert({
        where: { userId },
        update: {
          preferredTimes: analysis.preferredTimes,
          responseRate: analysis.responseRate,
          averageResponseTime: analysis.averageResponseTime,
          bestNotificationTypes: analysis.bestNotificationTypes,
          worstNotificationTypes: analysis.worstNotificationTypes,
          engagementTrend: analysis.engagementTrend,
          lastAnalysisDate: new Date(),
          insights: analysis.insights,
        },
        create: {
          userId,
          preferredTimes: analysis.preferredTimes,
          responseRate: analysis.responseRate,
          averageResponseTime: analysis.averageResponseTime,
          bestNotificationTypes: analysis.bestNotificationTypes,
          worstNotificationTypes: analysis.worstNotificationTypes,
          engagementTrend: analysis.engagementTrend,
          lastAnalysisDate: new Date(),
          insights: analysis.insights,
        },
      });

      this.logger.log(`Updated engagement patterns for user ${userId}`);

      return {
        userId: pattern.userId,
        preferredTimes: pattern.preferredTimes as number[],
        responseRate: pattern.responseRate,
        averageResponseTime: pattern.averageResponseTime,
        bestNotificationTypes: pattern.bestNotificationTypes as string[],
        worstNotificationTypes: pattern.worstNotificationTypes as string[],
        engagementTrend: pattern.engagementTrend as
          | 'improving'
          | 'declining'
          | 'stable',
        lastAnalysisDate: pattern.lastAnalysisDate,
      };
    } catch (error) {
      this.logger.error(
        `Failed to analyze user patterns: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  /**
   * Prepare behavior summary for OpenAI analysis
   */
  private prepareBehaviorSummary(
    behaviors: UserNotificationBehavior[],
  ): string {
    const summary: BehaviorSummaryData = {
      total_notifications: behaviors.length,
      actions: behaviors.reduce(
        (acc, b) => {
          acc[b.action] = (acc[b.action] || 0) + 1;
          return acc;
        },
        {} as Record<string, number>,
      ),
      notification_types: behaviors.reduce(
        (acc, b) => {
          acc[b.notificationType] = (acc[b.notificationType] || 0) + 1;
          return acc;
        },
        {} as Record<string, number>,
      ),
      time_distribution: behaviors.reduce(
        (acc, b) => {
          const hour = b.timeOfDay;
          acc[hour] = (acc[hour] || 0) + 1;
          return acc;
        },
        {} as Record<string, number>,
      ),
      day_distribution: behaviors.reduce(
        (acc, b) => {
          const day = b.dayOfWeek;
          acc[day] = (acc[day] || 0) + 1;
          return acc;
        },
        {} as Record<string, number>,
      ),
      response_times: behaviors
        .filter((b) => b.timeToAction)
        .map((b) => b.timeToAction as number),
    };

    return JSON.stringify(summary, null, 2);
  }

  /**
   * Get similar users based on behavior patterns (for recommendations)
   */
  async getSimilarUsers(userId: string, limit: number = 5): Promise<string[]> {
    try {
      const userPattern = await this.getUserEngagementPattern(userId);
      if (!userPattern) {
        return [];
      }

      // Simple similarity based on preferred times and response rate
      // In a production system, you'd use a proper vector similarity search
      const allPatterns = await this.prisma.userEngagementPattern.findMany({
        where: { userId: { not: userId } },
      });

      const similarities = allPatterns.map((pattern) => {
        const timeSimilarity = this.calculateTimeSimilarity(
          userPattern.preferredTimes,
          pattern.preferredTimes as number[],
        );
        const rateSimilarity =
          1 - Math.abs(userPattern.responseRate - pattern.responseRate);

        return {
          userId: pattern.userId,
          similarity: (timeSimilarity + rateSimilarity) / 2,
        };
      });

      return similarities
        .sort((a, b) => b.similarity - a.similarity)
        .slice(0, limit)
        .map((s) => s.userId);
    } catch (error) {
      this.logger.error(
        `Failed to get similar users: ${error.message}`,
        error.stack,
      );
      return [];
    }
  }

  /**
   * Calculate similarity between preferred times
   */
  private calculateTimeSimilarity(times1: number[], times2: number[]): number {
    if (!times1.length || !times2.length) return 0;

    const overlap = times1.filter((t) => times2.includes(t)).length;
    const total = Math.max(times1.length, times2.length);

    return overlap / total;
  }

  /**
   * Create a behavior vector for storing in Milvus
   */
  private createBehaviorVector(
    behaviorData: UserBehaviorData,
  ): BehaviorVectorResult | null {
    try {
      // Create a behavior vector using the notification behavior service
      const vectorParams: BehaviorVectorParameters = {
        timeOfDay: behaviorData.timeOfDay,
        dayOfWeek: behaviorData.dayOfWeek,
        action: behaviorData.action,
        notificationType: behaviorData.notificationType,
        timeToAction: behaviorData.timeToAction,
        deviceType: behaviorData.deviceType,
        contextData: behaviorData.contextData as Record<string, unknown>,
      };

      const vector =
        this.notificationBehaviorService.createBehaviorVector(vectorParams);

      return {
        id: `${behaviorData.userId}_${Date.now()}`,
        userId: behaviorData.userId,
        vector: vector,
        metadata: {
          timestamp: behaviorData.timestamp.getTime(),
          notificationType: behaviorData.notificationType,
          action: behaviorData.action,
          timeOfDay: behaviorData.timeOfDay,
          dayOfWeek: behaviorData.dayOfWeek,
          responseTime: behaviorData.timeToAction,
          deviceType: behaviorData.deviceType || undefined,
        },
      };
    } catch (error) {
      this.logger.error(
        `Failed to create behavior vector: ${error.message}`,
        error.stack,
      );
      return null;
    }
  }
}
