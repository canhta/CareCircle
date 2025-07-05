import 'package:flutter/material.dart';
import '../features/auth/auth.dart';
import '../common/common.dart';
import '../models/user_preferences_model.dart';
import '../services/user_preferences_service.dart';
import '../widgets/widget_optimizer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final AuthService _authService;
  late final UserPreferencesService _preferencesService;
  late final AppLogger _logger;

  UserPreferences? _preferences;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _logger = AppLogger('SettingsScreen');
    final secureStorage = SecureStorageService();
    _authService = AuthService(
      apiClient: ApiClient.instance,
      secureStorage: secureStorage,
      logger: _logger,
    );
    _preferencesService = UserPreferencesService(
      secureStorage: secureStorage,
      logger: _logger,
    );
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      _logger.info('Loading user settings');
      final preferences = await _preferencesService.loadPreferences();

      if (mounted) {
        setState(() {
          _preferences = preferences;
          _isLoading = false;
        });
      }

      _logger.info('Settings loaded successfully');
    } catch (e) {
      _logger.error('Failed to load settings', error: e);

      if (mounted) {
        setState(() {
          _preferences = const UserPreferences(); // Use defaults
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await _authService.logout();

      result.fold(
        (success) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        },
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error logging out: ${error.toString()}'),
            ),
          );
        },
      );
    }
  }

  /// Update a specific preference
  Future<void> _updatePreference<T>(String key, T value) async {
    try {
      await _preferencesService.updatePreference(key, value);

      // Reload preferences to update UI
      final updatedPreferences =
          await _preferencesService.getCurrentPreferences();

      if (mounted) {
        setState(() {
          _preferences = updatedPreferences;
        });

        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Setting updated successfully'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      _logger.info('Preference updated: $key = $value');
    } catch (e) {
      _logger.error('Failed to update preference: $key', error: e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update setting: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_preferences == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: const Center(
          child: Text('Failed to load settings'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: WidgetOptimizer.optimizeListView(
        addRepaintBoundaries: true,
        children: [
          _buildSection(
            'Notifications',
            [
              _buildSwitchTile(
                'Enable Notifications',
                'Receive push notifications',
                _preferences!.notificationsEnabled,
                (value) => _updatePreference('notificationsEnabled', value),
              ),
              _buildListTile(
                'Notification Preferences',
                'Customize notification settings',
                Icons.notifications_outlined,
                () => Navigator.pushNamed(context, '/notification-preferences'),
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            'Security',
            [
              _buildSwitchTile(
                'Biometric Authentication',
                'Use fingerprint or face ID',
                _preferences!.biometricEnabled,
                (value) => _updatePreference('biometricEnabled', value),
              ),
              _buildListTile(
                'Privacy Settings',
                'Manage your privacy preferences',
                Icons.privacy_tip_outlined,
                () => Navigator.pushNamed(context, '/privacy-settings'),
              ),
              _buildListTile(
                'Change Password',
                'Update your account password',
                Icons.lock_outline,
                () => Navigator.pushNamed(context, '/forgot-password'),
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            'Appearance',
            [
              _buildSwitchTile(
                'Dark Mode',
                'Use dark theme',
                _preferences!.darkModeEnabled,
                (value) => _updatePreference('darkModeEnabled', value),
              ),
              _buildListTile(
                'Language',
                _preferences!.language,
                Icons.language_outlined,
                _showLanguageDialog,
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            'Account',
            [
              _buildListTile(
                'Profile',
                'Edit your profile information',
                Icons.person_outline,
                () => Navigator.pushNamed(context, '/profile'),
              ),
              _buildListTile(
                'Health Data',
                'Manage your health information',
                Icons.health_and_safety_outlined,
                () => Navigator.pushNamed(context, '/health-data'),
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            'Support',
            [
              _buildListTile(
                'Help Center',
                'Get help and support',
                Icons.help_outline,
                () => Navigator.pushNamed(context, '/help-center'),
              ),
              _buildListTile(
                'Contact Support',
                'Get in touch with our team',
                Icons.contact_support_outlined,
                () => Navigator.pushNamed(context, '/contact-support'),
              ),
              _buildListTile(
                'About',
                'App version and information',
                Icons.info_outline,
                () => _showAboutDialog(),
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            'Account Actions',
            [
              _buildListTile(
                'Logout',
                'Sign out of your account',
                Icons.logout,
                _logout,
                textColor: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  void _showLanguageDialog() {
    if (_preferences == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLanguages.availableLanguages.map((language) {
            return RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: _preferences!.language,
              onChanged: (value) {
                if (value != null) {
                  _updatePreference('language', value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'CareCircle',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 CareCircle. All rights reserved.',
      children: [
        const SizedBox(height: 16),
        const Text(
          'CareCircle helps you stay connected with your loved ones and manage your health together.',
        ),
      ],
    );
  }
}
