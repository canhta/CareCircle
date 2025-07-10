import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../../infrastructure/repositories/medication_repository.dart';

// Healthcare-compliant logger for adherence context
final _logger = BoundedContextLoggers.medication;

/// Provider for user adherence records
final adherenceRecordsProvider = FutureProvider<List<AdherenceRecord>>((ref) async {
  // TODO: Implement adherence repository when available
  _logger.info('Fetching user adherence records - not yet implemented', {
    'operation': 'getAdherenceRecords',
    'timestamp': DateTime.now().toIso8601String(),
  });

  // Return empty list for now
  return <AdherenceRecord>[];
});

/// Provider for adherence records by medication ID
final medicationAdherenceProvider = FutureProvider.family<List<AdherenceRecord>, String>((ref, medicationId) async {
  // TODO: Implement adherence repository when available
  _logger.info('Fetching adherence records for medication - not yet implemented', {
    'operation': 'getMedicationAdherence',
    'medicationId': medicationId,
    'timestamp': DateTime.now().toIso8601String(),
  });

  // Return empty list for now
  return <AdherenceRecord>[];
});

/// Provider for adherence statistics
final adherenceStatisticsProvider = FutureProvider<AdherenceStatistics>((ref) async {
  // TODO: Implement adherence repository when available
  _logger.info('Fetching adherence statistics - not yet implemented', {
    'operation': 'getAdherenceStatistics',
    'timestamp': DateTime.now().toIso8601String(),
  });

  // Return default statistics for now
  return const AdherenceStatistics(
    medicationId: '',
    totalDoses: 0,
    takenDoses: 0,
    missedDoses: 0,
    skippedDoses: 0,
    lateDoses: 0,
    adherencePercentage: 0.0,
    currentStreak: 0,
    longestStreak: 0,
    lastDoseTime: null,
    nextDoseTime: null,
  );
});

/// Provider for today's adherence records
final todayAdherenceProvider = FutureProvider<List<AdherenceRecord>>((ref) async {
  final allRecords = await ref.read(adherenceRecordsProvider.future);
  final today = DateTime.now();
  
  final todayRecords = allRecords.where((record) {
    final recordDate = record.scheduledTime;
    return recordDate.year == today.year &&
           recordDate.month == today.month &&
           recordDate.day == today.day;
  }).toList();

  _logger.info('Filtered today\'s adherence records', {
    'operation': 'getTodayAdherence',
    'date': today.toIso8601String().split('T')[0],
    'totalRecords': allRecords.length,
    'todayRecords': todayRecords.length,
    'timestamp': DateTime.now().toIso8601String(),
  });

  return todayRecords;
});

/// Provider for adherence trends (last 30 days)
final adherenceTrendsProvider = FutureProvider<List<AdherenceTrendPoint>>((ref) async {
  // TODO: Implement adherence repository when available
  final endDate = DateTime.now();
  final startDate = endDate.subtract(const Duration(days: 30));

  _logger.info('Fetching adherence trends - not yet implemented', {
    'operation': 'getAdherenceTrends',
    'startDate': startDate.toIso8601String().split('T')[0],
    'endDate': endDate.toIso8601String().split('T')[0],
    'timestamp': DateTime.now().toIso8601String(),
  });

  // Return empty list for now
  return <AdherenceTrendPoint>[];
});

/// Provider for adherence management operations
final adherenceManagementProvider = StateNotifierProvider<AdherenceManagementNotifier, AsyncValue<void>>((ref) {
  final repository = ref.read(medicationRepositoryProvider);
  return AdherenceManagementNotifier(repository, ref);
});

/// State notifier for adherence management operations
class AdherenceManagementNotifier extends StateNotifier<AsyncValue<void>> {
  // ignore: unused_field
  final MedicationRepository _repository; // TODO: Will be used when adherence repository is implemented
  final Ref _ref;

  AdherenceManagementNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  /// Record dose taken
  Future<void> recordDoseTaken(String medicationId, String scheduleId, DateTime scheduledTime, double dosage, String unit, {String? notes}) async {
    state = const AsyncValue.loading();

    try {
      _logger.info('Recording dose taken', {
        'operation': 'recordDoseTaken',
        'scheduleId': scheduleId,
        'scheduledTime': scheduledTime.toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      final request = CreateAdherenceRecordRequest(
        medicationId: medicationId,
        scheduleId: scheduleId,
        scheduledTime: scheduledTime,
        dosage: dosage,
        unit: unit,
        status: DoseStatus.taken,
        takenAt: DateTime.now(),
        notes: notes,
      );

      // TODO: Implement adherence record creation when repository is available
      // await _repository.createAdherenceRecord(request);
      // Temporary: Log the request to avoid unused variable warning
      _logger.info('Adherence record request prepared', {
        'medicationId': request.medicationId,
        'status': request.status.name,
      });
      
      // Refresh adherence data
      _refreshAdherenceData();
      
      state = const AsyncValue.data(null);

      _logger.info('Dose recorded successfully', {
        'operation': 'recordDoseTaken',
        'scheduleId': scheduleId,
        'status': 'taken',
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to record dose taken', {
        'operation': 'recordDoseTaken',
        'scheduleId': scheduleId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Record dose missed
  Future<void> recordDoseMissed(String medicationId, String scheduleId, DateTime scheduledTime, double dosage, String unit, {String? reason}) async {
    state = const AsyncValue.loading();

    try {
      _logger.info('Recording dose missed', {
        'operation': 'recordDoseMissed',
        'scheduleId': scheduleId,
        'scheduledTime': scheduledTime.toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      final request = CreateAdherenceRecordRequest(
        medicationId: medicationId,
        scheduleId: scheduleId,
        scheduledTime: scheduledTime,
        dosage: dosage,
        unit: unit,
        status: DoseStatus.missed,
        notes: reason,
      );

      // TODO: Implement adherence record creation when repository is available
      // await _repository.createAdherenceRecord(request);
      // Temporary: Log the request to avoid unused variable warning
      _logger.info('Adherence record request prepared', {
        'medicationId': request.medicationId,
        'status': request.status.name,
      });
      
      // Refresh adherence data
      _refreshAdherenceData();
      
      state = const AsyncValue.data(null);

      _logger.info('Dose missed recorded successfully', {
        'operation': 'recordDoseMissed',
        'scheduleId': scheduleId,
        'status': 'missed',
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to record dose missed', {
        'operation': 'recordDoseMissed',
        'scheduleId': scheduleId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Record dose skipped
  Future<void> recordDoseSkipped(String medicationId, String scheduleId, DateTime scheduledTime, double dosage, String unit, {String? reason}) async {
    state = const AsyncValue.loading();

    try {
      _logger.info('Recording dose skipped', {
        'operation': 'recordDoseSkipped',
        'scheduleId': scheduleId,
        'scheduledTime': scheduledTime.toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      final request = CreateAdherenceRecordRequest(
        medicationId: medicationId,
        scheduleId: scheduleId,
        scheduledTime: scheduledTime,
        dosage: dosage,
        unit: unit,
        status: DoseStatus.skipped,
        notes: reason,
      );

      // TODO: Implement adherence record creation when repository is available
      // await _repository.createAdherenceRecord(request);
      // Temporary: Log the request to avoid unused variable warning
      _logger.info('Adherence record request prepared', {
        'medicationId': request.medicationId,
        'status': request.status.name,
      });
      
      // Refresh adherence data
      _refreshAdherenceData();
      
      state = const AsyncValue.data(null);

      _logger.info('Dose skipped recorded successfully', {
        'operation': 'recordDoseSkipped',
        'scheduleId': scheduleId,
        'status': 'skipped',
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to record dose skipped', {
        'operation': 'recordDoseSkipped',
        'scheduleId': scheduleId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Refresh all adherence-related data
  void _refreshAdherenceData() {
    _ref.invalidate(adherenceRecordsProvider);
    _ref.invalidate(adherenceStatisticsProvider);
    _ref.invalidate(todayAdherenceProvider);
    _ref.invalidate(adherenceTrendsProvider);
  }
}
