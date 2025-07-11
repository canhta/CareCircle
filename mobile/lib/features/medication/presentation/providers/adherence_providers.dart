import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';

import '../../infrastructure/repositories/adherence_repository.dart';

// Healthcare-compliant logger for adherence context
final _logger = BoundedContextLoggers.medication;

/// Provider for user adherence records
final adherenceRecordsProvider = FutureProvider<List<AdherenceRecord>>((ref) async {
  final repository = ref.read(adherenceRepositoryProvider);
  return repository.getAdherenceRecords();
});

/// Provider for adherence records by medication ID
final medicationAdherenceProvider = FutureProvider.family<List<AdherenceRecord>, String>((ref, medicationId) async {
  final repository = ref.read(adherenceRepositoryProvider);
  return repository.getAdherenceForMedication(medicationId);
});

/// Provider for adherence statistics
final adherenceStatisticsProvider = FutureProvider<AdherenceStatistics>((ref) async {
  final repository = ref.read(adherenceRepositoryProvider);
  return repository.getAdherenceStatistics();
});

/// Provider for today's adherence records
final todayAdherenceProvider = FutureProvider<List<AdherenceRecord>>((ref) async {
  final allRecords = await ref.read(adherenceRecordsProvider.future);
  final today = DateTime.now();

  final todayRecords = allRecords.where((record) {
    final recordDate = record.scheduledTime;
    return recordDate.year == today.year && recordDate.month == today.month && recordDate.day == today.day;
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
  final repository = ref.read(adherenceRepositoryProvider);
  final endDate = DateTime.now();
  final startDate = endDate.subtract(const Duration(days: 30));

  _logger.info('Fetching adherence trends', {
    'operation': 'getAdherenceTrends',
    'startDate': startDate.toIso8601String().split('T')[0],
    'endDate': endDate.toIso8601String().split('T')[0],
    'timestamp': DateTime.now().toIso8601String(),
  });

  try {
    // Get adherence records for the date range
    final records = await repository.getAdherenceRecords(
      params: AdherenceQueryParams(startDate: startDate, endDate: endDate),
    );

    // Group records by date and calculate daily adherence rates
    final Map<DateTime, List<AdherenceRecord>> recordsByDate = {};
    for (final record in records) {
      final date = DateTime(record.scheduledTime.year, record.scheduledTime.month, record.scheduledTime.day);
      recordsByDate.putIfAbsent(date, () => []).add(record);
    }

    // Create trend points for each day
    final trendPoints = <AdherenceTrendPoint>[];
    for (int i = 0; i < 30; i++) {
      final date = startDate.add(Duration(days: i));
      final dayRecords = recordsByDate[DateTime(date.year, date.month, date.day)] ?? [];

      final totalDoses = dayRecords.length;
      final completedDoses = dayRecords.where((r) => r.status == DoseStatus.taken).length;
      final adherenceRate = totalDoses > 0 ? completedDoses / totalDoses : 0.0;

      trendPoints.add(
        AdherenceTrendPoint(
          date: date,
          adherenceRate: adherenceRate,
          totalDoses: totalDoses,
          completedDoses: completedDoses,
        ),
      );
    }

    _logger.info('Adherence trends calculated successfully', {
      'operation': 'getAdherenceTrends',
      'trendPointCount': trendPoints.length,
      'totalRecords': records.length,
      'timestamp': DateTime.now().toIso8601String(),
    });

    return trendPoints;
  } catch (error) {
    _logger.error('Failed to fetch adherence trends', {
      'operation': 'getAdherenceTrends',
      'error': error.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Return empty list on error to prevent UI crashes
    return <AdherenceTrendPoint>[];
  }
});

/// Provider for adherence management operations
final adherenceManagementProvider = StateNotifierProvider<AdherenceManagementNotifier, AsyncValue<void>>((ref) {
  final repository = ref.read(adherenceRepositoryProvider);
  return AdherenceManagementNotifier(repository, ref);
});

/// State notifier for adherence management operations
class AdherenceManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final AdherenceRepository _repository;
  final Ref _ref;

  AdherenceManagementNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  /// Record dose taken
  Future<void> recordDoseTaken(
    String medicationId,
    String scheduleId,
    DateTime scheduledTime,
    double dosage,
    String unit, {
    String? notes,
  }) async {
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

      await _repository.createAdherenceRecord(request);

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
  Future<void> recordDoseMissed(
    String medicationId,
    String scheduleId,
    DateTime scheduledTime,
    double dosage,
    String unit, {
    String? reason,
  }) async {
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

      await _repository.createAdherenceRecord(request);

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
  Future<void> recordDoseSkipped(
    String medicationId,
    String scheduleId,
    DateTime scheduledTime,
    double dosage,
    String unit, {
    String? reason,
  }) async {
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

      await _repository.createAdherenceRecord(request);

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
