import 'package:flutter/material.dart';

import '../screens/health_goals_screen.dart';

/// Chart widget for visualizing goal progress over time
///
/// Displays progress trends, milestones, and motivational elements
/// to help users track their health goal achievements.
class GoalProgressChart extends StatelessWidget {
  final PlaceholderGoal goal;
  final DateTimeRange? dateRange;

  const GoalProgressChart({super.key, required this.goal, this.dateRange});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'Goal Progress Chart',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Track ${goal.title} progress over time',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
