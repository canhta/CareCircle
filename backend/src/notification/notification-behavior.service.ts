import { Injectable, Logger } from '@nestjs/common';
import { MilvusService } from '../vector/milvus.service';
import { EmbeddingService } from '../ai/embedding.service';
import { ConfigService } from '@nestjs/config';

export interface NotificationBehaviorVector {
  id: string;
  userId: string;
  notificationId: string;
  action: 'opened' | 'dismissed' | 'snoozed' | 'clicked' | 'ignored';
  timestamp: Date;
  vector: number[];
  metadata: {
    timeToAction?: number;
    deviceType?: string;
    timeOfDay: number;
    dayOfWeek: number;
    notificationType: string;
    contextData?: Record<string, any>;
  };
}

export interface SimilarNotificationBehavior {
  userId: string;
  similarity: number;
  metadata: NotificationBehaviorVector['metadata'];
  timestamp: Date;
}

@Injectable()
export class NotificationBehaviorService {
  private readonly logger = new Logger(NotificationBehaviorService.name);
  private readonly collectionName = 'notification_behaviors';

  constructor(
    private readonly milvusService: MilvusService,
    private readonly embeddingService: EmbeddingService,
    private readonly configService: ConfigService,
  ) {}

  /**
   * Store notification behavior vector
   */
  async storeNotificationBehavior(
    behaviorData: Omit<NotificationBehaviorVector, 'vector'>,
  ): Promise<void> {
    try {
      // Create behavior vector from the data
      const behaviorVector = this.createBehaviorVector({
        timeOfDay: behaviorData.metadata.timeOfDay,
        dayOfWeek: behaviorData.metadata.dayOfWeek,
        action: behaviorData.action,
        notificationType: behaviorData.metadata.notificationType,
        timeToAction: behaviorData.metadata.timeToAction,
        deviceType: behaviorData.metadata.deviceType,
        contextData: behaviorData.metadata.contextData,
      });

      const vectorData = {
        ...behaviorData,
        vector: behaviorVector,
      };

      // Store using the general vector service
      await this.milvusService.storeUserInteraction({
        id: vectorData.id,
        userId: vectorData.userId,
        checkInId: vectorData.notificationId, // Use notificationId as checkInId
        interactionType: 'notification_behavior',
        timestamp: vectorData.timestamp,
        vector: vectorData.vector,
        metadata: {
          // Store notification-specific metadata in the general metadata format
          category: 'notification_behavior',
          responseText: `${vectorData.action}_${vectorData.metadata.notificationType}`,
          riskScore: vectorData.metadata.timeToAction
            ? Math.min(vectorData.metadata.timeToAction / 60000, 10)
            : undefined,
          // Store original notification metadata as additional context
          ...(vectorData.metadata.contextData || {}),
        },
      });

      this.logger.debug(
        `Stored notification behavior for user: ${behaviorData.userId}`,
      );
    } catch (error) {
      this.logger.error(
        `Failed to store notification behavior: ${(error as Error).message}`,
        (error as Error).stack,
      );
      throw error;
    }
  }

  /**
   * Find similar notification behaviors
   */
  async findSimilarNotificationBehaviors(
    userId: string,
    behaviorVector: number[],
    limit: number = 5,
  ): Promise<SimilarNotificationBehavior[]> {
    try {
      const results = await this.milvusService.findSimilarInteractions(
        userId,
        behaviorVector,
        limit,
        true, // Include other users
      );

      return results
        .filter(
          (result) => result.metadata.category === 'notification_behavior',
        ) // Filter for notification behaviors
        .map((result) => ({
          userId: result.userId,
          similarity: result.similarity,
          metadata: {
            timeOfDay: 0, // Default values since we can't recover original structure
            dayOfWeek: 0,
            notificationType:
              result.metadata.responseText?.split('_')[1] || 'unknown',
            timeToAction: result.metadata.riskScore
              ? result.metadata.riskScore * 60000
              : undefined,
          },
          timestamp: result.timestamp,
        }));
    } catch (error) {
      this.logger.error(
        `Failed to find similar notification behaviors: ${(error as Error).message}`,
        (error as Error).stack,
      );
      return [];
    }
  }

  /**
   * Get notification behavior history for a user
   */
  async getNotificationBehaviorHistory(
    userId: string,
    limit: number = 100,
  ): Promise<NotificationBehaviorVector[]> {
    try {
      const interactions = await this.milvusService.getUserInteractionHistory(
        userId,
        limit,
      );

      return interactions
        .filter(
          (interaction) =>
            interaction.interactionType === 'notification_behavior',
        )
        .map((interaction) => ({
          id: interaction.id,
          userId: interaction.userId,
          notificationId: interaction.checkInId,
          action: (interaction.metadata.responseText?.split('_')[0] ||
            'unknown') as any,
          timestamp: interaction.timestamp,
          vector: interaction.vector,
          metadata: {
            timeOfDay: 0, // Default values since we can't recover original structure
            dayOfWeek: 0,
            notificationType:
              interaction.metadata.responseText?.split('_')[1] || 'unknown',
            timeToAction: interaction.metadata.riskScore
              ? interaction.metadata.riskScore * 60000
              : undefined,
          },
        }));
    } catch (error) {
      this.logger.error(
        `Failed to get notification behavior history: ${(error as Error).message}`,
        (error as Error).stack,
      );
      return [];
    }
  }

  /**
   * Create behavior vector from notification behavior data
   */
  createBehaviorVector(behaviorData: {
    timeOfDay: number;
    dayOfWeek: number;
    action: string;
    notificationType: string;
    timeToAction?: number;
    deviceType?: string;
    contextData?: Record<string, any>;
  }): number[] {
    // Create a behavior vector by encoding various features
    const vector: number[] = new Array(128).fill(0) as number[];

    // Time features (0-23 hours -> first 24 dimensions)
    if (behaviorData.timeOfDay >= 0 && behaviorData.timeOfDay <= 23) {
      vector[behaviorData.timeOfDay] = 1.0;
    }

    // Day of week features (24-30 dimensions)
    if (behaviorData.dayOfWeek >= 0 && behaviorData.dayOfWeek <= 6) {
      vector[24 + behaviorData.dayOfWeek] = 1.0;
    }

    // Action type encoding (31-40 dimensions)
    const actionMap: Record<string, number> = {
      opened: 31,
      dismissed: 32,
      snoozed: 33,
      clicked: 34,
      ignored: 35,
    };
    if (behaviorData.action && actionMap[behaviorData.action]) {
      vector[actionMap[behaviorData.action]] = 1.0;
    }

    // Notification type encoding (41-50 dimensions)
    const notificationTypeMap: Record<string, number> = {
      medication_reminder: 41,
      health_check: 42,
      care_group_update: 43,
      system_alert: 44,
      ai_insight: 45,
    };
    if (
      behaviorData.notificationType &&
      notificationTypeMap[behaviorData.notificationType]
    ) {
      vector[notificationTypeMap[behaviorData.notificationType]] = 1.0;
    }

    // Response time features (51-60 dimensions)
    if (behaviorData.timeToAction) {
      // Normalize response time (in minutes) and map to dimensions
      const responseMinutes = Math.min(
        behaviorData.timeToAction / (1000 * 60),
        60,
      );
      const responseIndex = Math.floor(responseMinutes / 6); // 6-minute buckets
      if (responseIndex < 10) {
        vector[51 + responseIndex] = responseMinutes / 60; // Normalized value
      }
    }

    // Device type encoding (61-65 dimensions)
    const deviceTypeMap: Record<string, number> = {
      mobile: 61,
      tablet: 62,
      desktop: 63,
      watch: 64,
    };
    if (behaviorData.deviceType && deviceTypeMap[behaviorData.deviceType]) {
      vector[deviceTypeMap[behaviorData.deviceType]] = 1.0;
    }

    // Normalize the vector
    const magnitude = Math.sqrt(
      vector.reduce((sum, val) => sum + val * val, 0),
    );
    if (magnitude > 0) {
      return vector.map((val) => val / magnitude);
    }

    return vector;
  }

  /**
   * Delete notification behavior data for a user (GDPR compliance)
   */
  async deleteNotificationBehaviorData(userId: string): Promise<void> {
    try {
      await this.milvusService.deleteUserInteractions(userId);
      this.logger.log(`Deleted notification behavior data for user: ${userId}`);
    } catch (error) {
      this.logger.error(
        `Failed to delete notification behavior data: ${(error as Error).message}`,
        (error as Error).stack,
      );
      throw error;
    }
  }
}
