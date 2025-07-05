/**
 * Interfaces for notification tracking
 */

import { NotificationChannel } from '@prisma/client';

/**
 * Interface for notification tracking metadata
 */
export interface NotificationTrackingMetadata {
  deviceId?: string;
  deviceType?: string;
  platform?: string;
  appVersion?: string;
  clickedElement?: string;
  ipAddress?: string;
  userAgent?: string;
  timestamp?: Date;
  sessionId?: string;
  geolocation?: {
    latitude?: number;
    longitude?: number;
  };
  [key: string]: unknown;
}

/**
 * Interface for notification tracking data
 */
export interface NotificationTrackingData {
  channel: NotificationChannel;
  metadata?: NotificationTrackingMetadata;
}

/**
 * Interface for notification context data
 */
export interface NotificationContextData {
  templateName: string;
  context: Record<string, unknown>;
  scheduledFor?: Date;
}

/**
 * Interface for notification template context
 */
export interface NotificationTemplateContext {
  [key: string]: string | number | boolean | Date | null | undefined;
}

/**
 * Interface for notification delivery statistics
 */
export interface NotificationDeliveryStats {
  total: number;
  delivered: number;
  failed: number;
  opened: number;
  clicked: number;
  byChannel: {
    [key in NotificationChannel]?: {
      sent: number;
      delivered: number;
      opened: number;
      clicked: number;
    };
  };
  byType: {
    [type: string]: {
      sent: number;
      opened: number;
      clicked: number;
    };
  };
}
