// Authentication models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    String? email,
    String? phoneNumber,
    required bool isEmailVerified,
    required bool isPhoneVerified,
    required bool isGuest,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String displayName,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? gender,
    @Default('ENGLISH') String language,
    String? photoUrl,
    @Default(false) bool useElderMode,
    @Default(<String, String>{}) Map<String, String> preferredUnits,
    Map<String, dynamic>? emergencyContact,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@freezed
abstract class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required User user,
    UserProfile? profile,
    required String accessToken,
    required String refreshToken,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

enum AuthStatus { unauthenticated, authenticated, guest, loading }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
    UserProfile? profile,
    String? accessToken,
    String? refreshToken,
    @Default(false) bool isLoading,
    String? error,
    @Default(AuthStatus.unauthenticated) AuthStatus status,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}

@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

@freezed
abstract class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    String? email,
    String? phoneNumber,
    required String password,
    required String displayName,
    String? firstName,
    String? lastName,
    @Default(false) bool isGuest,
    String? deviceId,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

@freezed
abstract class GuestLoginRequest with _$GuestLoginRequest {
  const factory GuestLoginRequest({required String deviceId}) =
      _GuestLoginRequest;

  factory GuestLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$GuestLoginRequestFromJson(json);
}
