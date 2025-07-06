import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  NotificationEvent,
  NotificationChannel,
  DeliveryStatus,
} from '@prisma/client';
import {
  AuditLogMetadata,
  ChannelDeliveryStats,
  NotificationDeliveryStats,
} from '../common/interfaces/audit-logging.interfaces';

export interface AuditLogEntry {
  notificationId: string;
  event: NotificationEvent;
  channel: NotificationChannel;
  status: DeliveryStatus;
  deliveryId?: string;
  providerId?: string;
  errorCode?: string;
  errorMessage?: string;
  processingTime?: number;
  retryCount?: number;
  metadata?: AuditLogMetadata;
}

export interface DeliveryLogEntry {
  notificationId: string;
  channel: NotificationChannel;
  deliveryStatus: DeliveryStatus;
  deliveryTime?: Date;
  externalId?: string;
  providerName?: string;
  openedAt?: Date;
  clickedAt?: Date;
  errorCode?: string;
  errorMessage?: string;
  latency?: number;
}

@Injectable()
export class NotificationAuditLoggingService {
  private readonly logger = new Logger(NotificationAuditLoggingService.name);

  constructor(private readonly prisma: PrismaService) {}

  /**
   * Log a notification audit event
   */
  async logAuditEvent(entry: AuditLogEntry): Promise<void> {
    try {
      await this.prisma.notificationAuditLog.create({
        data: {
          notificationId: entry.notificationId,
          event: entry.event,
          channel: entry.channel,
          status: entry.status,
          deliveryId: entry.deliveryId,
          providerId: entry.providerId,
          errorCode: entry.errorCode,
          errorMessage: entry.errorMessage,
          processingTime: entry.processingTime,
          retryCount: entry.retryCount,
          metadata: entry.metadata,
        },
      });

      this.logger.debug(
        `Audit log created for notification ${entry.notificationId}: ${entry.event} - ${entry.status}`,
      );
    } catch (error) {
      this.logger.error(
        `Failed to create audit log for notification ${entry.notificationId}:`,
        error,
      );
      // Don't throw error to prevent blocking the main notification flow
    }
  }

  /**
   * Log delivery tracking information
   */
  async logDeliveryEvent(entry: DeliveryLogEntry): Promise<void> {
    try {
      await this.prisma.notificationDeliveryLog.create({
        data: {
          notificationId: entry.notificationId,
          channel: entry.channel,
          deliveryStatus: entry.deliveryStatus,
          deliveryTime: entry.deliveryTime,
          externalId: entry.externalId,
          providerName: entry.providerName,
          openedAt: entry.openedAt,
          clickedAt: entry.clickedAt,
          errorCode: entry.errorCode,
          errorMessage: entry.errorMessage,
          latency: entry.latency,
        },
      });

      this.logger.debug(
        `Delivery log created for notification ${entry.notificationId}: ${entry.deliveryStatus}`,
      );
    } catch (error) {
      this.logger.error(
        `Failed to create delivery log for notification ${entry.notificationId}:`,
        error,
      );
      // Don't throw error to prevent blocking the main notification flow
    }
  }

  /**
   * Log notification creation
   */
  async logNotificationCreated(
    notificationId: string,
    channels: NotificationChannel[],
    processingTime?: number,
  ): Promise<void> {
    const promises = channels.map((channel) =>
      this.logAuditEvent({
        notificationId,
        event: NotificationEvent.CREATED,
        channel,
        status: DeliveryStatus.PENDING,
        processingTime,
      }),
    );

    await Promise.allSettled(promises);
  }

  /**
   * Log notification queued
   */
  async logNotificationQueued(
    notificationId: string,
    channels: NotificationChannel[],
    queueDelay?: number,
  ): Promise<void> {
    const promises = channels.map((channel) =>
      this.logAuditEvent({
        notificationId,
        event: NotificationEvent.QUEUED,
        channel,
        status: DeliveryStatus.PENDING,
        metadata: queueDelay ? { queueDelay } : undefined,
      }),
    );

    await Promise.allSettled(promises);
  }

  /**
   * Log notification processing
   */
  async logNotificationProcessing(
    notificationId: string,
    channel: NotificationChannel,
  ): Promise<void> {
    await this.logAuditEvent({
      notificationId,
      event: NotificationEvent.PROCESSING,
      channel,
      status: DeliveryStatus.PROCESSING,
    });
  }

  /**
   * Log notification sent
   */
  async logNotificationSent(
    notificationId: string,
    channel: NotificationChannel,
    deliveryId?: string,
    providerId?: string,
    processingTime?: number,
  ): Promise<void> {
    await this.logAuditEvent({
      notificationId,
      event: NotificationEvent.SENT,
      channel,
      status: DeliveryStatus.SENT,
      deliveryId,
      providerId,
      processingTime,
    });

    // Also log in delivery tracking
    await this.logDeliveryEvent({
      notificationId,
      channel,
      deliveryStatus: DeliveryStatus.SENT,
      deliveryTime: new Date(),
      externalId: deliveryId,
      providerName: this.getProviderName(channel),
      latency: processingTime,
    });
  }

  /**
   * Log notification delivered
   */
  async logNotificationDelivered(
    notificationId: string,
    channel: NotificationChannel,
    deliveryId?: string,
    latency?: number,
  ): Promise<void> {
    await this.logAuditEvent({
      notificationId,
      event: NotificationEvent.DELIVERED,
      channel,
      status: DeliveryStatus.DELIVERED,
      deliveryId,
      processingTime: latency,
    });

    // Update delivery tracking
    await this.logDeliveryEvent({
      notificationId,
      channel,
      deliveryStatus: DeliveryStatus.DELIVERED,
      deliveryTime: new Date(),
      externalId: deliveryId,
      latency,
    });
  }

  /**
   * Log notification failure
   */
  async logNotificationFailed(
    notificationId: string,
    channel: NotificationChannel,
    error: Error,
    retryCount: number = 0,
    errorCode?: string,
  ): Promise<void> {
    await this.logAuditEvent({
      notificationId,
      event: NotificationEvent.FAILED,
      channel,
      status: DeliveryStatus.FAILED,
      errorCode: errorCode || error.name,
      errorMessage: error.message,
      retryCount,
    });

    // Also log in delivery tracking
    await this.logDeliveryEvent({
      notificationId,
      channel,
      deliveryStatus: DeliveryStatus.FAILED,
      errorCode: errorCode || error.name,
      errorMessage: error.message,
    });
  }

  /**
   * Log notification retry
   */
  async logNotificationRetry(
    notificationId: string,
    channel: NotificationChannel,
    retryCount: number,
    error?: Error,
  ): Promise<void> {
    await this.logAuditEvent({
      notificationId,
      event: NotificationEvent.RETRIED,
      channel,
      status: DeliveryStatus.PENDING,
      retryCount,
      errorMessage: error?.message,
    });
  }

  /**
   * Log notification opened
   */
  async logNotificationOpened(
    notificationId: string,
    channel: NotificationChannel,
    metadata?: AuditLogMetadata,
  ): Promise<void> {
    await this.logAuditEvent({
      notificationId,
      event: NotificationEvent.OPENED,
      channel,
      status: DeliveryStatus.OPENED,
      metadata,
    });

    // Update delivery tracking
    const existingLog = await this.prisma.notificationDeliveryLog.findFirst({
      where: { notificationId, channel },
      orderBy: { createdAt: 'desc' },
    });

    if (existingLog) {
      await this.prisma.notificationDeliveryLog.update({
        where: { id: existingLog.id },
        data: {
          deliveryStatus: DeliveryStatus.OPENED,
          openedAt: new Date(),
        },
      });
    }
  }

  /**
   * Log notification clicked
   */
  async logNotificationClicked(
    notificationId: string,
    channel: NotificationChannel,
    metadata?: AuditLogMetadata,
  ): Promise<void> {
    await this.logAuditEvent({
      notificationId,
      event: NotificationEvent.CLICKED,
      channel,
      status: DeliveryStatus.CLICKED,
      metadata,
    });

    // Update delivery tracking
    const existingLog = await this.prisma.notificationDeliveryLog.findFirst({
      where: { notificationId, channel },
      orderBy: { createdAt: 'desc' },
    });

    if (existingLog) {
      await this.prisma.notificationDeliveryLog.update({
        where: { id: existingLog.id },
        data: {
          deliveryStatus: DeliveryStatus.CLICKED,
          clickedAt: new Date(),
        },
      });
    }
  }

  /**
   * Get audit logs for a notification
   */
  async getAuditLogs(notificationId: string) {
    return this.prisma.notificationAuditLog.findMany({
      where: { notificationId },
      orderBy: { createdAt: 'asc' },
    });
  }

  /**
   * Get delivery logs for a notification
   */
  async getDeliveryLogs(notificationId: string) {
    return this.prisma.notificationDeliveryLog.findMany({
      where: { notificationId },
      orderBy: { createdAt: 'asc' },
    });
  }

  /**
   * Get delivery statistics for a user
   */
  async getDeliveryStats(userId: string, days: number = 30) {
    try {
      const fromDate = new Date();
      fromDate.setDate(fromDate.getDate() - days);

      const notifications = await this.prisma.notification.findMany({
        where: {
          userId,
          createdAt: { gte: fromDate },
        },
        include: {
          auditLogs: true,
        },
      });

      const stats: NotificationDeliveryStats = {
        total: notifications.length,
        byStatus: {
          success: 0,
          failure: 0,
          pending: 0,
        },
        byChannel: {} as ChannelDeliveryStats,
      };

      notifications.forEach((notification) => {
        notification.auditLogs.forEach((log) => {
          switch (log.status) {
            case DeliveryStatus.SENT:
            case DeliveryStatus.DELIVERED:
              stats.byStatus.success++;
              break;
            case DeliveryStatus.FAILED:
              stats.byStatus.failure++;
              break;
            case DeliveryStatus.PENDING:
            case DeliveryStatus.PROCESSING:
              stats.byStatus.pending++;
              break;
          }

          // Channel statistics
          if (!stats.byChannel[log.channel]) {
            stats.byChannel[log.channel] = {
              total: 0,
              success: 0,
              failure: 0,
              pending: 0,
              sent: 0,
              delivered: 0,
              failed: 0,
              opened: 0,
              clicked: 0,
            };
          }

          stats.byChannel[log.channel].total++;

          if (log.status === DeliveryStatus.SENT)
            stats.byChannel[log.channel].sent++;
          if (log.status === DeliveryStatus.DELIVERED)
            stats.byChannel[log.channel].delivered++;
          if (log.status === DeliveryStatus.FAILED)
            stats.byChannel[log.channel].failed++;

          // Track opened and clicked events
          if (log.event === NotificationEvent.OPENED)
            stats.byChannel[log.channel].opened++;
          if (log.event === NotificationEvent.CLICKED)
            stats.byChannel[log.channel].clicked++;
        });
      });

      return stats;
    } catch (error) {
      this.logger.error(
        `Failed to get delivery stats for user ${userId}:`,
        error,
      );
      throw error;
    }
  }

  /**
   * Get provider name for a channel
   */
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
