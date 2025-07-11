import 'package:freezed_annotation/freezed_annotation.dart';
import 'adherence_record.dart';
import 'medication.dart';

part 'query_params.freezed.dart';
part 'query_params.g.dart';

/// Query parameters for prescription filtering
@freezed
abstract class PrescriptionQueryParams with _$PrescriptionQueryParams {
  const factory PrescriptionQueryParams({
    bool? isVerified,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) = _PrescriptionQueryParams;

  factory PrescriptionQueryParams.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionQueryParamsFromJson(json);
}

/// Query parameters for medication schedule filtering
@freezed
abstract class ScheduleQueryParams with _$ScheduleQueryParams {
  const factory ScheduleQueryParams({
    String? medicationId,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) = _ScheduleQueryParams;

  factory ScheduleQueryParams.fromJson(Map<String, dynamic> json) =>
      _$ScheduleQueryParamsFromJson(json);
}

/// Query parameters for adherence record filtering
@freezed
abstract class AdherenceQueryParams with _$AdherenceQueryParams {
  const factory AdherenceQueryParams({
    String? medicationId,
    String? scheduleId,
    DoseStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) = _AdherenceQueryParams;

  factory AdherenceQueryParams.fromJson(Map<String, dynamic> json) =>
      _$AdherenceQueryParamsFromJson(json);
}

/// Query parameters for medication filtering
@freezed
abstract class MedicationQueryParams with _$MedicationQueryParams {
  const factory MedicationQueryParams({
    String? searchTerm,
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

/// Query parameters for drug interaction filtering
@freezed
abstract class InteractionQueryParams with _$InteractionQueryParams {
  const factory InteractionQueryParams({
    String? medicationId,
    String? severity,
    bool? isActive,
    int? limit,
    int? offset,
  }) = _InteractionQueryParams;

  factory InteractionQueryParams.fromJson(Map<String, dynamic> json) =>
      _$InteractionQueryParamsFromJson(json);
}

/// Query parameters for medication inventory filtering
@freezed
abstract class InventoryQueryParams with _$InventoryQueryParams {
  const factory InventoryQueryParams({
    String? medicationId,
    bool? isLowStock,
    bool? isExpired,
    DateTime? expirationBefore,
    DateTime? expirationAfter,
    int? limit,
    int? offset,
  }) = _InventoryQueryParams;

  factory InventoryQueryParams.fromJson(Map<String, dynamic> json) =>
      _$InventoryQueryParamsFromJson(json);
}

/// Query parameters for prescription processing
@freezed
abstract class ProcessingQueryParams with _$ProcessingQueryParams {
  const factory ProcessingQueryParams({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) = _ProcessingQueryParams;

  factory ProcessingQueryParams.fromJson(Map<String, dynamic> json) =>
      _$ProcessingQueryParamsFromJson(json);
}
