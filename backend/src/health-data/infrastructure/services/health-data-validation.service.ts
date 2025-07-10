import { Injectable } from '@nestjs/common';
import { HealthMetric } from '../../domain/entities/health-metric.entity';
import { MetricType } from '@prisma/client';

export enum AgeGroup {
  PEDIATRIC = 'pediatric', // 0-12 years
  ADOLESCENT = 'adolescent', // 13-17 years
  ADULT = 'adult', // 18-64 years
  GERIATRIC = 'geriatric', // 65+ years
}

export enum Gender {
  MALE = 'male',
  FEMALE = 'female',
  OTHER = 'other',
}

export enum ValidationSeverity {
  INFO = 'info',
  WARNING = 'warning',
  ERROR = 'error',
  CRITICAL = 'critical',
}

export interface EnhancedValidationRule {
  metricType: MetricType;
  ageGroup?: AgeGroup;
  gender?: Gender;
  condition?: string;
  minValue: number;
  maxValue: number;
  unit: string;
  description: string;
  medicalReference?: string;
  severity: ValidationSeverity;
  emergencyThreshold?: {
    min?: number;
    max?: number;
  };
}

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
  severity: ValidationSeverity;
  emergencyAlert?: boolean;
  complianceFlags: string[];
  medicalReferences: string[];
}

@Injectable()
export class HealthDataValidationService {
  // Legacy validation rules for backward compatibility
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

  // Enhanced validation rules with age, gender, and condition-specific ranges
  private readonly enhancedValidationRules: EnhancedValidationRule[] = [
    // Heart Rate - Age-specific ranges based on AHA guidelines
    {
      metricType: MetricType.HEART_RATE,
      ageGroup: AgeGroup.PEDIATRIC,
      minValue: 80,
      maxValue: 180,
      unit: 'bpm',
      description: 'Pediatric heart rate (0-12 years): 80-180 bpm',
      medicalReference: 'American Heart Association Pediatric Guidelines',
      severity: ValidationSeverity.WARNING,
      emergencyThreshold: { min: 60, max: 220 },
    },
    {
      metricType: MetricType.HEART_RATE,
      ageGroup: AgeGroup.ADOLESCENT,
      minValue: 60,
      maxValue: 120,
      unit: 'bpm',
      description: 'Adolescent heart rate (13-17 years): 60-120 bpm',
      medicalReference: 'American Heart Association Pediatric Guidelines',
      severity: ValidationSeverity.WARNING,
      emergencyThreshold: { min: 50, max: 200 },
    },
    {
      metricType: MetricType.HEART_RATE,
      ageGroup: AgeGroup.ADULT,
      minValue: 60,
      maxValue: 100,
      unit: 'bpm',
      description: 'Adult resting heart rate (18-64 years): 60-100 bpm',
      medicalReference: 'American Heart Association Adult Guidelines',
      severity: ValidationSeverity.WARNING,
      emergencyThreshold: { min: 40, max: 180 },
    },
    {
      metricType: MetricType.HEART_RATE,
      ageGroup: AgeGroup.GERIATRIC,
      minValue: 60,
      maxValue: 100,
      unit: 'bpm',
      description: 'Geriatric heart rate (65+ years): 60-100 bpm',
      medicalReference: 'American Heart Association Geriatric Guidelines',
      severity: ValidationSeverity.WARNING,
      emergencyThreshold: { min: 45, max: 150 },
    },
    // Blood Pressure - Age and gender-specific ranges
    {
      metricType: MetricType.BLOOD_PRESSURE,
      ageGroup: AgeGroup.PEDIATRIC,
      minValue: 80,
      maxValue: 120,
      unit: 'mmHg',
      description: 'Pediatric systolic BP (0-12 years): 80-120 mmHg',
      medicalReference: 'American Academy of Pediatrics BP Guidelines',
      severity: ValidationSeverity.WARNING,
      emergencyThreshold: { min: 70, max: 140 },
    },
    {
      metricType: MetricType.BLOOD_PRESSURE,
      ageGroup: AgeGroup.ADULT,
      minValue: 90,
      maxValue: 140,
      unit: 'mmHg',
      description: 'Adult systolic BP (18-64 years): 90-140 mmHg',
      medicalReference: 'American Heart Association BP Guidelines 2017',
      severity: ValidationSeverity.WARNING,
      emergencyThreshold: { min: 70, max: 180 },
    },
    {
      metricType: MetricType.BLOOD_PRESSURE,
      ageGroup: AgeGroup.GERIATRIC,
      minValue: 90,
      maxValue: 150,
      unit: 'mmHg',
      description: 'Geriatric systolic BP (65+ years): 90-150 mmHg',
      medicalReference: 'American Heart Association Geriatric BP Guidelines',
      severity: ValidationSeverity.WARNING,
      emergencyThreshold: { min: 80, max: 200 },
    },
    // Blood Glucose - Condition-specific ranges
    {
      metricType: MetricType.BLOOD_GLUCOSE,
      condition: 'diabetes',
      minValue: 80,
      maxValue: 180,
      unit: 'mg/dL',
      description: 'Diabetic target glucose: 80-180 mg/dL',
      medicalReference: 'American Diabetes Association Standards 2023',
      severity: ValidationSeverity.WARNING,
      emergencyThreshold: { min: 50, max: 400 },
    },
    {
      metricType: MetricType.BLOOD_GLUCOSE,
      ageGroup: AgeGroup.ADULT,
      minValue: 70,
      maxValue: 140,
      unit: 'mg/dL',
      description: 'Adult normal glucose: 70-140 mg/dL',
      medicalReference: 'American Diabetes Association Normal Ranges',
      severity: ValidationSeverity.WARNING,
      emergencyThreshold: { min: 40, max: 400 },
    },
    // Temperature - Age-specific ranges
    {
      metricType: MetricType.TEMPERATURE,
      ageGroup: AgeGroup.PEDIATRIC,
      minValue: 36.0,
      maxValue: 37.5,
      unit: '°C',
      description: 'Pediatric normal temperature: 36.0-37.5°C',
      medicalReference: 'WHO Pediatric Temperature Guidelines',
      severity: ValidationSeverity.WARNING,
      emergencyThreshold: { min: 35.0, max: 40.0 },
    },
    {
      metricType: MetricType.TEMPERATURE,
      ageGroup: AgeGroup.ADULT,
      minValue: 36.1,
      maxValue: 37.2,
      unit: '°C',
      description: 'Adult normal temperature: 36.1-37.2°C',
      medicalReference: 'WHO Adult Temperature Guidelines',
      severity: ValidationSeverity.WARNING,
      emergencyThreshold: { min: 35.0, max: 41.0 },
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
      severity: ValidationSeverity.INFO,
      emergencyAlert: false,
      complianceFlags: [],
      medicalReferences: [],
    };

    // Try enhanced validation first
    const enhancedRule = this.findBestEnhancedRule(metric);
    if (enhancedRule) {
      this.applyEnhancedValidation(metric, enhancedRule, result);
    } else {
      // Fall back to legacy validation
      const rule = this.validationRules.find(
        (r) => r.metricType === metric.metricType,
      );
      if (!rule) {
        result.warnings.push(
          `No validation rule found for metric type: ${metric.metricType}`,
        );
        return result;
      }
      this.applyLegacyValidation(metric, rule, result);
    }

    // Apply additional validations
    this.validateSpecificMetric(metric, result);
    this.validateTemporal(metric, result);
    this.validateHealthcareCompliance(metric, result);
    this.calculateQualityMetrics(metric, result);

    return result;
  }

  /**
   * Enhanced validation method with comprehensive healthcare-specific rules
   */
  validateMetricEnhanced(
    metric: HealthMetric,
    patientAge?: number,
    patientGender?: Gender,
    healthConditions?: string[],
  ): ValidationResult {
    const result: ValidationResult = {
      isValid: true,
      warnings: [],
      errors: [],
      suggestions: [],
      confidence: 1.0,
      qualityScore: 100,
      severity: ValidationSeverity.INFO,
      emergencyAlert: false,
      complianceFlags: [],
      medicalReferences: [],
    };

    // Find the most specific enhanced rule
    const enhancedRule = this.findBestEnhancedRule(
      metric,
      patientAge,
      patientGender,
      healthConditions,
    );

    if (enhancedRule) {
      this.applyEnhancedValidation(metric, enhancedRule, result);
    } else {
      // Fall back to basic validation
      const basicRule = this.validationRules.find(
        (r) => r.metricType === metric.metricType,
      );
      if (basicRule) {
        this.applyLegacyValidation(metric, basicRule, result);
      }
    }

    // Apply comprehensive validations
    this.validateSpecificMetric(metric, result);
    this.validateTemporal(metric, result);
    this.validateHealthcareCompliance(metric, result);
    this.validateForHealthConditions(metric, healthConditions || [], result);
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

  getAllEnhancedValidationRules(): EnhancedValidationRule[] {
    return [...this.enhancedValidationRules];
  }

  private findBestEnhancedRule(
    metric: HealthMetric,
    patientAge?: number,
    patientGender?: Gender,
    healthConditions?: string[],
  ): EnhancedValidationRule | undefined {
    const candidates = this.enhancedValidationRules.filter(
      (rule) => rule.metricType === metric.metricType,
    );

    if (candidates.length === 0) return undefined;

    // Score each rule based on specificity
    let bestRule: EnhancedValidationRule | undefined;
    let bestScore = -1;

    for (const rule of candidates) {
      let score = 0;

      // Age group matching
      if (rule.ageGroup && patientAge !== undefined) {
        const ageGroup = this.getAgeGroup(patientAge);
        if (rule.ageGroup === ageGroup) {
          score += 10;
        } else {
          continue; // Skip if age group doesn't match
        }
      }

      // Gender matching
      if (rule.gender && patientGender) {
        if (rule.gender === patientGender) {
          score += 5;
        } else {
          continue; // Skip if gender doesn't match
        }
      }

      // Condition matching
      if (rule.condition && healthConditions) {
        if (healthConditions.includes(rule.condition)) {
          score += 15; // Highest priority for condition-specific rules
        } else {
          continue; // Skip if condition doesn't match
        }
      }

      if (score > bestScore) {
        bestScore = score;
        bestRule = rule;
      }
    }

    return bestRule || candidates[0]; // Return first rule if no specific match
  }

  private getAgeGroup(age: number): AgeGroup {
    if (age <= 12) return AgeGroup.PEDIATRIC;
    if (age <= 17) return AgeGroup.ADOLESCENT;
    if (age <= 64) return AgeGroup.ADULT;
    return AgeGroup.GERIATRIC;
  }

  private applyEnhancedValidation(
    metric: HealthMetric,
    rule: EnhancedValidationRule,
    result: ValidationResult,
  ): void {
    // Range validation
    if (metric.value < rule.minValue || metric.value > rule.maxValue) {
      result.isValid = false;
      result.errors.push(
        `Value ${metric.value} ${metric.unit} is outside ${rule.description.toLowerCase()}`,
      );
      result.severity = rule.severity;
    }

    // Emergency threshold check
    if (rule.emergencyThreshold) {
      const { min, max } = rule.emergencyThreshold;
      if (
        (min !== undefined && metric.value < min) ||
        (max !== undefined && metric.value > max)
      ) {
        result.emergencyAlert = true;
        result.severity = ValidationSeverity.CRITICAL;
        result.errors.push(
          `EMERGENCY: Value ${metric.value} ${metric.unit} requires immediate medical attention`,
        );
        result.suggestions.push('Contact healthcare provider immediately');
      }
    }

    // Unit validation
    if (metric.unit !== rule.unit) {
      result.warnings.push(
        `Unit mismatch: expected ${rule.unit}, got ${metric.unit}`,
      );
    }

    // Add medical reference
    if (rule.medicalReference) {
      result.medicalReferences.push(rule.medicalReference);
    }
  }

  private applyLegacyValidation(
    metric: HealthMetric,
    rule: ValidationRule,
    result: ValidationResult,
  ): void {
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
  }

  private validateHealthcareCompliance(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    // HIPAA Data Quality Requirements
    this.validateHIPAACompliance(metric, result);

    // Medical Device Data Standards
    this.validateMedicalDeviceStandards(metric, result);

    // Clinical Data Quality Metrics
    this.validateClinicalDataQuality(metric, result);
  }

  private validateHIPAACompliance(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    // Data completeness validation
    if (!metric.timestamp) {
      result.complianceFlags.push('HIPAA: Missing timestamp');
      result.warnings.push('Timestamp is required for HIPAA compliance');
    }

    if (!metric.source) {
      result.complianceFlags.push('HIPAA: Missing data source');
      result.warnings.push('Data source is required for HIPAA compliance');
    }

    // Data accuracy validation
    if (metric.value === null || metric.value === undefined) {
      result.complianceFlags.push('HIPAA: Missing metric value');
      result.errors.push('Metric value is required for HIPAA compliance');
      result.isValid = false;
    }

    // Data consistency validation
    if (!metric.unit || metric.unit.trim() === '') {
      result.complianceFlags.push('HIPAA: Missing unit of measurement');
      result.warnings.push(
        'Unit of measurement is required for HIPAA compliance',
      );
    }
  }

  private validateMedicalDeviceStandards(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    // Device-specific validation
    if (metric.deviceId) {
      // Check if device data meets FDA standards
      if (
        metric.source === 'DEVICE_SYNC' &&
        !metric.metadata?.deviceCalibrated
      ) {
        result.complianceFlags.push('FDA: Device calibration status unknown');
        result.warnings.push('Device calibration status should be verified');
      }

      // Data source reliability scoring
      const deviceReliabilityScore =
        this.calculateDeviceReliabilityScore(metric);
      if (deviceReliabilityScore < 0.8) {
        result.complianceFlags.push('FDA: Low device reliability score');
        result.warnings.push(
          'Device data reliability is below recommended threshold',
        );
      }
    }
  }

  private validateClinicalDataQuality(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    // Completeness scoring
    let completenessScore = 1.0;
    if (!metric.notes) completenessScore -= 0.1;
    if (!metric.metadata || Object.keys(metric.metadata).length === 0) {
      completenessScore -= 0.2;
    }

    if (completenessScore < 0.8) {
      result.complianceFlags.push('Clinical: Low data completeness');
      result.suggestions.push('Consider adding additional context or notes');
    }

    // Consistency validation
    if (metric.isManualEntry && metric.deviceId) {
      result.complianceFlags.push('Clinical: Data source inconsistency');
      result.warnings.push('Manual entry flag conflicts with device ID');
    }

    // Accuracy assessment
    if (metric.validationStatus === 'REJECTED') {
      result.complianceFlags.push('Clinical: Previously rejected data');
      result.errors.push('This metric was previously marked as invalid');
      result.isValid = false;
    }
  }

  private calculateDeviceReliabilityScore(metric: HealthMetric): number {
    let score = 1.0;

    // Reduce score based on data source
    switch (metric.source) {
      case 'MANUAL_ENTRY':
        score *= 0.7;
        break;
      case 'DEVICE_SYNC':
        score *= 0.95;
        break;
      case 'HEALTH_KIT':
      case 'GOOGLE_FIT':
        score *= 0.85;
        break;
      default:
        score *= 0.8;
    }

    // Adjust for manual entry flag
    if (metric.isManualEntry) {
      score *= 0.8;
    }

    // Adjust for device metadata
    if (metric.metadata?.deviceCalibrated === false) {
      score *= 0.6;
    }

    return score;
  }

  private validateForHealthConditions(
    metric: HealthMetric,
    healthConditions: string[],
    result: ValidationResult,
  ): void {
    for (const condition of healthConditions) {
      switch (condition.toLowerCase()) {
        case 'diabetes':
          this.validateForDiabetes(metric, result);
          break;
        case 'hypertension':
          this.validateForHypertension(metric, result);
          break;
        case 'heart_disease':
        case 'cardiac':
          this.validateForHeartDisease(metric, result);
          break;
        case 'obesity':
          this.validateForObesity(metric, result);
          break;
        default:
          break;
      }
    }
  }

  private validateForObesity(
    metric: HealthMetric,
    result: ValidationResult,
  ): void {
    if (metric.metricType === MetricType.WEIGHT) {
      // BMI-related validation would require height data
      result.suggestions.push(
        'Consider tracking BMI alongside weight for obesity management',
      );
    }

    if (metric.metricType === MetricType.STEPS && metric.value < 5000) {
      result.warnings.push(
        'Low daily step count - consider increasing physical activity',
      );
      result.suggestions.push(
        'Aim for at least 10,000 steps daily for weight management',
      );
    }
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
