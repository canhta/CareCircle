import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  // Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  // Check if biometric authentication is enabled for the app
  Future<bool> isBiometricEnabled() async {
    try {
      final String? enabled = await _secureStorage.read(
        key: 'biometric_enabled',
      );
      return enabled == 'true';
    } catch (e) {
      return false;
    }
  }

  // Enable biometric authentication
  Future<bool> enableBiometricAuth() async {
    try {
      // First check if biometric is available
      if (!await isBiometricAvailable()) {
        throw Exception(
          'Biometric authentication is not available on this device',
        );
      }

      // Authenticate with biometric to confirm setup
      final bool authenticated = await _authenticateWithBiometric(
        reason: 'Enable biometric authentication for secure access',
      );

      if (authenticated) {
        await _secureStorage.write(key: 'biometric_enabled', value: 'true');
        return true;
      }
      return false;
    } catch (e) {
      throw Exception(
        'Failed to enable biometric authentication: ${e.toString()}',
      );
    }
  }

  // Disable biometric authentication
  Future<void> disableBiometricAuth() async {
    try {
      await _secureStorage.delete(key: 'biometric_enabled');
      await _secureStorage.delete(key: 'biometric_credentials');
    } catch (e) {
      throw Exception(
        'Failed to disable biometric authentication: ${e.toString()}',
      );
    }
  }

  // Authenticate with biometric
  Future<bool> authenticateWithBiometric({String? reason}) async {
    try {
      if (!await isBiometricEnabled()) {
        return false;
      }

      return await _authenticateWithBiometric(
        reason: reason ?? 'Authenticate to access your account',
      );
    } catch (e) {
      throw Exception('Biometric authentication failed: ${e.toString()}');
    }
  }

  // Store credentials for biometric authentication
  Future<void> storeBiometricCredentials({
    required String email,
    required String encryptedPassword,
  }) async {
    try {
      if (!await isBiometricEnabled()) {
        throw Exception('Biometric authentication is not enabled');
      }

      final credentials = {
        'email': email,
        'encryptedPassword': encryptedPassword,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _secureStorage.write(
        key: 'biometric_credentials',
        value: jsonEncode(credentials),
      );
    } catch (e) {
      throw Exception('Failed to store biometric credentials: ${e.toString()}');
    }
  }

  // Get stored biometric credentials
  Future<Map<String, String>?> getBiometricCredentials() async {
    try {
      if (!await isBiometricEnabled()) {
        return null;
      }

      // Authenticate with biometric first
      final bool authenticated = await authenticateWithBiometric(
        reason: 'Authenticate to retrieve your saved credentials',
      );

      if (!authenticated) {
        return null;
      }

      final String? credentialsJson = await _secureStorage.read(
        key: 'biometric_credentials',
      );
      if (credentialsJson == null) {
        return null;
      }

      final Map<String, dynamic> credentials = jsonDecode(credentialsJson);
      return {
        'email': credentials['email'] as String,
        'encryptedPassword': credentials['encryptedPassword'] as String,
      };
    } catch (e) {
      return null;
    }
  }

  // Clear stored biometric credentials
  Future<void> clearBiometricCredentials() async {
    try {
      await _secureStorage.delete(key: 'biometric_credentials');
    } catch (e) {
      throw Exception('Failed to clear biometric credentials: ${e.toString()}');
    }
  }

  // Get biometric type display name
  String getBiometricTypeName(List<BiometricType> types) {
    if (types.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (types.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (types.contains(BiometricType.iris)) {
      return 'Iris';
    } else if (types.contains(BiometricType.strong)) {
      return 'Biometric';
    } else if (types.contains(BiometricType.weak)) {
      return 'Biometric';
    }
    return 'Biometric';
  }

  // Check if specific biometric type is available
  bool hasFaceID(List<BiometricType> types) {
    return types.contains(BiometricType.face);
  }

  bool hasFingerprint(List<BiometricType> types) {
    return types.contains(BiometricType.fingerprint);
  }

  bool hasIris(List<BiometricType> types) {
    return types.contains(BiometricType.iris);
  }

  // Private method to perform biometric authentication
  Future<bool> _authenticateWithBiometric({required String reason}) async {
    try {
      final bool authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );

      return authenticated;
    } on Exception catch (e) {
      throw Exception('Biometric authentication error: ${e.toString()}');
    }
  }

  // Validate biometric setup requirements
  Future<BiometricSetupStatus> validateBiometricSetup() async {
    try {
      final bool isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return BiometricSetupStatus.notAvailable;
      }

      final List<BiometricType> availableTypes = await getAvailableBiometrics();
      if (availableTypes.isEmpty) {
        return BiometricSetupStatus.notEnrolled;
      }

      final bool isEnabled = await isBiometricEnabled();
      if (!isEnabled) {
        return BiometricSetupStatus.availableNotEnabled;
      }

      return BiometricSetupStatus.enabled;
    } catch (e) {
      return BiometricSetupStatus.error;
    }
  }
}

// Enum for biometric setup status
enum BiometricSetupStatus {
  notAvailable,
  notEnrolled,
  availableNotEnabled,
  enabled,
  error,
}

// Extension for biometric setup status
extension BiometricSetupStatusExtension on BiometricSetupStatus {
  String get description {
    switch (this) {
      case BiometricSetupStatus.notAvailable:
        return 'Biometric authentication is not available on this device';
      case BiometricSetupStatus.notEnrolled:
        return 'No biometric credentials are enrolled on this device';
      case BiometricSetupStatus.availableNotEnabled:
        return 'Biometric authentication is available but not enabled';
      case BiometricSetupStatus.enabled:
        return 'Biometric authentication is enabled and ready';
      case BiometricSetupStatus.error:
        return 'Error checking biometric authentication status';
    }
  }

  bool get isUsable {
    return this == BiometricSetupStatus.enabled;
  }

  bool get canBeEnabled {
    return this == BiometricSetupStatus.availableNotEnabled;
  }
}
