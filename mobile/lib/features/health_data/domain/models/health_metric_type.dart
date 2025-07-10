import 'package:health/health.dart';
import 'package:json_annotation/json_annotation.dart';

/// Health metric types supported by CareCircle
/// Maps to backend MetricType enum and Health plugin HealthDataType
enum HealthMetricType {
  @JsonValue('heart_rate')
  heartRate,
  @JsonValue('blood_pressure')
  bloodPressure,
  @JsonValue('blood_glucose')
  bloodGlucose,
  @JsonValue('body_temperature')
  bodyTemperature,
  @JsonValue('blood_oxygen')
  bloodOxygen,
  @JsonValue('weight')
  weight,
  @JsonValue('height')
  height,
  @JsonValue('steps')
  steps,
  @JsonValue('sleep')
  sleep,
  @JsonValue('respiratory_rate')
  respiratoryRate,
  @JsonValue('activity')
  activity,
  @JsonValue('mood')
  mood,
  @JsonValue('exercise')
  exercise;

  /// Convert to Health plugin HealthDataType
  HealthDataType toHealthDataType() {
    switch (this) {
      case HealthMetricType.heartRate:
        return HealthDataType.HEART_RATE;
      case HealthMetricType.bloodPressure:
        return HealthDataType.BLOOD_PRESSURE_SYSTOLIC;
      case HealthMetricType.bloodGlucose:
        return HealthDataType.BLOOD_GLUCOSE;
      case HealthMetricType.bodyTemperature:
        return HealthDataType.BODY_TEMPERATURE;
      case HealthMetricType.bloodOxygen:
        return HealthDataType.BLOOD_OXYGEN;
      case HealthMetricType.weight:
        return HealthDataType.WEIGHT;
      case HealthMetricType.height:
        return HealthDataType.HEIGHT;
      case HealthMetricType.steps:
        return HealthDataType.STEPS;
      case HealthMetricType.sleep:
        return HealthDataType.SLEEP_IN_BED;
      case HealthMetricType.respiratoryRate:
        return HealthDataType.RESPIRATORY_RATE;
      case HealthMetricType.activity:
        return HealthDataType.WORKOUT;
      case HealthMetricType.mood:
        return HealthDataType.HEART_RATE; // Fallback for mood tracking
      case HealthMetricType.exercise:
        return HealthDataType.WORKOUT;
    }
  }

  /// Convert from Health plugin HealthDataType
  static HealthMetricType? fromHealthDataType(HealthDataType type) {
    switch (type) {
      case HealthDataType.HEART_RATE:
        return HealthMetricType.heartRate;
      case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
      case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
        return HealthMetricType.bloodPressure;
      case HealthDataType.BLOOD_GLUCOSE:
        return HealthMetricType.bloodGlucose;
      case HealthDataType.BODY_TEMPERATURE:
        return HealthMetricType.bodyTemperature;
      case HealthDataType.WEIGHT:
        return HealthMetricType.weight;
      case HealthDataType.HEIGHT:
        return HealthMetricType.height;
      case HealthDataType.STEPS:
        return HealthMetricType.steps;
      case HealthDataType.BLOOD_OXYGEN:
        return HealthMetricType.bloodOxygen;
      case HealthDataType.SLEEP_IN_BED:
      case HealthDataType.SLEEP_ASLEEP:
      case HealthDataType.SLEEP_AWAKE:
        return HealthMetricType.sleep;
      case HealthDataType.WORKOUT:
        return HealthMetricType.exercise;
      case HealthDataType.RESPIRATORY_RATE:
        return HealthMetricType.respiratoryRate;
      default:
        return null;
    }
  }

  /// Convert to backend API string
  String toApiString() {
    switch (this) {
      case HealthMetricType.heartRate:
        return 'HEART_RATE';
      case HealthMetricType.bloodPressure:
        return 'BLOOD_PRESSURE';
      case HealthMetricType.bloodGlucose:
        return 'BLOOD_GLUCOSE';
      case HealthMetricType.bodyTemperature:
        return 'BODY_TEMPERATURE';
      case HealthMetricType.weight:
        return 'WEIGHT';
      case HealthMetricType.height:
        return 'HEIGHT';
      case HealthMetricType.steps:
        return 'STEPS';
      case HealthMetricType.bloodOxygen:
        return 'BLOOD_OXYGEN';
      case HealthMetricType.sleep:
        return 'SLEEP';
      case HealthMetricType.exercise:
        return 'EXERCISE';
      case HealthMetricType.respiratoryRate:
        return 'RESPIRATORY_RATE';
      case HealthMetricType.activity:
        return 'ACTIVITY';
      case HealthMetricType.mood:
        return 'MOOD';
    }
  }

  /// Convert from backend API string
  static HealthMetricType? fromApiString(String apiString) {
    switch (apiString) {
      case 'HEART_RATE':
        return HealthMetricType.heartRate;
      case 'BLOOD_PRESSURE':
        return HealthMetricType.bloodPressure;
      case 'BLOOD_GLUCOSE':
        return HealthMetricType.bloodGlucose;
      case 'BODY_TEMPERATURE':
        return HealthMetricType.bodyTemperature;
      case 'WEIGHT':
        return HealthMetricType.weight;
      case 'HEIGHT':
        return HealthMetricType.height;
      case 'STEPS':
        return HealthMetricType.steps;
      case 'BLOOD_OXYGEN':
        return HealthMetricType.bloodOxygen;
      case 'SLEEP':
        return HealthMetricType.sleep;
      case 'EXERCISE':
        return HealthMetricType.exercise;
      case 'RESPIRATORY_RATE':
        return HealthMetricType.respiratoryRate;
      case 'ACTIVITY':
        return HealthMetricType.activity;
      case 'MOOD':
        return HealthMetricType.mood;
      default:
        return null;
    }
  }

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case HealthMetricType.heartRate:
        return 'Heart Rate';
      case HealthMetricType.bloodPressure:
        return 'Blood Pressure';
      case HealthMetricType.bloodGlucose:
        return 'Blood Glucose';
      case HealthMetricType.bodyTemperature:
        return 'Body Temperature';
      case HealthMetricType.weight:
        return 'Weight';
      case HealthMetricType.height:
        return 'Height';
      case HealthMetricType.steps:
        return 'Steps';
      case HealthMetricType.bloodOxygen:
        return 'Blood Oxygen';
      case HealthMetricType.sleep:
        return 'Sleep';
      case HealthMetricType.exercise:
        return 'Exercise';
      case HealthMetricType.respiratoryRate:
        return 'Respiratory Rate';
      case HealthMetricType.activity:
        return 'Activity';
      case HealthMetricType.mood:
        return 'Mood';
    }
  }

  /// Get unit for display
  String get unit {
    switch (this) {
      case HealthMetricType.heartRate:
        return 'bpm';
      case HealthMetricType.bloodPressure:
        return 'mmHg';
      case HealthMetricType.bloodGlucose:
        return 'mg/dL';
      case HealthMetricType.bodyTemperature:
        return '°F';
      case HealthMetricType.weight:
        return 'lbs';
      case HealthMetricType.height:
        return 'in';
      case HealthMetricType.steps:
        return 'steps';
      case HealthMetricType.bloodOxygen:
        return '%';
      case HealthMetricType.sleep:
        return 'hours';
      case HealthMetricType.exercise:
        return 'minutes';
      case HealthMetricType.respiratoryRate:
        return 'breaths/min';
      case HealthMetricType.activity:
        return 'minutes';
      case HealthMetricType.mood:
        return 'score';
    }
  }

  /// Get icon for UI
  String get icon {
    switch (this) {
      case HealthMetricType.heartRate:
        return '❤️';
      case HealthMetricType.bloodPressure:
        return '🩸';
      case HealthMetricType.bloodGlucose:
        return '🍯';
      case HealthMetricType.bodyTemperature:
        return '🌡️';
      case HealthMetricType.weight:
        return '⚖️';
      case HealthMetricType.height:
        return '📏';
      case HealthMetricType.steps:
        return '👣';
      case HealthMetricType.bloodOxygen:
        return '🫁';
      case HealthMetricType.sleep:
        return '😴';
      case HealthMetricType.exercise:
        return '🏃';
      case HealthMetricType.respiratoryRate:
        return '🫁';
      case HealthMetricType.activity:
        return '🏃';
      case HealthMetricType.mood:
        return '😊';
    }
  }

  /// Check if this metric type requires special handling for blood pressure
  bool get isBloodPressure => this == HealthMetricType.bloodPressure;

  /// Get all supported health data types for permissions
  static List<HealthDataType> get allHealthDataTypes {
    return HealthMetricType.values
        .map((type) => type.toHealthDataType())
        .toList()
      ..add(
        HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      ); // Add diastolic for blood pressure
  }

  /// Get read/write permissions for all types
  static List<HealthDataAccess> get allPermissions {
    return List.generate(
      allHealthDataTypes.length,
      (index) => HealthDataAccess.READ_WRITE,
    );
  }
}
