import 'package:flutter/material.dart';
import '../common/common.dart';

/// Navigation service for handling app navigation
/// Provides centralized navigation that can be called from anywhere
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  late final AppLogger _logger;

  NavigationService() {
    _logger = AppLogger('NavigationService');
  }

  /// Get the current navigation context
  BuildContext? get currentContext => navigatorKey.currentContext;

  /// Navigate to a named route
  Future<dynamic> navigateToRoute(String routeName,
      {Map<String, dynamic>? arguments}) async {
    _logger.info('Navigating to route: $routeName');

    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!
          .pushNamed(routeName, arguments: arguments);
    } else {
      _logger
          .warning('Navigation state is null, cannot navigate to $routeName');
      return null;
    }
  }

  /// Navigate and replace current route
  Future<dynamic> navigateAndReplace(String routeName,
      {Map<String, dynamic>? arguments}) async {
    _logger.info('Navigating and replacing with route: $routeName');

    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!
          .pushReplacementNamed(routeName, arguments: arguments);
    } else {
      _logger
          .warning('Navigation state is null, cannot navigate to $routeName');
      return null;
    }
  }

  /// Navigate and clear all previous routes
  Future<dynamic> navigateAndClearStack(String routeName,
      {Map<String, dynamic>? arguments}) async {
    _logger.info('Navigating and clearing stack to route: $routeName');

    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName,
        (route) => false,
        arguments: arguments,
      );
    } else {
      _logger
          .warning('Navigation state is null, cannot navigate to $routeName');
      return null;
    }
  }

  /// Go back to previous screen
  void goBack({dynamic result}) {
    _logger.info('Going back to previous screen');

    if (navigatorKey.currentState != null &&
        navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop(result);
    } else {
      _logger.warning('Cannot go back, no previous screen available');
    }
  }

  /// Navigate based on notification message type
  Future<void> navigateFromNotification(
      String messageType, Map<String, dynamic> payload) async {
    _logger.info('Navigating from notification: $messageType');

    switch (messageType) {
      case 'medication_reminder':
        await navigateToRoute('/medications', arguments: {
          'medication_id': payload['medication_id'],
          'from_notification': true,
        });
        break;

      case 'emergency_alert':
        await navigateToRoute('/emergency', arguments: {
          'alert_type': payload['alert_type'],
          'from_notification': true,
        });
        break;

      case 'check_in_reminder':
        await navigateToRoute('/health-check', arguments: {
          'check_in_type': payload['check_in_type'],
          'from_notification': true,
        });
        break;

      case 'care_group_update':
        await navigateToRoute('/care-group', arguments: {
          'group_id': payload['group_id'],
          'from_notification': true,
        });
        break;

      default:
        _logger.warning('Unknown notification message type: $messageType');
        // Default to home screen
        await navigateToRoute('/home');
    }
  }

  /// Show modal bottom sheet
  Future<T?> showModal<T>(Widget child,
      {bool isScrollControlled = false}) async {
    if (currentContext != null) {
      return showModalBottomSheet<T>(
        context: currentContext!,
        isScrollControlled: isScrollControlled,
        builder: (context) => child,
      );
    }
    return null;
  }

  /// Show dialog
  Future<T?> showDialogModal<T>(Widget child) async {
    if (currentContext != null) {
      return showDialog<T>(
        context: currentContext!,
        builder: (context) => child,
      );
    }
    return null;
  }

  /// Show snackbar
  void showSnackBar(String message,
      {SnackBarAction? action, Duration? duration}) {
    if (currentContext != null) {
      ScaffoldMessenger.of(currentContext!).showSnackBar(
        SnackBar(
          content: Text(message),
          action: action,
          duration: duration ?? const Duration(seconds: 4),
        ),
      );
    }
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      duration: const Duration(seconds: 6),
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      duration: const Duration(seconds: 3),
    );
  }
}
