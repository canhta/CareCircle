import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../services/background_message_handler.dart';
import '../../presentation/providers/notification_providers.dart';

/// Notification service initializer
///
/// Handles the initialization of the notification system:
/// - Sets up Firebase Cloud Messaging
/// - Registers background message handler
/// - Initializes FCM service
/// - Sets up notification providers
class NotificationServiceInitializer {
  static final _logger = BoundedContextLoggers.notification;

  /// Initialize the notification system
  static Future<void> initialize(WidgetRef ref) async {
    try {
      _logger.info('Initializing notification system', {
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Initialize FCM service through provider
      await ref.read(notificationServiceProvider.future);

      _logger.info('Notification system initialized successfully', {
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to initialize notification system', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Initialize notification system without ref (for main.dart)
  static Future<void> initializeStandalone() async {
    try {
      _logger.info('Initializing notification system (standalone)', {
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      _logger.info('Notification system background handler registered', {
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to initialize notification system (standalone)', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      // Don't rethrow in standalone mode to prevent app crash
    }
  }
}
