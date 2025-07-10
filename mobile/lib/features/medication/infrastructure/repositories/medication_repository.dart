import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/logging/error_tracker.dart';
import '../../domain/models/models.dart';
import '../services/medication_api_service.dart';

/// Healthcare-compliant medication repository with comprehensive data management
///
/// This repository handles all medication operations with strict privacy
/// protection and HIPAA-compliant logging practices.
class MedicationRepository {
  final MedicationApiService _apiService;

  // Healthcare-compliant logger for medication context
  static final _logger = BoundedContextLoggers.medication;

  MedicationRepository(this._apiService);

  /// Get user medications with optional filtering
  Future<List<Medication>> getMedications({MedicationQueryParams? params, bool useCache = true}) async {
    try {
      _logger.info('Fetching user medications', {
        'operation': 'getMedications',
        'hasFilters': params != null,
        'useCache': useCache,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Try cache first if enabled
      if (useCache) {
        final cached = await _getCachedMedications();
        if (cached != null && cached.isNotEmpty) {
          _logger.info('Returning cached medications', {'count': cached.length, 'source': 'cache'});
          return cached;
        }
      }

      // Fetch from API
      final response = await _apiService.getUserMedications(
        params?.isActive,
        params?.form?.name,
        params?.classification,
        params?.startDateFrom?.toIso8601String(),
        params?.startDateTo?.toIso8601String(),
        params?.endDateFrom?.toIso8601String(),
        params?.endDateTo?.toIso8601String(),
        params?.prescriptionId,
        params?.limit,
        params?.offset,
        params?.sortBy,
        params?.sortOrder,
      );

      final medications = response.data;

      // Cache the results
      await _cacheMedications(medications);

      // Log access with sanitized summary
      _logger.logHealthDataAccess('Medications accessed', {
        'dataType': 'medications',
        'medicationCount': medications.length,
        'hasActiveFilter': params?.isActive != null,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return medications;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'getMedications',
        context: {'hasFilters': params != null, 'useCache': useCache},
      );

      _logger.error('Failed to fetch medications', {
        'operation': 'getMedications',
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(e, stackTrace, operation: 'getMedications');
      rethrow;
    }
  }

  /// Get medication by ID
  Future<Medication?> getMedicationById(String id) async {
    try {
      _logger.info('Fetching medication by ID', {
        'operation': 'getMedicationById',
        'medicationId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.getMedication(id);
      final medication = response.data;

      _logger.logHealthDataAccess('Medication accessed', {
        'dataType': 'medication',
        'medicationId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return medication;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        _logger.warning('Medication not found', {'medicationId': id, 'statusCode': 404});
        return null;
      }

      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'getMedicationById',
        context: {'medicationId': id},
      );

      _logger.error('Failed to fetch medication', {
        'operation': 'getMedicationById',
        'medicationId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'getMedicationById',
        context: {'medicationId': id},
      );
      rethrow;
    }
  }

  /// Create new medication
  Future<Medication> createMedication(CreateMedicationRequest request) async {
    try {
      _logger.info('Creating new medication', {
        'operation': 'createMedication',
        'medicationName': request.name,
        'form': request.form.name,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.createMedication(request);
      final medication = response.data;

      if (medication == null) {
        throw Exception('Failed to create medication: No data returned');
      }

      // Clear cache to force refresh
      await _clearMedicationCache();

      _logger.logHealthDataAccess('Medication created', {
        'dataType': 'medication',
        'medicationId': medication.id,
        'medicationName': medication.name,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return medication;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'createMedication',
        context: {'medicationName': request.name, 'form': request.form.name},
      );

      _logger.error('Failed to create medication', {
        'operation': 'createMedication',
        'medicationName': request.name,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'createMedication',
        context: {'medicationName': request.name},
      );
      rethrow;
    }
  }

  /// Update existing medication
  Future<Medication> updateMedication(String id, UpdateMedicationRequest request) async {
    try {
      _logger.info('Updating medication', {
        'operation': 'updateMedication',
        'medicationId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.updateMedication(id, request);
      final medication = response.data;

      if (medication == null) {
        throw Exception('Failed to update medication: No data returned');
      }

      // Clear cache to force refresh
      await _clearMedicationCache();

      _logger.logHealthDataAccess('Medication updated', {
        'dataType': 'medication',
        'medicationId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return medication;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'updateMedication',
        context: {'medicationId': id},
      );

      _logger.error('Failed to update medication', {
        'operation': 'updateMedication',
        'medicationId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'updateMedication',
        context: {'medicationId': id},
      );
      rethrow;
    }
  }

  /// Delete medication
  Future<void> deleteMedication(String id) async {
    try {
      _logger.info('Deleting medication', {
        'operation': 'deleteMedication',
        'medicationId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _apiService.deleteMedication(id);

      // Clear cache to force refresh
      await _clearMedicationCache();

      _logger.logHealthDataAccess('Medication deleted', {
        'dataType': 'medication',
        'medicationId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'deleteMedication',
        context: {'medicationId': id},
      );

      _logger.error('Failed to delete medication', {
        'operation': 'deleteMedication',
        'medicationId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'deleteMedication',
        context: {'medicationId': id},
      );
      rethrow;
    }
  }

  /// Cache medications for offline access
  Future<void> _cacheMedications(List<Medication> medications) async {
    try {
      final medicationData = medications.map((m) => m.toJson()).toList();
      await StorageService.setCacheJson('medication_cache', 'user_medications', {
        'medications': medicationData,
        'cached_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.warning('Failed to cache medications', {'error': e.toString(), 'count': medications.length});
    }
  }

  /// Get cached medications
  Future<List<Medication>?> _getCachedMedications() async {
    try {
      final data = await StorageService.getCacheJson('medication_cache', 'user_medications');
      if (data == null) return null;

      final medications = data['medications'] as List?;
      if (medications == null) return null;

      return medications.cast<Map<String, dynamic>>().map((json) => Medication.fromJson(json)).toList();
    } catch (e) {
      _logger.warning('Failed to get cached medications', {'error': e.toString()});
      return null;
    }
  }

  /// Clear medication cache
  Future<void> _clearMedicationCache() async {
    try {
      await StorageService.removeCache('medication_cache', 'user_medications');
    } catch (e) {
      _logger.warning('Failed to clear medication cache', {'error': e.toString()});
    }
  }
}

/// Provider for medication repository
final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  final apiService = ref.read(medicationApiServiceProvider);
  return MedicationRepository(apiService);
});
