// Prescription models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prescription.freezed.dart';
part 'prescription.g.dart';

/// Verification status for prescriptions
enum VerificationStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('VERIFIED')
  verified,
  @JsonValue('REJECTED')
  rejected,
  @JsonValue('NEEDS_REVIEW')
  needsReview,
}

/// OCR extracted medication data
@freezed
abstract class OCRMedicationData with _$OCRMedicationData {
  const factory OCRMedicationData({
    String? name,
    String? strength,
    String? quantity,
    String? instructions,
    required double confidence,
  }) = _OCRMedicationData;

  factory OCRMedicationData.fromJson(Map<String, dynamic> json) =>
      _$OCRMedicationDataFromJson(json);
}

/// OCR extracted fields from prescription
@freezed
abstract class OCRFields with _$OCRFields {
  const factory OCRFields({
    String? prescribedBy,
    String? prescribedDate,
    String? pharmacy,
    @Default([]) List<OCRMedicationData> medications,
  }) = _OCRFields;

  factory OCRFields.fromJson(Map<String, dynamic> json) =>
      _$OCRFieldsFromJson(json);
}

/// OCR processing metadata
@freezed
abstract class ProcessingMetadata with _$ProcessingMetadata {
  const factory ProcessingMetadata({
    required String ocrEngine,
    required double processingTime,
    required double imageQuality,
    required String extractionMethod,
  }) = _ProcessingMetadata;

  factory ProcessingMetadata.fromJson(Map<String, dynamic> json) =>
      _$ProcessingMetadataFromJson(json);
}

/// Complete OCR data structure
@freezed
abstract class OCRData with _$OCRData {
  const factory OCRData({
    required String extractedText,
    required double confidence,
    required OCRFields fields,
    required ProcessingMetadata processingMetadata,
  }) = _OCRData;

  factory OCRData.fromJson(Map<String, dynamic> json) =>
      _$OCRDataFromJson(json);
}

/// Prescription medication entry
@freezed
abstract class PrescriptionMedication with _$PrescriptionMedication {
  const factory PrescriptionMedication({
    required String name,
    required String strength,
    required String form,
    required String dosage,
    required int quantity,
    required String instructions,
    String? linkedMedicationId,
  }) = _PrescriptionMedication;

  factory PrescriptionMedication.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionMedicationFromJson(json);
}

/// Main prescription entity
@freezed
abstract class Prescription with _$Prescription {
  const factory Prescription({
    required String id,
    required String userId,
    required String prescribedBy,
    required DateTime prescribedDate,
    String? pharmacy,
    OCRData? ocrData,
    String? imageUrl,
    @Default(false) bool isVerified,
    DateTime? verifiedAt,
    String? verifiedBy,
    @Default([]) List<PrescriptionMedication> medications,
    required DateTime createdAt,
    required DateTime updatedAt,
    // Additional properties expected by screens
    @Default(VerificationStatus.pending) VerificationStatus verificationStatus,
    DateTime? dateIssued, // Alias for prescribedDate
    @Default([])
    List<String> extractedMedications, // Simplified medication names
  }) = _Prescription;

  factory Prescription.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionFromJson(json);
}

/// Prescription creation request DTO
@freezed
abstract class CreatePrescriptionRequest with _$CreatePrescriptionRequest {
  const factory CreatePrescriptionRequest({
    required String prescribedBy,
    required DateTime prescribedDate,
    String? pharmacy,
    OCRData? ocrData,
    String? imageUrl,
    @Default(false) bool isVerified,
    DateTime? verifiedAt,
    String? verifiedBy,
    @Default([]) List<PrescriptionMedication> medications,
  }) = _CreatePrescriptionRequest;

  factory CreatePrescriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePrescriptionRequestFromJson(json);
}

/// OCR result for prescription scanning
@freezed
abstract class PrescriptionOCRResult with _$PrescriptionOCRResult {
  const factory PrescriptionOCRResult({
    required String extractedText,
    required double confidence,
    @Default([]) List<String> extractedMedications,
    String? prescribedBy,
    DateTime? prescribedDate,
    String? pharmacy,
    @Default([]) List<OCRMedicationData> medications,
  }) = _PrescriptionOCRResult;

  factory PrescriptionOCRResult.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionOCRResultFromJson(json);
}

/// Prescription update request DTO
@freezed
abstract class UpdatePrescriptionRequest with _$UpdatePrescriptionRequest {
  const factory UpdatePrescriptionRequest({
    String? prescribedBy,
    DateTime? prescribedDate,
    String? pharmacy,
    OCRData? ocrData,
    String? imageUrl,
    bool? isVerified,
    DateTime? verifiedAt,
    String? verifiedBy,
    List<PrescriptionMedication>? medications,
  }) = _UpdatePrescriptionRequest;

  factory UpdatePrescriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePrescriptionRequestFromJson(json);
}

/// OCR processing request DTO
@freezed
abstract class OCRProcessingRequest with _$OCRProcessingRequest {
  const factory OCRProcessingRequest({
    String? imageUrl,
    String? base64Image,
    @Default(false) bool enhanceImage,
    @Default(false) bool extractMedications,
  }) = _OCRProcessingRequest;

  factory OCRProcessingRequest.fromJson(Map<String, dynamic> json) =>
      _$OCRProcessingRequestFromJson(json);
}

/// OCR processing result DTO
@freezed
abstract class OCRProcessingResult with _$OCRProcessingResult {
  const factory OCRProcessingResult({
    required bool success,
    OCRData? ocrData,
    @Default([]) List<PrescriptionMedication> extractedMedications,
    String? error,
    String? message,
  }) = _OCRProcessingResult;

  factory OCRProcessingResult.fromJson(Map<String, dynamic> json) =>
      _$OCRProcessingResultFromJson(json);
}

/// API response wrapper for prescription operations
@freezed
abstract class PrescriptionResponse with _$PrescriptionResponse {
  const factory PrescriptionResponse({
    required bool success,
    Prescription? data,
    String? message,
    String? error,
  }) = _PrescriptionResponse;

  factory PrescriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionResponseFromJson(json);
}

/// API response wrapper for prescription list operations
@freezed
abstract class PrescriptionListResponse with _$PrescriptionListResponse {
  const factory PrescriptionListResponse({
    required bool success,
    @Default([]) List<Prescription> data,
    int? count,
    int? total,
    String? message,
    String? error,
  }) = _PrescriptionListResponse;

  factory PrescriptionListResponse.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionListResponseFromJson(json);
}
