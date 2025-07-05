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
import 'features/background_sync/background_sync.dart';
import 'features/firebase_messaging/firebase_messaging.dart';
import 'features/auth/auth.dart';
import 'common/common.dart';
import 'managers/health_data_manager.dart';
// import 'widgets/notification_handler.dart'; // Temporarily disabled
// import 'models/auth_models.dart'; // Remove old import to avoid conflicts

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging service
  final logger = AppLogger();
  logger.initialize(isDevelopment: true);

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

  // Initialize secure storage
  final secureStorage = SecureStorageService();
  secureStorage.initialize();

  // Initialize API Client
  try {
    final apiClient = ApiClient.instance;
    await apiClient.initialize(
      secureStorage: secureStorage,
      logger: logger,
    );
    debugPrint('API Client initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize API Client: $e');
    // Continue with app startup even if API Client fails
  }

  // Validate configuration
  if (!AppConfig.validateConfig()) {
    debugPrint('Configuration validation failed. Please check your .env file.');
  }

  // Initialize Authentication Service
  try {
    AuthService(
      apiClient: ApiClient.instance,
      logger: logger,
      secureStorage: secureStorage,
    );
    debugPrint('Auth Service initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize Auth Service: $e');
  }

  // Initialize Firebase Messaging Service
  try {
    final messagingService = FirebaseMessagingService(
      logger: logger,
      secureStorage: secureStorage,
    );
    await messagingService.initialize();
    debugPrint('Firebase Messaging Service initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize Firebase Messaging Service: $e');
  }

  // Initialize background sync service
  try {
    final backgroundSyncService = BackgroundSyncService(
      apiClient: ApiClient.instance,
      logger: logger,
      secureStorage: secureStorage,
    );
    await backgroundSyncService.initialize();

    // Register periodic sync with new API
    await backgroundSyncService.registerPeriodicSync(
      configuration: const SyncConfiguration(
        frequency: Duration(hours: 6),
      ),
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
    return MaterialApp(
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
        '/prescription-scanner': (context) => const PrescriptionScannerScreen(),
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
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late final AuthService _authService;
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAuthService();
  }

  Future<void> _initializeAuthService() async {
    try {
      final logger = AppLogger();
      final secureStorage = SecureStorageService();

      _authService = AuthService(
        apiClient: ApiClient.instance,
        logger: logger,
        secureStorage: secureStorage,
      );

      await _checkAuthState();
    } catch (e) {
      debugPrint('Error initializing auth service: $e');
      if (mounted) {
        setState(() {
          _currentUser = null;
          _isLoading = false;
        });
      }
    }
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
