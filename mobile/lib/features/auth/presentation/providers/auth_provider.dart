import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/auth_models.dart';
import '../../infrastructure/services/auth_service.dart';
import '../../infrastructure/services/firebase_auth_service.dart';
import '../../../../core/logging/logging.dart';
import '../../infrastructure/services/biometric_auth_service.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  // Healthcare-compliant logger for authentication context
  static final _logger = BoundedContextLoggers.auth;

  @override
  AuthState build() {
    // Return initial state first
    final state = const AuthState(status: AuthStatus.loading, isLoading: true);

    // Schedule initialization after the build is complete
    Future.microtask(() => _initializeAuth());

    return state;
  }

  Future<void> _initializeAuth() async {
    // No need to set loading state again as it's already set in build()
    try {
      final authService = ref.read(authServiceProvider);
      final firebaseAuthService = ref.read(firebaseAuthServiceProvider);

      // Check if user is signed in to Firebase
      if (firebaseAuthService.isSignedIn) {
        final user = await authService.getStoredUser();
        final profile = await authService.getStoredProfile();

        if (user != null) {
          state = state.copyWith(
            user: user,
            profile: profile,
            status: user.isGuest ? AuthStatus.guest : AuthStatus.authenticated,
            isLoading: false,
          );
        } else {
          // Firebase user exists but no stored user data - sign out
          await firebaseAuthService.signOut();
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            isLoading: false,
          );
        }
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
        );
      }
    } catch (e) {
      _logger.error('Auth initialization failed', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      state = state.copyWith(
        error: 'Failed to initialize authentication. Please restart the app.',
        status: AuthStatus.unauthenticated,
        isLoading: false,
      );
    }
  }

  Future<void> loginAsGuest() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final deviceId = await _getDeviceId();
      final firebaseAuthService = ref.read(firebaseAuthServiceProvider);
      final authService = ref.read(authServiceProvider);

      // Sign in anonymously with Firebase
      await firebaseAuthService.signInAnonymously();

      final authResponse = await authService.loginAsGuest(deviceId);

      state = state.copyWith(
        user: authResponse.user,
        profile: authResponse.profile,
        status: AuthStatus.guest,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final firebaseAuthService = ref.read(firebaseAuthServiceProvider);
      final authService = ref.read(authServiceProvider);

      // Sign in with Google via Firebase
      final userCredential = await firebaseAuthService.signInWithGoogle();

      // Get Firebase ID token
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      // Authenticate with backend using Google token
      final authResponse = await authService.signInWithGoogle(idToken);

      state = state.copyWith(
        user: authResponse.user,
        profile: authResponse.profile,
        status: AuthStatus.authenticated,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> signInWithApple() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final firebaseAuthService = ref.read(firebaseAuthServiceProvider);
      final authService = ref.read(authServiceProvider);

      // Sign in with Apple via Firebase
      final userCredential = await firebaseAuthService.signInWithApple();

      // Get Firebase ID token
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      // Authenticate with backend using Apple token
      final authResponse = await authService.signInWithApple(idToken);

      state = state.copyWith(
        user: authResponse.user,
        profile: authResponse.profile,
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
      final firebaseAuthService = ref.read(firebaseAuthServiceProvider);

      // Sign out from Firebase first
      await firebaseAuthService.signOut();

      // Then call backend logout and clear local tokens
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
