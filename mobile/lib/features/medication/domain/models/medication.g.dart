// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Medication _$MedicationFromJson(Map<String, dynamic> json) => _Medication(
  id: json['id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String,
  genericName: json['genericName'] as String?,
  strength: json['strength'] as String,
  form: $enumDecode(_$MedicationFormEnumMap, json['form']),
  manufacturer: json['manufacturer'] as String?,
  rxNormCode: json['rxNormCode'] as String?,
  ndcCode: json['ndcCode'] as String?,
  classification: json['classification'] as String?,
  category:
      $enumDecodeNullable(_$MedicationCategoryEnumMap, json['category']) ??
      MedicationCategory.other,
  isActive: json['isActive'] as bool? ?? true,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  prescriptionId: json['prescriptionId'] as String?,
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$MedicationToJson(_Medication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'genericName': instance.genericName,
      'strength': instance.strength,
      'form': _$MedicationFormEnumMap[instance.form]!,
      'manufacturer': instance.manufacturer,
      'rxNormCode': instance.rxNormCode,
      'ndcCode': instance.ndcCode,
      'classification': instance.classification,
      'category': _$MedicationCategoryEnumMap[instance.category]!,
      'isActive': instance.isActive,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'prescriptionId': instance.prescriptionId,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$MedicationFormEnumMap = {
  MedicationForm.tablet: 'TABLET',
  MedicationForm.capsule: 'CAPSULE',
  MedicationForm.liquid: 'LIQUID',
  MedicationForm.injection: 'INJECTION',
  MedicationForm.patch: 'PATCH',
  MedicationForm.inhaler: 'INHALER',
  MedicationForm.cream: 'CREAM',
  MedicationForm.ointment: 'OINTMENT',
  MedicationForm.drops: 'DROPS',
  MedicationForm.suppository: 'SUPPOSITORY',
  MedicationForm.other: 'OTHER',
};

const _$MedicationCategoryEnumMap = {
  MedicationCategory.cardiovascular: 'CARDIOVASCULAR',
  MedicationCategory.diabetes: 'DIABETES',
  MedicationCategory.painRelief: 'PAIN_RELIEF',
  MedicationCategory.antibiotics: 'ANTIBIOTICS',
  MedicationCategory.mentalHealth: 'MENTAL_HEALTH',
  MedicationCategory.respiratory: 'RESPIRATORY',
  MedicationCategory.gastrointestinal: 'GASTROINTESTINAL',
  MedicationCategory.vitaminsSupplements: 'VITAMINS_SUPPLEMENTS',
  MedicationCategory.other: 'OTHER',
};

_CreateMedicationRequest _$CreateMedicationRequestFromJson(
  Map<String, dynamic> json,
) => _CreateMedicationRequest(
  name: json['name'] as String,
  genericName: json['genericName'] as String?,
  strength: json['strength'] as String,
  form: $enumDecode(_$MedicationFormEnumMap, json['form']),
  manufacturer: json['manufacturer'] as String?,
  rxNormCode: json['rxNormCode'] as String?,
  ndcCode: json['ndcCode'] as String?,
  classification: json['classification'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  prescriptionId: json['prescriptionId'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$CreateMedicationRequestToJson(
  _CreateMedicationRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'genericName': instance.genericName,
  'strength': instance.strength,
  'form': _$MedicationFormEnumMap[instance.form]!,
  'manufacturer': instance.manufacturer,
  'rxNormCode': instance.rxNormCode,
  'ndcCode': instance.ndcCode,
  'classification': instance.classification,
  'isActive': instance.isActive,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'prescriptionId': instance.prescriptionId,
  'notes': instance.notes,
};

_UpdateMedicationRequest _$UpdateMedicationRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateMedicationRequest(
  name: json['name'] as String?,
  genericName: json['genericName'] as String?,
  strength: json['strength'] as String?,
  form: $enumDecodeNullable(_$MedicationFormEnumMap, json['form']),
  manufacturer: json['manufacturer'] as String?,
  rxNormCode: json['rxNormCode'] as String?,
  ndcCode: json['ndcCode'] as String?,
  classification: json['classification'] as String?,
  isActive: json['isActive'] as bool?,
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  prescriptionId: json['prescriptionId'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$UpdateMedicationRequestToJson(
  _UpdateMedicationRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'genericName': instance.genericName,
  'strength': instance.strength,
  'form': _$MedicationFormEnumMap[instance.form],
  'manufacturer': instance.manufacturer,
  'rxNormCode': instance.rxNormCode,
  'ndcCode': instance.ndcCode,
  'classification': instance.classification,
  'isActive': instance.isActive,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'prescriptionId': instance.prescriptionId,
  'notes': instance.notes,
};

_MedicationStatistics _$MedicationStatisticsFromJson(
  Map<String, dynamic> json,
) => _MedicationStatistics(
  totalMedications: (json['totalMedications'] as num).toInt(),
  activeMedications: (json['activeMedications'] as num).toInt(),
  inactiveMedications: (json['inactiveMedications'] as num).toInt(),
  expiringSoon: (json['expiringSoon'] as num).toInt(),
  medicationsByForm: (json['medicationsByForm'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry($enumDecode(_$MedicationFormEnumMap, k), (e as num).toInt()),
  ),
  medicationsByClassification: Map<String, int>.from(
    json['medicationsByClassification'] as Map,
  ),
  averageAdherence: (json['averageAdherence'] as num).toDouble(),
  totalDoses: (json['totalDoses'] as num).toInt(),
  missedDoses: (json['missedDoses'] as num).toInt(),
);

Map<String, dynamic> _$MedicationStatisticsToJson(
  _MedicationStatistics instance,
) => <String, dynamic>{
  'totalMedications': instance.totalMedications,
  'activeMedications': instance.activeMedications,
  'inactiveMedications': instance.inactiveMedications,
  'expiringSoon': instance.expiringSoon,
  'medicationsByForm': instance.medicationsByForm.map(
    (k, e) => MapEntry(_$MedicationFormEnumMap[k]!, e),
  ),
  'medicationsByClassification': instance.medicationsByClassification,
  'averageAdherence': instance.averageAdherence,
  'totalDoses': instance.totalDoses,
  'missedDoses': instance.missedDoses,
};

_MedicationResponse _$MedicationResponseFromJson(Map<String, dynamic> json) =>
    _MedicationResponse(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : Medication.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$MedicationResponseToJson(_MedicationResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
      'error': instance.error,
    };

_MedicationListResponse _$MedicationListResponseFromJson(
  Map<String, dynamic> json,
) => _MedicationListResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => Medication.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  count: (json['count'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  message: json['message'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$MedicationListResponseToJson(
  _MedicationListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'count': instance.count,
  'total': instance.total,
  'message': instance.message,
  'error': instance.error,
};
