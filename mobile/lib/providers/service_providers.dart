import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/service_locator.dart';
import '../common/common.dart';
import '../features/auth/auth.dart';
import '../features/daily_check_in/data/daily_check_in_service.dart';
import '../features/medication/data/medication_service.dart';
import '../features/health/data/health_service.dart';
import '../features/health/data/health_data_export_service.dart';
import '../features/prescription_scanner/data/prescription_scanner_service.dart';
import '../utils/notification_manager.dart';
import '../utils/analytics_service.dart';
import '../models/daily_check_in_models.dart';
import '../features/medication/domain/medication_models.dart';
import '../features/health/domain/health_models.dart';

/// Core service providers for dependency injection with Riverpod
/// These providers replace direct service instantiation in screens

// Core Services
final appLoggerProvider = Provider<AppLogger>((ref) {
  return ServiceLocator.get<AppLogger>();
});

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return ServiceLocator.get<SecureStorageService>();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ServiceLocator.get<ApiClient>();
});

// Authentication Services
final authServiceProvider = Provider<AuthService>((ref) {
  return ServiceLocator.get<AuthService>();
});

// Health Services
final dailyCheckInServiceProvider = Provider<DailyCheckInService>((ref) {
  return ServiceLocator.get<DailyCheckInService>();
});

final healthServiceProvider = Provider<HealthService>((ref) {
  return ServiceLocator.get<HealthService>();
});

final healthDataExportServiceProvider =
    Provider<HealthDataExportService>((ref) {
  return ServiceLocator.get<HealthDataExportService>();
});

// Medication Services
final medicationServiceProvider = Provider<MedicationService>((ref) {
  return ServiceLocator.get<MedicationService>();
});

final prescriptionScannerServiceProvider =
    Provider<PrescriptionScannerService>((ref) {
  return ServiceLocator.get<PrescriptionScannerService>();
});

// Utility Services
final notificationManagerProvider = Provider<NotificationManager>((ref) {
  return ServiceLocator.get<NotificationManager>();
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return ServiceLocator.get<AnalyticsService>();
});

// State Providers for common app state
final isLoadingProvider = StateProvider<bool>((ref) => false);

final errorMessageProvider = StateProvider<String?>((ref) => null);

// Auth State Providers
final currentUserProvider = StateProvider<User?>((ref) => null);

final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

// Daily Check-in State Providers
final todayCheckInProvider =
    FutureProvider.autoDispose<DailyCheckIn?>((ref) async {
  final service = ref.read(dailyCheckInServiceProvider);
  final result = await service.getTodayCheckIn();

  if (result.isSuccess) {
    return (result as Success<DailyCheckIn?>).data;
  } else {
    ref
        .read(appLoggerProvider)
        .error('Failed to load today\'s check-in', error: result.exception);
    return null;
  }
});

final recentCheckInsProvider =
    FutureProvider.autoDispose<List<DailyCheckIn>>((ref) async {
  final service = ref.read(dailyCheckInServiceProvider);
  final result = await service.getRecentCheckIns();

  if (result.isSuccess) {
    return (result as Success<List<DailyCheckIn>>).data;
  } else {
    ref
        .read(appLoggerProvider)
        .error('Failed to load recent check-ins', error: result.exception);
    return <DailyCheckIn>[];
  }
});

// Medication State Providers
final medicationsProvider =
    FutureProvider.autoDispose<List<Medication>>((ref) async {
  final service = ref.read(medicationServiceProvider);
  final result = await service.getMedications();

  return result.fold(
    (medications) => medications,
    (error) {
      ref
          .read(appLoggerProvider)
          .error('Failed to load medications', error: error);
      throw error;
    },
  );
});

// Health Data State Providers
final healthDataProvider = FutureProvider.autoDispose
    .family<List<CareCircleHealthData>, HealthDataRequest>(
        (ref, request) async {
  final service = ref.read(healthServiceProvider);
  final result = await service.getHealthData(request);

  return result.fold(
    (data) => data,
    (error) {
      ref
          .read(appLoggerProvider)
          .error('Failed to load health data', error: error);
      throw error;
    },
  );
});

// Helper classes for provider parameters

// Notification State Providers
final notificationSettingsProvider =
    FutureProvider.autoDispose<NotificationSettings>((ref) async {
  // This would typically load from user preferences or backend
  return const NotificationSettings(
    medicationReminders: true,
    checkInReminders: true,
    appointmentReminders: true,
    exerciseReminders: false,
  );
});

class NotificationSettings {
  final bool medicationReminders;
  final bool checkInReminders;
  final bool appointmentReminders;
  final bool exerciseReminders;

  const NotificationSettings({
    required this.medicationReminders,
    required this.checkInReminders,
    required this.appointmentReminders,
    required this.exerciseReminders,
  });

  NotificationSettings copyWith({
    bool? medicationReminders,
    bool? checkInReminders,
    bool? appointmentReminders,
    bool? exerciseReminders,
  }) {
    return NotificationSettings(
      medicationReminders: medicationReminders ?? this.medicationReminders,
      checkInReminders: checkInReminders ?? this.checkInReminders,
      appointmentReminders: appointmentReminders ?? this.appointmentReminders,
      exerciseReminders: exerciseReminders ?? this.exerciseReminders,
    );
  }
}

// User Preferences State Provider
final userPreferencesProvider =
    FutureProvider.autoDispose<UserPreferences>((ref) async {
  // This would typically load from secure storage or backend
  return const UserPreferences(
    theme: 'system',
    language: 'en',
    notifications: true,
    analytics: true,
  );
});

class UserPreferences {
  final String theme;
  final String language;
  final bool notifications;
  final bool analytics;

  const UserPreferences({
    required this.theme,
    required this.language,
    required this.notifications,
    required this.analytics,
  });

  UserPreferences copyWith({
    String? theme,
    String? language,
    bool? notifications,
    bool? analytics,
  }) {
    return UserPreferences(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      notifications: notifications ?? this.notifications,
      analytics: analytics ?? this.analytics,
    );
  }
}

// Error handling helper providers
final lastErrorProvider = StateProvider<Exception?>((ref) => null);

final retryCountProvider = StateProvider<int>((ref) => 0);

// Loading state management
final loadingStatesProvider = StateProvider<Map<String, bool>>((ref) => {});

// Helper function to set loading state for specific operations
void setLoadingState(WidgetRef ref, String operation, bool isLoading) {
  final currentStates = ref.read(loadingStatesProvider);
  ref.read(loadingStatesProvider.notifier).state = {
    ...currentStates,
    operation: isLoading,
  };
}

// Helper function to check if specific operation is loading
bool isOperationLoading(WidgetRef ref, String operation) {
  final states = ref.watch(loadingStatesProvider);
  return states[operation] ?? false;
}
