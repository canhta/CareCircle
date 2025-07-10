// Medication models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication.freezed.dart';
part 'medication.g.dart';

/// Medication form types (matches backend Prisma enum)
enum MedicationForm {
  @JsonValue('TABLET')
  tablet,
  @JsonValue('CAPSULE')
  capsule,
  @JsonValue('LIQUID')
  liquid,
  @JsonValue('INJECTION')
  injection,
  @JsonValue('PATCH')
  patch,
  @JsonValue('INHALER')
  inhaler,
  @JsonValue('CREAM')
  cream,
  @JsonValue('DROPS')
  drops,
  @JsonValue('SUPPOSITORY')
  suppository,
  @JsonValue('OTHER')
  other,
}

/// Extension for MedicationForm display names
extension MedicationFormExtension on MedicationForm {
  String get displayName {
    switch (this) {
      case MedicationForm.tablet:
        return 'Tablet';
      case MedicationForm.capsule:
        return 'Capsule';
      case MedicationForm.liquid:
        return 'Liquid';
      case MedicationForm.injection:
        return 'Injection';
      case MedicationForm.patch:
        return 'Patch';
      case MedicationForm.inhaler:
        return 'Inhaler';
      case MedicationForm.cream:
        return 'Cream';
      case MedicationForm.drops:
        return 'Drops';
      case MedicationForm.suppository:
        return 'Suppository';
      case MedicationForm.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case MedicationForm.tablet:
        return '💊';
      case MedicationForm.capsule:
        return '💊';
      case MedicationForm.liquid:
        return '🧴';
      case MedicationForm.injection:
        return '💉';
      case MedicationForm.patch:
        return '🩹';
      case MedicationForm.inhaler:
        return '🫁';
      case MedicationForm.cream:
        return '🧴';
      case MedicationForm.drops:
        return '💧';
      case MedicationForm.suppository:
        return '💊';
      case MedicationForm.other:
        return '💊';
    }
  }
}

/// Main medication entity
@freezed
abstract class Medication with _$Medication {
  const factory Medication({
    required String id,
    required String userId,
    required String name,
    String? genericName,
    required String strength,
    required MedicationForm form,
    String? manufacturer,
    String? rxNormCode,
    String? ndcCode,
    String? classification,
    @Default(true) bool isActive,
    required DateTime startDate,
    DateTime? endDate,
    String? prescriptionId,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Medication;

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);
}

/// Medication creation request DTO
@freezed
abstract class CreateMedicationRequest with _$CreateMedicationRequest {
  const factory CreateMedicationRequest({
    required String name,
    String? genericName,
    required String strength,
    required MedicationForm form,
    String? manufacturer,
    String? rxNormCode,
    String? ndcCode,
    String? classification,
    @Default(true) bool isActive,
    required DateTime startDate,
    DateTime? endDate,
    String? prescriptionId,
    String? notes,
  }) = _CreateMedicationRequest;

  factory CreateMedicationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateMedicationRequestFromJson(json);
}

/// Medication update request DTO
@freezed
abstract class UpdateMedicationRequest with _$UpdateMedicationRequest {
  const factory UpdateMedicationRequest({
    String? name,
    String? genericName,
    String? strength,
    MedicationForm? form,
    String? manufacturer,
    String? rxNormCode,
    String? ndcCode,
    String? classification,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    String? prescriptionId,
    String? notes,
  }) = _UpdateMedicationRequest;

  factory UpdateMedicationRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateMedicationRequestFromJson(json);
}

/// Medication query parameters DTO
@freezed
abstract class MedicationQueryParams with _$MedicationQueryParams {
  const factory MedicationQueryParams({
    bool? isActive,
    MedicationForm? form,
    String? classification,
    DateTime? startDateFrom,
    DateTime? startDateTo,
    DateTime? endDateFrom,
    DateTime? endDateTo,
    String? prescriptionId,
    @Default(50) int limit,
    @Default(0) int offset,
    @Default('name') String sortBy,
    @Default('asc') String sortOrder,
  }) = _MedicationQueryParams;

  factory MedicationQueryParams.fromJson(Map<String, dynamic> json) =>
      _$MedicationQueryParamsFromJson(json);
}

/// Medication statistics DTO
@freezed
abstract class MedicationStatistics with _$MedicationStatistics {
  const factory MedicationStatistics({
    required int totalMedications,
    required int activeMedications,
    required int inactiveMedications,
    required int expiringSoon,
    required Map<MedicationForm, int> medicationsByForm,
    required Map<String, int> medicationsByClassification,
    required double averageAdherence,
    required int totalDoses,
    required int missedDoses,
  }) = _MedicationStatistics;

  factory MedicationStatistics.fromJson(Map<String, dynamic> json) =>
      _$MedicationStatisticsFromJson(json);
}

/// API response wrapper for medication operations
@freezed
abstract class MedicationResponse with _$MedicationResponse {
  const factory MedicationResponse({
    required bool success,
    Medication? data,
    String? message,
    String? error,
  }) = _MedicationResponse;

  factory MedicationResponse.fromJson(Map<String, dynamic> json) =>
      _$MedicationResponseFromJson(json);
}

/// API response wrapper for medication list operations
@freezed
abstract class MedicationListResponse with _$MedicationListResponse {
  const factory MedicationListResponse({
    required bool success,
    @Default([]) List<Medication> data,
    int? count,
    int? total,
    String? message,
    String? error,
  }) = _MedicationListResponse;

  factory MedicationListResponse.fromJson(Map<String, dynamic> json) =>
      _$MedicationListResponseFromJson(json);
}
