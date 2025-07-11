// API response models for notification system
import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification.dart';
import 'notification_preferences.dart';
import 'notification_template.dart';
import 'emergency_alert.dart';

part 'api_responses.freezed.dart';
part 'api_responses.g.dart';

/// Notification response wrapper
@freezed
abstract class NotificationResponse with _$NotificationResponse {
  const factory NotificationResponse({
    required bool success,
    required String message,
    Notification? data,
    Map<String, dynamic>? errors,
    DateTime? timestamp,
  }) = _NotificationResponse;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);
}

/// Notification list response wrapper
@freezed
abstract class NotificationListResponse with _$NotificationListResponse {
  const factory NotificationListResponse({
    required bool success,
    required String message,
    @Default([]) List<Notification> data,
    Map<String, dynamic>? errors,
    DateTime? timestamp,
    PaginationMeta? pagination,
  }) = _NotificationListResponse;

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseFromJson(json);
}

/// Notification summary response wrapper
@freezed
abstract class NotificationSummaryResponse with _$NotificationSummaryResponse {
  const factory NotificationSummaryResponse({
    required bool success,
    required String message,
    NotificationSummary? data,
    Map<String, dynamic>? errors,
    DateTime? timestamp,
  }) = _NotificationSummaryResponse;

  factory NotificationSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationSummaryResponseFromJson(json);
}

/// Notification preferences response wrapper
@freezed
abstract class NotificationPreferencesResponse with _$NotificationPreferencesResponse {
  const factory NotificationPreferencesResponse({
    required bool success,
    required String message,
    NotificationPreferences? data,
    Map<String, dynamic>? errors,
    DateTime? timestamp,
  }) = _NotificationPreferencesResponse;

  factory NotificationPreferencesResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesResponseFromJson(json);
}

/// Emergency alert response wrapper
@freezed
abstract class EmergencyAlertResponse with _$EmergencyAlertResponse {
  const factory EmergencyAlertResponse({
    required bool success,
    required String message,
    EmergencyAlert? data,
    Map<String, dynamic>? errors,
    DateTime? timestamp,
  }) = _EmergencyAlertResponse;

  factory EmergencyAlertResponse.fromJson(Map<String, dynamic> json) =>
      _$EmergencyAlertResponseFromJson(json);
}

/// Emergency alert list response wrapper
@freezed
abstract class EmergencyAlertListResponse with _$EmergencyAlertListResponse {
  const factory EmergencyAlertListResponse({
    required bool success,
    required String message,
    @Default([]) List<EmergencyAlert> data,
    Map<String, dynamic>? errors,
    DateTime? timestamp,
    PaginationMeta? pagination,
  }) = _EmergencyAlertListResponse;

  factory EmergencyAlertListResponse.fromJson(Map<String, dynamic> json) =>
      _$EmergencyAlertListResponseFromJson(json);
}

/// Emergency contact response wrapper
@freezed
abstract class EmergencyContactResponse with _$EmergencyContactResponse {
  const factory EmergencyContactResponse({
    required bool success,
    required String message,
    EmergencyContact? data,
    Map<String, dynamic>? errors,
    DateTime? timestamp,
  }) = _EmergencyContactResponse;

  factory EmergencyContactResponse.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactResponseFromJson(json);
}

/// Emergency contact list response wrapper
@freezed
abstract class EmergencyContactListResponse with _$EmergencyContactListResponse {
  const factory EmergencyContactListResponse({
    required bool success,
    required String message,
    @Default([]) List<EmergencyContact> data,
    Map<String, dynamic>? errors,
    DateTime? timestamp,
    PaginationMeta? pagination,
  }) = _EmergencyContactListResponse;

  factory EmergencyContactListResponse.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactListResponseFromJson(json);
}

/// Notification template response wrapper
@freezed
abstract class NotificationTemplateResponse with _$NotificationTemplateResponse {
  const factory NotificationTemplateResponse({
    required bool success,
    required String message,
    NotificationTemplate? data,
    Map<String, dynamic>? errors,
    DateTime? timestamp,
  }) = _NotificationTemplateResponse;

  factory NotificationTemplateResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationTemplateResponseFromJson(json);
}

/// Notification template list response wrapper
@freezed
abstract class NotificationTemplateListResponse with _$NotificationTemplateListResponse {
  const factory NotificationTemplateListResponse({
    required bool success,
    required String message,
    @Default([]) List<NotificationTemplate> data,
    Map<String, dynamic>? errors,
    DateTime? timestamp,
    PaginationMeta? pagination,
  }) = _NotificationTemplateListResponse;

  factory NotificationTemplateListResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$NotificationTemplateListResponseFromJson(json);
}

/// Rendered template response wrapper
@freezed
abstract class RenderedTemplateResponse with _$RenderedTemplateResponse {
  const factory RenderedTemplateResponse({
    required bool success,
    required String message,
    RenderedTemplate? data,
    Map<String, dynamic>? errors,
    DateTime? timestamp,
  }) = _RenderedTemplateResponse;

  factory RenderedTemplateResponse.fromJson(Map<String, dynamic> json) =>
      _$RenderedTemplateResponseFromJson(json);
}

/// Pagination metadata
@freezed
abstract class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    required int currentPage,
    required int totalPages,
    required int totalItems,
    required int itemsPerPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
}

/// Rendered template data
@freezed
abstract class RenderedTemplate with _$RenderedTemplate {
  const factory RenderedTemplate({
    required String templateId,
    required String renderedContent,
    required String subject,
    Map<String, dynamic>? variables,
    DateTime? renderedAt,
  }) = _RenderedTemplate;

  factory RenderedTemplate.fromJson(Map<String, dynamic> json) =>
      _$RenderedTemplateFromJson(json);
}
