import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../logging/logging.dart';

/// Healthcare-compliant navigation service with comprehensive logging
///
/// This service provides centralized navigation management with detailed
/// logging for user journey tracking and debugging purposes.
class NavigationService {
  // Healthcare-compliant logger for navigation context
  static final _logger = BoundedContextLoggers.navigation;

  /// Navigate to a specific route with logging
  static void navigateTo(BuildContext context, String route, {Object? extra}) {
    _logger.logNavigationEvent('Navigation initiated', {
      'route': route,
      'hasExtra': extra != null,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      context.go(route, extra: extra);

      _logger.logNavigationEvent('Navigation completed', {
        'route': route,
        'success': true,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Navigation failed', {
        'route': route,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Push a new route onto the navigation stack
  static void pushRoute(BuildContext context, String route, {Object? extra}) {
    _logger.logNavigationEvent('Route push initiated', {
      'route': route,
      'hasExtra': extra != null,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      context.push(route, extra: extra);

      _logger.logNavigationEvent('Route push completed', {
        'route': route,
        'success': true,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Route push failed', {
        'route': route,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Pop the current route from the navigation stack
  static void popRoute(BuildContext context, {Object? result}) {
    _logger.logNavigationEvent('Route pop initiated', {
      'hasResult': result != null,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      context.pop(result);

      _logger.logNavigationEvent('Route pop completed', {
        'success': true,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Route pop failed', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Replace the current route
  static void replaceRoute(
    BuildContext context,
    String route, {
    Object? extra,
  }) {
    _logger.logNavigationEvent('Route replacement initiated', {
      'newRoute': route,
      'hasExtra': extra != null,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      context.pushReplacement(route, extra: extra);

      _logger.logNavigationEvent('Route replacement completed', {
        'newRoute': route,
        'success': true,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Route replacement failed', {
        'newRoute': route,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Navigate to authentication flow
  static void navigateToAuth(BuildContext context, {String? specificRoute}) {
    final route = specificRoute ?? '/auth/login';

    _logger.logNavigationEvent('Auth navigation initiated', {
      'authRoute': route,
      'timestamp': DateTime.now().toIso8601String(),
    });

    navigateTo(context, route);
  }

  /// Navigate to home after successful authentication
  static void navigateToHome(BuildContext context) {
    _logger.logNavigationEvent('Home navigation initiated', {
      'route': '/home',
      'context': 'post_authentication',
      'timestamp': DateTime.now().toIso8601String(),
    });

    navigateTo(context, '/home');
  }

  /// Navigate to onboarding flow
  static void navigateToOnboarding(BuildContext context) {
    _logger.logNavigationEvent('Onboarding navigation initiated', {
      'route': '/onboarding',
      'timestamp': DateTime.now().toIso8601String(),
    });

    navigateTo(context, '/onboarding');
  }

  /// Navigate to AI Assistant
  static void navigateToAIAssistant(
    BuildContext context, {
    String? conversationId,
  }) {
    final route = conversationId != null
        ? '/ai-assistant/conversation/$conversationId'
        : '/ai-assistant';

    _logger.logNavigationEvent('AI Assistant navigation initiated', {
      'route': route,
      'hasConversationId': conversationId != null,
      'timestamp': DateTime.now().toIso8601String(),
    });

    navigateTo(context, route);
  }

  /// Navigate to health data section
  static void navigateToHealthData(BuildContext context, {String? section}) {
    final route = section != null ? '/health_data/$section' : '/health_data';

    _logger.logNavigationEvent('Health data navigation initiated', {
      'route': route,
      'section': section,
      'timestamp': DateTime.now().toIso8601String(),
    });

    navigateTo(context, route);
  }

  /// Navigate to medication management
  static void navigateToMedications(
    BuildContext context, {
    String? medicationId,
  }) {
    final route = medicationId != null
        ? '/medications/$medicationId'
        : '/medications';

    _logger.logNavigationEvent('Medication navigation initiated', {
      'route': route,
      'hasMedicationId': medicationId != null,
      'timestamp': DateTime.now().toIso8601String(),
    });

    navigateTo(context, route);
  }

  /// Navigate to care group section
  static void navigateToCareGroup(BuildContext context, {String? groupId}) {
    final route = groupId != null ? '/care-group/$groupId' : '/care-group';

    _logger.logNavigationEvent('Care group navigation initiated', {
      'route': route,
      'hasGroupId': groupId != null,
      'timestamp': DateTime.now().toIso8601String(),
    });

    navigateTo(context, route);
  }

  /// Log deep link navigation
  static void logDeepLinkNavigation(
    String deepLink, {
    Map<String, dynamic>? parameters,
  }) {
    _logger.logNavigationEvent('Deep link navigation', {
      'deepLink': deepLink,
      'parameters': parameters ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Log navigation error
  static void logNavigationError(
    String operation,
    String error, {
    Map<String, dynamic>? context,
  }) {
    _logger.error('Navigation error occurred', {
      'operation': operation,
      'error': error,
      'context': context ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Log user journey milestone
  static void logJourneyMilestone(
    String milestone, {
    Map<String, dynamic>? context,
  }) {
    _logger.info('User journey milestone', {
      'milestone': milestone,
      'context': context ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Log tab navigation in main app shell
  static void logTabNavigation(int fromIndex, int toIndex, String tabName) {
    _logger.logNavigationEvent('Tab navigation', {
      'fromIndex': fromIndex,
      'toIndex': toIndex,
      'tabName': tabName,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Log back button press
  static void logBackButtonPress(BuildContext context) {
    _logger.logNavigationEvent('Back button pressed', {
      'currentRoute': GoRouterState.of(context).matchedLocation,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}

/// Custom route observer for comprehensive navigation logging
class HealthcareRouteObserver extends NavigatorObserver {
  static final _logger = BoundedContextLoggers.navigation;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    _logger.logNavigationEvent('Route pushed', {
      'routeName': route.settings.name ?? 'unknown',
      'previousRoute': previousRoute?.settings.name ?? 'none',
      'isInitialRoute': previousRoute == null,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    _logger.logNavigationEvent('Route popped', {
      'routeName': route.settings.name ?? 'unknown',
      'previousRoute': previousRoute?.settings.name ?? 'none',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    _logger.logNavigationEvent('Route replaced', {
      'newRoute': newRoute?.settings.name ?? 'unknown',
      'oldRoute': oldRoute?.settings.name ?? 'unknown',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);

    _logger.logNavigationEvent('Route removed', {
      'routeName': route.settings.name ?? 'unknown',
      'previousRoute': previousRoute?.settings.name ?? 'none',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
