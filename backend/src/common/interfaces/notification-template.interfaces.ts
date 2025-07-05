import {
  NotificationChannel,
  NotificationPriority,
  NotificationType,
} from '@prisma/client';
import { TemplateMetadata } from '../../notification/template-rendering.service';

/**
 * Interface for creating a notification template
 */
export interface CreateTemplateDto {
  name: string;
  description?: string;
  type: NotificationType;
  titleTemplate: string;
  messageTemplate: string;
  placeholders: TemplateMetadata['placeholders'];
  channels?: NotificationChannel[];
  defaultPriority?: NotificationPriority;
  language?: string;
}

/**
 * Interface for updating a notification template
 */
export interface UpdateTemplateDto {
  name?: string;
  description?: string;
  titleTemplate?: string;
  messageTemplate?: string;
  placeholders?: TemplateMetadata['placeholders'];
  channels?: NotificationChannel[];
  defaultPriority?: NotificationPriority;
  isActive?: boolean;
  language?: string;
}

/**
 * Interface for a rendered template
 */
export interface RenderedTemplate {
  title: string;
  message: string;
  channels: NotificationChannel[];
  priority: NotificationPriority;
  templateId: string;
  templateName: string;
}

/**
 * Interface for user preferences for templates
 */
export interface UserTemplatePreferences {
  language?: string;
  channels?: NotificationChannel[];
}

/**
 * Interface for medication context
 */
export interface MedicationContextData {
  userId: string;
  userName: string;
  firstName: string;
  lastName?: string;
  medicationName: string;
  dosage: string;
  schedule: string;
  instructions?: string;
  remainingDays?: number;
}

/**
 * Interface for care group context
 */
export interface CareGroupContextData {
  userId: string;
  userName: string;
  firstName: string;
  lastName?: string;
  careGroupId: string;
  careGroupName: string;
  memberCount: number;
  role: string;
}

/**
 * Interface for health alert context
 */
export interface HealthAlertContextData {
  userId: string;
  userName: string;
  firstName: string;
  lastName?: string;
  alertType: string;
  alertSeverity: string;
  metricName: string;
  metricValue: number;
  metricUnit?: string;
  thresholdValue?: number;
  recommendation?: string;
}
