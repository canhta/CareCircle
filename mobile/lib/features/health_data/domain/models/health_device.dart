// Health device models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_device.freezed.dart';
part 'health_device.g.dart';

enum DeviceType {
  @JsonValue('BLOOD_PRESSURE_MONITOR')
  bloodPressureMonitor,
  @JsonValue('GLUCOSE_METER')
  glucoseMeter,
  @JsonValue('SCALE')
  scale,
  @JsonValue('FITNESS_TRACKER')
  fitnessTracker,
  @JsonValue('SMARTWATCH')
  smartwatch,
  @JsonValue('PULSE_OXIMETER')
  pulseOximeter,
  @JsonValue('THERMOMETER')
  thermometer,
  @JsonValue('OTHER')
  other,
}

enum ConnectionStatus {
  @JsonValue('CONNECTED')
  connected,
  @JsonValue('DISCONNECTED')
  disconnected,
  @JsonValue('SYNCING')
  syncing,
  @JsonValue('ERROR')
  error,
}

/// Health device entity
@freezed
abstract class HealthDevice with _$HealthDevice {
  const factory HealthDevice({
    required String id,
    required String userId,
    required DeviceType deviceType,
    required String manufacturer,
    required String model,
    String? serialNumber,
    required DateTime lastSyncTimestamp,
    required ConnectionStatus connectionStatus,
    int? batteryLevel,
    String? firmware,
    @Default({}) Map<String, dynamic> settings,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HealthDevice;

  factory HealthDevice.fromJson(Map<String, dynamic> json) =>
      _$HealthDeviceFromJson(json);
}

/// Extension methods for HealthDevice
extension HealthDeviceExtension on HealthDevice {
  bool get isConnected => connectionStatus == ConnectionStatus.connected;
  bool get isSyncing => connectionStatus == ConnectionStatus.syncing;
  bool get hasError => connectionStatus == ConnectionStatus.error;

  bool get needsBatteryReplacement =>
      batteryLevel != null && batteryLevel! < 20;

  bool get isLowBattery => batteryLevel != null && batteryLevel! < 30;

  Duration get lastSyncAge => DateTime.now().difference(lastSyncTimestamp);

  bool isRecentlySync([int hoursThreshold = 24]) {
    final ageInHours = lastSyncAge.inHours;
    return ageInHours <= hoursThreshold;
  }

  String get displayName => '$manufacturer $model';

  String get deviceTypeDisplayName {
    switch (deviceType) {
      case DeviceType.bloodPressureMonitor:
        return 'Blood Pressure Monitor';
      case DeviceType.glucoseMeter:
        return 'Glucose Meter';
      case DeviceType.scale:
        return 'Scale';
      case DeviceType.fitnessTracker:
        return 'Fitness Tracker';
      case DeviceType.smartwatch:
        return 'Smartwatch';
      case DeviceType.pulseOximeter:
        return 'Pulse Oximeter';
      case DeviceType.thermometer:
        return 'Thermometer';
      case DeviceType.other:
        return 'Other';
    }
  }

  List<String> get supportedMetrics {
    switch (deviceType) {
      case DeviceType.bloodPressureMonitor:
        return ['BLOOD_PRESSURE'];
      case DeviceType.glucoseMeter:
        return ['BLOOD_GLUCOSE'];
      case DeviceType.scale:
        return ['WEIGHT'];
      case DeviceType.fitnessTracker:
        return ['STEPS', 'EXERCISE_MINUTES', 'SLEEP_DURATION', 'HEART_RATE'];
      case DeviceType.smartwatch:
        return ['HEART_RATE', 'STEPS', 'EXERCISE_MINUTES', 'SLEEP_DURATION'];
      case DeviceType.pulseOximeter:
        return ['OXYGEN_SATURATION', 'HEART_RATE'];
      case DeviceType.thermometer:
        return ['TEMPERATURE'];
      case DeviceType.other:
        return [];
    }
  }
}
