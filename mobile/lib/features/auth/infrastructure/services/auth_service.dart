import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/auth_models.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/logging/logging.dart';
import 'firebase_auth_service.dart';

part 'auth_service.g.dart';

@riverpod
AuthService authService(Ref ref) {
  return AuthService();
}

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _userKey = 'user';
  static const _profileKey = 'profile';

  // Healthcare-compliant logger for authentication context
  static final _logger = BoundedContextLoggers.auth;

  late final Dio _dio;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  AuthService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add interceptor for automatic Firebase ID token attachment
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final idToken = await _firebaseAuthService.getIdToken();
          if (idToken != null) {
            options.headers['Authorization'] = 'Bearer $idToken';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Clear stored user data on authentication failure
            await clearStoredData();
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<AuthResponse> loginWithEmail(String email, String password) async {
    _logger.info('Email login initiated', {
      'method': 'email',
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _saveAuthData(authResponse);

      _logger.logAuthEvent('Email login successful', {
        'userId': authResponse.user.id,
        'method': 'email',
        'timestamp': DateTime.now().toIso8601String(),
      });

      return authResponse;
    } on DioException catch (e) {
      _logger.error('Email login failed', {
        'method': 'email',
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleDioError(e);
    }
  }

  Future<AuthResponse> loginWithFirebaseToken(String idToken) async {
    _logger.info('Firebase login initiated', {
      'method': 'firebase',
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      final response = await _dio.post(
        '/auth/firebase-login',
        data: {'idToken': idToken},
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _saveAuthData(authResponse);

      _logger.logAuthEvent('Firebase login successful', {
        'userId': authResponse.user.id,
        'method': 'firebase',
        'timestamp': DateTime.now().toIso8601String(),
      });

      return authResponse;
    } on DioException catch (e) {
      _logger.error('Firebase login failed', {
        'method': 'firebase',
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleDioError(e);
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _saveAuthData(authResponse);
      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<AuthResponse> registerWithFirebaseToken(
    String idToken,
    RegisterRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/firebase-register',
        data: {
          'idToken': idToken,
          'displayName': request.displayName,
          'firstName': request.firstName,
          'lastName': request.lastName,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _saveAuthData(authResponse);
      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<AuthResponse> loginAsGuest(String deviceId) async {
    try {
      // Get Firebase ID token from current anonymous user
      final idToken = await _firebaseAuthService.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token for guest user');
      }

      final response = await _dio.post(
        '/auth/guest',
        data: {
          'deviceId': deviceId,
          'idToken': idToken,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _saveAuthData(authResponse);
      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<AuthResponse> convertGuest({
    String? email,
    String? phoneNumber,
    String? password,
    String? displayName,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/convert-guest',
        data: {
          if (email != null) 'email': email,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
          if (password != null) 'password': password,
          if (displayName != null) 'displayName': displayName,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _saveAuthData(authResponse);
      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<AuthResponse> signInWithGoogle(String idToken) async {
    try {
      final response = await _dio.post(
        '/auth/oauth/google',
        data: {'idToken': idToken},
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _saveAuthData(authResponse);
      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<AuthResponse> signInWithApple(String idToken) async {
    try {
      final response = await _dio.post(
        '/auth/oauth/apple',
        data: {'idToken': idToken},
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _saveAuthData(authResponse);
      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<UserProfile> updateProfile(Map<String, dynamic> updates) async {
    try {
      final response = await _dio.put('/user/profile', data: updates);
      final profile = UserProfile.fromJson(response.data);
      await _saveProfile(profile);
      return profile;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/user/me');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> logout() async {
    _logger.info('Logout initiated', {
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      // Sign out from Firebase
      await _firebaseAuthService.signOut();

      _logger.logAuthEvent('Firebase logout successful', {
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.warning('Firebase logout failed, continuing with local logout', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      // Continue with local logout even if Firebase logout fails
    } finally {
      await clearStoredData();

      _logger.logAuthEvent('Local logout completed', {
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await Future.wait([
      _storage.write(
        key: _userKey,
        value: jsonEncode(authResponse.user.toJson()),
      ),
      if (authResponse.profile != null)
        _storage.write(
          key: _profileKey,
          value: jsonEncode(authResponse.profile!.toJson()),
        ),
    ]);
  }

  Future<void> _saveProfile(UserProfile profile) async {
    await _storage.write(key: _profileKey, value: jsonEncode(profile.toJson()));
  }

  Future<String?> getFirebaseIdToken() async {
    return await _firebaseAuthService.getIdToken();
  }

  Future<User?> getStoredUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<UserProfile?> getStoredProfile() async {
    final profileJson = await _storage.read(key: _profileKey);
    if (profileJson != null) {
      return UserProfile.fromJson(jsonDecode(profileJson));
    }
    return null;
  }

  Future<void> clearStoredData() async {
    await Future.wait([
      _storage.delete(key: _userKey),
      _storage.delete(key: _profileKey),
    ]);
  }

  Future<bool> isLoggedIn() async {
    return _firebaseAuthService.isSignedIn;
  }

  String _handleDioError(DioException e) {
    _logger.error('API Error: ${e.message}', e);

    // Handle specific HTTP status codes
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final responseData = e.response!.data;

      // Extract error message from response
      String? errorMessage;
      if (responseData is Map<String, dynamic>) {
        errorMessage = responseData['message'] ?? responseData['error'];
      }

      switch (statusCode) {
        case 400:
          return errorMessage ?? 'Invalid request. Please check your input.';
        case 401:
          return errorMessage ?? 'Authentication failed. Please sign in again.';
        case 403:
          return errorMessage ?? 'Access denied. You don\'t have permission to perform this action.';
        case 404:
          return errorMessage ?? 'Service not found. Please try again later.';
        case 409:
          return errorMessage ?? 'Conflict. This action cannot be completed.';
        case 422:
          return errorMessage ?? 'Invalid data provided. Please check your input.';
        case 429:
          return 'Too many requests. Please wait a moment and try again.';
        case 500:
          return 'Server error. Please try again later.';
        case 503:
          return 'Service temporarily unavailable. Please try again later.';
        default:
          return errorMessage ?? 'An unexpected error occurred. Please try again.';
      }
    }

    // Handle network errors
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection and try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server response timeout. Please try again.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please check your internet connection and try again.';
      case DioExceptionType.connectionError:
        return 'Unable to connect to server. Please check your internet connection.';
      case DioExceptionType.badCertificate:
        return 'Security certificate error. Please try again later.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'Network error occurred. Please check your connection and try again.';
    }
  }
}
