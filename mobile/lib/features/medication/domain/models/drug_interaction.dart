// Drug interaction models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drug_interaction.freezed.dart';
part 'drug_interaction.g.dart';

/// Interaction severity levels
enum InteractionSeverity {
  @JsonValue('MINOR')
  minor,
  @JsonValue('MODERATE')
  moderate,
  @JsonValue('MAJOR')
  major,
  @JsonValue('CONTRAINDICATED')
  contraindicated,
}

/// Interaction types
enum InteractionType {
  @JsonValue('DRUG_DRUG')
  drugDrug,
  @JsonValue('DRUG_FOOD')
  drugFood,
  @JsonValue('DRUG_CONDITION')
  drugCondition,
  @JsonValue('DRUG_ALLERGY')
  drugAllergy,
}

/// Extensions for enum display names and colors
extension InteractionSeverityExtension on InteractionSeverity {
  String get displayName {
    switch (this) {
      case InteractionSeverity.minor:
        return 'Minor';
      case InteractionSeverity.moderate:
        return 'Moderate';
      case InteractionSeverity.major:
        return 'Major';
      case InteractionSeverity.contraindicated:
        return 'Contraindicated';
    }
  }

  String get colorHex {
    switch (this) {
      case InteractionSeverity.minor:
        return '#4CAF50'; // Green
      case InteractionSeverity.moderate:
        return '#FF9800'; // Orange
      case InteractionSeverity.major:
        return '#FF5722'; // Deep Orange
      case InteractionSeverity.contraindicated:
        return '#F44336'; // Red
    }
  }

  String get icon {
    switch (this) {
      case InteractionSeverity.minor:
        return '⚠️';
      case InteractionSeverity.moderate:
        return '⚠️';
      case InteractionSeverity.major:
        return '🚨';
      case InteractionSeverity.contraindicated:
        return '🛑';
    }
  }

  int get priority {
    switch (this) {
      case InteractionSeverity.minor:
        return 1;
      case InteractionSeverity.moderate:
        return 2;
      case InteractionSeverity.major:
        return 3;
      case InteractionSeverity.contraindicated:
        return 4;
    }
  }
}

extension InteractionTypeExtension on InteractionType {
  String get displayName {
    switch (this) {
      case InteractionType.drugDrug:
        return 'Drug-Drug Interaction';
      case InteractionType.drugFood:
        return 'Drug-Food Interaction';
      case InteractionType.drugCondition:
        return 'Drug-Condition Interaction';
      case InteractionType.drugAllergy:
        return 'Drug-Allergy Interaction';
    }
  }
}

/// Individual interaction alert
@freezed
abstract class InteractionAlert with _$InteractionAlert {
  const factory InteractionAlert({
    required String id,
    required InteractionType type,
    required InteractionSeverity severity,
    required String primaryMedication,
    String? secondaryMedication,
    String? interactingSubstance,
    required String description,
    required String clinicalEffect,
    String? mechanism,
    @Default([]) List<String> recommendations,
    @Default([]) List<String> alternatives,
    String? sourceReference,
    required double confidence,
  }) = _InteractionAlert;

  factory InteractionAlert.fromJson(Map<String, dynamic> json) =>
      _$InteractionAlertFromJson(json);
}

/// Comprehensive interaction analysis result
@freezed
abstract class InteractionAnalysis with _$InteractionAnalysis {
  const factory InteractionAnalysis({
    required String userId,
    required DateTime analysisDate,
    @Default([]) List<String> medicationIds,
    @Default([]) List<InteractionAlert> interactions,
    required InteractionSeverity highestSeverity,
    required int totalInteractions,
    required bool hasContraindications,
    @Default([]) List<String> generalRecommendations,
    String? pharmacistNotes,
  }) = _InteractionAnalysis;

  factory InteractionAnalysis.fromJson(Map<String, dynamic> json) =>
      _$InteractionAnalysisFromJson(json);
}

/// RxNorm medication data
@freezed
abstract class RxNormMedication with _$RxNormMedication {
  const factory RxNormMedication({
    required String rxcui,
    required String name,
    String? genericName,
    String? brandName,
    String? strength,
    String? doseForm,
    String? route,
    @Default([]) List<String> ingredients,
    String? classification,
    bool? isGeneric,
    @Default([]) List<String> synonyms,
  }) = _RxNormMedication;

  factory RxNormMedication.fromJson(Map<String, dynamic> json) =>
      _$RxNormMedicationFromJson(json);
}

/// Drug interaction check request DTO
@freezed
abstract class InteractionCheckRequest with _$InteractionCheckRequest {
  const factory InteractionCheckRequest({
    @Default([]) List<String> medicationIds,
    @Default([]) List<String> rxNormCodes,
    @Default([]) List<String> medicationNames,
    @Default(true) bool includeMinor,
    @Default(true) bool includeModerate,
    @Default(true) bool includeMajor,
    @Default(true) bool includeContraindicated,
    @Default(false) bool includeFood,
    @Default(false) bool includeConditions,
  }) = _InteractionCheckRequest;

  factory InteractionCheckRequest.fromJson(Map<String, dynamic> json) =>
      _$InteractionCheckRequestFromJson(json);
}

/// RxNorm search request DTO
@freezed
abstract class RxNormSearchRequest with _$RxNormSearchRequest {
  const factory RxNormSearchRequest({
    required String searchTerm,
    @Default(10) int maxResults,
    @Default(false) bool exactMatch,
    @Default(true) bool includeSynonyms,
    @Default([]) List<String> sources,
  }) = _RxNormSearchRequest;

  factory RxNormSearchRequest.fromJson(Map<String, dynamic> json) =>
      _$RxNormSearchRequestFromJson(json);
}

/// Medication enrichment request DTO
@freezed
abstract class MedicationEnrichmentRequest with _$MedicationEnrichmentRequest {
  const factory MedicationEnrichmentRequest({
    required String medicationId,
    String? medicationName,
    String? rxNormCode,
    @Default(true) bool updateClassification,
    @Default(true) bool updateIngredients,
    @Default(true) bool updateInteractions,
  }) = _MedicationEnrichmentRequest;

  factory MedicationEnrichmentRequest.fromJson(Map<String, dynamic> json) =>
      _$MedicationEnrichmentRequestFromJson(json);
}

/// API response wrapper for interaction analysis
@freezed
abstract class InteractionAnalysisResponse with _$InteractionAnalysisResponse {
  const factory InteractionAnalysisResponse({
    required bool success,
    InteractionAnalysis? data,
    String? message,
    String? error,
  }) = _InteractionAnalysisResponse;

  factory InteractionAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$InteractionAnalysisResponseFromJson(json);
}

/// API response wrapper for RxNorm search
@freezed
abstract class RxNormSearchResponse with _$RxNormSearchResponse {
  const factory RxNormSearchResponse({
    required bool success,
    @Default([]) List<RxNormMedication> data,
    int? count,
    String? message,
    String? error,
  }) = _RxNormSearchResponse;

  factory RxNormSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$RxNormSearchResponseFromJson(json);
}

/// API response wrapper for medication enrichment
@freezed
abstract class MedicationEnrichmentResponse with _$MedicationEnrichmentResponse {
  const factory MedicationEnrichmentResponse({
    required bool success,
    RxNormMedication? enrichedData,
    @Default([]) List<InteractionAlert> interactions,
    String? message,
    String? error,
  }) = _MedicationEnrichmentResponse;

  factory MedicationEnrichmentResponse.fromJson(Map<String, dynamic> json) =>
      _$MedicationEnrichmentResponseFromJson(json);
}
