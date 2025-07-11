import { Injectable, Logger } from '@nestjs/common';
import { NotificationChannel } from '@prisma/client';
import { PushNotificationService } from '../../infrastructure/services/push-notification.service';
import { EmailNotificationService } from '../../infrastructure/services/email-notification.service';

export interface EmergencyContact {
  id: string;
  userId: string;
  name: string;
  relationship:
    | 'family'
    | 'friend'
    | 'caregiver'
    | 'healthcare_provider'
    | 'emergency_contact';
  email?: string;
  phone?: string;
  pushTokens?: string[];
  priority: number; // 1 = highest priority
  isActive: boolean;
  notificationPreferences: {
    email: boolean;
    push: boolean;
    sms: boolean;
  };
}

export interface EscalationRule {
  id: string;
  name: string;
  triggerConditions: EscalationTrigger[];
  escalationLevels: EscalationLevel[];
  isActive: boolean;
  applicableTypes: string[];
  metadata: Record<string, any>;
}

export interface EscalationTrigger {
  type:
    | 'no_response'
    | 'critical_alert'
    | 'emergency_type'
    | 'vital_signs'
    | 'medication_missed';
  timeoutMinutes?: number;
  conditions: Record<string, any>;
}

export interface EscalationLevel {
  level: number;
  delayMinutes: number;
  contacts: string[]; // Emergency contact IDs
  channels: NotificationChannel[];
  message: string;
  requiresAcknowledgment: boolean;
  autoEscalate: boolean;
}

export interface EmergencyAlert {
  id: string;
  userId: string;
  type:
    | 'medical_emergency'
    | 'medication_critical'
    | 'vital_signs_critical'
    | 'fall_detected'
    | 'no_response'
    | 'panic_button';
  severity: 'low' | 'medium' | 'high' | 'critical';
  message: string;
  location?: {
    latitude: number;
    longitude: number;
    address?: string;
  };
  vitals?: {
    heartRate?: number;
    bloodPressure?: string;
    temperature?: number;
    oxygenSaturation?: number;
  };
  triggeredAt: Date;
  acknowledgedAt?: Date;
  acknowledgedBy?: string;
  escalationHistory: EscalationEvent[];
  metadata: Record<string, any>;
}

export interface EscalationEvent {
  level: number;
  triggeredAt: Date;
  contacts: string[];
  channels: NotificationChannel[];
  deliveryResults: EscalationDeliveryResult[];
  acknowledged: boolean;
  acknowledgedAt?: Date;
  acknowledgedBy?: string;
}

export interface EscalationDeliveryResult {
  contactId: string;
  channel: NotificationChannel;
  success: boolean;
  messageId?: string;
  error?: string;
  deliveredAt: Date;
}

@Injectable()
export class EmergencyEscalationService {
  private readonly logger = new Logger(EmergencyEscalationService.name);

  private readonly defaultEscalationRules: EscalationRule[] = [
    {
      id: 'critical-medical-emergency',
      name: 'Critical Medical Emergency',
      triggerConditions: [
        {
          type: 'critical_alert',
          conditions: { severity: 'critical' },
        },
      ],
      escalationLevels: [
        {
          level: 1,
          delayMinutes: 0, // Immediate
          contacts: ['primary_emergency_contact'],
          channels: [NotificationChannel.PUSH, NotificationChannel.EMAIL],
          message:
            '🚨 CRITICAL MEDICAL EMERGENCY - Immediate response required for {{patientName}}',
          requiresAcknowledgment: true,
          autoEscalate: true,
        },
        {
          level: 2,
          delayMinutes: 5,
          contacts: ['secondary_emergency_contact', 'healthcare_provider'],
          channels: [
            NotificationChannel.PUSH,
            NotificationChannel.EMAIL,
            NotificationChannel.SMS,
          ],
          message:
            '🚨 ESCALATED EMERGENCY - No response to critical alert for {{patientName}}',
          requiresAcknowledgment: true,
          autoEscalate: true,
        },
        {
          level: 3,
          delayMinutes: 10,
          contacts: ['all_emergency_contacts'],
          channels: [
            NotificationChannel.PUSH,
            NotificationChannel.EMAIL,
            NotificationChannel.SMS,
          ],
          message:
            '🚨 URGENT ESCALATION - Multiple attempts failed for emergency involving {{patientName}}',
          requiresAcknowledgment: false,
          autoEscalate: false,
        },
      ],
      isActive: true,
      applicableTypes: [
        'medical_emergency',
        'vital_signs_critical',
        'fall_detected',
      ],
      metadata: {},
    },
    {
      id: 'medication-critical',
      name: 'Critical Medication Alert',
      triggerConditions: [
        {
          type: 'medication_missed',
          timeoutMinutes: 60,
          conditions: { criticality: 'high' },
        },
      ],
      escalationLevels: [
        {
          level: 1,
          delayMinutes: 0,
          contacts: ['primary_caregiver'],
          channels: [NotificationChannel.PUSH, NotificationChannel.EMAIL],
          message:
            '⚠️ Critical medication missed by {{patientName}} - {{medicationName}}',
          requiresAcknowledgment: true,
          autoEscalate: true,
        },
        {
          level: 2,
          delayMinutes: 30,
          contacts: ['healthcare_provider', 'emergency_contact'],
          channels: [NotificationChannel.PUSH, NotificationChannel.EMAIL],
          message:
            '⚠️ ESCALATED: Critical medication still not taken by {{patientName}}',
          requiresAcknowledgment: true,
          autoEscalate: false,
        },
      ],
      isActive: true,
      applicableTypes: ['medication_critical'],
      metadata: {},
    },
  ];

  constructor(
    private readonly pushNotificationService: PushNotificationService,
    private readonly emailNotificationService: EmailNotificationService,
  ) {}

  /**
   * Trigger emergency escalation
   */
  async triggerEmergencyEscalation(
    emergencyAlert: EmergencyAlert,
    emergencyContacts: EmergencyContact[],
  ): Promise<{
    escalationId: string;
    initialLevel: number;
    contactsNotified: string[];
    nextEscalationAt?: Date;
  }> {
    this.logger.log(
      `Triggering emergency escalation for alert ${emergencyAlert.id}`,
    );

    // Find applicable escalation rule
    const rule = this.findApplicableEscalationRule(emergencyAlert);
    if (!rule) {
      throw new Error(
        'No applicable escalation rule found for emergency alert',
      );
    }

    // Start with level 1 escalation
    const firstLevel = rule.escalationLevels[0];
    if (!firstLevel) {
      throw new Error('No escalation levels defined in rule');
    }

    // Get contacts for first level
    const levelContacts = this.getContactsForLevel(
      firstLevel,
      emergencyContacts,
    );

    // Send notifications for first level
    const deliveryResults = await this.sendEscalationNotifications(
      emergencyAlert,
      firstLevel,
      levelContacts,
    );

    // Create escalation event
    const escalationEvent: EscalationEvent = {
      level: 1,
      triggeredAt: new Date(),
      contacts: levelContacts.map((c) => c.id),
      channels: firstLevel.channels,
      deliveryResults,
      acknowledged: false,
    };

    // Update emergency alert with escalation history
    emergencyAlert.escalationHistory.push(escalationEvent);

    // Schedule next escalation if auto-escalate is enabled
    let nextEscalationAt: Date | undefined;
    if (firstLevel.autoEscalate && rule.escalationLevels.length > 1) {
      nextEscalationAt = new Date(Date.now() + firstLevel.delayMinutes * 60000);
      this.scheduleNextEscalation(
        emergencyAlert.id,
        rule.id,
        2,
        nextEscalationAt,
      );
    }

    const escalationId = `escalation_${emergencyAlert.id}_${Date.now()}`;

    this.logger.log(
      `Emergency escalation triggered: ${escalationId}, notified ${levelContacts.length} contacts`,
    );

    return {
      escalationId,
      initialLevel: 1,
      contactsNotified: levelContacts.map((c) => c.id),
      nextEscalationAt,
    };
  }

  /**
   * Acknowledge emergency alert
   */
  acknowledgeEmergencyAlert(
    alertId: string,
    acknowledgedBy: string,
    acknowledgmentMessage?: string,
  ): {
    acknowledged: boolean;
    escalationStopped: boolean;
    notifiedContacts: string[];
  } {
    this.logger.log(
      `Acknowledging emergency alert ${alertId} by ${acknowledgedBy}`,
    );

    // In a real implementation, this would update the database
    // For now, simulate the acknowledgment

    // Stop any pending escalations
    this.stopEscalation(alertId);

    // Notify all contacts that the emergency has been acknowledged
    const notificationMessage =
      acknowledgmentMessage ||
      `Emergency alert has been acknowledged by ${acknowledgedBy}. Situation is being handled.`;

    // Send acknowledgment notifications to all previously notified contacts
    const notifiedContacts = this.sendAcknowledgmentNotifications(
      alertId,
      notificationMessage,
      acknowledgedBy,
    );

    this.logger.log(
      `Emergency alert ${alertId} acknowledged, ${notifiedContacts.length} contacts notified`,
    );

    return {
      acknowledged: true,
      escalationStopped: true,
      notifiedContacts,
    };
  }

  /**
   * Escalate to next level
   */
  async escalateToNextLevel(
    alertId: string,
    ruleId: string,
    nextLevel: number,
    emergencyContacts: EmergencyContact[],
  ): Promise<{
    escalated: boolean;
    level: number;
    contactsNotified: string[];
    nextEscalationAt?: Date;
  }> {
    this.logger.log(`Escalating alert ${alertId} to level ${nextLevel}`);

    const rule = this.defaultEscalationRules.find((r) => r.id === ruleId);
    if (!rule) {
      throw new Error('Escalation rule not found');
    }

    const levelConfig = rule.escalationLevels.find(
      (l) => l.level === nextLevel,
    );
    if (!levelConfig) {
      this.logger.warn(
        `No escalation level ${nextLevel} found for rule ${ruleId}`,
      );
      return {
        escalated: false,
        level: nextLevel,
        contactsNotified: [],
      };
    }

    // Get contacts for this level
    const levelContacts = this.getContactsForLevel(
      levelConfig,
      emergencyContacts,
    );

    // Create mock emergency alert for escalation
    const mockAlert: EmergencyAlert = {
      id: alertId,
      userId: 'user_id',
      type: 'medical_emergency',
      severity: 'critical',
      message: 'Emergency escalation',
      triggeredAt: new Date(),
      escalationHistory: [],
      metadata: {},
    };

    // Send escalation notifications
    await this.sendEscalationNotifications(
      mockAlert,
      levelConfig,
      levelContacts,
    );

    // Schedule next escalation if applicable
    let nextEscalationAt: Date | undefined;
    if (
      levelConfig.autoEscalate &&
      rule.escalationLevels.some((l) => l.level > nextLevel)
    ) {
      nextEscalationAt = new Date(
        Date.now() + levelConfig.delayMinutes * 60000,
      );
      this.scheduleNextEscalation(
        alertId,
        ruleId,
        nextLevel + 1,
        nextEscalationAt,
      );
    }

    return {
      escalated: true,
      level: nextLevel,
      contactsNotified: levelContacts.map((c) => c.id),
      nextEscalationAt,
    };
  }

  /**
   * Get emergency contacts for user
   */
  getEmergencyContacts(userId: string): EmergencyContact[] {
    // In a real implementation, this would query the database
    // For now, return mock emergency contacts

    return [
      {
        id: 'primary_emergency_contact',
        userId,
        name: 'John Doe (Spouse)',
        relationship: 'family',
        email: 'john.doe@example.com',
        phone: '+1-555-0101',
        pushTokens: ['token_john_123'],
        priority: 1,
        isActive: true,
        notificationPreferences: {
          email: true,
          push: true,
          sms: true,
        },
      },
      {
        id: 'secondary_emergency_contact',
        userId,
        name: 'Jane Smith (Daughter)',
        relationship: 'family',
        email: 'jane.smith@example.com',
        phone: '+1-555-0102',
        pushTokens: ['token_jane_456'],
        priority: 2,
        isActive: true,
        notificationPreferences: {
          email: true,
          push: true,
          sms: false,
        },
      },
      {
        id: 'healthcare_provider',
        userId,
        name: 'Dr. Sarah Johnson',
        relationship: 'healthcare_provider',
        email: 'dr.johnson@healthcenter.com',
        phone: '+1-555-0103',
        priority: 3,
        isActive: true,
        notificationPreferences: {
          email: true,
          push: false,
          sms: true,
        },
      },
    ];
  }

  /**
   * Create emergency alert
   */
  createEmergencyAlert(
    userId: string,
    type: EmergencyAlert['type'],
    severity: EmergencyAlert['severity'],
    message: string,
    metadata?: Record<string, any>,
  ): EmergencyAlert {
    const alert: EmergencyAlert = {
      id: `emergency_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      userId,
      type,
      severity,
      message,
      triggeredAt: new Date(),
      escalationHistory: [],
      metadata: metadata || {},
    };

    this.logger.log(`Created emergency alert ${alert.id} for user ${userId}`);

    return alert;
  }

  /**
   * Find applicable escalation rule
   */
  private findApplicableEscalationRule(
    alert: EmergencyAlert,
  ): EscalationRule | null {
    for (const rule of this.defaultEscalationRules) {
      if (!rule.isActive) continue;

      // Check if alert type is applicable
      if (!rule.applicableTypes.includes(alert.type)) continue;

      // Check trigger conditions
      const conditionsMet = rule.triggerConditions.some((trigger) => {
        switch (trigger.type) {
          case 'critical_alert':
            return alert.severity === 'critical';
          case 'emergency_type':
            return trigger.conditions.type === alert.type;
          default:
            return false;
        }
      });

      if (conditionsMet) {
        return rule;
      }
    }

    return null;
  }

  /**
   * Get contacts for escalation level
   */
  private getContactsForLevel(
    level: EscalationLevel,
    allContacts: EmergencyContact[],
  ): EmergencyContact[] {
    const contacts: EmergencyContact[] = [];

    for (const contactId of level.contacts) {
      if (contactId === 'all_emergency_contacts') {
        contacts.push(...allContacts.filter((c) => c.isActive));
      } else {
        const contact = allContacts.find(
          (c) => c.id === contactId && c.isActive,
        );
        if (contact) {
          contacts.push(contact);
        }
      }
    }

    // Sort by priority
    return contacts.sort((a, b) => a.priority - b.priority);
  }

  /**
   * Send escalation notifications
   */
  private async sendEscalationNotifications(
    alert: EmergencyAlert,
    level: EscalationLevel,
    contacts: EmergencyContact[],
  ): Promise<EscalationDeliveryResult[]> {
    const results: EscalationDeliveryResult[] = [];

    for (const contact of contacts) {
      for (const channel of level.channels) {
        if (!this.isChannelEnabledForContact(channel, contact)) {
          continue;
        }

        try {
          const message = this.processEscalationMessage(
            level.message,
            alert,
            contact,
          );
          let deliveryResult:
            | { success: boolean; messageId?: string; error?: string }
            | undefined;

          switch (channel) {
            case NotificationChannel.PUSH:
              if (contact.pushTokens && contact.pushTokens.length > 0) {
                deliveryResult = await this.pushNotificationService.sendToToken(
                  contact.pushTokens[0],
                  this.pushNotificationService.createHealthcareNotification(
                    'Emergency Alert',
                    message,
                    'emergency',
                    { alertId: alert.id, contactId: contact.id },
                  ),
                );
              }
              break;

            case NotificationChannel.EMAIL:
              if (contact.email) {
                deliveryResult =
                  await this.emailNotificationService.sendEmergencyAlert(
                    contact.email,
                    alert.type,
                    message,
                    contact.name,
                  );
              }
              break;

            case NotificationChannel.SMS:
              // SMS would be implemented here
              deliveryResult = { success: false, error: 'SMS not implemented' };
              break;
          }

          results.push({
            contactId: contact.id,
            channel,
            success: deliveryResult?.success || false,
            messageId: deliveryResult?.messageId,
            error: deliveryResult?.error,
            deliveredAt: new Date(),
          });
        } catch (error) {
          results.push({
            contactId: contact.id,
            channel,
            success: false,
            error: error instanceof Error ? error.message : 'Unknown error',
            deliveredAt: new Date(),
          });
        }
      }
    }

    return results;
  }

  /**
   * Check if channel is enabled for contact
   */
  private isChannelEnabledForContact(
    channel: NotificationChannel,
    contact: EmergencyContact,
  ): boolean {
    switch (channel) {
      case NotificationChannel.PUSH:
        return (
          contact.notificationPreferences.push &&
          (contact.pushTokens?.length || 0) > 0
        );
      case NotificationChannel.EMAIL:
        return contact.notificationPreferences.email && !!contact.email;
      case NotificationChannel.SMS:
        return contact.notificationPreferences.sms && !!contact.phone;
      default:
        return false;
    }
  }

  /**
   * Process escalation message with variables
   */
  private processEscalationMessage(
    template: string,
    alert: EmergencyAlert,
    contact: EmergencyContact,
  ): string {
    return template
      .replace(/\{\{patientName\}\}/g, 'Patient') // Would get actual name from user data
      .replace(/\{\{contactName\}\}/g, contact.name)
      .replace(/\{\{alertType\}\}/g, alert.type)
      .replace(/\{\{severity\}\}/g, alert.severity)
      .replace(/\{\{message\}\}/g, alert.message)
      .replace(/\{\{time\}\}/g, alert.triggeredAt.toLocaleString());
  }

  /**
   * Schedule next escalation
   */
  private scheduleNextEscalation(
    alertId: string,
    ruleId: string,
    nextLevel: number,
    scheduledAt: Date,
  ): void {
    // In a real implementation, this would use a job queue or scheduler
    this.logger.log(
      `Scheduled escalation for alert ${alertId} to level ${nextLevel} at ${scheduledAt.toISOString()}`,
    );

    // Mock scheduling - in production, use Bull Queue, Agenda, or similar
    setTimeout(() => {
      void (async () => {
        try {
          const emergencyContacts = this.getEmergencyContacts('user_id'); // Would get actual user ID
          await this.escalateToNextLevel(
            alertId,
            ruleId,
            nextLevel,
            emergencyContacts,
          );
        } catch (error) {
          this.logger.error(
            `Failed to escalate alert ${alertId} to level ${nextLevel}:`,
            error,
          );
        }
      })();
    }, scheduledAt.getTime() - Date.now());
  }

  /**
   * Stop escalation
   */
  private stopEscalation(alertId: string): void {
    // In a real implementation, this would cancel scheduled jobs
    this.logger.log(`Stopping escalation for alert ${alertId}`);
  }

  /**
   * Send acknowledgment notifications
   */
  private sendAcknowledgmentNotifications(
    alertId: string,
    _message: string,
    _acknowledgedBy: string,
  ): string[] {
    // In a real implementation, this would notify all previously contacted emergency contacts
    this.logger.log(
      `Sending acknowledgment notifications for alert ${alertId}`,
    );

    // Mock implementation
    return ['primary_emergency_contact', 'secondary_emergency_contact'];
  }
}
