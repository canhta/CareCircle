import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';
import '../services/firebase_auth_service.dart';
import '../services/biometric_auth_service.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _initializeAuth();
    return const AuthState();
  }

  Future<void> _initializeAuth() async {
    state = state.copyWith(isLoading: true, status: AuthStatus.loading);

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.getStoredUser();
      final profile = await authService.getStoredProfile();
      final token = await authService.getAccessToken();

      if (user != null && token != null) {
        state = state.copyWith(
          user: user,
          profile: profile,
          accessToken: token,
          status: user.isGuest ? AuthStatus.guest : AuthStatus.authenticated,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        status: AuthStatus.unauthenticated,
        isLoading: false,
      );
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authService = ref.read(authServiceProvider);
      final authResponse = await authService.loginWithEmail(email, password);

      state = state.copyWith(
        user: authResponse.user,
        profile: authResponse.profile,
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
        status: AuthStatus.authenticated,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authService = ref.read(authServiceProvider);
      final authResponse = await authService.register(request);

      state = state.copyWith(
        user: authResponse.user,
        profile: authResponse.profile,
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
        status: AuthStatus.authenticated,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> loginAsGuest() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final deviceId = await _getDeviceId();
      final authService = ref.read(authServiceProvider);
      final authResponse = await authService.loginAsGuest(deviceId);

      state = state.copyWith(
        user: authResponse.user,
        profile: authResponse.profile,
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
        status: AuthStatus.guest,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> convertGuestToRegistered({
    String? email,
    String? phoneNumber,
    String? password,
    String? displayName,
  }) async {
    if (state.status != AuthStatus.guest) {
      state = state.copyWith(error: 'Only guest users can be converted');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final authService = ref.read(authServiceProvider);
      final authResponse = await authService.convertGuest(
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        displayName: displayName,
      );

      state = state.copyWith(
        user: authResponse.user,
        profile: authResponse.profile,
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
        status: AuthStatus.authenticated,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authService = ref.read(authServiceProvider);
      final updatedProfile = await authService.updateProfile(updates);

      state = state.copyWith(profile: updatedProfile, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.logout();

      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      // Even if logout fails on server, clear local state
      state = const AuthState(
        status: AuthStatus.unauthenticated,
        error: 'Logout completed locally',
      );
    }
  }

  Future<void> convertGuest({
    String? email,
    String? phoneNumber,
    String? password,
    String? displayName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authService = ref.read(authServiceProvider);
      final authResponse = await authService.convertGuest(
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        displayName: displayName,
      );

      state = state.copyWith(
        user: authResponse.user,
        profile: authResponse.profile,
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
        status: AuthStatus.authenticated,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown-ios-device';
    } else {
      return 'unknown-device';
    }
  }
}

// Convenience providers for common auth state checks
@riverpod
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.status == AuthStatus.authenticated;
}

@riverpod
bool isGuest(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.status == AuthStatus.guest;
}

@riverpod
bool isLoggedIn(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.status == AuthStatus.authenticated ||
      authState.status == AuthStatus.guest;
}

@riverpod
User? currentUser(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.user;
}

@riverpod
UserProfile? currentProfile(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.profile;
}

@riverpod
AuthService authService(Ref ref) {
  return AuthService();
}

@riverpod
FirebaseAuthService firebaseAuthService(Ref ref) {
  return FirebaseAuthService();
}

@riverpod
BiometricAuthService biometricAuthService(Ref ref) {
  return BiometricAuthService();
}
