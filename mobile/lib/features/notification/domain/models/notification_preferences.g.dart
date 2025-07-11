// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPreference _$NotificationPreferenceFromJson(
  Map<String, dynamic> json,
) => _NotificationPreference(
  id: json['id'] as String,
  userId: json['userId'] as String,
  contextType: $enumDecode(_$ContextTypeEnumMap, json['contextType']),
  channel: $enumDecode(_$NotificationChannelEnumMap, json['channel']),
  frequency:
      $enumDecodeNullable(_$NotificationFrequencyEnumMap, json['frequency']) ??
      NotificationFrequency.immediately,
  enabled: json['enabled'] as bool? ?? true,
  quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
  quietHoursStart: json['quietHoursStart'] == null
      ? null
      : DateTime.parse(json['quietHoursStart'] as String),
  quietHoursEnd: json['quietHoursEnd'] == null
      ? null
      : DateTime.parse(json['quietHoursEnd'] as String),
  settings: json['settings'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$NotificationPreferenceToJson(
  _NotificationPreference instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'contextType': _$ContextTypeEnumMap[instance.contextType]!,
  'channel': _$NotificationChannelEnumMap[instance.channel]!,
  'frequency': _$NotificationFrequencyEnumMap[instance.frequency]!,
  'enabled': instance.enabled,
  'quietHoursEnabled': instance.quietHoursEnabled,
  'quietHoursStart': instance.quietHoursStart?.toIso8601String(),
  'quietHoursEnd': instance.quietHoursEnd?.toIso8601String(),
  'settings': instance.settings,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$ContextTypeEnumMap = {
  ContextType.medication: 'MEDICATION',
  ContextType.healthData: 'HEALTH_DATA',
  ContextType.careGroup: 'CARE_GROUP',
  ContextType.appointment: 'APPOINTMENT',
  ContextType.system: 'SYSTEM',
  ContextType.emergency: 'EMERGENCY',
};

const _$NotificationChannelEnumMap = {
  NotificationChannel.push: 'PUSH',
  NotificationChannel.sms: 'SMS',
  NotificationChannel.email: 'EMAIL',
  NotificationChannel.inApp: 'IN_APP',
};

const _$NotificationFrequencyEnumMap = {
  NotificationFrequency.immediately: 'IMMEDIATELY',
  NotificationFrequency.batchedHourly: 'BATCHED_HOURLY',
  NotificationFrequency.batchedDaily: 'BATCHED_DAILY',
  NotificationFrequency.digest: 'DIGEST',
};

_NotificationPreferences _$NotificationPreferencesFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferences(
  userId: json['userId'] as String,
  globalEnabled: json['globalEnabled'] as bool? ?? true,
  doNotDisturbEnabled: json['doNotDisturbEnabled'] as bool? ?? false,
  doNotDisturbStart: json['doNotDisturbStart'] == null
      ? null
      : DateTime.parse(json['doNotDisturbStart'] as String),
  doNotDisturbEnd: json['doNotDisturbEnd'] == null
      ? null
      : DateTime.parse(json['doNotDisturbEnd'] as String),
  preferences:
      (json['preferences'] as List<dynamic>?)
          ?.map(
            (e) => NotificationPreference.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  emergencySettings: json['emergencySettings'] == null
      ? const EmergencyAlertSettings()
      : EmergencyAlertSettings.fromJson(
          json['emergencySettings'] as Map<String, dynamic>,
        ),
  quietHours: json['quietHours'] == null
      ? const QuietHoursSettings()
      : QuietHoursSettings.fromJson(json['quietHours'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$NotificationPreferencesToJson(
  _NotificationPreferences instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'globalEnabled': instance.globalEnabled,
  'doNotDisturbEnabled': instance.doNotDisturbEnabled,
  'doNotDisturbStart': instance.doNotDisturbStart?.toIso8601String(),
  'doNotDisturbEnd': instance.doNotDisturbEnd?.toIso8601String(),
  'preferences': instance.preferences,
  'emergencySettings': instance.emergencySettings,
  'quietHours': instance.quietHours,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_EmergencyAlertSettings _$EmergencyAlertSettingsFromJson(
  Map<String, dynamic> json,
) => _EmergencyAlertSettings(
  enabled: json['enabled'] as bool? ?? true,
  overrideQuietHours: json['overrideQuietHours'] as bool? ?? true,
  soundEnabled: json['soundEnabled'] as bool? ?? true,
  vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
  fullScreenAlert: json['fullScreenAlert'] as bool? ?? true,
  emergencyContacts:
      (json['emergencyContacts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  escalationDelayMinutes:
      (json['escalationDelayMinutes'] as num?)?.toInt() ?? 5,
  autoEscalate: json['autoEscalate'] as bool? ?? true,
);

Map<String, dynamic> _$EmergencyAlertSettingsToJson(
  _EmergencyAlertSettings instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'overrideQuietHours': instance.overrideQuietHours,
  'soundEnabled': instance.soundEnabled,
  'vibrationEnabled': instance.vibrationEnabled,
  'fullScreenAlert': instance.fullScreenAlert,
  'emergencyContacts': instance.emergencyContacts,
  'escalationDelayMinutes': instance.escalationDelayMinutes,
  'autoEscalate': instance.autoEscalate,
};

_QuietHoursSettings _$QuietHoursSettingsFromJson(Map<String, dynamic> json) =>
    _QuietHoursSettings(
      enabled: json['enabled'] as bool? ?? false,
      startTime: json['startTime'] as String? ?? '22:00',
      endTime: json['endTime'] as String? ?? '08:00',
      activeDays:
          (json['activeDays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      allowedTypes:
          (json['allowedTypes'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$NotificationTypeEnumMap, e))
              .toList() ??
          const [],
      allowEmergencyAlerts: json['allowEmergencyAlerts'] as bool? ?? true,
    );

Map<String, dynamic> _$QuietHoursSettingsToJson(_QuietHoursSettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'activeDays': instance.activeDays,
      'allowedTypes': instance.allowedTypes
          .map((e) => _$NotificationTypeEnumMap[e]!)
          .toList(),
      'allowEmergencyAlerts': instance.allowEmergencyAlerts,
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

_EmergencyContact _$EmergencyContactFromJson(Map<String, dynamic> json) =>
    _EmergencyContact(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      relationship: json['relationship'] as String,
      isPrimary: json['isPrimary'] as bool? ?? true,
      notifyBySms: json['notifyBySms'] as bool? ?? true,
      notifyByEmail: json['notifyByEmail'] as bool? ?? false,
      priority: (json['priority'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$EmergencyContactToJson(_EmergencyContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'relationship': instance.relationship,
      'isPrimary': instance.isPrimary,
      'notifyBySms': instance.notifyBySms,
      'notifyByEmail': instance.notifyByEmail,
      'priority': instance.priority,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_UpdateNotificationPreferencesRequest
_$UpdateNotificationPreferencesRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateNotificationPreferencesRequest(
  globalEnabled: json['globalEnabled'] as bool?,
  doNotDisturbEnabled: json['doNotDisturbEnabled'] as bool?,
  doNotDisturbStart: json['doNotDisturbStart'] == null
      ? null
      : DateTime.parse(json['doNotDisturbStart'] as String),
  doNotDisturbEnd: json['doNotDisturbEnd'] == null
      ? null
      : DateTime.parse(json['doNotDisturbEnd'] as String),
  preferences: (json['preferences'] as List<dynamic>?)
      ?.map((e) => NotificationPreference.fromJson(e as Map<String, dynamic>))
      .toList(),
  emergencySettings: json['emergencySettings'] == null
      ? null
      : EmergencyAlertSettings.fromJson(
          json['emergencySettings'] as Map<String, dynamic>,
        ),
  quietHours: json['quietHours'] == null
      ? null
      : QuietHoursSettings.fromJson(json['quietHours'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateNotificationPreferencesRequestToJson(
  _UpdateNotificationPreferencesRequest instance,
) => <String, dynamic>{
  'globalEnabled': instance.globalEnabled,
  'doNotDisturbEnabled': instance.doNotDisturbEnabled,
  'doNotDisturbStart': instance.doNotDisturbStart?.toIso8601String(),
  'doNotDisturbEnd': instance.doNotDisturbEnd?.toIso8601String(),
  'preferences': instance.preferences,
  'emergencySettings': instance.emergencySettings,
  'quietHours': instance.quietHours,
};

_UpdatePreferenceRequest _$UpdatePreferenceRequestFromJson(
  Map<String, dynamic> json,
) => _UpdatePreferenceRequest(
  contextType: $enumDecode(_$ContextTypeEnumMap, json['contextType']),
  channel: $enumDecode(_$NotificationChannelEnumMap, json['channel']),
  enabled: json['enabled'] as bool?,
  frequency: $enumDecodeNullable(
    _$NotificationFrequencyEnumMap,
    json['frequency'],
  ),
  quietHoursEnabled: json['quietHoursEnabled'] as bool?,
  quietHoursStart: json['quietHoursStart'] == null
      ? null
      : DateTime.parse(json['quietHoursStart'] as String),
  quietHoursEnd: json['quietHoursEnd'] == null
      ? null
      : DateTime.parse(json['quietHoursEnd'] as String),
  settings: json['settings'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UpdatePreferenceRequestToJson(
  _UpdatePreferenceRequest instance,
) => <String, dynamic>{
  'contextType': _$ContextTypeEnumMap[instance.contextType]!,
  'channel': _$NotificationChannelEnumMap[instance.channel]!,
  'enabled': instance.enabled,
  'frequency': _$NotificationFrequencyEnumMap[instance.frequency],
  'quietHoursEnabled': instance.quietHoursEnabled,
  'quietHoursStart': instance.quietHoursStart?.toIso8601String(),
  'quietHoursEnd': instance.quietHoursEnd?.toIso8601String(),
  'settings': instance.settings,
};

_NotificationPreferencesResponse _$NotificationPreferencesResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferencesResponse(
  success: json['success'] as bool,
  data: NotificationPreferences.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$NotificationPreferencesResponseToJson(
  _NotificationPreferencesResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

_EmergencyContactResponse _$EmergencyContactResponseFromJson(
  Map<String, dynamic> json,
) => _EmergencyContactResponse(
  success: json['success'] as bool,
  data: EmergencyContact.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$EmergencyContactResponseToJson(
  _EmergencyContactResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

_EmergencyContactListResponse _$EmergencyContactListResponseFromJson(
  Map<String, dynamic> json,
) => _EmergencyContactListResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$EmergencyContactListResponseToJson(
  _EmergencyContactListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};
