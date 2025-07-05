import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../common/common.dart';
import '../config/app_config.dart';

/// Application-level initializer
/// Handles high-level app initialization that depends on other services
class AppInitializer {
  late final AppLogger _logger;
  bool _isInitialized = false;

  AppInitializer() {
    _logger = AppLogger('AppInitializer');
  }

  bool get isInitialized => _isInitialized;

  /// Initialize application
  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.info('AppInitializer already initialized');
      return;
    }

    try {
      _logger.info('Initializing application...');

      // Load environment variables
      await _loadEnvironmentVariables();

      // Initialize app configuration
      await _initializeAppConfig();

      // Validate configuration
      _validateConfiguration();

      _isInitialized = true;
      _logger.info('Application initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize application', error: e);
      rethrow;
    }
  }

  /// Load environment variables
  Future<void> _loadEnvironmentVariables() async {
    try {
      await dotenv.load(fileName: ".env");
      _logger.info('Environment variables loaded successfully');
    } catch (e) {
      _logger.warning('Failed to load environment variables: $e');
      // Continue without .env file - use defaults
    }
  }

  /// Initialize app configuration
  Future<void> _initializeAppConfig() async {
    try {
      await AppConfig.initialize();
      _logger.info('App configuration initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize app configuration', error: e);
      rethrow;
    }
  }

  /// Validate configuration
  void _validateConfiguration() {
    if (!AppConfig.validateConfig()) {
      _logger.warning(
          'Configuration validation failed. Please check your .env file.');
    } else {
      _logger.info('Configuration validation passed');
    }

    // Print configuration in debug mode
    AppConfig.printConfig();
  }
}
