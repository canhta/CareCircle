class HealthDataPoint {
  final String type;
  final double value;
  final String unit;
  final DateTime timestamp;
  final String source;
  final Map<String, dynamic>? metadata;

  const HealthDataPoint({
    required this.type,
    required this.value,
    required this.unit,
    required this.timestamp,
    required this.source,
    this.metadata,
  });

  factory HealthDataPoint.fromJson(Map<String, dynamic> json) {
    return HealthDataPoint(
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      source: json['source'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'source': source,
      'metadata': metadata,
    };
  }

  @override
  String toString() {
    return 'HealthDataPoint(type: $type, value: $value $unit, timestamp: $timestamp, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthDataPoint &&
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
        source.hashCode;
  }
}

class HealthSyncStatus {
  final String id;
  final DateTime lastSync;
  final bool isSuccess;
  final String? error;
  final int recordsCount;

  const HealthSyncStatus({
    required this.id,
    required this.lastSync,
    required this.isSuccess,
    this.error,
    required this.recordsCount,
  });

  factory HealthSyncStatus.fromJson(Map<String, dynamic> json) {
    return HealthSyncStatus(
      id: json['id'] as String,
      lastSync: DateTime.parse(json['lastSync'] as String),
      isSuccess: json['isSuccess'] as bool,
      error: json['error'] as String?,
      recordsCount: json['recordsCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lastSync': lastSync.toIso8601String(),
      'isSuccess': isSuccess,
      'error': error,
      'recordsCount': recordsCount,
    };
  }
}

class HealthPermissionStatus {
  final String dataType;
  final bool isGranted;
  final bool canWrite;
  final bool canRead;

  const HealthPermissionStatus({
    required this.dataType,
    required this.isGranted,
    required this.canWrite,
    required this.canRead,
  });

  factory HealthPermissionStatus.fromJson(Map<String, dynamic> json) {
    return HealthPermissionStatus(
      dataType: json['dataType'] as String,
      isGranted: json['isGranted'] as bool,
      canWrite: json['canWrite'] as bool,
      canRead: json['canRead'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dataType': dataType,
      'isGranted': isGranted,
      'canWrite': canWrite,
      'canRead': canRead,
    };
  }
}

class HealthDataSummary {
  final String type;
  final String period; // 'day', 'week', 'month'
  final double? minValue;
  final double? maxValue;
  final double? avgValue;
  final int count;
  final DateTime startDate;
  final DateTime endDate;

  const HealthDataSummary({
    required this.type,
    required this.period,
    this.minValue,
    this.maxValue,
    this.avgValue,
    required this.count,
    required this.startDate,
    required this.endDate,
  });

  factory HealthDataSummary.fromJson(Map<String, dynamic> json) {
    return HealthDataSummary(
      type: json['type'] as String,
      period: json['period'] as String,
      minValue: json['minValue'] as double?,
      maxValue: json['maxValue'] as double?,
      avgValue: json['avgValue'] as double?,
      count: json['count'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'period': period,
      'minValue': minValue,
      'maxValue': maxValue,
      'avgValue': avgValue,
      'count': count,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}

enum HealthDataType {
  steps('STEPS'),
  heartRate('HEART_RATE'),
  weight('WEIGHT'),
  height('HEIGHT'),
  sleepAnalysis('SLEEP_ANALYSIS'),
  bloodPressureSystolic('BLOOD_PRESSURE_SYSTOLIC'),
  bloodPressureDiastolic('BLOOD_PRESSURE_DIASTOLIC'),
  bloodGlucose('BLOOD_GLUCOSE'),
  bodyTemperature('BODY_TEMPERATURE'),
  oxygenSaturation('OXYGEN_SATURATION'),
  activeEnergyBurned('ACTIVE_ENERGY_BURNED'),
  distanceWalkingRunning('DISTANCE_WALKING_RUNNING');

  const HealthDataType(this.value);
  final String value;

  static HealthDataType? fromString(String value) {
    for (final type in HealthDataType.values) {
      if (type.value == value.toUpperCase()) {
        return type;
      }
    }
    return null;
  }
}

enum DataSource {
  appleHealth('APPLE_HEALTH'),
  googleFit('GOOGLE_FIT'),
  healthConnect('HEALTH_CONNECT'),
  manual('MANUAL'),
  device('DEVICE');

  const DataSource(this.value);
  final String value;

  static DataSource? fromString(String value) {
    for (final source in DataSource.values) {
      if (source.value == value.toUpperCase()) {
        return source;
      }
    }
    return null;
  }
}
