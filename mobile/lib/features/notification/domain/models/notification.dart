// Notification models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

/// Notification types (matches backend Prisma enum)
enum NotificationType {
  @JsonValue('MEDICATION_REMINDER')
  medicationReminder,
  @JsonValue('HEALTH_ALERT')
  healthAlert,
  @JsonValue('APPOINTMENT_REMINDER')
  appointmentReminder,
  @JsonValue('TASK_REMINDER')
  taskReminder,
  @JsonValue('CARE_GROUP_UPDATE')
  careGroupUpdate,
  @JsonValue('SYSTEM_NOTIFICATION')
  systemNotification,
  @JsonValue('EMERGENCY_ALERT')
  emergencyAlert,
}

/// Notification priority levels (matches backend Prisma enum)
enum NotificationPriority {
  @JsonValue('LOW')
  low,
  @JsonValue('NORMAL')
  normal,
  @JsonValue('HIGH')
  high,
  @JsonValue('URGENT')
  urgent,
}

/// Notification channels (matches backend Prisma enum)
enum NotificationChannel {
  @JsonValue('PUSH')
  push,
  @JsonValue('SMS')
  sms,
  @JsonValue('EMAIL')
  email,
  @JsonValue('IN_APP')
  inApp,
}

/// Notification status (matches backend Prisma enum)
enum NotificationStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('SENT')
  sent,
  @JsonValue('DELIVERED')
  delivered,
  @JsonValue('READ')
  read,
  @JsonValue('FAILED')
  failed,
  @JsonValue('EXPIRED')
  expired,
}

/// Interaction types for notification interactions
enum InteractionType {
  @JsonValue('OPENED')
  opened,
  @JsonValue('DISMISSED')
  dismissed,
  @JsonValue('ACTION_CLICKED')
  actionClicked,
  @JsonValue('SNOOZED')
  snoozed,
}

/// Notification frequency for preferences
enum NotificationFrequency {
  @JsonValue('IMMEDIATELY')
  immediately,
  @JsonValue('BATCHED_HOURLY')
  batchedHourly,
  @JsonValue('BATCHED_DAILY')
  batchedDaily,
  @JsonValue('DIGEST')
  digest,
}

/// Context types for notification preferences
enum ContextType {
  @JsonValue('MEDICATION')
  medication,
  @JsonValue('HEALTH_DATA')
  healthData,
  @JsonValue('CARE_GROUP')
  careGroup,
  @JsonValue('APPOINTMENT')
  appointment,
  @JsonValue('SYSTEM')
  system,
  @JsonValue('EMERGENCY')
  emergency,
}

/// Extensions for enum display names and icons
extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.medicationReminder:
        return 'Medication Reminder';
      case NotificationType.healthAlert:
        return 'Health Alert';
      case NotificationType.appointmentReminder:
        return 'Appointment Reminder';
      case NotificationType.taskReminder:
        return 'Task Reminder';
      case NotificationType.careGroupUpdate:
        return 'Care Group Update';
      case NotificationType.systemNotification:
        return 'System Notification';
      case NotificationType.emergencyAlert:
        return 'Emergency Alert';
    }
  }

  String get icon {
    switch (this) {
      case NotificationType.medicationReminder:
        return '💊';
      case NotificationType.healthAlert:
        return '🏥';
      case NotificationType.appointmentReminder:
        return '📅';
      case NotificationType.taskReminder:
        return '✅';
      case NotificationType.careGroupUpdate:
        return '👥';
      case NotificationType.systemNotification:
        return '⚙️';
      case NotificationType.emergencyAlert:
        return '🚨';
    }
  }
}

extension NotificationPriorityExtension on NotificationPriority {
  String get displayName {
    switch (this) {
      case NotificationPriority.low:
        return 'Low';
      case NotificationPriority.normal:
        return 'Normal';
      case NotificationPriority.high:
        return 'High';
      case NotificationPriority.urgent:
        return 'Urgent';
    }
  }

  String get color {
    switch (this) {
      case NotificationPriority.low:
        return '#4CAF50'; // Green
      case NotificationPriority.normal:
        return '#2196F3'; // Blue
      case NotificationPriority.high:
        return '#FF9800'; // Orange
      case NotificationPriority.urgent:
        return '#F44336'; // Red
    }
  }
}

/// Main notification entity (matches backend structure)
@freezed
abstract class Notification with _$Notification {
  const factory Notification({
    required String id,
    required String userId,
    required String title,
    required String message,
    required NotificationType type,
    @Default(NotificationPriority.normal) NotificationPriority priority,
    @Default(NotificationChannel.inApp) NotificationChannel channel,
    @Default(NotificationStatus.pending) NotificationStatus status,
    required DateTime createdAt,
    DateTime? scheduledFor,
    DateTime? deliveredAt,
    DateTime? readAt,
    DateTime? expiresAt,
    Map<String, dynamic>? context,
    DateTime? updatedAt,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
}

/// Notification interaction tracking
@freezed
abstract class NotificationInteraction with _$NotificationInteraction {
  const factory NotificationInteraction({
    required String id,
    required String notificationId,
    required InteractionType interactionType,
    Map<String, dynamic>? interactionData,
    required DateTime createdAt,
  }) = _NotificationInteraction;

  factory NotificationInteraction.fromJson(Map<String, dynamic> json) =>
      _$NotificationInteractionFromJson(json);
}

/// Notification summary response
@freezed
abstract class NotificationSummary with _$NotificationSummary {
  const factory NotificationSummary({
    required int total,
    required int unread,
    required Map<String, int> byType,
    required Map<String, int> byPriority,
  }) = _NotificationSummary;

  factory NotificationSummary.fromJson(Map<String, dynamic> json) =>
      _$NotificationSummaryFromJson(json);
}


