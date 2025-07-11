// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationResponse _$NotificationResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : Notification.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'] as Map<String, dynamic>?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$NotificationResponseToJson(
  _NotificationResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'timestamp': instance.timestamp?.toIso8601String(),
};

_NotificationListResponse _$NotificationListResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationListResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => Notification.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  errors: json['errors'] as Map<String, dynamic>?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
  pagination: json['pagination'] == null
      ? null
      : PaginationMeta.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationListResponseToJson(
  _NotificationListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'timestamp': instance.timestamp?.toIso8601String(),
  'pagination': instance.pagination,
};

_NotificationSummaryResponse _$NotificationSummaryResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationSummaryResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : NotificationSummary.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'] as Map<String, dynamic>?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$NotificationSummaryResponseToJson(
  _NotificationSummaryResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'timestamp': instance.timestamp?.toIso8601String(),
};

_NotificationPreferencesResponse _$NotificationPreferencesResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferencesResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : NotificationPreferences.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'] as Map<String, dynamic>?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$NotificationPreferencesResponseToJson(
  _NotificationPreferencesResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'timestamp': instance.timestamp?.toIso8601String(),
};

_EmergencyAlertResponse _$EmergencyAlertResponseFromJson(
  Map<String, dynamic> json,
) => _EmergencyAlertResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : EmergencyAlert.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'] as Map<String, dynamic>?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$EmergencyAlertResponseToJson(
  _EmergencyAlertResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'timestamp': instance.timestamp?.toIso8601String(),
};

_EmergencyAlertListResponse _$EmergencyAlertListResponseFromJson(
  Map<String, dynamic> json,
) => _EmergencyAlertListResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => EmergencyAlert.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  errors: json['errors'] as Map<String, dynamic>?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
  pagination: json['pagination'] == null
      ? null
      : PaginationMeta.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EmergencyAlertListResponseToJson(
  _EmergencyAlertListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'timestamp': instance.timestamp?.toIso8601String(),
  'pagination': instance.pagination,
};

_EmergencyContactResponse _$EmergencyContactResponseFromJson(
  Map<String, dynamic> json,
) => _EmergencyContactResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : EmergencyContact.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'] as Map<String, dynamic>?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$EmergencyContactResponseToJson(
  _EmergencyContactResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'timestamp': instance.timestamp?.toIso8601String(),
};

_EmergencyContactListResponse _$EmergencyContactListResponseFromJson(
  Map<String, dynamic> json,
) => _EmergencyContactListResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  errors: json['errors'] as Map<String, dynamic>?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
  pagination: json['pagination'] == null
      ? null
      : PaginationMeta.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EmergencyContactListResponseToJson(
  _EmergencyContactListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'timestamp': instance.timestamp?.toIso8601String(),
  'pagination': instance.pagination,
};

_NotificationTemplateResponse _$NotificationTemplateResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationTemplateResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : NotificationTemplate.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'] as Map<String, dynamic>?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$NotificationTemplateResponseToJson(
  _NotificationTemplateResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'timestamp': instance.timestamp?.toIso8601String(),
};

_NotificationTemplateListResponse _$NotificationTemplateListResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationTemplateListResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => NotificationTemplate.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  errors: json['errors'] as Map<String, dynamic>?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
  pagination: json['pagination'] == null
      ? null
      : PaginationMeta.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationTemplateListResponseToJson(
  _NotificationTemplateListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'timestamp': instance.timestamp?.toIso8601String(),
  'pagination': instance.pagination,
};

_RenderedTemplateResponse _$RenderedTemplateResponseFromJson(
  Map<String, dynamic> json,
) => _RenderedTemplateResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : RenderedTemplate.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'] as Map<String, dynamic>?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$RenderedTemplateResponseToJson(
  _RenderedTemplateResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'timestamp': instance.timestamp?.toIso8601String(),
};

_PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    _PaginationMeta(
      currentPage: (json['currentPage'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      totalItems: (json['totalItems'] as num).toInt(),
      itemsPerPage: (json['itemsPerPage'] as num).toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
    );

Map<String, dynamic> _$PaginationMetaToJson(_PaginationMeta instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'totalItems': instance.totalItems,
      'itemsPerPage': instance.itemsPerPage,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
    };

_RenderedTemplate _$RenderedTemplateFromJson(Map<String, dynamic> json) =>
    _RenderedTemplate(
      templateId: json['templateId'] as String,
      renderedContent: json['renderedContent'] as String,
      subject: json['subject'] as String,
      variables: json['variables'] as Map<String, dynamic>?,
      renderedAt: json['rendered_at'] == null
          ? null
          : DateTime.parse(json['rendered_at'] as String),
    );

Map<String, dynamic> _$RenderedTemplateToJson(_RenderedTemplate instance) =>
    <String, dynamic>{
      'templateId': instance.templateId,
      'renderedContent': instance.renderedContent,
      'subject': instance.subject,
      'variables': instance.variables,
      'rendered_at': instance.renderedAt?.toIso8601String(),
    };
