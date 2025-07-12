// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthDevice _$HealthDeviceFromJson(Map<String, dynamic> json) =>
    _HealthDevice(
      id: json['id'] as String,
      userId: json['userId'] as String,
      deviceType: $enumDecode(_$DeviceTypeEnumMap, json['deviceType']),
      manufacturer: json['manufacturer'] as String,
      model: json['model'] as String,
      serialNumber: json['serialNumber'] as String?,
      lastSyncTimestamp: DateTime.parse(json['lastSyncTimestamp'] as String),
      connectionStatus: $enumDecode(
        _$ConnectionStatusEnumMap,
        json['connectionStatus'],
      ),
      batteryLevel: (json['batteryLevel'] as num?)?.toInt(),
      firmware: json['firmware'] as String?,
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$HealthDeviceToJson(_HealthDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'deviceType': _$DeviceTypeEnumMap[instance.deviceType]!,
      'manufacturer': instance.manufacturer,
      'model': instance.model,
      'serialNumber': instance.serialNumber,
      'lastSyncTimestamp': instance.lastSyncTimestamp.toIso8601String(),
      'connectionStatus': _$ConnectionStatusEnumMap[instance.connectionStatus]!,
      'batteryLevel': instance.batteryLevel,
      'firmware': instance.firmware,
      'settings': instance.settings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$DeviceTypeEnumMap = {
  DeviceType.bloodPressureMonitor: 'BLOOD_PRESSURE_MONITOR',
  DeviceType.glucoseMeter: 'GLUCOSE_METER',
  DeviceType.scale: 'SCALE',
  DeviceType.fitnessTracker: 'FITNESS_TRACKER',
  DeviceType.smartwatch: 'SMARTWATCH',
  DeviceType.pulseOximeter: 'PULSE_OXIMETER',
  DeviceType.thermometer: 'THERMOMETER',
  DeviceType.other: 'OTHER',
};

const _$ConnectionStatusEnumMap = {
  ConnectionStatus.connected: 'CONNECTED',
  ConnectionStatus.disconnected: 'DISCONNECTED',
  ConnectionStatus.syncing: 'SYNCING',
  ConnectionStatus.error: 'ERROR',
};
