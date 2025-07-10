// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_metric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthMetric _$HealthMetricFromJson(Map<String, dynamic> json) => HealthMetric(
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
  metadata: json['metadata'] as Map<String, dynamic>,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$HealthMetricToJson(HealthMetric instance) =>
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
  HealthMetricType.heartRate: 'heart_rate',
  HealthMetricType.bloodPressure: 'blood_pressure',
  HealthMetricType.bloodGlucose: 'blood_glucose',
  HealthMetricType.bodyTemperature: 'body_temperature',
  HealthMetricType.bloodOxygen: 'blood_oxygen',
  HealthMetricType.weight: 'weight',
  HealthMetricType.height: 'height',
  HealthMetricType.steps: 'steps',
  HealthMetricType.sleep: 'sleep',
  HealthMetricType.respiratoryRate: 'respiratory_rate',
  HealthMetricType.activity: 'activity',
  HealthMetricType.mood: 'mood',
  HealthMetricType.exercise: 'exercise',
};

const _$DataSourceEnumMap = {
  DataSource.manual: 'manual',
  DataSource.appleHealth: 'apple_health',
  DataSource.googleFit: 'google_fit',
  DataSource.bluetoothDevice: 'bluetooth_device',
  DataSource.connectedApi: 'connected_api',
  DataSource.imported: 'imported',
};

const _$ValidationStatusEnumMap = {
  ValidationStatus.valid: 'valid',
  ValidationStatus.suspicious: 'suspicious',
  ValidationStatus.invalid: 'invalid',
  ValidationStatus.pending: 'pending',
};
