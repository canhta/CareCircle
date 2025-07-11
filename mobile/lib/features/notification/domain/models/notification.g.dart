// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Notification _$NotificationFromJson(Map<String, dynamic> json) =>
    _Notification(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      priority:
          $enumDecodeNullable(
            _$NotificationPriorityEnumMap,
            json['priority'],
          ) ??
          NotificationPriority.normal,
      channel:
          $enumDecodeNullable(_$NotificationChannelEnumMap, json['channel']) ??
          NotificationChannel.inApp,
      status:
          $enumDecodeNullable(_$NotificationStatusEnumMap, json['status']) ??
          NotificationStatus.pending,
      createdAt: DateTime.parse(json['createdAt'] as String),
      scheduledFor: json['scheduledFor'] == null
          ? null
          : DateTime.parse(json['scheduledFor'] as String),
      deliveredAt: json['deliveredAt'] == null
          ? null
          : DateTime.parse(json['deliveredAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      context: json['context'] as Map<String, dynamic>?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$NotificationToJson(_Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'message': instance.message,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'priority': _$NotificationPriorityEnumMap[instance.priority]!,
      'channel': _$NotificationChannelEnumMap[instance.channel]!,
      'status': _$NotificationStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'scheduledFor': instance.scheduledFor?.toIso8601String(),
      'deliveredAt': instance.deliveredAt?.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'context': instance.context,
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

const _$NotificationStatusEnumMap = {
  NotificationStatus.pending: 'PENDING',
  NotificationStatus.sent: 'SENT',
  NotificationStatus.delivered: 'DELIVERED',
  NotificationStatus.read: 'READ',
  NotificationStatus.failed: 'FAILED',
  NotificationStatus.expired: 'EXPIRED',
};

_NotificationInteraction _$NotificationInteractionFromJson(
  Map<String, dynamic> json,
) => _NotificationInteraction(
  id: json['id'] as String,
  notificationId: json['notificationId'] as String,
  interactionType: $enumDecode(
    _$InteractionTypeEnumMap,
    json['interactionType'],
  ),
  interactionData: json['interactionData'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$NotificationInteractionToJson(
  _NotificationInteraction instance,
) => <String, dynamic>{
  'id': instance.id,
  'notificationId': instance.notificationId,
  'interactionType': _$InteractionTypeEnumMap[instance.interactionType]!,
  'interactionData': instance.interactionData,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$InteractionTypeEnumMap = {
  InteractionType.opened: 'OPENED',
  InteractionType.dismissed: 'DISMISSED',
  InteractionType.actionClicked: 'ACTION_CLICKED',
  InteractionType.snoozed: 'SNOOZED',
};

_CreateNotificationRequest _$CreateNotificationRequestFromJson(
  Map<String, dynamic> json,
) => _CreateNotificationRequest(
  title: json['title'] as String,
  message: json['message'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  priority:
      $enumDecodeNullable(_$NotificationPriorityEnumMap, json['priority']) ??
      NotificationPriority.normal,
  channel:
      $enumDecodeNullable(_$NotificationChannelEnumMap, json['channel']) ??
      NotificationChannel.inApp,
  scheduledFor: json['scheduledFor'] == null
      ? null
      : DateTime.parse(json['scheduledFor'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  context: json['context'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$CreateNotificationRequestToJson(
  _CreateNotificationRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'message': instance.message,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'priority': _$NotificationPriorityEnumMap[instance.priority]!,
  'channel': _$NotificationChannelEnumMap[instance.channel]!,
  'scheduledFor': instance.scheduledFor?.toIso8601String(),
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'context': instance.context,
};

_NotificationSummary _$NotificationSummaryFromJson(Map<String, dynamic> json) =>
    _NotificationSummary(
      total: (json['total'] as num).toInt(),
      unread: (json['unread'] as num).toInt(),
      byType: Map<String, int>.from(json['byType'] as Map),
      byPriority: Map<String, int>.from(json['byPriority'] as Map),
    );

Map<String, dynamic> _$NotificationSummaryToJson(
  _NotificationSummary instance,
) => <String, dynamic>{
  'total': instance.total,
  'unread': instance.unread,
  'byType': instance.byType,
  'byPriority': instance.byPriority,
};

_NotificationResponse _$NotificationResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationResponse(
  success: json['success'] as bool,
  data: Notification.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$NotificationResponseToJson(
  _NotificationResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

_NotificationListResponse _$NotificationListResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationListResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => Notification.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$NotificationListResponseToJson(
  _NotificationListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

_NotificationSummaryResponse _$NotificationSummaryResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationSummaryResponse(
  success: json['success'] as bool,
  data: NotificationSummary.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$NotificationSummaryResponseToJson(
  _NotificationSummaryResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};
