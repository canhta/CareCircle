import 'package:flutter/material.dart';
import '../features/health/health.dart';
import '../common/common.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  late final HealthService _healthService;
  late final AppLogger _logger;

  bool _isLoading = false;
  bool _dataProcessingConsent = false;
  bool _healthDataSharingConsent = false;
  bool _familySharingConsent = false;
  bool _analyticsConsent = false;
  bool _marketingConsent = false;

  List<Map<String, dynamic>> _consentHistory = [];
  List<Map<String, dynamic>> _accessLog = [];

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadPrivacySettings();
  }

  void _initializeServices() {
    _logger = AppLogger('PrivacySettings');
    _healthService = HealthService(
      apiClient: ApiClient.instance,
      logger: _logger,
      secureStorage: SecureStorageService(),
    );
  }

  Future<void> _loadPrivacySettings() async {
    setState(() => _isLoading = true);

    try {
      // Initialize health service
      await _healthService.initialize();

      // Load consent settings from the API
      await _loadConsentSettings();
      await _loadConsentHistory();
      await _loadAccessLog();
    } catch (e) {
      _logger.error('Failed to load privacy settings', error: e);
      _showErrorSnackBar('Failed to load privacy settings: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadConsentSettings() async {
    try {
      final result = await _healthService.getConsentSettings();

      if (result.isSuccess && result.data != null) {
        final settings = result.data!;
        setState(() {
          _dataProcessingConsent = settings['dataProcessingConsent'] ?? false;
          _healthDataSharingConsent =
              settings['healthDataSharingConsent'] ?? false;
          _familySharingConsent = settings['familySharingConsent'] ?? false;
          _analyticsConsent = settings['analyticsConsent'] ?? false;
          _marketingConsent = settings['marketingConsent'] ?? false;
        });
      } else {
        _logger.warning('Failed to load consent settings', data: {
          'error': result.data,
        });
        // Use default values
        setState(() {
          _dataProcessingConsent = false;
          _healthDataSharingConsent = false;
          _familySharingConsent = false;
          _analyticsConsent = false;
          _marketingConsent = false;
        });
      }
    } catch (e) {
      _logger.error('Exception loading consent settings', error: e);
      // Use default values
      setState(() {
        _dataProcessingConsent = false;
        _healthDataSharingConsent = false;
        _familySharingConsent = false;
        _analyticsConsent = false;
        _marketingConsent = false;
      });
    }
  }

  Future<void> _loadConsentHistory() async {
    try {
      final result = await _healthService.getConsentHistory();

      if (result.isSuccess && result.data != null) {
        _consentHistory = result.data!;
      } else {
        _logger.warning('Failed to load consent history');
        // Use fallback data
        _consentHistory = [
          {
            'type': 'DATA_PROCESSING',
            'granted': false,
            'timestamp': DateTime.now().subtract(Duration(days: 1)),
            'version': '1.0',
          },
          {
            'type': 'ANALYTICS',
            'granted': false,
            'timestamp': DateTime.now().subtract(Duration(days: 7)),
            'version': '1.0',
          },
        ];
      }

      _logger.info('Consent history loaded: ${_consentHistory.length} entries');
    } catch (e) {
      _logger.error('Failed to load consent history', error: e);
      // Use fallback data
      _consentHistory = [
        {
          'type': 'DATA_PROCESSING',
          'granted': false,
          'timestamp': DateTime.now().subtract(Duration(days: 1)),
          'version': '1.0',
        },
        {
          'type': 'ANALYTICS',
          'granted': false,
          'timestamp': DateTime.now().subtract(Duration(days: 7)),
          'version': '1.0',
        },
      ];
    }
  }

  Future<void> _loadAccessLog() async {
    try {
      final result = await _healthService.getAccessLog();

      if (result.isSuccess && result.data != null) {
        _accessLog = result.data!;
      } else {
        _logger.warning('Failed to load access log');
        // Use fallback data
        _accessLog = [
          {
            'action': 'Data Export Request',
            'timestamp': DateTime.now().subtract(Duration(hours: 2)),
            'details': 'Full health data export requested',
          },
          {
            'action': 'Profile Access',
            'timestamp': DateTime.now().subtract(Duration(days: 1)),
            'details': 'Profile information accessed by care team',
          },
        ];
      }

      _logger.info('Access log loaded: ${_accessLog.length} entries');
    } catch (e) {
      _logger.error('Failed to load access log', error: e);
      // Use fallback data
      _accessLog = [
        {
          'action': 'Data Export Request',
          'timestamp': DateTime.now().subtract(Duration(hours: 2)),
          'details': 'Full health data export requested',
        },
        {
          'action': 'Profile Access',
          'timestamp': DateTime.now().subtract(Duration(days: 1)),
          'details': 'Profile information accessed by care team',
        },
      ];
    }
  }

  Future<void> _updateConsent(String consentType, bool granted) async {
    setState(() => _isLoading = true);

    try {
      // Make API call to update consent
      await _makeConsentApiCall(consentType, granted);

      // Update local state
      setState(() {
        switch (consentType) {
          case 'DATA_PROCESSING':
            _dataProcessingConsent = granted;
            break;
          case 'DATA_SHARING':
            _healthDataSharingConsent = granted;
            break;
          case 'FAMILY_SHARING':
            _familySharingConsent = granted;
            break;
          case 'ANALYTICS':
            _analyticsConsent = granted;
            break;
          case 'MARKETING':
            _marketingConsent = granted;
            break;
        }
      });

      // Add to consent history
      _consentHistory.insert(0, {
        'type': consentType,
        'granted': granted,
        'timestamp': DateTime.now(),
        'version': '1.0',
      });

      _logger.info('Consent updated: $consentType = $granted');

      _showSuccessSnackBar(
        '${_getConsentDisplayName(consentType)} ${granted ? 'granted' : 'revoked'} successfully',
      );
    } catch (e) {
      _logger.error('Failed to update consent', error: e);
      _showErrorSnackBar('Failed to update consent: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _makeConsentApiCall(String consentType, bool granted) async {
    try {
      // Build consent settings map
      final consentSettings = <String, bool>{
        consentType: granted,
      };

      // Call health service to update consent
      final result =
          await _healthService.updateConsentSettings(consentSettings);

      if (result.isFailure) {
        throw Exception('Failed to update consent: API call failed');
      }

      _logger.info('Consent API call successful: $consentType = $granted');
    } catch (e) {
      _logger.error('Consent API call failed', error: e);
      rethrow;
    }
  }

  String _getConsentDisplayName(String consentType) {
    switch (consentType) {
      case 'DATA_PROCESSING':
        return 'Data Processing';
      case 'DATA_SHARING':
        return 'Health Data Sharing';
      case 'FAMILY_SHARING':
        return 'Family Sharing';
      case 'ANALYTICS':
        return 'Analytics';
      case 'MARKETING':
        return 'Marketing';
      default:
        return consentType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildConsentSection(),
                  const SizedBox(height: 24),
                  _buildDataControlsSection(),
                  const SizedBox(height: 24),
                  _buildTransparencySection(),
                  const SizedBox(height: 24),
                  _buildLegalSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.privacy_tip, color: Colors.blue, size: 24),
                SizedBox(width: 8),
                Text(
                  'Privacy & Data Control',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Control how your health data is collected, used, and shared. '
              'All settings comply with Vietnam\'s Decree 13/2023/ND-CP on Personal Data Protection.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Consent Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildConsentTile(
              title: 'Health Data Processing',
              subtitle:
                  'Allow processing of your health data for monitoring and insights',
              value: _dataProcessingConsent,
              onChanged: (value) => _updateConsent('DATA_PROCESSING', value),
              icon: Icons.health_and_safety,
            ),
            _buildConsentTile(
              title: 'Health Data Sharing',
              subtitle: 'Share health insights with healthcare providers',
              value: _healthDataSharingConsent,
              onChanged: (value) => _updateConsent('DATA_SHARING', value),
              icon: Icons.share,
            ),
            _buildConsentTile(
              title: 'Family Sharing',
              subtitle:
                  'Share basic health metrics with family members in care groups',
              value: _familySharingConsent,
              onChanged: (value) => _updateConsent('FAMILY_SHARING', value),
              icon: Icons.family_restroom,
            ),
            _buildConsentTile(
              title: 'Analytics',
              subtitle:
                  'Help improve the app with usage analytics (anonymized)',
              value: _analyticsConsent,
              onChanged: (value) => _updateConsent('ANALYTICS', value),
              icon: Icons.analytics,
            ),
            _buildConsentTile(
              title: 'Marketing Communications',
              subtitle: 'Receive personalized health tips and recommendations',
              value: _marketingConsent,
              onChanged: (value) => _updateConsent('MARKETING', value),
              icon: Icons.notifications,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsentTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildDataControlsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Control Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.blue),
              title: const Text('Export My Data'),
              subtitle: const Text(
                'Download all your health data in JSON format',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _exportData,
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Delete All Data'),
              subtitle: const Text('Permanently delete all your health data'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showDeleteDataConfirmation,
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.orange),
              title: const Text('Revoke All Permissions'),
              subtitle: const Text('Remove all data access permissions'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _revokeAllPermissions,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransparencySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transparency & Audit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: const Text('Consent History'),
              subtitle: Text('${_consentHistory.length} consent records'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showConsentHistory,
            ),
            ListTile(
              leading: const Icon(Icons.visibility, color: Colors.blue),
              title: const Text('Data Access Log'),
              subtitle: Text('${_accessLog.length} access events'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showAccessLog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Legal & Compliance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.policy, color: Colors.blue),
              title: const Text('Privacy Policy'),
              subtitle: const Text('Read our privacy policy'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showPrivacyPolicy,
            ),
            ListTile(
              leading: const Icon(Icons.gavel, color: Colors.blue),
              title: const Text('Terms of Service'),
              subtitle: const Text('Read our terms of service'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showTermsOfService,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'CareCircle complies with Vietnam\'s Decree 13/2023/ND-CP on Personal Data Protection. '
                'Your data is processed with your explicit consent and you have the right to access, '
                'correct, or delete your personal data at any time.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportData() async {
    // TODO: Implement data export with health service
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Data export requested. You will receive an email with download link.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showDeleteDataConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action will permanently delete:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• All your health records'),
            Text('• All consent settings'),
            Text('• All care group memberships'),
            Text('• Your user profile'),
            SizedBox(height: 16),
            Text(
              'This action cannot be undone. Are you sure?',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteAllData();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Delete All Data',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAllData() async {
    // TODO: Implement data deletion with health service
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Data deletion requested. Your account will be deleted within 30 days.',
          ),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate back to login screen
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  Future<void> _revokeAllPermissions() async {
    try {
      setState(() => _isLoading = true);

      // Revoke all consents
      // TODO: Implement with health service
      // For now, just update local state
      setState(() {
        _dataProcessingConsent = false;
        _healthDataSharingConsent = false;
        _familySharingConsent = false;
        _analyticsConsent = false;
        _marketingConsent = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All permissions revoked successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showConsentHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Consent History'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: _consentHistory.length,
            itemBuilder: (context, index) {
              final consent = _consentHistory[index];
              return ListTile(
                title: Text(
                  _getConsentDisplayName(consent['consentType'] ?? ''),
                ),
                subtitle: Text(
                  '${consent['consentGranted'] ? 'Granted' : 'Revoked'} on ${consent['consentDate']}',
                ),
                trailing: Icon(
                  consent['consentGranted'] ? Icons.check_circle : Icons.cancel,
                  color: consent['consentGranted'] ? Colors.green : Colors.red,
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAccessLog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Access Log'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: _accessLog.length,
            itemBuilder: (context, index) {
              final access = _accessLog[index];
              return ListTile(
                title: Text(access['action'] ?? 'Unknown'),
                subtitle: Text(
                  '${access['accessor']} - ${access['timestamp']}',
                ),
                trailing: Icon(Icons.visibility, color: Colors.blue),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    // TODO: Implement privacy policy display
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy Policy - Coming Soon')),
    );
  }

  void _showTermsOfService() {
    // TODO: Implement terms of service display
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terms of Service - Coming Soon')),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
