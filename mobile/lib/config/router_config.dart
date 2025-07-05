import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/health_dashboard.dart';
import '../screens/health_data_screen.dart';
import '../screens/privacy_settings_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/prescription_scanner_screen.dart';
import '../screens/notification_center_screen.dart';
import '../screens/notification_preferences_screen.dart';
import '../screens/medications_screen.dart';
import '../screens/health_check_screen.dart';
import '../screens/care_groups_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/help_center_screen.dart';
import '../screens/contact_support_screen.dart';
import '../screens/reminders_screen.dart';
import '../screens/insights_screen.dart';

// Router configuration provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main app routes (protected)
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/health',
            name: 'health',
            builder: (context, state) => const HealthDashboard(healthData: []),
          ),
          GoRoute(
            path: '/health-data',
            name: 'health-data',
            builder: (context, state) => const HealthDataScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const PrivacySettingsScreen(),
          ),
          GoRoute(
            path: '/prescription-scanner',
            name: 'prescription-scanner',
            builder: (context, state) => const PrescriptionScannerScreen(),
          ),
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationCenterScreen(),
          ),
          GoRoute(
            path: '/notification-preferences',
            name: 'notification-preferences',
            builder: (context, state) => const NotificationPreferencesScreen(),
          ),
          GoRoute(
            path: '/medications',
            name: 'medications',
            builder: (context, state) => const MedicationsScreen(),
          ),
          GoRoute(
            path: '/health-check',
            name: 'health-check',
            builder: (context, state) => const HealthCheckScreen(),
          ),
          GoRoute(
            path: '/care-group',
            name: 'care-group',
            builder: (context, state) => const CareGroupsScreen(),
          ),
          GoRoute(
            path: '/app-settings',
            name: 'app-settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/help-center',
            name: 'help-center',
            builder: (context, state) => const HelpCenterScreen(),
          ),
          GoRoute(
            path: '/contact-support',
            name: 'contact-support',
            builder: (context, state) => const ContactSupportScreen(),
          ),
          GoRoute(
            path: '/reminders',
            name: 'reminders',
            builder: (context, state) => const RemindersScreen(),
          ),
          GoRoute(
            path: '/insights',
            name: 'insights',
            builder: (context, state) => const InsightsScreen(),
          ),
        ],
      ),
    ],

    // Global redirect for authentication
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isAuthenticated = user != null;

      // Public routes that don't require authentication
      final publicRoutes = ['/login', '/register', '/forgot-password'];
      final isPublicRoute = publicRoutes.contains(state.matchedLocation);

      // If not authenticated and trying to access protected route
      if (!isAuthenticated && !isPublicRoute) {
        return '/login';
      }

      // If authenticated and trying to access auth routes
      if (isAuthenticated && isPublicRoute) {
        return '/';
      }

      // No redirect needed
      return null;
    },

    // Error handling
    errorBuilder: (context, state) => ErrorScreen(error: state.error),

    // Debug logging
    debugLogDiagnostics: true,
  );
});

// Main scaffold with bottom navigation
class MainScaffold extends ConsumerWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
            label: 'Health',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            label: 'Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    switch (location) {
      case '/':
        return 0;
      case '/health':
        return 1;
      case '/health-data':
        return 2;
      case '/profile':
        return 3;
      default:
        return 0;
    }
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/health');
        break;
      case 2:
        context.go('/health-data');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}

// Error screen for handling routing errors
class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'An error occurred',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
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

// Extension for easier navigation
extension GoRouterExtensions on BuildContext {
  /// Navigate to login screen
  void goToLogin() => go('/login');

  /// Navigate to register screen
  void goToRegister() => go('/register');

  /// Navigate to home screen
  void goToHome() => go('/');

  /// Navigate to health dashboard
  void goToHealth() => go('/health');

  /// Navigate to health data screen
  void goToHealthData() => go('/health-data');

  /// Navigate to profile screen
  void goToProfile() => go('/profile');

  /// Navigate to settings screen
  void goToSettings() => go('/settings');

  /// Navigate to forgot password screen
  void goToForgotPassword() => go('/forgot-password');

  /// Navigate to prescription scanner screen
  void goToPrescriptionScanner() => go('/prescription-scanner');

  /// Navigate to notifications screen
  void goToNotifications() => go('/notifications');

  /// Navigate to notification preferences screen
  void goToNotificationPreferences() => go('/notification-preferences');

  /// Navigate to medications screen
  void goToMedications() => go('/medications');

  /// Navigate to health check screen
  void goToHealthCheck() => go('/health-check');

  /// Navigate to care group screen
  void goToCareGroup() => go('/care-group');

  /// Navigate to app settings screen
  void goToAppSettings() => go('/app-settings');

  /// Navigate to help center screen
  void goToHelpCenter() => go('/help-center');

  /// Navigate to contact support screen
  void goToContactSupport() => go('/contact-support');

  /// Navigate to reminders screen
  void goToReminders() => go('/reminders');

  /// Navigate to insights screen
  void goToInsights() => go('/insights');
}

// Route names for type safety
abstract class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/';
  static const String health = '/health';
  static const String healthData = '/health-data';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String prescriptionScanner = '/prescription-scanner';
  static const String notifications = '/notifications';
  static const String notificationPreferences = '/notification-preferences';
  static const String medications = '/medications';
  static const String healthCheck = '/health-check';
  static const String careGroup = '/care-group';
  static const String appSettings = '/app-settings';
  static const String helpCenter = '/help-center';
  static const String contactSupport = '/contact-support';
  static const String reminders = '/reminders';
  static const String insights = '/insights';
}
