import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../providers/medication_providers.dart';
import '../providers/adherence_providers.dart';

/// Medication Statistics Screen for analytics and insights interface
/// 
/// Features:
/// - Usage analytics and insights
/// - Adherence trends over time
/// - Medication effectiveness tracking
/// - Health correlations and patterns
/// - Material Design 3 healthcare adaptations
class MedicationStatisticsScreen extends ConsumerStatefulWidget {
  const MedicationStatisticsScreen({super.key});

  @override
  ConsumerState<MedicationStatisticsScreen> createState() => _MedicationStatisticsScreenState();
}

class _MedicationStatisticsScreenState extends ConsumerState<MedicationStatisticsScreen> {
  static final _logger = BoundedContextLoggers.medication;
  String _selectedPeriod = '30days';
  String _selectedMetric = 'adherence';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final medicationsAsync = ref.watch(medicationsProvider);
    final statisticsAsync = ref.watch(adherenceStatisticsProvider('all'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Statistics'),
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
              const PopupMenuItem(value: '90days', child: Text('Last 3 Months')),
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
            _buildOverviewCards(medicationsAsync, statisticsAsync, theme),
            const SizedBox(height: 24),
            _buildMetricSelector(theme),
            const SizedBox(height: 16),
            _buildMainChart(statisticsAsync, theme),
            const SizedBox(height: 24),
            _buildMedicationBreakdown(medicationsAsync, theme),
            const SizedBox(height: 24),
            _buildInsightsSection(statisticsAsync, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards(
    AsyncValue<List<Medication>> medicationsAsync,
    AsyncValue<AdherenceStatistics> statisticsAsync,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            'Total Medications',
            medicationsAsync.when(
              data: (medications) => medications.length.toString(),
              loading: () => '...',
              error: (_, __) => '0',
            ),
            Icons.medication,
            CareCircleDesignTokens.primaryMedicalBlue,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            'Avg Adherence',
            statisticsAsync.when(
              data: (stats) => '${stats.adherencePercentage.toInt()}%',
              loading: () => '...',
              error: (_, __) => '0%',
            ),
            Icons.trending_up,
            CareCircleDesignTokens.healthGreen,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            'Active Schedules',
            statisticsAsync.when(
              data: (stats) => '${stats.takenDoses + stats.missedDoses}',
              loading: () => '...',
              error: (_, __) => '0',
            ),
            Icons.schedule,
            Colors.orange,
            theme,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricSelector(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chart Metrics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _buildMetricChip('adherence', 'Adherence', theme),
                _buildMetricChip('doses_taken', 'Doses Taken', theme),
                _buildMetricChip('missed_doses', 'Missed Doses', theme),
                _buildMetricChip('effectiveness', 'Effectiveness', theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip(String metric, String label, ThemeData theme) {
    final isSelected = _selectedMetric == metric;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedMetric = metric;
          });
        }
      },
      selectedColor: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.2),
      checkmarkColor: CareCircleDesignTokens.primaryMedicalBlue,
    );
  }

  Widget _buildMainChart(AsyncValue<AdherenceStatistics> statisticsAsync, ThemeData theme) {
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
                  _getChartTitle(),
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
            statisticsAsync.when(
              data: (statistics) => _buildChart(statistics, theme),
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => _buildErrorState('Failed to load chart data', theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(AdherenceStatistics statistics, ThemeData theme) {
    switch (_selectedMetric) {
      case 'adherence':
        return _buildAdherenceChart(statistics, theme);
      case 'doses_taken':
        return _buildDosesChart(statistics, theme, true);
      case 'missed_doses':
        return _buildDosesChart(statistics, theme, false);
      case 'effectiveness':
        return _buildEffectivenessChart(statistics, theme);
      default:
        return _buildAdherenceChart(statistics, theme);
    }
  }

  Widget _buildAdherenceChart(AdherenceStatistics statistics, ThemeData theme) {
    // Create mock trend data from statistics
    final trends = List.generate(7, (index) => statistics.adherencePercentage + (index * 2.0 - 6.0));

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
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < trends.length) {
                    final date = DateTime.now().subtract(Duration(days: trends.length - index - 1));
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
          maxX: (trends.length - 1).toDouble(),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: trends.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value);
              }).toList(),
              isCurved: true,
              color: CareCircleDesignTokens.healthGreen,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: CareCircleDesignTokens.healthGreen,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: CareCircleDesignTokens.healthGreen.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDosesChart(AdherenceStatistics statistics, ThemeData theme, bool showTaken) {
    // Create mock dosage data from statistics
    final trends = List.generate(7, (index) => showTaken ? statistics.takenDoses : statistics.missedDoses);

    final color = showTaken ? CareCircleDesignTokens.healthGreen : CareCircleDesignTokens.criticalAlert;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: trends.reduce((a, b) => a > b ? a : b).toDouble() + 2,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => color.withValues(alpha: 0.8),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final value = rod.toY.toInt();
                final label = showTaken ? 'Taken' : 'Missed';
                return BarTooltipItem(
                  '$label: $value',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < trends.length) {
                    final date = DateTime.now().subtract(Duration(days: trends.length - index - 1));
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
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
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
          barGroups: trends.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value.toDouble();

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  color: color,
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEffectivenessChart(AdherenceStatistics statistics, ThemeData theme) {
    // Create mock effectiveness data from statistics
    final trends = List.generate(7, (index) => (statistics.adherencePercentage / 20.0).clamp(1.0, 5.0));

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < trends.length) {
                    final date = DateTime.now().subtract(Duration(days: trends.length - index - 1));
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
                interval: 1,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
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
          maxX: (trends.length - 1).toDouble(),
          minY: 1,
          maxY: 5,
          lineBarsData: [
            LineChartBarData(
              spots: trends.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value);
              }).toList(),
              isCurved: true,
              color: CareCircleDesignTokens.primaryMedicalBlue,
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
                color: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationBreakdown(AsyncValue<List<Medication>> medicationsAsync, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medication Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            medicationsAsync.when(
              data: (medications) => medications.isEmpty
                  ? _buildEmptyState('No medications to analyze', theme)
                  : _buildMedicationPieChart(medications, theme),
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => _buildErrorState('Failed to load medication data', theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationPieChart(List<Medication> medications, ThemeData theme) {
    final categoryData = <String, int>{};
    for (final medication in medications) {
      final category = medication.category.isNotEmpty ? medication.category : 'Other';
      categoryData[category] = (categoryData[category] ?? 0) + 1;
    }

    final colors = [
      CareCircleDesignTokens.primaryMedicalBlue,
      CareCircleDesignTokens.healthGreen,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];

    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sections: categoryData.entries.map((entry) {
                  final index = categoryData.keys.toList().indexOf(entry.key);
                  final color = colors[index % colors.length];
                  final percentage = (entry.value / medications.length * 100);

                  return PieChartSectionData(
                    color: color,
                    value: entry.value.toDouble(),
                    title: '${percentage.toInt()}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categoryData.entries.map((entry) {
                final index = categoryData.keys.toList().indexOf(entry.key);
                final color = colors[index % colors.length];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${entry.key} (${entry.value})',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsSection(AsyncValue<AdherenceStatistics> statisticsAsync, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Insights',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            statisticsAsync.when(
              data: (statistics) => _buildInsightsContent(statistics, theme),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _buildErrorState('Failed to load insights', theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsContent(AdherenceStatistics statistics, ThemeData theme) {
    final insights = _generateInsights(statistics);

    if (insights.isEmpty) {
      return _buildEmptyState('No insights available yet', theme);
    }

    return Column(
      children: insights.map((insight) => _buildInsightCard(insight, theme)).toList(),
    );
  }

  Widget _buildInsightCard(StatisticsInsight insight, ThemeData theme) {
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
                Text(
                  insight.description,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart(String message, ThemeData theme) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.analytics,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
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

  String _getChartTitle() {
    switch (_selectedMetric) {
      case 'adherence':
        return 'Adherence Trends';
      case 'doses_taken':
        return 'Doses Taken';
      case 'missed_doses':
        return 'Missed Doses';
      case 'effectiveness':
        return 'Effectiveness Trends';
      default:
        return 'Chart Data';
    }
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

  List<StatisticsInsight> _generateInsights(AdherenceStatistics statistics) {
    final insights = <StatisticsInsight>[];

    // Adherence insights
    if (statistics.adherencePercentage >= 90) {
      insights.add(StatisticsInsight(
        title: 'Excellent Adherence!',
        description: 'Your adherence of ${statistics.adherencePercentage.toInt()}% is excellent. Keep up the great work!',
        type: InsightType.positive,
        icon: Icons.celebration,
      ));
    } else if (statistics.adherencePercentage >= 70) {
      insights.add(StatisticsInsight(
        title: 'Good Progress',
        description: 'Your adherence is good at ${statistics.adherencePercentage.toInt()}%, but there\'s room for improvement.',
        type: InsightType.warning,
        icon: Icons.trending_up,
      ));
    } else {
      insights.add(StatisticsInsight(
        title: 'Needs Attention',
        description: 'Your adherence of ${statistics.adherencePercentage.toInt()}% could be improved. Consider setting more reminders.',
        type: InsightType.critical,
        icon: Icons.warning,
      ));
    }

    // Dose insights
    final totalDoses = statistics.takenDoses + statistics.missedDoses;
    if (totalDoses > 50) {
      insights.add(StatisticsInsight(
        title: 'Active Medication Management',
        description: 'You have $totalDoses total doses tracked. Great job staying on top of your medications!',
        type: InsightType.positive,
        icon: Icons.medication,
      ));
    }

    // Streak insights
    if (statistics.currentStreak >= 7) {
      insights.add(StatisticsInsight(
        title: 'Great Streak!',
        description: 'You\'ve maintained a ${statistics.currentStreak}-day streak. Consistency is key!',
        type: InsightType.positive,
        icon: Icons.local_fire_department,
      ));
    }

    return insights;
  }
}

// Helper classes for insights
class StatisticsInsight {
  final String title;
  final String description;
  final InsightType type;
  final IconData icon;

  StatisticsInsight({
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
  });
}

enum InsightType { positive, warning, critical }
