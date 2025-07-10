import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/health_metric_type.dart';

/// Widget displaying a list of recent health metrics
///
/// Shows the most recent health data entries with healthcare-appropriate
/// styling and privacy-compliant logging.
class RecentMetricsList extends ConsumerWidget {
  final int limit;
  final bool showEmpty;

  const RecentMetricsList({super.key, this.limit = 10, this.showEmpty = true});

  static final _logger = BoundedContextLoggers.healthData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with actual data provider
    // For now, show placeholder data
    final placeholderMetrics = _generatePlaceholderMetrics();

    if (placeholderMetrics.isEmpty && showEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: placeholderMetrics
          .take(limit)
          .map((metric) => _RecentMetricTile(metric: metric))
          .toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.health_and_safety_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No recent health data',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your health metrics to see them here',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddMetric(context),
            icon: const Icon(Icons.add),
            label: const Text('Add First Metric'),
            style: ElevatedButton.styleFrom(
              backgroundColor: CareCircleDesignTokens.healthGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddMetric(BuildContext context) {
    _logger.info('Navigating to add metric from empty state');
    // TODO: Implement navigation to add metric screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add metric coming soon')));
  }

  List<_PlaceholderMetric> _generatePlaceholderMetrics() {
    final now = DateTime.now();
    return [
      _PlaceholderMetric(
        type: HealthMetricType.heartRate,
        value: '72 bpm',
        timestamp: now.subtract(const Duration(hours: 2)),
        source: 'Apple Watch',
      ),
      _PlaceholderMetric(
        type: HealthMetricType.steps,
        value: '8,432 steps',
        timestamp: now.subtract(const Duration(hours: 4)),
        source: 'iPhone',
      ),
      _PlaceholderMetric(
        type: HealthMetricType.weight,
        value: '70.5 kg',
        timestamp: now.subtract(const Duration(hours: 8)),
        source: 'Smart Scale',
      ),
      _PlaceholderMetric(
        type: HealthMetricType.bloodPressure,
        value: '120/80 mmHg',
        timestamp: now.subtract(const Duration(days: 1)),
        source: 'Manual Entry',
      ),
      _PlaceholderMetric(
        type: HealthMetricType.sleep,
        value: '7.5 hours',
        timestamp: now.subtract(const Duration(days: 1, hours: 8)),
        source: 'Sleep Tracker',
      ),
    ];
  }
}

/// Individual tile for a recent health metric
class _RecentMetricTile extends StatelessWidget {
  final _PlaceholderMetric metric;

  const _RecentMetricTile({required this.metric});

  static final _logger = BoundedContextLoggers.healthData;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getMetricColor().withValues(alpha: 0.1),
          child: Icon(_getMetricIcon(), color: _getMetricColor(), size: 20),
        ),
        title: Text(
          metric.type.displayName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              metric.value,
              style: TextStyle(
                color: _getMetricColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  _formatTimeAgo(metric.timestamp),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(width: 8),
                Icon(Icons.device_hub, size: 12, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  metric.source,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: () => _onMetricTap(context),
      ),
    );
  }

  void _onMetricTap(BuildContext context) {
    _logger.info('Recent metric tapped: ${metric.type.displayName}');
    // TODO: Navigate to metric detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${metric.type.displayName} detail coming soon')),
    );
  }

  IconData _getMetricIcon() {
    switch (metric.type) {
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
      case HealthMetricType.bloodOxygen:
        return Icons.air;
      case HealthMetricType.sleep:
        return Icons.bedtime;
      case HealthMetricType.exercise:
        return Icons.fitness_center;
      case HealthMetricType.respiratoryRate:
        return Icons.air;
      case HealthMetricType.activity:
        return Icons.directions_run;
      case HealthMetricType.mood:
        return Icons.mood;
    }
  }

  Color _getMetricColor() {
    switch (metric.type) {
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
      case HealthMetricType.bloodOxygen:
        return Colors.cyan[600]!;
      case HealthMetricType.sleep:
        return Colors.indigo[600]!;
      case HealthMetricType.exercise:
        return Colors.deepOrange[600]!;
      case HealthMetricType.respiratoryRate:
        return Colors.lightBlue[600]!;
      case HealthMetricType.activity:
        return Colors.lime[600]!;
      case HealthMetricType.mood:
        return Colors.pink[600]!;
    }
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
}

/// Placeholder data model for recent metrics
class _PlaceholderMetric {
  final HealthMetricType type;
  final String value;
  final DateTime timestamp;
  final String source;

  const _PlaceholderMetric({
    required this.type,
    required this.value,
    required this.timestamp,
    required this.source,
  });
}

/// Loading state for recent metrics list
class RecentMetricsListLoading extends StatelessWidget {
  final int itemCount;

  const RecentMetricsListLoading({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.grey[300]),
            title: Container(
              height: 16,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 12,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
