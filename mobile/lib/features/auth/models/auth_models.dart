// Manual JSON serialization - no code generation needed

class User {
  final String id;
  final String? email;
  final String? phoneNumber;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isGuest;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  const User({
    required this.id,
    this.email,
    this.phoneNumber,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isGuest,
    required this.createdAt,
    required this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool,
      isPhoneVerified: json['isPhoneVerified'] as bool,
      isGuest: json['isGuest'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'isGuest': isGuest,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? isGuest,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.isEmailVerified == isEmailVerified &&
        other.isPhoneVerified == isPhoneVerified &&
        other.isGuest == isGuest &&
        other.createdAt == createdAt &&
        other.lastLoginAt == lastLoginAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      phoneNumber,
      isEmailVerified,
      isPhoneVerified,
      isGuest,
      createdAt,
      lastLoginAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, phoneNumber: $phoneNumber, isEmailVerified: $isEmailVerified, isPhoneVerified: $isPhoneVerified, isGuest: $isGuest, createdAt: $createdAt, lastLoginAt: $lastLoginAt)';
  }
}

class UserProfile {
  final String id;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String language;
  final String? photoUrl;
  final bool useElderMode;
  final Map<String, String> preferredUnits;
  final Map<String, dynamic>? emergencyContact;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
    required this.language,
    this.photoUrl,
    required this.useElderMode,
    required this.preferredUnits,
    this.emergencyContact,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
      language: json['language'] as String? ?? 'ENGLISH',
      photoUrl: json['photoUrl'] as String?,
      useElderMode: json['useElderMode'] as bool? ?? false,
      preferredUnits: json['preferredUnits'] != null
          ? Map<String, String>.from(json['preferredUnits'] as Map)
          : <String, String>{},
      emergencyContact: json['emergencyContact'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'language': language,
      'photoUrl': photoUrl,
      'useElderMode': useElderMode,
      'preferredUnits': preferredUnits,
      'emergencyContact': emergencyContact,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? displayName,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? gender,
    String? language,
    String? photoUrl,
    bool? useElderMode,
    Map<String, String>? preferredUnits,
    Map<String, dynamic>? emergencyContact,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      language: language ?? this.language,
      photoUrl: photoUrl ?? this.photoUrl,
      useElderMode: useElderMode ?? this.useElderMode,
      preferredUnits: preferredUnits ?? this.preferredUnits,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.displayName == displayName &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender &&
        other.language == language &&
        other.photoUrl == photoUrl &&
        other.useElderMode == useElderMode &&
        _mapsEqual(other.preferredUnits, preferredUnits) &&
        _mapsEqual(other.emergencyContact, emergencyContact) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      displayName,
      firstName,
      lastName,
      dateOfBirth,
      gender,
      language,
      photoUrl,
      useElderMode,
      preferredUnits,
      emergencyContact,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, displayName: $displayName, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, gender: $gender, language: $language, photoUrl: $photoUrl, useElderMode: $useElderMode, preferredUnits: $preferredUnits, emergencyContact: $emergencyContact, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class AuthResponse {
  final User user;
  final UserProfile? profile;
  final String accessToken;
  final String refreshToken;

  const AuthResponse({
    required this.user,
    this.profile,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'profile': profile?.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  AuthResponse copyWith({
    User? user,
    UserProfile? profile,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthResponse(
      user: user ?? this.user,
      profile: profile ?? this.profile,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResponse &&
        other.user == user &&
        other.profile == profile &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode {
    return Object.hash(user, profile, accessToken, refreshToken);
  }

  @override
  String toString() {
    return 'AuthResponse(user: $user, profile: $profile, accessToken: $accessToken, refreshToken: $refreshToken)';
  }
}

enum AuthStatus { unauthenticated, authenticated, guest, loading }

class AuthState {
  final User? user;
  final UserProfile? profile;
  final String? accessToken;
  final String? refreshToken;
  final bool isLoading;
  final String? error;
  final AuthStatus status;

  const AuthState({
    this.user,
    this.profile,
    this.accessToken,
    this.refreshToken,
    this.isLoading = false,
    this.error,
    this.status = AuthStatus.unauthenticated,
  });

  AuthState copyWith({
    User? user,
    UserProfile? profile,
    String? accessToken,
    String? refreshToken,
    bool? isLoading,
    String? error,
    AuthStatus? status,
  }) {
    return AuthState(
      user: user ?? this.user,
      profile: profile ?? this.profile,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.user == user &&
        other.profile == profile &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(
      user,
      profile,
      accessToken,
      refreshToken,
      isLoading,
      error,
      status,
    );
  }

  @override
  String toString() {
    return 'AuthState(user: $user, profile: $profile, accessToken: $accessToken, refreshToken: $refreshToken, isLoading: $isLoading, error: $error, status: $status)';
  }
}

class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }

  LoginRequest copyWith({String? email, String? password}) {
    return LoginRequest(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginRequest &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return Object.hash(email, password);
  }

  @override
  String toString() {
    return 'LoginRequest(email: $email, password: [HIDDEN])';
  }
}

class RegisterRequest {
  final String? email;
  final String? phoneNumber;
  final String password;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final bool isGuest;
  final String? deviceId;

  const RegisterRequest({
    this.email,
    this.phoneNumber,
    required this.password,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.isGuest = false,
    this.deviceId,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      password: json['password'] as String,
      displayName: json['displayName'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      isGuest: json['isGuest'] as bool? ?? false,
      deviceId: json['deviceId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'isGuest': isGuest,
      'deviceId': deviceId,
    };
  }

  RegisterRequest copyWith({
    String? email,
    String? phoneNumber,
    String? password,
    String? displayName,
    String? firstName,
    String? lastName,
    bool? isGuest,
    String? deviceId,
  }) {
    return RegisterRequest(
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isGuest: isGuest ?? this.isGuest,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegisterRequest &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.password == password &&
        other.displayName == displayName &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.isGuest == isGuest &&
        other.deviceId == deviceId;
  }

  @override
  int get hashCode {
    return Object.hash(
      email,
      phoneNumber,
      password,
      displayName,
      firstName,
      lastName,
      isGuest,
      deviceId,
    );
  }

  @override
  String toString() {
    return 'RegisterRequest(email: $email, phoneNumber: $phoneNumber, password: [HIDDEN], displayName: $displayName, firstName: $firstName, lastName: $lastName, isGuest: $isGuest, deviceId: $deviceId)';
  }
}

class GuestLoginRequest {
  final String deviceId;

  const GuestLoginRequest({required this.deviceId});

  factory GuestLoginRequest.fromJson(Map<String, dynamic> json) {
    return GuestLoginRequest(deviceId: json['deviceId'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'deviceId': deviceId};
  }

  GuestLoginRequest copyWith({String? deviceId}) {
    return GuestLoginRequest(deviceId: deviceId ?? this.deviceId);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GuestLoginRequest && other.deviceId == deviceId;
  }

  @override
  int get hashCode {
    return deviceId.hashCode;
  }

  @override
  String toString() {
    return 'GuestLoginRequest(deviceId: $deviceId)';
  }
}

// Helper function for map equality comparison
bool _mapsEqual<K, V>(Map<K, V>? a, Map<K, V>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}
