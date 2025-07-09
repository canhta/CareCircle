import 'package:health/health.dart';

/// Health metric types supported by CareCircle
/// Maps to backend MetricType enum and Health plugin HealthDataType
enum HealthMetricType {
  heartRate,
  bloodPressure,
  bloodGlucose,
  bodyTemperature,
  weight,
  height,
  steps,
  oxygenSaturation,
  sleep,
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
      case HealthMetricType.weight:
        return HealthDataType.WEIGHT;
      case HealthMetricType.height:
        return HealthDataType.HEIGHT;
      case HealthMetricType.steps:
        return HealthDataType.STEPS;
      case HealthMetricType.oxygenSaturation:
        return HealthDataType.BLOOD_OXYGEN;
      case HealthMetricType.sleep:
        return HealthDataType.SLEEP_IN_BED;
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
        return HealthMetricType.oxygenSaturation;
      case HealthDataType.SLEEP_IN_BED:
      case HealthDataType.SLEEP_ASLEEP:
      case HealthDataType.SLEEP_AWAKE:
        return HealthMetricType.sleep;
      case HealthDataType.WORKOUT:
        return HealthMetricType.exercise;
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
      case HealthMetricType.oxygenSaturation:
        return 'OXYGEN_SATURATION';
      case HealthMetricType.sleep:
        return 'SLEEP';
      case HealthMetricType.exercise:
        return 'EXERCISE';
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
      case 'OXYGEN_SATURATION':
        return HealthMetricType.oxygenSaturation;
      case 'SLEEP':
        return HealthMetricType.sleep;
      case 'EXERCISE':
        return HealthMetricType.exercise;
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
      case HealthMetricType.oxygenSaturation:
        return 'Oxygen Saturation';
      case HealthMetricType.sleep:
        return 'Sleep';
      case HealthMetricType.exercise:
        return 'Exercise';
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
      case HealthMetricType.oxygenSaturation:
        return '%';
      case HealthMetricType.sleep:
        return 'hours';
      case HealthMetricType.exercise:
        return 'minutes';
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
      case HealthMetricType.oxygenSaturation:
        return '🫁';
      case HealthMetricType.sleep:
        return '😴';
      case HealthMetricType.exercise:
        return '🏃';
    }
  }

  /// Check if this metric type requires special handling for blood pressure
  bool get isBloodPressure => this == HealthMetricType.bloodPressure;

  /// Get all supported health data types for permissions
  static List<HealthDataType> get allHealthDataTypes {
    return HealthMetricType.values
        .map((type) => type.toHealthDataType())
        .toList()
      ..add(HealthDataType.BLOOD_PRESSURE_DIASTOLIC); // Add diastolic for blood pressure
  }

  /// Get read/write permissions for all types
  static List<HealthDataAccess> get allPermissions {
    return List.generate(
      allHealthDataTypes.length,
      (index) => HealthDataAccess.READ_WRITE,
    );
  }
}
