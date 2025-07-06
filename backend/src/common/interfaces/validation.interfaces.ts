/**
 * Interfaces for validation functionality
 */

/**
 * Validation error response structure
 */
export interface ValidationErrorResponse {
  message: string;
  errors: Record<string, string[] | Record<string, unknown>>;
  statusCode: number;
}

/**
 * Formatted validation error object
 */
export interface FormattedValidationErrors {
  [property: string]: string[] | FormattedValidationErrors;
}

/**
 * Custom metadata for validation
 */
export interface CustomValidationMetadata {
  metatype: Constructor | undefined;
  type?: string;
  data?: string;
  [key: string]: unknown;
}

/**
 * Constructor type for any class
 */
export type Constructor = new (...args: any[]) => any;
