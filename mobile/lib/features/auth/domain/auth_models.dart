/// Authentication response model
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final User user;
  final int expiresIn;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.expiresIn,
  });

  /// Create from JSON
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] ?? json['access_token'] ?? '',
      refreshToken: json['refreshToken'] ?? json['refresh_token'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      expiresIn: json['expiresIn'] ?? json['expires_in'] ?? 3600,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
      'expiresIn': expiresIn,
    };
  }
}

/// User model
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? avatar;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime? dateOfBirth;
  final String? gender;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.avatar,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    this.dateOfBirth,
    this.gender,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Get name (for backward compatibility)
  String get name => fullName;

  /// Get initials
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();

  /// Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? json['first_name'] ?? '',
      lastName: json['lastName'] ?? json['last_name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone_number'],
      avatar: json['avatar'],
      isEmailVerified:
          json['isEmailVerified'] ?? json['email_verified'] ?? false,
      isPhoneVerified:
          json['isPhoneVerified'] ?? json['phone_verified'] ?? false,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
      createdAt:
          DateTime.tryParse(json['createdAt'] ?? json['created_at'] ?? '') ??
              DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] ?? json['updated_at'] ?? '') ??
              DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Copy with new values
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatar,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? dateOfBirth,
    String? gender,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, email: $email, name: $fullName)';
}

/// Login request model
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

/// Register request model
class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phoneNumber;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
    };
  }
}

/// Social login request model
class SocialLoginRequest {
  final String provider;
  final String idToken;
  final String? authorizationCode;
  final String? email;
  final String? firstName;
  final String? lastName;

  const SocialLoginRequest({
    required this.provider,
    required this.idToken,
    this.authorizationCode,
    this.email,
    this.firstName,
    this.lastName,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'idToken': idToken,
      if (authorizationCode != null) 'authorizationCode': authorizationCode,
      if (email != null) 'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
    };
  }
}

/// Forgot password request model
class ForgotPasswordRequest {
  final String email;

  const ForgotPasswordRequest({required this.email});

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}

/// Reset password request model
class ResetPasswordRequest {
  final String token;
  final String newPassword;

  const ResetPasswordRequest({
    required this.token,
    required this.newPassword,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'newPassword': newPassword,
    };
  }
}

/// Verify email request model
class VerifyEmailRequest {
  final String token;

  const VerifyEmailRequest({required this.token});

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'token': token};
  }
}

/// Update profile request model
class UpdateProfileRequest {
  final String? name;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? gender;

  const UpdateProfileRequest({
    this.name,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (name != null) {
      final nameParts = name!.trim().split(' ');
      data['firstName'] = nameParts.isNotEmpty ? nameParts[0] : '';
      data['lastName'] =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    }

    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (dateOfBirth != null) {
      data['dateOfBirth'] = dateOfBirth!.toIso8601String();
    }
    if (gender != null) data['gender'] = gender;

    return data;
  }
}
