// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmergencyAlert _$EmergencyAlertFromJson(
  Map<String, dynamic> json,
) => _EmergencyAlert(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  alertType: $enumDecode(_$EmergencyAlertTypeEnumMap, json['alertType']),
  severity: $enumDecode(_$EmergencyAlertSeverityEnumMap, json['severity']),
  status:
      $enumDecodeNullable(_$EmergencyAlertStatusEnumMap, json['status']) ??
      EmergencyAlertStatus.active,
  createdAt: DateTime.parse(json['createdAt'] as String),
  acknowledgedAt: json['acknowledgedAt'] == null
      ? null
      : DateTime.parse(json['acknowledgedAt'] as String),
  resolvedAt: json['resolvedAt'] == null
      ? null
      : DateTime.parse(json['resolvedAt'] as String),
  acknowledgedBy: json['acknowledgedBy'] as String?,
  resolvedBy: json['resolvedBy'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  location: json['location'] as String?,
  attachments: (json['attachments'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  actions:
      (json['actions'] as List<dynamic>?)
          ?.map((e) => EmergencyAlertAction.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  escalations:
      (json['escalations'] as List<dynamic>?)
          ?.map((e) => EmergencyEscalation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$EmergencyAlertToJson(_EmergencyAlert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'message': instance.message,
      'alertType': _$EmergencyAlertTypeEnumMap[instance.alertType]!,
      'severity': _$EmergencyAlertSeverityEnumMap[instance.severity]!,
      'status': _$EmergencyAlertStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'acknowledgedAt': instance.acknowledgedAt?.toIso8601String(),
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'acknowledgedBy': instance.acknowledgedBy,
      'resolvedBy': instance.resolvedBy,
      'metadata': instance.metadata,
      'location': instance.location,
      'attachments': instance.attachments,
      'actions': instance.actions,
      'escalations': instance.escalations,
      'updatedAt': instance.updatedAt?.toIso8601String(),
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

const _$EmergencyAlertSeverityEnumMap = {
  EmergencyAlertSeverity.low: 'LOW',
  EmergencyAlertSeverity.medium: 'MEDIUM',
  EmergencyAlertSeverity.high: 'HIGH',
  EmergencyAlertSeverity.critical: 'CRITICAL',
};

const _$EmergencyAlertStatusEnumMap = {
  EmergencyAlertStatus.active: 'ACTIVE',
  EmergencyAlertStatus.acknowledged: 'ACKNOWLEDGED',
  EmergencyAlertStatus.resolved: 'RESOLVED',
  EmergencyAlertStatus.escalated: 'ESCALATED',
  EmergencyAlertStatus.cancelled: 'CANCELLED',
};

_EmergencyAlertAction _$EmergencyAlertActionFromJson(
  Map<String, dynamic> json,
) => _EmergencyAlertAction(
  id: json['id'] as String,
  label: json['label'] as String,
  actionType: json['actionType'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  url: json['url'] as String?,
  parameters: json['parameters'] as Map<String, dynamic>?,
  isPrimary: json['isPrimary'] as bool? ?? false,
  isDestructive: json['isDestructive'] as bool? ?? false,
);

Map<String, dynamic> _$EmergencyAlertActionToJson(
  _EmergencyAlertAction instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'actionType': instance.actionType,
  'phoneNumber': instance.phoneNumber,
  'url': instance.url,
  'parameters': instance.parameters,
  'isPrimary': instance.isPrimary,
  'isDestructive': instance.isDestructive,
};

_EmergencyEscalation _$EmergencyEscalationFromJson(Map<String, dynamic> json) =>
    _EmergencyEscalation(
      id: json['id'] as String,
      alertId: json['alertId'] as String,
      contactId: json['contactId'] as String,
      contactName: json['contactName'] as String,
      contactPhone: json['contactPhone'] as String,
      contactEmail: json['contactEmail'] as String?,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      sentAt: json['sentAt'] == null
          ? null
          : DateTime.parse(json['sentAt'] as String),
      acknowledgedAt: json['acknowledgedAt'] == null
          ? null
          : DateTime.parse(json['acknowledgedAt'] as String),
      status: json['status'] as String? ?? 'pending',
      failureReason: json['failureReason'] as String?,
      attemptNumber: (json['attemptNumber'] as num?)?.toInt() ?? 1,
      priority: (json['priority'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$EmergencyEscalationToJson(
  _EmergencyEscalation instance,
) => <String, dynamic>{
  'id': instance.id,
  'alertId': instance.alertId,
  'contactId': instance.contactId,
  'contactName': instance.contactName,
  'contactPhone': instance.contactPhone,
  'contactEmail': instance.contactEmail,
  'scheduledAt': instance.scheduledAt.toIso8601String(),
  'sentAt': instance.sentAt?.toIso8601String(),
  'acknowledgedAt': instance.acknowledgedAt?.toIso8601String(),
  'status': instance.status,
  'failureReason': instance.failureReason,
  'attemptNumber': instance.attemptNumber,
  'priority': instance.priority,
};

_CreateEmergencyAlertRequest _$CreateEmergencyAlertRequestFromJson(
  Map<String, dynamic> json,
) => _CreateEmergencyAlertRequest(
  title: json['title'] as String,
  message: json['message'] as String,
  alertType: $enumDecode(_$EmergencyAlertTypeEnumMap, json['alertType']),
  severity:
      $enumDecodeNullable(_$EmergencyAlertSeverityEnumMap, json['severity']) ??
      EmergencyAlertSeverity.high,
  metadata: json['metadata'] as Map<String, dynamic>?,
  location: json['location'] as String?,
  attachments: (json['attachments'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  autoEscalate: json['autoEscalate'] as bool? ?? true,
  escalationDelayMinutes:
      (json['escalationDelayMinutes'] as num?)?.toInt() ?? 5,
);

Map<String, dynamic> _$CreateEmergencyAlertRequestToJson(
  _CreateEmergencyAlertRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'message': instance.message,
  'alertType': _$EmergencyAlertTypeEnumMap[instance.alertType]!,
  'severity': _$EmergencyAlertSeverityEnumMap[instance.severity]!,
  'metadata': instance.metadata,
  'location': instance.location,
  'attachments': instance.attachments,
  'autoEscalate': instance.autoEscalate,
  'escalationDelayMinutes': instance.escalationDelayMinutes,
};

_EmergencyAlertActionRequest _$EmergencyAlertActionRequestFromJson(
  Map<String, dynamic> json,
) => _EmergencyAlertActionRequest(
  alertId: json['alertId'] as String,
  actionType: json['actionType'] as String,
  parameters: json['parameters'] as Map<String, dynamic>?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$EmergencyAlertActionRequestToJson(
  _EmergencyAlertActionRequest instance,
) => <String, dynamic>{
  'alertId': instance.alertId,
  'actionType': instance.actionType,
  'parameters': instance.parameters,
  'notes': instance.notes,
};

_EmergencyAlertResponse _$EmergencyAlertResponseFromJson(
  Map<String, dynamic> json,
) => _EmergencyAlertResponse(
  success: json['success'] as bool,
  data: EmergencyAlert.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$EmergencyAlertResponseToJson(
  _EmergencyAlertResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

_EmergencyAlertListResponse _$EmergencyAlertListResponseFromJson(
  Map<String, dynamic> json,
) => _EmergencyAlertListResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => EmergencyAlert.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$EmergencyAlertListResponseToJson(
  _EmergencyAlertListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};
