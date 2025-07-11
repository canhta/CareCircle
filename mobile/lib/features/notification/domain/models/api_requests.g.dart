// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateNotificationRequest _$CreateNotificationRequestFromJson(
  Map<String, dynamic> json,
) => _CreateNotificationRequest(
  title: json['title'] as String,
  message: json['message'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  priority: $enumDecode(_$NotificationPriorityEnumMap, json['priority']),
  channel: $enumDecode(_$NotificationChannelEnumMap, json['channel']),
  userId: json['userId'] as String?,
  data: json['data'] as Map<String, dynamic>?,
  scheduledAt: json['scheduledAt'] == null
      ? null
      : DateTime.parse(json['scheduledAt'] as String),
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$CreateNotificationRequestToJson(
  _CreateNotificationRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'message': instance.message,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'priority': _$NotificationPriorityEnumMap[instance.priority]!,
  'channel': _$NotificationChannelEnumMap[instance.channel]!,
  'userId': instance.userId,
  'data': instance.data,
  'scheduledAt': instance.scheduledAt?.toIso8601String(),
  'tags': instance.tags,
};

const _$NotificationTypeEnumMap = {
  NotificationType.medicationReminder: 'MEDICATION_REMINDER',
  NotificationType.healthAlert: 'HEALTH_ALERT',
  NotificationType.appointmentReminder: 'APPOINTMENT_REMINDER',
  NotificationType.taskReminder: 'TASK_REMINDER',
  NotificationType.careGroupUpdate: 'CARE_GROUP_UPDATE',
  NotificationType.systemNotification: 'SYSTEM_NOTIFICATION',
  NotificationType.emergencyAlert: 'EMERGENCY_ALERT',
};

const _$NotificationPriorityEnumMap = {
  NotificationPriority.low: 'LOW',
  NotificationPriority.normal: 'NORMAL',
  NotificationPriority.high: 'HIGH',
  NotificationPriority.urgent: 'URGENT',
};

const _$NotificationChannelEnumMap = {
  NotificationChannel.push: 'PUSH',
  NotificationChannel.sms: 'SMS',
  NotificationChannel.email: 'EMAIL',
  NotificationChannel.inApp: 'IN_APP',
};

_UpdateNotificationPreferencesRequest
_$UpdateNotificationPreferencesRequestFromJson(Map<String, dynamic> json) =>
    _UpdateNotificationPreferencesRequest(
      globalEnabled: json['globalEnabled'] as bool?,
      quietHours: json['quietHours'] == null
          ? null
          : QuietHoursSettings.fromJson(
              json['quietHours'] as Map<String, dynamic>,
            ),
      emergencySettings: json['emergencySettings'] == null
          ? null
          : EmergencyAlertSettings.fromJson(
              json['emergencySettings'] as Map<String, dynamic>,
            ),
      channelPreferences: (json['channelPreferences'] as Map<String, dynamic>?)
          ?.map((k, e) => MapEntry(k, e as bool)),
      typePreferences: (json['typePreferences'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ),
      contextPreferences: (json['contextPreferences'] as Map<String, dynamic>?)
          ?.map((k, e) => MapEntry(k, e as bool)),
    );

Map<String, dynamic> _$UpdateNotificationPreferencesRequestToJson(
  _UpdateNotificationPreferencesRequest instance,
) => <String, dynamic>{
  'globalEnabled': instance.globalEnabled,
  'quietHours': instance.quietHours,
  'emergencySettings': instance.emergencySettings,
  'channelPreferences': instance.channelPreferences,
  'typePreferences': instance.typePreferences,
  'contextPreferences': instance.contextPreferences,
};

_UpdatePreferenceRequest _$UpdatePreferenceRequestFromJson(
  Map<String, dynamic> json,
) => _UpdatePreferenceRequest(
  enabled: json['enabled'] as bool,
  settings: json['settings'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UpdatePreferenceRequestToJson(
  _UpdatePreferenceRequest instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'settings': instance.settings,
};

_CreateEmergencyAlertRequest _$CreateEmergencyAlertRequestFromJson(
  Map<String, dynamic> json,
) => _CreateEmergencyAlertRequest(
  title: json['title'] as String,
  message: json['message'] as String,
  severity: $enumDecode(_$EmergencyAlertSeverityEnumMap, json['severity']),
  alertType: $enumDecode(_$EmergencyAlertTypeEnumMap, json['alertType']),
  userId: json['userId'] as String?,
  careGroupId: json['careGroupId'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  affectedUsers: (json['affectedUsers'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  requiresAcknowledgment: json['requiresAcknowledgment'] as bool?,
  escalationTimeoutMinutes: (json['escalationTimeoutMinutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$CreateEmergencyAlertRequestToJson(
  _CreateEmergencyAlertRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'message': instance.message,
  'severity': _$EmergencyAlertSeverityEnumMap[instance.severity]!,
  'alertType': _$EmergencyAlertTypeEnumMap[instance.alertType]!,
  'userId': instance.userId,
  'careGroupId': instance.careGroupId,
  'metadata': instance.metadata,
  'affectedUsers': instance.affectedUsers,
  'requiresAcknowledgment': instance.requiresAcknowledgment,
  'escalationTimeoutMinutes': instance.escalationTimeoutMinutes,
};

const _$EmergencyAlertSeverityEnumMap = {
  EmergencyAlertSeverity.low: 'LOW',
  EmergencyAlertSeverity.medium: 'MEDIUM',
  EmergencyAlertSeverity.high: 'HIGH',
  EmergencyAlertSeverity.critical: 'CRITICAL',
};

const _$EmergencyAlertTypeEnumMap = {
  EmergencyAlertType.medicalEmergency: 'MEDICAL_EMERGENCY',
  EmergencyAlertType.medicationOverdose: 'MEDICATION_OVERDOSE',
  EmergencyAlertType.fallDetection: 'FALL_DETECTION',
  EmergencyAlertType.vitalSignsCritical: 'VITAL_SIGNS_CRITICAL',
  EmergencyAlertType.missedCriticalMedication: 'MISSED_CRITICAL_MEDICATION',
  EmergencyAlertType.panicButton: 'PANIC_BUTTON',
  EmergencyAlertType.deviceMalfunction: 'DEVICE_MALFUNCTION',
  EmergencyAlertType.locationAlert: 'LOCATION_ALERT',
  EmergencyAlertType.caregiverAlert: 'CAREGIVER_ALERT',
  EmergencyAlertType.systemAlert: 'SYSTEM_ALERT',
};

_EmergencyAlertActionRequest _$EmergencyAlertActionRequestFromJson(
  Map<String, dynamic> json,
) => _EmergencyAlertActionRequest(
  actionType: json['actionType'] as String,
  notes: json['notes'] as String?,
  actionData: json['actionData'] as Map<String, dynamic>?,
  performedBy: json['performedBy'] as String?,
);

Map<String, dynamic> _$EmergencyAlertActionRequestToJson(
  _EmergencyAlertActionRequest instance,
) => <String, dynamic>{
  'actionType': instance.actionType,
  'notes': instance.notes,
  'actionData': instance.actionData,
  'performedBy': instance.performedBy,
};

_CreateTemplateRequest _$CreateTemplateRequestFromJson(
  Map<String, dynamic> json,
) => _CreateTemplateRequest(
  name: json['name'] as String,
  subject: json['subject'] as String,
  content: json['content'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  channel: $enumDecode(_$NotificationChannelEnumMap, json['channel']),
  description: json['description'] as String?,
  variables: (json['variables'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  isActive: json['isActive'] as bool?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$CreateTemplateRequestToJson(
  _CreateTemplateRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'subject': instance.subject,
  'content': instance.content,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'channel': _$NotificationChannelEnumMap[instance.channel]!,
  'description': instance.description,
  'variables': instance.variables,
  'isActive': instance.isActive,
  'metadata': instance.metadata,
};

_UpdateTemplateRequest _$UpdateTemplateRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateTemplateRequest(
  name: json['name'] as String?,
  subject: json['subject'] as String?,
  content: json['content'] as String?,
  description: json['description'] as String?,
  variables: (json['variables'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  isActive: json['isActive'] as bool?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UpdateTemplateRequestToJson(
  _UpdateTemplateRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'subject': instance.subject,
  'content': instance.content,
  'description': instance.description,
  'variables': instance.variables,
  'isActive': instance.isActive,
  'metadata': instance.metadata,
};

_RenderTemplateRequest _$RenderTemplateRequestFromJson(
  Map<String, dynamic> json,
) => _RenderTemplateRequest(
  variables: json['variables'] as Map<String, dynamic>,
  locale: json['locale'] as String?,
  context: json['context'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$RenderTemplateRequestToJson(
  _RenderTemplateRequest instance,
) => <String, dynamic>{
  'variables': instance.variables,
  'locale': instance.locale,
  'context': instance.context,
};
