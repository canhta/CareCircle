import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../application/providers/health_sync_provider.dart';
import '../../infrastructure/services/device_health_service.dart';

/// Widget providing troubleshooting tools and diagnostics for health data sync
/// 
/// Offers step-by-step troubleshooting guides, diagnostic tools, and
/// common issue resolution with healthcare-compliant logging and privacy protection.
class SyncTroubleshootingWidget extends ConsumerStatefulWidget {
  const SyncTroubleshootingWidget({super.key});

  @override
  ConsumerState<SyncTroubleshootingWidget> createState() => _SyncTroubleshootingWidgetState();
}

class _SyncTroubleshootingWidgetState extends ConsumerState<SyncTroubleshootingWidget> {
  static final _logger = BoundedContextLoggers.healthData;
  final _deviceHealthService = DeviceHealthService();
  bool _isRunningDiagnostics = false;

  @override
  Widget build(BuildContext context) {
    final syncStatus = ref.watch(healthSyncStatusProvider);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildQuickDiagnostics(),
            const SizedBox(height: 16),
            _buildCommonIssues(),
            const SizedBox(height: 16),
            _buildTroubleshootingActions(syncStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.build,
          color: CareCircleDesignTokens.primaryMedicalBlue,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Troubleshooting & Diagnostics',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickDiagnostics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Diagnostics',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              _buildDiagnosticItem(
                'Service Status',
                _deviceHealthService.isReady ? 'Ready' : 'Not Ready',
                _deviceHealthService.isReady,
              ),
              const Divider(height: 16),
              _buildDiagnosticItem(
                'Platform',
                _deviceHealthService.platformName,
                _deviceHealthService.platformName != 'Unknown',
              ),
              const Divider(height: 16),
              _buildDiagnosticItem(
                'Supported Metrics',
                '${_deviceHealthService.supportedMetricTypes.length} types',
                _deviceHealthService.supportedMetricTypes.isNotEmpty,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiagnosticItem(String label, String value, bool isHealthy) {
    return Row(
      children: [
        Icon(
          isHealthy ? Icons.check_circle : Icons.error,
          color: isHealthy ? CareCircleDesignTokens.healthGreen : Colors.red[600],
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: isHealthy ? CareCircleDesignTokens.healthGreen : Colors.red[600],
          ),
        ),
      ],
    );
  }

  Widget _buildCommonIssues() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Common Issues & Solutions',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _buildIssueItem(
          'Sync Not Working',
          'Check permissions and try reconnecting',
          Icons.sync_problem,
          () => _showSyncTroubleshooting(),
        ),
        _buildIssueItem(
          'Missing Data',
          'Verify device compatibility and data sources',
          Icons.data_usage,
          () => _showDataTroubleshooting(),
        ),
        _buildIssueItem(
          'Permission Denied',
          'Grant health permissions in device settings',
          Icons.lock,
          () => _showPermissionTroubleshooting(),
        ),
        _buildIssueItem(
          'Connection Issues',
          'Check network and restart the app',
          Icons.wifi_off,
          () => _showConnectionTroubleshooting(),
        ),
      ],
    );
  }

  Widget _buildIssueItem(String title, String description, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.orange[600],
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTroubleshootingActions(HealthSyncStatus syncStatus) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isRunningDiagnostics ? null : () => _runFullDiagnostics(),
                icon: _isRunningDiagnostics
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.medical_services, size: 18),
                label: Text(_isRunningDiagnostics ? 'Running...' : 'Run Diagnostics'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showDetailedHelp(),
                icon: const Icon(Icons.help_outline, size: 18),
                label: const Text('Get Help'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () => _resetHealthService(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Reset Health Service'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange[700],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _runFullDiagnostics() async {
    _logger.info('Running full health sync diagnostics');
    
    setState(() {
      _isRunningDiagnostics = true;
    });

    try {
      final diagnostics = <String, dynamic>{};
      
      // Check service status
      diagnostics['serviceReady'] = _deviceHealthService.isReady;
      diagnostics['platform'] = _deviceHealthService.platformName;
      diagnostics['supportedMetrics'] = _deviceHealthService.supportedMetricTypes.length;
      
      // Check permissions
      try {
        diagnostics['hasPermissions'] = await _deviceHealthService.hasPermissions();
      } catch (e) {
        diagnostics['permissionsError'] = e.toString();
      }
      
      // Check platform-specific availability
      if (_deviceHealthService.platformName == 'Health Connect') {
        try {
          diagnostics['healthConnectAvailable'] = await _deviceHealthService.isHealthConnectAvailable();
        } catch (e) {
          diagnostics['healthConnectError'] = e.toString();
        }
      }
      
      _logger.info('Diagnostics completed: $diagnostics');
      
      if (mounted) {
        _showDiagnosticsResults(diagnostics);
      }
    } catch (e) {
      _logger.error('Diagnostics failed: $e', e);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Diagnostics failed: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRunningDiagnostics = false;
        });
      }
    }
  }

  void _showDiagnosticsResults(Map<String, dynamic> diagnostics) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Diagnostics Results'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: diagnostics.entries.map((entry) {
              final isError = entry.key.contains('Error');
              final isHealthy = entry.value == true || 
                  (entry.value is String && entry.value != 'Unknown') ||
                  (entry.value is int && entry.value > 0);
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      isError ? Icons.error : (isHealthy ? Icons.check_circle : Icons.warning),
                      color: isError 
                          ? Colors.red[600] 
                          : (isHealthy ? CareCircleDesignTokens.healthGreen : Colors.orange[600]),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
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

  void _showSyncTroubleshooting() {
    _showTroubleshootingDialog(
      'Sync Troubleshooting',
      [
        '1. Check that health permissions are granted',
        '2. Ensure your device supports health data',
        '3. Try manually triggering a sync',
        '4. Check your internet connection',
        '5. Restart the CareCircle app',
        '6. If issues persist, contact support',
      ],
    );
  }

  void _showDataTroubleshooting() {
    _showTroubleshootingDialog(
      'Missing Data Troubleshooting',
      [
        '1. Verify your health device is connected',
        '2. Check that data is available in your health app',
        '3. Ensure the metric type is supported',
        '4. Try syncing a longer time period',
        '5. Check if manual entries are included',
        '6. Restart your health tracking device',
      ],
    );
  }

  void _showPermissionTroubleshooting() {
    _showTroubleshootingDialog(
      'Permission Troubleshooting',
      [
        '1. Go to device Settings > Privacy & Security',
        '2. Find Health or Health Connect settings',
        '3. Locate CareCircle in the app list',
        '4. Enable all required health permissions',
        '5. Return to CareCircle and try again',
        '6. Restart the app if permissions don\'t take effect',
      ],
    );
  }

  void _showConnectionTroubleshooting() {
    _showTroubleshootingDialog(
      'Connection Troubleshooting',
      [
        '1. Check your internet connection',
        '2. Ensure CareCircle has network permissions',
        '3. Try switching between WiFi and mobile data',
        '4. Restart the CareCircle app',
        '5. Check if the CareCircle service is available',
        '6. Contact support if issues persist',
      ],
    );
  }

  void _showTroubleshootingDialog(String title, List<String> steps) {
    _logger.info('Showing troubleshooting dialog: $title');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: steps.map((step) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(step, style: const TextStyle(fontSize: 14)),
            )).toList(),
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

  void _showDetailedHelp() {
    _logger.info('Showing detailed help dialog');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health Sync Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Getting Started',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. Grant health permissions when prompted'),
              Text('2. Ensure your health devices are connected'),
              Text('3. Trigger an initial sync to import data'),
              Text('4. Set up automatic sync preferences'),
              SizedBox(height: 16),
              Text(
                'Supported Platforms',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• iOS: Apple HealthKit integration'),
              Text('• Android: Google Health Connect integration'),
              Text('• Supports most major health devices and apps'),
              SizedBox(height: 16),
              Text(
                'Privacy & Security',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• All data is encrypted and HIPAA-compliant'),
              Text('• Data is processed securely on your device'),
              Text('• You control what data is shared'),
              Text('• Sync can be disabled at any time'),
              SizedBox(height: 16),
              Text(
                'Need More Help?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Contact our support team through the app settings or visit our help center online.'),
            ],
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

  Future<void> _resetHealthService() async {
    _logger.info('Resetting health service');
    
    try {
      // Re-initialize the device service
      final initialized = await _deviceHealthService.initialize();
      
      // Refresh all related providers
      ref.invalidate(healthSyncStatusProvider);
      ref.invalidate(healthSyncPermissionsProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(initialized 
                ? 'Health service reset successfully'
                : 'Failed to reset health service'),
            backgroundColor: initialized 
                ? CareCircleDesignTokens.healthGreen
                : Colors.orange,
          ),
        );
      }
    } catch (e) {
      _logger.error('Failed to reset health service: $e', e);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reset failed: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }
}
