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
}
