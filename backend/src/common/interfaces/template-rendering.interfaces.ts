/**
 * Interface for template context
 */
export interface TemplateContext {
  [key: string]: unknown;
}

/**
 * Interface for template metadata
 */
export interface TemplateMetadata {
  placeholders: {
    key: string;
    type: 'string' | 'number' | 'date' | 'boolean';
    required: boolean;
    description?: string;
  }[];
}

/**
 * Interface for template validation result
 */
export interface TemplateValidationResult {
  valid: boolean;
  errors: string[];
}

/**
 * Interface for user context data
 */
export interface UserContextData {
  id: string;
  email: string;
  name?: string;
  firstName?: string;
  lastName?: string;
}
