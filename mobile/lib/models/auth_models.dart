// Authentication Models and DTOs for CareCircle
// Matches backend NestJS API structure

class AuthTokens {
  final String accessToken;
  final String refreshToken;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RegisterRequest {
  final String email;
  final String password;
  final String? name;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? phoneNumber;

  RegisterRequest({
    required this.email,
    required this.password,
    this.name,
    this.dateOfBirth,
    this.gender,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        if (name != null) 'name': name,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
        if (gender != null) 'gender': gender,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      };
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        user: User.fromJson(json['user'] as Map<String, dynamic>),
      );
}

class User {
  final String id;
  final String email;
  final String? name;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? phoneNumber;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    this.name,
    this.dateOfBirth,
    this.gender,
    this.phoneNumber,
    required this.emailVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String?,
        dateOfBirth: json['dateOfBirth'] != null
            ? DateTime.parse(json['dateOfBirth'] as String)
            : null,
        gender: json['gender'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        emailVerified: json['emailVerified'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        if (name != null) 'name': name,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
        if (gender != null) 'gender': gender,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        'emailVerified': emailVerified,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class PasswordResetRequest {
  final String email;

  PasswordResetRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class PasswordResetConfirmRequest {
  final String token;
  final String newPassword;

  PasswordResetConfirmRequest({required this.token, required this.newPassword});

  Map<String, dynamic> toJson() => {'token': token, 'newPassword': newPassword};
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}

class UpdateProfileRequest {
  final String? name;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? phoneNumber;

  UpdateProfileRequest({
    this.name,
    this.dateOfBirth,
    this.gender,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
        if (gender != null) 'gender': gender,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      };
}

class OAuthSignInRequest {
  final String provider; // 'google' or 'apple'
  final String idToken;
  final String? accessToken;

  OAuthSignInRequest({
    required this.provider,
    required this.idToken,
    this.accessToken,
  });

  Map<String, dynamic> toJson() => {
        'provider': provider,
        'idToken': idToken,
        if (accessToken != null) 'accessToken': accessToken,
      };
}

// Authentication State
enum AuthState { unknown, authenticated, unauthenticated }

class AuthStatus {
  final AuthState state;
  final User? user;
  final String? errorMessage;

  AuthStatus({required this.state, this.user, this.errorMessage});

  bool get isAuthenticated => state == AuthState.authenticated;
  bool get isUnauthenticated => state == AuthState.unauthenticated;
  bool get isUnknown => state == AuthState.unknown;
}
