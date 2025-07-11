import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../core/logging/logging.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Healthcare-compliant logger for Firebase authentication
  static final _logger = BoundedContextLoggers.auth;

  // Initialize Google Sign In if needed
  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
    } catch (e) {
      throw Exception('Failed to initialize Google Sign-In: ${e.toString()}');
    }
  }

  // Check if user is signed in
  bool get isSignedIn => _firebaseAuth.currentUser != null;

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Get current user's ID token
  Future<String?> getIdToken() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      await _secureStorage.deleteAll();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Initialize Google Sign In if needed
      await _initializeGoogleSignIn();

      // Trigger the authentication flow using the new API
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw Exception('Failed to get Google ID token');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken!,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      return userCredential;
    } on GoogleSignInException catch (e) {
      final errorMessage = switch (e.code) {
        GoogleSignInExceptionCode.canceled =>
          'Google sign-in was cancelled by user',
        GoogleSignInExceptionCode.interrupted =>
          'Google sign-in was interrupted. Please try again.',
        GoogleSignInExceptionCode.clientConfigurationError =>
          'Google sign-in client configuration error. Please check your setup.',
        GoogleSignInExceptionCode.providerConfigurationError =>
          'Google sign-in provider configuration error. Please check your setup.',
        GoogleSignInExceptionCode.uiUnavailable =>
          'Google sign-in UI unavailable. Please try again.',
        GoogleSignInExceptionCode.userMismatch =>
          'Google sign-in user mismatch. Please try again.',
        _ => 'Google sign-in failed: ${e.description}',
      };
      throw Exception(errorMessage);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Google sign-in failed: ${e.toString()}');
    }
  }

  // Sign in with Apple
  Future<UserCredential> signInWithApple() async {
    try {
      // Request Apple ID credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create Firebase credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with the Apple credential
      return await _firebaseAuth.signInWithCredential(oauthCredential);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Apple sign-in failed: ${e.toString()}');
    }
  }

  // Sign in anonymously (for guest mode)
  Future<UserCredential> signInAnonymously() async {
    try {
      return await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  // Create user with email and password
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions with comprehensive error mapping
  String _handleFirebaseAuthException(FirebaseAuthException e) {
    _logger.error('Firebase Auth Error: ${e.code} - ${e.message}');

    switch (e.code) {
      // Email/Password Authentication Errors
      case 'user-not-found':
        return 'No account found with this email address. Please check your email or create a new account.';
      case 'wrong-password':
        return 'Incorrect password. Please try again or reset your password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support for assistance.';
      case 'email-already-in-use':
        return 'An account already exists with this email address. Please sign in instead.';
      case 'weak-password':
        return 'Password is too weak. Please choose a password with at least 6 characters.';

      // Rate Limiting and Security
      case 'too-many-requests':
        return 'Too many failed attempts. Please wait a few minutes before trying again.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled. Please contact support.';

      // Network and Connection Errors
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      case 'timeout':
        return 'Request timed out. Please try again.';

      // Token and Session Errors
      case 'invalid-credential':
        return 'Invalid credentials provided. Please try again.';
      case 'credential-already-in-use':
        return 'This credential is already associated with another account.';
      case 'invalid-verification-code':
        return 'Invalid verification code. Please check and try again.';
      case 'invalid-verification-id':
        return 'Invalid verification ID. Please restart the verification process.';

      // OAuth Specific Errors
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in method.';
      case 'invalid-oauth-provider':
        return 'Invalid OAuth provider. Please try a different sign-in method.';
      case 'oauth-account-not-linked':
        return 'OAuth account is not linked. Please link your account first.';

      // Apple Sign-In Specific
      case 'sign_in_canceled':
        return 'Sign-in was cancelled. Please try again.';
      case 'sign_in_failed':
        return 'Apple Sign-In failed. Please try again.';

      // Google Sign-In Specific
      case 'sign_in_required':
        return 'Please sign in to continue.';

      // Anonymous Authentication
      case 'anonymous-provider-disabled':
        return 'Anonymous sign-in is disabled. Please use another sign-in method.';

      // General Errors
      case 'internal-error':
        return 'An internal error occurred. Please try again later.';
      case 'invalid-api-key':
        return 'Invalid API configuration. Please contact support.';
      case 'app-not-authorized':
        return 'App is not authorized to use Firebase Authentication.';

      default:
        _logger.error('Unhandled Firebase Auth Error: ${e.code}');
        return 'Authentication failed. Please try again or contact support if the problem persists.';
    }
  }
}
