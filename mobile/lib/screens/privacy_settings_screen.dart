import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../features/health/health.dart';
import '../common/common.dart';
import '../utils/markdown_loader.dart';

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
        setState(() {
          _consentHistory = result.data!;
        });
      }
    } catch (e) {
      _logger.error('Failed to load consent history', error: e);
    }
  }

  Future<void> _loadAccessLog() async {
    try {
      final result = await _healthService.getAccessLog();
      if (result.isSuccess && result.data != null) {
        setState(() {
          _accessLog = result.data!;
        });
      }
    } catch (e) {
      _logger.error('Failed to load access log', error: e);
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

  Future<void> _requestDataExport() async {
    setState(() => _isLoading = true);

    try {
      final result = await _healthService.requestDataExport();

      if (result.isSuccess) {
        _showSuccessSnackBar(
          'Data export request submitted. You will receive an email with your data within 72 hours.',
        );
        _logger.info('Data export requested successfully');
      } else {
        throw Exception('API call failed');
      }
    } catch (e) {
      _logger.error('Failed to request data export', error: e);
      _showErrorSnackBar('Failed to request data export: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _requestDataDeletion() async {
    try {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Account Deletion'),
          content: const Text(
            'Are you sure you want to request account deletion? This action cannot be undone and will permanently delete all your data after a processing period.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _performDataDeletion();
              },
              child: const Text('DELETE MY ACCOUNT',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } catch (e) {
      _logger.error('Error showing deletion dialog', error: e);
    }
  }

  Future<void> _performDataDeletion() async {
    setState(() => _isLoading = true);

    try {
      final result = await _healthService.requestAccountDeletion();

      if (result.isSuccess) {
        _showSuccessSnackBar(
          'Account deletion request submitted. Your account and data will be deleted within 30 days.',
        );
        _logger.info('Account deletion requested successfully');

        // Wait a moment before navigating back to let user see the message
        await Future.delayed(const Duration(seconds: 3));
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        throw Exception('API call failed');
      }
    } catch (e) {
      _logger.error('Failed to request account deletion', error: e);
      _showErrorSnackBar('Failed to request account deletion: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showPrivacyPolicy() async {
    try {
      final policyContent = await MarkdownLoader.getPrivacyPolicy();
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: Markdown(
                      data: policyContent,
                      styleSheet: MarkdownStyleSheet(
                        h1: const TextStyle(fontSize: 24),
                        h2: const TextStyle(fontSize: 20),
                        h3: const TextStyle(fontSize: 18),
                        p: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } catch (e) {
      _logger.error('Failed to load privacy policy', error: e);
      _showErrorSnackBar('Failed to load privacy policy: $e');
    }
  }

  void _showTermsOfService() async {
    try {
      final termsContent = await MarkdownLoader.getTermsOfService();
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Terms of Service',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: Markdown(
                      data: termsContent,
                      styleSheet: MarkdownStyleSheet(
                        h1: const TextStyle(fontSize: 24),
                        h2: const TextStyle(fontSize: 20),
                        h3: const TextStyle(fontSize: 18),
                        p: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } catch (e) {
      _logger.error('Failed to load terms of service', error: e);
      _showErrorSnackBar('Failed to load terms of service: $e');
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
          child: _consentHistory.isEmpty
              ? const Center(child: Text('No consent history available'))
              : ListView.builder(
                  itemCount: _consentHistory.length,
                  itemBuilder: (context, index) {
                    final consent = _consentHistory[index];
                    final timestamp = consent['timestamp'] is DateTime
                        ? consent['timestamp']
                        : DateTime.parse(consent['timestamp'].toString());
                    return ListTile(
                      title: Text(
                        _getConsentDisplayName(consent['type'].toString()),
                      ),
                      subtitle: Text(
                        '${consent['granted'] ? 'Granted' : 'Revoked'} on ${_formatDate(timestamp)}',
                      ),
                      trailing: Icon(
                        consent['granted'] ? Icons.check_circle : Icons.cancel,
                        color: consent['granted'] ? Colors.green : Colors.red,
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

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showAccessLog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Access Log'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: _accessLog.isEmpty
              ? const Center(child: Text('No access log entries available'))
              : ListView.builder(
                  itemCount: _accessLog.length,
                  itemBuilder: (context, index) {
                    final access = _accessLog[index];
                    return ListTile(
                      title: Text(access['action'] ?? 'Unknown'),
                      subtitle: Text(
                        '${access['accessor']} - ${access['timestamp']}',
                      ),
                      trailing:
                          const Icon(Icons.visibility, color: Colors.blue),
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
              'Data Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.blue),
              title: const Text('Export Your Data'),
              subtitle: const Text('Download a copy of all your data'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _requestDataExport,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Delete Your Account'),
              subtitle: const Text(
                'Request permanent deletion of your account and all associated data',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _requestDataDeletion,
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
              'Transparency',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: const Text('Consent History'),
              subtitle: const Text('View your consent change history'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showConsentHistory,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.visibility, color: Colors.blue),
              title: const Text('Data Access Log'),
              subtitle: const Text('See who has accessed your data'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
              'Legal Documents',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.policy, color: Colors.blue),
              title: const Text('Privacy Policy'),
              subtitle: const Text('View our privacy policy'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showPrivacyPolicy,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.gavel, color: Colors.blue),
              title: const Text('Terms of Service'),
              subtitle: const Text('View our terms of service'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showTermsOfService,
            ),
          ],
        ),
      ),
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
