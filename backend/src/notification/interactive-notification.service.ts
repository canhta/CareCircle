import { Injectable, Logger } from '@nestjs/common';
import { NotificationService } from './notification.service';
import { UserBehaviorAnalyticsService } from './user-behavior-analytics.service';
import { HealthInsight } from '../insights/insight-generator.service';
import {
  NotificationType,
  NotificationChannel,
  NotificationPriority,
} from '@prisma/client';

export interface InteractiveNotificationOptions {
  userId: string;
  triggerType: 'insight' | 'risk_alert' | 'follow_up' | 'engagement';
  triggerData: any;
  priority: 'low' | 'medium' | 'high' | 'critical';
  actions?: InteractiveAction[];
}

export interface InteractiveAction {
  id: string;
  label: string;
  type: 'quick_response' | 'navigate' | 'schedule' | 'contact';
  payload?: any;
}

@Injectable()
export class InteractiveNotificationService {
  private readonly logger = new Logger(InteractiveNotificationService.name);

  constructor(
    private readonly notificationService: NotificationService,
    private readonly behaviorAnalytics: UserBehaviorAnalyticsService,
  ) {}

  /**
   * Process insights and trigger interactive notifications based on rules
   */
  async processInsightNotifications(
    userId: string,
    insights: HealthInsight[],
    checkInData?: any,
  ): Promise<void> {
    try {
      for (const insight of insights) {
        if (this.shouldTriggerNotification(insight)) {
          await this.sendInteractiveNotification({
            userId,
            triggerType: 'insight',
            triggerData: { insight, ...checkInData },
            priority: this.mapSeverityToPriority(insight.severity),
            actions: this.generateActionsForInsight(insight),
          });
        }
      }
    } catch (error) {
      this.logger.error(
        `Error processing insight notifications for user ${userId}:`,
        error,
      );
    }
  }

  /**
   * Send an interactive notification using existing notification service
   */
  async sendInteractiveNotification(
    options: InteractiveNotificationOptions,
  ): Promise<void> {
    const { title, message } = this.generateNotificationContent(
      options.triggerType,
      options.triggerData,
    );

    // Use existing notification service
    await this.notificationService.sendNotification({
      userId: options.userId,
      title,
      message,
      type: this.mapTriggerTypeToNotificationType(options.triggerType),
      channels: this.getChannelsForPriority(options.priority),
      priority: this.mapPriorityToEnum(options.priority),
      actionUrl: this.getActionUrlForTrigger(options.triggerType),
      templateData: {
        actions: options.actions,
        triggerType: options.triggerType,
      },
    });
  }

  /**
   * Handle user response to interactive notification
   */
  async handleInteractiveResponse(
    userId: string,
    notificationId: string,
    actionId: string,
    responseData?: any,
  ): Promise<void> {
    try {
      // Track the interaction using existing behavior analytics
      await this.behaviorAnalytics.trackUserBehavior({
        userId,
        notificationId,
        action: 'clicked',
        deviceType: 'unknown',
        timestamp: new Date(),
        timeOfDay: new Date().getHours(),
        dayOfWeek: new Date().getDay(),
        notificationType: 'interactive',
        contextData: { actionId, responseData },
      });

      // Process the specific action
      await this.processInteractiveAction(userId, actionId, responseData);

      this.logger.log(
        `Handled interactive response for user ${userId}, notification ${notificationId}`,
      );
    } catch (error) {
      this.logger.error(
        `Error handling interactive response from user ${userId}:`,
        error,
      );
    }
  }

  // Private helper methods
  private shouldTriggerNotification(insight: HealthInsight): boolean {
    return insight.severity === 'high' || insight.type === 'concern';
  }

  private mapSeverityToPriority(
    severity: string,
  ): 'low' | 'medium' | 'high' | 'critical' {
    switch (severity) {
      case 'high':
        return 'high';
      case 'medium':
        return 'medium';
      case 'low':
        return 'low';
      default:
        return 'medium';
    }
  }

  private generateActionsForInsight(
    insight: HealthInsight,
  ): InteractiveAction[] {
    // Generate context-aware actions based on insight type
    switch (insight.type) {
      case 'concern':
        return [
          {
            id: 'contact_caregiver',
            label: 'Contact Caregiver',
            type: 'contact',
          },
          { id: 'view_details', label: 'View Details', type: 'navigate' },
        ];
      default:
        return [{ id: 'acknowledge', label: 'Got it', type: 'quick_response' }];
    }
  }

  private generateNotificationContent(
    triggerType: string,
    triggerData: any,
  ): { title: string; message: string } {
    switch (triggerType) {
      case 'insight':
        return {
          title: '💡 Health Insight',
          message:
            triggerData.insight?.description ||
            'We have important health insights for you.',
        };
      case 'risk_alert':
        return {
          title: '⚠️ Health Alert',
          message:
            "Your recent check-in shows concerning patterns. Let's take action.",
        };
      default:
        return {
          title: '🏥 CareCircle',
          message: 'We have an important update for you.',
        };
    }
  }

  private mapTriggerTypeToNotificationType(
    triggerType: string,
  ): NotificationType {
    switch (triggerType) {
      case 'insight':
        return 'AI_INSIGHT';
      case 'risk_alert':
        return 'HEALTH_ALERT';
      case 'engagement':
        return 'CHECK_IN_REMINDER';
      default:
        return 'SYSTEM_NOTIFICATION';
    }
  }

  private getChannelsForPriority(priority: string): NotificationChannel[] {
    switch (priority) {
      case 'critical':
        return ['PUSH', 'IN_APP', 'SMS'];
      case 'high':
        return ['PUSH', 'IN_APP'];
      case 'medium':
        return ['IN_APP', 'PUSH'];
      default:
        return ['IN_APP'];
    }
  }

  private mapPriorityToEnum(priority: string): NotificationPriority {
    switch (priority) {
      case 'critical':
        return 'CRITICAL';
      case 'high':
        return 'HIGH';
      case 'medium':
        return 'NORMAL';
      default:
        return 'NORMAL';
    }
  }

  private getActionUrlForTrigger(triggerType: string): string {
    switch (triggerType) {
      case 'insight':
        return '/insights';
      case 'risk_alert':
        return '/health-status';
      case 'engagement':
        return '/check-in';
      default:
        return '/dashboard';
    }
  }

  private async processInteractiveAction(
    userId: string,
    actionId: string,
    responseData?: any,
  ): Promise<void> {
    // Delegate to appropriate domain services based on action type
    this.logger.log(
      `Processing interactive action ${actionId} for user ${userId}`,
    );
    // Implementation would delegate to domain-specific services
  }
}
