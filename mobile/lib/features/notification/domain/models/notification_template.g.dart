// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationTemplate _$NotificationTemplateFromJson(
  Map<String, dynamic> json,
) => _NotificationTemplate(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  channel: $enumDecode(_$NotificationChannelEnumMap, json['channel']),
  titleTemplate: json['titleTemplate'] as String,
  messageTemplate: json['messageTemplate'] as String,
  defaultContext: json['defaultContext'] as Map<String, dynamic>?,
  isActive: json['isActive'] as bool? ?? true,
  description: json['description'] as String?,
  requiredVariables: (json['requiredVariables'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  variableDescriptions: (json['variableDescriptions'] as Map<String, dynamic>?)
      ?.map((k, e) => MapEntry(k, e as String)),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$NotificationTemplateToJson(
  _NotificationTemplate instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'channel': _$NotificationChannelEnumMap[instance.channel]!,
  'titleTemplate': instance.titleTemplate,
  'messageTemplate': instance.messageTemplate,
  'defaultContext': instance.defaultContext,
  'isActive': instance.isActive,
  'description': instance.description,
  'requiredVariables': instance.requiredVariables,
  'variableDescriptions': instance.variableDescriptions,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
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

const _$NotificationChannelEnumMap = {
  NotificationChannel.push: 'PUSH',
  NotificationChannel.sms: 'SMS',
  NotificationChannel.email: 'EMAIL',
  NotificationChannel.inApp: 'IN_APP',
};

_TemplateVariable _$TemplateVariableFromJson(Map<String, dynamic> json) =>
    _TemplateVariable(
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      required: json['required'] as bool? ?? true,
      defaultValue: json['defaultValue'] as String?,
      allowedValues: (json['allowedValues'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      format: json['format'] as String?,
    );

Map<String, dynamic> _$TemplateVariableToJson(_TemplateVariable instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'required': instance.required,
      'defaultValue': instance.defaultValue,
      'allowedValues': instance.allowedValues,
      'format': instance.format,
    };
