/// User preferences model for app settings
class UserPreferences {
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final bool darkModeEnabled;
  final String language;
  final String themeMode; // 'light', 'dark', 'system'
  final bool autoSyncEnabled;
  final bool offlineModeEnabled;
  final Map<String, dynamic> customSettings;

  const UserPreferences({
    this.notificationsEnabled = true,
    this.biometricEnabled = false,
    this.darkModeEnabled = false,
    this.language = 'English',
    this.themeMode = 'system',
    this.autoSyncEnabled = true,
    this.offlineModeEnabled = false,
    this.customSettings = const {},
  });

  /// Create UserPreferences from JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      darkModeEnabled: json['darkModeEnabled'] as bool? ?? false,
      language: json['language'] as String? ?? 'English',
      themeMode: json['themeMode'] as String? ?? 'system',
      autoSyncEnabled: json['autoSyncEnabled'] as bool? ?? true,
      offlineModeEnabled: json['offlineModeEnabled'] as bool? ?? false,
      customSettings: json['customSettings'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Convert UserPreferences to JSON
  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'biometricEnabled': biometricEnabled,
      'darkModeEnabled': darkModeEnabled,
      'language': language,
      'themeMode': themeMode,
      'autoSyncEnabled': autoSyncEnabled,
      'offlineModeEnabled': offlineModeEnabled,
      'customSettings': customSettings,
    };
  }

  /// Create a copy with updated values
  UserPreferences copyWith({
    bool? notificationsEnabled,
    bool? biometricEnabled,
    bool? darkModeEnabled,
    String? language,
    String? themeMode,
    bool? autoSyncEnabled,
    bool? offlineModeEnabled,
    Map<String, dynamic>? customSettings,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      autoSyncEnabled: autoSyncEnabled ?? this.autoSyncEnabled,
      offlineModeEnabled: offlineModeEnabled ?? this.offlineModeEnabled,
      customSettings: customSettings ?? this.customSettings,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreferences &&
        other.notificationsEnabled == notificationsEnabled &&
        other.biometricEnabled == biometricEnabled &&
        other.darkModeEnabled == darkModeEnabled &&
        other.language == language &&
        other.themeMode == themeMode &&
        other.autoSyncEnabled == autoSyncEnabled &&
        other.offlineModeEnabled == offlineModeEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      notificationsEnabled,
      biometricEnabled,
      darkModeEnabled,
      language,
      themeMode,
      autoSyncEnabled,
      offlineModeEnabled,
    );
  }

  @override
  String toString() {
    return 'UserPreferences('
        'notificationsEnabled: $notificationsEnabled, '
        'biometricEnabled: $biometricEnabled, '
        'darkModeEnabled: $darkModeEnabled, '
        'language: $language, '
        'themeMode: $themeMode, '
        'autoSyncEnabled: $autoSyncEnabled, '
        'offlineModeEnabled: $offlineModeEnabled'
        ')';
  }
}

/// Available languages for the app
class AppLanguages {
  static const Map<String, String> languages = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Italian': 'it',
    'Portuguese': 'pt',
    'Chinese': 'zh',
    'Japanese': 'ja',
    'Korean': 'ko',
    'Arabic': 'ar',
  };

  static String getLanguageCode(String languageName) {
    return languages[languageName] ?? 'en';
  }

  static String getLanguageName(String languageCode) {
    return languages.entries
        .firstWhere(
          (entry) => entry.value == languageCode,
          orElse: () => const MapEntry('English', 'en'),
        )
        .key;
  }

  static List<String> get availableLanguages => languages.keys.toList();
}

/// Theme mode options
class AppThemeModes {
  static const String light = 'light';
  static const String dark = 'dark';
  static const String system = 'system';

  static const List<String> modes = [light, dark, system];

  static String getDisplayName(String mode) {
    switch (mode) {
      case light:
        return 'Light';
      case dark:
        return 'Dark';
      case system:
        return 'System';
      default:
        return 'System';
    }
  }
}
