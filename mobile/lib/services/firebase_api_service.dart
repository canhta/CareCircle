import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../services/auth_service.dart';

/// API service for Firebase token management with retry logic,
/// error handling, and offline support
class FirebaseApiService {
  static final FirebaseApiService _instance =
      FirebaseApiService._internal();
  factory FirebaseApiService() => _instance;
  FirebaseApiService._internal();

  late final Dio _dio;
  final AuthService _authService = AuthService();

  // Retry configuration
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);
  static const Duration _requestTimeout = Duration(seconds: 15);

  /// Initialize the service
  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: '${AppConfig.apiBaseUrl}/firebase',
      connectTimeout: _requestTimeout,
      receiveTimeout: _requestTimeout,
      sendTimeout: _requestTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(_createAuthInterceptor());
    _dio.interceptors.add(_createRetryInterceptor());
    
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (log) => debugPrint('[Firebase API] $log'),
      ));
    }
  }

  /// Register FCM token with enhanced device info
  Future<TokenRegistrationResult> registerToken({
    required String token,
    Map<String, dynamic>? deviceInfo,
  }) async {
    try {
      final enhancedDeviceInfo = await _buildEnhancedDeviceInfo(deviceInfo);
      
      final response = await _executeWithRetry(() async {
        return await _dio.post(
          '/tokens/register',
          data: {
            'token': token,
            'deviceType': Platform.isIOS ? 'ios' : 'android',
            'deviceInfo': enhancedDeviceInfo,
          },
        );
      });

      if (response.statusCode == 201) {
        final result = TokenRegistrationResult.fromJson(response.data['data']);
        await _cacheTokenRegistration(token, result);
        return result;
      } else {
        throw ApiException(
          'Failed to register token: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('Error registering FCM token: $e');
      rethrow;
    }
  }

  /// Remove FCM token
  Future<void> removeToken(String token) async {
    try {
      final response = await _executeWithRetry(() async {
        return await _dio.delete(
          '/tokens/remove',
          data: {'token': token},
        );
      });

      if (response.statusCode == 200) {
        await _removeCachedToken(token);
        debugPrint('FCM token removed successfully');
      } else {
        throw ApiException(
          'Failed to remove token: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('Error removing FCM token: $e');
      rethrow;
    }
  }

  /// Get user FCM tokens
  Future<List<String>> getUserTokens({bool activeOnly = true}) async {
    try {
      final response = await _executeWithRetry(() async {
        return await _dio.get(
          '/tokens',
          queryParameters: {'active': activeOnly},
        );
      });

      if (response.statusCode == 200) {
        final List<dynamic> tokens = response.data['data']['tokens'];
        return tokens.cast<String>();
      } else {
        throw ApiException(
          'Failed to get tokens: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('Error getting user tokens: $e');
      rethrow;
    }
  }

  /// Subscribe to notification topic
  Future<TopicSubscriptionResult> subscribeToTopic({
    required String topic,
    List<String>? tokens,
  }) async {
    try {
      final response = await _executeWithRetry(() async {
        return await _dio.post(
          '/topics/subscribe',
          data: {
            'topic': topic,
            if (tokens != null) 'tokens': tokens,
          },
        );
      });

      if (response.statusCode == 200) {
        final result = TopicSubscriptionResult.fromJson(response.data);
        await _cacheTopicSubscription(topic, true);
        return result;
      } else {
        throw ApiException(
          'Failed to subscribe to topic: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
      rethrow;
    }
  }

  /// Unsubscribe from notification topic
  Future<TopicSubscriptionResult> unsubscribeFromTopic({
    required String topic,
    List<String>? tokens,
  }) async {
    try {
      final response = await _executeWithRetry(() async {
        return await _dio.post(
          '/topics/unsubscribe',
          data: {
            'topic': topic,
            if (tokens != null) 'tokens': tokens,
          },
        );
      });

      if (response.statusCode == 200) {
        final result = TopicSubscriptionResult.fromJson(response.data);
        await _cacheTopicSubscription(topic, false);
        return result;
      } else {
        throw ApiException(
          'Failed to unsubscribe from topic: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
      rethrow;
    }
  }

  /// Send test notification
  Future<TestNotificationResult> sendTestNotification({
    String? message,
    bool includeDeviceInfo = false,
  }) async {
    try {
      final response = await _executeWithRetry(() async {
        return await _dio.post(
          '/test-notification',
          data: {
            if (message != null) 'message': message,
            'includeDeviceInfo': includeDeviceInfo,
          },
        );
      });

      if (response.statusCode == 200) {
        return TestNotificationResult.fromJson(response.data['data']);
      } else {
        throw ApiException(
          'Failed to send test notification: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('Error sending test notification: $e');
      rethrow;
    }
  }

  /// Clean up invalid tokens
  Future<CleanupResult> cleanupTokens() async {
    try {
      final response = await _executeWithRetry(() async {
        return await _dio.post('/tokens/cleanup');
      });

      if (response.statusCode == 200) {
        return CleanupResult.fromJson(response.data['data']);
      } else {
        throw ApiException(
          'Failed to cleanup tokens: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('Error cleaning up tokens: $e');
      rethrow;
    }
  }

  /// Get Firebase service health
  Future<ServiceHealthResult> getServiceHealth() async {
    try {
      final response = await _executeWithRetry(() async {
        return await _dio.get('/health');
      });

      if (response.statusCode == 200) {
        return ServiceHealthResult.fromJson(response.data['data']);
      } else {
        throw ApiException(
          'Failed to get service health: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('Error getting service health: $e');
      rethrow;
    }
  }

  // Helper methods
  Future<Map<String, dynamic>> _buildEnhancedDeviceInfo(
    Map<String, dynamic>? additionalInfo,
  ) async {
    final deviceInfo = <String, dynamic>{
      'platform': Platform.operatingSystem,
      'osVersion': Platform.operatingSystemVersion,
      'appVersion': await _getAppVersion(),
      'timestamp': DateTime.now().toIso8601String(),
      'locale': Platform.localeName,
      'timezone': DateTime.now().timeZoneName,
    };

    if (additionalInfo != null) {
      deviceInfo.addAll(additionalInfo);
    }

    return deviceInfo;
  }

  Future<String> _getAppVersion() async {
    // TODO: Use package_info_plus to get actual app version
    return '1.0.0';
  }

  /// Execute operation with retry logic
  Future<Response> _executeWithRetry(Future<Response> Function() operation) async {
    Exception? lastException;

    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        return await operation();
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        debugPrint('Attempt $attempt failed: $e');

        if (attempt == _maxRetries) {
          break;
        }

        // Wait before retry with exponential backoff
        await Future.delayed(_retryDelay * attempt);
      }
    }

    throw lastException!;
  }

  /// Create auth interceptor
  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final token = await _authService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (e) {
          debugPrint('Error adding auth token: $e');
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Try to refresh token
          try {
            // Try to refresh the token (this might not be available publicly)
            // For now, we'll just retry with the existing token
            debugPrint('Auth failed, unable to refresh token automatically');
            final newToken = await _authService.getAccessToken();
            if (newToken != null) {
              // Retry the request with new token
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newToken';
              final cloneReq = await _dio.fetch(opts);
              handler.resolve(cloneReq);
              return;
            }
          } catch (e) {
            debugPrint('Error refreshing token: $e');
          }
        }
        handler.next(error);
      },
    );
  }

  /// Create retry interceptor
  Interceptor _createRetryInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        final statusCode = error.response?.statusCode;
        
        // Retry on specific error codes
        if (statusCode != null && 
            (statusCode >= 500 || statusCode == 408 || statusCode == 429)) {
          
          final retryCount = error.requestOptions.extra['retryCount'] ?? 0;
          
          if (retryCount < _maxRetries) {
            error.requestOptions.extra['retryCount'] = retryCount + 1;
            
            // Wait before retry
            await Future.delayed(_retryDelay * (retryCount + 1));
            
            try {
              final response = await _dio.fetch(error.requestOptions);
              handler.resolve(response);
              return;
            } catch (e) {
              // Continue to next error handler
            }
          }
        }
        
        handler.next(error);
      },
    );
  }

  // Caching methods
  Future<void> _cacheTokenRegistration(String token, TokenRegistrationResult result) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_token', token);
      await prefs.setString('token_registration_result', result.toJson().toString());
      await prefs.setString('token_cached_at', DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Error caching token registration: $e');
    }
  }

  Future<void> _removeCachedToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_token');
      await prefs.remove('token_registration_result');
      await prefs.remove('token_cached_at');
    } catch (e) {
      debugPrint('Error removing cached token: $e');
    }
  }

  Future<void> _cacheTopicSubscription(String topic, bool isSubscribed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subscriptions = prefs.getStringList('topic_subscriptions') ?? [];
      
      if (isSubscribed && !subscriptions.contains(topic)) {
        subscriptions.add(topic);
      } else if (!isSubscribed) {
        subscriptions.remove(topic);
      }
      
      await prefs.setStringList('topic_subscriptions', subscriptions);
    } catch (e) {
      debugPrint('Error caching topic subscription: $e');
    }
  }
}

// Result classes
class TokenRegistrationResult {
  final String tokenId;
  final bool isNewToken;

  TokenRegistrationResult({
    required this.tokenId,
    required this.isNewToken,
  });

  factory TokenRegistrationResult.fromJson(Map<String, dynamic> json) {
    return TokenRegistrationResult(
      tokenId: json['tokenId'] as String,
      isNewToken: json['isNewToken'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tokenId': tokenId,
      'isNewToken': isNewToken,
    };
  }
}

class TopicSubscriptionResult {
  final String topic;
  final int tokenCount;
  final String message;

  TopicSubscriptionResult({
    required this.topic,
    required this.tokenCount,
    required this.message,
  });

  factory TopicSubscriptionResult.fromJson(Map<String, dynamic> json) {
    return TopicSubscriptionResult(
      topic: json['data']['topic'] as String,
      tokenCount: json['data']['tokenCount'] as int,
      message: json['message'] as String,
    );
  }
}

class TestNotificationResult {
  final bool success;
  final int successCount;
  final int failureCount;
  final List<Map<String, dynamic>>? responses;
  final List<Map<String, dynamic>>? deviceInfo;

  TestNotificationResult({
    required this.success,
    required this.successCount,
    required this.failureCount,
    this.responses,
    this.deviceInfo,
  });

  factory TestNotificationResult.fromJson(Map<String, dynamic> json) {
    return TestNotificationResult(
      success: json['success'] as bool,
      successCount: json['successCount'] as int,
      failureCount: json['failureCount'] as int,
      responses: (json['responses'] as List?)?.cast<Map<String, dynamic>>(),
      deviceInfo: (json['deviceInfo'] as List?)?.cast<Map<String, dynamic>>(),
    );
  }
}

class CleanupResult {
  final int totalTokens;
  final int invalidTokens;
  final int cleanedUp;

  CleanupResult({
    required this.totalTokens,
    required this.invalidTokens,
    required this.cleanedUp,
  });

  factory CleanupResult.fromJson(Map<String, dynamic> json) {
    return CleanupResult(
      totalTokens: json['totalTokens'] as int,
      invalidTokens: json['invalidTokens'] as int,
      cleanedUp: json['cleanedUp'] as int,
    );
  }
}

class ServiceHealthResult {
  final bool isHealthy;
  final DateTime lastHealthCheck;
  final int totalTokens;
  final int activeTokens;
  final List<String> errors;

  ServiceHealthResult({
    required this.isHealthy,
    required this.lastHealthCheck,
    required this.totalTokens,
    required this.activeTokens,
    required this.errors,
  });

  factory ServiceHealthResult.fromJson(Map<String, dynamic> json) {
    return ServiceHealthResult(
      isHealthy: json['isHealthy'] as bool,
      lastHealthCheck: DateTime.parse(json['lastHealthCheck'] as String),
      totalTokens: json['totalTokens'] as int,
      activeTokens: json['activeTokens'] as int,
      errors: (json['errors'] as List).cast<String>(),
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
