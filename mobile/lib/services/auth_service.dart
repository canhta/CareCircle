import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:simple_secure_storage/simple_secure_storage.dart';

import '../config/app_config.dart';
import '../models/auth_models.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  late final Dio _dio;
  late final GoogleSignIn _googleSignIn;

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';

  // Initialize the service
  Future<void> initialize() async {
    await init();
  }

  // Initialize the service
  Future<void> init() async {
    _googleSignIn = GoogleSignIn.instance;

    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: Duration(milliseconds: AppConfig.apiTimeout),
        receiveTimeout: Duration(milliseconds: AppConfig.apiTimeout),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _setupInterceptors();

    // Add logging in debug mode
    if (AppConfig.debugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the request with new token
              final token = await getAccessToken();
              if (token != null) {
                error.requestOptions.headers['Authorization'] = 'Bearer $token';
                final response = await _dio.fetch(error.requestOptions);
                handler.resolve(response);
                return;
              }
            }
            await logout();
          }
          handler.next(error);
        },
      ),
    );
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null;
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      final userData = await SimpleSecureStorage.read(_userDataKey);
      if (userData != null) {
        return User.fromJson(jsonDecode(userData));
      }
    } catch (e) {
      debugPrint('Error getting current user: $e');
    }
    return null;
  }

  // Login with email and password
  Future<AuthResult> login(LoginRequest request) async {
    try {
      final response = await _dio.post('/auth/login', data: request.toJson());

      if (response.statusCode == 200) {
        final data = response.data;
        final tokens = AuthTokens.fromJson(data['tokens']);
        final user = User.fromJson(data['user']);

        await _storeTokens(tokens);
        await _storeUser(user);

        return AuthResult(success: true, user: user);
      } else {
        return AuthResult(
          success: false,
          error: response.data['message'] ?? 'Login failed',
        );
      }
    } on DioException catch (e) {
      return AuthResult(
        success: false,
        error: e.response?.data['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  // Register new user
  Future<AuthResult> register(RegisterRequest request) async {
    try {
      final response =
          await _dio.post('/auth/register', data: request.toJson());

      if (response.statusCode == 201) {
        final data = response.data;
        final tokens = AuthTokens.fromJson(data['tokens']);
        final user = User.fromJson(data['user']);

        await _storeTokens(tokens);
        await _storeUser(user);

        return AuthResult(success: true, user: user);
      } else {
        return AuthResult(
          success: false,
          error: response.data['message'] ?? 'Registration failed',
        );
      }
    } on DioException catch (e) {
      return AuthResult(
        success: false,
        error: e.response?.data['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  // Google Sign-In
  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final response = await _dio.post('/auth/google', data: {
        'idToken': googleAuth.idToken,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final tokens = AuthTokens.fromJson(data['tokens']);
        final user = User.fromJson(data['user']);

        await _storeTokens(tokens);
        await _storeUser(user);

        return AuthResult(success: true, user: user);
      } else {
        return AuthResult(
          success: false,
          error: response.data['message'] ?? 'Google sign in failed',
        );
      }
    } on DioException catch (e) {
      return AuthResult(
        success: false,
        error: e.response?.data['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        error: 'Google sign in failed: ${e.toString()}',
      );
    }
  }

  // Apple Sign-In
  Future<AuthResult> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final response = await _dio.post('/auth/apple', data: {
        'identityToken': credential.identityToken,
        'authorizationCode': credential.authorizationCode,
        'email': credential.email,
        'givenName': credential.givenName,
        'familyName': credential.familyName,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final tokens = AuthTokens.fromJson(data['tokens']);
        final user = User.fromJson(data['user']);

        await _storeTokens(tokens);
        await _storeUser(user);

        return AuthResult(success: true, user: user);
      } else {
        return AuthResult(
          success: false,
          error: response.data['message'] ?? 'Apple sign in failed',
        );
      }
    } on DioException catch (e) {
      return AuthResult(
        success: false,
        error: e.response?.data['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        error: 'Apple sign in failed: ${e.toString()}',
      );
    }
  }

  // Request password reset
  Future<bool> requestPasswordReset(PasswordResetRequest request) async {
    try {
      final response =
          await _dio.post('/auth/forgot-password', data: request.toJson());
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Confirm password reset
  Future<bool> confirmPasswordReset(PasswordResetConfirmRequest request) async {
    try {
      final response = await _dio.post('/auth/password-reset/confirm',
          data: request.toJson());
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Update user profile
  Future<AuthResult> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await _dio.put('/auth/profile', data: request.toJson());

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data['user']);
        await _storeUser(user);
        return AuthResult(success: true, user: user);
      } else {
        return AuthResult(
          success: false,
          error: response.data['message'] ?? 'Profile update failed',
        );
      }
    } on DioException catch (e) {
      return AuthResult(
        success: false,
        error: e.response?.data['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Sign out from Google (always call signOut, it's safe to call even if not signed in)
      await _googleSignIn.signOut();

      // Clear all stored tokens and user data
      await _clearTokens();
    } catch (e) {
      debugPrint('Error during logout: $e');
      // Even if there's an error, clear local storage
      await _clearTokens();
    }
  }

  // Get access token
  Future<String?> getAccessToken() async {
    try {
      return await SimpleSecureStorage.read(_accessTokenKey);
    } catch (e) {
      return null;
    }
  }

  // Private methods

  Future<void> _storeTokens(AuthTokens tokens) async {
    await Future.wait([
      SimpleSecureStorage.write(_accessTokenKey, tokens.accessToken),
      SimpleSecureStorage.write(_refreshTokenKey, tokens.refreshToken),
    ]);
  }

  Future<void> _storeUser(User user) async {
    await SimpleSecureStorage.write(_userDataKey, jsonEncode(user.toJson()));
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await SimpleSecureStorage.read(_refreshTokenKey);
      if (refreshToken == null) return false;

      final response = await _dio.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });

      if (response.statusCode == 200) {
        final tokens = AuthTokens.fromJson(response.data['tokens']);
        await _storeTokens(tokens);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Failed to refresh tokens: $e');
      return false;
    }
  }

  Future<void> _clearTokens() async {
    await Future.wait([
      SimpleSecureStorage.delete(_accessTokenKey),
      SimpleSecureStorage.delete(_refreshTokenKey),
    ]);
  }
}

class AuthResult {
  final bool success;
  final User? user;
  final String? error;

  AuthResult({
    required this.success,
    this.user,
    this.error,
  });
}
