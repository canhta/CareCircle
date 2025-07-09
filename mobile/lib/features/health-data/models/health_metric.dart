import 'package:json_annotation/json_annotation.dart';

part 'health_metric.g.dart';

enum MetricType {
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
}

enum DataSource {
  @JsonValue('manual')
  manual,
  @JsonValue('apple_health')
  appleHealth,
  @JsonValue('google_fit')
  googleFit,
  @JsonValue('bluetooth_device')
  bluetoothDevice,
  @JsonValue('connected_api')
  connectedApi,
  @JsonValue('imported')
  imported,
}

enum ValidationStatus {
  @JsonValue('valid')
  valid,
  @JsonValue('suspicious')
  suspicious,
  @JsonValue('invalid')
  invalid,
  @JsonValue('pending')
  pending,
}

@JsonSerializable()
class HealthMetric {
  final String id;
  final String userId;
  final MetricType metricType;
  final double value;
  final String unit;
  final DateTime timestamp;
  final DataSource source;
  final String? deviceId;
  final String? notes;
  final bool isManualEntry;
  final ValidationStatus validationStatus;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  const HealthMetric({
    required this.id,
    required this.userId,
    required this.metricType,
    required this.value,
    required this.unit,
    required this.timestamp,
    required this.source,
    this.deviceId,
    this.notes,
    required this.isManualEntry,
    required this.validationStatus,
    required this.metadata,
    required this.createdAt,
  });

  factory HealthMetric.fromJson(Map<String, dynamic> json) =>
      _$HealthMetricFromJson(json);

  Map<String, dynamic> toJson() => _$HealthMetricToJson(this);

  HealthMetric copyWith({
    String? id,
    String? userId,
    MetricType? metricType,
    double? value,
    String? unit,
    DateTime? timestamp,
    DataSource? source,
    String? deviceId,
    String? notes,
    bool? isManualEntry,
    ValidationStatus? validationStatus,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return HealthMetric(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      metricType: metricType ?? this.metricType,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
      deviceId: deviceId ?? this.deviceId,
      notes: notes ?? this.notes,
      isManualEntry: isManualEntry ?? this.isManualEntry,
      validationStatus: validationStatus ?? this.validationStatus,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get displayValue {
    switch (metricType) {
      case MetricType.bloodPressure:
        final diastolic = metadata['diastolic'] ?? 0;
        return '$value/$diastolic $unit';
      default:
        return '$value $unit';
    }
  }

  bool get isFromDevice => deviceId != null;

  bool get isFromExternalAPI {
    return [
      DataSource.appleHealth,
      DataSource.googleFit,
      DataSource.connectedApi,
    ].contains(source);
  }

  bool isRecent([int hoursThreshold = 24]) {
    final now = DateTime.now();
    final diffInHours = now.difference(timestamp).inHours;
    return diffInHours <= hoursThreshold;
  }

  bool isSameDay(DateTime date) {
    return timestamp.year == date.year &&
        timestamp.month == date.month &&
        timestamp.day == date.day;
  }

  String get metricTypeDisplayName {
    switch (metricType) {
      case MetricType.heartRate:
        return 'Heart Rate';
      case MetricType.bloodPressure:
        return 'Blood Pressure';
      case MetricType.bloodGlucose:
        return 'Blood Glucose';
      case MetricType.bodyTemperature:
        return 'Body Temperature';
      case MetricType.bloodOxygen:
        return 'Blood Oxygen';
      case MetricType.weight:
        return 'Weight';
      case MetricType.steps:
        return 'Steps';
      case MetricType.sleep:
        return 'Sleep';
      case MetricType.respiratoryRate:
        return 'Respiratory Rate';
      case MetricType.activity:
        return 'Activity';
      case MetricType.mood:
        return 'Mood';
    }
  }
}
