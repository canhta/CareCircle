import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../common/common.dart';

/// Centralized Firebase initialization service
/// Handles Firebase app initialization and duplicate app prevention
class FirebaseInitializer {
  static bool _isInitialized = false;
  late final AppLogger _logger;

  FirebaseInitializer() {
    _logger = AppLogger('FirebaseInitializer');
  }

  /// Initialize Firebase with proper error handling
  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.info('Firebase already initialized');
      return;
    }

    try {
      _logger.info('Initializing Firebase...');

      // Initialize Firebase with the generated options
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      _isInitialized = true;
      _logger.info('Firebase initialized successfully');
    } catch (e) {
      // Handle the case where Firebase is already initialized
      if (e.toString().contains('already exists')) {
        _logger.info('Firebase app already exists, using existing instance');
        _isInitialized = true;
      } else {
        _logger.error('Failed to initialize Firebase', error: e);
        rethrow;
      }
    }
  }

  /// Ensure Firebase is initialized (safe to call multiple times)
  static Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      final initializer = FirebaseInitializer();
      await initializer.initialize();
    }
  }

  /// Check if Firebase is initialized
  static bool get isInitialized => _isInitialized;
}
