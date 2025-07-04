import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  NotificationTemplate,
  NotificationType,
  NotificationChannel,
  NotificationPriority,
} from '@prisma/client';
import {
  TemplateRenderingService,
  TemplateContext,
  TemplateMetadata,
} from './template-rendering.service';

export interface CreateTemplateDto {
  name: string;
  description?: string;
  type: NotificationType;
  titleTemplate: string;
  messageTemplate: string;
  placeholders: TemplateMetadata['placeholders'];
  channels?: NotificationChannel[];
  defaultPriority?: NotificationPriority;
  language?: string;
}

export interface UpdateTemplateDto {
  name?: string;
  description?: string;
  titleTemplate?: string;
  messageTemplate?: string;
  placeholders?: TemplateMetadata['placeholders'];
  channels?: NotificationChannel[];
  defaultPriority?: NotificationPriority;
  isActive?: boolean;
  language?: string;
}

export interface RenderedTemplate {
  title: string;
  message: string;
  channels: NotificationChannel[];
  priority: NotificationPriority;
  templateId: string;
  templateName: string;
}

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
      placeholders: template.placeholders as any,
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
    userPreferences?: {
      language?: string;
      channels?: NotificationChannel[];
    },
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
    user: any,
    prescription: any,
    additionalData: TemplateContext = {},
  ): TemplateContext {
    const baseContext = this.templateRenderer.createUserContext(
      user,
      additionalData,
    );

    return {
      ...baseContext,
      medicationName: prescription.medicationName,
      dosage: prescription.dosage,
      instructions: prescription.instructions,
      frequency: prescription.frequency,
      nextDose: prescription.nextDose
        ? new Date(prescription.nextDose).toLocaleTimeString()
        : '',
      prescriptionId: prescription.id,
      doctorName: prescription.doctorName || 'Your doctor',
      ...additionalData,
    };
  }

  /**
   * Create personalized context for care group notifications
   */
  createCareGroupContext(
    user: any,
    careGroup: any,
    additionalData: TemplateContext = {},
  ): TemplateContext {
    const baseContext = this.templateRenderer.createUserContext(
      user,
      additionalData,
    );

    return {
      ...baseContext,
      careGroupName: careGroup.name,
      careGroupId: careGroup.id,
      memberCount: careGroup.memberCount || 0,
      inviterName: careGroup.inviterName || 'Someone',
      ...additionalData,
    };
  }

  /**
   * Create personalized context for health alerts
   */
  createHealthAlertContext(
    user: any,
    alert: any,
    additionalData: TemplateContext = {},
  ): TemplateContext {
    const baseContext = this.templateRenderer.createUserContext(
      user,
      additionalData,
    );

    return {
      ...baseContext,
      alertType: alert.type,
      alertMessage: alert.message,
      severity: alert.severity,
      actionRequired: alert.actionRequired ? 'Yes' : 'No',
      ...additionalData,
    };
  }
}
