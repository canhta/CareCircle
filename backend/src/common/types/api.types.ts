/**
 * Common API Types for CareCircle Backend
 *
 * This file contains shared types for API contracts, request/response DTOs,
 * and common patterns that don't duplicate Prisma-generated types.
 */

// =============================================================================
// API Response Types
// =============================================================================

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  message?: string;
  errors?: string[];
  meta?: ResponseMetadata;
}

export interface ResponseMetadata {
  timestamp: string;
  requestId?: string;
  pagination?: PaginationMetadata;
  version?: string;
}

export interface PaginationMetadata {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
  hasNext: boolean;
  hasPrevious: boolean;
}

// =============================================================================
// Request Types
// =============================================================================

export interface PaginationQuery {
  page?: number;
  limit?: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}

export interface DateRangeQuery {
  startDate?: string | Date;
  endDate?: string | Date;
}

export interface SearchQuery {
  query?: string;
  filters?: Record<string, any>;
}

// =============================================================================
// Authentication Types
// =============================================================================

export interface AuthenticatedUser {
  uid: string;
  email?: string;
  phoneNumber?: string;
  isEmailVerified: boolean;
  isPhoneVerified: boolean;
  isGuest: boolean;
  roles: string[];
  permissions: string[];
}

export interface AuthenticatedRequest {
  user?: {
    id: string;
    email?: string;
    uid: string;
  };
}

export interface JwtPayload {
  sub: string;
  email?: string;
  iat: number;
  exp: number;
  aud: string;
  iss: string;
}

// =============================================================================
// Health Data API Types
// =============================================================================

export interface HealthMetricCreateRequest {
  metricType: string;
  value: number;
  unit: string;
  timestamp?: Date;
  source?: string;
  deviceId?: string;
  notes?: string;
  isManualEntry?: boolean;
  metadata?: Record<string, any>;
}

export interface HealthMetricUpdateRequest {
  value?: number;
  unit?: string;
  notes?: string;
  metadata?: Record<string, any>;
}

export interface HealthMetricQuery extends PaginationQuery, DateRangeQuery {
  metricType?: string;
  source?: string;
  deviceId?: string;
  validationStatus?: string;
}

// =============================================================================
// Device API Types
// =============================================================================

export interface HealthDeviceCreateRequest {
  deviceType: string;
  manufacturer: string;
  model: string;
  serialNumber?: string;
  settings?: Record<string, any>;
}

export interface HealthDeviceUpdateRequest {
  connectionStatus?: string;
  batteryLevel?: number;
  firmware?: string;
  settings?: Record<string, any>;
}

// =============================================================================
// AI Assistant API Types
// =============================================================================

export interface ConversationCreateRequest {
  title?: string;
  metadata?: Record<string, any>;
}

export interface MessageCreateRequest {
  content: string;
  attachments?: AttachmentData[];
}

export interface AttachmentData {
  type: 'image' | 'document' | 'audio' | 'chart';
  url: string;
  contentType: string;
  size: number;
  metadata?: Record<string, any>;
}

// =============================================================================
// Error Types
// =============================================================================

export interface ValidationError {
  field: string;
  message: string;
  code: string;
  value?: any;
}

export interface BusinessError {
  code: string;
  message: string;
  details?: Record<string, any>;
}

// =============================================================================
// Utility Types
// =============================================================================

export type Nullable<T> = T | null;
export type Optional<T> = T | undefined;
export type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P];
};

export interface TimestampedEntity {
  createdAt: Date;
  updatedAt: Date;
}

export interface SoftDeletableEntity extends TimestampedEntity {
  deletedAt?: Date;
}

// =============================================================================
// Health Context Types (for AI Assistant)
// =============================================================================

export interface HealthContext {
  userId: string;
  recentMetrics: HealthMetricSummary[];
  activeConditions: string[];
  currentMedications: string[];
  riskFactors: string[];
  preferences: UserHealthPreferences;
}

export interface HealthMetricSummary {
  metricType: string;
  latestValue: number;
  unit: string;
  timestamp: Date;
  trend?: 'increasing' | 'decreasing' | 'stable';
  isWithinNormalRange: boolean;
}

export interface UserHealthPreferences {
  units: {
    weight: 'kg' | 'lb';
    height: 'cm' | 'ft';
    temperature: 'c' | 'f';
    glucose: 'mmol/L' | 'mg/dL';
  };
  language: 'en' | 'vi';
  timezone: string;
}

// =============================================================================
// Export all types
// =============================================================================

export * from './api.types';
