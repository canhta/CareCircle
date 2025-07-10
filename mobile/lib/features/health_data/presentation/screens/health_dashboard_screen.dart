import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/health_metric_type.dart';
import '../../application/providers/health_sync_provider.dart';
import '../widgets/health_metric_card.dart';
import '../widgets/health_sync_status_widget.dart';
import '../widgets/recent_metrics_list.dart';

/// Main health dashboard screen showing key health metrics overview
///
/// This screen serves as the primary entry point for health data features,
/// displaying current health status, recent metrics, and quick access to
/// detailed views with healthcare-compliant logging.
class HealthDashboardScreen extends ConsumerStatefulWidget {
  const HealthDashboardScreen({super.key});

  @override
  ConsumerState<HealthDashboardScreen> createState() =>
      _HealthDashboardScreenState();
}

class _HealthDashboardScreenState extends ConsumerState<HealthDashboardScreen> {
  static final _logger = BoundedContextLoggers.healthData;

  @override
  void initState() {
    super.initState();
    _logger.info('Health dashboard screen initialized');

    // Trigger initial data sync check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionsAndSync();
    });
  }

  Future<void> _checkPermissionsAndSync() async {
    try {
      final hasPermissions = await ref.read(
        healthSyncPermissionsProvider.future,
      );
      if (hasPermissions) {
        // Trigger sync of last 24 hours if permissions are available
        ref.read(syncLast24HoursProvider);
      }
    } catch (e) {
      _logger.error('Failed to check permissions and sync: $e', e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Dashboard'),
        backgroundColor: CareCircleDesignTokens.healthGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () => _showSyncOptions(context),
            tooltip: 'Sync Health Data',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(),
            tooltip: 'Health Settings',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Health sync status
              const HealthSyncStatusWidget(),

              const SizedBox(height: 24),

              // Quick metrics overview
              _buildQuickMetricsSection(),

              const SizedBox(height: 24),

              // Recent metrics
              _buildRecentMetricsSection(),

              const SizedBox(height: 24),

              // Quick actions
              _buildQuickActionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Metrics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            HealthMetricCard(
              metricType: HealthMetricType.heartRate,
              onTap: () => _navigateToMetricDetail(HealthMetricType.heartRate),
            ),
            HealthMetricCard(
              metricType: HealthMetricType.bloodPressure,
              onTap: () =>
                  _navigateToMetricDetail(HealthMetricType.bloodPressure),
            ),
            HealthMetricCard(
              metricType: HealthMetricType.weight,
              onTap: () => _navigateToMetricDetail(HealthMetricType.weight),
            ),
            HealthMetricCard(
              metricType: HealthMetricType.steps,
              onTap: () => _navigateToMetricDetail(HealthMetricType.steps),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            TextButton(
              onPressed: () => _navigateToAllMetrics(),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const RecentMetricsList(limit: 5),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.add_circle_outline,
                label: 'Add Metric',
                color: CareCircleDesignTokens.healthGreen,
                onPressed: () => _navigateToAddMetric(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.devices,
                label: 'Devices',
                color: CareCircleDesignTokens.primaryMedicalBlue,
                onPressed: () => _navigateToDevices(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.track_changes,
                label: 'Goals',
                color: Colors.orange,
                onPressed: () => _navigateToGoals(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.analytics,
                label: 'Analytics',
                color: Colors.purple,
                onPressed: () => _navigateToAnalytics(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _refreshDashboard() async {
    _logger.info('Refreshing health dashboard');

    try {
      // Refresh sync status
      ref.invalidate(healthSyncStatusProvider);

      // Trigger fresh sync
      await ref.read(syncLast24HoursProvider.future);

      _logger.info('Health dashboard refreshed successfully');
    } catch (e) {
      _logger.error('Failed to refresh health dashboard: $e', e);

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

  void _showSyncOptions(BuildContext context) {
    _logger.info('Showing sync options dialog');

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Sync Last 24 Hours'),
              onTap: () {
                Navigator.pop(context);
                ref.read(syncLast24HoursProvider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sync_alt),
              title: const Text('Sync Last 7 Days'),
              onTap: () {
                Navigator.pop(context);
                ref.read(syncLast7DaysProvider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Force Sync All'),
              onTap: () {
                Navigator.pop(context);
                ref.read(forceSyncAllDataProvider);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMetricDetail(HealthMetricType metricType) {
    _logger.info('Navigating to metric detail: ${metricType.displayName}');
    // TODO: Implement metric detail navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${metricType.displayName} detail coming soon')),
    );
  }

  void _navigateToAllMetrics() {
    _logger.info('Navigating to all metrics view');
    // TODO: Implement all metrics navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All metrics view coming soon')),
    );
  }

  void _navigateToAddMetric() {
    _logger.info('Navigating to add metric screen');
    // TODO: Implement add metric navigation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add metric coming soon')));
  }

  void _navigateToDevices() {
    _logger.info('Navigating to devices screen');
    // TODO: Implement devices navigation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Devices screen coming soon')));
  }

  void _navigateToGoals() {
    _logger.info('Navigating to goals screen');
    // TODO: Implement goals navigation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Goals screen coming soon')));
  }

  void _navigateToAnalytics() {
    _logger.info('Navigating to analytics screen');
    // TODO: Implement analytics navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Analytics screen coming soon')),
    );
  }

  void _navigateToSettings() {
    _logger.info('Navigating to health settings');
    // TODO: Implement settings navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Health settings coming soon')),
    );
  }
}

/// Quick action button widget for dashboard actions
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
