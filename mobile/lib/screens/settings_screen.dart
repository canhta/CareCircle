import 'package:flutter/material.dart';
import '../features/auth/auth.dart';
import '../common/common.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final AuthService _authService;
  late final AppLogger _logger;

  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = false;
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    _logger = AppLogger('SettingsScreen');
    _authService = AuthService(
      apiClient: ApiClient.instance,
      secureStorage: SecureStorageService(),
      logger: _logger,
    );
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Load settings from local storage or user preferences
    // This is a placeholder implementation
    setState(() {
      _notificationsEnabled = true;
      _biometricEnabled = false;
      _darkModeEnabled = false;
      _language = 'English';
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            'Notifications',
            [
              _buildSwitchTile(
                'Enable Notifications',
                'Receive push notifications',
                _notificationsEnabled,
                (value) => setState(() => _notificationsEnabled = value),
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
                _biometricEnabled,
                (value) => setState(() => _biometricEnabled = value),
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
                _darkModeEnabled,
                (value) => setState(() => _darkModeEnabled = value),
              ),
              _buildListTile(
                'Language',
                _language,
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
                () => _showComingSoon(),
              ),
              _buildListTile(
                'Contact Support',
                'Get in touch with our team',
                Icons.contact_support_outlined,
                () => _showComingSoon(),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Spanish'),
              value: 'Spanish',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('French'),
              value: 'French',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
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

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon!'),
      ),
    );
  }
}
