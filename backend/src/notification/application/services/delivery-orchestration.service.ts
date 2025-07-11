import { Injectable, Logger } from '@nestjs/common';
import {
  NotificationChannel,
  NotificationPriority,
  NotificationStatus,
} from '@prisma/client';
import {
  PushNotificationService,
  NotificationDeliveryResult as PushDeliveryResult,
} from '../../infrastructure/services/push-notification.service';
import {
  EmailNotificationService,
  EmailDeliveryResult,
} from '../../infrastructure/services/email-notification.service';
import { NotificationRepository } from '../../domain/repositories/notification.repository';
import { Notification } from '../../domain/entities/notification.entity';

export interface DeliveryRequest {
  notificationId: string;
  userId: string;
  title: string;
  message: string;
  priority: NotificationPriority;
  channels: NotificationChannel[];
  userPreferences?: UserNotificationPreferences;
  metadata?: Record<string, any>;
}

export interface UserNotificationPreferences {
  pushEnabled: boolean;
  emailEnabled: boolean;
  smsEnabled: boolean;
  pushTokens?: string[];
  emailAddress?: string;
  phoneNumber?: string;
  quietHoursStart?: string; // HH:MM format
  quietHoursEnd?: string; // HH:MM format
  timezone?: string;
}

export interface DeliveryResult {
  notificationId: string;
  overallSuccess: boolean;
  channelResults: ChannelDeliveryResult[];
  deliveredAt: Date;
  failureReason?: string;
}

export interface ChannelDeliveryResult {
  channel: NotificationChannel;
  success: boolean;
  messageId?: string;
  error?: string;
  deliveredAt: Date;
  retryCount: number;
}

export interface RetryConfig {
  maxRetries: number;
  retryDelayMs: number;
  exponentialBackoff: boolean;
  retryableErrors: string[];
}

@Injectable()
export class DeliveryOrchestrationService {
  private readonly logger = new Logger(DeliveryOrchestrationService.name);

  private readonly defaultRetryConfig: RetryConfig = {
    maxRetries: 3,
    retryDelayMs: 1000,
    exponentialBackoff: true,
    retryableErrors: [
      'NETWORK_ERROR',
      'TIMEOUT',
      'RATE_LIMITED',
      'TEMPORARY_FAILURE',
      'SERVICE_UNAVAILABLE',
    ],
  };

  constructor(
    private readonly pushNotificationService: PushNotificationService,
    private readonly emailNotificationService: EmailNotificationService,
    private readonly notificationRepository: NotificationRepository,
  ) {}

  /**
   * Orchestrate notification delivery across multiple channels
   */
  async deliverNotification(request: DeliveryRequest): Promise<DeliveryResult> {
    this.logger.log(
      `Starting delivery orchestration for notification ${request.notificationId}`,
    );

    const channelResults: ChannelDeliveryResult[] = [];
    let overallSuccess = false;

    try {
      // Check quiet hours if user preferences are provided
      if (
        request.userPreferences &&
        this.isInQuietHours(request.userPreferences)
      ) {
        // For non-urgent notifications, defer delivery
        if (request.priority !== NotificationPriority.URGENT) {
          this.logger.log(
            `Deferring notification ${request.notificationId} due to quiet hours`,
          );
          await this.scheduleForLaterDelivery(request);
          return {
            notificationId: request.notificationId,
            overallSuccess: false,
            channelResults: [],
            deliveredAt: new Date(),
            failureReason: 'Deferred due to quiet hours',
          };
        }
      }

      // Determine optimal channel order based on priority and user preferences
      const orderedChannels = this.determineChannelOrder(
        request.channels,
        request.priority,
        request.userPreferences,
      );

      // Attempt delivery on each channel
      for (const channel of orderedChannels) {
        if (!this.isChannelEnabled(channel, request.userPreferences)) {
          this.logger.log(
            `Skipping disabled channel ${channel} for user ${request.userId}`,
          );
          continue;
        }

        const channelResult = await this.deliverToChannel(request, channel);
        channelResults.push(channelResult);

        // For high-priority notifications, try all channels
        // For normal priority, stop after first successful delivery
        if (
          channelResult.success &&
          request.priority !== NotificationPriority.URGENT &&
          request.priority !== NotificationPriority.HIGH
        ) {
          overallSuccess = true;
          break;
        }

        if (channelResult.success) {
          overallSuccess = true;
        }
      }

      // Update notification status in database
      await this.updateNotificationStatus(
        request.notificationId,
        overallSuccess,
        channelResults,
      );

      const result: DeliveryResult = {
        notificationId: request.notificationId,
        overallSuccess,
        channelResults,
        deliveredAt: new Date(),
      };

      if (!overallSuccess) {
        result.failureReason = 'All delivery channels failed';
      }

      this.logger.log(
        `Delivery orchestration completed for notification ${request.notificationId}: ${overallSuccess ? 'SUCCESS' : 'FAILED'}`,
      );

      return result;
    } catch (error) {
      this.logger.error(
        `Delivery orchestration failed for notification ${request.notificationId}:`,
        error,
      );

      await this.updateNotificationStatus(
        request.notificationId,
        false,
        channelResults,
      );

      return {
        notificationId: request.notificationId,
        overallSuccess: false,
        channelResults,
        deliveredAt: new Date(),
        failureReason: error instanceof Error ? error.message : 'Unknown error',
      };
    }
  }

  /**
   * Deliver notification to a specific channel with retry logic
   */
  private async deliverToChannel(
    request: DeliveryRequest,
    channel: NotificationChannel,
    retryCount = 0,
  ): Promise<ChannelDeliveryResult> {
    try {
      let deliveryResult: PushDeliveryResult | EmailDeliveryResult | null =
        null;

      switch (channel) {
        case NotificationChannel.PUSH:
          deliveryResult = await this.deliverPushNotification(request);
          break;
        case NotificationChannel.EMAIL:
          deliveryResult = await this.deliverEmailNotification(request);
          break;
        case NotificationChannel.SMS:
          // SMS delivery would be implemented here
          this.logger.warn('SMS delivery not yet implemented');
          deliveryResult = {
            success: false,
            error: 'SMS not implemented',
            recipients: [],
            deliveredAt: new Date(),
          };
          break;
        case NotificationChannel.IN_APP:
          // In-app notifications are handled differently (stored in database)
          deliveryResult = await this.deliverInAppNotification(request);
          break;
        default:
          throw new Error(`Unsupported channel: ${String(channel)}`);
      }

      if (deliveryResult.success) {
        return {
          channel,
          success: true,
          messageId: deliveryResult.messageId,
          deliveredAt: new Date(),
          retryCount,
        };
      } else {
        // Check if error is retryable
        if (
          this.isRetryableError(deliveryResult.error) &&
          retryCount < this.defaultRetryConfig.maxRetries
        ) {
          this.logger.warn(
            `Retrying delivery to ${channel} for notification ${request.notificationId} (attempt ${retryCount + 1})`,
          );

          // Wait before retry with exponential backoff
          const delay = this.calculateRetryDelay(retryCount);
          await this.sleep(delay);

          return this.deliverToChannel(request, channel, retryCount + 1);
        }

        return {
          channel,
          success: false,
          error: deliveryResult.error,
          deliveredAt: new Date(),
          retryCount,
        };
      }
    } catch (error) {
      this.logger.error(
        `Failed to deliver to ${channel} for notification ${request.notificationId}:`,
        error,
      );

      // Check if error is retryable
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      if (
        this.isRetryableError(errorMessage) &&
        retryCount < this.defaultRetryConfig.maxRetries
      ) {
        this.logger.warn(
          `Retrying delivery to ${channel} for notification ${request.notificationId} (attempt ${retryCount + 1})`,
        );

        const delay = this.calculateRetryDelay(retryCount);
        await this.sleep(delay);

        return this.deliverToChannel(request, channel, retryCount + 1);
      }

      return {
        channel,
        success: false,
        error: errorMessage,
        deliveredAt: new Date(),
        retryCount,
      };
    }
  }

  /**
   * Deliver push notification
   */
  private async deliverPushNotification(
    request: DeliveryRequest,
  ): Promise<PushDeliveryResult> {
    const tokens = request.userPreferences?.pushTokens || [];

    if (tokens.length === 0) {
      return {
        success: false,
        error: 'No push tokens available',
        token: '',
      };
    }

    const payload = this.pushNotificationService.createHealthcareNotification(
      request.title,
      request.message,
      this.mapNotificationTypeForPush(
        (request.metadata?.type as string) || 'health_alert',
      ),
      request.metadata,
    );

    // For multiple tokens, use batch delivery
    if (tokens.length > 1) {
      const results = await this.pushNotificationService.sendBatchNotification({
        tokens,
        payload,
        priority:
          request.priority === NotificationPriority.URGENT ? 'high' : 'normal',
      });

      const successfulDeliveries = results.filter((r) => r.success);

      return {
        success: successfulDeliveries.length > 0,
        messageId: successfulDeliveries[0]?.messageId,
        error:
          successfulDeliveries.length === 0
            ? 'All push deliveries failed'
            : undefined,
        token: tokens[0],
      };
    } else {
      return this.pushNotificationService.sendToToken(tokens[0], payload, {
        priority:
          request.priority === NotificationPriority.URGENT ? 'high' : 'normal',
      });
    }
  }

  /**
   * Deliver email notification
   */
  private async deliverEmailNotification(
    request: DeliveryRequest,
  ): Promise<EmailDeliveryResult> {
    const emailAddress = request.userPreferences?.emailAddress;

    if (!emailAddress) {
      return {
        success: false,
        error: 'No email address available',
        recipients: [],
        deliveredAt: new Date(),
      };
    }

    // Use appropriate email template based on notification type
    const notificationType =
      (request.metadata?.type as string) || 'health_alert';

    switch (notificationType) {
      case 'medication_reminder':
        return this.emailNotificationService.sendMedicationReminder(
          emailAddress,
          (request.metadata?.medicationName as string) || 'Unknown Medication',
          (request.metadata?.dosage as string) || 'As prescribed',
          new Date(
            (request.metadata?.scheduledTime as string | number | Date) ||
              Date.now(),
          ),
          (request.metadata?.patientName as string) || 'Patient',
        );
      case 'appointment_reminder':
        return this.emailNotificationService.sendAppointmentReminder(
          emailAddress,
          (request.metadata?.appointmentType as string) ||
            'Medical Appointment',
          new Date(
            (request.metadata?.appointmentDate as string | number | Date) ||
              Date.now(),
          ),
          (request.metadata?.providerName as string) || 'Healthcare Provider',
          (request.metadata?.location as string) || 'Healthcare Facility',
          (request.metadata?.patientName as string) || 'Patient',
        );
      case 'emergency_alert':
        return this.emailNotificationService.sendEmergencyAlert(
          emailAddress,
          (request.metadata?.alertType as string) || 'Emergency Alert',
          request.message,
          (request.metadata?.patientName as string) || 'Patient',
          request.metadata?.emergencyContacts as string[] | undefined,
        );
      default:
        return this.emailNotificationService.sendEmail({
          to: emailAddress,
          subject: request.title,
          text: request.message,
          priority:
            request.priority === NotificationPriority.URGENT
              ? 'high'
              : 'normal',
        });
    }
  }

  /**
   * Deliver in-app notification (store in database)
   */
  private async deliverInAppNotification(request: DeliveryRequest): Promise<{
    success: boolean;
    messageId?: string;
    error?: string;
    recipients: string[];
    deliveredAt: Date;
  }> {
    try {
      // In-app notifications are already stored in the database when the notification is created
      // This method just marks it as delivered
      await this.notificationRepository.markAsDelivered(request.notificationId);

      return {
        success: true,
        messageId: request.notificationId,
        recipients: [request.userId],
        deliveredAt: new Date(),
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        recipients: [request.userId],
        deliveredAt: new Date(),
      };
    }
  }

  /**
   * Determine optimal channel order based on priority and preferences
   */
  private determineChannelOrder(
    channels: NotificationChannel[],
    priority: NotificationPriority,
    preferences?: UserNotificationPreferences,
  ): NotificationChannel[] {
    // For urgent notifications, prioritize push notifications first
    if (priority === NotificationPriority.URGENT) {
      return [
        NotificationChannel.PUSH,
        NotificationChannel.EMAIL,
        NotificationChannel.SMS,
        NotificationChannel.IN_APP,
      ].filter((channel) => channels.includes(channel));
    }

    // For normal notifications, respect user preferences
    const orderedChannels = [...channels];

    // Sort based on user preferences (push first if enabled, then email)
    orderedChannels.sort((a, b) => {
      if (a === NotificationChannel.PUSH && preferences?.pushEnabled) return -1;
      if (b === NotificationChannel.PUSH && preferences?.pushEnabled) return 1;
      if (a === NotificationChannel.EMAIL && preferences?.emailEnabled)
        return -1;
      if (b === NotificationChannel.EMAIL && preferences?.emailEnabled)
        return 1;
      return 0;
    });

    return orderedChannels;
  }

  /**
   * Check if a channel is enabled for the user
   */
  private isChannelEnabled(
    channel: NotificationChannel,
    preferences?: UserNotificationPreferences,
  ): boolean {
    if (!preferences) return true;

    switch (channel) {
      case NotificationChannel.PUSH:
        return (
          preferences.pushEnabled && (preferences.pushTokens?.length || 0) > 0
        );
      case NotificationChannel.EMAIL:
        return preferences.emailEnabled && !!preferences.emailAddress;
      case NotificationChannel.SMS:
        return preferences.smsEnabled && !!preferences.phoneNumber;
      case NotificationChannel.IN_APP:
        return true; // In-app notifications are always enabled
      default:
        return true;
    }
  }

  /**
   * Check if current time is within user's quiet hours
   */
  private isInQuietHours(preferences: UserNotificationPreferences): boolean {
    if (!preferences.quietHoursStart || !preferences.quietHoursEnd) {
      return false;
    }

    const now = new Date();
    const timezone = preferences.timezone || 'UTC';

    // Convert current time to user's timezone
    const userTime = new Date(
      now.toLocaleString('en-US', { timeZone: timezone }),
    );
    const currentHour = userTime.getHours();
    const currentMinute = userTime.getMinutes();
    const currentTimeMinutes = currentHour * 60 + currentMinute;

    const [startHour, startMinute] = preferences.quietHoursStart
      .split(':')
      .map(Number);
    const [endHour, endMinute] = preferences.quietHoursEnd
      .split(':')
      .map(Number);

    const startTimeMinutes = startHour * 60 + startMinute;
    const endTimeMinutes = endHour * 60 + endMinute;

    // Handle overnight quiet hours (e.g., 22:00 to 06:00)
    if (startTimeMinutes > endTimeMinutes) {
      return (
        currentTimeMinutes >= startTimeMinutes ||
        currentTimeMinutes <= endTimeMinutes
      );
    } else {
      return (
        currentTimeMinutes >= startTimeMinutes &&
        currentTimeMinutes <= endTimeMinutes
      );
    }
  }

  /**
   * Schedule notification for later delivery (outside quiet hours)
   */
  private async scheduleForLaterDelivery(
    request: DeliveryRequest,
  ): Promise<void> {
    // Calculate next delivery time (after quiet hours end)
    const deliveryTime = this.calculateNextDeliveryTime(
      request.userPreferences,
    );

    // Update notification with scheduled delivery time
    await this.notificationRepository.update(request.notificationId, {
      scheduledFor: deliveryTime,
      status: NotificationStatus.PENDING,
    });
  }

  /**
   * Calculate next delivery time after quiet hours
   */
  private calculateNextDeliveryTime(
    preferences?: UserNotificationPreferences,
  ): Date {
    if (!preferences?.quietHoursEnd) {
      return new Date(Date.now() + 60000); // Default: 1 minute from now
    }

    const now = new Date();
    const timezone = preferences.timezone || 'UTC';
    const userTime = new Date(
      now.toLocaleString('en-US', { timeZone: timezone }),
    );

    const [endHour, endMinute] = preferences.quietHoursEnd
      .split(':')
      .map(Number);

    const deliveryTime = new Date(userTime);
    deliveryTime.setHours(endHour, endMinute, 0, 0);

    // If quiet hours end time has already passed today, schedule for tomorrow
    if (deliveryTime <= userTime) {
      deliveryTime.setDate(deliveryTime.getDate() + 1);
    }

    return deliveryTime;
  }

  /**
   * Update notification status in database
   */
  private async updateNotificationStatus(
    notificationId: string,
    success: boolean,
    channelResults: ChannelDeliveryResult[],
  ): Promise<void> {
    try {
      if (success) {
        await this.notificationRepository.markAsDelivered(notificationId);
      } else {
        await this.notificationRepository.markAsFailed(notificationId);
      }

      // Store delivery results as metadata
      await this.notificationRepository.update(notificationId, {
        context: {
          deliveryResults: channelResults,
          lastDeliveryAttempt: new Date().toISOString(),
        },
      });
    } catch (error) {
      this.logger.error(
        `Failed to update notification status for ${notificationId}:`,
        error,
      );
    }
  }

  /**
   * Check if error is retryable
   */
  private isRetryableError(error?: string): boolean {
    if (!error) return false;

    return this.defaultRetryConfig.retryableErrors.some((retryableError) =>
      error.toLowerCase().includes(retryableError.toLowerCase()),
    );
  }

  /**
   * Calculate retry delay with exponential backoff
   */
  private calculateRetryDelay(retryCount: number): number {
    if (!this.defaultRetryConfig.exponentialBackoff) {
      return this.defaultRetryConfig.retryDelayMs;
    }

    return this.defaultRetryConfig.retryDelayMs * Math.pow(2, retryCount);
  }

  /**
   * Sleep for specified milliseconds
   */
  private sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  /**
   * Map notification type for push notifications
   */
  private mapNotificationTypeForPush(
    type: string,
  ): 'medication' | 'appointment' | 'health_alert' | 'emergency' {
    switch (type) {
      case 'medication_reminder':
        return 'medication';
      case 'appointment_reminder':
        return 'appointment';
      case 'emergency_alert':
        return 'emergency';
      default:
        return 'health_alert';
    }
  }
}
