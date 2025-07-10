import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/logging/logging.dart';
import 'core/logging/error_tracker.dart';
import 'core/storage/storage.dart';
import 'core/design/design_tokens.dart';
import 'app/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize healthcare-compliant logging system
  await AppLogger.initialize();
  await BoundedContextLoggers.initialize();

  // Initialize storage infrastructure
  await StorageService.initialize();

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
    final router = ref.watch(routerProvider);

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


}
