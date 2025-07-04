import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/app_config.dart';
import 'config/firebase_initializer.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/prescription_scanner_screen.dart';
import 'screens/notification_center_screen.dart';
import 'screens/notification_preferences_screen.dart';
import 'services/background_sync_service.dart';
import 'services/firebase_messaging_service.dart';
import 'services/auth_service.dart';
import 'services/logging_service.dart';
import 'managers/health_data_manager.dart';
import 'widgets/notification_handler.dart';
import 'models/auth_models.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging service
  LoggingService().initialize(isDevelopment: true);

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase using centralized initializer
  // This will handle the duplicate app error gracefully
  try {
    await FirebaseInitializer.ensureInitialized();
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization handled: $e');
    // Continue with app startup even if Firebase initialization has issues
  }

  // Initialize AppConfig
  try {
    await AppConfig.initialize();
    debugPrint('AppConfig initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize AppConfig: $e');
    // Continue with app startup even if AppConfig fails
  }

  // Validate configuration
  if (!AppConfig.validateConfig()) {
    debugPrint('Configuration validation failed. Please check your .env file.');
  }

  // Initialize Authentication Service
  try {
    final authService = AuthService();
    await authService.initialize();
    debugPrint('Auth Service initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize Auth Service: $e');
  }

  // Initialize Firebase Messaging Service
  try {
    final messagingService = FirebaseMessagingService();
    await messagingService.initialize();
    debugPrint('Firebase Messaging Service initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize Firebase Messaging Service: $e');
  }

  // Initialize background sync service
  try {
    final backgroundSyncService = BackgroundSyncService();
    await backgroundSyncService.initialize();
    await backgroundSyncService.registerPeriodicSync(
      frequency: const Duration(hours: 6),
      requiresNetworkConnectivity: true,
    );
    debugPrint('Background sync service initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize background sync service: $e');
  }

  // Initialize health data manager
  try {
    final healthDataManager = HealthDataManager();
    await healthDataManager.initialize();
    debugPrint('Health data manager initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize health data manager: $e');
  }

  // Print configuration in debug mode
  AppConfig.printConfig();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationHandler(
      onMessageReceived: (message) {
        debugPrint('App received foreground message: ${message.data}');
      },
      onMessageTap: (message) {
        debugPrint('App message tapped: ${message.data}');
      },
      onTokenRefresh: (token) {
        debugPrint('App FCM token refreshed');
      },
      child: MaterialApp(
        title: 'CareCircle',
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
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/prescription-scanner': (context) =>
              const PrescriptionScannerScreen(),
          '/notifications': (context) => const NotificationCenterScreen(),
          '/notification-preferences': (context) =>
              const NotificationPreferencesScreen(),
          '/medications': (context) =>
              const HomeScreen(), // TODO: Create MedicationsScreen
          '/health-check': (context) =>
              const HomeScreen(), // TODO: Create HealthCheckScreen
          '/care-group': (context) =>
              const HomeScreen(), // TODO: Create CareGroupScreen
          '/settings': (context) =>
              const HomeScreen(), // TODO: Create SettingsScreen
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      final user = await _authService.getCurrentUser();
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _currentUser != null ? const HomeScreen() : const LoginScreen();
  }
}
