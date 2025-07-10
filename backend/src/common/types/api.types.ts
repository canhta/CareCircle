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
// Job Queue Types
// =============================================================================

export interface CriticalAlertJobData {
  userId: string;
  alertId: string;
  alertType: string;
  priority: string;
  message: string;
  healthcareProviderAlert: boolean;
  emergencyServicesAlert: boolean;
  immediateActions: string[];
}

export interface ValidationMetricsJobData {
  userId: string;
  metricType: string;
  validationResult: ValidationResult;
}

export interface HealthcareProviderNotificationData {
  userId: string;
  providerId?: string;
  alertType: string;
  message: string;
  urgency: string;
  patientData: {
    metricType: string;
    value: number;
    unit: string;
    timestamp: Date;
    medicalGuidance: string;
    immediateActions: string[];
  };
}

// Re-export ValidationResult from health-data validation service
export interface ValidationResult {
  isValid: boolean;
  warnings: string[];
  errors: string[];
  suggestions: string[];
  confidence: number;
  normalizedValue?: number;
  qualityScore: number;
  severity: 'info' | 'warning' | 'error' | 'critical';
  emergencyAlert?: boolean;
  complianceFlags: string[];
  medicalReferences: string[];
}

// =============================================================================
// Health Profile DTOs
// =============================================================================

export interface CreateHealthProfileDto {
  baselineMetrics?: Partial<BaselineMetricsDto>;
  healthConditions?: HealthConditionDto[];
  allergies?: AllergyDto[];
  riskFactors?: RiskFactorDto[];
}

export interface UpdateHealthProfileDto {
  baselineMetrics?: Partial<BaselineMetricsDto>;
  healthConditions?: HealthConditionDto[];
  allergies?: AllergyDto[];
  riskFactors?: RiskFactorDto[];
}

export interface BaselineMetricsDto {
  height: number;
  weight: number;
  bmi: number;
  restingHeartRate: number;
  bloodPressure: {
    systolic: number;
    diastolic: number;
  };
  bloodGlucose: number;
}

export interface HealthConditionDto {
  name: string;
  diagnosisDate?: string | Date;
  isCurrent: boolean;
  severity: 'mild' | 'moderate' | 'severe';
  medications?: string[];
  notes?: string;
}

export interface AllergyDto {
  allergen: string;
  reactionType: string;
  severity: 'mild' | 'moderate' | 'severe';
}

export interface RiskFactorDto {
  type: string;
  description: string;
  riskLevel: 'low' | 'medium' | 'high';
}

export interface HealthGoalDto {
  metricType: string;
  targetValue: number;
  unit: string;
  startDate: string | Date;
  targetDate: string | Date;
  recurrence: 'once' | 'daily' | 'weekly' | 'monthly';
}

export interface UpdateHealthGoalDto {
  targetValue?: number;
  unit?: string;
  targetDate?: string | Date;
  currentValue?: number;
  progress?: number;
  status?: 'active' | 'achieved' | 'behind' | 'abandoned';
  recurrence?: 'once' | 'daily' | 'weekly' | 'monthly';
}

// =============================================================================
// Export all types
// =============================================================================

export * from './api.types';
