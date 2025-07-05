import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../common/common.dart';
import '../domain/auth_models.dart';

/// Enhanced authentication service using common modules
class AuthService extends BaseRepository {
  final SecureStorageService _secureStorage;

  AuthService({
    required super.apiClient,
    required super.logger,
    required SecureStorageService secureStorage,
  }) : _secureStorage = secureStorage;

  /// Login with email and password
  Future<Result<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await post<AuthResponse>(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      return result.fold(
        (authResponse) async {
          // Save tokens and user data
          await _saveAuthData(authResponse);
          return Result.success(authResponse);
        },
        (exception) => Result.failure(exception),
      );
    } catch (e) {
      return handleError(e);
    }
  }

  /// Register new user
  Future<Result<AuthResponse>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    try {
      final result = await post<AuthResponse>(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
        },
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      return result.fold(
        (authResponse) async {
          await _saveAuthData(authResponse);
          return Result.success(authResponse);
        },
        (exception) => Result.failure(exception),
      );
    } catch (e) {
      return handleError(e);
    }
  }

  /// Login with Google
  Future<Result<AuthResponse>> loginWithGoogle() async {
    try {
      // Initialize Google Sign In if not already done
      await GoogleSignIn.instance.initialize();

      // Trigger the authentication flow
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        return Result.failure(Exception('Failed to get Google ID token'));
      }

      final result = await post<AuthResponse>(
        ApiEndpoints.socialLogin,
        data: {
          'provider': 'google',
          'idToken': idToken,
        },
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      return result.fold(
        (authResponse) async {
          await _saveAuthData(authResponse);
          return Result.success(authResponse);
        },
        (exception) => Result.failure(exception),
      );
    } catch (e) {
      return handleError(e);
    }
  }

  /// Login with Apple
  Future<Result<AuthResponse>> loginWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final result = await post<AuthResponse>(
        ApiEndpoints.socialLogin,
        data: {
          'provider': 'apple',
          'idToken': credential.identityToken,
          'authorizationCode': credential.authorizationCode,
          if (credential.email != null) 'email': credential.email,
          if (credential.givenName != null) 'firstName': credential.givenName,
          if (credential.familyName != null) 'lastName': credential.familyName,
        },
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      return result.fold(
        (authResponse) async {
          await _saveAuthData(authResponse);
          return Result.success(authResponse);
        },
        (exception) => Result.failure(exception),
      );
    } catch (e) {
      return handleError(e);
    }
  }

  /// Refresh access token
  Future<Result<String>> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) {
        return Result.failure(Exception('No refresh token available'));
      }

      final result = await post<Map<String, dynamic>>(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      return result.fold(
        (response) async {
          final newAccessToken = response['accessToken'] as String;
          final newRefreshToken = response['refreshToken'] as String?;

          await _secureStorage.saveAccessToken(newAccessToken);
          if (newRefreshToken != null) {
            await _secureStorage.saveRefreshToken(newRefreshToken);
          }

          return Result.success(newAccessToken);
        },
        (exception) => Result.failure(exception),
      );
    } catch (e) {
      return handleError(e);
    }
  }

  /// Logout user
  Future<Result<void>> logout() async {
    try {
      // Call logout endpoint
      await post(ApiEndpoints.logout);

      // Clear local data
      await _clearAuthData();

      // Sign out from Google
      await GoogleSignIn.instance.disconnect();

      return Result.success(null);
    } catch (e) {
      // Even if API call fails, clear local data
      await _clearAuthData();
      return Result.success(null);
    }
  }

  /// Forgot password
  Future<Result<void>> forgotPassword(String email) async {
    try {
      final result = await post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );

      return result.fold(
        (_) => Result.success(null),
        (exception) => Result.failure(exception),
      );
    } catch (e) {
      return handleError(e);
    }
  }

  /// Reset password
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final result = await post(
        ApiEndpoints.resetPassword,
        data: {
          'token': token,
          'newPassword': newPassword,
        },
      );

      return result.fold(
        (_) => Result.success(null),
        (exception) => Result.failure(exception),
      );
    } catch (e) {
      return handleError(e);
    }
  }

  /// Verify email
  Future<Result<void>> verifyEmail(String token) async {
    try {
      final result = await post(
        ApiEndpoints.verifyEmail,
        data: {'token': token},
      );

      return result.fold(
        (_) => Result.success(null),
        (exception) => Result.failure(exception),
      );
    } catch (e) {
      return handleError(e);
    }
  }

  /// Update user profile
  Future<Result<User>> updateProfile(UpdateProfileRequest request) async {
    try {
      final result = await put<Map<String, dynamic>>(
        ApiEndpoints.updateProfile,
        data: request.toJson(),
      );

      return result.fold(
        (response) async {
          final updatedUser = User.fromJson(response['user'] ?? response);
          await _secureStorage.saveUserData(updatedUser.toJson());
          return Result.success(updatedUser);
        },
        (exception) => Result.failure(exception),
      );
    } catch (e) {
      return handleError(e);
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.getAccessToken();
    return token != null;
  }

  /// Get current user data
  Future<User?> getCurrentUser() async {
    final userData = await _secureStorage.getUserData();
    if (userData != null) {
      return User.fromJson(userData);
    }
    return null;
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.getAccessToken();
  }

  /// Save authentication data
  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await _secureStorage.saveAccessToken(authResponse.accessToken);
    await _secureStorage.saveRefreshToken(authResponse.refreshToken);
    await _secureStorage.saveUserData(authResponse.user.toJson());
  }

  /// Clear authentication data
  Future<void> _clearAuthData() async {
    await _secureStorage.clearAuthData();
  }
}
