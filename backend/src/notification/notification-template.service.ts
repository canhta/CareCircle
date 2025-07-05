import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  NotificationTemplate,
  NotificationType,
  NotificationChannel,
  NotificationPriority,
} from '@prisma/client';
import { TemplateRenderingService } from './template-rendering.service';
import {
  CareGroupContextData,
  CreateTemplateDto,
  HealthAlertContextData,
  MedicationContextData,
  RenderedTemplate,
  UpdateTemplateDto,
  UserTemplatePreferences,
} from '../common/interfaces/notification-template.interfaces';
import {
  TemplateContext,
  TemplateMetadata,
  UserContextData,
} from '../common/interfaces/template-rendering.interfaces';

@Injectable()
export class NotificationTemplateService {
  private readonly logger = new Logger(NotificationTemplateService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly templateRenderer: TemplateRenderingService,
  ) {}

  /**
   * Create a new notification template
   */
  async createTemplate(data: CreateTemplateDto): Promise<NotificationTemplate> {
    const template = await this.prisma.notificationTemplate.create({
      data: {
        name: data.name,
        description: data.description,
        type: data.type,
        titleTemplate: data.titleTemplate,
        messageTemplate: data.messageTemplate,
        placeholders: data.placeholders,
        channels: data.channels || [],
        defaultPriority: data.defaultPriority || NotificationPriority.NORMAL,
        language: data.language || 'en',
      },
    });

    this.logger.debug(`Created template: ${template.name}`);
    return template;
  }

  /**
   * Get a template by ID
   */
  async getTemplate(id: string): Promise<NotificationTemplate> {
    const template = await this.prisma.notificationTemplate.findUnique({
      where: { id },
    });

    if (!template) {
      throw new NotFoundException(`Template with ID ${id} not found`);
    }

    return template;
  }

  /**
   * Get a template by name
   */
  async getTemplateByName(name: string): Promise<NotificationTemplate | null> {
    return this.prisma.notificationTemplate.findUnique({
      where: { name },
    });
  }

  /**
   * Get templates by type
   */
  async getTemplatesByType(
    type: NotificationType,
  ): Promise<NotificationTemplate[]> {
    return this.prisma.notificationTemplate.findMany({
      where: { type, isActive: true },
      orderBy: { createdAt: 'desc' },
    });
  }

  /**
   * Update a template
   */
  async updateTemplate(
    id: string,
    data: UpdateTemplateDto,
  ): Promise<NotificationTemplate> {
    const template = await this.prisma.notificationTemplate.update({
      where: { id },
      data: {
        ...data,
        updatedAt: new Date(),
      },
    });

    this.logger.debug(`Updated template: ${template.name}`);
    return template;
  }

  /**
   * Delete a template (soft delete by setting isActive to false)
   */
  async deleteTemplate(id: string): Promise<void> {
    await this.prisma.notificationTemplate.update({
      where: { id },
      data: { isActive: false },
    });

    this.logger.debug(`Deleted template: ${id}`);
  }

  /**
   * List all active templates
   */
  async listTemplates(): Promise<NotificationTemplate[]> {
    return this.prisma.notificationTemplate.findMany({
      where: { isActive: true },
      orderBy: { createdAt: 'desc' },
    });
  }

  /**
   * Render a template with context data
   */
  async renderTemplate(
    templateId: string,
    context: TemplateContext,
  ): Promise<RenderedTemplate> {
    const template = await this.getTemplate(templateId);

    // Validate context
    const metadata: TemplateMetadata = {
      placeholders: template.placeholders as TemplateMetadata['placeholders'],
    };

    const validation = this.templateRenderer.validateContext(
      template.titleTemplate,
      context,
      metadata,
    );

    if (!validation.valid) {
      throw new Error(
        `Template validation failed: ${validation.errors.join(', ')}`,
      );
    }

    // Render template
    const title = this.templateRenderer.render(template.titleTemplate, context);
    const message = this.templateRenderer.render(
      template.messageTemplate,
      context,
    );

    return {
      title,
      message,
      channels: template.channels,
      priority: template.defaultPriority,
      templateId: template.id,
      templateName: template.name,
    };
  }

  /**
   * Render template by name
   */
  async renderTemplateByName(
    name: string,
    context: TemplateContext,
  ): Promise<RenderedTemplate> {
    const template = await this.getTemplateByName(name);

    if (!template) {
      throw new NotFoundException(`Template with name ${name} not found`);
    }

    return this.renderTemplate(template.id, context);
  }

  /**
   * Get the best template for a notification type with user preferences
   */
  async getBestTemplate(
    type: NotificationType,
    userPreferences?: UserTemplatePreferences,
  ): Promise<NotificationTemplate | null> {
    const templates = await this.getTemplatesByType(type);

    if (templates.length === 0) {
      return null;
    }

    // Filter by language preference if provided
    if (userPreferences?.language) {
      const languageTemplates = templates.filter(
        (t) => t.language === userPreferences.language,
      );
      if (languageTemplates.length > 0) {
        return languageTemplates[0];
      }
    }

    // Return the most recent template
    return templates[0];
  }

  /**
   * Create personalized context for medication reminders
   */
  createMedicationContext(
    user: UserContextData,
    prescription: MedicationContextData,
    additionalData: TemplateContext = {},
  ): TemplateContext {
    // Start with basic user context
    const context = this.templateRenderer.createUserContext(
      user,
      additionalData,
    );

    // Add medication data
    const medicationContext: TemplateContext = {
      medicationName: prescription.medicationName,
      dosage: prescription.dosage,
      schedule: prescription.schedule,
      instructions: prescription.instructions || '',
      remainingDays: prescription.remainingDays || 0,
    };

    return { ...context, ...medicationContext };
  }

  /**
   * Create personalized context for care group notifications
   */
  createCareGroupContext(
    user: UserContextData,
    careGroup: CareGroupContextData,
    additionalData: TemplateContext = {},
  ): TemplateContext {
    // Start with basic user context
    const context = this.templateRenderer.createUserContext(
      user,
      additionalData,
    );

    // Add care group data
    const careGroupContext: TemplateContext = {
      careGroupName: careGroup.careGroupName,
      careGroupId: careGroup.careGroupId,
      memberCount: careGroup.memberCount,
      role: careGroup.role,
    };

    return { ...context, ...careGroupContext };
  }

  /**
   * Create personalized context for health alerts
   */
  createHealthAlertContext(
    user: UserContextData,
    alert: HealthAlertContextData,
    additionalData: TemplateContext = {},
  ): TemplateContext {
    // Start with basic user context
    const context = this.templateRenderer.createUserContext(
      user,
      additionalData,
    );

    // Add health alert data
    const alertContext: TemplateContext = {
      alertType: alert.alertType,
      alertSeverity: alert.alertSeverity,
      metricName: alert.metricName,
      metricValue: alert.metricValue,
      metricUnit: alert.metricUnit || '',
      thresholdValue: alert.thresholdValue || 0,
      recommendation: alert.recommendation || '',
    };

    return { ...context, ...alertContext };
  }
}
