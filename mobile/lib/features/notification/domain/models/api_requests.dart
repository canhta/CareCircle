// API request models for notification system
import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification.dart';
import 'notification_preferences.dart';
import 'emergency_alert.dart';

part 'api_requests.freezed.dart';
part 'api_requests.g.dart';

/// Create notification request
@freezed
abstract class CreateNotificationRequest with _$CreateNotificationRequest {
  const factory CreateNotificationRequest({
    required String title,
    required String message,
    required NotificationType type,
    required NotificationPriority priority,
    required NotificationChannel channel,
    String? userId,
    Map<String, dynamic>? data,
    DateTime? scheduledAt,
    List<String>? tags,
  }) = _CreateNotificationRequest;

  factory CreateNotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateNotificationRequestFromJson(json);
}

/// Update notification preferences request
@freezed
abstract class UpdateNotificationPreferencesRequest
    with _$UpdateNotificationPreferencesRequest {
  const factory UpdateNotificationPreferencesRequest({
    bool? globalEnabled,
    QuietHoursSettings? quietHours,
    EmergencyAlertSettings? emergencySettings,
    Map<String, bool>? channelPreferences,
    Map<String, bool>? typePreferences,
    Map<String, bool>? contextPreferences,
  }) = _UpdateNotificationPreferencesRequest;

  factory UpdateNotificationPreferencesRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateNotificationPreferencesRequestFromJson(json);
}

/// Update specific preference request
@freezed
abstract class UpdatePreferenceRequest with _$UpdatePreferenceRequest {
  const factory UpdatePreferenceRequest({
    required bool enabled,
    Map<String, dynamic>? settings,
  }) = _UpdatePreferenceRequest;

  factory UpdatePreferenceRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePreferenceRequestFromJson(json);
}

/// Create emergency alert request
@freezed
abstract class CreateEmergencyAlertRequest with _$CreateEmergencyAlertRequest {
  const factory CreateEmergencyAlertRequest({
    required String title,
    required String message,
    required EmergencyAlertSeverity severity,
    required EmergencyAlertType alertType,
    String? userId,
    String? careGroupId,
    Map<String, dynamic>? metadata,
    List<String>? affectedUsers,
    bool? requiresAcknowledgment,
    int? escalationTimeoutMinutes,
  }) = _CreateEmergencyAlertRequest;

  factory CreateEmergencyAlertRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateEmergencyAlertRequestFromJson(json);
}

/// Emergency alert action request
@freezed
abstract class EmergencyAlertActionRequest with _$EmergencyAlertActionRequest {
  const factory EmergencyAlertActionRequest({
    required String actionType,
    String? notes,
    Map<String, dynamic>? actionData,
    String? performedBy,
  }) = _EmergencyAlertActionRequest;

  factory EmergencyAlertActionRequest.fromJson(Map<String, dynamic> json) =>
      _$EmergencyAlertActionRequestFromJson(json);
}

/// Create template request
@freezed
abstract class CreateTemplateRequest with _$CreateTemplateRequest {
  const factory CreateTemplateRequest({
    required String name,
    required String subject,
    required String content,
    required NotificationType type,
    required NotificationChannel channel,
    String? description,
    Map<String, String>? variables,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) = _CreateTemplateRequest;

  factory CreateTemplateRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTemplateRequestFromJson(json);
}

/// Update template request
@freezed
abstract class UpdateTemplateRequest with _$UpdateTemplateRequest {
  const factory UpdateTemplateRequest({
    String? name,
    String? subject,
    String? content,
    String? description,
    Map<String, String>? variables,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) = _UpdateTemplateRequest;

  factory UpdateTemplateRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTemplateRequestFromJson(json);
}

/// Render template request
@freezed
abstract class RenderTemplateRequest with _$RenderTemplateRequest {
  const factory RenderTemplateRequest({
    required Map<String, dynamic> variables,
    String? locale,
    Map<String, dynamic>? context,
  }) = _RenderTemplateRequest;

  factory RenderTemplateRequest.fromJson(Map<String, dynamic> json) =>
      _$RenderTemplateRequestFromJson(json);
}
