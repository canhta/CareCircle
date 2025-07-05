import '../../../common/common.dart';
import '../models/firebase_auth_models.dart';

/// Repository interface for Firebase authentication operations
abstract class FirebaseAuthRepository {
  /// Get current authenticated user
  AuthUser? get currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated;

  /// Stream of authentication state changes
  Stream<AuthUser?> get authStateChanges;

  /// Stream of ID token changes
  Stream<AuthUser?> get idTokenChanges;

  /// Sign in with email and password
  Future<Result<AuthResult>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Create account with email and password
  Future<Result<AuthResult>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign in with Google
  Future<Result<AuthResult>> signInWithGoogle();

  /// Sign in with Apple
  Future<Result<AuthResult>> signInWithApple();

  /// Sign in with phone number
  Future<Result<AuthResult>> signInWithPhoneNumber({
    required String phoneNumber,
    required String smsCode,
    required String verificationId,
  });

  /// Verify phone number and get verification ID
  Future<Result<String>> verifyPhoneNumber({
    required String phoneNumber,
    int timeout = 30,
  });

  /// Sign in anonymously
  Future<Result<AuthResult>> signInAnonymously();

  /// Link account with credential
  Future<Result<AuthResult>> linkWithCredential(AuthCredential credential);

  /// Unlink account from provider
  Future<Result<void>> unlinkFromProvider(String providerId);

  /// Reauthenticate user with credential
  Future<Result<void>> reauthenticateWithCredential(AuthCredential credential);

  /// Send email verification
  Future<Result<void>> sendEmailVerification({
    String? continueUrl,
    Map<String, dynamic>? actionCodeSettings,
  });

  /// Verify email with action code
  Future<Result<void>> verifyEmailWithCode(String actionCode);

  /// Send password reset email
  Future<Result<void>> sendPasswordResetEmail({
    required String email,
    String? continueUrl,
    Map<String, dynamic>? actionCodeSettings,
  });

  /// Confirm password reset with code
  Future<Result<void>> confirmPasswordReset({
    required String actionCode,
    required String newPassword,
  });

  /// Update user email
  Future<Result<void>> updateEmail(String newEmail);

  /// Update user password
  Future<Result<void>> updatePassword(String newPassword);

  /// Update user profile
  Future<Result<void>> updateProfile({
    String? displayName,
    String? photoUrl,
  });

  /// Delete user account
  Future<Result<void>> deleteAccount();

  /// Reload user data
  Future<Result<void>> reloadUser();

  /// Get ID token
  Future<Result<String>> getIdToken({bool forceRefresh = false});

  /// Sign out
  Future<Result<void>> signOut();

  /// Check if email is available (not already in use)
  Future<Result<bool>> isEmailAvailable(String email);

  /// Get sign-in methods for email
  Future<Result<List<String>>> getSignInMethodsForEmail(String email);

  /// Set language code for auth operations
  Future<Result<void>> setLanguageCode(String languageCode);

  /// Initialize Firebase Auth
  Future<Result<void>> initialize();

  /// Dispose resources
  Future<Result<void>> dispose();
}
