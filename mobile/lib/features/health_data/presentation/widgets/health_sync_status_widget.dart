import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../application/providers/health_sync_provider.dart';

/// Widget displaying health data sync status and controls
///
/// Shows current sync status, last sync time, and provides
/// quick access to sync operations with healthcare-compliant logging.
class HealthSyncStatusWidget extends ConsumerWidget {
  const HealthSyncStatusWidget({super.key});

  static final _logger = BoundedContextLoggers.healthData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatus = ref.watch(healthSyncStatusProvider);
    final permissionsAsync = ref.watch(healthSyncPermissionsProvider);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Health Data Sync',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CareCircleDesignTokens.primaryMedicalBlue,
                  ),
                ),
                const Spacer(),
                _buildSyncStatusIndicator(syncStatus),
              ],
            ),
            const SizedBox(height: 12),
            _buildPermissionsStatus(context, permissionsAsync),
            const SizedBox(height: 8),
            _buildLastSyncInfo(context, syncStatus),
            if (syncStatus.isSyncing) ...[
              const SizedBox(height: 12),
              _buildSyncProgress(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatusIndicator(HealthSyncStatus status) {
    if (status.isSyncing) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
      );
    }

    final color = status.hasError
        ? CareCircleDesignTokens.criticalAlert
        : CareCircleDesignTokens.healthGreen;

    final icon = status.hasError ? Icons.error : Icons.check_circle;

    return Icon(icon, color: color, size: 16);
  }

  Widget _buildPermissionsStatus(
    BuildContext context,
    AsyncValue<bool> permissionsAsync,
  ) {
    return permissionsAsync.when(
      data: (hasPermissions) {
        if (hasPermissions) {
          return Row(
            children: [
              Icon(
                Icons.check_circle,
                color: CareCircleDesignTokens.healthGreen,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Health permissions granted',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: CareCircleDesignTokens.healthGreen,
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Icon(Icons.warning, color: Colors.orange[600], size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Health permissions required',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.orange[600]),
                ),
              ),
              TextButton(
                onPressed: () => _requestPermissions(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 32),
                ),
                child: const Text('Grant'),
              ),
            ],
          );
        }
      },
      loading: () => Row(
        children: [
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          ),
          const SizedBox(width: 6),
          Text(
            'Checking permissions...',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
      error: (error, _) => Row(
        children: [
          Icon(
            Icons.error,
            color: CareCircleDesignTokens.criticalAlert,
            size: 16,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Permission check failed',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: CareCircleDesignTokens.criticalAlert,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastSyncInfo(BuildContext context, HealthSyncStatus status) {
    final lastSyncTime = status.lastSyncTime;

    if (lastSyncTime == null) {
      return Text(
        'No sync performed yet',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
      );
    }

    final timeAgo = _formatTimeAgo(lastSyncTime);
    final syncInfo = status.lastSyncResult != null
        ? '${status.lastSyncResult!.syncedCount} items synced'
        : 'Last sync';

    return Row(
      children: [
        Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          '$syncInfo $timeAgo',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSyncProgress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LinearProgressIndicator(
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(
            CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Syncing health data...',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: CareCircleDesignTokens.primaryMedicalBlue,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  void _requestPermissions(BuildContext context) async {
    _logger.info('Requesting health permissions from sync status widget');

    try {
      // TODO: Implement permission request through DeviceHealthService
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission request coming soon'),
          backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        ),
      );
    } catch (e) {
      _logger.error('Failed to request health permissions: $e', e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to request permissions: ${e.toString()}'),
          backgroundColor: CareCircleDesignTokens.criticalAlert,
        ),
      );
    }
  }
}

/// Compact version of sync status for use in app bars or smaller spaces
class CompactHealthSyncStatus extends ConsumerWidget {
  const CompactHealthSyncStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatus = ref.watch(healthSyncStatusProvider);

    if (syncStatus.isSyncing) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 6),
          Text(
            'Syncing...',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      );
    }

    final color = syncStatus.hasError ? Colors.red[300] : Colors.green[300];
    final icon = syncStatus.hasError ? Icons.sync_problem : Icons.sync;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(
          syncStatus.hasError ? 'Sync Error' : 'Synced',
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }
}
