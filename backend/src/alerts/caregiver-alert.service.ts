import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { NotificationService } from '../notification/notification.service';

export interface CaregiverAlert {
  id: string;
  type: 'urgent' | 'warning' | 'info';
  title: string;
  message: string;
  priority: number;
  timestamp: Date;
  userId: string;
  caregiverIds: string[];
  isRead: boolean;
  actions: AlertAction[];
}

export interface AlertAction {
  id: string;
  label: string;
  type: 'contact' | 'escalate' | 'acknowledge' | 'custom';
  metadata?: Record<string, unknown>;
}

export interface AlertCriteria {
  healthScoreThreshold: number;
  missedCheckInsCount: number;
  criticalSymptoms: string[];
  emergencyKeywords: string[];
}

@Injectable()
export class CaregiverAlertService {
  private readonly logger = new Logger(CaregiverAlertService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly notificationService: NotificationService,
  ) {}

  async generateCaregiverAlerts(
    userId: string,
    healthScore: number,
    insights: Record<string, unknown>,
    checkInData: Record<string, unknown>,
  ): Promise<CaregiverAlert[]> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: {
        careGroupMembers: {
          include: {
            careGroup: {
              include: {
                members: {
                  where: {
                    role: 'CAREGIVER',
                  },
                  include: {
                    user: true,
                  },
                },
              },
            },
          },
        },
      },
    });

    if (!user || !user.careGroupMembers.length) {
      return [];
    }

    const caregiverIds = user.careGroupMembers.flatMap((membership) =>
      membership.careGroup.members.map((member) => member.user.id),
    );

    const alerts: CaregiverAlert[] = [];

    // Check for urgent health score alerts
    if (healthScore < 30) {
      alerts.push(
        await this.createAlert(
          'urgent',
          'Critical Health Score Alert',
          `${user.firstName} ${user.lastName} has a critically low health score of ${healthScore}. Immediate attention may be required.`,
          userId,
          caregiverIds,
          10,
          [
            {
              id: 'contact',
              label: 'Contact Patient',
              type: 'contact',
              metadata: { phone: user.phone, email: user.email },
            },
            {
              id: 'escalate',
              label: 'Escalate to Medical Professional',
              type: 'escalate',
            },
          ],
        ),
      );
    } else if (healthScore < 50) {
      alerts.push(
        await this.createAlert(
          'warning',
          'Low Health Score Warning',
          `${user.firstName} ${user.lastName} has a concerning health score of ${healthScore}. Consider reaching out to check on their well-being.`,
          userId,
          caregiverIds,
          5,
          [
            {
              id: 'contact',
              label: 'Contact Patient',
              type: 'contact',
              metadata: { phone: user.phone, email: user.email },
            },
          ],
        ),
      );
    }

    // Check for missed check-ins
    const missedCheckIns = await this.getMissedCheckInsCount(userId);
    if (missedCheckIns >= 3) {
      alerts.push(
        await this.createAlert(
          'warning',
          'Missed Check-ins Alert',
          `${user.firstName} ${user.lastName} has missed ${missedCheckIns} consecutive daily check-ins. They may need support or encouragement.`,
          userId,
          caregiverIds,
          7,
          [
            {
              id: 'contact',
              label: 'Contact Patient',
              type: 'contact',
              metadata: { phone: user.phone, email: user.email },
            },
          ],
        ),
      );
    }

    // Check for critical symptoms
    const criticalSymptoms = this.detectCriticalSymptoms(checkInData);
    if (criticalSymptoms.length > 0) {
      alerts.push(
        await this.createAlert(
          'urgent',
          'Critical Symptoms Detected',
          `${user.firstName} ${user.lastName} has reported critical symptoms: ${criticalSymptoms.join(', ')}. Medical attention may be required.`,
          userId,
          caregiverIds,
          9,
          [
            {
              id: 'contact',
              label: 'Contact Patient',
              type: 'contact',
              metadata: { phone: user.phone, email: user.email },
            },
            {
              id: 'escalate',
              label: 'Emergency Response',
              type: 'escalate',
            },
          ],
        ),
      );
    }

    // Check for medication adherence issues
    const medicationConcerns = this.detectMedicationConcerns(insights);
    if (medicationConcerns.length > 0) {
      alerts.push(
        await this.createAlert(
          'warning',
          'Medication Adherence Concern',
          `${user.firstName} ${user.lastName} may be experiencing medication adherence issues: ${medicationConcerns.join(', ')}`,
          userId,
          caregiverIds,
          6,
          [
            {
              id: 'contact',
              label: 'Contact Patient',
              type: 'contact',
              metadata: { phone: user.phone, email: user.email },
            },
          ],
        ),
      );
    }

    // Send notifications for new alerts
    await this.sendAlertNotifications(alerts);

    return alerts;
  }

  private async createAlert(
    type: 'urgent' | 'warning' | 'info',
    title: string,
    message: string,
    userId: string,
    caregiverIds: string[],
    priority: number,
    actions: AlertAction[],
  ): Promise<CaregiverAlert> {
    const alert: CaregiverAlert = {
      id: `alert_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      type,
      title,
      message,
      priority,
      timestamp: new Date(),
      userId,
      caregiverIds,
      isRead: false,
      actions,
    };

    // Store alert in database
    this.storeAlert(alert);

    return alert;
  }

  private storeAlert(alert: CaregiverAlert): void {
    try {
      // Store in database - this would need proper schema
      this.logger.log(`Storing alert: ${alert.id} for user: ${alert.userId}`);
      // TODO: Implement actual database storage when alert schema is available
    } catch (error) {
      this.logger.error('Failed to store alert', error);
    }
  }

  private async getMissedCheckInsCount(userId: string): Promise<number> {
    const now = new Date();
    const threeDaysAgo = new Date(now.getTime() - 3 * 24 * 60 * 60 * 1000);

    const checkIns = await this.prisma.dailyCheckIn.findMany({
      where: {
        userId,
        createdAt: {
          gte: threeDaysAgo,
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });

    if (checkIns.length === 0) {
      return 3; // No check-ins found in the last 3 days
    }

    // Count days since last check-in
    const lastCheckIn = checkIns[0];
    const lastCheckInDate = lastCheckIn.createdAt;
    const daysSinceLastCheckIn = Math.floor(
      (now.getTime() - lastCheckInDate.getTime()) / (24 * 60 * 60 * 1000),
    );

    return daysSinceLastCheckIn;
  }

  private detectCriticalSymptoms(
    checkInData: Record<string, unknown>,
  ): string[] {
    const criticalSymptoms: string[] = [];

    // Extract symptoms array
    const symptoms = Array.isArray(checkInData.symptoms)
      ? checkInData.symptoms
      : [];

    // Critical symptom keywords
    const criticalKeywords = [
      'chest pain',
      'severe pain',
      'difficulty breathing',
      'shortness of breath',
      'fainting',
      'unconscious',
      'seizure',
      'unresponsive',
    ];

    // Check for critical symptoms
    for (const symptom of symptoms) {
      if (typeof symptom === 'string') {
        for (const keyword of criticalKeywords) {
          if (symptom.toLowerCase().includes(keyword)) {
            criticalSymptoms.push(symptom);
            break;
          }
        }
      }
    }

    // Check for high pain levels
    const painLevel =
      typeof checkInData.painLevel === 'number' ? checkInData.painLevel : 0;
    if (painLevel >= 8) {
      criticalSymptoms.push(`High pain level (${painLevel}/10)`);
    }

    return criticalSymptoms;
  }

  private detectMedicationConcerns(
    insights: Record<string, unknown>,
  ): string[] {
    const concerns: string[] = [];

    // Check for medication adherence issues in insights
    if (
      typeof insights.medicationAdherence === 'number' &&
      insights.medicationAdherence < 0.7
    ) {
      concerns.push('Low medication adherence');
    }

    if (
      Array.isArray(insights.missedMedications) &&
      insights.missedMedications.length > 0
    ) {
      concerns.push(
        `Missed medications: ${insights.missedMedications.length} in past week`,
      );
    }

    if (Array.isArray(insights.medicationWarnings)) {
      for (const warning of insights.medicationWarnings) {
        if (typeof warning === 'string') {
          concerns.push(warning);
        }
      }
    }

    return concerns;
  }

  private async sendAlertNotifications(
    alerts: CaregiverAlert[],
  ): Promise<void> {
    for (const alert of alerts) {
      for (const caregiverId of alert.caregiverIds) {
        await this.notificationService.sendNotification({
          userId: caregiverId,
          title: alert.title,
          message: alert.message,
          type: 'HEALTH_ALERT',
          priority: alert.type === 'urgent' ? 'HIGH' : 'NORMAL',
          channels: ['PUSH', 'EMAIL'],
          templateData: {
            alertId: alert.id,
            alertType: alert.type,
            patientId: alert.userId,
            actions: alert.actions,
            triggerType: 'care_alert',
          },
        });
      }
    }
  }
}
