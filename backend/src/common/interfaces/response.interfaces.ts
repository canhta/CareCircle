/**
 * Standard API response envelope
 */
export interface ApiResponse<T> {
  success: boolean;
  data: T;
  message?: string;
  error?: string;
}

/**
 * Error response structure
 */
export interface ErrorResponse {
  success: false;
  error: string;
  message: string;
  details?: ErrorDetails;
  statusCode: number;
  timestamp: string;
  path: string;
}

/**
 * Structured error details
 */
export interface ErrorDetails {
  code?: string;
  field?: string;
  validation?: Record<string, string>;
  [key: string]: unknown;
}

/**
 * Success response structure
 */
export interface SuccessResponse<T> {
  success: true;
  data: T;
  message?: string;
}

/**
 * Generic no content success response
 */
export interface NoContentResponse {
  success: true;
  message?: string;
}

/**
 * Common health check response structure
 */
export interface HealthCheckResponse {
  status: 'ok' | 'error';
  uptime: number;
  timestamp: string;
  version: string;
  services: Record<
    string,
    {
      status: 'ok' | 'error';
      message?: string;
      latency?: number;
    }
  >;
}
