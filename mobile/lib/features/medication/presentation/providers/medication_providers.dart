import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../../infrastructure/repositories/medication_repository.dart';
import '../../infrastructure/services/medication_notification_service.dart';

// Healthcare-compliant logger for medication context
final _logger = BoundedContextLoggers.medication;

/// Provider for user medications list
final medicationsProvider = FutureProvider<List<Medication>>((ref) async {
  final repository = ref.read(medicationRepositoryProvider);
  return repository.getMedications();
});

/// Provider for active medications only
final activeMedicationsProvider = FutureProvider<List<Medication>>((ref) async {
  final repository = ref.read(medicationRepositoryProvider);
  return repository.getMedications(params: const MedicationQueryParams(isActive: true));
});

/// Provider for inactive medications only
final inactiveMedicationsProvider = FutureProvider<List<Medication>>((ref) async {
  final repository = ref.read(medicationRepositoryProvider);
  return repository.getMedications(params: const MedicationQueryParams(isActive: false));
});

/// Provider for single medication by ID
final medicationProvider = FutureProvider.family<Medication?, String>((ref, id) async {
  final repository = ref.read(medicationRepositoryProvider);
  return repository.getMedicationById(id);
});

// TODO: Implement these providers when additional repository methods are added
// /// Provider for medication search results
// final medicationSearchProvider = FutureProvider.family<List<Medication>, String>((ref, searchTerm) async {
//   if (searchTerm.isEmpty) return [];
//
//   final repository = ref.read(medicationRepositoryProvider);
//   return repository.searchMedications(searchTerm, limit: 20);
// });

// /// Provider for user prescriptions
// final prescriptionsProvider = FutureProvider<List<Prescription>>((ref) async {
//   final repository = ref.read(medicationRepositoryProvider);
//   return repository.getUserPrescriptions();
// });

// /// Provider for adherence records
// final adherenceRecordsProvider = FutureProvider<List<AdherenceRecord>>((ref) async {
//   final repository = ref.read(medicationRepositoryProvider);
//   return repository.getAdherenceRecords();
// });

// /// Provider for adherence records by medication ID
// final medicationAdherenceProvider = FutureProvider.family<List<AdherenceRecord>, String>((ref, medicationId) async {
//   final repository = ref.read(medicationRepositoryProvider);
//   return repository.getAdherenceRecords(params: AdherenceQueryParams(medicationId: medicationId));
// });

/// State provider for selected medication
final selectedMedicationProvider = StateProvider<Medication?>((ref) => null);

/// State provider for medication filter parameters
final medicationFilterProvider = StateProvider<MedicationQueryParams>((ref) => const MedicationQueryParams());

/// State provider for medication search term
final medicationSearchTermProvider = StateProvider<String>((ref) => '');

/// State provider for medication form filter
final medicationFormFilterProvider = StateProvider<MedicationForm?>((ref) => null);

/// State provider for medication active status filter
final medicationActiveFilterProvider = StateProvider<bool?>((ref) => null);

/// Notifier for medication CRUD operations
class MedicationNotifier extends StateNotifier<AsyncValue<List<Medication>>> {
  final MedicationRepository _repository;
  final Ref _ref;

  MedicationNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    loadMedications();
  }

  Future<void> loadMedications() async {
    state = const AsyncValue.loading();
    try {
      final medications = await _repository.getMedications();
      state = AsyncValue.data(medications);

      _logger.logMedicationEvent('Medications loaded successfully', {
        'medicationCount': medications.length,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);

      _logger.error('Failed to load medications', {
        'error': error.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> createMedication(CreateMedicationRequest request) async {
    try {
      final newMedication = await _repository.createMedication(request);

      // Update state with new medication
      state.whenData((medications) {
        state = AsyncValue.data([...medications, newMedication]);
      });

      // Invalidate related providers to ensure data consistency
      _ref.invalidate(medicationsProvider);
      _ref.invalidate(activeMedicationsProvider);
      _ref.invalidate(medicationStatisticsProvider);

      _logger.logMedicationEvent('Medication created successfully', {
        'medicationId': newMedication.id,
        'medicationName': newMedication.name,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (error) {
      _logger.error('Failed to create medication', {
        'medicationName': request.name,
        'error': error.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  Future<void> updateMedication(String id, UpdateMedicationRequest request) async {
    try {
      final updatedMedication = await _repository.updateMedication(id, request);

      // Update state with updated medication
      state.whenData((medications) {
        final updatedList = medications.map((med) => med.id == id ? updatedMedication : med).toList();
        state = AsyncValue.data(List<Medication>.from(updatedList));
      });

      // Invalidate related providers to ensure data consistency
      _ref.invalidate(medicationsProvider);
      _ref.invalidate(activeMedicationsProvider);
      _ref.invalidate(inactiveMedicationsProvider);
      _ref.invalidate(medicationStatisticsProvider);

      _logger.logMedicationEvent('Medication updated successfully', {
        'medicationId': updatedMedication.id,
        'medicationName': updatedMedication.name,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (error) {
      _logger.error('Failed to update medication', {
        'medicationId': id,
        'error': error.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  Future<void> deleteMedication(String id) async {
    try {
      await _repository.deleteMedication(id);

      // Update state by removing deleted medication
      state.whenData((medications) {
        final updatedList = medications.where((med) => med.id != id).toList();
        state = AsyncValue.data(updatedList);
      });

      // Invalidate related providers to ensure data consistency
      _ref.invalidate(medicationsProvider);
      _ref.invalidate(activeMedicationsProvider);
      _ref.invalidate(inactiveMedicationsProvider);
      _ref.invalidate(medicationStatisticsProvider);

      _logger.logMedicationEvent('Medication deleted successfully', {
        'medicationId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (error) {
      _logger.error('Failed to delete medication', {
        'medicationId': id,
        'error': error.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  Future<void> refreshMedications() async {
    await loadMedications();
  }
}

/// Provider for medication notifier
final medicationNotifierProvider = StateNotifierProvider<MedicationNotifier, AsyncValue<List<Medication>>>((ref) {
  final repository = ref.read(medicationRepositoryProvider);
  return MedicationNotifier(repository, ref);
});

/// Computed provider for filtered medications
final filteredMedicationsProvider = Provider<AsyncValue<List<Medication>>>((ref) {
  final medications = ref.watch(medicationNotifierProvider);
  final searchTerm = ref.watch(medicationSearchTermProvider);
  final formFilter = ref.watch(medicationFormFilterProvider);
  final activeFilter = ref.watch(medicationActiveFilterProvider);

  return medications.when(
    data: (meds) {
      var filtered = meds.where((med) {
        // Search term filter
        if (searchTerm.isNotEmpty) {
          final searchLower = searchTerm.toLowerCase();
          if (!med.name.toLowerCase().contains(searchLower) &&
              !(med.genericName?.toLowerCase().contains(searchLower) ?? false)) {
            return false;
          }
        }

        // Form filter
        if (formFilter != null && med.form != formFilter) {
          return false;
        }

        // Active status filter
        if (activeFilter != null && med.isActive != activeFilter) {
          return false;
        }

        return true;
      }).toList();

      // Sort by name
      filtered.sort((a, b) => a.name.compareTo(b.name));

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

/// Provider for medication statistics
final medicationStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final medications = await ref.watch(medicationsProvider.future);

  final stats = {
    'total': medications.length,
    'active': medications.where((m) => m.isActive).length,
    'inactive': medications.where((m) => !m.isActive).length,
    'byForm': <String, int>{},
    'expiringSoon': medications
        .where((m) => m.endDate != null && m.endDate!.isBefore(DateTime.now().add(const Duration(days: 30))))
        .length,
  };

  // Count by form
  final byForm = stats['byForm'] as Map<String, int>;
  for (final med in medications) {
    final form = med.form.displayName;
    byForm[form] = (byForm[form] ?? 0) + 1;
  }

  return stats;
});

// ============================================================================
// NOTIFICATION PROVIDERS
// ============================================================================

/// Provider for medication notification service
final medicationNotificationServiceProvider = Provider<MedicationNotificationService>((ref) {
  return MedicationNotificationService();
});

/// Provider for notification initialization status
final notificationInitializationProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(medicationNotificationServiceProvider);
  final initialized = await service.initialize();

  if (initialized) {
    // Request permissions after initialization
    await service.requestPermissions();
  }

  return initialized;
});

/// Provider for pending notifications count
final pendingNotificationsCountProvider = FutureProvider<int>((ref) async {
  final service = ref.read(medicationNotificationServiceProvider);
  return service.getPendingNotificationsCount();
});

/// Provider for scheduling medication reminders
final scheduleReminderProvider = Provider<Future<bool> Function({
  required String medicationId,
  required String medicationName,
  required String dosage,
  required DateTime scheduledTime,
  String? instructions,
})>((ref) {
  final service = ref.read(medicationNotificationServiceProvider);

  return ({
    required String medicationId,
    required String medicationName,
    required String dosage,
    required DateTime scheduledTime,
    String? instructions,
  }) async {
    return service.scheduleMedicationReminder(
      medicationId: medicationId,
      medicationName: medicationName,
      dosage: dosage,
      scheduledTime: scheduledTime,
      instructions: instructions,
    );
  };
});
