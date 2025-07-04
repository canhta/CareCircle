import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { initializeApp, getApps, App } from 'firebase-admin/app';
import {
  getMessaging,
  Messaging,
  Message,
  MulticastMessage,
} from 'firebase-admin/messaging';
import { credential, ServiceAccount } from 'firebase-admin';
import { PrismaService } from '../prisma/prisma.service';

export interface FCMMessage {
  title: string;
  body: string;
  token?: string;
  tokens?: string[];
  topic?: string;
  data?: { [key: string]: string };
  imageUrl?: string;
  actionUrl?: string;
  priority?: 'high' | 'normal';
  collapseKey?: string;
  timeToLive?: number;
}

export interface FCMSendResult {
  success: boolean;
  messageId?: string;
  error?: string;
  failureCount?: number;
  successCount?: number;
  responses?: Array<{
    success: boolean;
    messageId?: string;
    error?: string;
  }>;
}

@Injectable()
export class FirebaseService {
  private readonly logger = new Logger(FirebaseService.name);
  private app: App;
  private messaging: Messaging;

  constructor(
    private readonly configService: ConfigService,
    private readonly prisma: PrismaService,
  ) {
    this.initializeFirebase();
  }

  private initializeFirebase(): void {
    try {
      // Check if Firebase app is already initialized
      if (getApps().length === 0) {
        const serviceAccount = this.getServiceAccountCredentials();

        this.app = initializeApp({
          credential: credential.cert(serviceAccount),
          projectId: serviceAccount.projectId,
        });

        this.logger.log('Firebase Admin SDK initialized successfully');
      } else {
        this.app = getApps()[0];
        this.logger.log('Using existing Firebase app instance');
      }

      this.messaging = getMessaging(this.app);
      this.logger.log('Firebase Messaging initialized successfully');
    } catch (error) {
      this.logger.error('Failed to initialize Firebase:', error);
      throw error;
    }
  }

  private getServiceAccountCredentials(): ServiceAccount {
    // Try to get service account from environment variables first
    const serviceAccountJson = this.configService.get<string>(
      'FIREBASE_SERVICE_ACCOUNT_KEY',
    );

    if (serviceAccountJson) {
      try {
        return JSON.parse(serviceAccountJson) as ServiceAccount;
      } catch (error) {
        this.logger.error('Invalid Firebase service account JSON:', error);
        throw new Error('Invalid Firebase service account configuration');
      }
    }

    // Fallback to individual environment variables
    const projectId = this.configService.get<string>('FIREBASE_PROJECT_ID');
    const clientEmail = this.configService.get<string>('FIREBASE_CLIENT_EMAIL');
    const privateKey = this.configService.get<string>('FIREBASE_PRIVATE_KEY');

    if (!projectId || !clientEmail || !privateKey) {
      throw new Error(
        'Firebase configuration missing. Please set FIREBASE_SERVICE_ACCOUNT_KEY or individual Firebase environment variables',
      );
    }

    return {
      projectId,
      clientEmail,
      privateKey: privateKey.replace(/\\n/g, '\n'),
    };
  }

  /**
   * Send push notification to a single device
   */
  async sendToDevice(fcmMessage: FCMMessage): Promise<FCMSendResult> {
    if (!fcmMessage.token) {
      throw new Error('Token is required for single device messaging');
    }

    try {
      const message = this.buildMessage(fcmMessage);
      const response = await this.messaging.send(message);

      this.logger.log(
        `Push notification sent successfully. Message ID: ${response}`,
      );

      return {
        success: true,
        messageId: response,
      };
    } catch (error: unknown) {
      this.logger.error('Failed to send push notification:', error);
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error occurred';

      return {
        success: false,
        error: errorMessage,
      };
    }
  }

  /**
   * Send push notification to multiple devices
   */
  async sendToDevices(fcmMessage: FCMMessage): Promise<FCMSendResult> {
    if (!fcmMessage.tokens || fcmMessage.tokens.length === 0) {
      throw new Error('Tokens array is required for multi-device messaging');
    }

    try {
      const message = this.buildMulticastMessage(fcmMessage);
      const response = await this.messaging.sendEachForMulticast(message);

      this.logger.log(
        `Push notification sent to ${fcmMessage.tokens.length} devices. ` +
          `Success: ${response.successCount}, Failures: ${response.failureCount}`,
      );

      return {
        success: response.failureCount === 0,
        successCount: response.successCount,
        failureCount: response.failureCount,
        responses: response.responses.map((res) => ({
          success: res.success,
          messageId: res.messageId,
          error: res.error?.message,
        })),
      };
    } catch (error: unknown) {
      this.logger.error('Failed to send push notifications:', error);
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error occurred';

      return {
        success: false,
        error: errorMessage,
      };
    }
  }

  /**
   * Send push notification to a topic
   */
  async sendToTopic(fcmMessage: FCMMessage): Promise<FCMSendResult> {
    if (!fcmMessage.topic) {
      throw new Error('Topic is required for topic messaging');
    }

    try {
      const message = this.buildTopicMessage(fcmMessage);
      const response = await this.messaging.send(message);

      this.logger.log(
        `Push notification sent to topic '${fcmMessage.topic}'. Message ID: ${response}`,
      );

      return {
        success: true,
        messageId: response,
      };
    } catch (error: unknown) {
      this.logger.error('Failed to send topic notification:', error);
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error occurred';

      return {
        success: false,
        error: errorMessage,
      };
    }
  }

  /**
   * Subscribe tokens to a topic
   */
  async subscribeToTopic(tokens: string[], topic: string): Promise<void> {
    try {
      const response = await this.messaging.subscribeToTopic(tokens, topic);
      this.logger.log(
        `Subscribed ${response.successCount} tokens to topic '${topic}'. ` +
          `Failures: ${response.failureCount}`,
      );
    } catch (error) {
      this.logger.error(`Failed to subscribe to topic '${topic}':`, error);
      throw error;
    }
  }

  /**
   * Unsubscribe tokens from a topic
   */
  async unsubscribeFromTopic(tokens: string[], topic: string): Promise<void> {
    try {
      const response = await this.messaging.unsubscribeFromTopic(tokens, topic);
      this.logger.log(
        `Unsubscribed ${response.successCount} tokens from topic '${topic}'. ` +
          `Failures: ${response.failureCount}`,
      );
    } catch (error) {
      this.logger.error(`Failed to unsubscribe from topic '${topic}':`, error);
      throw error;
    }
  }

  /**
   * Store FCM token for a user
   */
  async storeUserToken(
    userId: string,
    token: string,
    deviceType: 'ios' | 'android' | 'web',
  ): Promise<void> {
    try {
      await this.prisma.deviceToken.upsert({
        where: {
          userId_token: {
            userId,
            token,
          },
        },
        create: {
          userId,
          token,
          deviceType,
          isActive: true,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        update: {
          isActive: true,
          updatedAt: new Date(),
        },
      });

      this.logger.log(`Stored FCM token for user ${userId}`);
    } catch (error) {
      this.logger.error(`Failed to store FCM token for user ${userId}:`, error);
      throw error;
    }
  }

  /**
   * Get active FCM tokens for a user
   */
  async getUserTokens(userId: string): Promise<string[]> {
    try {
      const deviceTokens = await this.prisma.deviceToken.findMany({
        where: {
          userId,
          isActive: true,
        },
        select: {
          token: true,
        },
      });

      return deviceTokens.map((dt) => dt.token);
    } catch (error) {
      this.logger.error(`Failed to get FCM tokens for user ${userId}:`, error);
      return [];
    }
  }

  /**
   * Remove FCM token for a user
   */
  async removeUserToken(userId: string, token: string): Promise<void> {
    try {
      await this.prisma.deviceToken.updateMany({
        where: {
          userId,
          token,
        },
        data: {
          isActive: false,
          updatedAt: new Date(),
        },
      });

      this.logger.log(`Removed FCM token for user ${userId}`);
    } catch (error) {
      this.logger.error(
        `Failed to remove FCM token for user ${userId}:`,
        error,
      );
      throw error;
    }
  }

  /**
   * Clean up invalid tokens
   */
  async cleanupInvalidTokens(): Promise<void> {
    try {
      // Get all active tokens
      const activeTokens = await this.prisma.deviceToken.findMany({
        where: { isActive: true },
        select: { id: true, token: true },
      });

      const invalidTokenIds: string[] = [];

      // Test tokens in batches
      const batchSize = 100;
      for (let i = 0; i < activeTokens.length; i += batchSize) {
        const batch = activeTokens.slice(i, i + batchSize);

        for (const deviceToken of batch) {
          try {
            // Try to send a dry run message to validate token
            await this.messaging.send(
              {
                token: deviceToken.token,
                notification: {
                  title: 'Test',
                  body: 'Test',
                },
              },
              true,
            ); // dry run
          } catch (error: unknown) {
            if (error && typeof error === 'object' && 'code' in error) {
              const firebaseError = error as { code: string };
              if (
                firebaseError.code === 'messaging/invalid-registration-token' ||
                firebaseError.code ===
                  'messaging/registration-token-not-registered'
              ) {
                invalidTokenIds.push(deviceToken.id);
              }
            }
          }
        }
      }

      // Mark invalid tokens as inactive
      if (invalidTokenIds.length > 0) {
        await this.prisma.deviceToken.updateMany({
          where: {
            id: {
              in: invalidTokenIds,
            },
          },
          data: {
            isActive: false,
            updatedAt: new Date(),
          },
        });

        this.logger.log(
          `Cleaned up ${invalidTokenIds.length} invalid FCM tokens`,
        );
      }
    } catch (error) {
      this.logger.error('Failed to cleanup invalid tokens:', error);
    }
  }

  private buildMessage(fcmMessage: FCMMessage): Message {
    if (!fcmMessage.token) {
      throw new Error('Token is required for single device messaging');
    }

    const message: Message = {
      token: fcmMessage.token,
      notification: {
        title: fcmMessage.title,
        body: fcmMessage.body,
      },
    };

    if (fcmMessage.imageUrl && message.notification) {
      message.notification.imageUrl = fcmMessage.imageUrl;
    }

    if (fcmMessage.data) {
      message.data = fcmMessage.data;
    }

    if (fcmMessage.actionUrl) {
      message.data = {
        ...message.data,
        actionUrl: fcmMessage.actionUrl,
      };
    }

    // Android-specific configuration
    if (
      fcmMessage.priority ||
      fcmMessage.collapseKey ||
      fcmMessage.timeToLive
    ) {
      message.android = {
        priority: fcmMessage.priority || 'normal',
        ...(fcmMessage.collapseKey && { collapseKey: fcmMessage.collapseKey }),
        ...(fcmMessage.timeToLive && { ttl: fcmMessage.timeToLive }),
      };
    }

    // iOS-specific configuration
    message.apns = {
      payload: {
        aps: {
          alert: {
            title: fcmMessage.title,
            body: fcmMessage.body,
          },
          badge: 1,
          sound: 'default',
        },
      },
    };

    return message;
  }

  private buildMulticastMessage(fcmMessage: FCMMessage): MulticastMessage {
    if (!fcmMessage.tokens) {
      throw new Error('Tokens array is required for multicast messaging');
    }

    const baseMessage = this.buildMessage({ ...fcmMessage, token: 'dummy' });

    return {
      tokens: fcmMessage.tokens,
      notification: baseMessage.notification,
      data: baseMessage.data,
      android: baseMessage.android,
      apns: baseMessage.apns,
      webpush: baseMessage.webpush,
      fcmOptions: baseMessage.fcmOptions,
    };
  }

  private buildTopicMessage(fcmMessage: FCMMessage): Message {
    if (!fcmMessage.topic) {
      throw new Error('Topic is required for topic messaging');
    }

    const baseMessage = this.buildMessage({ ...fcmMessage, token: 'dummy' });

    return {
      topic: fcmMessage.topic,
      notification: baseMessage.notification,
      data: baseMessage.data,
      android: baseMessage.android,
      apns: baseMessage.apns,
      webpush: baseMessage.webpush,
      fcmOptions: baseMessage.fcmOptions,
    };
  }
}
