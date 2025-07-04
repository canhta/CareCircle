import { Injectable } from '@nestjs/common';

export interface TemplateContext {
  [key: string]: any;
}

export interface TemplateMetadata {
  placeholders: {
    key: string;
    type: 'string' | 'number' | 'date' | 'boolean';
    required: boolean;
    description?: string;
  }[];
}

@Injectable()
export class TemplateRenderingService {
  /**
   * Render a template with provided context data
   * Supports placeholders in the format {{key}} and {{key.nestedKey}}
   */
  render(template: string, context: TemplateContext): string {
    if (!template) {
      return '';
    }

    // Replace placeholders with context data
    return template.replace(/\{\{([^}]+)\}\}/g, (match, key) => {
      const value = this.getValue(context, key.trim());
      return this.formatValue(value);
    });
  }

  /**
   * Validate that all required placeholders are present in the context
   */
  validateContext(
    template: string,
    context: TemplateContext,
    metadata?: TemplateMetadata,
  ): { valid: boolean; errors: string[] } {
    const errors: string[] = [];
    const placeholders = this.extractPlaceholders(template);

    // Check if all placeholders have values
    for (const placeholder of placeholders) {
      const value = this.getValue(context, placeholder);
      if (value === undefined || value === null) {
        errors.push(`Missing value for placeholder: ${placeholder}`);
      }
    }

    // Check required placeholders from metadata
    if (metadata?.placeholders) {
      for (const placeholderMeta of metadata.placeholders) {
        if (placeholderMeta.required) {
          const value = this.getValue(context, placeholderMeta.key);
          if (value === undefined || value === null || value === '') {
            errors.push(`Required placeholder missing: ${placeholderMeta.key}`);
          }

          // Type validation
          if (value !== undefined && value !== null) {
            const isValidType = this.validateType(value, placeholderMeta.type);
            if (!isValidType) {
              errors.push(
                `Invalid type for placeholder ${placeholderMeta.key}: expected ${placeholderMeta.type}`,
              );
            }
          }
        }
      }
    }

    return {
      valid: errors.length === 0,
      errors,
    };
  }

  /**
   * Extract all placeholders from a template
   */
  extractPlaceholders(template: string): string[] {
    const matches = template.match(/\{\{([^}]+)\}\}/g) || [];
    return matches.map((match) => match.replace(/\{\{|\}\}/g, '').trim());
  }

  /**
   * Get nested value from context using dot notation
   */
  private getValue(context: TemplateContext, key: string): any {
    const keys = key.split('.');
    let value = context;

    for (const k of keys) {
      if (value && typeof value === 'object' && k in value) {
        value = value[k];
      } else {
        return undefined;
      }
    }

    return value;
  }

  /**
   * Format value for display
   */
  private formatValue(value: any): string {
    if (value === undefined || value === null) {
      return '';
    }

    if (value instanceof Date) {
      return value.toLocaleString();
    }

    if (typeof value === 'boolean') {
      return value ? 'Yes' : 'No';
    }

    if (typeof value === 'number') {
      return value.toString();
    }

    return String(value);
  }

  /**
   * Validate value type
   */
  private validateType(value: any, expectedType: string): boolean {
    switch (expectedType) {
      case 'string':
        return typeof value === 'string';
      case 'number':
        return typeof value === 'number' && !isNaN(value);
      case 'date':
        return value instanceof Date || !isNaN(Date.parse(value));
      case 'boolean':
        return typeof value === 'boolean';
      default:
        return true;
    }
  }

  /**
   * Create a personalized context for a user
   */
  createUserContext(
    user: any,
    additionalData: TemplateContext = {},
  ): TemplateContext {
    const baseContext = {
      userName: user.name || user.email?.split('@')[0] || 'User',
      userEmail: user.email,
      userFirstName: user.name?.split(' ')[0] || 'User',
      userLastName: user.name?.split(' ').slice(1).join(' ') || '',
      currentDate: new Date().toLocaleDateString(),
      currentTime: new Date().toLocaleTimeString(),
      currentDateTime: new Date().toLocaleString(),
    };

    return { ...baseContext, ...additionalData };
  }
}
