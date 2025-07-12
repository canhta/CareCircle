import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';

import '../../infrastructure/repositories/schedule_repository.dart';

// Healthcare-compliant logger for schedule context
final _logger = BoundedContextLoggers.medication;

/// Provider for user medication schedules
final schedulesProvider = FutureProvider<List<MedicationSchedule>>((ref) async {
  final repository = ref.read(scheduleRepositoryProvider);
  return repository.getSchedules();
});

/// Provider for schedules by medication ID
final medicationSchedulesProvider =
    FutureProvider.family<List<MedicationSchedule>, String>((
      ref,
      medicationId,
    ) async {
      final repository = ref.read(scheduleRepositoryProvider);
      return repository.getSchedulesForMedication(medicationId);
    });

/// Provider for schedule by ID
final scheduleProvider = FutureProvider.family<MedicationSchedule?, String>((
  ref,
  scheduleId,
) async {
  final repository = ref.read(scheduleRepositoryProvider);
  return repository.getScheduleById(scheduleId);
});

/// Provider for active schedules (schedules with reminders enabled)
final activeSchedulesProvider = FutureProvider<List<MedicationSchedule>>((
  ref,
) async {
  final allSchedules = await ref.read(schedulesProvider.future);

  final activeSchedules = allSchedules
      .where(
        (schedule) =>
            schedule.remindersEnabled &&
            (schedule.endDate == null ||
                schedule.endDate!.isAfter(DateTime.now())),
      )
      .toList();

  _logger.info('Filtered active schedules', {
    'operation': 'getActiveSchedules',
    'totalSchedules': allSchedules.length,
    'activeSchedules': activeSchedules.length,
    'timestamp': DateTime.now().toIso8601String(),
  });

  return activeSchedules;
});

/// Provider for today's scheduled doses
final todayScheduledDosesProvider = FutureProvider<List<MedicationSchedule>>((
  ref,
) async {
  final activeSchedules = await ref.read(activeSchedulesProvider.future);
  final today = DateTime.now();
  final todayStart = DateTime(today.year, today.month, today.day);
  final todayEnd = todayStart.add(const Duration(days: 1));

  // Filter schedules that are active today
  final todaySchedules = activeSchedules.where((schedule) {
    // Check if schedule is active today
    final scheduleStart = DateTime(
      schedule.startDate.year,
      schedule.startDate.month,
      schedule.startDate.day,
    );

    final scheduleEnd = schedule.endDate != null
        ? DateTime(
            schedule.endDate!.year,
            schedule.endDate!.month,
            schedule.endDate!.day,
          ).add(const Duration(days: 1))
        : null;

    // Schedule should start before or on today and end after today (or no end date)
    final isActiveToday = scheduleStart.isBefore(todayEnd) &&
        (scheduleEnd == null || scheduleEnd.isAfter(todayStart));

    return isActiveToday;
  }).toList();

  _logger.info('Generated today\'s scheduled doses', {
    'operation': 'getTodayScheduledDoses',
    'date': today.toIso8601String().split('T')[0],
    'totalSchedules': activeSchedules.length,
    'todaySchedules': todaySchedules.length,
    'timestamp': DateTime.now().toIso8601String(),
  });

  return todaySchedules;
});

/// Provider for schedule management operations
final scheduleManagementProvider =
    StateNotifierProvider<ScheduleManagementNotifier, AsyncValue<void>>((ref) {
      final repository = ref.read(scheduleRepositoryProvider);
      return ScheduleManagementNotifier(repository, ref);
    });

/// State notifier for schedule management operations
class ScheduleManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final ScheduleRepository _repository;
  final Ref _ref;

  ScheduleManagementNotifier(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  /// Create new medication schedule
  Future<void> createSchedule(CreateScheduleRequest request) async {
    state = const AsyncValue.loading();

    try {
      _logger.info('Creating medication schedule', {
        'operation': 'createSchedule',
        'medicationId': request.medicationId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _repository.createSchedule(request);

      // Refresh schedules
      _ref.invalidate(schedulesProvider);
      _ref.invalidate(medicationSchedulesProvider(request.medicationId));
      _ref.invalidate(activeSchedulesProvider);
      _ref.invalidate(todayScheduledDosesProvider);

      state = const AsyncValue.data(null);

      _logger.info('Medication schedule created successfully', {
        'operation': 'createSchedule',
        'medicationId': request.medicationId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to create medication schedule', {
        'operation': 'createSchedule',
        'medicationId': request.medicationId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Update existing medication schedule
  Future<void> updateSchedule(
    String scheduleId,
    UpdateScheduleRequest request,
  ) async {
    state = const AsyncValue.loading();

    try {
      _logger.info('Updating medication schedule', {
        'operation': 'updateSchedule',
        'scheduleId': scheduleId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _repository.updateSchedule(scheduleId, request);

      // Refresh schedules
      _ref.invalidate(schedulesProvider);
      _ref.invalidate(scheduleProvider(scheduleId));
      _ref.invalidate(activeSchedulesProvider);
      _ref.invalidate(todayScheduledDosesProvider);

      state = const AsyncValue.data(null);

      _logger.info('Medication schedule updated successfully', {
        'operation': 'updateSchedule',
        'scheduleId': scheduleId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to update medication schedule', {
        'operation': 'updateSchedule',
        'scheduleId': scheduleId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Delete medication schedule
  Future<void> deleteSchedule(String scheduleId) async {
    state = const AsyncValue.loading();

    try {
      _logger.info('Deleting medication schedule', {
        'operation': 'deleteSchedule',
        'scheduleId': scheduleId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _repository.deleteSchedule(scheduleId);

      // Refresh schedules
      _ref.invalidate(schedulesProvider);
      _ref.invalidate(scheduleProvider(scheduleId));
      _ref.invalidate(activeSchedulesProvider);
      _ref.invalidate(todayScheduledDosesProvider);

      state = const AsyncValue.data(null);

      _logger.info('Medication schedule deleted successfully', {
        'operation': 'deleteSchedule',
        'scheduleId': scheduleId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to delete medication schedule', {
        'operation': 'deleteSchedule',
        'scheduleId': scheduleId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// TODO: Implement ScheduledDose model and dose generation logic
// This would generate scheduled doses based on:
// - schedule.schedule.frequency
// - schedule.schedule.times
// - schedule.schedule.specificTimes
// - schedule.reminderTimes

/// Aliases for screen compatibility
final scheduleCreateProvider = scheduleManagementProvider;
final scheduleUpdateProvider = scheduleManagementProvider;
final scheduleDeleteProvider = scheduleManagementProvider;
