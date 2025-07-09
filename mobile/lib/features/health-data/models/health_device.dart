import 'package:json_annotation/json_annotation.dart';

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

@JsonSerializable()
class HealthDevice {
  final String id;
  final String userId;
  final DeviceType deviceType;
  final String manufacturer;
  final String model;
  final String? serialNumber;
  final DateTime lastSyncTimestamp;
  final ConnectionStatus connectionStatus;
  final int? batteryLevel;
  final String? firmware;
  final Map<String, dynamic> settings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HealthDevice({
    required this.id,
    required this.userId,
    required this.deviceType,
    required this.manufacturer,
    required this.model,
    this.serialNumber,
    required this.lastSyncTimestamp,
    required this.connectionStatus,
    this.batteryLevel,
    this.firmware,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HealthDevice.fromJson(Map<String, dynamic> json) =>
      _$HealthDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$HealthDeviceToJson(this);

  HealthDevice copyWith({
    String? id,
    String? userId,
    DeviceType? deviceType,
    String? manufacturer,
    String? model,
    String? serialNumber,
    DateTime? lastSyncTimestamp,
    ConnectionStatus? connectionStatus,
    int? batteryLevel,
    String? firmware,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthDevice(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceType: deviceType ?? this.deviceType,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      serialNumber: serialNumber ?? this.serialNumber,
      lastSyncTimestamp: lastSyncTimestamp ?? this.lastSyncTimestamp,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      firmware: firmware ?? this.firmware,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
