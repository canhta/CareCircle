import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Core imports
import '../core/logging/bounded_context_loggers.dart';

// Authentication imports
import '../features/auth/domain/models/auth_models.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/screens/welcome_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/convert_guest_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';

// Feature imports
import '../features/home/screens/main_app_shell.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/health_data/presentation/screens/health_dashboard_screen.dart';
import '../features/medication/presentation/screens/medication_list_screen.dart';
import '../features/medication/presentation/screens/medication_detail_screen.dart';
import '../features/medication/presentation/screens/medication_form_screen.dart';
import '../features/medication/presentation/screens/prescription_scan_screen.dart';
import '../features/medication/presentation/screens/schedule_management_screen.dart';
import '../features/medication/presentation/screens/adherence_dashboard_screen.dart';
import '../features/notification/presentation/screens/notification_center_screen.dart';
import '../features/notification/presentation/screens/notification_detail_screen.dart';
import '../features/notification/presentation/screens/notification_preferences_screen.dart';
import '../features/notification/presentation/screens/emergency_alert_screen.dart';

/// Healthcare-compliant logger for navigation context
final _logger = BoundedContextLoggers.navigation;

/// Router provider that creates and manages the app's routing configuration
final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.createRouter(ref);
});

/// App router configuration class
class AppRouter {
  /// Creates the main GoRouter instance with authentication-aware routing
  static GoRouter createRouter(Ref ref) {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      redirect: (BuildContext context, GoRouterState state) {
        return _handleAuthRedirect(ref, context, state);
      },
      routes: _buildRoutes(),
      errorBuilder: (context, state) => _buildErrorScreen(context, state),
    );
  }

  /// Handles authentication-based redirects
  static String? _handleAuthRedirect(
    Ref ref,
    BuildContext context,
    GoRouterState state,
  ) {
    final authState = ref.read(authNotifierProvider);
    final isLoggedIn =
        authState.status == AuthStatus.authenticated ||
        authState.status == AuthStatus.guest;
    final isLoading = authState.status == AuthStatus.loading;
    final currentLocation = state.matchedLocation;

    _logger.logNavigationEvent('Route redirect check', {
      'currentLocation': currentLocation,
      'authStatus': authState.status.name,
      'isLoggedIn': isLoggedIn,
      'isLoading': isLoading,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Don't redirect while loading
    if (isLoading) {
      _logger.logNavigationEvent('Redirect skipped - auth loading', {
        'location': currentLocation,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return null;
    }

    // If logged in and trying to access auth routes, redirect to home
    if (isLoggedIn && currentLocation.startsWith('/auth')) {
      _logger.logNavigationEvent('Redirect to home - user authenticated', {
        'fromLocation': currentLocation,
        'toLocation': '/home',
        'authStatus': authState.status.name,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return '/home';
    }

    // If not logged in and trying to access protected routes, redirect to welcome
    if (!isLoggedIn && _isProtectedRoute(currentLocation)) {
      _logger
          .logNavigationEvent('Redirect to welcome - user not authenticated', {
            'fromLocation': currentLocation,
            'toLocation': '/',
            'authStatus': authState.status.name,
            'timestamp': DateTime.now().toIso8601String(),
          });
      return '/';
    }

    return null;
  }

  /// Checks if a route requires authentication
  static bool _isProtectedRoute(String location) {
    final protectedRoutes = ['/home', '/health_data', '/onboarding', '/notifications'];
    return protectedRoutes.any((route) => location.startsWith(route));
  }

  /// Builds the main route configuration
  static List<RouteBase> _buildRoutes() {
    return [
      // Public routes (no authentication required)
      ..._buildPublicRoutes(),

      // Authentication routes
      ..._buildAuthRoutes(),

      // Protected routes (authentication required)
      ..._buildProtectedRoutes(),
    ];
  }

  /// Public routes accessible without authentication
  static List<RouteBase> _buildPublicRoutes() {
    return [
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) {
          _logger.logNavigationEvent('Welcome screen accessed', {
            'timestamp': DateTime.now().toIso8601String(),
          });
          return const WelcomeScreen();
        },
      ),
    ];
  }

  /// Authentication-related routes
  static List<RouteBase> _buildAuthRoutes() {
    return [
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) {
          _logger.logNavigationEvent('Login screen accessed', {
            'timestamp': DateTime.now().toIso8601String(),
          });
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/auth/register',
        name: 'register',
        builder: (context, state) {
          _logger.logNavigationEvent('Register screen accessed', {
            'timestamp': DateTime.now().toIso8601String(),
          });
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: '/auth/convert-guest',
        name: 'convert-guest',
        builder: (context, state) {
          _logger.logNavigationEvent('Convert guest screen accessed', {
            'timestamp': DateTime.now().toIso8601String(),
          });
          return const ConvertGuestScreen();
        },
      ),
      GoRoute(
        path: '/auth/forgot-password',
        name: 'forgot-password',
        builder: (context, state) {
          _logger.logNavigationEvent('Forgot password screen accessed', {
            'timestamp': DateTime.now().toIso8601String(),
          });
          return const ForgotPasswordScreen();
        },
      ),
    ];
  }

  /// Protected routes that require authentication
  static List<RouteBase> _buildProtectedRoutes() {
    return [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) {
          _logger.logNavigationEvent('Onboarding screen accessed', {
            'timestamp': DateTime.now().toIso8601String(),
          });
          return const OnboardingScreen();
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) {
          _logger.logNavigationEvent('Home screen accessed', {
            'timestamp': DateTime.now().toIso8601String(),
          });
          return const MainAppShell();
        },
      ),
      GoRoute(
        path: '/health_data',
        name: 'health-data',
        builder: (context, state) {
          _logger.logNavigationEvent('Health data screen accessed', {
            'timestamp': DateTime.now().toIso8601String(),
          });
          return const HealthDashboardScreen();
        },
      ),
      // Medication Management Routes
      GoRoute(
        path: '/medications',
        name: 'medications',
        builder: (context, state) {
          _logger.logNavigationEvent('Medications screen accessed', {
            'timestamp': DateTime.now().toIso8601String(),
          });
          return const MedicationListScreen();
        },
        routes: [
          GoRoute(
            path: '/detail/:id',
            name: 'medication-detail',
            builder: (context, state) {
              final medicationId = state.pathParameters['id']!;
              _logger.logNavigationEvent('Medication detail screen accessed', {
                'medicationId': medicationId,
                'timestamp': DateTime.now().toIso8601String(),
              });
              return MedicationDetailScreen(medicationId: medicationId);
            },
          ),
          GoRoute(
            path: '/add',
            name: 'add-medication',
            builder: (context, state) {
              _logger.logNavigationEvent('Add medication screen accessed', {
                'timestamp': DateTime.now().toIso8601String(),
              });
              return const MedicationFormScreen();
            },
          ),
          GoRoute(
            path: '/edit/:id',
            name: 'edit-medication',
            builder: (context, state) {
              final medicationId = state.pathParameters['id']!;
              _logger.logNavigationEvent('Edit medication screen accessed', {
                'medicationId': medicationId,
                'timestamp': DateTime.now().toIso8601String(),
              });
              return MedicationFormScreen(medicationId: medicationId);
            },
          ),
          GoRoute(
            path: '/scan',
            name: 'prescription-scan',
            builder: (context, state) {
              _logger.logNavigationEvent('Prescription scan screen accessed', {
                'timestamp': DateTime.now().toIso8601String(),
              });
              return const PrescriptionScanScreen();
            },
          ),
          GoRoute(
            path: '/schedules',
            name: 'medication-schedules',
            builder: (context, state) {
              _logger.logNavigationEvent(
                'Medication schedules screen accessed',
                {'timestamp': DateTime.now().toIso8601String()},
              );
              // For general schedule management, we'll show all schedules
              return const ScheduleManagementScreen();
            },
          ),
          GoRoute(
            path: '/schedules/:medicationId',
            name: 'medication-schedule-detail',
            builder: (context, state) {
              final medicationId = state.pathParameters['medicationId']!;
              _logger
                  .logNavigationEvent('Medication schedule detail accessed', {
                    'medicationId': medicationId,
                    'timestamp': DateTime.now().toIso8601String(),
                  });
              return ScheduleManagementScreen(medicationId: medicationId);
            },
          ),
          GoRoute(
            path: '/adherence',
            name: 'adherence-dashboard',
            builder: (context, state) {
              _logger.logNavigationEvent(
                'Adherence dashboard screen accessed',
                {'timestamp': DateTime.now().toIso8601String()},
              );
              return const AdherenceDashboardScreen();
            },
          ),
        ],
      ),
      // Notification Management Routes
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) {
          _logger.logNavigationEvent('Notification center accessed', {
            'timestamp': DateTime.now().toIso8601String(),
          });
          return const NotificationCenterScreen();
        },
        routes: [
          GoRoute(
            path: '/:id',
            name: 'notification-detail',
            builder: (context, state) {
              final notificationId = state.pathParameters['id']!;
              _logger.logNavigationEvent('Notification detail accessed', {
                'notificationId': notificationId,
                'timestamp': DateTime.now().toIso8601String(),
              });
              return NotificationDetailScreen(notificationId: notificationId);
            },
          ),
          GoRoute(
            path: '/preferences',
            name: 'notification-preferences',
            builder: (context, state) {
              _logger.logNavigationEvent('Notification preferences accessed', {
                'timestamp': DateTime.now().toIso8601String(),
              });
              return const NotificationPreferencesScreen();
            },
          ),
          GoRoute(
            path: '/emergency-alerts',
            name: 'emergency-alerts',
            builder: (context, state) {
              _logger.logNavigationEvent('Emergency alerts accessed', {
                'timestamp': DateTime.now().toIso8601String(),
              });
              return const EmergencyAlertScreen();
            },
          ),
        ],
      ),
    ];
  }

  /// Builds error screen for unmatched routes
  static Widget _buildErrorScreen(BuildContext context, GoRouterState state) {
    _logger.error('Route not found', {
      'location': state.matchedLocation,
      'fullPath': state.fullPath,
      'timestamp': DateTime.now().toIso8601String(),
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.matchedLocation}" could not be found.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
