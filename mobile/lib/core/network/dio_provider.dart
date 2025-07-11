import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../logging/bounded_context_loggers.dart';
import '../../features/auth/infrastructure/services/firebase_auth_service.dart';
import 'performance_dio_interceptor.dart';

/// Healthcare-compliant Dio instance provider with Firebase authentication
///
/// This provider creates a configured Dio instance with:
/// - Firebase ID token authentication
/// - Performance monitoring
/// - Healthcare-compliant logging
/// - Proper timeout configurations
/// - Error handling interceptors
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add Firebase authentication interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final firebaseAuthService = FirebaseAuthService();
          final idToken = await firebaseAuthService.getIdToken();
          if (idToken != null) {
            options.headers['Authorization'] = 'Bearer $idToken';
          }
        } catch (e) {
          BoundedContextLoggers.auth.warning(
            'Failed to get Firebase ID token',
            {
              'error': e.toString(),
              'path': options.path,
              'method': options.method,
            },
          );
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Handle authentication errors
        if (error.response?.statusCode == 401) {
          BoundedContextLoggers.auth.warning('Authentication error detected', {
            'statusCode': error.response?.statusCode,
            'path': error.requestOptions.path,
            'method': error.requestOptions.method,
          });
        }
        handler.next(error);
      },
    ),
  );

  // Add performance monitoring interceptor
  dio.interceptors.add(PerformanceDioInterceptor());

  // Add logging interceptor for debugging
  if (AppConfig.isDevelopment) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false, // Don't log request body for privacy
        responseBody: false, // Don't log response body for privacy
        requestHeader: false, // Don't log headers for security
        responseHeader: false,
        logPrint: (object) {
          BoundedContextLoggers.network.debug('HTTP Request/Response', {
            'message': object.toString(),
          });
        },
      ),
    );
  }

  return dio;
});

/// Medication-specific Dio provider with extended timeouts for OCR operations
final medicationDioProvider = Provider<Dio>((ref) {
  final baseDio = ref.read(dioProvider);

  // Clone the base Dio instance with medication-specific configurations
  final medicationDio = Dio(
    BaseOptions(
      baseUrl: baseDio.options.baseUrl,
      connectTimeout: const Duration(seconds: 60), // Extended for OCR
      receiveTimeout: const Duration(seconds: 120), // Extended for OCR
      sendTimeout: const Duration(seconds: 60), // Extended for file uploads
      headers: baseDio.options.headers,
    ),
  );

  // Copy all interceptors from base Dio
  medicationDio.interceptors.addAll(baseDio.interceptors);

  return medicationDio;
});

/// Health data specific Dio provider with optimized timeouts
final healthDataDioProvider = Provider<Dio>((ref) {
  final baseDio = ref.read(dioProvider);

  // Clone the base Dio instance with health data specific configurations
  final healthDataDio = Dio(
    BaseOptions(
      baseUrl: baseDio.options.baseUrl,
      connectTimeout: const Duration(seconds: 15), // Faster for health metrics
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 15),
      headers: baseDio.options.headers,
    ),
  );

  // Copy all interceptors from base Dio
  healthDataDio.interceptors.addAll(baseDio.interceptors);

  return healthDataDio;
});

/// Care group specific Dio provider with real-time optimizations
final careGroupDioProvider = Provider<Dio>((ref) {
  final baseDio = ref.read(dioProvider);

  // Clone the base Dio instance with care group specific configurations
  final careGroupDio = Dio(
    BaseOptions(
      baseUrl: baseDio.options.baseUrl,
      connectTimeout: const Duration(
        seconds: 10,
      ), // Fast for real-time features
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 10),
      headers: baseDio.options.headers,
    ),
  );

  // Copy all interceptors from base Dio
  careGroupDio.interceptors.addAll(baseDio.interceptors);

  return careGroupDio;
});
