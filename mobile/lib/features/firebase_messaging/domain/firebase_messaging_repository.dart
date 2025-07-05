import '../../../common/common.dart';
import '../models/firebase_messaging_models.dart';

/// Repository interface for Firebase Messaging
abstract class FirebaseMessagingRepository {
  /// Initialize the messaging service
  Future<Result<void>> initialize();

  /// Get the current FCM token
  Future<Result<String>> getToken();

  /// Check if notifications are enabled
  Future<Result<bool>> areNotificationsEnabled();

  /// Request notification permissions
  Future<Result<NotificationPermissionStatus>> requestPermissions();

  /// Subscribe to a topic
  Future<Result<void>> subscribeToTopic(String topic);

  /// Unsubscribe from a topic
  Future<Result<void>> unsubscribeFromTopic(String topic);

  /// Send a message to the server
  Future<Result<void>> sendMessage(NotificationMessage message);

  /// Get stored messages
  Future<Result<List<NotificationMessage>>> getStoredMessages();

  /// Clear stored messages
  Future<Result<void>> clearStoredMessages();

  /// Track message interaction
  Future<Result<void>> trackMessageInteraction(MessageInteraction interaction);

  /// Set message handlers
  void setOnMessageReceived(Function(NotificationMessage) handler);
  void setOnMessageTapped(Function(NotificationMessage) handler);
  void setOnTokenRefresh(Function(String) handler);
  void setOnError(Function(String) handler);

  /// Check if the service is initialized
  bool get isInitialized;

  /// Get current device info
  Future<Result<MessagingDeviceInfo>> getDeviceInfo();

  /// Dispose resources
  Future<Result<void>> dispose();
}
