import { Processor, WorkerHost } from '@nestjs/bullmq';
import { Logger } from '@nestjs/common';
import { Job } from 'bullmq';
import { PrismaService } from '../../prisma/prisma.service';
import { NotificationPayload } from '../../common/interfaces/notification.interfaces';
import { NotificationAuditLoggingService } from '../audit-logging.service';
import { NotificationChannel } from '@prisma/client';
import { FirebaseService } from '../../firebase/firebase.service';

@Processor('notification')
export class NotificationProcessor extends WorkerHost {
  private readonly logger = new Logger(NotificationProcessor.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly auditLoggingService: NotificationAuditLoggingService,
    private readonly firebaseService: FirebaseService,
  ) {
    super();
  }

  async process(
    job: Job<{ notificationId: string } & NotificationPayload>,
  ): Promise<void> {
    const { notificationId, ...payload } = job.data;
    const startTime = Date.now();

    try {
      this.logger.debug(`Processing notification job: ${notificationId}`);

      // Log processing started
      for (const channel of payload.channels) {
        await this.auditLoggingService.logNotificationProcessing(
          notificationId,
          channel,
        );
      }

      // Simulate notification delivery based on channels
      const deliveryResults = await this.deliverNotification(payload);

      // Update notification status
      await this.prisma.notification.update({
        where: { id: notificationId },
        data: {
          sentAt: new Date(),
        },
      });

      // Log delivery results
      await this.logDeliveryResults(notificationId, deliveryResults);

      this.logger.log(`Notification delivered successfully: ${notificationId}`);
    } catch (error) {
      const processingTime = Date.now() - startTime;

      // Log failure for all channels
      for (const channel of payload.channels) {
        await this.auditLoggingService.logNotificationFailed(
          notificationId,
          channel,
          error instanceof Error ? error : new Error(String(error)),
          job.attemptsMade,
        );
      }

      this.logger.error(
        `Failed to process notification ${notificationId}:`,
        error,
      );
      throw error; // Re-throw to trigger job retry
    }
  }

  private async deliverNotification(
    payload: NotificationPayload,
  ): Promise<DeliveryResult[]> {
    const results: DeliveryResult[] = [];

    for (const channel of payload.channels) {
      const startTime = Date.now();
      try {
        switch (channel) {
          case NotificationChannel.PUSH:
            await this.sendPushNotification(payload);
            break;
          case NotificationChannel.EMAIL:
            await this.sendEmailNotification(payload);
            break;
          case NotificationChannel.SMS:
            await this.sendSMSNotification(payload);
            break;
          case NotificationChannel.IN_APP:
            await this.sendInAppNotification(payload);
            break;
        }

        const processingTime = Date.now() - startTime;
        const deliveryId = `${channel}-${Date.now()}`; // Mock delivery ID

        results.push({
          channel,
          status: 'delivered',
          timestamp: new Date(),
          deliveryId,
          processingTime,
        });
      } catch (error) {
        const processingTime = Date.now() - startTime;
        const errorMsg = error instanceof Error ? error.message : String(error);

        this.logger.error(
          `Failed to deliver notification via ${channel}:`,
          error,
        );

        results.push({
          channel,
          status: 'failed',
          timestamp: new Date(),
          error: errorMsg,
          processingTime,
        });
      }
    }

    return results;
  }
  private async sendPushNotification(
    payload: NotificationPayload,
  ): Promise<void> {
    this.logger.debug(`Sending push notification: ${payload.title}`);

    // Get user's FCM tokens
    const tokens = await this.firebaseService.getUserTokens(payload.userId);

    if (tokens.length === 0) {
      this.logger.warn(`No FCM tokens found for user ${payload.userId}`);
      return;
    }

    // Send to multiple devices if user has multiple tokens
    const fcmMessage = {
      title: payload.title,
      body: payload.message,
      tokens,
      data: payload.templateData
        ? Object.fromEntries(
            Object.entries(payload.templateData).map(([key, value]) => [
              key,
              String(value),
            ]),
          )
        : undefined,
      actionUrl: payload.actionUrl,
      priority:
        payload.priority === 'HIGH' ? ('high' as const) : ('normal' as const),
    };

    const result = await this.firebaseService.sendToDevices(fcmMessage);

    if (!result.success) {
      throw new Error(`FCM send failed: ${result.error}`);
    }
  }

  private async sendEmailNotification(
    payload: NotificationPayload,
  ): Promise<void> {
    // TODO: Implement email service (e.g., SendGrid, AWS SES)
    this.logger.debug(`Sending email notification: ${payload.title}`);

    // For now, simulate delivery
    await new Promise((resolve) => setTimeout(resolve, 100));
  }

  private async sendSMSNotification(
    payload: NotificationPayload,
  ): Promise<void> {
    // TODO: Implement SMS service (e.g., Twilio, AWS SNS)
    this.logger.debug(`Sending SMS notification: ${payload.title}`);

    // For now, simulate delivery
    await new Promise((resolve) => setTimeout(resolve, 100));
  }

  private async sendInAppNotification(
    payload: NotificationPayload,
  ): Promise<void> {
    // TODO: Implement WebSocket or Server-Sent Events for real-time in-app notifications
    this.logger.debug(`Sending in-app notification: ${payload.title}`);

    // For now, simulate delivery
    await new Promise((resolve) => setTimeout(resolve, 100));
  }

  private async logDeliveryResults(
    notificationId: string,
    results: DeliveryResult[],
  ): Promise<void> {
    for (const result of results) {
      if (result.status === 'delivered') {
        await this.auditLoggingService.logNotificationSent(
          notificationId,
          result.channel as NotificationChannel,
          result.deliveryId,
          this.getProviderName(result.channel as NotificationChannel),
          result.processingTime,
        );
      } else if (result.status === 'failed') {
        await this.auditLoggingService.logNotificationFailed(
          notificationId,
          result.channel as NotificationChannel,
          new Error(result.error || 'Unknown error'),
          0, // retry count handled by BullMQ
        );
      }
    }
  }

  private getProviderName(channel: NotificationChannel): string {
    switch (channel) {
      case NotificationChannel.PUSH:
        return 'FCM';
      case NotificationChannel.EMAIL:
        return 'SendGrid';
      case NotificationChannel.SMS:
        return 'Twilio';
      case NotificationChannel.IN_APP:
        return 'WebSocket';
      default:
        return 'Unknown';
    }
  }
}

interface DeliveryResult {
  channel: string;
  status: 'delivered' | 'failed';
  timestamp: Date;
  deliveryId?: string;
  processingTime?: number;
  error?: string;
}
