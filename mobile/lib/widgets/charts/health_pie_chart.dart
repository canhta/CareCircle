import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/health_service.dart';

class HealthPieChart extends StatefulWidget {
  final List<HealthPieChartData> data;
  final String title;
  final bool showPercentages;
  final bool showLegend;
  final bool enableInteraction;
  final double radius;

  const HealthPieChart({
    super.key,
    required this.data,
    required this.title,
    this.showPercentages = true,
    this.showLegend = true,
    this.enableInteraction = true,
    this.radius = 80,
  });

  @override
  State<HealthPieChart> createState() => _HealthPieChartState();
}

class HealthPieChartData {
  final String label;
  final double value;
  final Color color;
  final String unit;

  const HealthPieChartData({
    required this.label,
    required this.value,
    required this.color,
    required this.unit,
  });
}

class _HealthPieChartState extends State<HealthPieChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.data.isEmpty) {
      return Card(
        child: Container(
          height: 300,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'No data available',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final total = widget.data.map((e) => e.value).reduce((a, b) => a + b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          enabled: widget.enableInteraction,
                          touchCallback:
                              (FlTouchEvent event, PieTouchResponse? response) {
                                if (!event.isInterestedForInteractions ||
                                    response == null ||
                                    response.touchedSection == null) {
                                  setState(() {
                                    _touchedIndex = null;
                                  });
                                  return;
                                }

                                setState(() {
                                  _touchedIndex = response
                                      .touchedSection!
                                      .touchedSectionIndex;
                                });
                              },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 0,
                        sections: _buildPieChartSections(total),
                      ),
                    ),
                  ),
                ),
                if (widget.showLegend) ...[
                  const SizedBox(width: 16),
                  Expanded(flex: 1, child: _buildLegend(total)),
                ],
              ],
            ),
            const SizedBox(height: 16),
            _buildSummary(total),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(double total) {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = index == _touchedIndex;
      final percentage = (data.value / total) * 100;

      return PieChartSectionData(
        color: data.color,
        value: data.value,
        title: widget.showPercentages
            ? '${percentage.toStringAsFixed(1)}%'
            : '',
        radius: isTouched ? widget.radius + 10 : widget.radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 14 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [
            Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2),
          ],
        ),
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();
  }

  Widget _buildLegend(double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.data.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        final percentage = (data.value / total) * 100;
        final isSelected = index == _touchedIndex;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: GestureDetector(
            onTap: widget.enableInteraction
                ? () {
                    setState(() {
                      _touchedIndex = _touchedIndex == index ? null : index;
                    });
                  }
                : null,
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: data.color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      Text(
                        '${data.value.toStringAsFixed(1)} ${data.unit} (${percentage.toStringAsFixed(1)}%)',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          fontWeight: isSelected
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummary(double total) {
    final theme = Theme.of(context);
    final unit = widget.data.isNotEmpty ? widget.data.first.unit : '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            'Total',
            '${total.toStringAsFixed(1)} $unit',
            Icons.add,
          ),
          _buildSummaryItem(
            'Categories',
            '${widget.data.length}',
            Icons.category,
          ),
          _buildSummaryItem(
            'Largest',
            _getLargestCategory(),
            Icons.trending_up,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  String _getLargestCategory() {
    if (widget.data.isEmpty) return '-';

    final largest = widget.data.reduce((a, b) => a.value > b.value ? a : b);
    return largest.label;
  }
}

/// Helper functions to create common pie chart data
class HealthPieChartHelper {
  /// Create sleep phase breakdown pie chart data
  static List<HealthPieChartData> createSleepPhaseData(
    List<CareCircleHealthData> sleepData,
  ) {
    final deepSleep = sleepData
        .where((d) => d.type == CareCircleHealthDataType.sleepAsleep)
        .fold(0.0, (sum, d) => sum + d.value);

    final lightSleep =
        sleepData
            .where((d) => d.type == CareCircleHealthDataType.sleepInBed)
            .fold(0.0, (sum, d) => sum + d.value) -
        deepSleep;

    // REM sleep estimation (approximately 20-25% of total sleep)
    final totalSleep = deepSleep + lightSleep;
    final remSleep = totalSleep * 0.22; // 22% estimate
    final adjustedLightSleep = lightSleep - remSleep;

    return [
      HealthPieChartData(
        label: 'Deep Sleep',
        value: deepSleep,
        color: Colors.indigo,
        unit: 'min',
      ),
      HealthPieChartData(
        label: 'REM Sleep',
        value: remSleep,
        color: Colors.purple,
        unit: 'min',
      ),
      HealthPieChartData(
        label: 'Light Sleep',
        value: adjustedLightSleep,
        color: Colors.lightBlue,
        unit: 'min',
      ),
    ].where((data) => data.value > 0).toList();
  }

  /// Create heart rate zones pie chart data
  static List<HealthPieChartData> createHeartRateZonesData(
    List<CareCircleHealthData> heartRateData,
  ) {
    if (heartRateData.isEmpty) return [];

    final Map<String, int> zones = {
      'Resting': 0,
      'Fat Burn': 0,
      'Cardio': 0,
      'Peak': 0,
    };

    for (final data in heartRateData) {
      final hr = data.value.toInt();
      if (hr < 100) {
        zones['Resting'] = zones['Resting']! + 1;
      } else if (hr < 140) {
        zones['Fat Burn'] = zones['Fat Burn']! + 1;
      } else if (hr < 170) {
        zones['Cardio'] = zones['Cardio']! + 1;
      } else {
        zones['Peak'] = zones['Peak']! + 1;
      }
    }

    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red];

    return zones.entries
        .toList()
        .asMap()
        .entries
        .where((entry) => entry.value.value > 0)
        .map(
          (entry) => HealthPieChartData(
            label: entry.value.key,
            value: entry.value.value.toDouble(),
            color: colors[entry.key],
            unit: 'readings',
          ),
        )
        .toList();
  }

  /// Create activity distribution pie chart data
  static List<HealthPieChartData> createActivityDistributionData(
    List<CareCircleHealthData> activityData,
  ) {
    final Map<CareCircleHealthDataType, double> totals = {};

    for (final data in activityData) {
      totals[data.type] = (totals[data.type] ?? 0) + data.value;
    }

    final colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.purple,
    ];

    return totals.entries.toList().asMap().entries.map((entry) {
      final type = entry.value.key;
      final value = entry.value.value;
      final colorIndex = entry.key % colors.length;

      return HealthPieChartData(
        label: _getDisplayNameForType(type),
        value: value,
        color: colors[colorIndex],
        unit: _getUnitForType(type),
      );
    }).toList();
  }

  static String _getDisplayNameForType(CareCircleHealthDataType type) {
    switch (type) {
      case CareCircleHealthDataType.steps:
        return 'Steps';
      case CareCircleHealthDataType.activeEnergyBurned:
        return 'Active Calories';
      case CareCircleHealthDataType.distanceWalkingRunning:
        return 'Distance';
      case CareCircleHealthDataType.heartRate:
        return 'Heart Rate';
      default:
        return type.name;
    }
  }

  static String _getUnitForType(CareCircleHealthDataType type) {
    switch (type) {
      case CareCircleHealthDataType.steps:
        return 'steps';
      case CareCircleHealthDataType.activeEnergyBurned:
        return 'cal';
      case CareCircleHealthDataType.distanceWalkingRunning:
        return 'km';
      case CareCircleHealthDataType.heartRate:
        return 'bpm';
      default:
        return '';
    }
  }
}
