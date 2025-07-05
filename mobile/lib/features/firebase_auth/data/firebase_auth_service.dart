import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../common/common.dart';
import '../domain/firebase_auth_models.dart' as auth_models;
import '../domain/firebase_auth_repository.dart';

/// Firebase Authentication service implementation
class FirebaseAuthService implements FirebaseAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final AppLogger _logger;
  final SecureStorageService _secureStorage;

  // Stream controllers for auth state management
  final StreamController<auth_models.AuthUser?> _authStateController =
      StreamController<auth_models.AuthUser?>.broadcast();
  final StreamController<auth_models.AuthUser?> _idTokenController =
      StreamController<auth_models.AuthUser?>.broadcast();

  // Current user cache
  auth_models.AuthUser? _currentUser;

  FirebaseAuthService({
    required AppLogger logger,
    required SecureStorageService secureStorage,
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _logger = logger,
        _secureStorage = secureStorage,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  @override
  auth_models.AuthUser? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  Stream<auth_models.AuthUser?> get authStateChanges =>
      _authStateController.stream;

  @override
  Stream<auth_models.AuthUser?> get idTokenChanges => _idTokenController.stream;

  @override
  Future<Result<void>> initialize() async {
    try {
      _logger.info('Initializing Firebase Auth service');

      // Listen to Firebase auth state changes
      _firebaseAuth.authStateChanges().listen((User? firebaseUser) {
        final authUser = firebaseUser != null
            ? auth_models.AuthUser.fromFirebaseUser(firebaseUser)
            : null;
        _currentUser = authUser;
        _authStateController.add(authUser);

        if (authUser != null) {
          _logger.info('User authenticated: ${authUser.email}');
        } else {
          _logger.info('User signed out');
        }
      });

      // Listen to ID token changes
      _firebaseAuth.idTokenChanges().listen((User? firebaseUser) {
        final authUser = firebaseUser != null
            ? auth_models.AuthUser.fromFirebaseUser(firebaseUser)
            : null;
        _idTokenController.add(authUser);
      });

      // Set initial user state
      final currentFirebaseUser = _firebaseAuth.currentUser;
      if (currentFirebaseUser != null) {
        _currentUser =
            auth_models.AuthUser.fromFirebaseUser(currentFirebaseUser);
      }

      _logger.info('Firebase Auth service initialized successfully');
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to initialize Firebase Auth service', error: e);
      return Result.failure(
          Exception('Failed to initialize Firebase Auth: $e'));
    }
  }

  @override
  Future<Result<auth_models.AuthResult>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Signing in with email: $email');

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final authResult = _createAuthResult(userCredential);
      await _storeUserSession(userCredential.user);

      _logger.info('Email sign-in successful');
      return Result.success(authResult);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _logger.error('Email sign-in failed: ${e.code}', error: e);
      return Result.success(auth_models.AuthResult.failure(errorMessage));
    } catch (e) {
      _logger.error('Email sign-in error', error: e);
      return Result.success(
          auth_models.AuthResult.failure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<auth_models.AuthResult>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Creating user account with email: $email');

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final authResult = _createAuthResult(userCredential);
      await _storeUserSession(userCredential.user);

      _logger.info('Account creation successful');
      return Result.success(authResult);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _logger.error('Account creation failed: ${e.code}', error: e);
      return Result.success(auth_models.AuthResult.failure(errorMessage));
    } catch (e) {
      _logger.error('Account creation error', error: e);
      return Result.success(
          auth_models.AuthResult.failure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<auth_models.AuthResult>> signInWithGoogle() async {
    try {
      _logger.info('Starting Google sign-in');

      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final authResult = _createAuthResult(userCredential);
      await _storeUserSession(userCredential.user);

      _logger.info('Google sign-in successful');
      return Result.success(authResult);
    } catch (e) {
      _logger.error('Google sign-in failed', error: e);
      return Result.success(
          auth_models.AuthResult.failure('Google sign-in failed'));
    }
  }

  @override
  Future<Result<auth_models.AuthResult>> signInWithApple() async {
    try {
      _logger.info('Starting Apple sign-in');

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
      final userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      final authResult = _createAuthResult(userCredential);
      await _storeUserSession(userCredential.user);

      _logger.info('Apple sign-in successful');
      return Result.success(authResult);
    } catch (e) {
      _logger.error('Apple sign-in failed', error: e);
      return Result.success(
          auth_models.AuthResult.failure('Apple sign-in failed'));
    }
  }

  @override
  Future<Result<auth_models.AuthResult>> signInWithPhoneNumber({
    required String phoneNumber,
    required String smsCode,
    required String verificationId,
  }) async {
    try {
      _logger.info('Signing in with phone number');

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final authResult = _createAuthResult(userCredential);
      await _storeUserSession(userCredential.user);

      _logger.info('Phone sign-in successful');
      return Result.success(authResult);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _logger.error('Phone sign-in failed: ${e.code}', error: e);
      return Result.success(auth_models.AuthResult.failure(errorMessage));
    } catch (e) {
      _logger.error('Phone sign-in error', error: e);
      return Result.success(
          auth_models.AuthResult.failure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<String>> verifyPhoneNumber({
    required String phoneNumber,
    int timeout = 30,
  }) async {
    try {
      _logger.info('Verifying phone number: $phoneNumber');

      final completer = Completer<String>();

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: timeout),
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-verification completed (Android only)
          _logger.info('Phone verification completed automatically');
        },
        verificationFailed: (FirebaseAuthException e) {
          _logger.error('Phone verification failed: ${e.code}', error: e);
          if (!completer.isCompleted) {
            completer.completeError(e);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          _logger.info('SMS code sent');
          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _logger.info('Code auto-retrieval timeout');
          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },
      );

      final verificationId = await completer.future;
      return Result.success(verificationId);
    } catch (e) {
      _logger.error('Phone verification error', error: e);
      return Result.failure(Exception('Phone verification failed: $e'));
    }
  }

  @override
  Future<Result<auth_models.AuthResult>> signInAnonymously() async {
    try {
      _logger.info('Signing in anonymously');

      final userCredential = await _firebaseAuth.signInAnonymously();

      final authResult = _createAuthResult(userCredential);
      await _storeUserSession(userCredential.user);

      _logger.info('Anonymous sign-in successful');
      return Result.success(authResult);
    } catch (e) {
      _logger.error('Anonymous sign-in failed', error: e);
      return Result.success(
          auth_models.AuthResult.failure('Anonymous sign-in failed'));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      _logger.info('Signing out user');

      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);

      await _clearUserSession();
      _currentUser = null;

      _logger.info('User signed out successfully');
      return Result.success(null);
    } catch (e) {
      _logger.error('Sign out failed', error: e);
      return Result.failure(Exception('Sign out failed'));
    }
  }

  // Stub implementations for remaining methods
  @override
  Future<Result<auth_models.AuthResult>> linkWithCredential(
      auth_models.AuthCredential credential) async {
    try {
      _logger.info('Linking credential to current user');

      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return Result.failure(Exception('No user is currently signed in'));
      }

      // Convert our credential to Firebase credential
      AuthCredential firebaseCredential;
      if (credential is auth_models.GoogleCredential) {
        firebaseCredential = GoogleAuthProvider.credential(
          idToken: credential.idToken,
          accessToken: credential.accessToken,
        );
      } else if (credential is auth_models.AppleCredential) {
        firebaseCredential = OAuthProvider("apple.com").credential(
          idToken: credential.identityToken,
          accessToken: credential.authorizationCode,
        );
      } else if (credential is auth_models.PhoneCredential) {
        firebaseCredential = PhoneAuthProvider.credential(
          verificationId: credential.verificationId,
          smsCode: credential.smsCode,
        );
      } else {
        return Result.failure(Exception(
            'Unsupported credential type: ${credential.runtimeType}'));
      }

      final userCredential =
          await currentUser.linkWithCredential(firebaseCredential);
      final authResult = _createAuthResult(userCredential);
      await _storeUserSession(userCredential.user);

      _logger.info('Credential linked successfully');
      return Result.success(authResult);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _logger.error('Link credential failed: ${e.code}', error: e);
      return Result.success(auth_models.AuthResult.failure(errorMessage));
    } catch (e) {
      _logger.error('Link credential error', error: e);
      return Result.success(
          auth_models.AuthResult.failure('Failed to link credential'));
    }
  }

  @override
  Future<Result<void>> unlinkFromProvider(String providerId) async {
    try {
      _logger.info('Unlinking provider: $providerId');

      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return Result.failure(Exception('No user is currently signed in'));
      }

      await currentUser.unlink(providerId);
      _logger.info('Provider unlinked successfully: $providerId');
      return Result.success(null);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _logger.error('Unlink provider failed: ${e.code}', error: e);
      return Result.failure(Exception(errorMessage));
    } catch (e) {
      _logger.error('Unlink provider error', error: e);
      return Result.failure(Exception('Failed to unlink provider'));
    }
  }

  @override
  Future<Result<void>> reauthenticateWithCredential(
      auth_models.AuthCredential credential) async {
    try {
      _logger.info('Reauthenticating with credential');

      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return Result.failure(Exception('No user is currently signed in'));
      }

      // Convert our credential to Firebase credential
      AuthCredential firebaseCredential;
      if (credential is auth_models.GoogleCredential) {
        firebaseCredential = GoogleAuthProvider.credential(
          idToken: credential.idToken,
          accessToken: credential.accessToken,
        );
      } else if (credential is auth_models.AppleCredential) {
        firebaseCredential = OAuthProvider("apple.com").credential(
          idToken: credential.identityToken,
          accessToken: credential.authorizationCode,
        );
      } else if (credential is auth_models.PhoneCredential) {
        firebaseCredential = PhoneAuthProvider.credential(
          verificationId: credential.verificationId,
          smsCode: credential.smsCode,
        );
      } else if (credential is auth_models.EmailPasswordCredential) {
        firebaseCredential = EmailAuthProvider.credential(
          email: credential.email,
          password: credential.password,
        );
      } else {
        return Result.failure(Exception(
            'Unsupported credential type: ${credential.runtimeType}'));
      }

      await currentUser.reauthenticateWithCredential(firebaseCredential);
      _logger.info('Reauthentication successful');
      return Result.success(null);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _logger.error('Reauthentication failed: ${e.code}', error: e);
      return Result.failure(Exception(errorMessage));
    } catch (e) {
      _logger.error('Reauthentication error', error: e);
      return Result.failure(Exception('Failed to reauthenticate'));
    }
  }

  @override
  Future<Result<void>> sendEmailVerification(
      {String? continueUrl, Map<String, dynamic>? actionCodeSettings}) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return Result.failure(Exception('No user is currently signed in'));
      }

      await currentUser.sendEmailVerification();
      _logger.info('Email verification sent to ${currentUser.email}');
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to send email verification', error: e);
      return Result.failure(Exception('Failed to send email verification: $e'));
    }
  }

  @override
  Future<Result<void>> verifyEmailWithCode(String actionCode) async {
    // TODO: Implement when needed
    return Result.failure(Exception('Not implemented'));
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(
      {required String email,
      String? continueUrl,
      Map<String, dynamic>? actionCodeSettings}) async {
    try {
      _logger.info('Sending password reset email to: $email');
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      _logger.info('Password reset email sent successfully');
      return Result.success(null);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _logger.error('Failed to send password reset email: ${e.code}', error: e);
      return Result.failure(Exception(errorMessage));
    } catch (e) {
      _logger.error('Failed to send password reset email', error: e);
      return Result.failure(
          Exception('Failed to send password reset email: $e'));
    }
  }

  @override
  Future<Result<void>> confirmPasswordReset(
      {required String actionCode, required String newPassword}) async {
    // TODO: Implement when needed
    return Result.failure(Exception('Not implemented'));
  }

  @override
  Future<Result<void>> updateEmail(String newEmail) async {
    try {
      _logger.info('Updating user email');

      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return Result.failure(Exception('No user is currently signed in'));
      }

      await currentUser.verifyBeforeUpdateEmail(newEmail);
      await _storeUserSession(currentUser);

      _logger.info('Email updated successfully');
      return Result.success(null);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _logger.error('Update email failed: ${e.code}', error: e);
      return Result.failure(Exception(errorMessage));
    } catch (e) {
      _logger.error('Update email error', error: e);
      return Result.failure(Exception('Failed to update email'));
    }
  }

  @override
  Future<Result<void>> updatePassword(String newPassword) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return Result.failure(Exception('No user is currently signed in'));
      }

      await currentUser.updatePassword(newPassword);
      _logger.info('Password updated successfully');
      return Result.success(null);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _logger.error('Failed to update password: ${e.code}', error: e);
      return Result.failure(Exception(errorMessage));
    } catch (e) {
      _logger.error('Failed to update password', error: e);
      return Result.failure(Exception('Failed to update password: $e'));
    }
  }

  @override
  Future<Result<void>> updateProfile(
      {String? displayName, String? photoUrl}) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return Result.failure(Exception('No user is currently signed in'));
      }

      await currentUser.updateDisplayName(displayName);
      if (photoUrl != null) {
        await currentUser.updatePhotoURL(photoUrl);
      }

      _logger.info('Profile updated successfully');
      return Result.success(null);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _logger.error('Failed to update profile: ${e.code}', error: e);
      return Result.failure(Exception(errorMessage));
    } catch (e) {
      _logger.error('Failed to update profile', error: e);
      return Result.failure(Exception('Failed to update profile: $e'));
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return Result.failure(Exception('No user is currently signed in'));
      }

      await currentUser.delete();
      _logger.info('Account deleted successfully');
      return Result.success(null);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _logger.error('Failed to delete account: ${e.code}', error: e);
      return Result.failure(Exception(errorMessage));
    } catch (e) {
      _logger.error('Failed to delete account', error: e);
      return Result.failure(Exception('Failed to delete account: $e'));
    }
  }

  @override
  Future<Result<void>> reloadUser() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return Result.failure(Exception('No user is currently signed in'));
      }

      await currentUser.reload();
      _logger.info('User reloaded successfully');
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to reload user', error: e);
      return Result.failure(Exception('Failed to reload user: $e'));
    }
  }

  @override
  Future<Result<String>> getIdToken({bool forceRefresh = false}) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return Result.failure(Exception('No user is currently signed in'));
      }

      final idToken = await currentUser.getIdToken(forceRefresh);
      return Result.success(idToken ?? '');
    } catch (e) {
      _logger.error('Failed to get ID token', error: e);
      return Result.failure(Exception('Failed to get ID token'));
    }
  }

  @override
  Future<Result<bool>> isEmailAvailable(String email) async {
    // TODO: Implement when needed
    return Result.failure(Exception('Not implemented'));
  }

  @override
  Future<Result<List<String>>> getSignInMethodsForEmail(String email) async {
    try {
      _logger.info('Getting sign-in methods for email: $email');

      // Note: fetchSignInMethodsForEmail is deprecated for security reasons
      // Instead, we'll return common sign-in methods and let the user try
      // This prevents email enumeration attacks

      final commonMethods = <String>[
        'password',
        'google.com',
        'apple.com',
      ];

      _logger.info('Returning common sign-in methods');
      return Result.success(commonMethods);
    } catch (e) {
      _logger.error('Failed to get sign-in methods', error: e);
      return Result.failure(Exception('Failed to get sign-in methods: $e'));
    }
  }

  @override
  Future<Result<void>> setLanguageCode(String languageCode) async {
    try {
      _firebaseAuth.setLanguageCode(languageCode);
      _logger.info('Language code set to: $languageCode');
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to set language code', error: e);
      return Result.failure(Exception('Failed to set language code: $e'));
    }
  }

  @override
  Future<Result<void>> dispose() async {
    try {
      _logger.info('Disposing Firebase Auth service');

      await _authStateController.close();
      await _idTokenController.close();

      _logger.info('Firebase Auth service disposed');
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to dispose Firebase Auth service', error: e);
      return Result.failure(Exception('Failed to dispose service'));
    }
  }

  // Private helper methods

  auth_models.AuthResult _createAuthResult(UserCredential userCredential) {
    final user = userCredential.user;
    if (user == null) {
      return auth_models.AuthResult.failure('Authentication failed');
    }

    return auth_models.AuthResult.success(
      userId: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  Future<void> _storeUserSession(User? user) async {
    if (user != null) {
      await _secureStorage.writeString('user_id', user.uid);
      if (user.email != null) {
        await _secureStorage.writeString('user_email', user.email!);
      }
    }
  }

  Future<void> _clearUserSession() async {
    await _secureStorage.delete('user_id');
    await _secureStorage.delete('user_email');
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case auth_models.AuthErrorCodes.userNotFound:
        return 'No user found with this email address.';
      case auth_models.AuthErrorCodes.wrongPassword:
        return 'Incorrect password.';
      case auth_models.AuthErrorCodes.emailAlreadyInUse:
        return 'This email address is already in use.';
      case auth_models.AuthErrorCodes.weakPassword:
        return 'Password is too weak. Please choose a stronger password.';
      case auth_models.AuthErrorCodes.invalidEmail:
        return 'Invalid email address format.';
      case auth_models.AuthErrorCodes.userDisabled:
        return 'This user account has been disabled.';
      case auth_models.AuthErrorCodes.tooManyRequests:
        return 'Too many failed attempts. Please try again later.';
      case auth_models.AuthErrorCodes.networkRequestFailed:
        return 'Network error. Please check your connection.';
      case auth_models.AuthErrorCodes.requiresRecentLogin:
        return 'This operation requires recent authentication. Please sign in again.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
