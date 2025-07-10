// Care Group models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';

part 'care_group_models.freezed.dart';
part 'care_group_models.g.dart';

/// Member roles within a care group
enum MemberRole {
  @JsonValue('ADMIN')
  admin,
  @JsonValue('CAREGIVER')
  caregiver,
  @JsonValue('CARE_RECIPIENT')
  careRecipient,
  @JsonValue('OBSERVER')
  observer,
}

/// Task priority levels
enum TaskPriority {
  @JsonValue('LOW')
  low,
  @JsonValue('MEDIUM')
  medium,
  @JsonValue('HIGH')
  high,
  @JsonValue('URGENT')
  urgent,
}

/// Task status
enum TaskStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('IN_PROGRESS')
  inProgress,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('OVERDUE')
  overdue,
  @JsonValue('CANCELLED')
  cancelled,
}

/// Care group activity types
enum ActivityType {
  @JsonValue('GROUP_CREATED')
  groupCreated,
  @JsonValue('MEMBER_JOINED')
  memberJoined,
  @JsonValue('MEMBER_LEFT')
  memberLeft,
  @JsonValue('TASK_CREATED')
  taskCreated,
  @JsonValue('TASK_COMPLETED')
  taskCompleted,
  @JsonValue('HEALTH_DATA_SHARED')
  healthDataShared,
  @JsonValue('MEDICATION_UPDATED')
  medicationUpdated,
}

/// Care group settings
@freezed
abstract class CareGroupSettings with _$CareGroupSettings {
  const factory CareGroupSettings({
    @Default(true) bool allowHealthDataSharing,
    @Default(true) bool allowMedicationSharing,
    @Default(false) bool requireApprovalForNewMembers,
    @Default(true) bool enableTaskNotifications,
    @Default(true) bool enableActivityFeed,
    @Default('CAREGIVER') String defaultMemberRole,
    @Default(30) int inviteExpirationDays,
  }) = _CareGroupSettings;

  factory CareGroupSettings.fromJson(Map<String, dynamic> json) =>
      _$CareGroupSettingsFromJson(json);
}

/// Member notification preferences
@freezed
abstract class MemberNotificationPreferences
    with _$MemberNotificationPreferences {
  const factory MemberNotificationPreferences({
    @Default(true) bool taskAssignments,
    @Default(true) bool taskReminders,
    @Default(true) bool groupActivity,
    @Default(true) bool healthUpdates,
    @Default(true) bool medicationReminders,
    @Default(false) bool dailyDigest,
    @Default('IMMEDIATE') String urgentAlerts,
  }) = _MemberNotificationPreferences;

  factory MemberNotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$MemberNotificationPreferencesFromJson(json);
}

/// Care group member
@freezed
abstract class CareGroupMember with _$CareGroupMember {
  const factory CareGroupMember({
    required String id,
    required String groupId,
    required String userId,
    required String displayName,
    String? email,
    String? photoUrl,
    required MemberRole role,
    String? customTitle,
    required DateTime joinedAt,
    String? invitedBy,
    required bool isActive,
    DateTime? lastActive,
    @Default(MemberNotificationPreferences())
    MemberNotificationPreferences notificationPreferences,
  }) = _CareGroupMember;

  factory CareGroupMember.fromJson(Map<String, dynamic> json) =>
      _$CareGroupMemberFromJson(json);
}

/// Care recipient information
@freezed
abstract class CareRecipient with _$CareRecipient {
  const factory CareRecipient({
    required String id,
    required String groupId,
    required String userId,
    required String displayName,
    String? relationship,
    DateTime? dateOfBirth,
    String? medicalConditions,
    String? emergencyContact,
    String? primaryPhysician,
    String? insuranceInfo,
    @Default(true) bool allowHealthDataSharing,
    @Default(true) bool allowMedicationSharing,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CareRecipient;

  factory CareRecipient.fromJson(Map<String, dynamic> json) =>
      _$CareRecipientFromJson(json);
}

/// Care task
@freezed
abstract class CareTask with _$CareTask {
  const factory CareTask({
    required String id,
    required String groupId,
    required String title,
    String? description,
    required TaskPriority priority,
    required TaskStatus status,
    required String assignedTo,
    required String createdBy,
    String? careRecipientId,
    required DateTime createdAt,
    required DateTime dueDate,
    DateTime? completedAt,
    String? completionNotes,
    List<String>? attachments,
    @Default(false) bool isRecurring,
    String? recurrencePattern,
    DateTime? nextDueDate,
  }) = _CareTask;

  factory CareTask.fromJson(Map<String, dynamic> json) =>
      _$CareTaskFromJson(json);
}

/// Care group activity
@freezed
abstract class CareGroupActivity with _$CareGroupActivity {
  const factory CareGroupActivity({
    required String id,
    required String groupId,
    required ActivityType type,
    required String performedBy,
    String? performedByName,
    required String description,
    Map<String, dynamic>? metadata,
    required DateTime timestamp,
    @Default(false) bool isImportant,
  }) = _CareGroupActivity;

  factory CareGroupActivity.fromJson(Map<String, dynamic> json) =>
      _$CareGroupActivityFromJson(json);
}

/// Main care group entity
@freezed
abstract class CareGroup with _$CareGroup {
  const factory CareGroup({
    required String id,
    required String name,
    String? description,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<CareGroupMember> members,
    required List<CareRecipient> careRecipients,
    required bool isActive,
    @Default(CareGroupSettings()) CareGroupSettings settings,
    String? inviteCode,
    DateTime? inviteExpiration,
    @Default(0) int memberCount,
    @Default(0) int activeTaskCount,
  }) = _CareGroup;

  factory CareGroup.fromJson(Map<String, dynamic> json) =>
      _$CareGroupFromJson(json);
}

/// Request models for API calls
@freezed
abstract class CreateCareGroupRequest with _$CreateCareGroupRequest {
  const factory CreateCareGroupRequest({
    required String name,
    String? description,
    @Default(CareGroupSettings()) CareGroupSettings settings,
  }) = _CreateCareGroupRequest;

  factory CreateCareGroupRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCareGroupRequestFromJson(json);
}

@freezed
abstract class InviteMemberRequest with _$InviteMemberRequest {
  const factory InviteMemberRequest({
    required String email,
    required MemberRole role,
    String? customTitle,
    String? personalMessage,
  }) = _InviteMemberRequest;

  factory InviteMemberRequest.fromJson(Map<String, dynamic> json) =>
      _$InviteMemberRequestFromJson(json);
}

@freezed
abstract class CreateTaskRequest with _$CreateTaskRequest {
  const factory CreateTaskRequest({
    required String title,
    String? description,
    required TaskPriority priority,
    required String assignedTo,
    String? careRecipientId,
    required DateTime dueDate,
    @Default(false) bool isRecurring,
    String? recurrencePattern,
  }) = _CreateTaskRequest;

  factory CreateTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskRequestFromJson(json);
}

@freezed
abstract class UpdateTaskRequest with _$UpdateTaskRequest {
  const factory UpdateTaskRequest({
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    String? assignedTo,
    DateTime? dueDate,
    String? completionNotes,
  }) = _UpdateTaskRequest;

  factory UpdateTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskRequestFromJson(json);
}
