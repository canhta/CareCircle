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
  actions?: NotificationAction[];
}

export interface NotificationAction {
  id: string;
  title: string;
  icon?: string;
}

export interface DeviceInfo {
  model?: string;
  osVersion?: string;
  appVersion?: string;
}

export interface TokenRegistrationResult {
  tokenId: string;
  isNewToken: boolean;
}

export interface CleanupResult {
  totalTokens: number;
  invalidTokens: number;
  cleanedUp: number;
}

export interface HealthStatus {
  isHealthy: boolean;
  lastHealthCheck: Date;
  totalTokens: number;
  activeTokens: number;
  errors: string[];
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
    deviceInfo?: DeviceInfo,
  ): Promise<TokenRegistrationResult> {
    try {
      const existingToken = await this.prisma.deviceToken.findUnique({
        where: {
          userId_token: {
            userId,
            token,
          },
        },
      });

      const isNewToken = !existingToken;

      const result = await this.prisma.deviceToken.upsert({
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
          deviceInfo: deviceInfo ? JSON.stringify(deviceInfo) : null,
          isActive: true,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        update: {
          isActive: true,
          deviceInfo: deviceInfo ? JSON.stringify(deviceInfo) : undefined,
          updatedAt: new Date(),
        },
      });

      this.logger.log(
        `${isNewToken ? 'Registered new' : 'Updated'} FCM token for user ${userId}`,
      );

      return {
        tokenId: result.id,
        isNewToken,
      };
    } catch (error) {
      this.logger.error(`Failed to store FCM token for user ${userId}:`, error);
      throw error;
    }
  }

  /**
   * Get active FCM tokens for a user
   */
  async getUserTokens(
    userId: string,
    activeOnly: boolean = true,
  ): Promise<string[]> {
    try {
      const deviceTokens = await this.prisma.deviceToken.findMany({
        where: {
          userId,
          ...(activeOnly && { isActive: true }),
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
   * Send notification to multiple users
   */
  async sendNotificationToUsers(dto: {
    title: string;
    body: string;
    userIds: string[];
    data?: { [key: string]: string };
    imageUrl?: string;
    actionUrl?: string;
    priority?: 'high' | 'normal';
    actions?: NotificationAction[];
  }): Promise<FCMSendResult[]> {
    const results: FCMSendResult[] = [];

    for (const userId of dto.userIds) {
      const tokens = await this.getUserTokens(userId);

      if (tokens.length === 0) {
        this.logger.warn(`No FCM tokens found for user ${userId}`);
        continue;
      }

      try {
        const result = await this.sendToDevices({
          title: dto.title,
          body: dto.body,
          tokens,
          data: dto.data,
          imageUrl: dto.imageUrl,
          actionUrl: dto.actionUrl,
          priority: dto.priority,
          actions: dto.actions,
        });

        results.push(result);
      } catch (error) {
        this.logger.error(
          `Failed to send notification to user ${userId}:`,
          error,
        );
        results.push({
          success: false,
          error: error instanceof Error ? error.message : 'Unknown error',
        });
      }
    }

    return results;
  }

  /**
   * Get device info for a user
   */
  async getDeviceInfo(userId: string): Promise<any[]> {
    try {
      const deviceTokens = await this.prisma.deviceToken.findMany({
        where: {
          userId,
          isActive: true,
        },
        select: {
          deviceType: true,
          deviceInfo: true,
          createdAt: true,
          updatedAt: true,
        },
      });

      return deviceTokens.map((token) => ({
        deviceType: token.deviceType,
        deviceInfo: token.deviceInfo ? JSON.parse(token.deviceInfo) : undefined,
        createdAt: token.createdAt,
        updatedAt: token.updatedAt,
      }));
    } catch (error) {
      this.logger.error(`Failed to get device info for user ${userId}:`, error);
      return [];
    }
  }

  /**
   * Clean up invalid tokens for a specific user
   */
  async cleanupInvalidTokens(userId?: string): Promise<CleanupResult> {
    try {
      const whereClause = userId
        ? { userId, isActive: true }
        : { isActive: true };

      const activeTokens = await this.prisma.deviceToken.findMany({
        where: whereClause,
        select: { id: true, token: true },
      });

      const invalidTokenIds: string[] = [];

      for (const deviceToken of activeTokens) {
        try {
          await this.messaging.send(
            {
              token: deviceToken.token,
              notification: {
                title: 'Health Check',
                body: 'Validating token',
              },
            },
            true, // dry run
          );
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

      let cleanedUp = 0;
      if (invalidTokenIds.length > 0) {
        const updateResult = await this.prisma.deviceToken.updateMany({
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

        cleanedUp = updateResult.count;
        this.logger.log(
          `Cleaned up ${cleanedUp} invalid FCM tokens${userId ? ` for user ${userId}` : ''}`,
        );
      }

      return {
        totalTokens: activeTokens.length,
        invalidTokens: invalidTokenIds.length,
        cleanedUp,
      };
    } catch (error) {
      this.logger.error(
        `Failed to cleanup invalid tokens${userId ? ` for user ${userId}` : ''}:`,
        error,
      );
      throw error;
    }
  }

  /**
   * Get Firebase service health status
   */
  async getHealthStatus(): Promise<HealthStatus> {
    try {
      const totalTokens = await this.prisma.deviceToken.count();
      const activeTokens = await this.prisma.deviceToken.count({
        where: { isActive: true },
      });

      const errors: string[] = [];

      // Test Firebase connectivity
      try {
        await this.messaging.send(
          {
            token: 'test-token',
            notification: {
              title: 'Health Check',
              body: 'Testing Firebase connectivity',
            },
          },
          true, // dry run
        );
      } catch (error: unknown) {
        if (error && typeof error === 'object' && 'code' in error) {
          const firebaseError = error as { code: string };
          if (firebaseError.code !== 'messaging/invalid-registration-token') {
            errors.push(`Firebase connectivity issue: ${firebaseError.code}`);
          }
        }
      }

      return {
        isHealthy: errors.length === 0,
        lastHealthCheck: new Date(),
        totalTokens,
        activeTokens,
        errors,
      };
    } catch (error) {
      this.logger.error('Failed to get health status:', error);
      throw error;
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
