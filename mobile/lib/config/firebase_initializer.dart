import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

/// Utility class for Firebase initialization
class FirebaseInitializer {
  /// Initialize Firebase if not already initialized
  static Future<void> ensureInitialized() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }
}
