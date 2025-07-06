/**
 * Interfaces for exception handling functionality
 */

import { Request } from 'express';

/**
 * Represents error details that can be included in error responses
 */
export interface ErrorDetails {
  [key: string]: unknown;
}

/**
 * Structure for HTTP exception responses
 */
export interface HttpExceptionResponse {
  message: string | string[];
  error?: string;
  details?: ErrorDetails;
  statusCode?: number;
}

/**
 * Standard error response structure
 */
export interface ErrorResponse {
  statusCode: number;
  timestamp: string;
  path: string;
  method: string;
  message: string | string[];
  error?: string;
  correlationId: string;
  details?: ErrorDetails;
}

/**
 * Request with user information
 */
export interface RequestWithUser extends Request {
  user?: {
    id?: string;
    email?: string;
    role?: string;
  };
  correlationId?: string;
}

/**
 * Security event severity levels
 */
export type SecuritySeverity = 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';

/**
 * Security event types
 */
export type SecurityEventType =
  | 'SYSTEM'
  | 'AUTHENTICATION'
  | 'AUTHORIZATION'
  | 'DATA_ACCESS'
  | 'COMPLIANCE';

/**
 * Security event log entry
 */
export interface SecurityEventLog {
  userId?: string;
  action: string;
  resource: string;
  details: ErrorDetails;
  timestamp: Date;
  severity: SecuritySeverity;
  eventType: SecurityEventType;
}
