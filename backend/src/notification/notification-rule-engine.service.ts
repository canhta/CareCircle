import { Injectable, Logger } from '@nestjs/common';
import { HealthInsight } from '../insights/insight-generator.service';

export interface NotificationRule {
  id: string;
  name: string;
  description: string;
  condition: (data: any) => boolean;
  triggerType: 'insight' | 'risk_alert' | 'follow_up' | 'engagement';
  priority: 'low' | 'medium' | 'high' | 'critical';
  enabled: boolean;
}

export interface RuleEvaluationData {
  insight?: HealthInsight;
  riskScore?: number;
  trends?: string[];
  symptoms?: string[];
  prescriptions?: any[];
  missedDays?: number;
  totalCheckIns?: number;
  lastCheckIn?: Date;
  userContext?: any;
}

@Injectable()
export class NotificationRuleEngine {
  private readonly logger = new Logger(NotificationRuleEngine.name);

  // Configurable notification rules
  private readonly defaultRules: NotificationRule[] = [
    {
      id: 'high_risk_score',
      name: 'High Risk Score Alert',
      description: 'Trigger critical alert when risk score is 8 or higher',
      condition: (data: RuleEvaluationData) => (data.riskScore ?? 0) >= 8,
      triggerType: 'risk_alert',
      priority: 'critical',
      enabled: true,
    },
    {
      id: 'declining_trend',
      name: 'Declining Health Trend',
      description: 'Alert when health metrics show declining trend for 3+ days',
      condition: (data: RuleEvaluationData) =>
        Boolean(
          data.trends?.includes('declining') &&
            (data.userContext?.durationDays ?? 0) >= 3,
        ),
      triggerType: 'insight',
      priority: 'high',
      enabled: true,
    },
    {
      id: 'missed_checkins',
      name: 'Missed Check-ins Follow-up',
      description: 'Engage users who missed 2 or more check-ins',
      condition: (data: RuleEvaluationData) => (data.missedDays ?? 0) >= 2,
      triggerType: 'engagement',
      priority: 'medium',
      enabled: true,
    },
    {
      id: 'medication_concern',
      name: 'Medication Side Effects Alert',
      description: 'Alert when symptoms suggest medication side effects',
      condition: (data: RuleEvaluationData) =>
        Boolean(
          data.symptoms?.some((symptom: string) =>
            ['nausea', 'dizziness', 'fatigue'].includes(symptom.toLowerCase()),
          ) && (data.prescriptions?.length ?? 0) > 0,
        ),
      triggerType: 'insight',
      priority: 'high',
      enabled: true,
    },
    {
      id: 'high_severity_insight',
      name: 'High Severity Health Insight',
      description: 'Alert for high severity health insights',
      condition: (data: RuleEvaluationData) =>
        data.insight?.severity === 'high' || data.insight?.type === 'concern',
      triggerType: 'insight',
      priority: 'high',
      enabled: true,
    },
  ];

  /**
   * Evaluate all rules against provided data and return matching rules
   */
  evaluateRules(data: RuleEvaluationData): NotificationRule[] {
    try {
      const matchingRules = this.defaultRules.filter((rule) => {
        if (!rule.enabled) return false;

        try {
          return rule.condition(data);
        } catch (error) {
          this.logger.warn(
            `Error evaluating rule ${rule.id}: ${error.message}`,
          );
          return false;
        }
      });

      this.logger.debug(
        `Evaluated ${this.defaultRules.length} rules, ${matchingRules.length} matched`,
        { matchingRuleIds: matchingRules.map((r) => r.id) },
      );

      return matchingRules;
    } catch (error) {
      this.logger.error('Error during rule evaluation:', error);
      return [];
    }
  }

  /**
   * Get all available rules
   */
  getAllRules(): NotificationRule[] {
    return [...this.defaultRules];
  }

  /**
   * Get rules by trigger type
   */
  getRulesByTriggerType(triggerType: string): NotificationRule[] {
    return this.defaultRules.filter((rule) => rule.triggerType === triggerType);
  }

  /**
   * Enable or disable a specific rule
   */
  toggleRule(ruleId: string, enabled: boolean): boolean {
    const rule = this.defaultRules.find((r) => r.id === ruleId);
    if (rule) {
      rule.enabled = enabled;
      this.logger.log(`Rule ${ruleId} ${enabled ? 'enabled' : 'disabled'}`);
      return true;
    }
    return false;
  }

  /**
   * Add custom rule (for future extensibility)
   */
  addCustomRule(rule: NotificationRule): void {
    this.defaultRules.push(rule);
    this.logger.log(`Added custom rule: ${rule.id}`);
  }

  /**
   * Create evaluation data from health insight
   */
  createInsightEvaluationData(
    insight: HealthInsight,
    additionalContext?: any,
  ): RuleEvaluationData {
    return {
      insight,
      riskScore: insight.confidence * 10, // Convert to 1-10 scale
      trends: [insight.type],
      symptoms: additionalContext?.symptoms || [],
      prescriptions: additionalContext?.prescriptions || [],
      userContext: additionalContext,
    };
  }

  /**
   * Create evaluation data from engagement metrics
   */
  createEngagementEvaluationData(
    missedDays: number,
    totalCheckIns: number,
    lastCheckIn?: Date,
  ): RuleEvaluationData {
    return {
      missedDays,
      totalCheckIns,
      lastCheckIn,
    };
  }
}
