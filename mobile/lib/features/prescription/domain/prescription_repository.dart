import 'dart:io';
import '../../../common/common.dart';
import 'prescription_models.dart';

/// Repository interface for prescription operations
abstract class PrescriptionRepository {
  /// Scan a prescription image using OCR
  Future<Result<PrescriptionOCRResponse>> scanPrescription(
    File imageFile, {
    PrescriptionScanOptions? options,
  });

  /// Get paginated prescriptions
  Future<Result<PrescriptionPaginatedResponse>> getPrescriptions({
    int page = 1,
    int limit = 20,
    PrescriptionFilterOptions? filters,
  });

  /// Get a specific prescription by ID
  Future<Result<PrescriptionModel>> getPrescription(String prescriptionId);

  /// Create a new prescription
  Future<Result<PrescriptionModel>> createPrescription(
    Map<String, dynamic> prescriptionData,
  );

  /// Update an existing prescription
  Future<Result<PrescriptionModel>> updatePrescription(
    String prescriptionId,
    Map<String, dynamic> prescriptionData,
  );

  /// Delete a prescription
  Future<Result<void>> deletePrescription(String prescriptionId);

  /// Get prescriptions for a specific patient
  Future<Result<List<PrescriptionModel>>> getPatientPrescriptions(
    String patientId,
  );

  /// Get active prescriptions
  Future<Result<List<PrescriptionModel>>> getActivePrescriptions();

  /// Get prescriptions expiring soon
  Future<Result<List<PrescriptionModel>>> getExpiringSoon({
    int days = 7,
  });

  /// Mark prescription as completed
  Future<Result<void>> markAsCompleted(String prescriptionId);

  /// Mark prescription as cancelled
  Future<Result<void>> markAsCancelled(String prescriptionId);

  /// Upload prescription image
  Future<Result<String>> uploadPrescriptionImage(File imageFile);

  /// Get prescription statistics
  Future<Result<Map<String, dynamic>>> getPrescriptionStats();
}
