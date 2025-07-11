import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { NotificationType, NotificationChannel, Prisma } from '@prisma/client';
import {
  TemplateData,
  TemplateVariable,
} from '../services/template-engine.service';

export interface CreateTemplateRequest {
  name: string;
  type: NotificationType;
  channel: NotificationChannel;
  subject: string;
  htmlContent: string;
  textContent: string;
  variables: TemplateVariable[];
  locale: string;
  isActive?: boolean;
  metadata?: Record<string, any>;
}

export interface UpdateTemplateRequest {
  name?: string;
  subject?: string;
  htmlContent?: string;
  textContent?: string;
  variables?: TemplateVariable[];
  locale?: string;
  isActive?: boolean;
  metadata?: Record<string, any>;
}

export interface TemplateSearchFilters {
  type?: NotificationType;
  channel?: NotificationChannel;
  locale?: string;
  isActive?: boolean;
  name?: string;
}

@Injectable()
export class TemplateRepository {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Create a new template
   */
  async create(request: CreateTemplateRequest): Promise<TemplateData> {
    const templateContent = {
      subject: request.subject,
      htmlContent: request.htmlContent,
      textContent: request.textContent,
      variables: request.variables,
      locale: request.locale,
    };

    const template = await this.prisma.notificationTemplate.create({
      data: {
        name: request.name,
        type: request.type,
        channel: request.channel,
        template: templateContent as unknown as Prisma.InputJsonValue,
        version: 1,
        isActive: request.isActive ?? true,
        metadata: request.metadata || {},
      },
    });

    return this.mapToTemplateData(template);
  }

  /**
   * Find template by ID
   */
  async findById(id: string): Promise<TemplateData | null> {
    const template = await this.prisma.notificationTemplate.findUnique({
      where: { id },
    });

    return template ? this.mapToTemplateData(template) : null;
  }

  /**
   * Find template by name and type
   */
  async findByNameAndType(
    name: string,
    type: NotificationType,
  ): Promise<TemplateData | null> {
    const template = await this.prisma.notificationTemplate.findFirst({
      where: {
        name,
        type,
        isActive: true,
      },
      orderBy: {
        version: 'desc',
      },
    });

    return template ? this.mapToTemplateData(template) : null;
  }

  /**
   * Find templates with filters
   */
  async findMany(
    filters: TemplateSearchFilters = {},
    limit = 50,
    offset = 0,
  ): Promise<TemplateData[]> {
    const where: Record<string, unknown> = {};

    if (filters.type) where.type = filters.type;
    if (filters.channel) where.channel = filters.channel;
    if (filters.isActive !== undefined) where.isActive = filters.isActive;
    if (filters.name) {
      where.name = {
        contains: filters.name,
        mode: 'insensitive',
      };
    }

    const templates = await this.prisma.notificationTemplate.findMany({
      where,
      orderBy: [{ name: 'asc' }, { version: 'desc' }],
      take: limit,
      skip: offset,
    });

    return templates.map((template) => this.mapToTemplateData(template));
  }

  /**
   * Get all versions of a template
   */
  async findVersions(
    name: string,
    type: NotificationType,
  ): Promise<TemplateData[]> {
    const templates = await this.prisma.notificationTemplate.findMany({
      where: {
        name,
        type,
      },
      orderBy: {
        version: 'desc',
      },
    });

    return templates.map((template) => this.mapToTemplateData(template));
  }

  /**
   * Update template (creates new version)
   */
  async update(
    id: string,
    request: UpdateTemplateRequest,
  ): Promise<TemplateData> {
    const existingTemplate = await this.prisma.notificationTemplate.findUnique({
      where: { id },
    });

    if (!existingTemplate) {
      throw new Error('Template not found');
    }

    const existingTemplateContent = existingTemplate.template as Record<
      string,
      unknown
    >;
    const newTemplateContent = {
      subject: request.subject ?? (existingTemplateContent.subject as string),
      htmlContent:
        request.htmlContent ?? (existingTemplateContent.htmlContent as string),
      textContent:
        request.textContent ?? (existingTemplateContent.textContent as string),
      variables:
        request.variables ??
        (existingTemplateContent.variables as TemplateVariable[]),
      locale: request.locale ?? (existingTemplateContent.locale as string),
    };

    // Create new version
    const newVersion = await this.prisma.notificationTemplate.create({
      data: {
        name: request.name ?? existingTemplate.name,
        type: existingTemplate.type,
        channel: existingTemplate.channel,
        template: newTemplateContent as unknown as Prisma.InputJsonValue,
        version: existingTemplate.version + 1,
        isActive: request.isActive ?? existingTemplate.isActive,
        metadata: {
          ...(existingTemplate.metadata as Record<string, any>),
          ...request.metadata,
        },
      },
    });

    // Deactivate previous version if new version is active
    if (newVersion.isActive) {
      await this.prisma.notificationTemplate.updateMany({
        where: {
          name: newVersion.name,
          type: newVersion.type,
          id: { not: newVersion.id },
        },
        data: {
          isActive: false,
        },
      });
    }

    return this.mapToTemplateData(newVersion);
  }

  /**
   * Activate a specific template version
   */
  async activateVersion(id: string): Promise<TemplateData> {
    const template = await this.prisma.notificationTemplate.findUnique({
      where: { id },
    });

    if (!template) {
      throw new Error('Template not found');
    }

    // Deactivate all other versions
    await this.prisma.notificationTemplate.updateMany({
      where: {
        name: template.name,
        type: template.type,
        id: { not: id },
      },
      data: {
        isActive: false,
      },
    });

    // Activate this version
    const updatedTemplate = await this.prisma.notificationTemplate.update({
      where: { id },
      data: {
        isActive: true,
      },
    });

    return this.mapToTemplateData(updatedTemplate);
  }

  /**
   * Deactivate template
   */
  async deactivate(id: string): Promise<TemplateData> {
    const updatedTemplate = await this.prisma.notificationTemplate.update({
      where: { id },
      data: {
        isActive: false,
      },
    });

    return this.mapToTemplateData(updatedTemplate);
  }

  /**
   * Delete template (soft delete by deactivating)
   */
  async delete(id: string): Promise<void> {
    await this.prisma.notificationTemplate.update({
      where: { id },
      data: {
        isActive: false,
        metadata: {
          deletedAt: new Date().toISOString(),
        },
      },
    });
  }

  /**
   * Hard delete template (use with caution)
   */
  async hardDelete(id: string): Promise<void> {
    await this.prisma.notificationTemplate.delete({
      where: { id },
    });
  }

  /**
   * Get template usage statistics
   */
  getUsageStats(
    _templateId: string,
    _days = 30,
  ): {
    totalUsage: number;
    successfulDeliveries: number;
    failedDeliveries: number;
    averageRenderTime: number;
  } {
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - _days);

    // This would require additional tracking tables in a real implementation
    // For now, return mock data
    return {
      totalUsage: 0,
      successfulDeliveries: 0,
      failedDeliveries: 0,
      averageRenderTime: 0,
    };
  }

  /**
   * Validate template for healthcare compliance
   */
  validateHealthcareCompliance(templateData: TemplateData): {
    isCompliant: boolean;
    violations: string[];
    recommendations: string[];
  } {
    const violations: string[] = [];
    const recommendations: string[] = [];

    // Check for PII/PHI patterns in template content
    const allContent = `${templateData.subject} ${templateData.htmlContent} ${templateData.textContent}`;

    // Patterns that might indicate hardcoded sensitive data
    const sensitivePatterns = [
      {
        pattern: /\b\d{3}-\d{2}-\d{4}\b/,
        message: 'Potential SSN pattern detected',
      },
      {
        pattern: /\b\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}\b/,
        message: 'Potential credit card pattern detected',
      },
      {
        pattern: /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/,
        message: 'Hardcoded email address detected',
      },
      {
        pattern: /\b\d{3}[\s.-]?\d{3}[\s.-]?\d{4}\b/,
        message: 'Potential phone number pattern detected',
      },
    ];

    for (const { pattern, message } of sensitivePatterns) {
      if (pattern.test(allContent)) {
        violations.push(message);
      }
    }

    // Check for required elements in emergency templates
    if (templateData.type === NotificationType.EMERGENCY_ALERT) {
      if (
        !allContent.toLowerCase().includes('emergency') &&
        !allContent.toLowerCase().includes('urgent')
      ) {
        violations.push('Emergency templates must clearly indicate urgency');
      }

      if (!allContent.toLowerCase().includes('immediate')) {
        recommendations.push(
          'Consider adding "immediate action required" language',
        );
      }
    }

    // Check for medication safety requirements
    if (templateData.type === NotificationType.MEDICATION_REMINDER) {
      const requiredMedicationVars = ['medicationName', 'dosage'];
      const templateVarNames = templateData.variables.map((v) => v.name);

      for (const requiredVar of requiredMedicationVars) {
        if (!templateVarNames.includes(requiredVar)) {
          violations.push(
            `Medication templates must include ${requiredVar} variable`,
          );
        }
      }

      if (!allContent.toLowerCase().includes('prescribed')) {
        recommendations.push(
          'Include reminder to take medication as prescribed',
        );
      }
    }

    // Check for appointment requirements
    if (templateData.type === NotificationType.APPOINTMENT_REMINDER) {
      const requiredAppointmentVars = ['appointmentDate', 'providerName'];
      const templateVarNames = templateData.variables.map((v) => v.name);

      for (const requiredVar of requiredAppointmentVars) {
        if (!templateVarNames.includes(requiredVar)) {
          violations.push(
            `Appointment templates must include ${requiredVar} variable`,
          );
        }
      }
    }

    // Check for accessibility requirements
    if (templateData.htmlContent) {
      if (!templateData.htmlContent.includes('alt=')) {
        recommendations.push(
          'Consider adding alt text for images for accessibility',
        );
      }

      if (!templateData.htmlContent.includes('style=')) {
        recommendations.push(
          'Ensure sufficient color contrast for accessibility',
        );
      }
    }

    // Check for localization support
    if (!templateData.locale || templateData.locale === '') {
      violations.push('Template must specify a locale');
    }

    // Check for required variables validation
    for (const variable of templateData.variables) {
      if (variable.required && !variable.description) {
        violations.push(
          `Required variable ${variable.name} must have a description`,
        );
      }

      if (variable.type === 'string' && !variable.validation?.maxLength) {
        recommendations.push(
          `Consider adding max length validation for string variable ${variable.name}`,
        );
      }
    }

    return {
      isCompliant: violations.length === 0,
      violations,
      recommendations,
    };
  }

  /**
   * Clone template with new name
   */
  async clone(id: string, newName: string): Promise<TemplateData> {
    const originalTemplate = await this.prisma.notificationTemplate.findUnique({
      where: { id },
    });

    if (!originalTemplate) {
      throw new Error('Template not found');
    }

    const clonedTemplate = await this.prisma.notificationTemplate.create({
      data: {
        name: newName,
        type: originalTemplate.type,
        channel: originalTemplate.channel,
        template: originalTemplate.template as Prisma.InputJsonValue,
        version: 1,
        isActive: false, // Cloned templates start as inactive
        metadata: {
          ...(originalTemplate.metadata as Record<string, any>),
          clonedFrom: originalTemplate.id,
          clonedAt: new Date().toISOString(),
        },
      },
    });

    return this.mapToTemplateData(clonedTemplate);
  }

  /**
   * Search templates by content
   */
  async searchByContent(
    searchTerm: string,
    limit = 20,
  ): Promise<TemplateData[]> {
    const templates = await this.prisma.notificationTemplate.findMany({
      where: {
        OR: [
          {
            name: {
              contains: searchTerm,
              mode: 'insensitive',
            },
          },
          // Note: Cannot search JSON fields directly with Prisma
          // In a real implementation, you might use full-text search or extract fields
        ],
        isActive: true,
      },
      orderBy: {
        updatedAt: 'desc',
      },
      take: limit,
    });

    // Filter by content in application layer
    const filteredTemplates = templates.filter((template) => {
      const templateContent = template.template as Record<string, unknown>;
      const searchableContent =
        `${(templateContent.subject as string) || ''} ${(templateContent.htmlContent as string) || ''} ${(templateContent.textContent as string) || ''}`.toLowerCase();
      return searchableContent.includes(searchTerm.toLowerCase());
    });

    return filteredTemplates.map((template) =>
      this.mapToTemplateData(template),
    );
  }

  /**
   * Get templates by type and locale
   */
  async findByTypeAndLocale(
    type: NotificationType,
    locale: string,
  ): Promise<TemplateData[]> {
    const templates = await this.prisma.notificationTemplate.findMany({
      where: {
        type,
        isActive: true,
      },
      orderBy: {
        name: 'asc',
      },
    });

    // Filter by locale in application layer
    const filteredTemplates = templates.filter((template) => {
      const templateContent = template.template as Record<string, unknown>;
      return templateContent.locale === locale;
    });

    return filteredTemplates.map((template) =>
      this.mapToTemplateData(template),
    );
  }

  /**
   * Map Prisma model to TemplateData
   */
  private mapToTemplateData(template: Record<string, unknown>): TemplateData {
    const templateContent = template.template as Record<string, unknown>;

    return {
      id: template.id as string,
      name: template.name as string,
      type: template.type as NotificationType,
      subject: (templateContent.subject as string) || '',
      htmlContent: (templateContent.htmlContent as string) || '',
      textContent: (templateContent.textContent as string) || '',
      variables: (templateContent.variables as TemplateVariable[]) || [],
      locale: (templateContent.locale as string) || 'en',
      version: template.version as number,
      isActive: template.isActive as boolean,
      metadata: template.metadata as Record<string, any>,
    };
  }
}
