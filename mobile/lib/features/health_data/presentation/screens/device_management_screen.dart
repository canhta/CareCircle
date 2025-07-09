import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../application/providers/health_sync_provider.dart';
import '../../infrastructure/services/device_health_service.dart';
import '../widgets/device_connection_card.dart';
import '../widgets/device_permissions_widget.dart';
import '../widgets/sync_troubleshooting_widget.dart';

/// Screen for managing health device connections and sync settings
/// 
/// Provides interface for device pairing, connection management,
/// sync status monitoring, and troubleshooting with healthcare-compliant
/// privacy protection and logging.
class DeviceManagementScreen extends ConsumerStatefulWidget {
  const DeviceManagementScreen({super.key});

  @override
  ConsumerState<DeviceManagementScreen> createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends ConsumerState<DeviceManagementScreen> {
  static final _logger = BoundedContextLoggers.healthData;
  final _deviceHealthService = DeviceHealthService();

  @override
  void initState() {
    super.initState();
    _logger.info('Device management screen initialized');
    
    // Initialize device service if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDeviceService();
    });
  }

  Future<void> _initializeDeviceService() async {
    try {
      if (!_deviceHealthService.isReady) {
        await _deviceHealthService.initialize();
      }
    } catch (e) {
      _logger.error('Failed to initialize device service: $e', e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Management'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(),
            tooltip: 'Help & Troubleshooting',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDeviceStatus,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Platform information
              _buildPlatformInfoSection(),
              
              const SizedBox(height: 24),
              
              // Permissions status
              const DevicePermissionsWidget(),
              
              const SizedBox(height: 24),
              
              // Device connection status
              _buildDeviceConnectionSection(),
              
              const SizedBox(height: 24),
              
              // Sync management
              _buildSyncManagementSection(),
              
              const SizedBox(height: 24),
              
              // Troubleshooting
              const SyncTroubleshootingWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformInfoSection() {
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
            Row(
              children: [
                Icon(
                  Icons.smartphone,
                  color: CareCircleDesignTokens.primaryMedicalBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Health Platform',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CareCircleDesignTokens.primaryMedicalBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPlatformDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformDetails() {
    final platformName = _deviceHealthService.platformName;
    final isReady = _deviceHealthService.isReady;
    
    return Column(
      children: [
        Row(
          children: [
            Icon(
              _getPlatformIcon(),
              color: _getPlatformColor(),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    platformName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getPlatformDescription(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isReady 
                    ? CareCircleDesignTokens.healthGreen.withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isReady ? 'Ready' : 'Setup Required',
                style: TextStyle(
                  fontSize: 12,
                  color: isReady ? CareCircleDesignTokens.healthGreen : Colors.orange[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSupportedMetricsInfo(),
      ],
    );
  }

  Widget _buildSupportedMetricsInfo() {
    final supportedTypes = _deviceHealthService.supportedMetricTypes;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supported Health Metrics',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: supportedTypes.take(6).map((type) => Chip(
            label: Text(
              type.displayName,
              style: const TextStyle(fontSize: 11),
            ),
            backgroundColor: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.1),
            side: BorderSide.none,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          )).toList(),
        ),
        if (supportedTypes.length > 6) ...[
          const SizedBox(height: 4),
          Text(
            '+${supportedTypes.length - 6} more metrics supported',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDeviceConnectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Connection',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
        const SizedBox(height: 16),
        const DeviceConnectionCard(),
      ],
    );
  }

  Widget _buildSyncManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sync Management',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
        const SizedBox(height: 16),
        _buildSyncControls(),
      ],
    );
  }

  Widget _buildSyncControls() {
    final syncStatus = ref.watch(healthSyncStatusProvider);
    
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.sync,
                  color: CareCircleDesignTokens.primaryMedicalBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Sync Controls',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (syncStatus.isSyncing)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: syncStatus.isSyncing ? null : () => _syncLast24Hours(),
                    icon: const Icon(Icons.sync, size: 18),
                    label: const Text('Sync 24h'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CareCircleDesignTokens.healthGreen,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: syncStatus.isSyncing ? null : () => _syncLast7Days(),
                    icon: const Icon(Icons.sync_alt, size: 18),
                    label: const Text('Sync 7d'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: syncStatus.isSyncing ? null : () => _forceFullSync(),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Force Full Sync'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange[700],
                  side: BorderSide(color: Colors.orange[700]!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPlatformIcon() {
    final platformName = _deviceHealthService.platformName;
    switch (platformName) {
      case 'HealthKit':
        return Icons.favorite;
      case 'Health Connect':
        return Icons.health_and_safety;
      default:
        return Icons.device_unknown;
    }
  }

  Color _getPlatformColor() {
    final platformName = _deviceHealthService.platformName;
    switch (platformName) {
      case 'HealthKit':
        return Colors.blue[600]!;
      case 'Health Connect':
        return Colors.green[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  String _getPlatformDescription() {
    final platformName = _deviceHealthService.platformName;
    switch (platformName) {
      case 'HealthKit':
        return 'Apple\'s health data platform for iOS devices';
      case 'Health Connect':
        return 'Google\'s health data platform for Android devices';
      default:
        return 'Health platform not detected';
    }
  }

  Future<void> _refreshDeviceStatus() async {
    _logger.info('Refreshing device status');
    
    try {
      // Refresh sync status
      ref.invalidate(healthSyncStatusProvider);
      ref.invalidate(healthSyncPermissionsProvider);
      
      // Re-initialize device service if needed
      await _initializeDeviceService();
      
      _logger.info('Device status refreshed successfully');
    } catch (e) {
      _logger.error('Failed to refresh device status: $e', e);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }

  void _syncLast24Hours() {
    _logger.info('Triggering 24-hour sync from device management');
    ref.read(syncLast24HoursProvider);
  }

  void _syncLast7Days() {
    _logger.info('Triggering 7-day sync from device management');
    ref.read(syncLast7DaysProvider);
  }

  void _forceFullSync() {
    _logger.info('Triggering force full sync from device management');
    ref.read(forceSyncAllDataProvider);
  }

  void _showHelpDialog() {
    _logger.info('Showing device management help dialog');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Device Management Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Health Data Sync',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Sync 24h: Syncs health data from the last 24 hours'),
              Text('• Sync 7d: Syncs health data from the last 7 days'),
              Text('• Force Full Sync: Re-syncs all available health data'),
              SizedBox(height: 16),
              Text(
                'Troubleshooting',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Check permissions if sync fails'),
              Text('• Restart the app if connection issues persist'),
              Text('• Ensure your device supports health data sharing'),
              SizedBox(height: 16),
              Text(
                'Privacy',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• All health data is encrypted and HIPAA-compliant'),
              Text('• You control what data is shared'),
              Text('• Data sync can be disabled at any time'),
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
}
