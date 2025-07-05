import '../../../common/common.dart';
import '../domain/firebase_api_models.dart';
import '../domain/firebase_api_repository.dart';

/// Firebase API service implementation
class FirebaseApiService extends BaseRepository
    implements FirebaseApiRepository {
  bool _isInitialized = false;

  FirebaseApiService({
    required super.apiClient,
    required super.logger,
  });

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<Result<void>> initialize() async {
    try {
      logger.info('Initializing Firebase API service');

      // Initialize service
      _isInitialized = true;

      logger.info('Firebase API service initialized successfully');
      return const Result.success(null);
    } catch (e) {
      logger.error('Failed to initialize Firebase API service', error: e);
      return Result.failure(
        NetworkException('Failed to initialize Firebase API service: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> dispose() async {
    try {
      logger.info('Disposing Firebase API service');
      _isInitialized = false;
      return const Result.success(null);
    } catch (e) {
      logger.error('Failed to dispose Firebase API service', error: e);
      return Result.failure(
        NetworkException('Failed to dispose Firebase API service: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<TokenRegistrationResult>> registerToken({
    required String token,
    required DeviceInfo deviceInfo,
    bool overrideExisting = false,
  }) async {
    try {
      logger.info('Registering FCM token');

      final response = await apiClient.post(
        '/api/v1/firebase/register-token',
        data: {
          'token': token,
          'deviceInfo': deviceInfo.toJson(),
          'overrideExisting': overrideExisting,
        },
      );

      final result = TokenRegistrationResult.success(
        message: response.data['message'] as String?,
      );
      logger.info('FCM token registered successfully');
      return Result.success(result);
    } catch (e) {
      logger.error('Failed to register FCM token', error: e);
      return Result.failure(
        NetworkException('Failed to register FCM token: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> removeToken(String token) async {
    try {
      logger.info('Removing FCM token');

      await apiClient.delete('/api/v1/firebase/token/$token');

      logger.info('FCM token removed successfully');
      return const Result.success(null);
    } catch (e) {
      logger.error('Failed to remove FCM token', error: e);
      return Result.failure(
        NetworkException('Failed to remove FCM token: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<List<String>>> getUserTokens({bool activeOnly = true}) async {
    try {
      logger.info('Getting user tokens');

      final response = await apiClient.get(
        '/api/v1/firebase/tokens',
        queryParameters: {'activeOnly': activeOnly},
      );

      final tokens = List<String>.from(response.data['tokens'] ?? []);
      logger.info('Retrieved ${tokens.length} tokens');
      return Result.success(tokens);
    } catch (e) {
      logger.error('Failed to get user tokens', error: e);
      return Result.failure(
        NetworkException('Failed to get user tokens: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<TopicSubscriptionResult>> subscribeToTopic({
    required String topic,
    String? token,
  }) async {
    try {
      logger.info('Subscribing to topic: $topic');

      final response = await apiClient.post(
        '/api/v1/firebase/subscribe',
        data: {
          'topic': topic,
          if (token != null) 'token': token,
        },
      );

      final result = TopicSubscriptionResult.success(
        message: response.data['message'] as String?,
      );
      logger.info('Subscribed to topic successfully');
      return Result.success(result);
    } catch (e) {
      logger.error('Failed to subscribe to topic', error: e);
      return Result.failure(
        NetworkException('Failed to subscribe to topic: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<TopicSubscriptionResult>> unsubscribeFromTopic({
    required String topic,
    String? token,
  }) async {
    try {
      logger.info('Unsubscribing from topic: $topic');

      final response = await apiClient.post(
        '/api/v1/firebase/unsubscribe',
        data: {
          'topic': topic,
          if (token != null) 'token': token,
        },
      );

      final result = TopicSubscriptionResult.success(
        message: response.data['message'] as String?,
      );
      logger.info('Unsubscribed from topic successfully');
      return Result.success(result);
    } catch (e) {
      logger.error('Failed to unsubscribe from topic', error: e);
      return Result.failure(
        NetworkException('Failed to unsubscribe from topic: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<TestNotificationResult>> sendTestNotification({
    required TestNotification notification,
    String? targetToken,
  }) async {
    try {
      logger.info('Sending test notification');

      final response = await apiClient.post(
        '/api/v1/firebase/send-test',
        data: {
          'notification': notification.toJson(),
          if (targetToken != null) 'targetToken': targetToken,
        },
      );

      final result = TestNotificationResult.success(
        message: response.data['message'] as String?,
        notificationId: response.data['notificationId'] as String?,
        recipientCount: response.data['recipientCount'] as int?,
      );
      logger.info('Test notification sent successfully');
      return Result.success(result);
    } catch (e) {
      logger.error('Failed to send test notification', error: e);
      return Result.failure(
        NetworkException('Failed to send test notification: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<CleanupResult>> cleanupTokens() async {
    try {
      logger.info('Cleaning up tokens');

      final response = await apiClient.post('/api/v1/firebase/cleanup');

      final result = CleanupResult.success(
        cleanedTokensCount: response.data['cleanedCount'] as int? ?? 0,
      );
      logger.info('Token cleanup completed');
      return Result.success(result);
    } catch (e) {
      logger.error('Failed to cleanup tokens', error: e);
      return Result.failure(
        NetworkException('Failed to cleanup tokens: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<ServiceHealthResult>> getServiceHealth() async {
    try {
      logger.info('Getting service health');

      final response = await apiClient.get('/api/v1/firebase/health');

      final health = ServiceHealth(
        healthy: true,
        status: response.data['status'] as String? ?? 'healthy',
        timestamp: DateTime.now(),
        details: response.data['details'] as Map<String, dynamic>?,
      );

      final result = ServiceHealthResult.success(health);
      logger.info('Service health retrieved successfully');
      return Result.success(result);
    } catch (e) {
      logger.error('Failed to get service health', error: e);
      return Result.failure(
        NetworkException('Failed to get service health: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<DeviceInfo>> getDeviceInfo() async {
    try {
      logger.info('Getting device info');

      // In a real implementation, this would gather device information
      final deviceInfo = DeviceInfo(
        deviceId: 'device-id',
        platform: 'flutter',
        appVersion: '1.0.0',
        locale: 'en',
        timezone: 'UTC',
      );

      logger.info('Device info retrieved successfully');
      return Result.success(deviceInfo);
    } catch (e) {
      logger.error('Failed to get device info', error: e);
      return Result.failure(
        NetworkException('Failed to get device info: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }
}
