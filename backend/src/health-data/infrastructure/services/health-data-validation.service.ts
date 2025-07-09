import { Injectable } from '@nestjs/common';
import { HealthMetric } from '../../domain/entities/health-metric.entity';
import { MetricType } from '@prisma/client';

export interface ValidationRule {
  metricType: MetricType;
  minValue: number;
  maxValue: number;
  unit: string;
  description: string;
}

export interface ValidationResult {
  isValid: boolean;
  warnings: string[];
  errors: string[];
  suggestions: string[];
  confidence: number; // 0-1 confidence score
  normalizedValue?: number; // Normalized value if unit conversion applied
  qualityScore: number; // 0-100 data quality score
}

@Injectable()
export class HealthDataValidationService {
  private readonly validationRules: ValidationRule[] = [
    {
      metricType: MetricType.HEART_RATE,
      minValue: 30,
      maxValue: 250,
      unit: 'bpm',
      description: 'Heart rate should be between 30-250 bpm',
    },
    {
      metricType: MetricType.BLOOD_PRESSURE,
      minValue: 70,
      maxValue: 250,
      unit: 'mmHg',
      description: 'Systolic blood pressure should be between 70-250 mmHg',
    },
    {
      metricType: MetricType.BLOOD_GLUCOSE,
      minValue: 20,
      maxValue: 600,
      unit: 'mg/dL',
      description: 'Blood glucose should be between 20-600 mg/dL',
    },
    {
      metricType: MetricType.TEMPERATURE,
      minValue: 35,
      maxValue: 42,
      unit: '°C',
      description: 'Body temperature should be between 35-42°C',
    },
    {
      metricType: MetricType.OXYGEN_SATURATION,
      minValue: 70,
      maxValue: 100,
      unit: '%',
      description: 'Blood oxygen saturation should be between 70-100%',
    },
    {
      metricType: MetricType.WEIGHT,
      minValue: 1,
      maxValue: 500,
      unit: 'kg',
      description: 'Weight should be between 1-500 kg',
    },
    {
      metricType: MetricType.STEPS,
      minValue: 0,
      maxValue: 100000,
      unit: 'steps',
      description: 'Daily steps should be between 0-100,000',
    },
    {
      metricType: MetricType.SLEEP_DURATION,
      minValue: 0,
      maxValue: 24,
      unit: 'hours',
      description: 'Sleep duration should be between 0-24 hours',
    },
  ];

  validateMetric(metric: HealthMetric): ValidationResult {
    const result: ValidationResult = {
      isValid: true,
      warnings: [],
      errors: [],
      suggestions: [],
      confidence: 1.0,
      qualityScore: 100,
    };

    const rule = this.validationRules.find(
      (r) => r.metricType === metric.metricType,
    );
    if (!rule) {
      result.warnings.push(
        `No validation rule found for metric type: ${metric.metricType}`,
      );
      return result;
    }

    // Basic range validation
    if (metric.value < rule.minValue || metric.value > rule.maxValue) {
      result.isValid = false;
      result.errors.push(
        `Value ${metric.value} ${metric.unit} is outside normal range (${rule.minValue}-${rule.maxValue} ${rule.unit})`,
      );
    }

    // Unit validation
    if (metric.unit !== rule.unit) {
      result.warnings.push(
        `Unit mismatch: expected ${rule.unit}, got ${metric.unit}`,
      );
    }

    // Metric-specific validations
    this.validateSpecificMetric(metric, result);

    // Temporal validation
    this.validateTemporal(metric, result);

    // Calculate quality score and confidence
    this.calculateQualityMetrics(metric, result);

    return result;
  }

  validateMetrics(metrics: HealthMetric[]): ValidationResult[] {
    return metrics.map((metric) => this.validateMetric(metric));
  }

  getValidationRule(metricType: MetricType): ValidationRule | undefined {
    return this.validationRules.find((r) => r.metricType === metricType);
  }

  getAllValidationRules(): ValidationRule[] {
    return [...this.validationRules];
  }

  private validateSpecificMetric(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    switch (metric.metricType) {
      case MetricType.BLOOD_PRESSURE:
        this.validateBloodPressure(metric, result);
        break;
      case MetricType.HEART_RATE:
        this.validateHeartRate(metric, result);
        break;
      case MetricType.BLOOD_GLUCOSE:
        this.validateBloodGlucose(metric, result);
        break;
      case MetricType.TEMPERATURE:
        this.validateBodyTemperature(metric, result);
        break;
      case MetricType.WEIGHT:
        this.validateWeight(metric, result);
        break;
      default:
        break;
    }
  }

  private validateBloodPressure(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    const systolic = metric.value;
    const diastolic = (metric.metadata?.diastolic as number) || 0;

    if (diastolic > 0) {
      if (diastolic < 40 || diastolic > 130) {
        result.warnings.push(
          `Diastolic pressure ${diastolic} mmHg may be unusual`,
        );
      }

      if (systolic <= diastolic) {
        result.errors.push(
          'Systolic pressure should be higher than diastolic pressure',
        );
        result.isValid = false;
      }

      // Hypertension warnings
      if (systolic >= 140 || diastolic >= 90) {
        result.warnings.push(
          'Blood pressure readings suggest hypertension - consult healthcare provider',
        );
      }

      // Hypotension warnings
      if (systolic < 90 || diastolic < 60) {
        result.warnings.push(
          'Blood pressure readings suggest hypotension - monitor closely',
        );
      }
    }
  }

  private validateHeartRate(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    const heartRate = metric.value;

    // Age-based validation (if available in metadata)
    const age = metric.metadata?.age as number;
    if (age) {
      const maxHeartRate = 220 - age;
      if (heartRate > maxHeartRate * 0.9) {
        result.warnings.push(
          `Heart rate ${heartRate} bpm is very high for age ${age}`,
        );
      }
    }

    // General warnings
    if (heartRate < 50) {
      result.warnings.push('Heart rate below 50 bpm may indicate bradycardia');
    } else if (heartRate > 100) {
      result.warnings.push('Heart rate above 100 bpm may indicate tachycardia');
    }
  }

  private validateBloodGlucose(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    const glucose = metric.value;
    const testType = (metric.metadata?.testType as string) || 'random';

    switch (testType) {
      case 'fasting':
        if (glucose > 126) {
          result.warnings.push(
            'Fasting glucose above 126 mg/dL may indicate diabetes',
          );
        } else if (glucose > 100) {
          result.warnings.push(
            'Fasting glucose above 100 mg/dL may indicate prediabetes',
          );
        }
        break;
      case 'postprandial':
        if (glucose > 200) {
          result.warnings.push(
            'Post-meal glucose above 200 mg/dL is concerning',
          );
        }
        break;
      case 'random':
        if (glucose > 200) {
          result.warnings.push(
            'Random glucose above 200 mg/dL may indicate diabetes',
          );
        }
        break;
    }
  }

  private validateBodyTemperature(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    const temp = metric.value;

    if (temp > 38.0) {
      result.warnings.push('Temperature above 38°C indicates fever');
    } else if (temp < 36.0) {
      result.warnings.push('Temperature below 36°C may indicate hypothermia');
    }

    if (temp > 40.0) {
      result.errors.push(
        'Temperature above 40°C is dangerously high - seek immediate medical attention',
      );
    }
  }

  private validateWeight(metric: HealthMetric, result: ValidationResult): void {
    const weight = metric.value;
    const height = metric.metadata?.height as number | undefined; // in cm

    if (height) {
      const heightInM = height / 100;
      const bmi = weight / (heightInM * heightInM);

      if (bmi < 18.5) {
        result.suggestions.push(`BMI ${bmi.toFixed(1)} indicates underweight`);
      } else if (bmi > 30) {
        result.warnings.push(`BMI ${bmi.toFixed(1)} indicates obesity`);
      } else if (bmi > 25) {
        result.suggestions.push(`BMI ${bmi.toFixed(1)} indicates overweight`);
      }
    }
  }

  private validateTemporal(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    const now = new Date();
    const metricTime = metric.timestamp;

    // Future timestamp validation
    if (metricTime > now) {
      result.errors.push('Metric timestamp cannot be in the future');
      result.isValid = false;
    }

    // Very old timestamp validation (more than 1 year)
    const oneYearAgo = new Date();
    oneYearAgo.setFullYear(now.getFullYear() - 1);

    if (metricTime < oneYearAgo) {
      result.warnings.push('Metric timestamp is more than 1 year old');
    }
  }

  private calculateQualityMetrics(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    let qualityScore = 100;
    let confidence = 1.0;

    // Reduce quality score for errors and warnings
    qualityScore -= result.errors.length * 30;
    qualityScore -= result.warnings.length * 10;

    // Adjust confidence based on data source
    switch (metric.source) {
      case 'MANUAL_ENTRY':
        confidence *= 0.8; // Manual entry less reliable
        break;
      case 'DEVICE_SYNC':
      case 'HEALTH_KIT':
      case 'GOOGLE_FIT':
        confidence *= 0.95; // Device data generally reliable
        break;
      case 'IMPORTED':
        confidence *= 0.7; // Imported data may have quality issues
        break;
    }

    // Adjust confidence based on validation status
    if (!result.isValid) {
      confidence *= 0.3;
      qualityScore = Math.min(qualityScore, 30);
    }

    // Adjust for manual entry flag
    if (metric.isManualEntry) {
      confidence *= 0.9;
      qualityScore -= 5;
    }

    // Ensure bounds
    qualityScore = Math.max(0, Math.min(100, qualityScore));
    confidence = Math.max(0, Math.min(1, confidence));

    result.qualityScore = qualityScore;
    result.confidence = confidence;
  }

  // Enhanced validation methods for specific health conditions
  validateMetricForCondition(
    metric: HealthMetric,
    healthConditions: string[],
  ): ValidationResult {
    const result = this.validateMetric(metric);

    // Apply condition-specific validation rules
    for (const condition of healthConditions) {
      this.applyConditionSpecificRules(metric, condition, result);
    }

    return result;
  }

  private applyConditionSpecificRules(
    metric: HealthMetric,
    condition: string,
    result: ValidationResult,
  ): void {
    switch (condition.toLowerCase()) {
      case 'diabetes':
        this.validateForDiabetes(metric, result);
        break;
      case 'hypertension':
        this.validateForHypertension(metric, result);
        break;
      case 'heart_disease':
        this.validateForHeartDisease(metric, result);
        break;
      default:
        break;
    }
  }

  private validateForDiabetes(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    if (metric.metricType === MetricType.BLOOD_GLUCOSE) {
      const glucose = metric.value;
      if (glucose > 180) {
        result.warnings.push(
          'Blood glucose level is concerning for diabetes management',
        );
        result.suggestions.push(
          'Consider consulting with your healthcare provider about glucose management',
        );
      }
    }
  }

  private validateForHypertension(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    if (metric.metricType === MetricType.BLOOD_PRESSURE) {
      const systolic = metric.value;
      const diastolic = (metric.metadata?.diastolic as number) || 0;

      if (systolic > 130 || diastolic > 80) {
        result.warnings.push(
          'Blood pressure reading is elevated for hypertension management',
        );
        result.suggestions.push(
          'Monitor blood pressure regularly and follow prescribed treatment plan',
        );
      }
    }
  }

  private validateForHeartDisease(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    if (metric.metricType === MetricType.HEART_RATE) {
      const heartRate = metric.value;
      if (heartRate > 120 || heartRate < 50) {
        result.warnings.push(
          'Heart rate reading may require attention given heart condition',
        );
        result.suggestions.push(
          'Consider discussing this reading with your cardiologist',
        );
      }
    }
  }

  // Batch validation for multiple metrics
  validateMetricBatch(metrics: HealthMetric[]): ValidationResult[] {
    return metrics.map((metric) => this.validateMetric(metric));
  }

  // Get validation summary for a set of metrics
  getValidationSummary(validationResults: ValidationResult[]): {
    totalMetrics: number;
    validMetrics: number;
    invalidMetrics: number;
    averageQualityScore: number;
    averageConfidence: number;
    commonIssues: string[];
  } {
    const totalMetrics = validationResults.length;
    const validMetrics = validationResults.filter((r) => r.isValid).length;
    const invalidMetrics = totalMetrics - validMetrics;

    const averageQualityScore =
      validationResults.reduce((sum, r) => sum + r.qualityScore, 0) /
      totalMetrics;

    const averageConfidence =
      validationResults.reduce((sum, r) => sum + r.confidence, 0) /
      totalMetrics;

    // Collect all issues and find most common ones
    const allIssues = validationResults.flatMap((r) => [
      ...r.errors,
      ...r.warnings,
    ]);
    const issueCounts = allIssues.reduce(
      (counts, issue) => {
        counts[issue] = (counts[issue] || 0) + 1;
        return counts;
      },
      {} as Record<string, number>,
    );

    const commonIssues = Object.entries(issueCounts)
      .sort(([, a], [, b]) => b - a)
      .slice(0, 5)
      .map(([issue]) => issue);

    return {
      totalMetrics,
      validMetrics,
      invalidMetrics,
      averageQualityScore,
      averageConfidence,
      commonIssues,
    };
  }
}
