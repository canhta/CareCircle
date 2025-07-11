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
  AppLogger.info('CareCircle mobile application starting', {
    'timestamp': DateTime.now().toIso8601String(),
  });

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
        return TalkerWrapper(
          talker: AppLogger.instance,
          options: LogConfig.talkerWrapperOptions,
          child: child!,
        );
      },
    );
  }

  ThemeData _createTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: CareCircleColorTokens.lightColorScheme,
      textTheme: CareCircleTypographyTokens.textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: CareCircleColorTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        titleTextStyle: CareCircleTypographyTokens.textTheme.titleLarge
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
        ),
        margin: EdgeInsets.all(CareCircleSpacingTokens.sm),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(
            CareCircleSpacingTokens.touchTargetMin,
            CareCircleSpacingTokens.touchTargetMin,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: CareCircleSpacingTokens.md,
            vertical: CareCircleSpacingTokens.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
          borderSide: BorderSide(
            color: CareCircleColorTokens.lightColorScheme.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
          borderSide: BorderSide(
            color: CareCircleColorTokens.primaryMedicalBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
          borderSide: BorderSide(
            color: CareCircleColorTokens.criticalAlert,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: CareCircleSpacingTokens.md,
          vertical: CareCircleSpacingTokens.md,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 6,
        highlightElevation: 12,
        sizeConstraints: BoxConstraints.tightFor(
          width: CareCircleSpacingTokens.emergencyButtonMin,
          height: CareCircleSpacingTokens.emergencyButtonMin,
        ),
      ),
    );
  }
}
