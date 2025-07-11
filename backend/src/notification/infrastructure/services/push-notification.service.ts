import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as admin from 'firebase-admin';
import {
  Message,
  MulticastMessage,
  BatchResponse,
  MessagingTopicManagementResponse,
} from 'firebase-admin/messaging';

export interface PushNotificationPayload {
  title: string;
  body: string;
  data?: Record<string, string>;
  imageUrl?: string;
  clickAction?: string;
  sound?: string;
  badge?: number;
}

export interface FCMTokenInfo {
  token: string;
  userId: string;
  deviceType: 'ios' | 'android' | 'web';
  isActive: boolean;
  lastUsed: Date;
}

export interface BatchNotificationRequest {
  tokens: string[];
  payload: PushNotificationPayload;
  priority?: 'high' | 'normal';
  timeToLive?: number;
}

export interface NotificationDeliveryResult {
  success: boolean;
  messageId?: string;
  error?: string;
  token?: string;
}

@Injectable()
export class PushNotificationService {
  private readonly logger = new Logger(PushNotificationService.name);
  private readonly messaging: admin.messaging.Messaging;

  constructor(private readonly configService: ConfigService) {
    this.messaging = admin.messaging();
  }

  /**
   * Send push notification to a single device token
   */
  async sendToToken(
    token: string,
    payload: PushNotificationPayload,
    options?: {
      priority?: 'high' | 'normal';
      timeToLive?: number;
      collapseKey?: string;
    },
  ): Promise<NotificationDeliveryResult> {
    try {
      const message: Message = {
        token,
        notification: {
          title: payload.title,
          body: payload.body,
          imageUrl: payload.imageUrl,
        },
        data: payload.data || {},
        android: {
          priority: options?.priority || 'high',
          ttl: options?.timeToLive || 3600000, // 1 hour default
          collapseKey: options?.collapseKey,
          notification: {
            sound: payload.sound || 'default',
            clickAction: payload.clickAction,
            channelId: 'carecircle_notifications',
            priority: 'high',
            defaultSound: true,
            defaultVibrateTimings: true,
          },
        },
        apns: {
          payload: {
            aps: {
              alert: {
                title: payload.title,
                body: payload.body,
              },
              sound: payload.sound || 'default',
              badge: payload.badge,
              contentAvailable: true,
              mutableContent: true,
            },
          },
          fcmOptions: {
            imageUrl: payload.imageUrl,
          },
        },
        webpush: {
          notification: {
            title: payload.title,
            body: payload.body,
            icon: '/icons/notification-icon.png',
            badge: '/icons/badge-icon.png',
            image: payload.imageUrl,
            requireInteraction: true,
            actions: [
              {
                action: 'view',
                title: 'View',
              },
              {
                action: 'dismiss',
                title: 'Dismiss',
              },
            ],
          },
          fcmOptions: {
            link: payload.clickAction || '/',
          },
        },
      };

      const messageId = await this.messaging.send(message);

      this.logger.log(`Push notification sent successfully: ${messageId}`);

      return {
        success: true,
        messageId,
        token,
      };
    } catch (error) {
      this.logger.error(
        `Failed to send push notification to token ${token}:`,
        error,
      );

      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        token,
      };
    }
  }

  /**
   * Send push notifications to multiple device tokens (batch)
   */
  async sendBatchNotification(
    request: BatchNotificationRequest,
  ): Promise<NotificationDeliveryResult[]> {
    try {
      if (request.tokens.length === 0) {
        return [];
      }

      // Firebase FCM supports up to 500 tokens per batch
      const batchSize = 500;
      const results: NotificationDeliveryResult[] = [];

      for (let i = 0; i < request.tokens.length; i += batchSize) {
        const tokenBatch = request.tokens.slice(i, i + batchSize);

        const multicastMessage: MulticastMessage = {
          tokens: tokenBatch,
          notification: {
            title: request.payload.title,
            body: request.payload.body,
            imageUrl: request.payload.imageUrl,
          },
          data: request.payload.data || {},
          android: {
            priority: request.priority || 'high',
            ttl: request.timeToLive || 3600000,
            notification: {
              sound: request.payload.sound || 'default',
              clickAction: request.payload.clickAction,
              channelId: 'carecircle_notifications',
              priority: 'high',
              defaultSound: true,
              defaultVibrateTimings: true,
            },
          },
          apns: {
            payload: {
              aps: {
                alert: {
                  title: request.payload.title,
                  body: request.payload.body,
                },
                sound: request.payload.sound || 'default',
                badge: request.payload.badge,
                contentAvailable: true,
                mutableContent: true,
              },
            },
            fcmOptions: {
              imageUrl: request.payload.imageUrl,
            },
          },
          webpush: {
            notification: {
              title: request.payload.title,
              body: request.payload.body,
              icon: '/icons/notification-icon.png',
              badge: '/icons/badge-icon.png',
              image: request.payload.imageUrl,
              requireInteraction: true,
            },
            fcmOptions: {
              link: request.payload.clickAction || '/',
            },
          },
        };

        const batchResponse: BatchResponse =
          await this.messaging.sendEachForMulticast(multicastMessage);

        // Process batch results
        batchResponse.responses.forEach((response, index) => {
          const token = tokenBatch[index];

          if (response.success) {
            results.push({
              success: true,
              messageId: response.messageId,
              token,
            });
          } else {
            results.push({
              success: false,
              error: response.error?.message || 'Unknown error',
              token,
            });
          }
        });

        this.logger.log(
          `Batch notification sent: ${batchResponse.successCount} successful, ${batchResponse.failureCount} failed`,
        );
      }

      return results;
    } catch (error) {
      this.logger.error('Failed to send batch notification:', error);

      // Return failure results for all tokens
      return request.tokens.map((token) => ({
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        token,
      }));
    }
  }

  /**
   * Subscribe tokens to a topic for topic-based messaging
   */
  async subscribeToTopic(
    tokens: string[],
    topic: string,
  ): Promise<MessagingTopicManagementResponse> {
    try {
      const response = await this.messaging.subscribeToTopic(tokens, topic);

      this.logger.log(
        `Topic subscription: ${response.successCount} successful, ${response.failureCount} failed for topic ${topic}`,
      );

      return response;
    } catch (error) {
      this.logger.error(`Failed to subscribe to topic ${topic}:`, error);
      throw error;
    }
  }

  /**
   * Unsubscribe tokens from a topic
   */
  async unsubscribeFromTopic(
    tokens: string[],
    topic: string,
  ): Promise<MessagingTopicManagementResponse> {
    try {
      const response = await this.messaging.unsubscribeFromTopic(tokens, topic);

      this.logger.log(
        `Topic unsubscription: ${response.successCount} successful, ${response.failureCount} failed for topic ${topic}`,
      );

      return response;
    } catch (error) {
      this.logger.error(`Failed to unsubscribe from topic ${topic}:`, error);
      throw error;
    }
  }

  /**
   * Send notification to a topic
   */
  async sendToTopic(
    topic: string,
    payload: PushNotificationPayload,
  ): Promise<NotificationDeliveryResult> {
    try {
      const message: Message = {
        topic,
        notification: {
          title: payload.title,
          body: payload.body,
          imageUrl: payload.imageUrl,
        },
        data: payload.data || {},
        android: {
          priority: 'high',
          notification: {
            sound: payload.sound || 'default',
            clickAction: payload.clickAction,
            channelId: 'carecircle_notifications',
            priority: 'high',
            defaultSound: true,
            defaultVibrateTimings: true,
          },
        },
        apns: {
          payload: {
            aps: {
              alert: {
                title: payload.title,
                body: payload.body,
              },
              sound: payload.sound || 'default',
              badge: payload.badge,
              contentAvailable: true,
              mutableContent: true,
            },
          },
          fcmOptions: {
            imageUrl: payload.imageUrl,
          },
        },
        webpush: {
          notification: {
            title: payload.title,
            body: payload.body,
            icon: '/icons/notification-icon.png',
            badge: '/icons/badge-icon.png',
            image: payload.imageUrl,
            requireInteraction: true,
          },
          fcmOptions: {
            link: payload.clickAction || '/',
          },
        },
      };

      const messageId = await this.messaging.send(message);

      this.logger.log(
        `Topic notification sent successfully to ${topic}: ${messageId}`,
      );

      return {
        success: true,
        messageId,
      };
    } catch (error) {
      this.logger.error(
        `Failed to send notification to topic ${topic}:`,
        error,
      );

      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }

  /**
   * Validate FCM token format
   */
  validateToken(token: string): boolean {
    // FCM tokens are typically 152+ characters long and contain alphanumeric characters, hyphens, and underscores
    const fcmTokenRegex = /^[a-zA-Z0-9_-]{140,}$/;
    return fcmTokenRegex.test(token);
  }

  /**
   * Create healthcare-specific notification payload
   */
  createHealthcareNotification(
    title: string,
    body: string,
    type: 'medication' | 'appointment' | 'health_alert' | 'emergency',
    data?: Record<string, string>,
  ): PushNotificationPayload {
    const basePayload: PushNotificationPayload = {
      title,
      body,
      data: {
        type,
        timestamp: new Date().toISOString(),
        ...data,
      },
      sound: type === 'emergency' ? 'emergency_alert.wav' : 'default',
      badge: 1,
    };

    // Set appropriate click action based on type
    switch (type) {
      case 'medication':
        basePayload.clickAction = '/medications';
        basePayload.imageUrl = '/icons/medication-icon.png';
        break;
      case 'appointment':
        basePayload.clickAction = '/appointments';
        basePayload.imageUrl = '/icons/appointment-icon.png';
        break;
      case 'health_alert':
        basePayload.clickAction = '/health-alerts';
        basePayload.imageUrl = '/icons/health-alert-icon.png';
        break;
      case 'emergency':
        basePayload.clickAction = '/emergency';
        basePayload.imageUrl = '/icons/emergency-icon.png';
        break;
    }

    return basePayload;
  }
}
