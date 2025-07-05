import '../../../common/common.dart';
import 'firebase_api_models.dart';

/// Repository interface for Firebase API operations
abstract class FirebaseApiRepository {
  /// Initialize the service
  Future<Result<void>> initialize();

  /// Register FCM token with the backend
  Future<Result<TokenRegistrationResult>> registerToken({
    required String token,
    required DeviceInfo deviceInfo,
    bool overrideExisting = false,
  });

  /// Remove FCM token from the backend
  Future<Result<void>> removeToken(String token);

  /// Get user's registered tokens
  Future<Result<List<String>>> getUserTokens({bool activeOnly = true});

  /// Subscribe to a topic
  Future<Result<TopicSubscriptionResult>> subscribeToTopic({
    required String topic,
    String? token,
  });

  /// Unsubscribe from a topic
  Future<Result<TopicSubscriptionResult>> unsubscribeFromTopic({
    required String topic,
    String? token,
  });

  /// Send a test notification
  Future<Result<TestNotificationResult>> sendTestNotification({
    required TestNotification notification,
    String? targetToken,
  });

  /// Clean up expired or invalid tokens
  Future<Result<CleanupResult>> cleanupTokens();

  /// Check service health
  Future<Result<ServiceHealthResult>> getServiceHealth();

  /// Get enhanced device information
  Future<Result<DeviceInfo>> getDeviceInfo();

  /// Check if the service is initialized
  bool get isInitialized;

  /// Dispose resources
  Future<Result<void>> dispose();
}
