// Health device models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_device.freezed.dart';
part 'health_device.g.dart';

enum DeviceType {
  @JsonValue('smart_watch')
  smartWatch,
  @JsonValue('fitness_tracker')
  fitnessTracker,
  @JsonValue('blood_pressure_monitor')
  bloodPressureMonitor,
  @JsonValue('glucose_monitor')
  glucoseMonitor,
  @JsonValue('pulse_oximeter')
  pulseOximeter,
  @JsonValue('scale')
  scale,
  @JsonValue('thermometer')
  thermometer,
}

enum ConnectionStatus {
  @JsonValue('connected')
  connected,
  @JsonValue('disconnected')
  disconnected,
  @JsonValue('pairing')
  pairing,
  @JsonValue('error')
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
  bool get isPairing => connectionStatus == ConnectionStatus.pairing;
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
      case DeviceType.smartWatch:
        return 'Smart Watch';
      case DeviceType.fitnessTracker:
        return 'Fitness Tracker';
      case DeviceType.bloodPressureMonitor:
        return 'Blood Pressure Monitor';
      case DeviceType.glucoseMonitor:
        return 'Glucose Monitor';
      case DeviceType.pulseOximeter:
        return 'Pulse Oximeter';
      case DeviceType.scale:
        return 'Scale';
      case DeviceType.thermometer:
        return 'Thermometer';
    }
  }

  List<String> get supportedMetrics {
    switch (deviceType) {
      case DeviceType.smartWatch:
        return ['heart_rate', 'steps', 'activity', 'sleep'];
      case DeviceType.fitnessTracker:
        return ['steps', 'activity', 'sleep', 'heart_rate'];
      case DeviceType.bloodPressureMonitor:
        return ['blood_pressure'];
      case DeviceType.glucoseMonitor:
        return ['blood_glucose'];
      case DeviceType.pulseOximeter:
        return ['blood_oxygen', 'heart_rate'];
      case DeviceType.scale:
        return ['weight'];
      case DeviceType.thermometer:
        return ['body_temperature'];
    }
  }
}
