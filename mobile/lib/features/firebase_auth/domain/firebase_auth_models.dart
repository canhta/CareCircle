/// Firebase authentication models
library;

/// Authentication result wrapper
class AuthResult {
  final bool success;
  final String? userId;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? error;
  final Map<String, dynamic>? metadata;

  const AuthResult({
    required this.success,
    this.userId,
    this.email,
    this.displayName,
    this.photoUrl,
    this.error,
    this.metadata,
  });

  factory AuthResult.success({
    required String userId,
    String? email,
    String? displayName,
    String? photoUrl,
    Map<String, dynamic>? metadata,
  }) {
    return AuthResult(
      success: true,
      userId: userId,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      metadata: metadata,
    );
  }

  factory AuthResult.failure(String error) {
    return AuthResult(
      success: false,
      error: error,
    );
  }

  AuthResult copyWith({
    bool? success,
    String? userId,
    String? email,
    String? displayName,
    String? photoUrl,
    String? error,
    Map<String, dynamic>? metadata,
  }) {
    return AuthResult(
      success: success ?? this.success,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      error: error ?? this.error,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// User authentication data
class AuthUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool emailVerified;
  final DateTime? createdAt;
  final DateTime? lastSignInAt;
  final List<String> signInMethods;
  final Map<String, dynamic>? customClaims;

  const AuthUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.emailVerified,
    this.createdAt,
    this.lastSignInAt,
    this.signInMethods = const [],
    this.customClaims,
  });

  factory AuthUser.fromFirebaseUser(dynamic firebaseUser) {
    // In a real implementation, this would map from Firebase User
    return AuthUser(
      uid: firebaseUser?.uid ?? '',
      email: firebaseUser?.email,
      displayName: firebaseUser?.displayName,
      photoUrl: firebaseUser?.photoURL,
      emailVerified: firebaseUser?.emailVerified ?? false,
      createdAt: firebaseUser?.metadata?.creationTime,
      lastSignInAt: firebaseUser?.metadata?.lastSignInTime,
      signInMethods: firebaseUser?.providerData
              ?.map<String>((provider) => provider.providerId)
              ?.toList() ??
          [],
    );
  }

  AuthUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? lastSignInAt,
    List<String>? signInMethods,
    Map<String, dynamic>? customClaims,
  }) {
    return AuthUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      signInMethods: signInMethods ?? this.signInMethods,
      customClaims: customClaims ?? this.customClaims,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      'createdAt': createdAt?.toIso8601String(),
      'lastSignInAt': lastSignInAt?.toIso8601String(),
      'signInMethods': signInMethods,
      'customClaims': customClaims,
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lastSignInAt: json['lastSignInAt'] != null
          ? DateTime.parse(json['lastSignInAt'])
          : null,
      signInMethods: List<String>.from(json['signInMethods'] ?? []),
      customClaims: json['customClaims'] as Map<String, dynamic>?,
    );
  }
}

/// Authentication credentials for different sign-in methods
abstract class AuthCredential {
  const AuthCredential();
}

class EmailPasswordCredential extends AuthCredential {
  final String email;
  final String password;

  const EmailPasswordCredential({
    required this.email,
    required this.password,
  });
}

class GoogleCredential extends AuthCredential {
  final String idToken;
  final String? accessToken;

  const GoogleCredential({
    required this.idToken,
    this.accessToken,
  });
}

class AppleCredential extends AuthCredential {
  final String identityToken;
  final String authorizationCode;

  const AppleCredential({
    required this.identityToken,
    required this.authorizationCode,
  });
}

class PhoneCredential extends AuthCredential {
  final String verificationId;
  final String smsCode;

  const PhoneCredential({
    required this.verificationId,
    required this.smsCode,
  });
}

/// Email verification request
class EmailVerificationRequest {
  final String email;
  final String? continueUrl;
  final Map<String, dynamic>? actionCodeSettings;

  const EmailVerificationRequest({
    required this.email,
    this.continueUrl,
    this.actionCodeSettings,
  });
}

/// Password reset request
class PasswordResetRequest {
  final String email;
  final String? continueUrl;
  final Map<String, dynamic>? actionCodeSettings;

  const PasswordResetRequest({
    required this.email,
    this.continueUrl,
    this.actionCodeSettings,
  });
}

/// Phone verification request
class PhoneVerificationRequest {
  final String phoneNumber;
  final int? timeout;
  final String? verificationId;

  const PhoneVerificationRequest({
    required this.phoneNumber,
    this.timeout,
    this.verificationId,
  });
}

/// Authentication state enumeration
enum AuthenticationState {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

/// Authentication error codes
class AuthErrorCodes {
  static const String userNotFound = 'user-not-found';
  static const String wrongPassword = 'wrong-password';
  static const String emailAlreadyInUse = 'email-already-in-use';
  static const String weakPassword = 'weak-password';
  static const String invalidEmail = 'invalid-email';
  static const String userDisabled = 'user-disabled';
  static const String tooManyRequests = 'too-many-requests';
  static const String networkRequestFailed = 'network-request-failed';
  static const String requiresRecentLogin = 'requires-recent-login';
}
