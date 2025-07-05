import 'package:health/health.dart';
import 'package:flutter/foundation.dart';

/// Health data types that CareCircle tracks
enum CareCircleHealthDataType {
  steps,
  heartRate,
  bloodPressure,
  weight,
  height,
  sleepInBed,
  sleepAsleep,
  activeEnergyBurned,
  basalEnergyBurned,
  distanceWalkingRunning,
  bodyTemperature,
  oxygenSaturation,
  bloodGlucose,
}

/// Mapping from CareCircle types to Flutter Health types
const Map<CareCircleHealthDataType, HealthDataType> healthDataTypeMap = {
  CareCircleHealthDataType.steps: HealthDataType.STEPS,
  CareCircleHealthDataType.heartRate: HealthDataType.HEART_RATE,
  CareCircleHealthDataType.bloodPressure:
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  CareCircleHealthDataType.weight: HealthDataType.WEIGHT,
  CareCircleHealthDataType.height: HealthDataType.HEIGHT,
  CareCircleHealthDataType.sleepInBed: HealthDataType.SLEEP_IN_BED,
  CareCircleHealthDataType.sleepAsleep: HealthDataType.SLEEP_ASLEEP,
  CareCircleHealthDataType.activeEnergyBurned:
      HealthDataType.ACTIVE_ENERGY_BURNED,
  CareCircleHealthDataType.basalEnergyBurned:
      HealthDataType.BASAL_ENERGY_BURNED,
  CareCircleHealthDataType.distanceWalkingRunning:
      HealthDataType.DISTANCE_WALKING_RUNNING,
  CareCircleHealthDataType.bodyTemperature: HealthDataType.BODY_TEMPERATURE,
  CareCircleHealthDataType.oxygenSaturation: HealthDataType.BLOOD_OXYGEN,
  CareCircleHealthDataType.bloodGlucose: HealthDataType.BLOOD_GLUCOSE,
};

/// Health data point model for CareCircle
class CareCircleHealthData {
  final CareCircleHealthDataType type;
  final double value;
  final String unit;
  final DateTime timestamp;
  final String? source;
  final Map<String, dynamic>? metadata;

  const CareCircleHealthData({
    required this.type,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.source,
    this.metadata,
  });

  /// Convert from Flutter Health HealthDataPoint
  factory CareCircleHealthData.fromHealthDataPoint(HealthDataPoint dataPoint) {
    // Find the CareCircle type that matches this health data type
    final careCircleType = healthDataTypeMap.entries
        .firstWhere(
          (entry) => entry.value == dataPoint.type,
          orElse: () => throw ArgumentError(
            'Unsupported health data type: ${dataPoint.type}',
          ),
        )
        .key;

    // Extract numeric value from HealthValue
    double numericValue;
    try {
      if (dataPoint.value is NumericHealthValue) {
        numericValue =
            (dataPoint.value as NumericHealthValue).numericValue.toDouble();
      } else if (dataPoint.value is AudiogramHealthValue) {
        // For audiogram data, we might want to extract frequencies or decibels
        debugPrint('HealthService: Skipping audiogram data type');
        throw ArgumentError('Audiogram data is not supported in CareCircle');
      } else if (dataPoint.value is WorkoutHealthValue) {
        // For workout data, we might want to extract duration or distance
        debugPrint('HealthService: Skipping workout data type');
        throw ArgumentError('Workout data requires special handling');
      } else {
        debugPrint(
            'HealthService: Unsupported health value type: ${dataPoint.value.runtimeType}');
        throw ArgumentError(
            'Unsupported health value type: ${dataPoint.value.runtimeType}');
      }
    } catch (e) {
      debugPrint(
          'HealthService: Error extracting numeric value from health data: $e');
      rethrow;
    }

    return CareCircleHealthData(
      type: careCircleType,
      value: numericValue,
      unit: dataPoint.unit.name,
      timestamp: dataPoint.dateFrom,
      source: dataPoint.sourcePlatform.name,
    );
  }

  /// Create from JSON
  factory CareCircleHealthData.fromJson(Map<String, dynamic> json) {
    return CareCircleHealthData(
      type: CareCircleHealthDataType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () =>
            throw ArgumentError('Invalid health data type: ${json['type']}'),
      ),
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      source: json['source'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'source': source,
      'metadata': metadata,
    };
  }

  /// Copy with new values
  CareCircleHealthData copyWith({
    CareCircleHealthDataType? type,
    double? value,
    String? unit,
    DateTime? timestamp,
    String? source,
    Map<String, dynamic>? metadata,
  }) {
    return CareCircleHealthData(
      type: type ?? this.type,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'CareCircleHealthData(type: $type, value: $value, unit: $unit, timestamp: $timestamp, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CareCircleHealthData &&
        other.type == type &&
        other.value == value &&
        other.unit == unit &&
        other.timestamp == timestamp &&
        other.source == source;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        value.hashCode ^
        unit.hashCode ^
        timestamp.hashCode ^
        (source?.hashCode ?? 0);
  }
}

/// Health sync status model
class HealthSyncStatus {
  final String id;
  final DateTime lastSync;
  final bool isSuccess;
  final String? error;
  final int recordsCount;
  final Map<String, dynamic>? metadata;

  const HealthSyncStatus({
    required this.id,
    required this.lastSync,
    required this.isSuccess,
    this.error,
    required this.recordsCount,
    this.metadata,
  });

  /// Create from JSON
  factory HealthSyncStatus.fromJson(Map<String, dynamic> json) {
    return HealthSyncStatus(
      id: json['id'] as String,
      lastSync: DateTime.parse(json['lastSync'] as String),
      isSuccess: json['isSuccess'] as bool,
      error: json['error'] as String?,
      recordsCount: json['recordsCount'] as int,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lastSync': lastSync.toIso8601String(),
      'isSuccess': isSuccess,
      'error': error,
      'recordsCount': recordsCount,
      'metadata': metadata,
    };
  }

  /// Copy with new values
  HealthSyncStatus copyWith({
    String? id,
    DateTime? lastSync,
    bool? isSuccess,
    String? error,
    int? recordsCount,
    Map<String, dynamic>? metadata,
  }) {
    return HealthSyncStatus(
      id: id ?? this.id,
      lastSync: lastSync ?? this.lastSync,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      recordsCount: recordsCount ?? this.recordsCount,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'HealthSyncStatus(id: $id, lastSync: $lastSync, isSuccess: $isSuccess, error: $error, recordsCount: $recordsCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthSyncStatus &&
        other.id == id &&
        other.lastSync == lastSync &&
        other.isSuccess == isSuccess &&
        other.error == error &&
        other.recordsCount == recordsCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        lastSync.hashCode ^
        isSuccess.hashCode ^
        (error?.hashCode ?? 0) ^
        recordsCount.hashCode;
  }
}

/// Health permissions model
class HealthPermissions {
  final Map<CareCircleHealthDataType, bool> permissions;

  const HealthPermissions({
    required this.permissions,
  });

  /// Create from JSON
  factory HealthPermissions.fromJson(Map<String, dynamic> json) {
    final permissions = <CareCircleHealthDataType, bool>{};

    for (final entry in json['permissions'].entries) {
      final type = CareCircleHealthDataType.values.firstWhere(
        (t) => t.name == entry.key,
        orElse: () =>
            throw ArgumentError('Invalid health data type: ${entry.key}'),
      );
      permissions[type] = entry.value as bool;
    }

    return HealthPermissions(permissions: permissions);
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'permissions': permissions.map((key, value) => MapEntry(key.name, value)),
    };
  }

  /// Check if all requested permissions are granted
  bool hasAllPermissions(List<CareCircleHealthDataType> types) {
    return types.every((type) => permissions[type] == true);
  }

  /// Check if any permission is granted
  bool hasAnyPermission() {
    return permissions.values.any((granted) => granted);
  }

  /// Get granted permissions
  List<CareCircleHealthDataType> getGrantedPermissions() {
    return permissions.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get denied permissions
  List<CareCircleHealthDataType> getDeniedPermissions() {
    return permissions.entries
        .where((entry) => !entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  @override
  String toString() {
    return 'HealthPermissions(permissions: $permissions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthPermissions &&
        other.permissions.length == permissions.length &&
        other.permissions.entries
            .every((entry) => permissions[entry.key] == entry.value);
  }

  @override
  int get hashCode {
    return permissions.hashCode;
  }
}

/// Health data request model
class HealthDataRequest {
  final List<CareCircleHealthDataType> types;
  final DateTime startDate;
  final DateTime endDate;
  final int? limit;
  final Map<String, dynamic>? filters;

  const HealthDataRequest({
    required this.types,
    required this.startDate,
    required this.endDate,
    this.limit,
    this.filters,
  });

  /// Create from JSON
  factory HealthDataRequest.fromJson(Map<String, dynamic> json) {
    final types = (json['types'] as List<dynamic>)
        .map((type) => CareCircleHealthDataType.values.firstWhere(
              (t) => t.name == type,
              orElse: () =>
                  throw ArgumentError('Invalid health data type: $type'),
            ))
        .toList();

    return HealthDataRequest(
      types: types,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      limit: json['limit'] as int?,
      filters: json['filters'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'types': types.map((type) => type.name).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'limit': limit,
      'filters': filters,
    };
  }

  /// Copy with new values
  HealthDataRequest copyWith({
    List<CareCircleHealthDataType>? types,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    Map<String, dynamic>? filters,
  }) {
    return HealthDataRequest(
      types: types ?? this.types,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      limit: limit ?? this.limit,
      filters: filters ?? this.filters,
    );
  }

  @override
  String toString() {
    return 'HealthDataRequest(types: $types, startDate: $startDate, endDate: $endDate, limit: $limit, filters: $filters)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthDataRequest &&
        other.types.length == types.length &&
        other.types.every((type) => types.contains(type)) &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    return types.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        (limit?.hashCode ?? 0);
  }
}
