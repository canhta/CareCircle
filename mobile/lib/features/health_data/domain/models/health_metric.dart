// Health metric models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';
import 'health_metric_type.dart';

part 'health_metric.freezed.dart';
part 'health_metric.g.dart';

enum DataSource {
  @JsonValue('MANUAL_ENTRY')
  manualEntry,
  @JsonValue('HEALTH_KIT')
  healthKit,
  @JsonValue('GOOGLE_FIT')
  googleFit,
  @JsonValue('DEVICE_SYNC')
  deviceSync,
  @JsonValue('IMPORTED')
  imported,
}

enum ValidationStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('VALIDATED')
  validated,
  @JsonValue('FLAGGED')
  flagged,
  @JsonValue('REJECTED')
  rejected,
}

/// Main health metric entity
@freezed
abstract class HealthMetric with _$HealthMetric {
  const factory HealthMetric({
    required String id,
    required String userId,
    required HealthMetricType metricType,
    required double value,
    required String unit,
    required DateTime timestamp,
    required DataSource source,
    String? deviceId,
    String? notes,
    required bool isManualEntry,
    required ValidationStatus validationStatus,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
  }) = _HealthMetric;

  factory HealthMetric.fromJson(Map<String, dynamic> json) =>
      _$HealthMetricFromJson(json);
}

/// Extension methods for HealthMetric
extension HealthMetricExtension on HealthMetric {
  String get displayValue {
    switch (metricType) {
      case HealthMetricType.bloodPressure:
        final diastolic = metadata['diastolic'] ?? 0;
        return '$value/$diastolic $unit';
      default:
        return '$value $unit';
    }
  }

  bool get isFromDevice => deviceId != null;

  bool get isFromExternalAPI {
    return [
      DataSource.healthKit,
      DataSource.googleFit,
      DataSource.deviceSync,
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

  String get metricTypeDisplayName => metricType.displayName;
}
