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

// Health Analysis Models

class HealthInsight {
  final String
      type; // 'warning', 'improvement', 'goal_achieved', 'recommendation'
  final String title;
  final String description;
  final String severity; // 'low', 'medium', 'high'
  final int confidence; // 0-100
  final bool actionable;
  final List<String>? recommendations;
  final HealthTrend? trend;

  const HealthInsight({
    required this.type,
    required this.title,
    required this.description,
    required this.severity,
    required this.confidence,
    required this.actionable,
    this.recommendations,
    this.trend,
  });

  factory HealthInsight.fromJson(Map<String, dynamic> json) {
    return HealthInsight(
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      severity: json['severity'] as String,
      confidence: json['confidence'] as int,
      actionable: json['actionable'] as bool,
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : null,
      trend: json['trend'] != null ? HealthTrend.fromJson(json['trend']) : null,
    );
  }
}

class HealthTrend {
  final String metric;
  final double currentValue;
  final double previousValue;
  final double change;
  final double changePercentage;
  final String direction; // 'up', 'down', 'stable'
  final String period; // 'daily', 'weekly', 'monthly'
  final int confidence;

  const HealthTrend({
    required this.metric,
    required this.currentValue,
    required this.previousValue,
    required this.change,
    required this.changePercentage,
    required this.direction,
    required this.period,
    required this.confidence,
  });

  factory HealthTrend.fromJson(Map<String, dynamic> json) {
    return HealthTrend(
      metric: json['metric'] as String,
      currentValue: (json['currentValue'] as num).toDouble(),
      previousValue: (json['previousValue'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      changePercentage: (json['changePercentage'] as num).toDouble(),
      direction: json['direction'] as String,
      period: json['period'] as String,
      confidence: json['confidence'] as int,
    );
  }
}

class HealthGoal {
  final String type;
  final String title;
  final int current;
  final int target;
  final String timeframe;
  final String priority;

  const HealthGoal({
    required this.type,
    required this.title,
    required this.current,
    required this.target,
    required this.timeframe,
    required this.priority,
  });

  factory HealthGoal.fromJson(Map<String, dynamic> json) {
    return HealthGoal(
      type: json['type'] as String,
      title: json['title'] as String,
      current: json['current'] as int,
      target: json['target'] as int,
      timeframe: json['timeframe'] as String,
      priority: json['priority'] as String,
    );
  }

  double get progressPercentage => target > 0 ? (current / target) * 100 : 0;
}

class HealthMetrics {
  final StepsMetrics steps;
  final HeartRateMetrics heartRate;
  final SleepMetrics sleep;
  final ActivityMetrics activity;
  final VitalsMetrics? vitals;

  const HealthMetrics({
    required this.steps,
    required this.heartRate,
    required this.sleep,
    required this.activity,
    this.vitals,
  });

  factory HealthMetrics.fromJson(Map<String, dynamic> json) {
    return HealthMetrics(
      steps: StepsMetrics.fromJson(json['steps']),
      heartRate: HeartRateMetrics.fromJson(json['heartRate']),
      sleep: SleepMetrics.fromJson(json['sleep']),
      activity: ActivityMetrics.fromJson(json['activity']),
      vitals: json['vitals'] != null
          ? VitalsMetrics.fromJson(json['vitals'])
          : null,
    );
  }
}

class StepsMetrics {
  final int total;
  final double average;
  final int min;
  final int max;
  final int daysWithData;

  const StepsMetrics({
    required this.total,
    required this.average,
    required this.min,
    required this.max,
    required this.daysWithData,
  });

  factory StepsMetrics.fromJson(Map<String, dynamic> json) {
    return StepsMetrics(
      total: json['total'] as int,
      average: (json['average'] as num).toDouble(),
      min: json['min'] as int,
      max: json['max'] as int,
      daysWithData: json['daysWithData'] as int,
    );
  }
}

class HeartRateMetrics {
  final double average;
  final double resting;
  final double max;
  final double variability;

  const HeartRateMetrics({
    required this.average,
    required this.resting,
    required this.max,
    required this.variability,
  });

  factory HeartRateMetrics.fromJson(Map<String, dynamic> json) {
    return HeartRateMetrics(
      average: (json['average'] as num).toDouble(),
      resting: (json['resting'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      variability: (json['variability'] as num).toDouble(),
    );
  }
}

class SleepMetrics {
  final double averageDuration; // minutes
  final double averageQuality; // 1-10
  final double deepSleepPercentage;
  final double remSleepPercentage;

  const SleepMetrics({
    required this.averageDuration,
    required this.averageQuality,
    required this.deepSleepPercentage,
    required this.remSleepPercentage,
  });

  factory SleepMetrics.fromJson(Map<String, dynamic> json) {
    return SleepMetrics(
      averageDuration: (json['averageDuration'] as num).toDouble(),
      averageQuality: (json['averageQuality'] as num).toDouble(),
      deepSleepPercentage: (json['deepSleepPercentage'] as num).toDouble(),
      remSleepPercentage: (json['remSleepPercentage'] as num).toDouble(),
    );
  }

  double get durationInHours => averageDuration / 60;
}

class ActivityMetrics {
  final int activeMinutes;
  final int caloriesBurned;
  final double distance;

  const ActivityMetrics({
    required this.activeMinutes,
    required this.caloriesBurned,
    required this.distance,
  });

  factory ActivityMetrics.fromJson(Map<String, dynamic> json) {
    return ActivityMetrics(
      activeMinutes: json['activeMinutes'] as int,
      caloriesBurned: json['caloriesBurned'] as int,
      distance: (json['distance'] as num).toDouble(),
    );
  }
}

class VitalsMetrics {
  final double? weight;
  final BloodPressureMetrics? bloodPressure;
  final double? bloodGlucose;
  final double? bodyTemperature;

  const VitalsMetrics({
    this.weight,
    this.bloodPressure,
    this.bloodGlucose,
    this.bodyTemperature,
  });

  factory VitalsMetrics.fromJson(Map<String, dynamic> json) {
    return VitalsMetrics(
      weight:
          json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      bloodPressure: json['bloodPressure'] != null
          ? BloodPressureMetrics.fromJson(json['bloodPressure'])
          : null,
      bloodGlucose: json['bloodGlucose'] != null
          ? (json['bloodGlucose'] as num).toDouble()
          : null,
      bodyTemperature: json['bodyTemperature'] != null
          ? (json['bodyTemperature'] as num).toDouble()
          : null,
    );
  }
}

class BloodPressureMetrics {
  final int systolic;
  final int diastolic;

  const BloodPressureMetrics({required this.systolic, required this.diastolic});

  factory BloodPressureMetrics.fromJson(Map<String, dynamic> json) {
    return BloodPressureMetrics(
      systolic: json['systolic'] as int,
      diastolic: json['diastolic'] as int,
    );
  }

  String get formatted => '$systolic/$diastolic mmHg';
}

class HealthAnalysisData {
  final String userId;
  final String period;
  final DateTime startDate;
  final DateTime endDate;
  final HealthMetrics metrics;
  final List<HealthInsight> insights;
  final List<HealthTrend> trends;
  final List<HealthGoal> goals;
  final String dataQuality;

  const HealthAnalysisData({
    required this.userId,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.metrics,
    required this.insights,
    required this.trends,
    required this.goals,
    required this.dataQuality,
  });

  factory HealthAnalysisData.fromJson(Map<String, dynamic> json) {
    return HealthAnalysisData(
      userId: json['userId'] as String,
      period: json['period'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      metrics: HealthMetrics.fromJson(json['metrics']),
      insights: (json['insights'] as List)
          .map((insight) => HealthInsight.fromJson(insight))
          .toList(),
      trends: (json['trends'] as List)
          .map((trend) => HealthTrend.fromJson(trend))
          .toList(),
      goals: (json['goals'] as List)
          .map((goal) => HealthGoal.fromJson(goal))
          .toList(),
      dataQuality: json['dataQuality'] as String,
    );
  }
}
