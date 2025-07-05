import '../../../common/common.dart';
import 'medication_models.dart';

/// Repository interface for medication-related operations
abstract class MedicationRepository {
  /// Mark a medication as taken
  Future<Result<void>> markMedicationTaken({
    required String medicationId,
    required DateTime takenAt,
    String? notes,
  });

  /// Skip a medication dose
  Future<Result<void>> skipMedicationDose({
    required String medicationId,
    required DateTime skippedAt,
    required String reason,
  });

  /// Get all medications
  Future<Result<List<Medication>>> getMedications();

  /// Get medication by ID
  Future<Result<Medication>> getMedicationById(String medicationId);

  /// Add a new medication
  Future<Result<void>> addMedication(MedicationCreate medication);

  /// Update an existing medication
  Future<Result<void>> updateMedication(
    String medicationId,
    MedicationUpdate medication,
  );

  /// Delete a medication
  Future<Result<void>> deleteMedication(String medicationId);

  /// Get medication history
  Future<Result<List<MedicationHistory>>> getMedicationHistory(
      String medicationId);
}
