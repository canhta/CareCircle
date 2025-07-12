import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/logging/error_tracker.dart';
import '../../domain/models/models.dart';
import '../services/medication_api_service.dart';

/// Healthcare-compliant adherence repository with comprehensive data management
///
/// This repository handles all adherence tracking operations with strict privacy
/// protection and HIPAA-compliant logging practices.
class AdherenceRepository {
  final MedicationApiService _apiService;

  // Healthcare-compliant logger for medication context
  static final _logger = BoundedContextLoggers.medication;

  AdherenceRepository(this._apiService);

  /// Get user adherence records with optional filtering
  Future<List<AdherenceRecord>> getAdherenceRecords({
    AdherenceQueryParams? params,
    bool useCache = true,
  }) async {
    try {
      _logger.info('Fetching user adherence records', {
        'operation': 'getAdherenceRecords',
        'hasFilters': params != null,
        'useCache': useCache,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Try cache first if enabled
      if (useCache) {
        final cached = await _getCachedAdherenceRecords();
        if (cached != null && cached.isNotEmpty) {
          _logger.info('Returning cached adherence records', {
            'count': cached.length,
            'source': 'cache',
          });
          return cached;
        }
      }

      // Fetch from API
      final response = await _apiService.getAdherenceRecords(
        params?.medicationId,
        params?.scheduleId,
        params?.status?.name,
        params?.startDate?.toIso8601String(),
        params?.endDate?.toIso8601String(),
        params?.limit,
        params?.offset,
      );

      final records = response.data;

      // Cache the results
      await _cacheAdherenceRecords(records);

      // Log access with sanitized summary
      _logger.logHealthDataAccess('Adherence records accessed', {
        'dataType': 'adherenceRecords',
        'recordCount': records.length,
        'hasMedicationFilter': params?.medicationId != null,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return records;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'getAdherenceRecords',
        context: {'hasFilters': params != null, 'useCache': useCache},
      );

      _logger.error('Failed to fetch adherence records', {
        'operation': 'getAdherenceRecords',
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'getAdherenceRecords',
      );
      rethrow;
    }
  }

  /// Get adherence records for specific medication
  Future<List<AdherenceRecord>> getAdherenceForMedication(
    String medicationId,
  ) async {
    return getAdherenceRecords(
      params: AdherenceQueryParams(medicationId: medicationId),
    );
  }

  /// Get adherence record by ID
  Future<AdherenceRecord?> getAdherenceRecordById(String id) async {
    try {
      _logger.info('Fetching adherence record by ID', {
        'operation': 'getAdherenceRecordById',
        'recordId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.getAdherenceRecord(id);
      final record = response.data;

      _logger.logHealthDataAccess('Adherence record accessed', {
        'dataType': 'adherenceRecord',
        'recordId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return record;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        _logger.warning('Adherence record not found', {
          'recordId': id,
          'statusCode': 404,
        });
        return null;
      }

      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'getAdherenceRecordById',
        context: {'recordId': id},
      );

      _logger.error('Failed to fetch adherence record', {
        'operation': 'getAdherenceRecordById',
        'recordId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'getAdherenceRecordById',
        context: {'recordId': id},
      );
      rethrow;
    }
  }

  /// Create new adherence record
  Future<AdherenceRecord> createAdherenceRecord(
    CreateAdherenceRecordRequest request,
  ) async {
    try {
      _logger.info('Creating new adherence record', {
        'operation': 'createAdherenceRecord',
        'medicationId': request.medicationId,
        'status': request.status.name,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.createAdherenceRecord(request);
      final record = response.data;

      if (record == null) {
        throw Exception('Failed to create adherence record: No data returned');
      }

      // Clear cache to force refresh
      await _clearAdherenceCache();

      _logger.logHealthDataAccess('Adherence record created', {
        'dataType': 'adherenceRecord',
        'recordId': record.id,
        'medicationId': record.medicationId,
        'status': record.status.name,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return record;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'createAdherenceRecord',
        context: {
          'medicationId': request.medicationId,
          'status': request.status.name,
        },
      );

      _logger.error('Failed to create adherence record', {
        'operation': 'createAdherenceRecord',
        'medicationId': request.medicationId,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'createAdherenceRecord',
      );
      rethrow;
    }
  }

  /// Update adherence record
  Future<AdherenceRecord> updateAdherenceRecord(
    String id,
    UpdateAdherenceRecordRequest request,
  ) async {
    try {
      _logger.info('Updating adherence record', {
        'operation': 'updateAdherenceRecord',
        'recordId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.updateAdherenceRecord(id, request);
      final record = response.data;

      if (record == null) {
        throw Exception('Failed to update adherence record: No data returned');
      }

      // Clear cache to force refresh
      await _clearAdherenceCache();

      _logger.logHealthDataAccess('Adherence record updated', {
        'dataType': 'adherenceRecord',
        'recordId': record.id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return record;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'updateAdherenceRecord',
        context: {'recordId': id},
      );

      _logger.error('Failed to update adherence record', {
        'operation': 'updateAdherenceRecord',
        'recordId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'updateAdherenceRecord',
        context: {'recordId': id},
      );
      rethrow;
    }
  }

  /// Delete adherence record
  Future<void> deleteAdherenceRecord(String id) async {
    try {
      _logger.info('Deleting adherence record', {
        'operation': 'deleteAdherenceRecord',
        'recordId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _apiService.deleteAdherenceRecord(id);

      // Clear cache to force refresh
      await _clearAdherenceCache();

      _logger.logHealthDataAccess('Adherence record deleted', {
        'dataType': 'adherenceRecord',
        'recordId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'deleteAdherenceRecord',
        context: {'recordId': id},
      );

      _logger.error('Failed to delete adherence record', {
        'operation': 'deleteAdherenceRecord',
        'recordId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'deleteAdherenceRecord',
        context: {'recordId': id},
      );
      rethrow;
    }
  }

  /// Get adherence statistics
  Future<AdherenceStatistics> getAdherenceStatistics({
    String? medicationId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      _logger.info('Fetching adherence statistics', {
        'operation': 'getAdherenceStatistics',
        'medicationId': medicationId,
        'hasDateRange': startDate != null && endDate != null,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.getAdherenceStatistics(
        medicationId,
        startDate?.toIso8601String(),
        endDate?.toIso8601String(),
      );

      final statistics = response.data;
      if (statistics == null) {
        throw Exception('Failed to get adherence statistics: No data returned');
      }

      _logger.logHealthDataAccess('Adherence statistics accessed', {
        'dataType': 'adherenceStatistics',
        'medicationId': medicationId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return statistics;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'getAdherenceStatistics',
        context: {
          'medicationId': medicationId,
          'hasDateRange': startDate != null && endDate != null,
        },
      );

      _logger.error('Failed to fetch adherence statistics', {
        'operation': 'getAdherenceStatistics',
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'getAdherenceStatistics',
      );
      rethrow;
    }
  }

  /// Mark dose as taken by record ID
  Future<AdherenceRecord> markDoseAsTaken(String recordId, {DateTime? takenAt, String? notes}) async {
    try {
      _logger.info('Marking dose as taken by record ID', {
        'operation': 'markDoseAsTaken',
        'recordId': recordId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.markDoseTaken({
        'recordId': recordId,
        'takenAt': (takenAt ?? DateTime.now()).toIso8601String(),
        'notes': notes,
      });

      final record = response.data;
      if (record == null) {
        throw Exception('Failed to mark dose as taken: No data returned');
      }

      // Clear cache to force refresh
      await _clearAdherenceCache();

      _logger.logMedicationEvent('Dose marked as taken successfully', {
        'recordId': recordId,
        'takenAt': (takenAt ?? DateTime.now()).toIso8601String(),
      });

      return record;
    } on DioException catch (e) {
      _logger.error('API error marking dose as taken', {
        'recordId': recordId,
        'statusCode': e.response?.statusCode,
        'error': e.message,
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'markDoseAsTaken',
      );
      rethrow;
    }
  }

  /// Mark dose as taken by medication and schedule
  Future<AdherenceRecord> markDoseTaken({
    required String medicationId,
    required String scheduleId,
    DateTime? takenAt,
    String? notes,
  }) async {
    try {
      _logger.info('Marking dose as taken', {
        'operation': 'markDoseTaken',
        'medicationId': medicationId,
        'scheduleId': scheduleId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.markDoseTaken({
        'medicationId': medicationId,
        'scheduleId': scheduleId,
        'takenAt': (takenAt ?? DateTime.now()).toIso8601String(),
        'notes': notes,
      });

      final record = response.data;
      if (record == null) {
        throw Exception('Failed to mark dose as taken: No data returned');
      }

      // Clear cache to force refresh
      await _clearAdherenceCache();

      _logger.logHealthDataAccess('Dose marked as taken', {
        'dataType': 'adherenceRecord',
        'recordId': record.id,
        'medicationId': medicationId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return record;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'markDoseTaken',
        context: {'medicationId': medicationId, 'scheduleId': scheduleId},
      );

      _logger.error('Failed to mark dose as taken', {
        'operation': 'markDoseTaken',
        'medicationId': medicationId,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'markDoseTaken',
      );
      rethrow;
    }
  }

  /// Cache adherence records for offline access
  Future<void> _cacheAdherenceRecords(List<AdherenceRecord> records) async {
    try {
      final recordData = records.map((r) => r.toJson()).toList();
      await StorageService.setCacheJson(
        'medication_cache',
        'user_adherence_records',
        {'records': recordData, 'cached_at': DateTime.now().toIso8601String()},
      );
    } catch (e) {
      _logger.warning('Failed to cache adherence records', {
        'error': e.toString(),
        'count': records.length,
      });
    }
  }

  /// Get cached adherence records
  Future<List<AdherenceRecord>?> _getCachedAdherenceRecords() async {
    try {
      final data = await StorageService.getCacheJson(
        'medication_cache',
        'user_adherence_records',
      );
      if (data == null) return null;

      final records = data['records'] as List?;
      if (records == null) return null;

      return records
          .cast<Map<String, dynamic>>()
          .map((json) => AdherenceRecord.fromJson(json))
          .toList();
    } catch (e) {
      _logger.warning('Failed to get cached adherence records', {
        'error': e.toString(),
      });
      return null;
    }
  }

  /// Clear adherence cache
  Future<void> _clearAdherenceCache() async {
    try {
      await StorageService.removeCache(
        'medication_cache',
        'user_adherence_records',
      );
    } catch (e) {
      _logger.warning('Failed to clear adherence cache', {
        'error': e.toString(),
      });
    }
  }
}

/// Provider for adherence repository
final adherenceRepositoryProvider = Provider<AdherenceRepository>((ref) {
  final apiService = ref.read(medicationApiServiceProvider);
  return AdherenceRepository(apiService);
});
