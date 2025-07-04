import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';

/// Modern Firebase Auth service with OAuth providers
class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// Initialize the service
  Future<void> initialize() async {
    await _googleSignIn.initialize(
        // Add your Google Sign-In configuration here if needed
        );

    AppConfig.logger.i('FirebaseAuthService initialized');
  }

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _storeUserSession(credential.user);

      AppConfig.logger.i('Email sign in successful: ${credential.user?.email}');
      return AuthResult(success: true, user: credential.user);
    } on FirebaseAuthException catch (e) {
      AppConfig.logger.e('Firebase Auth Error: ${e.code} - ${e.message}');
      return AuthResult(success: false, error: _getErrorMessage(e.code));
    } catch (e) {
      AppConfig.logger.e('Sign in error: $e');
      return AuthResult(success: false, error: 'An unexpected error occurred');
    }
  }

  /// Create account with email and password
  Future<AuthResult> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _storeUserSession(credential.user);

      AppConfig.logger
          .i('Account created successfully: ${credential.user?.email}');
      return AuthResult(success: true, user: credential.user);
    } on FirebaseAuthException catch (e) {
      AppConfig.logger.e('Firebase Auth Error: ${e.code} - ${e.message}');
      return AuthResult(success: false, error: _getErrorMessage(e.code));
    } catch (e) {
      AppConfig.logger.e('Account creation error: $e');
      return AuthResult(success: false, error: 'An unexpected error occurred');
    }
  }

  /// Sign in with Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      await _storeUserSession(userCredential.user);

      AppConfig.logger
          .i('Google sign in successful: ${userCredential.user?.email}');
      return AuthResult(success: true, user: userCredential.user);
    } catch (e) {
      AppConfig.logger.e('Google sign in error: $e');
      return AuthResult(success: false, error: 'Google sign in failed');
    }
  }

  /// Sign in with Apple
  Future<AuthResult> signInWithApple() async {
    try {
      // Request Apple ID credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuth credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with the Apple credential
      final userCredential = await _auth.signInWithCredential(oauthCredential);

      await _storeUserSession(userCredential.user);

      AppConfig.logger
          .i('Apple sign in successful: ${userCredential.user?.email}');
      return AuthResult(success: true, user: userCredential.user);
    } catch (e) {
      AppConfig.logger.e('Apple sign in error: $e');
      return AuthResult(success: false, error: 'Apple sign in failed');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);

      await _clearUserSession();

      AppConfig.logger.i('User signed out successfully');
    } catch (e) {
      AppConfig.logger.e('Sign out error: $e');
      rethrow;
    }
  }

  /// Delete user account
  Future<AuthResult> deleteAccount() async {
    try {
      final user = currentUser;
      if (user != null) {
        await user.delete();
        await _clearUserSession();
        AppConfig.logger.i('Account deleted successfully');
        return AuthResult(success: true);
      } else {
        return AuthResult(success: false, error: 'No user to delete');
      }
    } on FirebaseAuthException catch (e) {
      AppConfig.logger.e('Account deletion error: ${e.code} - ${e.message}');
      return AuthResult(success: false, error: _getErrorMessage(e.code));
    } catch (e) {
      AppConfig.logger.e('Account deletion error: $e');
      return AuthResult(success: false, error: 'Failed to delete account');
    }
  }

  /// Send password reset email
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      AppConfig.logger.i('Password reset email sent to: $email');
      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      AppConfig.logger.e('Password reset error: ${e.code} - ${e.message}');
      return AuthResult(success: false, error: _getErrorMessage(e.code));
    } catch (e) {
      AppConfig.logger.e('Password reset error: $e');
      return AuthResult(
          success: false, error: 'Failed to send password reset email');
    }
  }

  /// Update user profile
  Future<AuthResult> updateProfile(
      {String? displayName, String? photoURL}) async {
    try {
      final user = currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
        await user.reload();
        AppConfig.logger.i('Profile updated successfully');
        return AuthResult(success: true, user: _auth.currentUser);
      } else {
        return AuthResult(success: false, error: 'No user to update');
      }
    } on FirebaseAuthException catch (e) {
      AppConfig.logger.e('Profile update error: ${e.code} - ${e.message}');
      return AuthResult(success: false, error: _getErrorMessage(e.code));
    } catch (e) {
      AppConfig.logger.e('Profile update error: $e');
      return AuthResult(success: false, error: 'Failed to update profile');
    }
  }

  /// Get user ID token
  Future<String?> getIdToken() async {
    try {
      final user = currentUser;
      if (user != null) {
        return await user.getIdToken();
      }
      return null;
    } catch (e) {
      AppConfig.logger.e('Get ID token error: $e');
      return null;
    }
  }

  /// Refresh user ID token
  Future<String?> refreshIdToken() async {
    try {
      final user = currentUser;
      if (user != null) {
        return await user.getIdToken(true);
      }
      return null;
    } catch (e) {
      AppConfig.logger.e('Refresh ID token error: $e');
      return null;
    }
  }

  /// Store user session securely
  Future<void> _storeUserSession(User? user) async {
    if (user != null) {
      await AppConfig.setUserId(user.uid);
      await AppConfig.setUserEmail(user.email ?? '');

      // Store the ID token
      final idToken = await user.getIdToken();
      if (idToken != null) {
        await AppConfig.setAccessToken(idToken);
      }
    }
  }

  /// Clear user session
  Future<void> _clearUserSession() async {
    await AppConfig.clearSecureStorage();
  }

  /// Get user-friendly error message
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'weak-password':
        return 'Password should be at least 6 characters';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'requires-recent-login':
        return 'Please sign in again to perform this action';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}

/// Authentication result class
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

/// Riverpod providers
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.read(firebaseAuthServiceProvider);
  return authService.authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.asData?.value;
});

/// Auth state notifier for UI state management
final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref.read(firebaseAuthServiceProvider));
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final FirebaseAuthService _authService;

  AuthStateNotifier(this._authService) : super(const AuthState.initial());

  Future<void> signInWithEmail(String email, String password) async {
    state = const AuthState.loading();
    try {
      final result = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.success) {
        state = const AuthState.authenticated();
      } else {
        state = AuthState.error(result.error ?? 'Sign in failed');
      }
    } catch (e) {
      state = AuthState.error('An unexpected error occurred');
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    state = const AuthState.loading();
    try {
      final result = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.success) {
        state = const AuthState.authenticated();
      } else {
        state = AuthState.error(result.error ?? 'Sign up failed');
      }
    } catch (e) {
      state = AuthState.error('An unexpected error occurred');
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();
    try {
      final result = await _authService.signInWithGoogle();
      if (result.success) {
        state = const AuthState.authenticated();
      } else {
        state = AuthState.error(result.error ?? 'Google sign in failed');
      }
    } catch (e) {
      state = AuthState.error('An unexpected error occurred');
    }
  }

  Future<void> signInWithApple() async {
    state = const AuthState.loading();
    try {
      final result = await _authService.signInWithApple();
      if (result.success) {
        state = const AuthState.authenticated();
      } else {
        state = AuthState.error(result.error ?? 'Apple sign in failed');
      }
    } catch (e) {
      state = AuthState.error('An unexpected error occurred');
    }
  }

  Future<void> signOut() async {
    state = const AuthState.loading();
    try {
      await _authService.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error('Sign out failed');
    }
  }

  Future<void> sendPasswordReset(String email) async {
    state = const AuthState.loading();
    try {
      final result = await _authService.sendPasswordResetEmail(email);
      if (result.success) {
        state = const AuthState.initial();
      } else {
        state = AuthState.error(
            result.error ?? 'Failed to send password reset email');
      }
    } catch (e) {
      state = AuthState.error('An unexpected error occurred');
    }
  }

  void clearError() {
    state = const AuthState.initial();
  }
}

/// Auth state sealed class
sealed class AuthState {
  const AuthState();

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated() = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.error(String message) = AuthError;
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
