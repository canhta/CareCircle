/**
 * Interfaces for audit logging functionality
 */

/**
 * Represents metadata for audit logs
 * This needs to be compatible with Prisma's JSON type
 */
export interface AuditLogMetadata {
  [key: string]: unknown;
}

/**
 * Notification audit log entry
 */
export interface NotificationAuditLogEntry {
  id: string;
  notificationId: string;
  action: string;
  userId?: string;
  timestamp: Date;
  metadata?: AuditLogMetadata;
}

/**
 * Notification delivery log entry
 */
export interface NotificationDeliveryLogEntry {
  id: string;
  notificationId: string;
  channel: string;
  status: string;
  timestamp: Date;
  metadata?: AuditLogMetadata;
}

/**
 * Channel delivery statistics
 */
export interface ChannelDeliveryStats {
  [key: string]: {
    total: number;
    success: number;
    failure: number;
    pending: number;
    sent: number;
    delivered: number;
    failed: number;
    opened: number;
    clicked: number;
  };
}

/**
 * Notification delivery statistics
 */
export interface NotificationDeliveryStats {
  total: number;
  byStatus: {
    success: number;
    failure: number;
    pending: number;
  };
  byChannel: ChannelDeliveryStats;
}
