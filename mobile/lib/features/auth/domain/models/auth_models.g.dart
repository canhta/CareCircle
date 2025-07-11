// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  email: json['email'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  isEmailVerified: json['isEmailVerified'] as bool,
  isPhoneVerified: json['isPhoneVerified'] as bool,
  isGuest: json['isGuest'] as bool,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  lastLoginAt: json['lastLoginAt'] == null
      ? null
      : DateTime.parse(json['lastLoginAt'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'isEmailVerified': instance.isEmailVerified,
  'isPhoneVerified': instance.isPhoneVerified,
  'isGuest': instance.isGuest,
  'createdAt': instance.createdAt?.toIso8601String(),
  'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
};

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  displayName: json['displayName'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  dateOfBirth: json['dateOfBirth'] == null
      ? null
      : DateTime.parse(json['dateOfBirth'] as String),
  gender: json['gender'] as String?,
  language: json['language'] as String? ?? 'ENGLISH',
  photoUrl: json['photoUrl'] as String?,
  useElderMode: json['useElderMode'] as bool? ?? false,
  preferredUnits:
      (json['preferredUnits'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  emergencyContact: json['emergencyContact'] as Map<String, dynamic>?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'language': instance.language,
      'photoUrl': instance.photoUrl,
      'useElderMode': instance.useElderMode,
      'preferredUnits': instance.preferredUnits,
      'emergencyContact': instance.emergencyContact,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) =>
    _AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      profile: json['profile'] == null
          ? null
          : UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseToJson(_AuthResponse instance) =>
    <String, dynamic>{'user': instance.user, 'profile': instance.profile};

_AuthState _$AuthStateFromJson(Map<String, dynamic> json) => _AuthState(
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  profile: json['profile'] == null
      ? null
      : UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
  isLoading: json['isLoading'] as bool? ?? false,
  error: json['error'] as String?,
  status:
      $enumDecodeNullable(_$AuthStatusEnumMap, json['status']) ??
      AuthStatus.unauthenticated,
);

Map<String, dynamic> _$AuthStateToJson(_AuthState instance) =>
    <String, dynamic>{
      'user': instance.user,
      'profile': instance.profile,
      'isLoading': instance.isLoading,
      'error': instance.error,
      'status': _$AuthStatusEnumMap[instance.status]!,
    };

const _$AuthStatusEnumMap = {
  AuthStatus.unauthenticated: 'unauthenticated',
  AuthStatus.authenticated: 'authenticated',
  AuthStatus.guest: 'guest',
  AuthStatus.loading: 'loading',
};

_RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    _RegisterRequest(
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      displayName: json['displayName'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      isGuest: json['isGuest'] as bool? ?? false,
      deviceId: json['deviceId'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(_RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'displayName': instance.displayName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'isGuest': instance.isGuest,
      'deviceId': instance.deviceId,
    };

_GuestLoginRequest _$GuestLoginRequestFromJson(Map<String, dynamic> json) =>
    _GuestLoginRequest(deviceId: json['deviceId'] as String);

Map<String, dynamic> _$GuestLoginRequestToJson(_GuestLoginRequest instance) =>
    <String, dynamic>{'deviceId': instance.deviceId};
