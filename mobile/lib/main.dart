import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Configuration and Service Locator
import 'config/service_locator.dart';
import 'utils/notification_manager.dart';
import 'utils/navigation_service.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/prescription_scanner_screen.dart';
import 'screens/notification_center_screen.dart';
import 'screens/notification_preferences_screen.dart';
import 'screens/medications_screen.dart';
import 'screens/health_check_screen.dart';
import 'screens/care_group_main_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/help_center_screen.dart';
import 'screens/contact_support_screen.dart';
import 'screens/reminders_screen.dart';
import 'screens/insights_screen.dart';

// Features and widgets
import 'features/auth/auth.dart';
import 'widgets/notification_handler.dart';
import 'widgets/error_boundary.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Get the notification manager from service locator
  final notificationManager = ServiceLocator.get<NotificationManager>();

  // Handle background message through notification manager
  await notificationManager.handleBackgroundMessage(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize all services through service locator
    await ServiceLocator.initialize();

    // Wait for critical services to be ready
    await ServiceLocator.waitForInitialization();

    // Configure Firebase Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Pass all uncaught asynchronous errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Set Firebase background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    debugPrint('App initialization completed successfully');
  } catch (e) {
    debugPrint('App initialization failed: $e');
    // Continue with app startup even if some services fail
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareCircle',
      // Use navigation service's navigator key for global navigation
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      // Wrap the entire app with NotificationHandler and ErrorBoundary
      home: const ErrorBoundary(
        errorMessage: 'Unable to load CareCircle app',
        child: NotificationHandler(
          child: AuthWrapper(),
        ),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/prescription-scanner': (context) => const PrescriptionScannerScreen(),
        '/notifications': (context) => const NotificationCenterScreen(),
        '/notification-preferences': (context) =>
            const NotificationPreferencesScreen(),
        '/medications': (context) => const MedicationsScreen(),
        '/health-check': (context) => const HealthCheckScreen(),
        '/care-group': (context) => const CareGroupScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/help-center': (context) => const HelpCenterScreen(),
        '/contact-support': (context) => const ContactSupportScreen(),
        '/reminders': (context) => const RemindersScreen(),
        '/insights': (context) => const InsightsScreen(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      // Get auth service from service locator
      final authService = ServiceLocator.get<AuthService>();
      final user = await authService.getCurrentUser();

      if (mounted) {
        setState(() {
          _currentUser = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error checking auth state: $e');
      if (mounted) {
        setState(() {
          _currentUser = null;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return _currentUser != null ? const HomeScreen() : const LoginScreen();
  }
}
