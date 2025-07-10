import { Injectable, Logger } from '@nestjs/common';
import { MetricType } from '@prisma/client';
import {
  ValidationResult,
  ValidationSeverity,
} from './health-data-validation.service';

// Extended validation result with tracking metadata
interface ValidationResultWithMetadata extends ValidationResult {
  metricType: MetricType;
  timestamp: Date;
  userId: string;
}

export interface ValidationMetrics {
  totalValidations: number;
  successfulValidations: number;
  failedValidations: number;
  successRate: number;
  averageQualityScore: number;
  averageConfidenceScore: number;
  emergencyAlerts: number;
  complianceFlags: number;
  metricTypeBreakdown: Record<string, ValidationTypeMetrics>;
  severityBreakdown: Record<ValidationSeverity, number>;
  commonIssues: ValidationIssue[];
  trendAnalysis: ValidationTrend;
}

export interface ValidationTypeMetrics {
  metricType: MetricType;
  totalCount: number;
  successCount: number;
  failureCount: number;
  successRate: number;
  averageQualityScore: number;
  emergencyAlerts: number;
  mostCommonIssues: string[];
}

export interface ValidationIssue {
  issue: string;
  frequency: number;
  severity: ValidationSeverity;
  affectedMetricTypes: MetricType[];
  recommendations: string[];
}

export interface ValidationTrend {
  period: string;
  successRateTrend: 'improving' | 'declining' | 'stable';
  qualityScoreTrend: 'improving' | 'declining' | 'stable';
  emergencyAlertTrend: 'increasing' | 'decreasing' | 'stable';
  dataQualityDegradation: boolean;
  recommendations: string[];
}

export interface ValidationSummary {
  userId: string;
  period: {
    startDate: Date;
    endDate: Date;
  };
  metrics: ValidationMetrics;
  healthcareCompliance: {
    hipaaCompliance: number; // 0-100 score
    medicalDeviceCompliance: number; // 0-100 score
    clinicalDataQuality: number; // 0-100 score
    overallComplianceScore: number; // 0-100 score
  };
  recommendations: string[];
  alerts: ValidationAlert[];
}

export interface ValidationAlert {
  id: string;
  type: 'emergency' | 'quality_degradation' | 'compliance_issue';
  severity: ValidationSeverity;
  message: string;
  metricType: MetricType;
  timestamp: Date;
  resolved: boolean;
  recommendations: string[];
}

@Injectable()
export class ValidationMetricsService {
  private readonly logger = new Logger(ValidationMetricsService.name);
  private validationHistory: Map<string, ValidationResultWithMetadata[]> =
    new Map();
  private alertHistory: Map<string, ValidationAlert[]> = new Map();

  /**
   * Record validation result for metrics tracking
   */
  recordValidationResult(
    userId: string,
    metricType: MetricType,
    result: ValidationResult,
  ): void {
    const userHistory = this.validationHistory.get(userId) || [];
    const validationRecord: ValidationResultWithMetadata = {
      ...result,
      metricType,
      timestamp: new Date(),
      userId,
    };

    userHistory.push(validationRecord);
    this.validationHistory.set(userId, userHistory);

    // Generate alerts if necessary
    this.checkForAlerts(userId, metricType, result);

    this.logger.log(
      `Recorded validation result for user ${userId}, metric ${metricType}: ${result.isValid ? 'VALID' : 'INVALID'}`,
    );
  }

  /**
   * Get validation metrics for a user over a specific period
   */
  getValidationMetrics(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): ValidationMetrics {
    const userHistory = this.validationHistory.get(userId) || [];
    const periodHistory = userHistory.filter(
      (record: ValidationResultWithMetadata) =>
        record.timestamp >= startDate && record.timestamp <= endDate,
    );

    if (periodHistory.length === 0) {
      return this.getEmptyMetrics();
    }

    const totalValidations = periodHistory.length;
    const successfulValidations = periodHistory.filter(
      (record) => record.isValid,
    ).length;
    const failedValidations = totalValidations - successfulValidations;
    const successRate = (successfulValidations / totalValidations) * 100;

    const averageQualityScore =
      periodHistory.reduce((sum, record) => sum + record.qualityScore, 0) /
      totalValidations;

    const averageConfidenceScore =
      periodHistory.reduce((sum, record) => sum + record.confidence, 0) /
      totalValidations;

    const emergencyAlerts = periodHistory.filter(
      (record) => record.emergencyAlert,
    ).length;

    const complianceFlags = periodHistory.reduce(
      (sum, record) => sum + (record.complianceFlags?.length || 0),
      0,
    );

    // Metric type breakdown
    const metricTypeBreakdown =
      this.calculateMetricTypeBreakdown(periodHistory);

    // Severity breakdown
    const severityBreakdown = this.calculateSeverityBreakdown(periodHistory);

    // Common issues analysis
    const commonIssues = this.analyzeCommonIssues(periodHistory);

    // Trend analysis
    const trendAnalysis = this.analyzeTrends(userId, endDate);

    return {
      totalValidations,
      successfulValidations,
      failedValidations,
      successRate,
      averageQualityScore,
      averageConfidenceScore,
      emergencyAlerts,
      complianceFlags,
      metricTypeBreakdown,
      severityBreakdown,
      commonIssues,
      trendAnalysis,
    };
  }

  /**
   * Generate comprehensive validation summary report
   */
  generateValidationSummary(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): ValidationSummary {
    const metrics = this.getValidationMetrics(userId, startDate, endDate);
    const alerts = this.getAlertsForPeriod(userId, startDate, endDate);
    const compliance = this.calculateHealthcareCompliance(
      userId,
      startDate,
      endDate,
    );
    const recommendations = this.generateRecommendations(metrics, compliance);

    return {
      userId,
      period: { startDate, endDate },
      metrics,
      healthcareCompliance: compliance,
      recommendations,
      alerts,
    };
  }

  /**
   * Check for data quality degradation and generate alerts
   */
  private checkForAlerts(
    userId: string,
    metricType: MetricType,
    result: ValidationResult,
  ): void {
    const userAlerts = this.alertHistory.get(userId) || [];

    // Emergency alert
    if (result.emergencyAlert) {
      const alert: ValidationAlert = {
        id: `emergency_${Date.now()}`,
        type: 'emergency',
        severity: ValidationSeverity.CRITICAL,
        message: `Emergency threshold exceeded for ${metricType}`,
        metricType,
        timestamp: new Date(),
        resolved: false,
        recommendations: result.suggestions,
      };
      userAlerts.push(alert);
    }

    // Quality degradation alert
    if (result.qualityScore < 60) {
      const alert: ValidationAlert = {
        id: `quality_${Date.now()}`,
        type: 'quality_degradation',
        severity: ValidationSeverity.WARNING,
        message: `Data quality degradation detected for ${metricType}`,
        metricType,
        timestamp: new Date(),
        resolved: false,
        recommendations: [
          'Review data collection process',
          'Verify device calibration',
        ],
      };
      userAlerts.push(alert);
    }

    // Compliance issue alert
    if (result.complianceFlags.length > 0) {
      const alert: ValidationAlert = {
        id: `compliance_${Date.now()}`,
        type: 'compliance_issue',
        severity: ValidationSeverity.ERROR,
        message: `Healthcare compliance issues detected: ${result.complianceFlags.join(', ')}`,
        metricType,
        timestamp: new Date(),
        resolved: false,
        recommendations: [
          'Review data collection procedures',
          'Ensure HIPAA compliance',
        ],
      };
      userAlerts.push(alert);
    }

    this.alertHistory.set(userId, userAlerts);
  }

  private getEmptyMetrics(): ValidationMetrics {
    return {
      totalValidations: 0,
      successfulValidations: 0,
      failedValidations: 0,
      successRate: 0,
      averageQualityScore: 0,
      averageConfidenceScore: 0,
      emergencyAlerts: 0,
      complianceFlags: 0,
      metricTypeBreakdown: {},
      severityBreakdown: {
        [ValidationSeverity.INFO]: 0,
        [ValidationSeverity.WARNING]: 0,
        [ValidationSeverity.ERROR]: 0,
        [ValidationSeverity.CRITICAL]: 0,
      },
      commonIssues: [],
      trendAnalysis: {
        period: 'No data',
        successRateTrend: 'stable',
        qualityScoreTrend: 'stable',
        emergencyAlertTrend: 'stable',
        dataQualityDegradation: false,
        recommendations: [],
      },
    };
  }

  private calculateMetricTypeBreakdown(
    history: ValidationResultWithMetadata[],
  ): Record<string, ValidationTypeMetrics> {
    const breakdown: Record<string, ValidationTypeMetrics> = {};

    for (const record of history) {
      const metricType = record.metricType;
      if (!breakdown[metricType]) {
        breakdown[metricType] = {
          metricType,
          totalCount: 0,
          successCount: 0,
          failureCount: 0,
          successRate: 0,
          averageQualityScore: 0,
          emergencyAlerts: 0,
          mostCommonIssues: [],
        };
      }

      const metrics = breakdown[metricType];
      metrics.totalCount++;
      if (record.isValid) {
        metrics.successCount++;
      } else {
        metrics.failureCount++;
      }
      if (record.emergencyAlert) {
        metrics.emergencyAlerts++;
      }
    }

    // Calculate derived metrics
    for (const metricType in breakdown) {
      const metrics = breakdown[metricType];
      metrics.successRate = (metrics.successCount / metrics.totalCount) * 100;

      const typeRecords = history.filter(
        (r: ValidationResultWithMetadata) => r.metricType === metricType,
      );
      metrics.averageQualityScore =
        typeRecords.reduce((sum, r) => sum + r.qualityScore, 0) /
        typeRecords.length;
    }

    return breakdown;
  }

  private calculateSeverityBreakdown(
    history: ValidationResultWithMetadata[],
  ): Record<ValidationSeverity, number> {
    const breakdown = {
      [ValidationSeverity.INFO]: 0,
      [ValidationSeverity.WARNING]: 0,
      [ValidationSeverity.ERROR]: 0,
      [ValidationSeverity.CRITICAL]: 0,
    };

    for (const record of history) {
      breakdown[record.severity]++;
    }

    return breakdown;
  }

  private analyzeCommonIssues(
    history: ValidationResultWithMetadata[],
  ): ValidationIssue[] {
    const issueMap = new Map<string, ValidationIssue>();

    for (const record of history) {
      // Analyze errors and warnings
      [...record.errors, ...record.warnings].forEach((issue) => {
        if (!issueMap.has(issue)) {
          issueMap.set(issue, {
            issue,
            frequency: 0,
            severity: record.severity,
            affectedMetricTypes: [],
            recommendations: [],
          });
        }
        const issueRecord = issueMap.get(issue)!;
        issueRecord.frequency++;

        const metricType = record.metricType;
        if (!issueRecord.affectedMetricTypes.includes(metricType)) {
          issueRecord.affectedMetricTypes.push(metricType);
        }
      });
    }

    return Array.from(issueMap.values())
      .sort((a, b) => b.frequency - a.frequency)
      .slice(0, 10); // Top 10 most common issues
  }

  private analyzeTrends(_userId: string, _endDate: Date): ValidationTrend {
    // This would typically analyze historical data over time
    // For now, return a basic trend analysis
    return {
      period: 'Last 30 days',
      successRateTrend: 'stable',
      qualityScoreTrend: 'stable',
      emergencyAlertTrend: 'stable',
      dataQualityDegradation: false,
      recommendations: ['Continue current data collection practices'],
    };
  }

  private getAlertsForPeriod(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): ValidationAlert[] {
    const userAlerts = this.alertHistory.get(userId) || [];
    return userAlerts.filter(
      (alert) => alert.timestamp >= startDate && alert.timestamp <= endDate,
    );
  }

  private calculateHealthcareCompliance(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): ValidationSummary['healthcareCompliance'] {
    const userHistory = this.validationHistory.get(userId) || [];
    const periodHistory = userHistory.filter(
      (record: ValidationResultWithMetadata) =>
        record.timestamp >= startDate && record.timestamp <= endDate,
    );

    if (periodHistory.length === 0) {
      return {
        hipaaCompliance: 100,
        medicalDeviceCompliance: 100,
        clinicalDataQuality: 100,
        overallComplianceScore: 100,
      };
    }

    // Calculate compliance scores based on flags
    const totalRecords = periodHistory.length;
    const hipaaIssues = periodHistory.filter((r) =>
      r.complianceFlags?.some((flag: string) => flag.includes('HIPAA')),
    ).length;
    const deviceIssues = periodHistory.filter((r) =>
      r.complianceFlags?.some((flag: string) => flag.includes('FDA')),
    ).length;
    const clinicalIssues = periodHistory.filter((r) =>
      r.complianceFlags?.some((flag: string) => flag.includes('Clinical')),
    ).length;

    const hipaaCompliance = Math.max(
      0,
      100 - (hipaaIssues / totalRecords) * 100,
    );
    const medicalDeviceCompliance = Math.max(
      0,
      100 - (deviceIssues / totalRecords) * 100,
    );
    const clinicalDataQuality = Math.max(
      0,
      100 - (clinicalIssues / totalRecords) * 100,
    );
    const overallComplianceScore =
      (hipaaCompliance + medicalDeviceCompliance + clinicalDataQuality) / 3;

    return {
      hipaaCompliance,
      medicalDeviceCompliance,
      clinicalDataQuality,
      overallComplianceScore,
    };
  }

  private generateRecommendations(
    metrics: ValidationMetrics,
    compliance: ValidationSummary['healthcareCompliance'],
  ): string[] {
    const recommendations: string[] = [];

    if (metrics.successRate < 80) {
      recommendations.push(
        'Review data collection procedures to improve validation success rate',
      );
    }

    if (metrics.averageQualityScore < 70) {
      recommendations.push('Implement data quality improvement measures');
    }

    if (compliance.overallComplianceScore < 90) {
      recommendations.push(
        'Address healthcare compliance issues to meet regulatory standards',
      );
    }

    if (metrics.emergencyAlerts > 0) {
      recommendations.push(
        'Review emergency alert protocols and response procedures',
      );
    }

    return recommendations;
  }
}
