import { Injectable, Logger } from '@nestjs/common';
import {
  NotificationType,
  NotificationPriority,
  NotificationChannel,
} from '@prisma/client';
import { Notification } from '../../domain/entities/notification.entity';

export interface BatchingRule {
  id: string;
  name: string;
  notificationTypes: NotificationType[];
  batchWindow: number; // minutes
  maxBatchSize: number;
  minBatchSize: number;
  priority: NotificationPriority;
  channels: NotificationChannel[];
  isActive: boolean;
  conditions: BatchingCondition[];
}

export interface BatchingCondition {
  field: string; // e.g., 'userId', 'context.medicationId', 'type'
  operator: 'equals' | 'contains' | 'in' | 'not_equals';
  value: any;
}

export interface NotificationBatch {
  id: string;
  userId: string;
  notifications: Notification[];
  batchType: 'digest' | 'grouped' | 'frequency_controlled';
  createdAt: Date;
  scheduledFor: Date;
  priority: NotificationPriority;
  digestContent?: DigestContent;
  metadata: Record<string, any>;
}

export interface DigestContent {
  subject: string;
  summary: string;
  sections: DigestSection[];
  totalCount: number;
  highPriorityCount: number;
}

export interface DigestSection {
  type: NotificationType;
  title: string;
  items: DigestItem[];
  count: number;
}

export interface DigestItem {
  id: string;
  title: string;
  message: string;
  priority: NotificationPriority;
  createdAt: Date;
  metadata?: Record<string, any>;
}

export interface BatchingStrategy {
  type: 'time_based' | 'count_based' | 'smart_grouping' | 'frequency_control';
  parameters: Record<string, any>;
}

@Injectable()
export class NotificationBatchingService {
  private readonly logger = new Logger(NotificationBatchingService.name);

  private readonly defaultBatchingRules: BatchingRule[] = [
    {
      id: 'medication-reminders',
      name: 'Medication Reminders Batching',
      notificationTypes: [NotificationType.MEDICATION_REMINDER],
      batchWindow: 60, // 1 hour
      maxBatchSize: 5,
      minBatchSize: 2,
      priority: NotificationPriority.NORMAL,
      channels: [NotificationChannel.PUSH, NotificationChannel.EMAIL],
      isActive: true,
      conditions: [
        {
          field: 'userId',
          operator: 'equals',
          value: '{{userId}}', // Dynamic value
        },
      ],
    },
    {
      id: 'care-group-updates',
      name: 'Care Group Updates Digest',
      notificationTypes: [NotificationType.CARE_GROUP_UPDATE],
      batchWindow: 240, // 4 hours
      maxBatchSize: 10,
      minBatchSize: 3,
      priority: NotificationPriority.LOW,
      channels: [NotificationChannel.EMAIL],
      isActive: true,
      conditions: [
        {
          field: 'userId',
          operator: 'equals',
          value: '{{userId}}',
        },
      ],
    },
    {
      id: 'system-notifications',
      name: 'System Notifications Digest',
      notificationTypes: [NotificationType.SYSTEM_NOTIFICATION],
      batchWindow: 480, // 8 hours
      maxBatchSize: 15,
      minBatchSize: 2,
      priority: NotificationPriority.LOW,
      channels: [NotificationChannel.EMAIL, NotificationChannel.IN_APP],
      isActive: true,
      conditions: [
        {
          field: 'userId',
          operator: 'equals',
          value: '{{userId}}',
        },
      ],
    },
  ];

  /**
   * Determine if notifications should be batched
   */
  shouldBatchNotifications(
    notifications: Notification[],
    userId: string,
  ): {
    shouldBatch: boolean;
    batchingRule?: BatchingRule;
    strategy?: BatchingStrategy;
    reasoning: string;
  } {
    if (notifications.length === 0) {
      return {
        shouldBatch: false,
        reasoning: 'No notifications to batch',
      };
    }

    // Never batch emergency or urgent notifications
    const hasUrgentNotifications = notifications.some(
      (n) =>
        n.priority === NotificationPriority.URGENT ||
        n.type === NotificationType.EMERGENCY_ALERT,
    );

    if (hasUrgentNotifications) {
      return {
        shouldBatch: false,
        reasoning:
          'Contains urgent/emergency notifications that must be sent immediately',
      };
    }

    // Find applicable batching rule
    const applicableRule = this.findApplicableBatchingRule(
      notifications,
      userId,
    );

    if (!applicableRule) {
      return {
        shouldBatch: false,
        reasoning: 'No applicable batching rule found',
      };
    }

    // Check if we have enough notifications to batch
    if (notifications.length < applicableRule.minBatchSize) {
      return {
        shouldBatch: false,
        batchingRule: applicableRule,
        reasoning: `Not enough notifications (${notifications.length}) to meet minimum batch size (${applicableRule.minBatchSize})`,
      };
    }

    // Determine batching strategy
    const strategy = this.determineBatchingStrategy(
      notifications,
      applicableRule,
    );

    return {
      shouldBatch: true,
      batchingRule: applicableRule,
      strategy,
      reasoning: `Batching ${notifications.length} notifications using ${strategy.type} strategy`,
    };
  }

  /**
   * Create notification batch
   */
  createBatch(
    notifications: Notification[],
    userId: string,
    batchingRule: BatchingRule,
    strategy: BatchingStrategy,
  ): NotificationBatch {
    this.logger.log(
      `Creating batch for user ${userId} with ${notifications.length} notifications`,
    );

    const batchId = this.generateBatchId();
    const now = new Date();

    // Determine batch type and schedule
    const batchType = this.determineBatchType(strategy);
    const scheduledFor = this.calculateBatchSchedule(
      now,
      batchingRule,
      strategy,
    );

    // Create digest content if needed
    let digestContent: DigestContent | undefined;
    if (batchType === 'digest') {
      digestContent = this.createDigestContent(notifications);
    }

    const batch: NotificationBatch = {
      id: batchId,
      userId,
      notifications: notifications.slice(0, batchingRule.maxBatchSize),
      batchType,
      createdAt: now,
      scheduledFor,
      priority: this.calculateBatchPriority(notifications),
      digestContent,
      metadata: {
        batchingRuleId: batchingRule.id,
        strategy: strategy.type,
        originalNotificationCount: notifications.length,
        channels: batchingRule.channels,
      },
    };

    this.logger.log(
      `Created batch ${batchId} scheduled for ${scheduledFor.toISOString()}`,
    );

    return batch;
  }

  /**
   * Group related notifications
   */
  groupRelatedNotifications(
    notifications: Notification[],
    groupingCriteria: string[] = [
      'type',
      'context.medicationId',
      'context.appointmentId',
    ],
  ): Notification[][] {
    const groups: Map<string, Notification[]> = new Map();

    for (const notification of notifications) {
      const groupKey = this.generateGroupKey(notification, groupingCriteria);

      if (!groups.has(groupKey)) {
        groups.set(groupKey, []);
      }

      groups.get(groupKey)!.push(notification);
    }

    // Filter out single-item groups (no need to batch single notifications)
    return Array.from(groups.values()).filter((group) => group.length > 1);
  }

  /**
   * Create frequency-controlled batches
   */
  createFrequencyControlledBatches(
    notifications: Notification[],
    userId: string,
    maxNotificationsPerHour: number = 3,
    maxNotificationsPerDay: number = 20,
  ): NotificationBatch[] {
    const batches: NotificationBatch[] = [];
    const now = new Date();

    // Sort notifications by priority (urgent first)
    const sortedNotifications = [...notifications].sort((a, b) => {
      const priorityOrder = {
        [NotificationPriority.URGENT]: 0,
        [NotificationPriority.HIGH]: 1,
        [NotificationPriority.NORMAL]: 2,
        [NotificationPriority.LOW]: 3,
      };
      return priorityOrder[a.priority] - priorityOrder[b.priority];
    });

    let currentHourBatch: Notification[] = [];
    let currentHour = now.getHours();
    let notificationsThisHour = 0;
    let notificationsToday = 0;

    for (const notification of sortedNotifications) {
      // Check daily limit
      if (notificationsToday >= maxNotificationsPerDay) {
        // Schedule remaining notifications for tomorrow
        const tomorrowBatch = this.createDelayedBatch(
          sortedNotifications.slice(sortedNotifications.indexOf(notification)),
          userId,
          new Date(now.getTime() + 24 * 60 * 60 * 1000), // Tomorrow
        );
        batches.push(tomorrowBatch);
        break;
      }

      // Check hourly limit
      if (notificationsThisHour >= maxNotificationsPerHour) {
        // Create batch for current hour
        if (currentHourBatch.length > 0) {
          const hourlyBatch = this.createTimedBatch(
            currentHourBatch,
            userId,
            currentHour,
          );
          batches.push(hourlyBatch);
        }

        // Move to next hour
        currentHour = (currentHour + 1) % 24;
        currentHourBatch = [];
        notificationsThisHour = 0;
      }

      currentHourBatch.push(notification);
      notificationsThisHour++;
      notificationsToday++;
    }

    // Create final batch if there are remaining notifications
    if (currentHourBatch.length > 0) {
      const finalBatch = this.createTimedBatch(
        currentHourBatch,
        userId,
        currentHour,
      );
      batches.push(finalBatch);
    }

    return batches;
  }

  /**
   * Optimize batch delivery timing
   */
  optimizeBatchTiming(
    batch: NotificationBatch,
    userTimezone: string = 'UTC',
    userPreferences?: {
      preferredHours: number[];
      quietHours: { start: string; end: string };
    },
  ): Date {
    let optimizedTime = new Date(batch.scheduledFor);

    // Convert to user timezone
    const userTime = new Date(
      optimizedTime.toLocaleString('en-US', { timeZone: userTimezone }),
    );
    const hour = userTime.getHours();

    // Apply user preferences if available
    if (userPreferences) {
      // Check if scheduled time is in quiet hours
      const [quietStart, quietEnd] = [
        parseInt(userPreferences.quietHours.start.split(':')[0]),
        parseInt(userPreferences.quietHours.end.split(':')[0]),
      ];

      let inQuietHours = false;
      if (quietStart > quietEnd) {
        // Overnight quiet hours
        inQuietHours = hour >= quietStart || hour <= quietEnd;
      } else {
        inQuietHours = hour >= quietStart && hour <= quietEnd;
      }

      if (inQuietHours) {
        // Move to end of quiet hours
        optimizedTime.setHours(quietEnd, 0, 0, 0);
        if (optimizedTime <= new Date()) {
          optimizedTime.setDate(optimizedTime.getDate() + 1);
        }
      }

      // Prefer user's preferred hours
      if (
        userPreferences.preferredHours.length > 0 &&
        !userPreferences.preferredHours.includes(hour)
      ) {
        const nextPreferredHour =
          userPreferences.preferredHours.find((h) => h > hour) ||
          userPreferences.preferredHours[0];
        optimizedTime.setHours(nextPreferredHour, 0, 0, 0);

        if (optimizedTime <= new Date()) {
          optimizedTime.setDate(optimizedTime.getDate() + 1);
        }
      }
    }

    // Ensure we don't schedule too far in the future for high-priority batches
    if (batch.priority === NotificationPriority.HIGH) {
      const maxDelay = new Date(batch.createdAt.getTime() + 4 * 60 * 60 * 1000); // 4 hours max
      if (optimizedTime > maxDelay) {
        optimizedTime = maxDelay;
      }
    }

    return optimizedTime;
  }

  /**
   * Find applicable batching rule
   */
  private findApplicableBatchingRule(
    notifications: Notification[],
    userId: string,
  ): BatchingRule | null {
    for (const rule of this.defaultBatchingRules) {
      if (!rule.isActive) continue;

      // Check if notification types match
      const hasMatchingTypes = notifications.some((n) =>
        rule.notificationTypes.includes(n.type),
      );
      if (!hasMatchingTypes) continue;

      // Check conditions
      const conditionsMet = rule.conditions.every((condition) =>
        this.evaluateCondition(condition, notifications[0], userId),
      );

      if (conditionsMet) {
        return rule;
      }
    }

    return null;
  }

  /**
   * Determine batching strategy
   */
  private determineBatchingStrategy(
    notifications: Notification[],
    rule: BatchingRule,
  ): BatchingStrategy {
    // Smart grouping for related notifications
    if (this.hasRelatedNotifications(notifications)) {
      return {
        type: 'smart_grouping',
        parameters: {
          groupingCriteria: [
            'type',
            'context.medicationId',
            'context.appointmentId',
          ],
        },
      };
    }

    // Time-based batching for regular notifications
    if (rule.batchWindow > 0) {
      return {
        type: 'time_based',
        parameters: {
          windowMinutes: rule.batchWindow,
        },
      };
    }

    // Count-based batching
    return {
      type: 'count_based',
      parameters: {
        batchSize: rule.maxBatchSize,
      },
    };
  }

  /**
   * Create digest content
   */
  private createDigestContent(notifications: Notification[]): DigestContent {
    const sections: DigestSection[] = [];
    const typeGroups = new Map<NotificationType, Notification[]>();

    // Group by type
    for (const notification of notifications) {
      if (!typeGroups.has(notification.type)) {
        typeGroups.set(notification.type, []);
      }
      typeGroups.get(notification.type)!.push(notification);
    }

    // Create sections
    for (const [type, typeNotifications] of typeGroups) {
      const section: DigestSection = {
        type,
        title: this.getTypeDisplayName(type),
        count: typeNotifications.length,
        items: typeNotifications.map((n) => ({
          id: n.id,
          title: n.title,
          message: n.message,
          priority: n.priority,
          createdAt: n.createdAt,
          metadata: n.context,
        })),
      };
      sections.push(section);
    }

    const highPriorityCount = notifications.filter(
      (n) =>
        n.priority === NotificationPriority.HIGH ||
        n.priority === NotificationPriority.URGENT,
    ).length;

    return {
      subject: `CareCircle Digest - ${notifications.length} notifications`,
      summary: this.generateDigestSummary(notifications),
      sections,
      totalCount: notifications.length,
      highPriorityCount,
    };
  }

  /**
   * Generate digest summary
   */
  private generateDigestSummary(notifications: Notification[]): string {
    const typeCount = new Map<NotificationType, number>();

    for (const notification of notifications) {
      typeCount.set(
        notification.type,
        (typeCount.get(notification.type) || 0) + 1,
      );
    }

    const summaryParts: string[] = [];
    for (const [type, count] of typeCount) {
      summaryParts.push(
        `${count} ${this.getTypeDisplayName(type).toLowerCase()}`,
      );
    }

    return `You have ${summaryParts.join(', ')} waiting for your attention.`;
  }

  /**
   * Get display name for notification type
   */
  private getTypeDisplayName(type: NotificationType): string {
    const displayNames = {
      [NotificationType.MEDICATION_REMINDER]: 'Medication Reminders',
      [NotificationType.APPOINTMENT_REMINDER]: 'Appointment Reminders',
      [NotificationType.HEALTH_ALERT]: 'Health Alerts',
      [NotificationType.TASK_REMINDER]: 'Task Reminders',
      [NotificationType.CARE_GROUP_UPDATE]: 'Care Group Updates',
      [NotificationType.SYSTEM_NOTIFICATION]: 'System Notifications',
      [NotificationType.EMERGENCY_ALERT]: 'Emergency Alerts',
    };

    return displayNames[type] || type;
  }

  /**
   * Calculate batch priority
   */
  private calculateBatchPriority(
    notifications: Notification[],
  ): NotificationPriority {
    const priorities = notifications.map((n) => n.priority);

    if (priorities.includes(NotificationPriority.URGENT))
      return NotificationPriority.URGENT;
    if (priorities.includes(NotificationPriority.HIGH))
      return NotificationPriority.HIGH;
    if (priorities.includes(NotificationPriority.NORMAL))
      return NotificationPriority.NORMAL;
    return NotificationPriority.LOW;
  }

  /**
   * Calculate batch schedule
   */
  private calculateBatchSchedule(
    now: Date,
    rule: BatchingRule,
    strategy: BatchingStrategy,
  ): Date {
    switch (strategy.type) {
      case 'time_based':
        return new Date(now.getTime() + rule.batchWindow * 60000);
      case 'smart_grouping':
        return new Date(now.getTime() + 30 * 60000); // 30 minutes for smart grouping
      default:
        return new Date(now.getTime() + 15 * 60000); // 15 minutes default
    }
  }

  /**
   * Determine batch type
   */
  private determineBatchType(
    strategy: BatchingStrategy,
  ): 'digest' | 'grouped' | 'frequency_controlled' {
    switch (strategy.type) {
      case 'smart_grouping':
        return 'grouped';
      case 'frequency_control':
        return 'frequency_controlled';
      default:
        return 'digest';
    }
  }

  /**
   * Generate group key for notifications
   */
  private generateGroupKey(
    notification: Notification,
    criteria: string[],
  ): string {
    const keyParts: string[] = [];

    for (const criterion of criteria) {
      if (criterion === 'type') {
        keyParts.push(notification.type);
      } else if (criterion.startsWith('context.')) {
        const contextKey = criterion.substring(8);
        const contextValue = notification.context?.[contextKey] as string;
        if (contextValue) {
          keyParts.push(`${contextKey}:${contextValue}`);
        }
      }
    }

    return keyParts.join('|');
  }

  /**
   * Check if notifications are related
   */
  private hasRelatedNotifications(notifications: Notification[]): boolean {
    // Check if multiple notifications share the same medication or appointment
    const medicationIds = new Set();
    const appointmentIds = new Set();

    for (const notification of notifications) {
      if (notification.context?.medicationId) {
        medicationIds.add(notification.context.medicationId);
      }
      if (notification.context?.appointmentId) {
        appointmentIds.add(notification.context.appointmentId);
      }
    }

    return (
      medicationIds.size < notifications.length ||
      appointmentIds.size < notifications.length
    );
  }

  /**
   * Evaluate batching condition
   */
  private evaluateCondition(
    condition: BatchingCondition,
    notification: Notification,
    userId: string,
  ): boolean {
    let value = condition.value as string;

    // Replace dynamic values
    if (typeof value === 'string' && value.includes('{{userId}}')) {
      value = value.replace('{{userId}}', userId);
    }

    let fieldValue: unknown;
    if (condition.field === 'userId') {
      fieldValue = notification.userId;
    } else if (condition.field.startsWith('context.')) {
      const contextKey = condition.field.substring(8);
      fieldValue = notification.context?.[contextKey];
    } else {
      fieldValue = (notification as unknown as Record<string, unknown>)[
        condition.field
      ];
    }

    switch (condition.operator) {
      case 'equals':
        return fieldValue === value;
      case 'not_equals':
        return fieldValue !== value;
      case 'contains':
        return typeof fieldValue === 'string' && fieldValue.includes(value);
      case 'in':
        return Array.isArray(value) && value.includes(fieldValue);
      default:
        return false;
    }
  }

  /**
   * Create delayed batch
   */
  private createDelayedBatch(
    notifications: Notification[],
    userId: string,
    scheduledFor: Date,
  ): NotificationBatch {
    return {
      id: this.generateBatchId(),
      userId,
      notifications,
      batchType: 'frequency_controlled',
      createdAt: new Date(),
      scheduledFor,
      priority: this.calculateBatchPriority(notifications),
      metadata: {
        delayReason: 'Daily notification limit reached',
      },
    };
  }

  /**
   * Create timed batch
   */
  private createTimedBatch(
    notifications: Notification[],
    userId: string,
    hour: number,
  ): NotificationBatch {
    const scheduledFor = new Date();
    scheduledFor.setHours(hour, 0, 0, 0);

    if (scheduledFor <= new Date()) {
      scheduledFor.setDate(scheduledFor.getDate() + 1);
    }

    return {
      id: this.generateBatchId(),
      userId,
      notifications,
      batchType: 'frequency_controlled',
      createdAt: new Date(),
      scheduledFor,
      priority: this.calculateBatchPriority(notifications),
      metadata: {
        scheduledHour: hour,
      },
    };
  }

  /**
   * Generate unique batch ID
   */
  private generateBatchId(): string {
    return `batch_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }
}
