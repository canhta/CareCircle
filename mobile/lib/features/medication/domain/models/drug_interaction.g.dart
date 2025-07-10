// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drug_interaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InteractionAlert _$InteractionAlertFromJson(Map<String, dynamic> json) =>
    _InteractionAlert(
      id: json['id'] as String,
      type: $enumDecode(_$InteractionTypeEnumMap, json['type']),
      severity: $enumDecode(_$InteractionSeverityEnumMap, json['severity']),
      primaryMedication: json['primaryMedication'] as String,
      secondaryMedication: json['secondaryMedication'] as String?,
      interactingSubstance: json['interactingSubstance'] as String?,
      description: json['description'] as String,
      clinicalEffect: json['clinicalEffect'] as String,
      mechanism: json['mechanism'] as String?,
      recommendations:
          (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      alternatives:
          (json['alternatives'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      sourceReference: json['sourceReference'] as String?,
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$InteractionAlertToJson(_InteractionAlert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$InteractionTypeEnumMap[instance.type]!,
      'severity': _$InteractionSeverityEnumMap[instance.severity]!,
      'primaryMedication': instance.primaryMedication,
      'secondaryMedication': instance.secondaryMedication,
      'interactingSubstance': instance.interactingSubstance,
      'description': instance.description,
      'clinicalEffect': instance.clinicalEffect,
      'mechanism': instance.mechanism,
      'recommendations': instance.recommendations,
      'alternatives': instance.alternatives,
      'sourceReference': instance.sourceReference,
      'confidence': instance.confidence,
    };

const _$InteractionTypeEnumMap = {
  InteractionType.drugDrug: 'DRUG_DRUG',
  InteractionType.drugFood: 'DRUG_FOOD',
  InteractionType.drugCondition: 'DRUG_CONDITION',
  InteractionType.drugAllergy: 'DRUG_ALLERGY',
};

const _$InteractionSeverityEnumMap = {
  InteractionSeverity.minor: 'MINOR',
  InteractionSeverity.moderate: 'MODERATE',
  InteractionSeverity.major: 'MAJOR',
  InteractionSeverity.contraindicated: 'CONTRAINDICATED',
};

_InteractionAnalysis _$InteractionAnalysisFromJson(Map<String, dynamic> json) =>
    _InteractionAnalysis(
      userId: json['userId'] as String,
      analysisDate: DateTime.parse(json['analysisDate'] as String),
      medicationIds:
          (json['medicationIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      interactions:
          (json['interactions'] as List<dynamic>?)
              ?.map((e) => InteractionAlert.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      highestSeverity: $enumDecode(
        _$InteractionSeverityEnumMap,
        json['highestSeverity'],
      ),
      totalInteractions: (json['totalInteractions'] as num).toInt(),
      hasContraindications: json['hasContraindications'] as bool,
      generalRecommendations:
          (json['generalRecommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pharmacistNotes: json['pharmacistNotes'] as String?,
    );

Map<String, dynamic> _$InteractionAnalysisToJson(
  _InteractionAnalysis instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'analysisDate': instance.analysisDate.toIso8601String(),
  'medicationIds': instance.medicationIds,
  'interactions': instance.interactions,
  'highestSeverity': _$InteractionSeverityEnumMap[instance.highestSeverity]!,
  'totalInteractions': instance.totalInteractions,
  'hasContraindications': instance.hasContraindications,
  'generalRecommendations': instance.generalRecommendations,
  'pharmacistNotes': instance.pharmacistNotes,
};

_RxNormMedication _$RxNormMedicationFromJson(Map<String, dynamic> json) =>
    _RxNormMedication(
      rxcui: json['rxcui'] as String,
      name: json['name'] as String,
      genericName: json['genericName'] as String?,
      brandName: json['brandName'] as String?,
      strength: json['strength'] as String?,
      doseForm: json['doseForm'] as String?,
      route: json['route'] as String?,
      ingredients:
          (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      classification: json['classification'] as String?,
      isGeneric: json['isGeneric'] as bool?,
      synonyms:
          (json['synonyms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$RxNormMedicationToJson(_RxNormMedication instance) =>
    <String, dynamic>{
      'rxcui': instance.rxcui,
      'name': instance.name,
      'genericName': instance.genericName,
      'brandName': instance.brandName,
      'strength': instance.strength,
      'doseForm': instance.doseForm,
      'route': instance.route,
      'ingredients': instance.ingredients,
      'classification': instance.classification,
      'isGeneric': instance.isGeneric,
      'synonyms': instance.synonyms,
    };

_InteractionCheckRequest _$InteractionCheckRequestFromJson(
  Map<String, dynamic> json,
) => _InteractionCheckRequest(
  medicationIds:
      (json['medicationIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  rxNormCodes:
      (json['rxNormCodes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  medicationNames:
      (json['medicationNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  includeMinor: json['includeMinor'] as bool? ?? true,
  includeModerate: json['includeModerate'] as bool? ?? true,
  includeMajor: json['includeMajor'] as bool? ?? true,
  includeContraindicated: json['includeContraindicated'] as bool? ?? true,
  includeFood: json['includeFood'] as bool? ?? false,
  includeConditions: json['includeConditions'] as bool? ?? false,
);

Map<String, dynamic> _$InteractionCheckRequestToJson(
  _InteractionCheckRequest instance,
) => <String, dynamic>{
  'medicationIds': instance.medicationIds,
  'rxNormCodes': instance.rxNormCodes,
  'medicationNames': instance.medicationNames,
  'includeMinor': instance.includeMinor,
  'includeModerate': instance.includeModerate,
  'includeMajor': instance.includeMajor,
  'includeContraindicated': instance.includeContraindicated,
  'includeFood': instance.includeFood,
  'includeConditions': instance.includeConditions,
};

_RxNormSearchRequest _$RxNormSearchRequestFromJson(Map<String, dynamic> json) =>
    _RxNormSearchRequest(
      searchTerm: json['searchTerm'] as String,
      maxResults: (json['maxResults'] as num?)?.toInt() ?? 10,
      exactMatch: json['exactMatch'] as bool? ?? false,
      includeSynonyms: json['includeSynonyms'] as bool? ?? true,
      sources:
          (json['sources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$RxNormSearchRequestToJson(
  _RxNormSearchRequest instance,
) => <String, dynamic>{
  'searchTerm': instance.searchTerm,
  'maxResults': instance.maxResults,
  'exactMatch': instance.exactMatch,
  'includeSynonyms': instance.includeSynonyms,
  'sources': instance.sources,
};

_MedicationEnrichmentRequest _$MedicationEnrichmentRequestFromJson(
  Map<String, dynamic> json,
) => _MedicationEnrichmentRequest(
  medicationId: json['medicationId'] as String,
  medicationName: json['medicationName'] as String?,
  rxNormCode: json['rxNormCode'] as String?,
  updateClassification: json['updateClassification'] as bool? ?? true,
  updateIngredients: json['updateIngredients'] as bool? ?? true,
  updateInteractions: json['updateInteractions'] as bool? ?? true,
);

Map<String, dynamic> _$MedicationEnrichmentRequestToJson(
  _MedicationEnrichmentRequest instance,
) => <String, dynamic>{
  'medicationId': instance.medicationId,
  'medicationName': instance.medicationName,
  'rxNormCode': instance.rxNormCode,
  'updateClassification': instance.updateClassification,
  'updateIngredients': instance.updateIngredients,
  'updateInteractions': instance.updateInteractions,
};

_InteractionAnalysisResponse _$InteractionAnalysisResponseFromJson(
  Map<String, dynamic> json,
) => _InteractionAnalysisResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : InteractionAnalysis.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$InteractionAnalysisResponseToJson(
  _InteractionAnalysisResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
  'error': instance.error,
};

_RxNormSearchResponse _$RxNormSearchResponseFromJson(
  Map<String, dynamic> json,
) => _RxNormSearchResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => RxNormMedication.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  count: (json['count'] as num?)?.toInt(),
  message: json['message'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$RxNormSearchResponseToJson(
  _RxNormSearchResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'count': instance.count,
  'message': instance.message,
  'error': instance.error,
};

_MedicationEnrichmentResponse _$MedicationEnrichmentResponseFromJson(
  Map<String, dynamic> json,
) => _MedicationEnrichmentResponse(
  success: json['success'] as bool,
  enrichedData: json['enrichedData'] == null
      ? null
      : RxNormMedication.fromJson(json['enrichedData'] as Map<String, dynamic>),
  interactions:
      (json['interactions'] as List<dynamic>?)
          ?.map((e) => InteractionAlert.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  message: json['message'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$MedicationEnrichmentResponseToJson(
  _MedicationEnrichmentResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'enrichedData': instance.enrichedData,
  'interactions': instance.interactions,
  'message': instance.message,
  'error': instance.error,
};
