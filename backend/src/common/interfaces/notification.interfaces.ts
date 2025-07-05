import {
  NotificationType,
  NotificationChannel,
  NotificationPriority,
  Notification,
  Reminder,
  User,
  Prescription,
  CareGroup,
} from '@prisma/client';
import { CheckInInsight } from './daily-check-in.interfaces';

/**
 * Interface for interactive notification options
 */
export interface InteractiveNotificationOptions {
  userId: string;
  triggerType: InteractiveTriggerType;
  triggerData: unknown;
  priority: NotificationPriorityLevel;
  actions?: InteractiveAction[];
}

/**
 * Type for interactive trigger types
 */
export type InteractiveTriggerType =
  | 'insight'
  | 'risk_alert'
  | 'follow_up'
  | 'engagement';

/**
 * Type for notification priority levels
 */
export type NotificationPriorityLevel = 'low' | 'medium' | 'high' | 'critical';

/**
 * Interface for interactive action
 */
export interface InteractiveAction {
  id: string;
  label: string;
  type: InteractiveActionType;
  payload?: unknown;
}

/**
 * Type for interactive action types
 */
export type InteractiveActionType =
  | 'quick_response'
  | 'navigate'
  | 'schedule'
  | 'contact';

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
 * Interface for notification payload
 */
export interface NotificationPayload {
  userId: string;
  title: string;
  message: string;
  type: NotificationType;
  channels: NotificationChannel[];
  priority?: NotificationPriority;
  actionUrl?: string;
  scheduledFor?: Date;
  templateData?: NotificationTemplateData;
}

/**
 * Interface for notification template data
 */
export interface NotificationTemplateData {
  medicationName?: string;
  dosage?: string;
  frequency?: string;
  userName?: string;
  actions?: InteractiveAction[];
  triggerType?: string;
  [key: string]: unknown;
}

/**
 * Interface for medication reminder data
 */
export interface ReminderData {
  id: string;
  prescriptionId: string;
  userId: string;
  medicationName: string;
  dosage: string;
  scheduledAt: Date;
  frequency: string;
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
  contextData?: Record<string, unknown>;
}

/**
 * Interface for notification test options
 */
export interface TestNotificationOptions {
  userId: string;
  checkInData?: Record<string, unknown>;
  insights?: CheckInInsight[];
}

/**
 * Interface for weekly health insights
 */
export interface WeeklyHealthInsights {
  summary: string;
  metrics: Record<string, unknown>;
}

/**
 * Interface for care group summary
 */
export interface CareGroupSummary {
  activities: number;
  newMembers: number;
}

/**
 * Interface for prescription with associated metadata
 */
export interface PrescriptionWithMetadata extends Prescription {
  medication: {
    name: string;
    dosage: string;
    frequency: string;
  };
}

/**
 * Basic health insight interface
 */
export interface HealthInsight {
  type: string;
  description: string;
  severity: string;
}
