import { Injectable, Logger } from '@nestjs/common';
import * as Handlebars from 'handlebars';
import { NotificationType } from '@prisma/client';

export interface TemplateData {
  id: string;
  name: string;
  type: NotificationType;
  subject: string;
  htmlContent: string;
  textContent: string;
  variables: TemplateVariable[];
  locale: string;
  version: number;
  isActive: boolean;
  metadata?: Record<string, any>;
}

export interface TemplateVariable {
  name: string;
  type: 'string' | 'number' | 'date' | 'boolean' | 'object';
  required: boolean;
  description: string;
  defaultValue?: any;
  validation?: TemplateVariableValidation;
}

export interface TemplateVariableValidation {
  pattern?: string; // Regex pattern
  minLength?: number;
  maxLength?: number;
  min?: number; // For numbers
  max?: number; // For numbers
  allowedValues?: any[]; // Enum values
}

export interface RenderContext {
  variables: Record<string, any>;
  locale?: string;
  timezone?: string;
  userPreferences?: Record<string, any>;
  metadata?: Record<string, any>;
}

export interface RenderedTemplate {
  subject: string;
  htmlContent: string;
  textContent: string;
  variables: Record<string, any>;
  renderTime: Date;
}

@Injectable()
export class TemplateEngineService {
  private readonly logger = new Logger(TemplateEngineService.name);
  private readonly handlebars: typeof Handlebars;
  private readonly compiledTemplates = new Map<
    string,
    HandlebarsTemplateDelegate
  >();

  constructor() {
    this.handlebars = Handlebars.create();
    this.registerHelpers();
    this.registerPartials();
  }

  /**
   * Render a template with provided context
   */
  renderTemplate(
    template: TemplateData,
    context: RenderContext,
  ): RenderedTemplate {
    try {
      this.logger.log(`Rendering template ${template.name} (${template.id})`);

      // Validate required variables
      this.validateTemplateVariables(template.variables, context.variables);

      // Prepare render context with helpers and metadata
      const renderContext = this.prepareRenderContext(template, context);

      // Compile templates if not already cached
      const subjectTemplate = this.getCompiledTemplate(
        `${template.id}_subject`,
        template.subject,
      );
      const htmlTemplate = this.getCompiledTemplate(
        `${template.id}_html`,
        template.htmlContent,
      );
      const textTemplate = this.getCompiledTemplate(
        `${template.id}_text`,
        template.textContent,
      );

      // Render all parts
      const renderedSubject = subjectTemplate(renderContext);
      const renderedHtml = htmlTemplate(renderContext);
      const renderedText = textTemplate(renderContext);

      // Sanitize and validate rendered content
      const sanitizedResult = this.sanitizeRenderedContent({
        subject: renderedSubject,
        htmlContent: renderedHtml,
        textContent: renderedText,
        variables: context.variables,
        renderTime: new Date(),
      });

      this.logger.log(`Template ${template.name} rendered successfully`);

      return sanitizedResult;
    } catch (error) {
      this.logger.error(`Failed to render template ${template.name}:`, error);
      throw new Error(
        `Template rendering failed: ${error instanceof Error ? error.message : 'Unknown error'}`,
      );
    }
  }

  /**
   * Validate template syntax and variables
   */
  validateTemplate(template: TemplateData): {
    isValid: boolean;
    errors: string[];
  } {
    const errors: string[] = [];

    try {
      // Validate subject template
      this.handlebars.compile(template.subject);
    } catch (error) {
      errors.push(
        `Subject template syntax error: ${error instanceof Error ? error.message : 'Unknown error'}`,
      );
    }

    try {
      // Validate HTML template
      this.handlebars.compile(template.htmlContent);
    } catch (error) {
      errors.push(
        `HTML template syntax error: ${error instanceof Error ? error.message : 'Unknown error'}`,
      );
    }

    try {
      // Validate text template
      this.handlebars.compile(template.textContent);
    } catch (error) {
      errors.push(
        `Text template syntax error: ${error instanceof Error ? error.message : 'Unknown error'}`,
      );
    }

    // Validate template variables
    const variableErrors = this.validateTemplateVariableDefinitions(
      template.variables,
    );
    errors.push(...variableErrors);

    // Check for healthcare compliance
    const complianceErrors = this.validateHealthcareCompliance(template);
    errors.push(...complianceErrors);

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Get default healthcare templates
   */
  getDefaultHealthcareTemplates(): TemplateData[] {
    return [
      this.createMedicationReminderTemplate(),
      this.createAppointmentReminderTemplate(),
      this.createHealthAlertTemplate(),
      this.createEmergencyAlertTemplate(),
      this.createCareGroupUpdateTemplate(),
    ];
  }

  /**
   * Register custom Handlebars helpers
   */
  private registerHelpers(): void {
    // Date formatting helper
    this.handlebars.registerHelper(
      'formatDate',
      (date: Date | string, format: string, timezone?: string) => {
        const dateObj = typeof date === 'string' ? new Date(date) : date;

        if (!dateObj || isNaN(dateObj.getTime())) {
          return 'Invalid Date';
        }

        const options: Intl.DateTimeFormatOptions = {};

        switch (format) {
          case 'short':
            options.dateStyle = 'short';
            options.timeStyle = 'short';
            break;
          case 'medium':
            options.dateStyle = 'medium';
            options.timeStyle = 'short';
            break;
          case 'long':
            options.dateStyle = 'long';
            options.timeStyle = 'short';
            break;
          case 'date-only':
            options.dateStyle = 'medium';
            break;
          case 'time-only':
            options.timeStyle = 'short';
            break;
          default:
            options.dateStyle = 'medium';
            options.timeStyle = 'short';
        }

        if (timezone) {
          options.timeZone = timezone;
        }

        return dateObj.toLocaleString('en-US', options);
      },
    );

    // Capitalize helper
    this.handlebars.registerHelper('capitalize', (str: string) => {
      if (typeof str !== 'string') return str;
      return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
    });

    // Conditional helper
    this.handlebars.registerHelper(
      'ifEquals',
      function (
        arg1: unknown,
        arg2: unknown,
        options: {
          fn: (context: unknown) => string;
          inverse: (context: unknown) => string;
        },
      ) {
        return arg1 === arg2 ? options.fn(this) : options.inverse(this);
      },
    );

    // Healthcare-specific helpers
    this.handlebars.registerHelper(
      'formatMedication',
      (name: string, dosage: string, frequency: string) => {
        return `${name} - ${dosage} (${frequency})`;
      },
    );

    this.handlebars.registerHelper('urgencyLevel', (priority: string) => {
      switch (priority?.toLowerCase()) {
        case 'urgent':
          return '🚨 URGENT';
        case 'high':
          return '⚠️ HIGH PRIORITY';
        case 'normal':
          return 'ℹ️ NORMAL';
        case 'low':
          return '📝 LOW PRIORITY';
        default:
          return priority;
      }
    });

    // Sanitization helper
    this.handlebars.registerHelper('sanitize', (str: string) => {
      if (typeof str !== 'string') return str;
      // Remove potentially harmful content while preserving healthcare data
      return str
        .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
        .replace(/javascript:/gi, '')
        .replace(/on\w+\s*=/gi, '');
    });

    // Localization helper (basic implementation)
    this.handlebars.registerHelper('t', (key: string, locale = 'en') => {
      // This would integrate with a proper i18n system
      const translations: Record<string, Record<string, string>> = {
        en: {
          'medication.reminder': 'Medication Reminder',
          'appointment.reminder': 'Appointment Reminder',
          'health.alert': 'Health Alert',
          'emergency.alert': 'Emergency Alert',
          'take.medication': 'Please take your medication',
          'appointment.scheduled': 'You have an appointment scheduled',
        },
        es: {
          'medication.reminder': 'Recordatorio de Medicamento',
          'appointment.reminder': 'Recordatorio de Cita',
          'health.alert': 'Alerta de Salud',
          'emergency.alert': 'Alerta de Emergencia',
          'take.medication': 'Por favor tome su medicamento',
          'appointment.scheduled': 'Tiene una cita programada',
        },
      };

      return translations[locale as string]?.[key] || key;
    });
  }

  /**
   * Register common template partials
   */
  private registerPartials(): void {
    // Header partial
    this.handlebars.registerPartial(
      'header',
      `
      <div style="background-color: #1976d2; color: white; padding: 20px; text-align: center;">
        <h1 style="margin: 0; font-size: 24px;">CareCircle</h1>
        <p style="margin: 5px 0 0 0; font-size: 14px;">Healthcare Notification Platform</p>
      </div>
    `,
    );

    // Footer partial
    this.handlebars.registerPartial(
      'footer',
      `
      <div style="font-size: 12px; color: #666; text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
        <p>This is an automated message from CareCircle Healthcare Platform.</p>
        <p>For support, contact us at <a href="mailto:support@carecircle.com">support@carecircle.com</a></p>
        <p>&copy; {{currentYear}} CareCircle. All rights reserved.</p>
      </div>
    `,
    );

    // Medication info partial
    this.handlebars.registerPartial(
      'medicationInfo',
      `
      <div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin: 15px 0;">
        <strong>Medication:</strong> {{medicationName}}<br>
        <strong>Dosage:</strong> {{dosage}}<br>
        {{#if frequency}}<strong>Frequency:</strong> {{frequency}}<br>{{/if}}
        {{#if scheduledTime}}<strong>Scheduled Time:</strong> {{formatDate scheduledTime 'time-only'}}<br>{{/if}}
      </div>
    `,
    );

    // Appointment info partial
    this.handlebars.registerPartial(
      'appointmentInfo',
      `
      <div style="background-color: #e3f2fd; padding: 15px; border-radius: 5px; margin: 15px 0;">
        <strong>Appointment Type:</strong> {{appointmentType}}<br>
        <strong>Provider:</strong> {{providerName}}<br>
        <strong>Date & Time:</strong> {{formatDate appointmentDate 'medium'}}<br>
        {{#if location}}<strong>Location:</strong> {{location}}<br>{{/if}}
      </div>
    `,
    );
  }

  /**
   * Get compiled template from cache or compile new one
   */
  private getCompiledTemplate(
    key: string,
    source: string,
  ): HandlebarsTemplateDelegate {
    if (this.compiledTemplates.has(key)) {
      return this.compiledTemplates.get(key)!;
    }

    const compiled = this.handlebars.compile(source);
    this.compiledTemplates.set(key, compiled);
    return compiled;
  }

  /**
   * Prepare render context with additional helpers and metadata
   */
  private prepareRenderContext(
    template: TemplateData,
    context: RenderContext,
  ): Record<string, any> {
    return {
      ...context.variables,
      currentYear: new Date().getFullYear(),
      currentDate: new Date(),
      locale: context.locale || template.locale || 'en',
      timezone: context.timezone || 'UTC',
      templateName: template.name,
      templateType: template.type,
      userPreferences: context.userPreferences || {},
      metadata: {
        ...template.metadata,
        ...context.metadata,
      },
    };
  }

  /**
   * Validate template variables against context
   */
  private validateTemplateVariables(
    templateVars: TemplateVariable[],
    contextVars: Record<string, any>,
  ): void {
    const errors: string[] = [];

    for (const templateVar of templateVars) {
      if (templateVar.required && !(templateVar.name in contextVars)) {
        errors.push(`Required variable '${templateVar.name}' is missing`);
        continue;
      }

      const value = contextVars[templateVar.name] as unknown;
      if (value !== undefined && value !== null) {
        const validationError = this.validateVariableValue(templateVar, value);
        if (validationError) {
          errors.push(validationError);
        }
      }
    }

    if (errors.length > 0) {
      throw new Error(`Template validation failed: ${errors.join(', ')}`);
    }
  }

  /**
   * Validate individual variable value
   */
  private validateVariableValue(
    templateVar: TemplateVariable,
    value: unknown,
  ): string | null {
    const { validation } = templateVar;
    if (!validation) return null;

    // Type validation
    switch (templateVar.type) {
      case 'string':
        if (typeof value !== 'string') {
          return `Variable '${templateVar.name}' must be a string`;
        }
        if (validation.minLength && value.length < validation.minLength) {
          return `Variable '${templateVar.name}' must be at least ${validation.minLength} characters`;
        }
        if (validation.maxLength && value.length > validation.maxLength) {
          return `Variable '${templateVar.name}' must be at most ${validation.maxLength} characters`;
        }
        if (validation.pattern && !new RegExp(validation.pattern).test(value)) {
          return `Variable '${templateVar.name}' does not match required pattern`;
        }
        break;
      case 'number':
        if (typeof value !== 'number') {
          return `Variable '${templateVar.name}' must be a number`;
        }
        if (validation.min !== undefined && value < validation.min) {
          return `Variable '${templateVar.name}' must be at least ${validation.min}`;
        }
        if (validation.max !== undefined && value > validation.max) {
          return `Variable '${templateVar.name}' must be at most ${validation.max}`;
        }
        break;
      case 'date': {
        const dateValue = new Date(value as string | number | Date);
        if (isNaN(dateValue.getTime())) {
          return `Variable '${templateVar.name}' must be a valid date`;
        }
        break;
      }
      case 'boolean':
        if (typeof value !== 'boolean') {
          return `Variable '${templateVar.name}' must be a boolean`;
        }
        break;
    }

    // Allowed values validation
    if (validation.allowedValues && !validation.allowedValues.includes(value)) {
      return `Variable '${templateVar.name}' must be one of: ${validation.allowedValues.join(', ')}`;
    }

    return null;
  }

  /**
   * Validate template variable definitions
   */
  private validateTemplateVariableDefinitions(
    variables: TemplateVariable[],
  ): string[] {
    const errors: string[] = [];
    const variableNames = new Set<string>();

    for (const variable of variables) {
      // Check for duplicate names
      if (variableNames.has(variable.name)) {
        errors.push(`Duplicate variable name: ${variable.name}`);
      }
      variableNames.add(variable.name);

      // Validate variable name format
      if (!/^[a-zA-Z][a-zA-Z0-9_]*$/.test(variable.name)) {
        errors.push(`Invalid variable name format: ${variable.name}`);
      }

      // Validate type
      if (
        !['string', 'number', 'date', 'boolean', 'object'].includes(
          variable.type,
        )
      ) {
        errors.push(`Invalid variable type: ${variable.type}`);
      }
    }

    return errors;
  }

  /**
   * Validate healthcare compliance
   */
  private validateHealthcareCompliance(template: TemplateData): string[] {
    const errors: string[] = [];

    // Check for potential PII/PHI exposure in templates
    const sensitivePatterns = [
      /\b\d{3}-\d{2}-\d{4}\b/, // SSN pattern
      /\b\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}\b/, // Credit card pattern
      /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/, // Email pattern in template content
    ];

    const allContent = `${template.subject} ${template.htmlContent} ${template.textContent}`;

    for (const pattern of sensitivePatterns) {
      if (pattern.test(allContent)) {
        errors.push('Template contains potentially sensitive data patterns');
        break;
      }
    }

    // Validate required healthcare disclaimers for certain types
    if (template.type === NotificationType.EMERGENCY_ALERT) {
      if (
        !allContent.toLowerCase().includes('emergency') &&
        !allContent.toLowerCase().includes('urgent')
      ) {
        errors.push('Emergency alert templates must clearly indicate urgency');
      }
    }

    return errors;
  }

  /**
   * Sanitize rendered content
   */
  private sanitizeRenderedContent(
    rendered: RenderedTemplate,
  ): RenderedTemplate {
    return {
      ...rendered,
      subject: this.sanitizeText(rendered.subject),
      htmlContent: this.sanitizeHtml(rendered.htmlContent),
      textContent: this.sanitizeText(rendered.textContent),
    };
  }

  /**
   * Sanitize text content
   */
  private sanitizeText(text: string): string {
    // Remove any remaining template syntax that wasn't processed
    return text.replace(/\{\{[^}]*\}\}/g, '').trim();
  }

  /**
   * Sanitize HTML content
   */
  private sanitizeHtml(html: string): string {
    // Basic HTML sanitization - in production, use a proper HTML sanitizer
    return html
      .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
      .replace(/javascript:/gi, '')
      .replace(/on\w+\s*=/gi, '')
      .replace(/\{\{[^}]*\}\}/g, '');
  }

  /**
   * Create default medication reminder template
   */
  private createMedicationReminderTemplate(): TemplateData {
    return {
      id: 'medication-reminder-default',
      name: 'Default Medication Reminder',
      type: NotificationType.MEDICATION_REMINDER,
      subject: '{{t "medication.reminder" locale}} - {{medicationName}}',
      htmlContent: `
        {{> header}}
        <div style="padding: 30px;">
          <h2>{{t "medication.reminder" locale}}</h2>
          <p>Hello {{patientName}},</p>
          <p>{{t "take.medication" locale}}:</p>
          {{> medicationInfo}}
          <p>Please take your medication as prescribed by your healthcare provider.</p>
        </div>
        {{> footer}}
      `,
      textContent: `
        {{t "medication.reminder" locale}}
        
        Hello {{patientName}},
        
        {{t "take.medication" locale}}:
        
        Medication: {{medicationName}}
        Dosage: {{dosage}}
        {{#if frequency}}Frequency: {{frequency}}{{/if}}
        {{#if scheduledTime}}Scheduled Time: {{formatDate scheduledTime 'time-only'}}{{/if}}
        
        Please take your medication as prescribed by your healthcare provider.
      `,
      variables: [
        {
          name: 'patientName',
          type: 'string',
          required: true,
          description: 'Patient name',
        },
        {
          name: 'medicationName',
          type: 'string',
          required: true,
          description: 'Medication name',
        },
        {
          name: 'dosage',
          type: 'string',
          required: true,
          description: 'Medication dosage',
        },
        {
          name: 'frequency',
          type: 'string',
          required: false,
          description: 'Medication frequency',
        },
        {
          name: 'scheduledTime',
          type: 'date',
          required: false,
          description: 'Scheduled time',
        },
      ],
      locale: 'en',
      version: 1,
      isActive: true,
    };
  }

  /**
   * Create default appointment reminder template
   */
  private createAppointmentReminderTemplate(): TemplateData {
    return {
      id: 'appointment-reminder-default',
      name: 'Default Appointment Reminder',
      type: NotificationType.APPOINTMENT_REMINDER,
      subject: '{{t "appointment.reminder" locale}} - {{appointmentType}}',
      htmlContent: `
        {{> header}}
        <div style="padding: 30px;">
          <h2>{{t "appointment.reminder" locale}}</h2>
          <p>Hello {{patientName}},</p>
          <p>{{t "appointment.scheduled" locale}}:</p>
          {{> appointmentInfo}}
          <p>Please arrive 15 minutes early for check-in.</p>
        </div>
        {{> footer}}
      `,
      textContent: `
        {{t "appointment.reminder" locale}}
        
        Hello {{patientName}},
        
        {{t "appointment.scheduled" locale}}:
        
        Appointment Type: {{appointmentType}}
        Provider: {{providerName}}
        Date & Time: {{formatDate appointmentDate 'medium'}}
        {{#if location}}Location: {{location}}{{/if}}
        
        Please arrive 15 minutes early for check-in.
      `,
      variables: [
        {
          name: 'patientName',
          type: 'string',
          required: true,
          description: 'Patient name',
        },
        {
          name: 'appointmentType',
          type: 'string',
          required: true,
          description: 'Type of appointment',
        },
        {
          name: 'providerName',
          type: 'string',
          required: true,
          description: 'Healthcare provider name',
        },
        {
          name: 'appointmentDate',
          type: 'date',
          required: true,
          description: 'Appointment date and time',
        },
        {
          name: 'location',
          type: 'string',
          required: false,
          description: 'Appointment location',
        },
      ],
      locale: 'en',
      version: 1,
      isActive: true,
    };
  }

  /**
   * Create default health alert template
   */
  private createHealthAlertTemplate(): TemplateData {
    return {
      id: 'health-alert-default',
      name: 'Default Health Alert',
      type: NotificationType.HEALTH_ALERT,
      subject: '{{urgencyLevel priority}} {{t "health.alert" locale}}',
      htmlContent: `
        {{> header}}
        <div style="padding: 30px;">
          <h2>{{urgencyLevel priority}} {{t "health.alert" locale}}</h2>
          <p>Hello {{patientName}},</p>
          <div style="background-color: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 5px; margin: 15px 0;">
            <p><strong>Alert:</strong> {{alertMessage}}</p>
            {{#if recommendations}}
            <p><strong>Recommendations:</strong> {{recommendations}}</p>
            {{/if}}
          </div>
          <p>Please contact your healthcare provider if you have any concerns.</p>
        </div>
        {{> footer}}
      `,
      textContent: `
        {{urgencyLevel priority}} {{t "health.alert" locale}}
        
        Hello {{patientName}},
        
        Alert: {{alertMessage}}
        {{#if recommendations}}
        Recommendations: {{recommendations}}
        {{/if}}
        
        Please contact your healthcare provider if you have any concerns.
      `,
      variables: [
        {
          name: 'patientName',
          type: 'string',
          required: true,
          description: 'Patient name',
        },
        {
          name: 'alertMessage',
          type: 'string',
          required: true,
          description: 'Alert message',
        },
        {
          name: 'priority',
          type: 'string',
          required: true,
          description: 'Alert priority',
          validation: { allowedValues: ['low', 'normal', 'high', 'urgent'] },
        },
        {
          name: 'recommendations',
          type: 'string',
          required: false,
          description: 'Recommended actions',
        },
      ],
      locale: 'en',
      version: 1,
      isActive: true,
    };
  }

  /**
   * Create default emergency alert template
   */
  private createEmergencyAlertTemplate(): TemplateData {
    return {
      id: 'emergency-alert-default',
      name: 'Default Emergency Alert',
      type: NotificationType.EMERGENCY_ALERT,
      subject: '🚨 {{t "emergency.alert" locale}} - IMMEDIATE ACTION REQUIRED',
      htmlContent: `
        <div style="background-color: #ffebee; border: 2px solid #f44336; padding: 20px; border-radius: 5px;">
          <h2 style="color: #d32f2f; margin-top: 0;">🚨 {{t "emergency.alert" locale}}</h2>
          <p><strong>Patient:</strong> {{patientName}}</p>
          <p><strong>Emergency Type:</strong> {{emergencyType}}</p>
          <p><strong>Message:</strong> {{emergencyMessage}}</p>
          <p><strong>Time:</strong> {{formatDate timestamp 'medium'}}</p>
          
          <div style="background-color: #fff; padding: 15px; margin: 15px 0; border-radius: 3px;">
            <p style="margin: 0;"><strong>IMMEDIATE ACTION REQUIRED</strong></p>
            <p style="margin: 5px 0 0 0;">Please respond to this emergency alert immediately.</p>
          </div>
        </div>
      `,
      textContent: `
        🚨 {{t "emergency.alert" locale}} 🚨
        
        Patient: {{patientName}}
        Emergency Type: {{emergencyType}}
        Message: {{emergencyMessage}}
        Time: {{formatDate timestamp 'medium'}}
        
        IMMEDIATE ACTION REQUIRED
        Please respond to this emergency alert immediately.
      `,
      variables: [
        {
          name: 'patientName',
          type: 'string',
          required: true,
          description: 'Patient name',
        },
        {
          name: 'emergencyType',
          type: 'string',
          required: true,
          description: 'Type of emergency',
        },
        {
          name: 'emergencyMessage',
          type: 'string',
          required: true,
          description: 'Emergency message',
        },
        {
          name: 'timestamp',
          type: 'date',
          required: true,
          description: 'Emergency timestamp',
        },
      ],
      locale: 'en',
      version: 1,
      isActive: true,
    };
  }

  /**
   * Create default care group update template
   */
  private createCareGroupUpdateTemplate(): TemplateData {
    return {
      id: 'care-group-update-default',
      name: 'Default Care Group Update',
      type: NotificationType.CARE_GROUP_UPDATE,
      subject: 'Care Group Update - {{careGroupName}}',
      htmlContent: `
        {{> header}}
        <div style="padding: 30px;">
          <h2>Care Group Update</h2>
          <p>Hello {{memberName}},</p>
          <p>There's an update in your care group <strong>{{careGroupName}}</strong>:</p>
          <div style="background-color: #f3e5f5; padding: 15px; border-radius: 5px; margin: 15px 0;">
            <p><strong>Update:</strong> {{updateMessage}}</p>
            {{#if updatedBy}}
            <p><strong>Updated by:</strong> {{updatedBy}}</p>
            {{/if}}
            <p><strong>Time:</strong> {{formatDate updateTime 'medium'}}</p>
          </div>
          <p>Stay connected with your care team for the best health outcomes.</p>
        </div>
        {{> footer}}
      `,
      textContent: `
        Care Group Update
        
        Hello {{memberName}},
        
        There's an update in your care group {{careGroupName}}:
        
        Update: {{updateMessage}}
        {{#if updatedBy}}Updated by: {{updatedBy}}{{/if}}
        Time: {{formatDate updateTime 'medium'}}
        
        Stay connected with your care team for the best health outcomes.
      `,
      variables: [
        {
          name: 'memberName',
          type: 'string',
          required: true,
          description: 'Care group member name',
        },
        {
          name: 'careGroupName',
          type: 'string',
          required: true,
          description: 'Care group name',
        },
        {
          name: 'updateMessage',
          type: 'string',
          required: true,
          description: 'Update message',
        },
        {
          name: 'updatedBy',
          type: 'string',
          required: false,
          description: 'Person who made the update',
        },
        {
          name: 'updateTime',
          type: 'date',
          required: true,
          description: 'Update timestamp',
        },
      ],
      locale: 'en',
      version: 1,
      isActive: true,
    };
  }
}
