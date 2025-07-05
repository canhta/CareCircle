/**
 * Base interface for domain exception details
 */
export interface DomainExceptionDetails {
  code: string;
  field?: string;
  value?: unknown;
  [key: string]: unknown;
}

/**
 * Interface for validation error details
 */
export interface ValidationErrorDetails extends DomainExceptionDetails {
  constraints: Record<string, string>;
  children?: ValidationErrorDetails[];
}

/**
 * Interface for data integrity error details
 */
export interface DataIntegrityErrorDetails extends DomainExceptionDetails {
  entity: string;
  operation: 'create' | 'update' | 'delete' | 'read';
  identifier?: string | number;
  relationViolation?: {
    entity: string;
    field: string;
    constraint: string;
  };
}

/**
 * Interface for health data error details
 */
export interface HealthDataErrorDetails extends DomainExceptionDetails {
  dataType?: string;
  userId?: string;
  sourceSystem?: string;
  timestamp?: string | Date;
}

/**
 * Interface for care group error details
 */
export interface CareGroupErrorDetails extends DomainExceptionDetails {
  careGroupId?: string;
  memberId?: string;
  role?: string;
  permission?: string;
}

/**
 * Interface for notification error details
 */
export interface NotificationErrorDetails extends DomainExceptionDetails {
  notificationId?: string;
  channel?: string;
  userId?: string;
  templateId?: string;
  failureReason?: string;
}

/**
 * Interface for subscription error details
 */
export interface SubscriptionErrorDetails extends DomainExceptionDetails {
  subscriptionId?: string;
  planId?: string;
  userId?: string;
  paymentId?: string;
  expirationDate?: string | Date;
}

/**
 * Interface for AI service error details
 */
export interface AIServiceErrorDetails extends DomainExceptionDetails {
  service?: string;
  model?: string;
  requestId?: string;
  promptTokens?: number;
  completionTokens?: number;
  errorResponse?: {
    status?: number;
    message?: string;
    type?: string;
  };
}

/**
 * Interface for compliance error details
 */
export interface ComplianceErrorDetails extends DomainExceptionDetails {
  regulation?: string;
  dataType?: string;
  userId?: string;
  consentRequired?: boolean;
  consentGiven?: boolean;
}

/**
 * Interface for prescription error details
 */
export interface PrescriptionErrorDetails extends DomainExceptionDetails {
  prescriptionId?: string;
  medicationName?: string;
  scanData?: {
    confidence?: number;
    errorType?: string;
  };
}
