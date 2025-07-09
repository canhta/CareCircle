import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/logging/logging.dart';
import 'core/logging/error_tracker.dart';
import 'core/design/design_tokens.dart';
import 'features/auth/models/auth_models.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/welcome_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/convert_guest_screen.dart';
import 'features/auth/screens/forgot_password_screen.dart';
import 'features/home/screens/main_app_shell.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize healthcare-compliant logging system
  await AppLogger.initialize();
  await BoundedContextLoggers.initialize();

  // Initialize error tracking with Firebase Crashlytics
  await ErrorTracker.initialize();

  // Log application startup
  AppLogger.info('CareCircle mobile application starting', {'timestamp': DateTime.now().toIso8601String()});

  runApp(const ProviderScope(child: CareCircleApp()));
}

class CareCircleApp extends ConsumerWidget {
  const CareCircleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = _createRouter(ref);

    return MaterialApp.router(
      title: 'CareCircle',
      theme: _createTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      // Add navigation logging observer
      builder: (context, child) {
        return TalkerWrapper(talker: AppLogger.instance, options: LogConfig.talkerWrapperOptions, child: child!);
      },
    );
  }

  ThemeData _createTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CareCircleDesignTokens.primaryMedicalBlue,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      cardTheme: CardThemeData(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  GoRouter _createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final authState = ref.read(authNotifierProvider);
        final isLoggedIn = authState.status == AuthStatus.authenticated || authState.status == AuthStatus.guest;
        final isLoading = authState.status == AuthStatus.loading;

        // Don't redirect while loading
        if (isLoading) return null;

        // If logged in and trying to access auth routes, redirect to home
        if (isLoggedIn && state.matchedLocation.startsWith('/auth')) {
          return '/home';
        }

        // If not logged in and trying to access protected routes, redirect to welcome
        if (!isLoggedIn && state.matchedLocation.startsWith('/home')) {
          return '/';
        }

        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
        GoRoute(path: '/auth/login', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/auth/register', builder: (context, state) => const RegisterScreen()),
        GoRoute(path: '/auth/convert-guest', builder: (context, state) => const ConvertGuestScreen()),
        GoRoute(path: '/auth/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
        GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
        GoRoute(path: '/home', builder: (context, state) => const MainAppShell()),
      ],
    );
  }
}
