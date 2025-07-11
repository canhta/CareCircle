import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/logging/error_tracker.dart';
import '../../domain/models/models.dart';
import '../services/medication_api_service.dart';

/// Healthcare-compliant prescription repository with comprehensive data management
///
/// This repository handles all prescription operations with strict privacy
/// protection and HIPAA-compliant logging practices.
class PrescriptionRepository {
  final MedicationApiService _apiService;

  // Healthcare-compliant logger for medication context
  static final _logger = BoundedContextLoggers.medication;

  PrescriptionRepository(this._apiService);

  /// Get user prescriptions with optional filtering
  Future<List<Prescription>> getPrescriptions({
    PrescriptionQueryParams? params,
    bool useCache = true,
  }) async {
    try {
      _logger.info('Fetching user prescriptions', {
        'operation': 'getPrescriptions',
        'hasFilters': params != null,
        'useCache': useCache,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Try cache first if enabled
      if (useCache) {
        final cached = await _getCachedPrescriptions();
        if (cached != null && cached.isNotEmpty) {
          _logger.info('Returning cached prescriptions', {
            'count': cached.length,
            'source': 'cache',
          });
          return cached;
        }
      }

      // Fetch from API
      final response = await _apiService.getUserPrescriptions(
        params?.isVerified,
        params?.startDate?.toIso8601String(),
        params?.endDate?.toIso8601String(),
        params?.limit,
        params?.offset,
      );

      final prescriptions = response.data;

      // Cache the results
      await _cachePrescriptions(prescriptions);

      // Log access with sanitized summary
      _logger.logHealthDataAccess('Prescriptions accessed', {
        'dataType': 'prescriptions',
        'prescriptionCount': prescriptions.length,
        'hasVerifiedFilter': params?.isVerified != null,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return prescriptions;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'getPrescriptions',
        context: {'hasFilters': params != null, 'useCache': useCache},
      );

      _logger.error('Failed to fetch prescriptions', {
        'operation': 'getPrescriptions',
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'getPrescriptions',
      );
      rethrow;
    }
  }

  /// Get prescription by ID
  Future<Prescription?> getPrescriptionById(String id) async {
    try {
      _logger.info('Fetching prescription by ID', {
        'operation': 'getPrescriptionById',
        'prescriptionId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.getPrescription(id);
      final prescription = response.data;

      _logger.logHealthDataAccess('Prescription accessed', {
        'dataType': 'prescription',
        'prescriptionId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return prescription;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        _logger.warning('Prescription not found', {
          'prescriptionId': id,
          'statusCode': 404,
        });
        return null;
      }

      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'getPrescriptionById',
        context: {'prescriptionId': id},
      );

      _logger.error('Failed to fetch prescription', {
        'operation': 'getPrescriptionById',
        'prescriptionId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'getPrescriptionById',
        context: {'prescriptionId': id},
      );
      rethrow;
    }
  }

  /// Create new prescription
  Future<Prescription> createPrescription(
    CreatePrescriptionRequest request,
  ) async {
    try {
      _logger.info('Creating new prescription', {
        'operation': 'createPrescription',
        'prescribedBy': request.prescribedBy,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.createPrescription(request);
      final prescription = response.data;

      if (prescription == null) {
        throw Exception('Failed to create prescription: No data returned');
      }

      // Clear cache to force refresh
      await _clearPrescriptionCache();

      _logger.logHealthDataAccess('Prescription created', {
        'dataType': 'prescription',
        'prescriptionId': prescription.id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return prescription;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'createPrescription',
        context: {'prescribedBy': request.prescribedBy},
      );

      _logger.error('Failed to create prescription', {
        'operation': 'createPrescription',
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'createPrescription',
      );
      rethrow;
    }
  }

  /// Update prescription
  Future<Prescription> updatePrescription(
    String id,
    UpdatePrescriptionRequest request,
  ) async {
    try {
      _logger.info('Updating prescription', {
        'operation': 'updatePrescription',
        'prescriptionId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.updatePrescription(id, request);
      final prescription = response.data;

      if (prescription == null) {
        throw Exception('Failed to update prescription: No data returned');
      }

      // Clear cache to force refresh
      await _clearPrescriptionCache();

      _logger.logHealthDataAccess('Prescription updated', {
        'dataType': 'prescription',
        'prescriptionId': prescription.id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return prescription;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'updatePrescription',
        context: {'prescriptionId': id},
      );

      _logger.error('Failed to update prescription', {
        'operation': 'updatePrescription',
        'prescriptionId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'updatePrescription',
        context: {'prescriptionId': id},
      );
      rethrow;
    }
  }

  /// Delete prescription
  Future<void> deletePrescription(String id) async {
    try {
      _logger.info('Deleting prescription', {
        'operation': 'deletePrescription',
        'prescriptionId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _apiService.deletePrescription(id);

      // Clear cache to force refresh
      await _clearPrescriptionCache();

      _logger.logHealthDataAccess('Prescription deleted', {
        'dataType': 'prescription',
        'prescriptionId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'deletePrescription',
        context: {'prescriptionId': id},
      );

      _logger.error('Failed to delete prescription', {
        'operation': 'deletePrescription',
        'prescriptionId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'deletePrescription',
        context: {'prescriptionId': id},
      );
      rethrow;
    }
  }

  /// Cache prescriptions for offline access
  Future<void> _cachePrescriptions(List<Prescription> prescriptions) async {
    try {
      final prescriptionData = prescriptions.map((p) => p.toJson()).toList();
      await StorageService.setCacheJson(
        'medication_cache',
        'user_prescriptions',
        {
          'prescriptions': prescriptionData,
          'cached_at': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      _logger.warning('Failed to cache prescriptions', {
        'error': e.toString(),
        'count': prescriptions.length,
      });
    }
  }

  /// Get cached prescriptions
  Future<List<Prescription>?> _getCachedPrescriptions() async {
    try {
      final data = await StorageService.getCacheJson(
        'medication_cache',
        'user_prescriptions',
      );
      if (data == null) return null;

      final prescriptions = data['prescriptions'] as List?;
      if (prescriptions == null) return null;

      return prescriptions
          .cast<Map<String, dynamic>>()
          .map((json) => Prescription.fromJson(json))
          .toList();
    } catch (e) {
      _logger.warning('Failed to get cached prescriptions', {
        'error': e.toString(),
      });
      return null;
    }
  }

  /// Clear prescription cache
  Future<void> _clearPrescriptionCache() async {
    try {
      await StorageService.removeCache(
        'medication_cache',
        'user_prescriptions',
      );
    } catch (e) {
      _logger.warning('Failed to clear prescription cache', {
        'error': e.toString(),
      });
    }
  }
}

/// Provider for prescription repository
final prescriptionRepositoryProvider = Provider<PrescriptionRepository>((ref) {
  final apiService = ref.read(medicationApiServiceProvider);
  return PrescriptionRepository(apiService);
});
