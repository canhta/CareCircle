import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/design/design_tokens.dart';
import '../../domain/models/models.dart';
import '../providers/adherence_providers.dart';

/// Adherence Dashboard Screen for compliance tracking and visualization
///
/// Features:
/// - Adherence charts and trend analysis
/// - Compliance reports and streak visualization
/// - Multiple medication adherence comparison
/// - Achievement badges and progress indicators
/// - Material Design 3 healthcare adaptations
class AdherenceDashboardScreen extends ConsumerStatefulWidget {
  const AdherenceDashboardScreen({super.key});

  @override
  ConsumerState<AdherenceDashboardScreen> createState() =>
      _AdherenceDashboardScreenState();
}

class _AdherenceDashboardScreenState
    extends ConsumerState<AdherenceDashboardScreen> {
  String _selectedPeriod = '7days';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statisticsAsync = ref.watch(adherenceStatisticsProvider);
    final trendsAsync = ref.watch(adherenceTrendsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adherence Dashboard'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedPeriod,
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '7days', child: Text('Last 7 Days')),
              const PopupMenuItem(value: '30days', child: Text('Last 30 Days')),
              const PopupMenuItem(
                value: '90days',
                child: Text('Last 3 Months'),
              ),
              const PopupMenuItem(value: '365days', child: Text('Last Year')),
            ],
            icon: const Icon(Icons.date_range),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewSection(statisticsAsync, theme),
            const SizedBox(height: 24),
            _buildTrendsChartSection(trendsAsync, theme),
            const SizedBox(height: 24),
            _buildAchievementsSection(statisticsAsync, theme),
            const SizedBox(height: 24),
            _buildInsightsSection(statisticsAsync, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection(
    AsyncValue<AdherenceStatistics> statisticsAsync,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Adherence',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            statisticsAsync.when(
              data: (statistics) => _buildOverviewContent(statistics, theme),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  _buildErrorState('Failed to load statistics', theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewContent(
    AdherenceStatistics statistics,
    ThemeData theme,
  ) {
    return Column(
      children: [
        // Large adherence percentage display
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                _getAdherenceColor(statistics.adherencePercentage),
                _getAdherenceColor(
                  statistics.adherencePercentage,
                ).withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${statistics.adherencePercentage.toInt()}%',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Adherence',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Statistics grid
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Current Streak',
                '${statistics.currentStreak}',
                'days',
                Icons.local_fire_department,
                CareCircleDesignTokens.healthGreen,
                theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Best Streak',
                '${statistics.longestStreak}',
                'days',
                Icons.emoji_events,
                Colors.amber,
                theme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Taken',
                '${statistics.takenDoses}',
                'doses',
                Icons.check_circle,
                CareCircleDesignTokens.healthGreen,
                theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Total Missed',
                '${statistics.missedDoses}',
                'doses',
                Icons.cancel,
                CareCircleDesignTokens.criticalAlert,
                theme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            unit,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsChartSection(
    AsyncValue<List<AdherenceTrendPoint>> trendsAsync,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Adherence Trends',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CareCircleDesignTokens.primaryMedicalBlue,
                  ),
                ),
                const Spacer(),
                Text(
                  _getPeriodDisplayName(_selectedPeriod),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            trendsAsync.when(
              data: (statistics) => _buildTrendsChart(statistics, theme),
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) =>
                  _buildErrorState('Failed to load trends', theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsChart(List<AdherenceTrendPoint> trends, ThemeData theme) {
    // Use the actual trend data
    final trendValues = trends.map((point) => point.adherenceRate).toList();
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < trends.length) {
                    final date = DateTime.now().subtract(
                      Duration(days: trendValues.length - index - 1),
                    );
                    return Text(
                      '${date.day}/${date.month}',
                      style: theme.textTheme.bodySmall,
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: theme.textTheme.bodySmall,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          minX: 0,
          maxX: (trendValues.length - 1).toDouble(),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: trendValues.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value);
              }).toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  CareCircleDesignTokens.primaryMedicalBlue,
                  CareCircleDesignTokens.healthGreen,
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: CareCircleDesignTokens.primaryMedicalBlue,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    CareCircleDesignTokens.primaryMedicalBlue.withValues(
                      alpha: 0.3,
                    ),
                    CareCircleDesignTokens.healthGreen.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(
    AsyncValue<AdherenceStatistics> statisticsAsync,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            statisticsAsync.when(
              data: (statistics) =>
                  _buildAchievementsContent(statistics, theme),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  _buildErrorState('Failed to load achievements', theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsContent(
    AdherenceStatistics statistics,
    ThemeData theme,
  ) {
    final achievements = _getAchievements(statistics);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: achievements
          .map((achievement) => _buildAchievementBadge(achievement, theme))
          .toList(),
    );
  }

  Widget _buildAchievementBadge(Achievement achievement, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: achievement.isEarned
            ? achievement.color.withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: achievement.isEarned
              ? achievement.color.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            achievement.icon,
            color: achievement.isEarned
                ? achievement.color
                : theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            achievement.title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: achievement.isEarned
                  ? achievement.color
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: achievement.isEarned
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsSection(
    AsyncValue<AdherenceStatistics> statisticsAsync,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Insights & Recommendations',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            statisticsAsync.when(
              data: (statistics) => _buildInsightsContent(statistics, theme),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  _buildErrorState('Failed to load insights', theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsContent(
    AdherenceStatistics statistics,
    ThemeData theme,
  ) {
    final insights = _generateInsights(statistics);

    return Column(
      children: insights
          .map((insight) => _buildInsightCard(insight, theme))
          .toList(),
    );
  }

  Widget _buildInsightCard(Insight insight, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: insight.type == InsightType.positive
            ? CareCircleDesignTokens.healthGreen.withValues(alpha: 0.1)
            : insight.type == InsightType.warning
            ? Colors.orange.withValues(alpha: 0.1)
            : CareCircleDesignTokens.criticalAlert.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: insight.type == InsightType.positive
              ? CareCircleDesignTokens.healthGreen.withValues(alpha: 0.3)
              : insight.type == InsightType.warning
              ? Colors.orange.withValues(alpha: 0.3)
              : CareCircleDesignTokens.criticalAlert.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            insight.icon,
            color: insight.type == InsightType.positive
                ? CareCircleDesignTokens.healthGreen
                : insight.type == InsightType.warning
                ? Colors.orange
                : CareCircleDesignTokens.criticalAlert,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(insight.description, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: CareCircleDesignTokens.criticalAlert,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: CareCircleDesignTokens.criticalAlert,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getAdherenceColor(double percentage) {
    if (percentage >= 90) return CareCircleDesignTokens.healthGreen;
    if (percentage >= 70) return Colors.orange;
    return CareCircleDesignTokens.criticalAlert;
  }

  String _getPeriodDisplayName(String period) {
    switch (period) {
      case '7days':
        return 'Last 7 Days';
      case '30days':
        return 'Last 30 Days';
      case '90days':
        return 'Last 3 Months';
      case '365days':
        return 'Last Year';
      default:
        return 'Unknown Period';
    }
  }

  List<Achievement> _getAchievements(AdherenceStatistics statistics) {
    return [
      Achievement(
        title: 'Perfect Week',
        icon: Icons.star,
        color: Colors.amber,
        isEarned: statistics.currentStreak >= 7,
      ),
      Achievement(
        title: 'Consistency Champion',
        icon: Icons.emoji_events,
        color: CareCircleDesignTokens.healthGreen,
        isEarned: statistics.adherencePercentage >= 90,
      ),
      Achievement(
        title: 'Month Master',
        icon: Icons.calendar_month,
        color: CareCircleDesignTokens.primaryMedicalBlue,
        isEarned: statistics.currentStreak >= 30,
      ),
      Achievement(
        title: 'Streak Starter',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        isEarned: statistics.currentStreak >= 3,
      ),
    ];
  }

  List<Insight> _generateInsights(AdherenceStatistics statistics) {
    final insights = <Insight>[];

    if (statistics.adherencePercentage >= 95) {
      insights.add(
        Insight(
          title: 'Excellent Adherence!',
          description:
              'You\'re maintaining excellent medication adherence. Keep up the great work!',
          type: InsightType.positive,
          icon: Icons.celebration,
        ),
      );
    } else if (statistics.adherencePercentage >= 80) {
      insights.add(
        Insight(
          title: 'Good Progress',
          description:
              'Your adherence is good, but there\'s room for improvement. Consider setting more reminders.',
          type: InsightType.warning,
          icon: Icons.trending_up,
        ),
      );
    } else {
      insights.add(
        Insight(
          title: 'Needs Attention',
          description:
              'Your adherence could be improved. Consider talking to your healthcare provider about strategies.',
          type: InsightType.critical,
          icon: Icons.warning,
        ),
      );
    }

    if (statistics.currentStreak >= 7) {
      insights.add(
        Insight(
          title: 'Great Streak!',
          description:
              'You\'ve maintained a ${statistics.currentStreak}-day streak. Consistency is key to treatment success.',
          type: InsightType.positive,
          icon: Icons.local_fire_department,
        ),
      );
    }

    if (statistics.missedDoses > statistics.takenDoses * 0.2) {
      insights.add(
        Insight(
          title: 'Missed Doses Pattern',
          description:
              'You\'ve missed several doses recently. Consider adjusting your reminder settings.',
          type: InsightType.warning,
          icon: Icons.schedule,
        ),
      );
    }

    return insights;
  }
}

// Helper classes for achievements and insights
class Achievement {
  final String title;
  final IconData icon;
  final Color color;
  final bool isEarned;

  Achievement({
    required this.title,
    required this.icon,
    required this.color,
    required this.isEarned,
  });
}

class Insight {
  final String title;
  final String description;
  final InsightType type;
  final IconData icon;

  Insight({
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
  });
}

enum InsightType { positive, warning, critical }
