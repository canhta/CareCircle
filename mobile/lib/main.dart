import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/app_config.dart';
import 'screens/home_screen.dart';
import 'services/background_sync_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Validate configuration
  if (!AppConfig.validateConfig()) {
    debugPrint('Configuration validation failed. Please check your .env file.');
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
      ),
      home: const HomeScreen(),
    );
  }
}
