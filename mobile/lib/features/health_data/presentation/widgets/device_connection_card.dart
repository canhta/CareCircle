import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../application/providers/health_sync_provider.dart';
import '../../infrastructure/services/device_health_service.dart';

/// Card widget displaying device connection status and controls
///
/// Shows current connection state, device information, and provides
/// controls for managing device connections with healthcare-compliant
/// privacy protection.
class DeviceConnectionCard extends ConsumerStatefulWidget {
  const DeviceConnectionCard({super.key});

  @override
  ConsumerState<DeviceConnectionCard> createState() =>
      _DeviceConnectionCardState();
}

class _DeviceConnectionCardState extends ConsumerState<DeviceConnectionCard> {
  static final _logger = BoundedContextLoggers.healthData;
  final _deviceHealthService = DeviceHealthService();

  @override
  Widget build(BuildContext context) {
    final syncStatus = ref.watch(healthSyncStatusProvider);
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
            _buildConnectionStatus(permissionsAsync),
            const SizedBox(height: 16),
            _buildDeviceInfo(),
            const SizedBox(height: 16),
            _buildConnectionActions(permissionsAsync, syncStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.devices,
          color: CareCircleDesignTokens.primaryMedicalBlue,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Device Connection Status',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionStatus(AsyncValue<bool> permissionsAsync) {
    return permissionsAsync.when(
      data: (hasPermissions) {
        final isReady = _deviceHealthService.isReady;
        final status = _getConnectionStatus(hasPermissions, isReady);

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: status.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: status.color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(status.icon, color: status.color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: status.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      status.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
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
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(
              'Checking connection status...',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      error: (error, _) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CareCircleDesignTokens.criticalAlert.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: CareCircleDesignTokens.criticalAlert.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error,
              color: CareCircleDesignTokens.criticalAlert,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connection Error',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: CareCircleDesignTokens.criticalAlert,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Failed to check device status: ${error.toString()}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfo() {
    final platformName = _deviceHealthService.platformName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Information',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        _buildInfoRow('Platform', platformName),
        _buildInfoRow(
          'Service Status',
          _deviceHealthService.isReady ? 'Ready' : 'Not Ready',
        ),
        _buildInfoRow(
          'Supported Metrics',
          '${_deviceHealthService.supportedMetricTypes.length} types',
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionActions(
    AsyncValue<bool> permissionsAsync,
    HealthSyncStatus syncStatus,
  ) {
    return permissionsAsync.when(
      data: (hasPermissions) {
        if (!hasPermissions) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _requestPermissions(),
              icon: const Icon(Icons.security),
              label: const Text('Grant Permissions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CareCircleDesignTokens.healthGreen,
                foregroundColor: Colors.white,
              ),
            ),
          );
        }

        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _testConnection(),
                icon: const Icon(Icons.wifi_protected_setup),
                label: const Text('Test Connection'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: syncStatus.isSyncing
                    ? null
                    : () => _reconnectDevice(),
                icon: const Icon(Icons.refresh),
                label: const Text('Reconnect'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: null, child: Text('Loading...')),
      ),
      error: (_, _) => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _retryConnection(),
          icon: const Icon(Icons.refresh),
          label: const Text('Retry Connection'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[600],
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  ConnectionStatus _getConnectionStatus(bool hasPermissions, bool isReady) {
    if (!hasPermissions) {
      return ConnectionStatus(
        title: 'Permissions Required',
        description: 'Health data permissions need to be granted',
        icon: Icons.lock,
        color: Colors.orange[600]!,
      );
    }

    if (!isReady) {
      return ConnectionStatus(
        title: 'Service Not Ready',
        description: 'Health service needs to be initialized',
        icon: Icons.warning,
        color: Colors.orange[600]!,
      );
    }

    return ConnectionStatus(
      title: 'Connected',
      description: 'Device is connected and ready for health data sync',
      icon: Icons.check_circle,
      color: CareCircleDesignTokens.healthGreen,
    );
  }

  Future<void> _requestPermissions() async {
    _logger.info('Requesting health permissions from device connection card');

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
              content: Text('Health permissions were denied'),
              backgroundColor: Colors.orange,
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

  Future<void> _testConnection() async {
    _logger.info('Testing device connection');

    try {
      final hasPermissions = await _deviceHealthService.hasPermissions();
      final isReady = _deviceHealthService.isReady;

      final message = hasPermissions && isReady
          ? 'Connection test successful'
          : 'Connection test failed - check permissions and service status';

      final color = hasPermissions && isReady
          ? CareCircleDesignTokens.healthGreen
          : Colors.orange;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: color),
        );
      }
    } catch (e) {
      _logger.error('Connection test failed: $e', e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection test failed: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }

  Future<void> _reconnectDevice() async {
    _logger.info('Reconnecting device');

    try {
      // Re-initialize the device service
      final initialized = await _deviceHealthService.initialize();

      if (initialized) {
        // Refresh all related providers
        ref.invalidate(healthSyncStatusProvider);
        ref.invalidate(healthSyncPermissionsProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Device reconnected successfully'),
              backgroundColor: CareCircleDesignTokens.healthGreen,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to reconnect device'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      _logger.error('Failed to reconnect device: $e', e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reconnection failed: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }

  Future<void> _retryConnection() async {
    _logger.info('Retrying device connection');

    // Refresh permissions state to retry
    ref.invalidate(healthSyncPermissionsProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Retrying connection...'),
          backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        ),
      );
    }
  }
}

/// Data class for connection status information
class ConnectionStatus {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const ConnectionStatus({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
