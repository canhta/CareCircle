import 'package:health/health.dart';
import 'package:json_annotation/json_annotation.dart';

/// Health metric types supported by CareCircle
/// Matches backend MetricType enum exactly for API compatibility
enum HealthMetricType {
  @JsonValue('BLOOD_PRESSURE')
  bloodPressure,
  @JsonValue('HEART_RATE')
  heartRate,
  @JsonValue('WEIGHT')
  weight,
  @JsonValue('BLOOD_GLUCOSE')
  bloodGlucose,
  @JsonValue('TEMPERATURE')
  temperature,
  @JsonValue('OXYGEN_SATURATION')
  oxygenSaturation,
  @JsonValue('STEPS')
  steps,
  @JsonValue('SLEEP_DURATION')
  sleepDuration,
  @JsonValue('EXERCISE_MINUTES')
  exerciseMinutes,
  @JsonValue('MOOD')
  mood,
  @JsonValue('PAIN_LEVEL')
  painLevel;

  /// Convert to Health plugin HealthDataType
  HealthDataType toHealthDataType() {
    switch (this) {
      case HealthMetricType.heartRate:
        return HealthDataType.HEART_RATE;
      case HealthMetricType.bloodPressure:
        return HealthDataType.BLOOD_PRESSURE_SYSTOLIC;
      case HealthMetricType.bloodGlucose:
        return HealthDataType.BLOOD_GLUCOSE;
      case HealthMetricType.temperature:
        return HealthDataType.BODY_TEMPERATURE;
      case HealthMetricType.oxygenSaturation:
        return HealthDataType.BLOOD_OXYGEN;
      case HealthMetricType.weight:
        return HealthDataType.WEIGHT;
      case HealthMetricType.steps:
        return HealthDataType.STEPS;
      case HealthMetricType.sleepDuration:
        return HealthDataType.SLEEP_IN_BED;
      case HealthMetricType.exerciseMinutes:
        return HealthDataType.WORKOUT;
      case HealthMetricType.mood:
        return HealthDataType.HEART_RATE; // Fallback for mood tracking
      case HealthMetricType.painLevel:
        return HealthDataType.HEART_RATE; // Fallback for pain level tracking
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
        return HealthMetricType.temperature;
      case HealthDataType.WEIGHT:
        return HealthMetricType.weight;
      case HealthDataType.STEPS:
        return HealthMetricType.steps;
      case HealthDataType.BLOOD_OXYGEN:
        return HealthMetricType.oxygenSaturation;
      case HealthDataType.SLEEP_IN_BED:
      case HealthDataType.SLEEP_ASLEEP:
      case HealthDataType.SLEEP_AWAKE:
        return HealthMetricType.sleepDuration;
      case HealthDataType.WORKOUT:
        return HealthMetricType.exerciseMinutes;
      default:
        return null;
    }
  }

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case HealthMetricType.bloodPressure:
        return 'Blood Pressure';
      case HealthMetricType.heartRate:
        return 'Heart Rate';
      case HealthMetricType.weight:
        return 'Weight';
      case HealthMetricType.bloodGlucose:
        return 'Blood Glucose';
      case HealthMetricType.temperature:
        return 'Temperature';
      case HealthMetricType.oxygenSaturation:
        return 'Oxygen Saturation';
      case HealthMetricType.steps:
        return 'Steps';
      case HealthMetricType.sleepDuration:
        return 'Sleep Duration';
      case HealthMetricType.exerciseMinutes:
        return 'Exercise Minutes';
      case HealthMetricType.mood:
        return 'Mood';
      case HealthMetricType.painLevel:
        return 'Pain Level';
    }
  }

  /// Get unit for display
  String get unit {
    switch (this) {
      case HealthMetricType.bloodPressure:
        return 'mmHg';
      case HealthMetricType.heartRate:
        return 'bpm';
      case HealthMetricType.weight:
        return 'lbs';
      case HealthMetricType.bloodGlucose:
        return 'mg/dL';
      case HealthMetricType.temperature:
        return '°F';
      case HealthMetricType.oxygenSaturation:
        return '%';
      case HealthMetricType.steps:
        return 'steps';
      case HealthMetricType.sleepDuration:
        return 'hours';
      case HealthMetricType.exerciseMinutes:
        return 'minutes';
      case HealthMetricType.mood:
        return 'score';
      case HealthMetricType.painLevel:
        return 'level';
    }
  }

  /// Get icon for UI
  String get icon {
    switch (this) {
      case HealthMetricType.bloodPressure:
        return '🩸';
      case HealthMetricType.heartRate:
        return '❤️';
      case HealthMetricType.weight:
        return '⚖️';
      case HealthMetricType.bloodGlucose:
        return '🍯';
      case HealthMetricType.temperature:
        return '🌡️';
      case HealthMetricType.oxygenSaturation:
        return '🫁';
      case HealthMetricType.steps:
        return '👣';
      case HealthMetricType.sleepDuration:
        return '😴';
      case HealthMetricType.exerciseMinutes:
        return '🏃';
      case HealthMetricType.mood:
        return '😊';
      case HealthMetricType.painLevel:
        return '🩹';
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
