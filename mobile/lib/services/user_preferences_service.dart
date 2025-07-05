import '../common/common.dart';
import '../models/user_preferences_model.dart';

/// Service for managing user preferences and app settings
class UserPreferencesService {
  late final SecureStorageService _secureStorage;
  late final AppLogger _logger;
  
  UserPreferences? _cachedPreferences;
  
  UserPreferencesService({
    required SecureStorageService secureStorage,
    required AppLogger logger,
  }) {
    _secureStorage = secureStorage;
    _logger = logger;
  }

  /// Load user preferences from storage
  Future<UserPreferences> loadPreferences() async {
    try {
      _logger.info('Loading user preferences');
      
      final preferencesData = await _secureStorage.getUserPreferences();
      
      if (preferencesData != null) {
        _cachedPreferences = UserPreferences.fromJson(preferencesData);
        _logger.info('User preferences loaded successfully');
      } else {
        // Return default preferences if none exist
        _cachedPreferences = const UserPreferences();
        _logger.info('No existing preferences found, using defaults');
      }
      
      return _cachedPreferences!;
    } catch (e) {
      _logger.error('Failed to load user preferences', error: e);
      // Return default preferences on error
      _cachedPreferences = const UserPreferences();
      return _cachedPreferences!;
    }
  }

  /// Save user preferences to storage
  Future<void> savePreferences(UserPreferences preferences) async {
    try {
      _logger.info('Saving user preferences');
      
      await _secureStorage.saveUserPreferences(preferences.toJson());
      _cachedPreferences = preferences;
      
      _logger.info('User preferences saved successfully');
    } catch (e) {
      _logger.error('Failed to save user preferences', error: e);
      rethrow;
    }
  }

  /// Get current preferences (from cache or load if not cached)
  Future<UserPreferences> getCurrentPreferences() async {
    if (_cachedPreferences != null) {
      return _cachedPreferences!;
    }
    return await loadPreferences();
  }

  /// Update a specific preference
  Future<void> updatePreference<T>(String key, T value) async {
    try {
      final currentPreferences = await getCurrentPreferences();
      UserPreferences updatedPreferences;

      switch (key) {
        case 'notificationsEnabled':
          updatedPreferences = currentPreferences.copyWith(
            notificationsEnabled: value as bool,
          );
          break;
        case 'biometricEnabled':
          updatedPreferences = currentPreferences.copyWith(
            biometricEnabled: value as bool,
          );
          break;
        case 'darkModeEnabled':
          updatedPreferences = currentPreferences.copyWith(
            darkModeEnabled: value as bool,
          );
          break;
        case 'language':
          updatedPreferences = currentPreferences.copyWith(
            language: value as String,
          );
          break;
        case 'themeMode':
          updatedPreferences = currentPreferences.copyWith(
            themeMode: value as String,
          );
          break;
        case 'autoSyncEnabled':
          updatedPreferences = currentPreferences.copyWith(
            autoSyncEnabled: value as bool,
          );
          break;
        case 'offlineModeEnabled':
          updatedPreferences = currentPreferences.copyWith(
            offlineModeEnabled: value as bool,
          );
          break;
        default:
          // Handle custom settings
          final customSettings = Map<String, dynamic>.from(
            currentPreferences.customSettings,
          );
          customSettings[key] = value;
          updatedPreferences = currentPreferences.copyWith(
            customSettings: customSettings,
          );
      }

      await savePreferences(updatedPreferences);
      _logger.info('Preference updated: $key = $value');
    } catch (e) {
      _logger.error('Failed to update preference: $key', error: e);
      rethrow;
    }
  }

  /// Update multiple preferences at once
  Future<void> updateMultiplePreferences(Map<String, dynamic> updates) async {
    try {
      final currentPreferences = await getCurrentPreferences();
      
      UserPreferences updatedPreferences = currentPreferences;
      
      for (final entry in updates.entries) {
        switch (entry.key) {
          case 'notificationsEnabled':
            updatedPreferences = updatedPreferences.copyWith(
              notificationsEnabled: entry.value as bool,
            );
            break;
          case 'biometricEnabled':
            updatedPreferences = updatedPreferences.copyWith(
              biometricEnabled: entry.value as bool,
            );
            break;
          case 'darkModeEnabled':
            updatedPreferences = updatedPreferences.copyWith(
              darkModeEnabled: entry.value as bool,
            );
            break;
          case 'language':
            updatedPreferences = updatedPreferences.copyWith(
              language: entry.value as String,
            );
            break;
          case 'themeMode':
            updatedPreferences = updatedPreferences.copyWith(
              themeMode: entry.value as String,
            );
            break;
          case 'autoSyncEnabled':
            updatedPreferences = updatedPreferences.copyWith(
              autoSyncEnabled: entry.value as bool,
            );
            break;
          case 'offlineModeEnabled':
            updatedPreferences = updatedPreferences.copyWith(
              offlineModeEnabled: entry.value as bool,
            );
            break;
          default:
            // Handle custom settings
            final customSettings = Map<String, dynamic>.from(
              updatedPreferences.customSettings,
            );
            customSettings[entry.key] = entry.value;
            updatedPreferences = updatedPreferences.copyWith(
              customSettings: customSettings,
            );
        }
      }

      await savePreferences(updatedPreferences);
      _logger.info('Multiple preferences updated: ${updates.keys.join(', ')}');
    } catch (e) {
      _logger.error('Failed to update multiple preferences', error: e);
      rethrow;
    }
  }

  /// Reset preferences to defaults
  Future<void> resetToDefaults() async {
    try {
      _logger.info('Resetting preferences to defaults');
      
      const defaultPreferences = UserPreferences();
      await savePreferences(defaultPreferences);
      
      _logger.info('Preferences reset to defaults successfully');
    } catch (e) {
      _logger.error('Failed to reset preferences to defaults', error: e);
      rethrow;
    }
  }

  /// Clear all preferences
  Future<void> clearPreferences() async {
    try {
      _logger.info('Clearing all preferences');
      
      await _secureStorage.clearUserData();
      _cachedPreferences = null;
      
      _logger.info('All preferences cleared successfully');
    } catch (e) {
      _logger.error('Failed to clear preferences', error: e);
      rethrow;
    }
  }

  /// Get a specific preference value
  Future<T?> getPreference<T>(String key) async {
    try {
      final preferences = await getCurrentPreferences();
      
      switch (key) {
        case 'notificationsEnabled':
          return preferences.notificationsEnabled as T;
        case 'biometricEnabled':
          return preferences.biometricEnabled as T;
        case 'darkModeEnabled':
          return preferences.darkModeEnabled as T;
        case 'language':
          return preferences.language as T;
        case 'themeMode':
          return preferences.themeMode as T;
        case 'autoSyncEnabled':
          return preferences.autoSyncEnabled as T;
        case 'offlineModeEnabled':
          return preferences.offlineModeEnabled as T;
        default:
          return preferences.customSettings[key] as T?;
      }
    } catch (e) {
      _logger.error('Failed to get preference: $key', error: e);
      return null;
    }
  }
}
