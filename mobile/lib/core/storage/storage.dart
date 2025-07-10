/// CareCircle Storage Infrastructure
///
/// Provides unified storage services for healthcare data with:
/// - Secure storage for PHI/PII data (flutter_secure_storage)
/// - Fast cache storage for non-sensitive data (Hive)
/// - Healthcare-compliant data handling
/// - Offline capabilities
///
/// Usage:
/// ```dart
/// // Initialize storage (call once at app startup)
/// await StorageService.initialize();
///
/// // Store sensitive data
/// await StorageService.setSecure('user_token', token);
///
/// // Cache non-sensitive data
/// await StorageService.setCache(HiveBoxNames.healthMetrics, 'key', data);
///
/// // Healthcare-specific convenience methods
/// await StorageService.setUserProfile(profileData);
/// await StorageService.cacheHealthMetrics(metricsData);
/// ```
library;

export 'storage_service.dart';
export 'secure_storage.dart';
export 'hive_storage.dart';
