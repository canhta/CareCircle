import '../../../common/common.dart';
import '../domain/medication_models.dart';
import '../domain/medication_repository.dart';

/// Medication service implementation
class MedicationService implements MedicationRepository {
  final AppLogger _logger;
  final ApiClient _apiClient;

  MedicationService({
    required AppLogger logger,
    required ApiClient apiClient,
    required SecureStorageService secureStorage,
  })  : _logger = logger,
        _apiClient = apiClient;

  @override
  Future<Result<void>> markMedicationTaken({
    required String medicationId,
    required DateTime takenAt,
    String? notes,
  }) async {
    try {
      _logger.info('Marking medication as taken: $medicationId');

      // Make API call to mark medication as taken
      await _apiClient.post(
        '/medications/$medicationId/taken',
        data: {
          'taken_at': takenAt.toIso8601String(),
          'notes': notes,
        },
      );

      _logger.info('Successfully marked medication as taken: $medicationId');
      return Result.success(null);
    } on NetworkException catch (e) {
      _logger.error('API error marking medication as taken', error: e);
      return Result.failure(
          Exception('Failed to mark medication as taken: ${e.message}'));
    } catch (e) {
      _logger.error('Error marking medication as taken', error: e);
      return Result.failure(
          Exception('Failed to mark medication as taken: $e'));
    }
  }

  @override
  Future<Result<void>> skipMedicationDose({
    required String medicationId,
    required DateTime skippedAt,
    required String reason,
  }) async {
    try {
      _logger.info('Skipping medication dose: $medicationId');

      // Make API call to skip medication dose
      await _apiClient.post(
        '/medications/$medicationId/skip',
        data: {
          'skipped_at': skippedAt.toIso8601String(),
          'reason': reason,
        },
      );

      _logger.info('Successfully skipped medication: $medicationId');
      return Result.success(null);
    } on NetworkException catch (e) {
      _logger.error('API error skipping medication', error: e);
      return Result.failure(
          Exception('Failed to skip medication: ${e.message}'));
    } catch (e) {
      _logger.error('Error skipping medication dose', error: e);
      return Result.failure(Exception('Failed to skip medication: $e'));
    }
  }

  @override
  Future<Result<List<Medication>>> getMedications() async {
    try {
      _logger.info('Getting medications');

      // Make API call to get medications
      final response = await _apiClient.get('/medications');

      if (response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        final medications =
            data.map((json) => Medication.fromJson(json)).toList();

        _logger
            .info('Successfully retrieved ${medications.length} medications');
        return Result.success(medications);
      } else {
        _logger.error('API returned null data for medications');
        return Result.failure(
            Exception('Failed to get medications: No data returned'));
      }
    } on NetworkException catch (e) {
      _logger.error('API error getting medications', error: e);
      return Result.failure(
          Exception('Failed to get medications: ${e.message}'));
    } catch (e) {
      _logger.error('Error getting medications', error: e);
      return Result.failure(Exception('Failed to get medications: $e'));
    }
  }

  @override
  Future<Result<Medication>> getMedicationById(String medicationId) async {
    try {
      _logger.info('Getting medication by id: $medicationId');

      // Make API call to get medication
      final response = await _apiClient.get('/medications/$medicationId');

      if (response.data != null) {
        final medication =
            Medication.fromJson(response.data as Map<String, dynamic>);

        _logger.info('Successfully retrieved medication: ${medication.name}');
        return Result.success(medication);
      } else {
        _logger.error('API returned null data for medication');
        return Result.failure(
            Exception('Failed to get medication: No data returned'));
      }
    } on NetworkException catch (e) {
      _logger.error('API error getting medication', error: e);
      return Result.failure(
          Exception('Failed to get medication: ${e.message}'));
    } catch (e) {
      _logger.error('Error getting medication by id', error: e);
      return Result.failure(Exception('Failed to get medication: $e'));
    }
  }

  @override
  Future<Result<void>> addMedication(MedicationCreate medication) async {
    try {
      _logger.info('Adding new medication: ${medication.name}');

      // Make API call to add medication
      await _apiClient.post(
        '/medications',
        data: medication.toJson(),
      );

      _logger.info('Successfully added medication: ${medication.name}');
      return Result.success(null);
    } on NetworkException catch (e) {
      _logger.error('API error adding medication', error: e);
      return Result.failure(
          Exception('Failed to add medication: ${e.message}'));
    } catch (e) {
      _logger.error('Error adding medication', error: e);
      return Result.failure(Exception('Failed to add medication: $e'));
    }
  }

  @override
  Future<Result<void>> updateMedication(
      String medicationId, MedicationUpdate medication) async {
    try {
      _logger.info('Updating medication: $medicationId');

      // Make API call to update medication
      await _apiClient.put(
        '/medications/$medicationId',
        data: medication.toJson(),
      );

      _logger.info('Successfully updated medication: $medicationId');
      return Result.success(null);
    } on NetworkException catch (e) {
      _logger.error('API error updating medication', error: e);
      return Result.failure(
          Exception('Failed to update medication: ${e.message}'));
    } catch (e) {
      _logger.error('Error updating medication', error: e);
      return Result.failure(Exception('Failed to update medication: $e'));
    }
  }

  @override
  Future<Result<void>> deleteMedication(String medicationId) async {
    try {
      _logger.info('Deleting medication: $medicationId');

      // Make API call to delete medication
      await _apiClient.delete('/medications/$medicationId');

      _logger.info('Successfully deleted medication: $medicationId');
      return Result.success(null);
    } on NetworkException catch (e) {
      _logger.error('API error deleting medication', error: e);
      return Result.failure(
          Exception('Failed to delete medication: ${e.message}'));
    } catch (e) {
      _logger.error('Error deleting medication', error: e);
      return Result.failure(Exception('Failed to delete medication: $e'));
    }
  }

  @override
  Future<Result<List<MedicationHistory>>> getMedicationHistory(
      String medicationId) async {
    try {
      _logger.info('Getting medication history: $medicationId');

      // Make API call to get medication history
      final response =
          await _apiClient.get('/medications/$medicationId/history');

      if (response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        final history =
            data.map((json) => MedicationHistory.fromJson(json)).toList();

        _logger.info(
            'Successfully retrieved ${history.length} medication history entries');
        return Result.success(history);
      } else {
        _logger.error('API returned null data for medication history');
        return Result.failure(
            Exception('Failed to get medication history: No data returned'));
      }
    } on NetworkException catch (e) {
      _logger.error('API error getting medication history', error: e);
      return Result.failure(
          Exception('Failed to get medication history: ${e.message}'));
    } catch (e) {
      _logger.error('Error getting medication history', error: e);
      return Result.failure(Exception('Failed to get medication history: $e'));
    }
  }
}
