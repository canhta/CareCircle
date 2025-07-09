import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../application/providers/health_sync_provider.dart';
import '../../domain/models/health_metric_type.dart';
import '../../infrastructure/services/device_health_service.dart';

/// Widget for managing health data permissions
///
/// Displays current permission status for different health metrics
/// and provides controls for requesting permissions with healthcare-compliant
/// privacy protection and detailed explanations.
class DevicePermissionsWidget extends ConsumerStatefulWidget {
  const DevicePermissionsWidget({super.key});

  @override
  ConsumerState<DevicePermissionsWidget> createState() => _DevicePermissionsWidgetState();
}

class _DevicePermissionsWidgetState extends ConsumerState<DevicePermissionsWidget> {
  static final _logger = BoundedContextLoggers.healthData;
  final _deviceHealthService = DeviceHealthService();
  bool _showAllPermissions = false;

  @override
  Widget build(BuildContext context) {
    final permissionsAsync = ref.watch(healthSyncPermissionsProvider);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildPermissionsStatus(permissionsAsync),
            const SizedBox(height: 16),
            _buildPermissionsList(),
            const SizedBox(height: 16),
            _buildPermissionsActions(permissionsAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.security, color: CareCircleDesignTokens.primaryMedicalBlue, size: 20),
        const SizedBox(width: 8),
        Text(
          'Health Data Permissions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => _showPermissionsInfo(),
          icon: const Icon(Icons.info_outline, size: 18),
          tooltip: 'Permission Information',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildPermissionsStatus(AsyncValue<bool> permissionsAsync) {
    return permissionsAsync.when(
      data: (hasPermissions) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: hasPermissions
                ? CareCircleDesignTokens.healthGreen.withValues(alpha: 0.1)
                : Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasPermissions
                  ? CareCircleDesignTokens.healthGreen.withValues(alpha: 0.3)
                  : Colors.orange.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                hasPermissions ? Icons.check_circle : Icons.warning,
                color: hasPermissions ? CareCircleDesignTokens.healthGreen : Colors.orange[600],
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasPermissions ? 'Permissions Granted' : 'Permissions Required',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: hasPermissions ? CareCircleDesignTokens.healthGreen : Colors.orange[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasPermissions
                          ? 'CareCircle can access your health data'
                          : 'Grant permissions to sync health data',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(width: 12),
            Text(
              'Checking permissions...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      error: (error, _) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CareCircleDesignTokens.criticalAlert.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CareCircleDesignTokens.criticalAlert.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.error, color: CareCircleDesignTokens.criticalAlert, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Failed to check permissions: ${error.toString()}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsList() {
    final supportedTypes = _deviceHealthService.supportedMetricTypes;
    final displayTypes = _showAllPermissions ? supportedTypes : supportedTypes.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Health Metrics Access',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            if (supportedTypes.length > 5)
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAllPermissions = !_showAllPermissions;
                  });
                },
                child: Text(_showAllPermissions ? 'Show Less' : 'Show All'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ...displayTypes.map((type) => _buildPermissionItem(type)),
      ],
    );
  }

  Widget _buildPermissionItem(HealthMetricType metricType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(_getMetricIcon(metricType), color: _getMetricColor(metricType), size: 18),
          const SizedBox(width: 12),
          Expanded(child: Text(metricType.displayName, style: Theme.of(context).textTheme.bodySmall)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: CareCircleDesignTokens.healthGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Read/Write',
              style: TextStyle(fontSize: 10, color: CareCircleDesignTokens.healthGreen, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsActions(AsyncValue<bool> permissionsAsync) {
    return permissionsAsync.when(
      data: (hasPermissions) {
        if (hasPermissions) {
          return Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showPermissionsDetails(),
                  icon: const Icon(Icons.list),
                  label: const Text('View Details'),
                  style: OutlinedButton.styleFrom(foregroundColor: CareCircleDesignTokens.primaryMedicalBlue),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _revokePermissions(),
                  icon: const Icon(Icons.block),
                  label: const Text('Revoke'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[600],
                    side: BorderSide(color: Colors.red[600]!),
                  ),
                ),
              ),
            ],
          );
        } else {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _requestPermissions(),
              icon: const Icon(Icons.security),
              label: const Text('Grant Health Permissions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CareCircleDesignTokens.healthGreen,
                foregroundColor: Colors.white,
              ),
            ),
          );
        }
      },
      loading: () => const SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: null, child: Text('Loading...')),
      ),
      error: (_, __) => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _retryPermissionCheck(),
          icon: const Icon(Icons.refresh),
          label: const Text('Retry Permission Check'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[600], foregroundColor: Colors.white),
        ),
      ),
    );
  }

  IconData _getMetricIcon(HealthMetricType metricType) {
    switch (metricType) {
      case HealthMetricType.heartRate:
        return Icons.favorite;
      case HealthMetricType.bloodPressure:
        return Icons.monitor_heart;
      case HealthMetricType.bloodGlucose:
        return Icons.bloodtype;
      case HealthMetricType.bodyTemperature:
        return Icons.thermostat;
      case HealthMetricType.weight:
        return Icons.scale;
      case HealthMetricType.height:
        return Icons.height;
      case HealthMetricType.steps:
        return Icons.directions_walk;
      case HealthMetricType.oxygenSaturation:
        return Icons.air;
      case HealthMetricType.sleep:
        return Icons.bedtime;
      case HealthMetricType.exercise:
        return Icons.fitness_center;
    }
  }

  Color _getMetricColor(HealthMetricType metricType) {
    switch (metricType) {
      case HealthMetricType.heartRate:
        return Colors.red[600]!;
      case HealthMetricType.bloodPressure:
        return Colors.blue[600]!;
      case HealthMetricType.bloodGlucose:
        return Colors.orange[600]!;
      case HealthMetricType.bodyTemperature:
        return Colors.amber[600]!;
      case HealthMetricType.weight:
        return Colors.green[600]!;
      case HealthMetricType.height:
        return Colors.teal[600]!;
      case HealthMetricType.steps:
        return Colors.purple[600]!;
      case HealthMetricType.oxygenSaturation:
        return Colors.cyan[600]!;
      case HealthMetricType.sleep:
        return Colors.indigo[600]!;
      case HealthMetricType.exercise:
        return Colors.deepOrange[600]!;
    }
  }

  Future<void> _requestPermissions() async {
    _logger.info('Requesting health permissions from permissions widget');

    try {
      final granted = await _deviceHealthService.requestPermissions();

      if (granted) {
        // Refresh permissions state
        ref.invalidate(healthSyncPermissionsProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Health permissions granted successfully'),
              backgroundColor: CareCircleDesignTokens.healthGreen,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Health permissions were denied. Please grant permissions in Settings.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      _logger.error('Failed to request health permissions: $e', e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to request permissions: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }

  void _revokePermissions() {
    _logger.info('Showing revoke permissions dialog');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke Health Permissions'),
        content: const Text(
          'To revoke health data permissions, please go to your device Settings > Privacy & Security > Health and disable access for CareCircle.\n\n'
          'Note: This will stop health data sync until permissions are granted again.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Refresh permissions state to reflect changes
              ref.invalidate(healthSyncPermissionsProvider);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showPermissionsDetails() {
    _logger.info('Showing permissions details dialog');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health Permissions Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'CareCircle has been granted access to the following health data types:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              ..._deviceHealthService.supportedMetricTypes.map(
                (type) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(_getMetricIcon(type), size: 16, color: _getMetricColor(type)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(type.displayName, style: const TextStyle(fontSize: 14))),
                      Text('Read/Write', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Privacy & Security:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              const Text('• All data is encrypted and HIPAA-compliant', style: TextStyle(fontSize: 14)),
              const Text('• Data is only used for your health tracking', style: TextStyle(fontSize: 14)),
              const Text('• You can revoke permissions at any time', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
      ),
    );
  }

  void _showPermissionsInfo() {
    _logger.info('Showing permissions info dialog');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Health Permissions'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Why does CareCircle need health permissions?', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('CareCircle needs access to your health data to:'),
              Text('• Sync your health metrics automatically'),
              Text('• Provide personalized health insights'),
              Text('• Track your health goals and progress'),
              Text('• Share data with your healthcare providers'),
              SizedBox(height: 16),
              Text('Your Privacy is Protected', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• All data is encrypted and HIPAA-compliant'),
              Text('• Data is stored securely on your device and our servers'),
              Text('• You control what data is shared and with whom'),
              Text('• Permissions can be revoked at any time'),
              SizedBox(height: 16),
              Text('Platform Integration', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• iOS: Integrates with Apple HealthKit'),
              Text('• Android: Integrates with Google Health Connect'),
              Text('• Supports all major health metrics and devices'),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
      ),
    );
  }

  void _retryPermissionCheck() {
    _logger.info('Retrying permission check');

    // Refresh permissions state
    ref.invalidate(healthSyncPermissionsProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rechecking permissions...'),
          backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        ),
      );
    }
  }
}
