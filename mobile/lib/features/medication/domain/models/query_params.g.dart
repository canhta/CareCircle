// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrescriptionQueryParams _$PrescriptionQueryParamsFromJson(
  Map<String, dynamic> json,
) => _PrescriptionQueryParams(
  isVerified: json['isVerified'] as bool?,
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  limit: (json['limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
);

Map<String, dynamic> _$PrescriptionQueryParamsToJson(
  _PrescriptionQueryParams instance,
) => <String, dynamic>{
  'isVerified': instance.isVerified,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'limit': instance.limit,
  'offset': instance.offset,
};

_ScheduleQueryParams _$ScheduleQueryParamsFromJson(Map<String, dynamic> json) =>
    _ScheduleQueryParams(
      medicationId: json['medicationId'] as String?,
      isActive: json['isActive'] as bool?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      limit: (json['limit'] as num?)?.toInt(),
      offset: (json['offset'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ScheduleQueryParamsToJson(
  _ScheduleQueryParams instance,
) => <String, dynamic>{
  'medicationId': instance.medicationId,
  'isActive': instance.isActive,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'limit': instance.limit,
  'offset': instance.offset,
};

_AdherenceQueryParams _$AdherenceQueryParamsFromJson(
  Map<String, dynamic> json,
) => _AdherenceQueryParams(
  medicationId: json['medicationId'] as String?,
  scheduleId: json['scheduleId'] as String?,
  status: $enumDecodeNullable(_$DoseStatusEnumMap, json['status']),
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  limit: (json['limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
);

Map<String, dynamic> _$AdherenceQueryParamsToJson(
  _AdherenceQueryParams instance,
) => <String, dynamic>{
  'medicationId': instance.medicationId,
  'scheduleId': instance.scheduleId,
  'status': _$DoseStatusEnumMap[instance.status],
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'limit': instance.limit,
  'offset': instance.offset,
};

const _$DoseStatusEnumMap = {
  DoseStatus.scheduled: 'SCHEDULED',
  DoseStatus.taken: 'TAKEN',
  DoseStatus.missed: 'MISSED',
  DoseStatus.skipped: 'SKIPPED',
  DoseStatus.late: 'LATE',
};

_MedicationQueryParams _$MedicationQueryParamsFromJson(
  Map<String, dynamic> json,
) => _MedicationQueryParams(
  searchTerm: json['searchTerm'] as String?,
  isActive: json['isActive'] as bool?,
  form: $enumDecodeNullable(_$MedicationFormEnumMap, json['form']),
  classification: json['classification'] as String?,
  startDateFrom: json['startDateFrom'] == null
      ? null
      : DateTime.parse(json['startDateFrom'] as String),
  startDateTo: json['startDateTo'] == null
      ? null
      : DateTime.parse(json['startDateTo'] as String),
  endDateFrom: json['endDateFrom'] == null
      ? null
      : DateTime.parse(json['endDateFrom'] as String),
  endDateTo: json['endDateTo'] == null
      ? null
      : DateTime.parse(json['endDateTo'] as String),
  prescriptionId: json['prescriptionId'] as String?,
  limit: (json['limit'] as num?)?.toInt() ?? 50,
  offset: (json['offset'] as num?)?.toInt() ?? 0,
  sortBy: json['sortBy'] as String? ?? 'name',
  sortOrder: json['sortOrder'] as String? ?? 'asc',
);

Map<String, dynamic> _$MedicationQueryParamsToJson(
  _MedicationQueryParams instance,
) => <String, dynamic>{
  'searchTerm': instance.searchTerm,
  'isActive': instance.isActive,
  'form': _$MedicationFormEnumMap[instance.form],
  'classification': instance.classification,
  'startDateFrom': instance.startDateFrom?.toIso8601String(),
  'startDateTo': instance.startDateTo?.toIso8601String(),
  'endDateFrom': instance.endDateFrom?.toIso8601String(),
  'endDateTo': instance.endDateTo?.toIso8601String(),
  'prescriptionId': instance.prescriptionId,
  'limit': instance.limit,
  'offset': instance.offset,
  'sortBy': instance.sortBy,
  'sortOrder': instance.sortOrder,
};

const _$MedicationFormEnumMap = {
  MedicationForm.tablet: 'TABLET',
  MedicationForm.capsule: 'CAPSULE',
  MedicationForm.liquid: 'LIQUID',
  MedicationForm.injection: 'INJECTION',
  MedicationForm.patch: 'PATCH',
  MedicationForm.inhaler: 'INHALER',
  MedicationForm.cream: 'CREAM',
  MedicationForm.drops: 'DROPS',
  MedicationForm.suppository: 'SUPPOSITORY',
  MedicationForm.other: 'OTHER',
};

_InteractionQueryParams _$InteractionQueryParamsFromJson(
  Map<String, dynamic> json,
) => _InteractionQueryParams(
  medicationId: json['medicationId'] as String?,
  severity: json['severity'] as String?,
  isActive: json['isActive'] as bool?,
  limit: (json['limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
);

Map<String, dynamic> _$InteractionQueryParamsToJson(
  _InteractionQueryParams instance,
) => <String, dynamic>{
  'medicationId': instance.medicationId,
  'severity': instance.severity,
  'isActive': instance.isActive,
  'limit': instance.limit,
  'offset': instance.offset,
};

_InventoryQueryParams _$InventoryQueryParamsFromJson(
  Map<String, dynamic> json,
) => _InventoryQueryParams(
  medicationId: json['medicationId'] as String?,
  isLowStock: json['isLowStock'] as bool?,
  isExpired: json['isExpired'] as bool?,
  expirationBefore: json['expirationBefore'] == null
      ? null
      : DateTime.parse(json['expirationBefore'] as String),
  expirationAfter: json['expirationAfter'] == null
      ? null
      : DateTime.parse(json['expirationAfter'] as String),
  limit: (json['limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
);

Map<String, dynamic> _$InventoryQueryParamsToJson(
  _InventoryQueryParams instance,
) => <String, dynamic>{
  'medicationId': instance.medicationId,
  'isLowStock': instance.isLowStock,
  'isExpired': instance.isExpired,
  'expirationBefore': instance.expirationBefore?.toIso8601String(),
  'expirationAfter': instance.expirationAfter?.toIso8601String(),
  'limit': instance.limit,
  'offset': instance.offset,
};

_ProcessingQueryParams _$ProcessingQueryParamsFromJson(
  Map<String, dynamic> json,
) => _ProcessingQueryParams(
  status: json['status'] as String?,
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  limit: (json['limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
);

Map<String, dynamic> _$ProcessingQueryParamsToJson(
  _ProcessingQueryParams instance,
) => <String, dynamic>{
  'status': instance.status,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'limit': instance.limit,
  'offset': instance.offset,
};
