import {
  NotificationType,
  NotificationChannel,
  NotificationPriority,
} from '@prisma/client';
import { CheckInInsight } from './daily-check-in.interfaces';

/**
 * Interface for interactive notification options
 */
export interface InteractiveNotificationOptions {
  userId: string;
  triggerType: 'insight' | 'risk_alert' | 'follow_up' | 'engagement';
  triggerData: any;
  priority: 'low' | 'medium' | 'high' | 'critical';
  actions?: InteractiveAction[];
}

/**
 * Interface for interactive action
 */
export interface InteractiveAction {
  id: string;
  label: string;
  type: 'quick_response' | 'navigate' | 'schedule' | 'contact';
  payload?: any;
}

/**
 * Interface for notification data
 */
export interface NotificationData {
  userId: string;
  title: string;
  message: string;
  type: NotificationType;
  channels: NotificationChannel[];
  priority: NotificationPriority;
  actionUrl: string;
  templateData: {
    actions?: InteractiveAction[];
    triggerType: string;
    [key: string]: any;
  };
}

/**
 * Interface for user interaction tracking
 */
export interface UserInteractionData {
  userId: string;
  notificationId: string;
  action: string;
  deviceType: string;
  timestamp: Date;
  timeOfDay: number;
  dayOfWeek: number;
  notificationType: string;
  contextData?: Record<string, any>;
}

/**
 * Interface for notification test options
 */
export interface TestNotificationOptions {
  userId: string;
  checkInData?: Record<string, any>;
  insights?: CheckInInsight[];
}
