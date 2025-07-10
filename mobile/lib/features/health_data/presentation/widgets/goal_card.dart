import 'package:flutter/material.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/health_metric_type.dart';
import '../screens/health_goals_screen.dart';

/// Card widget displaying a health goal with progress visualization
///
/// Shows goal information, current progress, and provides actions
/// for goal management with healthcare-appropriate styling and
/// motivational elements.
class GoalCard extends StatelessWidget {
  final PlaceholderGoal goal;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const GoalCard({super.key, required this.goal, this.onTap, this.onEdit});

  static final _logger = BoundedContextLoggers.healthData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _logger.info('Goal card tapped: ${goal.title}');
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 12),
              _buildProgressSection(context),
              const SizedBox(height: 12),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(_getMetricIcon(), color: _getMetricColor(), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goal.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                goal.description,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        if (onEdit != null)
          IconButton(
            onPressed: () {
              _logger.info('Goal edit button tapped: ${goal.title}');
              onEdit?.call();
            },
            icon: const Icon(Icons.edit, size: 18),
            tooltip: 'Edit Goal',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final progressPercentage = goal.progressPercentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatValue(goal.currentValue)} / ${_formatValue(goal.targetValue)} ${goal.unit}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _getProgressColor(progressPercentage),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getProgressColor(
                  progressPercentage,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${(progressPercentage * 100).round()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getProgressColor(progressPercentage),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progressPercentage,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            _getProgressColor(progressPercentage),
          ),
          minHeight: 6,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              _getStatusIcon(progressPercentage),
              size: 14,
              color: _getProgressColor(progressPercentage),
            ),
            const SizedBox(width: 4),
            Text(
              _getStatusText(progressPercentage),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getProgressColor(progressPercentage),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final daysLeft = goal.deadline.difference(DateTime.now()).inDays;
    final isOverdue = daysLeft < 0;

    return Row(
      children: [
        Icon(Icons.schedule, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          isOverdue
              ? 'Overdue by ${(-daysLeft)} days'
              : daysLeft == 0
              ? 'Due today'
              : '$daysLeft days left',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isOverdue ? Colors.red[600] : Colors.grey[600],
          ),
        ),
        const Spacer(),
        if (goal.progressPercentage >= 1.0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: CareCircleDesignTokens.healthGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 12,
                  color: CareCircleDesignTokens.healthGreen,
                ),
                const SizedBox(width: 4),
                Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: CareCircleDesignTokens.healthGreen,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  IconData _getMetricIcon() {
    switch (goal.metricType) {
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
    switch (goal.metricType) {
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

  Color _getProgressColor(double progress) {
    if (progress >= 1.0) {
      return CareCircleDesignTokens.healthGreen;
    } else if (progress >= 0.7) {
      return Colors.blue[600]!;
    } else if (progress >= 0.4) {
      return Colors.orange[600]!;
    } else {
      return Colors.red[600]!;
    }
  }

  IconData _getStatusIcon(double progress) {
    if (progress >= 1.0) {
      return Icons.check_circle;
    } else if (progress >= 0.7) {
      return Icons.trending_up;
    } else if (progress >= 0.4) {
      return Icons.warning;
    } else {
      return Icons.trending_down;
    }
  }

  String _getStatusText(double progress) {
    if (progress >= 1.0) {
      return 'Goal completed!';
    } else if (progress >= 0.7) {
      return 'On track';
    } else if (progress >= 0.4) {
      return 'Needs attention';
    } else {
      return 'Behind schedule';
    }
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }
    return value.toStringAsFixed(1);
  }
}

/// Compact version of goal card for smaller spaces
class CompactGoalCard extends StatelessWidget {
  final PlaceholderGoal goal;
  final VoidCallback? onTap;

  const CompactGoalCard({super.key, required this.goal, this.onTap});

  @override
  Widget build(BuildContext context) {
    final progressPercentage = goal.progressPercentage;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(_getMetricIcon(), color: _getMetricColor(), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progressPercentage,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(progressPercentage),
                      ),
                      minHeight: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(progressPercentage * 100).round()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _getProgressColor(progressPercentage),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getMetricIcon() {
    switch (goal.metricType) {
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
    switch (goal.metricType) {
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

  Color _getProgressColor(double progress) {
    if (progress >= 1.0) {
      return CareCircleDesignTokens.healthGreen;
    } else if (progress >= 0.7) {
      return Colors.blue[600]!;
    } else if (progress >= 0.4) {
      return Colors.orange[600]!;
    } else {
      return Colors.red[600]!;
    }
  }
}
