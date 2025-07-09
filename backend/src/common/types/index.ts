/**
 * Common Types Index
 *
 * Central export point for all common types used across the CareCircle backend.
 * This file re-exports types from various modules to provide a single import point.
 */

// API and Request/Response types
export * from './api.types';

// Domain value objects (JSON-compatible interfaces)
export type {
  MessageMetadata,
  QueryIntent,
  Entity,
} from '../../ai-assistant/domain/value-objects/message.value-objects';

export type {
  ConversationMetadata,
  UserPreferences,
} from '../../ai-assistant/domain/value-objects/conversation.value-objects';

export type {
  Reference,
  Attachment,
  Source,
  VerificationLevel,
  ValidationResult,
} from '../../ai-assistant/domain/value-objects/shared.value-objects';

export type {
  BaselineMetrics,
  HealthCondition,
  Allergy,
  RiskFactor,
  HealthGoal,
} from '../../health-data/domain/entities/health-profile.entity';

// Prisma types (re-export commonly used ones for convenience)
export type {
  UserAccount,
  UserProfile,
  HealthProfile,
  HealthMetric,
  HealthDevice,
  Conversation,
  Message,
  Notification,
  // Enums from Prisma
  MetricType,
  DataSource,
  ValidationStatus,
  DeviceType,
  ConnectionStatus,
  ConversationStatus,
  MessageRole,
  NotificationType,
  NotificationPriority,
  NotificationStatus,
  Gender,
  Language,
  AuthMethodType,
  Role,
  Permission,
  DataAccessLevel,
} from '@prisma/client';

// Type utilities for working with Prisma types
export type PrismaModel = {
  id: string;
  createdAt: Date;
  updatedAt?: Date;
};

export type CreateInput<T> = Omit<T, 'id' | 'createdAt' | 'updatedAt'>;
export type UpdateInput<T> = Partial<Omit<T, 'id' | 'createdAt' | 'updatedAt'>>;

// Common type guards
export const isValidUUID = (value: string): boolean => {
  const uuidRegex =
    /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
  return uuidRegex.test(value);
};

export const isValidEmail = (value: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(value);
};

export const isValidPhoneNumber = (value: string): boolean => {
  const phoneRegex = /^\+?[1-9]\d{1,14}$/;
  return phoneRegex.test(value.replace(/\s/g, ''));
};
