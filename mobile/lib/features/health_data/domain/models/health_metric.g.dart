// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_metric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthMetric _$HealthMetricFromJson(Map<String, dynamic> json) =>
    _HealthMetric(
      id: json['id'] as String,
      userId: json['userId'] as String,
      metricType: $enumDecode(_$HealthMetricTypeEnumMap, json['metricType']),
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      source: $enumDecode(_$DataSourceEnumMap, json['source']),
      deviceId: json['deviceId'] as String?,
      notes: json['notes'] as String?,
      isManualEntry: json['isManualEntry'] as bool,
      validationStatus: $enumDecode(
        _$ValidationStatusEnumMap,
        json['validationStatus'],
      ),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$HealthMetricToJson(_HealthMetric instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'metricType': _$HealthMetricTypeEnumMap[instance.metricType]!,
      'value': instance.value,
      'unit': instance.unit,
      'timestamp': instance.timestamp.toIso8601String(),
      'source': _$DataSourceEnumMap[instance.source]!,
      'deviceId': instance.deviceId,
      'notes': instance.notes,
      'isManualEntry': instance.isManualEntry,
      'validationStatus': _$ValidationStatusEnumMap[instance.validationStatus]!,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$HealthMetricTypeEnumMap = {
  HealthMetricType.bloodPressure: 'BLOOD_PRESSURE',
  HealthMetricType.heartRate: 'HEART_RATE',
  HealthMetricType.weight: 'WEIGHT',
  HealthMetricType.bloodGlucose: 'BLOOD_GLUCOSE',
  HealthMetricType.temperature: 'TEMPERATURE',
  HealthMetricType.oxygenSaturation: 'OXYGEN_SATURATION',
  HealthMetricType.steps: 'STEPS',
  HealthMetricType.sleepDuration: 'SLEEP_DURATION',
  HealthMetricType.exerciseMinutes: 'EXERCISE_MINUTES',
  HealthMetricType.mood: 'MOOD',
  HealthMetricType.painLevel: 'PAIN_LEVEL',
};

const _$DataSourceEnumMap = {
  DataSource.manualEntry: 'MANUAL_ENTRY',
  DataSource.healthKit: 'HEALTH_KIT',
  DataSource.googleFit: 'GOOGLE_FIT',
  DataSource.deviceSync: 'DEVICE_SYNC',
  DataSource.imported: 'IMPORTED',
};

const _$ValidationStatusEnumMap = {
  ValidationStatus.pending: 'PENDING',
  ValidationStatus.validated: 'VALIDATED',
  ValidationStatus.flagged: 'FLAGGED',
  ValidationStatus.rejected: 'REJECTED',
};
