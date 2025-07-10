// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_group_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CareGroupSettings _$CareGroupSettingsFromJson(Map<String, dynamic> json) =>
    _CareGroupSettings(
      allowHealthDataSharing: json['allowHealthDataSharing'] as bool? ?? true,
      allowMedicationSharing: json['allowMedicationSharing'] as bool? ?? true,
      requireApprovalForNewMembers:
          json['requireApprovalForNewMembers'] as bool? ?? false,
      enableTaskNotifications: json['enableTaskNotifications'] as bool? ?? true,
      enableActivityFeed: json['enableActivityFeed'] as bool? ?? true,
      defaultMemberRole: json['defaultMemberRole'] as String? ?? 'CAREGIVER',
      inviteExpirationDays:
          (json['inviteExpirationDays'] as num?)?.toInt() ?? 30,
    );

Map<String, dynamic> _$CareGroupSettingsToJson(_CareGroupSettings instance) =>
    <String, dynamic>{
      'allowHealthDataSharing': instance.allowHealthDataSharing,
      'allowMedicationSharing': instance.allowMedicationSharing,
      'requireApprovalForNewMembers': instance.requireApprovalForNewMembers,
      'enableTaskNotifications': instance.enableTaskNotifications,
      'enableActivityFeed': instance.enableActivityFeed,
      'defaultMemberRole': instance.defaultMemberRole,
      'inviteExpirationDays': instance.inviteExpirationDays,
    };

_MemberNotificationPreferences _$MemberNotificationPreferencesFromJson(
  Map<String, dynamic> json,
) => _MemberNotificationPreferences(
  taskAssignments: json['taskAssignments'] as bool? ?? true,
  taskReminders: json['taskReminders'] as bool? ?? true,
  groupActivity: json['groupActivity'] as bool? ?? true,
  healthUpdates: json['healthUpdates'] as bool? ?? true,
  medicationReminders: json['medicationReminders'] as bool? ?? true,
  dailyDigest: json['dailyDigest'] as bool? ?? false,
  urgentAlerts: json['urgentAlerts'] as String? ?? 'IMMEDIATE',
);

Map<String, dynamic> _$MemberNotificationPreferencesToJson(
  _MemberNotificationPreferences instance,
) => <String, dynamic>{
  'taskAssignments': instance.taskAssignments,
  'taskReminders': instance.taskReminders,
  'groupActivity': instance.groupActivity,
  'healthUpdates': instance.healthUpdates,
  'medicationReminders': instance.medicationReminders,
  'dailyDigest': instance.dailyDigest,
  'urgentAlerts': instance.urgentAlerts,
};

_CareGroupMember _$CareGroupMemberFromJson(Map<String, dynamic> json) =>
    _CareGroupMember(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      role: $enumDecode(_$MemberRoleEnumMap, json['role']),
      customTitle: json['customTitle'] as String?,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      invitedBy: json['invitedBy'] as String?,
      isActive: json['isActive'] as bool,
      lastActive: json['lastActive'] == null
          ? null
          : DateTime.parse(json['lastActive'] as String),
      notificationPreferences: json['notificationPreferences'] == null
          ? const MemberNotificationPreferences()
          : MemberNotificationPreferences.fromJson(
              json['notificationPreferences'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$CareGroupMemberToJson(_CareGroupMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'userId': instance.userId,
      'displayName': instance.displayName,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
      'role': _$MemberRoleEnumMap[instance.role]!,
      'customTitle': instance.customTitle,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'invitedBy': instance.invitedBy,
      'isActive': instance.isActive,
      'lastActive': instance.lastActive?.toIso8601String(),
      'notificationPreferences': instance.notificationPreferences,
    };

const _$MemberRoleEnumMap = {
  MemberRole.admin: 'ADMIN',
  MemberRole.caregiver: 'CAREGIVER',
  MemberRole.careRecipient: 'CARE_RECIPIENT',
  MemberRole.observer: 'OBSERVER',
};

_CareRecipient _$CareRecipientFromJson(Map<String, dynamic> json) =>
    _CareRecipient(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      relationship: json['relationship'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      medicalConditions: json['medicalConditions'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      primaryPhysician: json['primaryPhysician'] as String?,
      insuranceInfo: json['insuranceInfo'] as String?,
      allowHealthDataSharing: json['allowHealthDataSharing'] as bool? ?? true,
      allowMedicationSharing: json['allowMedicationSharing'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CareRecipientToJson(_CareRecipient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'userId': instance.userId,
      'displayName': instance.displayName,
      'relationship': instance.relationship,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'medicalConditions': instance.medicalConditions,
      'emergencyContact': instance.emergencyContact,
      'primaryPhysician': instance.primaryPhysician,
      'insuranceInfo': instance.insuranceInfo,
      'allowHealthDataSharing': instance.allowHealthDataSharing,
      'allowMedicationSharing': instance.allowMedicationSharing,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_CareTask _$CareTaskFromJson(Map<String, dynamic> json) => _CareTask(
  id: json['id'] as String,
  groupId: json['groupId'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  status: $enumDecode(_$TaskStatusEnumMap, json['status']),
  assignedTo: json['assignedTo'] as String,
  createdBy: json['createdBy'] as String,
  careRecipientId: json['careRecipientId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  dueDate: DateTime.parse(json['dueDate'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  completionNotes: json['completionNotes'] as String?,
  attachments: (json['attachments'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  isRecurring: json['isRecurring'] as bool? ?? false,
  recurrencePattern: json['recurrencePattern'] as String?,
  nextDueDate: json['nextDueDate'] == null
      ? null
      : DateTime.parse(json['nextDueDate'] as String),
);

Map<String, dynamic> _$CareTaskToJson(_CareTask instance) => <String, dynamic>{
  'id': instance.id,
  'groupId': instance.groupId,
  'title': instance.title,
  'description': instance.description,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'status': _$TaskStatusEnumMap[instance.status]!,
  'assignedTo': instance.assignedTo,
  'createdBy': instance.createdBy,
  'careRecipientId': instance.careRecipientId,
  'createdAt': instance.createdAt.toIso8601String(),
  'dueDate': instance.dueDate.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'completionNotes': instance.completionNotes,
  'attachments': instance.attachments,
  'isRecurring': instance.isRecurring,
  'recurrencePattern': instance.recurrencePattern,
  'nextDueDate': instance.nextDueDate?.toIso8601String(),
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'LOW',
  TaskPriority.medium: 'MEDIUM',
  TaskPriority.high: 'HIGH',
  TaskPriority.urgent: 'URGENT',
};

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'PENDING',
  TaskStatus.inProgress: 'IN_PROGRESS',
  TaskStatus.completed: 'COMPLETED',
  TaskStatus.overdue: 'OVERDUE',
  TaskStatus.cancelled: 'CANCELLED',
};

_CareGroupActivity _$CareGroupActivityFromJson(Map<String, dynamic> json) =>
    _CareGroupActivity(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      performedBy: json['performedBy'] as String,
      performedByName: json['performedByName'] as String?,
      description: json['description'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isImportant: json['isImportant'] as bool? ?? false,
    );

Map<String, dynamic> _$CareGroupActivityToJson(_CareGroupActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'performedBy': instance.performedBy,
      'performedByName': instance.performedByName,
      'description': instance.description,
      'metadata': instance.metadata,
      'timestamp': instance.timestamp.toIso8601String(),
      'isImportant': instance.isImportant,
    };

const _$ActivityTypeEnumMap = {
  ActivityType.groupCreated: 'GROUP_CREATED',
  ActivityType.memberJoined: 'MEMBER_JOINED',
  ActivityType.memberLeft: 'MEMBER_LEFT',
  ActivityType.taskCreated: 'TASK_CREATED',
  ActivityType.taskCompleted: 'TASK_COMPLETED',
  ActivityType.healthDataShared: 'HEALTH_DATA_SHARED',
  ActivityType.medicationUpdated: 'MEDICATION_UPDATED',
};

_CareGroup _$CareGroupFromJson(Map<String, dynamic> json) => _CareGroup(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  createdBy: json['createdBy'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  members: (json['members'] as List<dynamic>)
      .map((e) => CareGroupMember.fromJson(e as Map<String, dynamic>))
      .toList(),
  careRecipients: (json['careRecipients'] as List<dynamic>)
      .map((e) => CareRecipient.fromJson(e as Map<String, dynamic>))
      .toList(),
  isActive: json['isActive'] as bool,
  settings: json['settings'] == null
      ? const CareGroupSettings()
      : CareGroupSettings.fromJson(json['settings'] as Map<String, dynamic>),
  inviteCode: json['inviteCode'] as String?,
  inviteExpiration: json['inviteExpiration'] == null
      ? null
      : DateTime.parse(json['inviteExpiration'] as String),
  memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
  activeTaskCount: (json['activeTaskCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CareGroupToJson(_CareGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'members': instance.members,
      'careRecipients': instance.careRecipients,
      'isActive': instance.isActive,
      'settings': instance.settings,
      'inviteCode': instance.inviteCode,
      'inviteExpiration': instance.inviteExpiration?.toIso8601String(),
      'memberCount': instance.memberCount,
      'activeTaskCount': instance.activeTaskCount,
    };

_CreateCareGroupRequest _$CreateCareGroupRequestFromJson(
  Map<String, dynamic> json,
) => _CreateCareGroupRequest(
  name: json['name'] as String,
  description: json['description'] as String?,
  settings: json['settings'] == null
      ? const CareGroupSettings()
      : CareGroupSettings.fromJson(json['settings'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreateCareGroupRequestToJson(
  _CreateCareGroupRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'settings': instance.settings,
};

_InviteMemberRequest _$InviteMemberRequestFromJson(Map<String, dynamic> json) =>
    _InviteMemberRequest(
      email: json['email'] as String,
      role: $enumDecode(_$MemberRoleEnumMap, json['role']),
      customTitle: json['customTitle'] as String?,
      personalMessage: json['personalMessage'] as String?,
    );

Map<String, dynamic> _$InviteMemberRequestToJson(
  _InviteMemberRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'role': _$MemberRoleEnumMap[instance.role]!,
  'customTitle': instance.customTitle,
  'personalMessage': instance.personalMessage,
};

_CreateTaskRequest _$CreateTaskRequestFromJson(Map<String, dynamic> json) =>
    _CreateTaskRequest(
      title: json['title'] as String,
      description: json['description'] as String?,
      priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
      assignedTo: json['assignedTo'] as String,
      careRecipientId: json['careRecipientId'] as String?,
      dueDate: DateTime.parse(json['dueDate'] as String),
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurrencePattern: json['recurrencePattern'] as String?,
    );

Map<String, dynamic> _$CreateTaskRequestToJson(_CreateTaskRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'assignedTo': instance.assignedTo,
      'careRecipientId': instance.careRecipientId,
      'dueDate': instance.dueDate.toIso8601String(),
      'isRecurring': instance.isRecurring,
      'recurrencePattern': instance.recurrencePattern,
    };

_UpdateTaskRequest _$UpdateTaskRequestFromJson(Map<String, dynamic> json) =>
    _UpdateTaskRequest(
      title: json['title'] as String?,
      description: json['description'] as String?,
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
      status: $enumDecodeNullable(_$TaskStatusEnumMap, json['status']),
      assignedTo: json['assignedTo'] as String?,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      completionNotes: json['completionNotes'] as String?,
    );

Map<String, dynamic> _$UpdateTaskRequestToJson(_UpdateTaskRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'priority': _$TaskPriorityEnumMap[instance.priority],
      'status': _$TaskStatusEnumMap[instance.status],
      'assignedTo': instance.assignedTo,
      'dueDate': instance.dueDate?.toIso8601String(),
      'completionNotes': instance.completionNotes,
    };
