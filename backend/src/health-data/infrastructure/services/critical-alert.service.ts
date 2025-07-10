import { Injectable, Logger } from '@nestjs/common';
import { MetricType } from '@prisma/client';
import { HealthMetric } from '../../domain/entities/health-metric.entity';
import { ValidationResult } from './health-data-validation.service';

export enum AlertType {
  EMERGENCY_THRESHOLD = 'emergency_threshold',
  CRITICAL_VALUE = 'critical_value',
  DATA_QUALITY_DEGRADATION = 'data_quality_degradation',
  COMPLIANCE_VIOLATION = 'compliance_violation',
  DEVICE_MALFUNCTION = 'device_malfunction',
}

export enum AlertPriority {
  LOW = 'low',
  MEDIUM = 'medium',
  HIGH = 'high',
  CRITICAL = 'critical',
  EMERGENCY = 'emergency',
}

export interface CriticalAlert {
  id: string;
  userId: string;
  type: AlertType;
  priority: AlertPriority;
  metricType: MetricType;
  value: number;
  unit: string;
  threshold: {
    min?: number;
    max?: number;
    description: string;
  };
  message: string;
  medicalGuidance: string;
  immediateActions: string[];
  healthcareProviderAlert: boolean;
  emergencyServicesAlert: boolean;
  timestamp: Date;
  acknowledged: boolean;
  acknowledgedBy?: string;
  acknowledgedAt?: Date;
  resolved: boolean;
  resolvedAt?: Date;
  metadata: Record<string, any>;
}

export interface EmergencyThreshold {
  metricType: MetricType;
  ageGroup?: string;
  gender?: string;
  condition?: string;
  criticalMin?: number;
  criticalMax?: number;
  emergencyMin?: number;
  emergencyMax?: number;
  unit: string;
  medicalReference: string;
  immediateActions: string[];
  healthcareProviderRequired: boolean;
  emergencyServicesRequired: boolean;
}

@Injectable()
export class CriticalAlertService {
  private readonly logger = new Logger(CriticalAlertService.name);
  private activeAlerts: Map<string, CriticalAlert[]> = new Map();

  // Emergency thresholds based on medical guidelines
  private readonly emergencyThresholds: EmergencyThreshold[] = [
    // Heart Rate Emergency Thresholds
    {
      metricType: MetricType.HEART_RATE,
      ageGroup: 'adult',
      criticalMin: 50,
      criticalMax: 150,
      emergencyMin: 40,
      emergencyMax: 180,
      unit: 'bpm',
      medicalReference: 'American Heart Association Emergency Guidelines',
      immediateActions: [
        'Check patient responsiveness',
        'Monitor for symptoms of cardiac distress',
        'Prepare for potential cardiac intervention',
      ],
      healthcareProviderRequired: true,
      emergencyServicesRequired: false,
    },
    {
      metricType: MetricType.HEART_RATE,
      ageGroup: 'pediatric',
      criticalMin: 70,
      criticalMax: 200,
      emergencyMin: 60,
      emergencyMax: 220,
      unit: 'bpm',
      medicalReference: 'American Academy of Pediatrics Emergency Guidelines',
      immediateActions: [
        'Assess child for distress',
        'Check for fever or illness',
        'Contact pediatric emergency services if needed',
      ],
      healthcareProviderRequired: true,
      emergencyServicesRequired: false,
    },
    // Blood Pressure Emergency Thresholds
    {
      metricType: MetricType.BLOOD_PRESSURE,
      ageGroup: 'adult',
      criticalMin: 80,
      criticalMax: 180,
      emergencyMin: 70,
      emergencyMax: 200,
      unit: 'mmHg',
      medicalReference:
        'American Heart Association Hypertensive Crisis Guidelines',
      immediateActions: [
        'Assess for symptoms of hypertensive crisis',
        'Check for end-organ damage signs',
        'Prepare for immediate blood pressure management',
      ],
      healthcareProviderRequired: true,
      emergencyServicesRequired: true,
    },
    // Blood Glucose Emergency Thresholds
    {
      metricType: MetricType.BLOOD_GLUCOSE,
      criticalMin: 60,
      criticalMax: 300,
      emergencyMin: 40,
      emergencyMax: 400,
      unit: 'mg/dL',
      medicalReference: 'American Diabetes Association Emergency Guidelines',
      immediateActions: [
        'Assess for hypoglycemic/hyperglycemic symptoms',
        'Administer appropriate glucose management',
        'Monitor for diabetic ketoacidosis signs',
      ],
      healthcareProviderRequired: true,
      emergencyServicesRequired: false,
    },
    // Temperature Emergency Thresholds
    {
      metricType: MetricType.TEMPERATURE,
      criticalMin: 35.5,
      criticalMax: 39.0,
      emergencyMin: 35.0,
      emergencyMax: 41.0,
      unit: '°C',
      medicalReference: 'WHO Temperature Emergency Guidelines',
      immediateActions: [
        'Assess for signs of hypothermia/hyperthermia',
        'Implement temperature management protocols',
        'Monitor for complications',
      ],
      healthcareProviderRequired: true,
      emergencyServicesRequired: false,
    },
    // Oxygen Saturation Emergency Thresholds
    {
      metricType: MetricType.OXYGEN_SATURATION,
      criticalMin: 90,
      emergencyMin: 85,
      unit: '%',
      medicalReference: 'American Thoracic Society Oxygen Guidelines',
      immediateActions: [
        'Assess respiratory status immediately',
        'Administer supplemental oxygen if available',
        'Prepare for emergency respiratory support',
      ],
      healthcareProviderRequired: true,
      emergencyServicesRequired: true,
    },
  ];

  /**
   * Evaluate metric for critical alerts
   */
  evaluateForCriticalAlerts(
    metric: HealthMetric,
    validationResult: ValidationResult,
    patientAge?: number,
    patientGender?: string,
    healthConditions?: string[],
  ): CriticalAlert[] {
    const alerts: CriticalAlert[] = [];

    // Check emergency thresholds
    const emergencyAlert = this.checkEmergencyThresholds(
      metric,
      patientAge,
      patientGender,
      healthConditions,
    );
    if (emergencyAlert) {
      alerts.push(emergencyAlert);
    }

    // Check data quality degradation
    const qualityAlert = this.checkDataQualityDegradation(
      metric,
      validationResult,
    );
    if (qualityAlert) {
      alerts.push(qualityAlert);
    }

    // Check compliance violations
    const complianceAlert = this.checkComplianceViolations(
      metric,
      validationResult,
    );
    if (complianceAlert) {
      alerts.push(complianceAlert);
    }

    // Store active alerts
    if (alerts.length > 0) {
      const userAlerts = this.activeAlerts.get(metric.userId) || [];
      userAlerts.push(...alerts);
      this.activeAlerts.set(metric.userId, userAlerts);

      this.logger.warn(
        `Generated ${alerts.length} critical alerts for user ${metric.userId}, metric ${metric.metricType}`,
      );
    }

    return alerts;
  }

  /**
   * Get active alerts for a user
   */
  getActiveAlerts(userId: string): CriticalAlert[] {
    return this.activeAlerts.get(userId) || [];
  }

  /**
   * Acknowledge an alert
   */
  acknowledgeAlert(alertId: string, acknowledgedBy: string): boolean {
    for (const [userId, alerts] of this.activeAlerts.entries()) {
      const alert = alerts.find((a) => a.id === alertId);
      if (alert) {
        alert.acknowledged = true;
        alert.acknowledgedBy = acknowledgedBy;
        alert.acknowledgedAt = new Date();

        this.logger.log(
          `Alert ${alertId} acknowledged by ${acknowledgedBy} for user ${userId}`,
        );
        return true;
      }
    }
    return false;
  }

  /**
   * Resolve an alert
   */
  resolveAlert(alertId: string): boolean {
    for (const [userId, alerts] of this.activeAlerts.entries()) {
      const alertIndex = alerts.findIndex((a) => a.id === alertId);
      if (alertIndex !== -1) {
        alerts[alertIndex].resolved = true;
        alerts[alertIndex].resolvedAt = new Date();

        this.logger.log(`Alert ${alertId} resolved for user ${userId}`);
        return true;
      }
    }
    return false;
  }

  /**
   * Get emergency thresholds for a metric type
   */
  getEmergencyThresholds(metricType: MetricType): EmergencyThreshold[] {
    return this.emergencyThresholds.filter((t) => t.metricType === metricType);
  }

  private checkEmergencyThresholds(
    metric: HealthMetric,
    patientAge?: number,
    patientGender?: string,
    healthConditions?: string[],
  ): CriticalAlert | null {
    const thresholds = this.findBestThreshold(
      metric.metricType,
      patientAge,
      patientGender,
      healthConditions,
    );

    if (!thresholds) return null;

    let alertType: AlertType | null = null;
    let priority: AlertPriority | null = null;
    let thresholdDescription = '';

    // Check emergency thresholds
    if (
      (thresholds.emergencyMin !== undefined &&
        metric.value < thresholds.emergencyMin) ||
      (thresholds.emergencyMax !== undefined &&
        metric.value > thresholds.emergencyMax)
    ) {
      alertType = AlertType.EMERGENCY_THRESHOLD;
      priority = AlertPriority.EMERGENCY;
      thresholdDescription = `Emergency threshold (${thresholds.emergencyMin || 'N/A'}-${thresholds.emergencyMax || 'N/A'} ${thresholds.unit})`;
    }
    // Check critical thresholds
    else if (
      (thresholds.criticalMin !== undefined &&
        metric.value < thresholds.criticalMin) ||
      (thresholds.criticalMax !== undefined &&
        metric.value > thresholds.criticalMax)
    ) {
      alertType = AlertType.CRITICAL_VALUE;
      priority = AlertPriority.CRITICAL;
      thresholdDescription = `Critical threshold (${thresholds.criticalMin || 'N/A'}-${thresholds.criticalMax || 'N/A'} ${thresholds.unit})`;
    }

    if (!alertType || !priority) return null;

    return {
      id: `${alertType}_${metric.id}_${Date.now()}`,
      userId: metric.userId,
      type: alertType,
      priority,
      metricType: metric.metricType,
      value: metric.value,
      unit: metric.unit,
      threshold: {
        min: thresholds.criticalMin || thresholds.emergencyMin,
        max: thresholds.criticalMax || thresholds.emergencyMax,
        description: thresholdDescription,
      },
      message: `${priority.toUpperCase()}: ${metric.metricType} value ${metric.value} ${metric.unit} exceeds ${thresholdDescription}`,
      medicalGuidance: `Based on ${thresholds.medicalReference}`,
      immediateActions: thresholds.immediateActions,
      healthcareProviderAlert: thresholds.healthcareProviderRequired,
      emergencyServicesAlert: thresholds.emergencyServicesRequired,
      timestamp: new Date(),
      acknowledged: false,
      resolved: false,
      metadata: {
        metricId: metric.id,
        deviceId: metric.deviceId,
        source: metric.source,
        isManualEntry: metric.isManualEntry,
        medicalReference: thresholds.medicalReference,
      },
    };
  }

  private checkDataQualityDegradation(
    metric: HealthMetric,
    validationResult: ValidationResult,
  ): CriticalAlert | null {
    if (validationResult.qualityScore < 40) {
      return {
        id: `quality_${metric.id}_${Date.now()}`,
        userId: metric.userId,
        type: AlertType.DATA_QUALITY_DEGRADATION,
        priority: AlertPriority.HIGH,
        metricType: metric.metricType,
        value: metric.value,
        unit: metric.unit,
        threshold: {
          description: 'Data quality score below 40%',
        },
        message: `Severe data quality degradation detected for ${metric.metricType}`,
        medicalGuidance:
          'Review data collection procedures and device calibration',
        immediateActions: [
          'Verify device functionality',
          'Check data collection procedures',
          'Consider manual verification',
        ],
        healthcareProviderAlert: false,
        emergencyServicesAlert: false,
        timestamp: new Date(),
        acknowledged: false,
        resolved: false,
        metadata: {
          qualityScore: validationResult.qualityScore,
          confidence: validationResult.confidence,
          validationErrors: validationResult.errors,
        },
      };
    }
    return null;
  }

  private checkComplianceViolations(
    metric: HealthMetric,
    validationResult: ValidationResult,
  ): CriticalAlert | null {
    if (validationResult.complianceFlags.length > 2) {
      return {
        id: `compliance_${metric.id}_${Date.now()}`,
        userId: metric.userId,
        type: AlertType.COMPLIANCE_VIOLATION,
        priority: AlertPriority.HIGH,
        metricType: metric.metricType,
        value: metric.value,
        unit: metric.unit,
        threshold: {
          description: 'Multiple compliance violations detected',
        },
        message: `Healthcare compliance violations: ${validationResult.complianceFlags.join(', ')}`,
        medicalGuidance:
          'Address compliance issues to meet regulatory standards',
        immediateActions: [
          'Review HIPAA compliance procedures',
          'Verify medical device standards',
          'Update data collection protocols',
        ],
        healthcareProviderAlert: false,
        emergencyServicesAlert: false,
        timestamp: new Date(),
        acknowledged: false,
        resolved: false,
        metadata: {
          complianceFlags: validationResult.complianceFlags,
          validationStatus: metric.validationStatus,
        },
      };
    }
    return null;
  }

  private findBestThreshold(
    metricType: MetricType,
    patientAge?: number,
    patientGender?: string,
    healthConditions?: string[],
  ): EmergencyThreshold | null {
    const candidates = this.emergencyThresholds.filter(
      (t) => t.metricType === metricType,
    );

    if (candidates.length === 0) return null;

    // Find the most specific threshold
    let bestThreshold: EmergencyThreshold | null = null;
    let bestScore = -1;

    for (const threshold of candidates) {
      let score = 0;

      // Age group matching
      if (threshold.ageGroup && patientAge !== undefined) {
        const ageGroup = this.getAgeGroup(patientAge);
        if (threshold.ageGroup === ageGroup) {
          score += 10;
        } else {
          continue; // Skip if age group doesn't match
        }
      }

      // Gender matching
      if (threshold.gender && patientGender) {
        if (threshold.gender === patientGender) {
          score += 5;
        } else {
          continue; // Skip if gender doesn't match
        }
      }

      // Condition matching
      if (threshold.condition && healthConditions) {
        if (healthConditions.includes(threshold.condition)) {
          score += 15;
        } else {
          continue; // Skip if condition doesn't match
        }
      }

      if (score > bestScore) {
        bestScore = score;
        bestThreshold = threshold;
      }
    }

    return bestThreshold || candidates[0]; // Return first threshold if no specific match
  }

  private getAgeGroup(age: number): string {
    if (age <= 12) return 'pediatric';
    if (age <= 17) return 'adolescent';
    if (age <= 64) return 'adult';
    return 'geriatric';
  }
}
