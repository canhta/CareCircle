import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/health_metric_type.dart';

/// Card widget displaying a health metric with current value and trend
///
/// Shows the latest value for a specific health metric type with
/// healthcare-appropriate styling and loading states.
class HealthMetricCard extends ConsumerWidget {
  final HealthMetricType metricType;
  final VoidCallback? onTap;

  const HealthMetricCard({super.key, required this.metricType, this.onTap});

  static final _logger = BoundedContextLoggers.healthData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _logger.info('Health metric card tapped: ${metricType.displayName}');
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(_getMetricIcon(), color: _getMetricColor(), size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      metricType.displayName,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: Colors.grey[700]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildMetricValue(context),
              const SizedBox(height: 8),
              _buildLastUpdated(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricValue(BuildContext context) {
    // TODO: Replace with actual data from provider
    // For now, show placeholder values
    final placeholderValue = _getPlaceholderValue();
    final placeholderUnit = _getPlaceholderUnit();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          placeholderValue,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: _getMetricColor()),
        ),
        if (placeholderUnit.isNotEmpty)
          Text(placeholderUnit, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildLastUpdated(BuildContext context) {
    // TODO: Replace with actual last sync time
    return Row(
      children: [
        Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          'Updated 2h ago',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[500], fontSize: 10),
        ),
      ],
    );
  }

  IconData _getMetricIcon() {
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

  Color _getMetricColor() {
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

  String _getPlaceholderValue() {
    switch (metricType) {
      case HealthMetricType.heartRate:
        return '72';
      case HealthMetricType.bloodPressure:
        return '120/80';
      case HealthMetricType.bloodGlucose:
        return '95';
      case HealthMetricType.bodyTemperature:
        return '98.6';
      case HealthMetricType.weight:
        return '70.5';
      case HealthMetricType.height:
        return '175';
      case HealthMetricType.steps:
        return '8,432';
      case HealthMetricType.oxygenSaturation:
        return '98';
      case HealthMetricType.sleep:
        return '7.5';
      case HealthMetricType.exercise:
        return '45';
    }
  }

  String _getPlaceholderUnit() {
    switch (metricType) {
      case HealthMetricType.heartRate:
        return 'bpm';
      case HealthMetricType.bloodPressure:
        return 'mmHg';
      case HealthMetricType.bloodGlucose:
        return 'mg/dL';
      case HealthMetricType.bodyTemperature:
        return '°F';
      case HealthMetricType.weight:
        return 'kg';
      case HealthMetricType.height:
        return 'cm';
      case HealthMetricType.steps:
        return 'steps';
      case HealthMetricType.oxygenSaturation:
        return '%';
      case HealthMetricType.sleep:
        return 'hours';
      case HealthMetricType.exercise:
        return 'min';
    }
  }
}

/// Loading state for health metric card
class HealthMetricCardLoading extends StatelessWidget {
  const HealthMetricCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 24,
              width: 60,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(height: 4),
            Container(
              height: 12,
              width: 40,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(height: 8),
            Container(
              height: 10,
              width: 80,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error state for health metric card
class HealthMetricCardError extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;

  const HealthMetricCardError({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: CareCircleDesignTokens.criticalAlert, size: 32),
            const SizedBox(height: 8),
            Text(
              'Error loading data',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: CareCircleDesignTokens.criticalAlert,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              error,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 8),
              TextButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
