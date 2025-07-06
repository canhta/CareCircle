import 'package:get_it/get_it.dart';
import '../common/common.dart';
import '../features/auth/auth.dart';
import '../features/firebase_messaging/firebase_messaging.dart';
import '../features/background_sync/background_sync.dart';
import '../features/medication/data/medication_service.dart';
import '../features/health/data/health_service.dart';
import '../features/health/data/health_data_export_service.dart';
import '../managers/health_data_manager.dart';
import '../services/error_tracking_service.dart';
import '../utils/notification_manager.dart';
import '../utils/app_initializer.dart';
import '../utils/firebase_initializer.dart';
import '../utils/navigation_service.dart';
import '../utils/analytics_service.dart';

/// Service locator for dependency injection
/// Provides centralized access to all services and managers
class ServiceLocator {
  static final GetIt _instance = GetIt.instance;

  static GetIt get instance => _instance;

  /// Initialize all services and dependencies
  static Future<void> initialize() async {
    // Core services first
    await _registerCoreServices();

    // Firebase services
    await _registerFirebaseServices();

    // Feature services
    await _registerFeatureServices();

    // Managers
    await _registerManagers();

    // Utilities
    await _registerUtilities();
  }

  /// Register core services (logging, storage, networking)
  static Future<void> _registerCoreServices() async {
    // Logger - singleton, immediately available
    _instance.registerSingleton<AppLogger>(
      AppLogger()..initialize(isDevelopment: true),
    );

    // Navigation service - singleton, immediately available
    _instance.registerSingleton<NavigationService>(NavigationService());

    // Secure storage - async singleton (to support dependency chain)
    _instance.registerSingletonAsync<SecureStorageService>(
      () async {
        final secureStorage = SecureStorageService();
        secureStorage.initialize();
        return secureStorage;
      },
    );

    // API Client - async singleton with dependencies
    _instance.registerSingletonAsync<ApiClient>(
      () async {
        final apiClient = ApiClient.instance;
        await apiClient.initialize(
          secureStorage: await getAsync<SecureStorageService>(),
          logger: get<AppLogger>(),
        );
        return apiClient;
      },
      dependsOn: [SecureStorageService],
    );
  }

  /// Register Firebase-related services
  static Future<void> _registerFirebaseServices() async {
    // Firebase Initializer - async singleton
    _instance.registerSingletonAsync<FirebaseInitializer>(
      () async {
        final initializer = FirebaseInitializer();
        await initializer.initialize();
        return initializer;
      },
    );

    // Firebase Messaging Service - async singleton
    _instance.registerSingletonAsync<FirebaseMessagingService>(
      () async {
        final messagingService = FirebaseMessagingService(
          logger: get<AppLogger>(),
          secureStorage: await getAsync<SecureStorageService>(),
        );
        await messagingService.initialize();
        return messagingService;
      },
      dependsOn: [FirebaseInitializer, SecureStorageService],
    );
  }

  /// Register feature services (auth, background sync, etc.)
  static Future<void> _registerFeatureServices() async {
    // Auth Service - async singleton with dependencies
    _instance.registerSingletonAsync<AuthService>(
      () async => AuthService(
        apiClient: await getAsync<ApiClient>(),
        logger: get<AppLogger>(),
        secureStorage: await getAsync<SecureStorageService>(),
      ),
      dependsOn: [ApiClient, SecureStorageService],
    );

    // Medication Service - async singleton with dependencies
    _instance.registerSingletonAsync<MedicationService>(
      () async => MedicationService(
        apiClient: await getAsync<ApiClient>(),
        logger: get<AppLogger>(),
        secureStorage: await getAsync<SecureStorageService>(),
      ),
      dependsOn: [ApiClient, SecureStorageService],
    );

    // Health Service - async singleton with dependencies
    _instance.registerSingletonAsync<HealthService>(
      () async => HealthService(
        apiClient: await getAsync<ApiClient>(),
        logger: get<AppLogger>(),
        secureStorage: await getAsync<SecureStorageService>(),
      ),
      dependsOn: [ApiClient, SecureStorageService],
    );

    // Health Data Export Service - async singleton with dependencies
    _instance.registerSingletonAsync<HealthDataExportService>(
      () async => HealthDataExportService(
        apiClient: await getAsync<ApiClient>(),
        logger: get<AppLogger>(),
      ),
      dependsOn: [ApiClient],
    );

    // Background Sync Service - async singleton
    _instance.registerSingletonAsync<BackgroundSyncService>(
      () async {
        final syncService = BackgroundSyncService(
          apiClient: await getAsync<ApiClient>(),
          logger: get<AppLogger>(),
          secureStorage: await getAsync<SecureStorageService>(),
        );
        await syncService.initialize();
        return syncService;
      },
      dependsOn: [ApiClient, SecureStorageService],
    );
  }

  /// Register managers (health data, etc.)
  static Future<void> _registerManagers() async {
    // Health Data Manager - async singleton
    _instance.registerSingletonAsync<HealthDataManager>(
      () async {
        final healthManager = HealthDataManager();
        await healthManager.initialize();
        return healthManager;
      },
    );
  }

  /// Register utility services
  static Future<void> _registerUtilities() async {
    // Analytics Service - async singleton
    _instance.registerSingletonAsync<AnalyticsService>(
      () async {
        final analyticsService = AnalyticsService();
        await analyticsService.initialize();
        return analyticsService;
      },
    );

    // Error Tracking Service - async singleton
    _instance.registerSingletonAsync<ErrorTrackingService>(
      () async {
        final errorTrackingService = ErrorTrackingService(
          analytics: await getAsync<AnalyticsService>(),
          logger: get<AppLogger>(),
        );
        await errorTrackingService.initialize();
        return errorTrackingService;
      },
      dependsOn: [AnalyticsService],
    );

    // Notification Manager - async singleton
    _instance.registerSingletonAsync<NotificationManager>(
      () async {
        final notificationManager = NotificationManager(
          logger: get<AppLogger>(),
          messagingService: await getAsync<FirebaseMessagingService>(),
        );
        await notificationManager.initialize();
        return notificationManager;
      },
      dependsOn: [FirebaseMessagingService],
    );

    // App Initializer - async singleton (handles app-level initialization)
    _instance.registerSingletonAsync<AppInitializer>(
      () async {
        final initializer = AppInitializer();
        await initializer.initialize();
        return initializer;
      },
      dependsOn: [
        FirebaseInitializer,
        NotificationManager,
        BackgroundSyncService,
        HealthDataManager,
      ],
    );
  }

  /// Wait for all async services to be ready
  static Future<void> waitForInitialization() async {
    await _instance.allReady();
  }

  /// Get service instance
  static T get<T extends Object>() => _instance.get<T>();

  /// Get service instance async (for services still initializing)
  static Future<T> getAsync<T extends Object>() => _instance.getAsync<T>();

  /// Reset all services (useful for testing)
  static Future<void> reset() async {
    await _instance.reset();
  }
}
