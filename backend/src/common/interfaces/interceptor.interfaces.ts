/**
 * Interfaces for interceptor functionality
 */

import { Request, Response } from 'express';

/**
 * Request object with correlation ID
 */
export interface RequestWithCorrelationId extends Request {
  correlationId: string;
  user?: {
    id?: string;
    email?: string;
    [key: string]: unknown;
  };
}

/**
 * Audit data for PHI access
 */
export interface PHIAccessAuditData {
  userId?: string;
  action: string;
  resource: string;
  statusCode: number;
  duration: number;
  ip: string | undefined;
  userAgent?: string;
  correlationId: string;
  timestamp: Date;
}

/**
 * Cache options for HTTP responses
 */
export interface CacheOptions {
  ttl?: number;
  key?: string;
  isPrivate?: boolean;
}

/**
 * Transaction options for database operations
 */
export interface TransactionOptions {
  isolationLevel?:
    | 'ReadUncommitted'
    | 'ReadCommitted'
    | 'RepeatableRead'
    | 'Serializable';
  timeout?: number;
  maxAttempts?: number;
}

/**
 * Extended execution context with type-safe methods
 */
export interface TypedExecutionContext {
  getRequest<T = RequestWithCorrelationId>(): T;
  getResponse<T = Response>(): T;
}
