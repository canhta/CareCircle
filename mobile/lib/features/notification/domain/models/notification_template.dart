// Notification template models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';
import 'notification.dart';

part 'notification_template.freezed.dart';
part 'notification_template.g.dart';

/// Notification template entity
@freezed
abstract class NotificationTemplate with _$NotificationTemplate {
  const factory NotificationTemplate({
    required String id,
    required String name,
    required NotificationType type,
    required NotificationChannel channel,
    required String titleTemplate,
    required String messageTemplate,
    Map<String, dynamic>? defaultContext,
    @Default(true) bool isActive,
    String? description,
    List<String>? requiredVariables,
    Map<String, String>? variableDescriptions,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _NotificationTemplate;

  factory NotificationTemplate.fromJson(Map<String, dynamic> json) =>
      _$NotificationTemplateFromJson(json);
}

/// Template variable definition
@freezed
abstract class TemplateVariable with _$TemplateVariable {
  const factory TemplateVariable({
    required String name,
    required String type, // string, number, date, boolean
    required String description,
    @Default(true) bool required,
    String? defaultValue,
    List<String>? allowedValues,
    String? format, // For dates, numbers, etc.
  }) = _TemplateVariable;

  factory TemplateVariable.fromJson(Map<String, dynamic> json) =>
      _$TemplateVariableFromJson(json);
}

/// Template rendering request
@freezed
abstract class RenderTemplateRequest with _$RenderTemplateRequest {
  const factory RenderTemplateRequest({
    required String templateId,
    required Map<String, dynamic> variables,
    String? locale,
  }) = _RenderTemplateRequest;

  factory RenderTemplateRequest.fromJson(Map<String, dynamic> json) =>
      _$RenderTemplateRequestFromJson(json);
}

/// Rendered template result
@freezed
abstract class RenderedTemplate with _$RenderedTemplate {
  const factory RenderedTemplate({
    required String title,
    required String message,
    Map<String, dynamic>? context,
    List<String>? errors,
    List<String>? warnings,
  }) = _RenderedTemplate;

  factory RenderedTemplate.fromJson(Map<String, dynamic> json) =>
      _$RenderedTemplateFromJson(json);
}

/// Create template request DTO
@freezed
abstract class CreateTemplateRequest with _$CreateTemplateRequest {
  const factory CreateTemplateRequest({
    required String name,
    required NotificationType type,
    required NotificationChannel channel,
    required String titleTemplate,
    required String messageTemplate,
    Map<String, dynamic>? defaultContext,
    String? description,
    List<String>? requiredVariables,
    Map<String, String>? variableDescriptions,
  }) = _CreateTemplateRequest;

  factory CreateTemplateRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTemplateRequestFromJson(json);
}

/// Update template request DTO
@freezed
abstract class UpdateTemplateRequest with _$UpdateTemplateRequest {
  const factory UpdateTemplateRequest({
    String? name,
    String? titleTemplate,
    String? messageTemplate,
    Map<String, dynamic>? defaultContext,
    bool? isActive,
    String? description,
    List<String>? requiredVariables,
    Map<String, String>? variableDescriptions,
  }) = _UpdateTemplateRequest;

  factory UpdateTemplateRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTemplateRequestFromJson(json);
}

/// API response wrappers
@freezed
abstract class NotificationTemplateResponse
    with _$NotificationTemplateResponse {
  const factory NotificationTemplateResponse({
    required bool success,
    required NotificationTemplate data,
    String? message,
  }) = _NotificationTemplateResponse;

  factory NotificationTemplateResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationTemplateResponseFromJson(json);
}

@freezed
abstract class NotificationTemplateListResponse
    with _$NotificationTemplateListResponse {
  const factory NotificationTemplateListResponse({
    required bool success,
    required List<NotificationTemplate> data,
    String? message,
  }) = _NotificationTemplateListResponse;

  factory NotificationTemplateListResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$NotificationTemplateListResponseFromJson(json);
}

@freezed
abstract class RenderedTemplateResponse with _$RenderedTemplateResponse {
  const factory RenderedTemplateResponse({
    required bool success,
    required RenderedTemplate data,
    String? message,
  }) = _RenderedTemplateResponse;

  factory RenderedTemplateResponse.fromJson(Map<String, dynamic> json) =>
      _$RenderedTemplateResponseFromJson(json);
}

/// Predefined template types for common healthcare notifications
enum HealthcareTemplateType {
  medicationReminder,
  medicationMissed,
  medicationRefillReminder,
  appointmentReminder,
  appointmentConfirmation,
  labResultsAvailable,
  vitalsAlert,
  emergencyAlert,
  careGroupInvitation,
  careGroupTaskAssigned,
  careGroupTaskCompleted,
  systemMaintenance,
  securityAlert,
}

extension HealthcareTemplateTypeExtension on HealthcareTemplateType {
  String get displayName {
    switch (this) {
      case HealthcareTemplateType.medicationReminder:
        return 'Medication Reminder';
      case HealthcareTemplateType.medicationMissed:
        return 'Missed Medication';
      case HealthcareTemplateType.medicationRefillReminder:
        return 'Refill Reminder';
      case HealthcareTemplateType.appointmentReminder:
        return 'Appointment Reminder';
      case HealthcareTemplateType.appointmentConfirmation:
        return 'Appointment Confirmation';
      case HealthcareTemplateType.labResultsAvailable:
        return 'Lab Results Available';
      case HealthcareTemplateType.vitalsAlert:
        return 'Vitals Alert';
      case HealthcareTemplateType.emergencyAlert:
        return 'Emergency Alert';
      case HealthcareTemplateType.careGroupInvitation:
        return 'Care Group Invitation';
      case HealthcareTemplateType.careGroupTaskAssigned:
        return 'Task Assigned';
      case HealthcareTemplateType.careGroupTaskCompleted:
        return 'Task Completed';
      case HealthcareTemplateType.systemMaintenance:
        return 'System Maintenance';
      case HealthcareTemplateType.securityAlert:
        return 'Security Alert';
    }
  }

  NotificationType get notificationType {
    switch (this) {
      case HealthcareTemplateType.medicationReminder:
      case HealthcareTemplateType.medicationMissed:
      case HealthcareTemplateType.medicationRefillReminder:
        return NotificationType.medicationReminder;
      case HealthcareTemplateType.appointmentReminder:
      case HealthcareTemplateType.appointmentConfirmation:
        return NotificationType.appointmentReminder;
      case HealthcareTemplateType.labResultsAvailable:
      case HealthcareTemplateType.vitalsAlert:
        return NotificationType.healthAlert;
      case HealthcareTemplateType.emergencyAlert:
        return NotificationType.emergencyAlert;
      case HealthcareTemplateType.careGroupInvitation:
      case HealthcareTemplateType.careGroupTaskAssigned:
      case HealthcareTemplateType.careGroupTaskCompleted:
        return NotificationType.careGroupUpdate;
      case HealthcareTemplateType.systemMaintenance:
      case HealthcareTemplateType.securityAlert:
        return NotificationType.systemNotification;
    }
  }

  List<String> get commonVariables {
    switch (this) {
      case HealthcareTemplateType.medicationReminder:
        return ['medicationName', 'dosage', 'scheduledTime', 'patientName'];
      case HealthcareTemplateType.medicationMissed:
        return ['medicationName', 'dosage', 'missedTime', 'patientName'];
      case HealthcareTemplateType.medicationRefillReminder:
        return [
          'medicationName',
          'remainingDoses',
          'pharmacyName',
          'patientName',
        ];
      case HealthcareTemplateType.appointmentReminder:
        return [
          'appointmentDate',
          'appointmentTime',
          'doctorName',
          'clinicName',
          'patientName',
        ];
      case HealthcareTemplateType.appointmentConfirmation:
        return [
          'appointmentDate',
          'appointmentTime',
          'doctorName',
          'clinicName',
          'confirmationCode',
        ];
      case HealthcareTemplateType.labResultsAvailable:
        return ['testName', 'resultDate', 'doctorName', 'patientName'];
      case HealthcareTemplateType.vitalsAlert:
        return ['vitalType', 'value', 'normalRange', 'severity', 'patientName'];
      case HealthcareTemplateType.emergencyAlert:
        return [
          'alertType',
          'severity',
          'location',
          'contactInfo',
          'patientName',
        ];
      case HealthcareTemplateType.careGroupInvitation:
        return ['groupName', 'inviterName', 'role', 'patientName'];
      case HealthcareTemplateType.careGroupTaskAssigned:
        return [
          'taskTitle',
          'assignerName',
          'dueDate',
          'priority',
          'patientName',
        ];
      case HealthcareTemplateType.careGroupTaskCompleted:
        return ['taskTitle', 'completedBy', 'completionDate', 'patientName'];
      case HealthcareTemplateType.systemMaintenance:
        return ['maintenanceDate', 'duration', 'affectedServices'];
      case HealthcareTemplateType.securityAlert:
        return ['alertType', 'timestamp', 'location', 'actionRequired'];
    }
  }
}

/// Extensions for template utilities
extension NotificationTemplateExtension on NotificationTemplate {
  /// Check if template has all required variables
  bool hasRequiredVariables(Map<String, dynamic> variables) {
    if (requiredVariables == null) return true;

    for (final required in requiredVariables!) {
      if (!variables.containsKey(required) || variables[required] == null) {
        return false;
      }
    }
    return true;
  }

  /// Get missing required variables
  List<String> getMissingVariables(Map<String, dynamic> variables) {
    if (requiredVariables == null) return [];

    return requiredVariables!
        .where(
          (required) =>
              !variables.containsKey(required) || variables[required] == null,
        )
        .toList();
  }

  /// Validate template variables
  List<String> validateVariables(Map<String, dynamic> variables) {
    final errors = <String>[];

    // Check required variables
    final missing = getMissingVariables(variables);
    if (missing.isNotEmpty) {
      errors.add('Missing required variables: ${missing.join(', ')}');
    }

    // Add more validation logic as needed

    return errors;
  }
}
