import 'package:flutter/material.dart';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../screens/health_goals_screen.dart';

/// Badge widget displaying a health achievement
///
/// Shows achievement information with motivational styling
/// and celebration elements to encourage user engagement.
class AchievementBadge extends StatelessWidget {
  final PlaceholderAchievement achievement;
  final VoidCallback? onTap;

  const AchievementBadge({super.key, required this.achievement, this.onTap});

  static final _logger = BoundedContextLoggers.healthData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _logger.info('Achievement badge tapped: ${achievement.title}');
        onTap?.call();
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [achievement.color.withValues(alpha: 0.1), achievement.color.withValues(alpha: 0.05)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: achievement.color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: achievement.color.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: Icon(achievement.icon, color: achievement.color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              achievement.title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: achievement.color),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(achievement.earnedDate),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600], fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference}d ago';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}

/// Placeholder widget for goal progress chart
class GoalProgressChart extends StatelessWidget {
  final PlaceholderGoal goal;

  const GoalProgressChart({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text('Progress Chart', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text('Coming soon', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}
