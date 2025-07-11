import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/logging/error_tracker.dart';
import '../../domain/models/models.dart';
import '../services/medication_api_service.dart';

/// Healthcare-compliant medication schedule repository with comprehensive data management
///
/// This repository handles all medication schedule operations with strict privacy
/// protection and HIPAA-compliant logging practices.
class ScheduleRepository {
  final MedicationApiService _apiService;

  // Healthcare-compliant logger for medication context
  static final _logger = BoundedContextLoggers.medication;

  ScheduleRepository(this._apiService);

  /// Get user medication schedules with optional filtering
  Future<List<MedicationSchedule>> getSchedules({
    ScheduleQueryParams? params,
    bool useCache = true,
  }) async {
    try {
      _logger.info('Fetching user medication schedules', {
        'operation': 'getSchedules',
        'hasFilters': params != null,
        'useCache': useCache,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Try cache first if enabled
      if (useCache) {
        final cached = await _getCachedSchedules();
        if (cached != null && cached.isNotEmpty) {
          _logger.info('Returning cached schedules', {
            'count': cached.length,
            'source': 'cache',
          });
          return cached;
        }
      }

      // Fetch from API
      final response = await _apiService.getUserSchedules(
        params?.medicationId,
        params?.isActive,
        params?.startDate?.toIso8601String(),
        params?.endDate?.toIso8601String(),
      );

      final schedules = response.data;

      // Cache the results
      await _cacheSchedules(schedules);

      // Log access with sanitized summary
      _logger.logHealthDataAccess('Medication schedules accessed', {
        'dataType': 'medicationSchedules',
        'scheduleCount': schedules.length,
        'hasMedicationFilter': params?.medicationId != null,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return schedules;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'getSchedules',
        context: {'hasFilters': params != null, 'useCache': useCache},
      );

      _logger.error('Failed to fetch medication schedules', {
        'operation': 'getSchedules',
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'getSchedules',
      );
      rethrow;
    }
  }

  /// Get schedules for specific medication
  Future<List<MedicationSchedule>> getSchedulesForMedication(
    String medicationId,
  ) async {
    return getSchedules(
      params: const ScheduleQueryParams().copyWith(medicationId: medicationId),
    );
  }

  /// Get schedule by ID
  Future<MedicationSchedule?> getScheduleById(String id) async {
    try {
      _logger.info('Fetching schedule by ID', {
        'operation': 'getScheduleById',
        'scheduleId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.getSchedule(id);
      final schedule = response.data;

      _logger.logHealthDataAccess('Medication schedule accessed', {
        'dataType': 'medicationSchedule',
        'scheduleId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return schedule;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        _logger.warning('Schedule not found', {
          'scheduleId': id,
          'statusCode': 404,
        });
        return null;
      }

      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'getScheduleById',
        context: {'scheduleId': id},
      );

      _logger.error('Failed to fetch schedule', {
        'operation': 'getScheduleById',
        'scheduleId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'getScheduleById',
        context: {'scheduleId': id},
      );
      rethrow;
    }
  }

  /// Create new medication schedule
  Future<MedicationSchedule> createSchedule(
    CreateScheduleRequest request,
  ) async {
    try {
      _logger.info('Creating new medication schedule', {
        'operation': 'createSchedule',
        'medicationId': request.medicationId,
        'frequency': request.schedule.frequency.name,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.createSchedule(request);
      final schedule = response.data;

      if (schedule == null) {
        throw Exception('Failed to create schedule: No data returned');
      }

      // Clear cache to force refresh
      await _clearScheduleCache();

      _logger.logHealthDataAccess('Medication schedule created', {
        'dataType': 'medicationSchedule',
        'scheduleId': schedule.id,
        'medicationId': schedule.medicationId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return schedule;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'createSchedule',
        context: {
          'medicationId': request.medicationId,
          'frequency': request.schedule.frequency.name,
        },
      );

      _logger.error('Failed to create medication schedule', {
        'operation': 'createSchedule',
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
        operation: 'createSchedule',
      );
      rethrow;
    }
  }

  /// Update medication schedule
  Future<MedicationSchedule> updateSchedule(
    String id,
    UpdateScheduleRequest request,
  ) async {
    try {
      _logger.info('Updating medication schedule', {
        'operation': 'updateSchedule',
        'scheduleId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.updateSchedule(id, request);
      final schedule = response.data;

      if (schedule == null) {
        throw Exception('Failed to update schedule: No data returned');
      }

      // Clear cache to force refresh
      await _clearScheduleCache();

      _logger.logHealthDataAccess('Medication schedule updated', {
        'dataType': 'medicationSchedule',
        'scheduleId': schedule.id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return schedule;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'updateSchedule',
        context: {'scheduleId': id},
      );

      _logger.error('Failed to update medication schedule', {
        'operation': 'updateSchedule',
        'scheduleId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'updateSchedule',
        context: {'scheduleId': id},
      );
      rethrow;
    }
  }

  /// Delete medication schedule
  Future<void> deleteSchedule(String id) async {
    try {
      _logger.info('Deleting medication schedule', {
        'operation': 'deleteSchedule',
        'scheduleId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _apiService.deleteSchedule(id);

      // Clear cache to force refresh
      await _clearScheduleCache();

      _logger.logHealthDataAccess('Medication schedule deleted', {
        'dataType': 'medicationSchedule',
        'scheduleId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'deleteSchedule',
        context: {'scheduleId': id},
      );

      _logger.error('Failed to delete medication schedule', {
        'operation': 'deleteSchedule',
        'scheduleId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'deleteSchedule',
        context: {'scheduleId': id},
      );
      rethrow;
    }
  }

  /// Get upcoming scheduled doses
  Future<List<MedicationSchedule>> getUpcomingSchedules({int? hours}) async {
    try {
      _logger.info('Fetching upcoming medication schedules', {
        'operation': 'getUpcomingSchedules',
        'hours': hours,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.getUpcomingSchedules(hours);
      final schedules = response.data;

      _logger.logHealthDataAccess('Upcoming schedules accessed', {
        'dataType': 'upcomingSchedules',
        'scheduleCount': schedules.length,
        'hoursAhead': hours,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return schedules;
    } on DioException catch (e) {
      await ErrorTracker.recordMedicationError(
        e,
        StackTrace.current,
        operation: 'getUpcomingSchedules',
        context: {'hours': hours},
      );

      _logger.error('Failed to fetch upcoming schedules', {
        'operation': 'getUpcomingSchedules',
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e, stackTrace) {
      await ErrorTracker.recordMedicationError(
        e,
        stackTrace,
        operation: 'getUpcomingSchedules',
      );
      rethrow;
    }
  }

  /// Cache schedules for offline access
  Future<void> _cacheSchedules(List<MedicationSchedule> schedules) async {
    try {
      final scheduleData = schedules.map((s) => s.toJson()).toList();
      await StorageService.setCacheJson('medication_cache', 'user_schedules', {
        'schedules': scheduleData,
        'cached_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.warning('Failed to cache schedules', {
        'error': e.toString(),
        'count': schedules.length,
      });
    }
  }

  /// Get cached schedules
  Future<List<MedicationSchedule>?> _getCachedSchedules() async {
    try {
      final data = await StorageService.getCacheJson(
        'medication_cache',
        'user_schedules',
      );
      if (data == null) return null;

      final schedules = data['schedules'] as List?;
      if (schedules == null) return null;

      return schedules
          .cast<Map<String, dynamic>>()
          .map((json) => MedicationSchedule.fromJson(json))
          .toList();
    } catch (e) {
      _logger.warning('Failed to get cached schedules', {
        'error': e.toString(),
      });
      return null;
    }
  }

  /// Clear schedule cache
  Future<void> _clearScheduleCache() async {
    try {
      await StorageService.removeCache('medication_cache', 'user_schedules');
    } catch (e) {
      _logger.warning('Failed to clear schedule cache', {
        'error': e.toString(),
      });
    }
  }
}

/// Provider for schedule repository
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  final apiService = ref.read(medicationApiServiceProvider);
  return ScheduleRepository(apiService);
});
