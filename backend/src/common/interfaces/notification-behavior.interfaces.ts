import { UserNotificationBehavior } from '@prisma/client';

/**
 * Interface for context data in behavior notifications
 */
export interface BehaviorNotificationContextData {
  /** The content or subject of the notification */
  content?: string;

  /** Any related entity ID this notification refers to */
  entityId?: string;

  /** Type of the entity this notification refers to */
  entityType?: string;

  /** Any additional data relevant to this notification */
  additionalData?: Record<string, string | number | boolean>;

  /** Any specific priority information */
  priority?: 'low' | 'normal' | 'high';

  /** Was this a recurring notification */
  isRecurring?: boolean;
}

/**
 * Interface for behavior vector result
 */
export interface BehaviorVectorResult {
  /** Unique identifier */
  id: string;

  /** Associated user ID */
  userId: string;

  /** Vector representation */
  vector: number[];

  /** Associated metadata */
  metadata: {
    /** Timestamp in milliseconds */
    timestamp: number;

    /** Type of notification */
    notificationType: string;

    /** Action taken on notification */
    action: string;

    /** Hour of the day (0-23) */
    timeOfDay: number;

    /** Day of week (0-6, where 0 is Sunday) */
    dayOfWeek: number;

    /** Time to respond in milliseconds */
    responseTime?: number;

    /** Type of device used */
    deviceType?: string;
  };
}

/**
 * Interface for behavior summary statistics
 */
export interface BehaviorSummaryData {
  /** Total number of notifications */
  total_notifications: number;

  /** Actions taken, grouped by type */
  actions: Record<string, number>;

  /** Notification types with counts */
  notification_types: Record<string, number>;

  /** Distribution of interactions by hour */
  time_distribution: Record<string, number>;

  /** Distribution of interactions by day of week */
  day_distribution: Record<string, number>;

  /** Array of response times in milliseconds */
  response_times: number[];
}

/**
 * Interface for behavior vector parameters
 */
export interface BehaviorVectorParameters {
  /** Hour of day (0-23) */
  timeOfDay: number;

  /** Day of week (0-6, where 0 is Sunday) */
  dayOfWeek: number;

  /** Action taken on notification */
  action: string;

  /** Type of notification */
  notificationType: string;

  /** Time to respond in milliseconds */
  timeToAction?: number;

  /** Type of device used */
  deviceType?: string;

  /** Additional context data */
  contextData?: BehaviorNotificationContextData;
}
