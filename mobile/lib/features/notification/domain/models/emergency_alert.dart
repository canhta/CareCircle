// Emergency alert models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';

part 'emergency_alert.freezed.dart';
part 'emergency_alert.g.dart';

/// Emergency alert severity levels
enum EmergencyAlertSeverity {
  @JsonValue('LOW')
  low,
  @JsonValue('MEDIUM')
  medium,
  @JsonValue('HIGH')
  high,
  @JsonValue('CRITICAL')
  critical,
}

/// Emergency alert types
enum EmergencyAlertType {
  @JsonValue('MEDICAL_EMERGENCY')
  medicalEmergency,
  @JsonValue('MEDICATION_OVERDOSE')
  medicationOverdose,
  @JsonValue('FALL_DETECTION')
  fallDetection,
  @JsonValue('VITAL_SIGNS_CRITICAL')
  vitalSignsCritical,
  @JsonValue('MISSED_CRITICAL_MEDICATION')
  missedCriticalMedication,
  @JsonValue('PANIC_BUTTON')
  panicButton,
  @JsonValue('DEVICE_MALFUNCTION')
  deviceMalfunction,
  @JsonValue('LOCATION_ALERT')
  locationAlert,
  @JsonValue('CAREGIVER_ALERT')
  caregiverAlert,
  @JsonValue('SYSTEM_ALERT')
  systemAlert,
}

/// Emergency alert status
enum EmergencyAlertStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('ACKNOWLEDGED')
  acknowledged,
  @JsonValue('RESOLVED')
  resolved,
  @JsonValue('ESCALATED')
  escalated,
  @JsonValue('CANCELLED')
  cancelled,
}

/// Emergency alert entity
@freezed
abstract class EmergencyAlert with _$EmergencyAlert {
  const factory EmergencyAlert({
    required String id,
    required String userId,
    required String title,
    required String message,
    required EmergencyAlertType alertType,
    required EmergencyAlertSeverity severity,
    @Default(EmergencyAlertStatus.active) EmergencyAlertStatus status,
    required DateTime createdAt,
    DateTime? acknowledgedAt,
    DateTime? resolvedAt,
    String? acknowledgedBy,
    String? resolvedBy,
    Map<String, dynamic>? metadata,
    String? location,
    List<String>? attachments,
    @Default([]) List<EmergencyAlertAction> actions,
    @Default([]) List<EmergencyEscalation> escalations,
    DateTime? updatedAt,
  }) = _EmergencyAlert;

  factory EmergencyAlert.fromJson(Map<String, dynamic> json) =>
      _$EmergencyAlertFromJson(json);
}

/// Emergency alert action (buttons/responses)
@freezed
abstract class EmergencyAlertAction with _$EmergencyAlertAction {
  const factory EmergencyAlertAction({
    required String id,
    required String label,
    required String
    actionType, // 'acknowledge', 'resolve', 'escalate', 'call_emergency', 'contact_caregiver'
    String? phoneNumber,
    String? url,
    Map<String, dynamic>? parameters,
    @Default(false) bool isPrimary,
    @Default(false) bool isDestructive,
  }) = _EmergencyAlertAction;

  factory EmergencyAlertAction.fromJson(Map<String, dynamic> json) =>
      _$EmergencyAlertActionFromJson(json);
}

/// Emergency escalation tracking
@freezed
abstract class EmergencyEscalation with _$EmergencyEscalation {
  const factory EmergencyEscalation({
    required String id,
    required String alertId,
    required String contactId,
    required String contactName,
    required String contactPhone,
    String? contactEmail,
    required DateTime scheduledAt,
    DateTime? sentAt,
    DateTime? acknowledgedAt,
    @Default('pending')
    String status, // 'pending', 'sent', 'acknowledged', 'failed'
    String? failureReason,
    @Default(1) int attemptNumber,
    @Default(1) int priority,
  }) = _EmergencyEscalation;

  factory EmergencyEscalation.fromJson(Map<String, dynamic> json) =>
      _$EmergencyEscalationFromJson(json);
}

/// Extensions for emergency alert utilities
extension EmergencyAlertSeverityExtension on EmergencyAlertSeverity {
  String get displayName {
    switch (this) {
      case EmergencyAlertSeverity.low:
        return 'Low';
      case EmergencyAlertSeverity.medium:
        return 'Medium';
      case EmergencyAlertSeverity.high:
        return 'High';
      case EmergencyAlertSeverity.critical:
        return 'Critical';
    }
  }

  String get color {
    switch (this) {
      case EmergencyAlertSeverity.low:
        return '#4CAF50'; // Green
      case EmergencyAlertSeverity.medium:
        return '#FF9800'; // Orange
      case EmergencyAlertSeverity.high:
        return '#F44336'; // Red
      case EmergencyAlertSeverity.critical:
        return '#9C27B0'; // Purple
    }
  }

  int get priority {
    switch (this) {
      case EmergencyAlertSeverity.low:
        return 1;
      case EmergencyAlertSeverity.medium:
        return 2;
      case EmergencyAlertSeverity.high:
        return 3;
      case EmergencyAlertSeverity.critical:
        return 4;
    }
  }
}

extension EmergencyAlertTypeExtension on EmergencyAlertType {
  String get displayName {
    switch (this) {
      case EmergencyAlertType.medicalEmergency:
        return 'Medical Emergency';
      case EmergencyAlertType.medicationOverdose:
        return 'Medication Overdose';
      case EmergencyAlertType.fallDetection:
        return 'Fall Detection';
      case EmergencyAlertType.vitalSignsCritical:
        return 'Critical Vital Signs';
      case EmergencyAlertType.missedCriticalMedication:
        return 'Missed Critical Medication';
      case EmergencyAlertType.panicButton:
        return 'Panic Button';
      case EmergencyAlertType.deviceMalfunction:
        return 'Device Malfunction';
      case EmergencyAlertType.locationAlert:
        return 'Location Alert';
      case EmergencyAlertType.caregiverAlert:
        return 'Caregiver Alert';
      case EmergencyAlertType.systemAlert:
        return 'System Alert';
    }
  }

  String get icon {
    switch (this) {
      case EmergencyAlertType.medicalEmergency:
        return '🚨';
      case EmergencyAlertType.medicationOverdose:
        return '💊';
      case EmergencyAlertType.fallDetection:
        return '🤕';
      case EmergencyAlertType.vitalSignsCritical:
        return '💓';
      case EmergencyAlertType.missedCriticalMedication:
        return '⏰';
      case EmergencyAlertType.panicButton:
        return '🆘';
      case EmergencyAlertType.deviceMalfunction:
        return '⚠️';
      case EmergencyAlertType.locationAlert:
        return '📍';
      case EmergencyAlertType.caregiverAlert:
        return '👨‍⚕️';
      case EmergencyAlertType.systemAlert:
        return '🔧';
    }
  }

  EmergencyAlertSeverity get defaultSeverity {
    switch (this) {
      case EmergencyAlertType.medicalEmergency:
      case EmergencyAlertType.medicationOverdose:
      case EmergencyAlertType.vitalSignsCritical:
      case EmergencyAlertType.panicButton:
        return EmergencyAlertSeverity.critical;
      case EmergencyAlertType.fallDetection:
      case EmergencyAlertType.missedCriticalMedication:
      case EmergencyAlertType.caregiverAlert:
        return EmergencyAlertSeverity.high;
      case EmergencyAlertType.deviceMalfunction:
      case EmergencyAlertType.locationAlert:
        return EmergencyAlertSeverity.medium;
      case EmergencyAlertType.systemAlert:
        return EmergencyAlertSeverity.low;
    }
  }
}

extension EmergencyAlertExtension on EmergencyAlert {
  /// Check if alert is still active
  bool get isActive => status == EmergencyAlertStatus.active;

  /// Check if alert requires immediate attention
  bool get requiresImmediateAttention =>
      isActive &&
      (severity == EmergencyAlertSeverity.critical ||
          severity == EmergencyAlertSeverity.high);

  /// Get time since alert was created
  Duration get timeSinceCreated => DateTime.now().difference(createdAt);

  /// Check if alert should be escalated
  bool shouldEscalate(int escalationDelayMinutes) {
    if (!isActive) return false;
    return timeSinceCreated.inMinutes >= escalationDelayMinutes;
  }

  /// Get next escalation contact
  EmergencyEscalation? get nextEscalation {
    final pendingEscalations =
        escalations.where((e) => e.status == 'pending').toList()
          ..sort((a, b) => a.priority.compareTo(b.priority));

    return pendingEscalations.isNotEmpty ? pendingEscalations.first : null;
  }

  /// Get primary action
  EmergencyAlertAction? get primaryAction {
    return actions.where((a) => a.isPrimary).isNotEmpty
        ? actions.firstWhere((a) => a.isPrimary)
        : actions.isNotEmpty
        ? actions.first
        : null;
  }
}
