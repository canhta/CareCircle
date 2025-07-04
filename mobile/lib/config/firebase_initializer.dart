import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

/// Utility class for Firebase initialization
class FirebaseInitializer {
  static bool _isInitialized = false;

  /// Initialize Firebase if not already initialized
  static Future<void> ensureInitialized() async {
    if (_isInitialized) {
      debugPrint('Firebase already initialized by FirebaseInitializer');
      return;
    }

    try {
      // Check if Firebase is already initialized by other means
      if (Firebase.apps.isNotEmpty) {
        debugPrint(
            'Firebase already initialized: ${Firebase.apps.length} app(s) found');
        _isInitialized = true;
        return;
      }

      // Initialize Firebase
      debugPrint('Initializing Firebase...');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      _isInitialized = true;
      debugPrint('Firebase initialized successfully');
    } on FirebaseException catch (e) {
      debugPrint(
          'FirebaseException during initialization: ${e.code} - ${e.message}');

      // Handle specific Firebase exceptions
      if (e.code == 'duplicate-app') {
        // Firebase is already initialized, this is not an error
        debugPrint('Firebase already initialized (duplicate-app error caught)');
        _isInitialized = true;
        return;
      }

      // Re-throw other Firebase exceptions
      rethrow;
    } catch (e) {
      debugPrint('General error during Firebase initialization: $e');

      // Check if error message contains duplicate app indicators
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('duplicate') ||
          errorString.contains('already exists') ||
          errorString.contains('already initialized')) {
        debugPrint(
            'Firebase already initialized (caught general duplicate error)');
        _isInitialized = true;
        return;
      }

      // Re-throw other errors
      rethrow;
    }
  }

  /// Get the current Firebase app instance
  static FirebaseApp get app {
    if (Firebase.apps.isEmpty) {
      throw FirebaseException(
        plugin: 'firebase_core',
        code: 'no-app',
        message:
            'Firebase has not been initialized. Call ensureInitialized() first.',
      );
    }
    return Firebase.app();
  }

  /// Check if Firebase is initialized
  static bool get isInitialized => _isInitialized && Firebase.apps.isNotEmpty;
}
