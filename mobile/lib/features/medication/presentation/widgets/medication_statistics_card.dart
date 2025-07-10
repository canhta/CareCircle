import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/design_tokens.dart';
import '../providers/medication_providers.dart';

class MedicationStatisticsCard extends ConsumerWidget {
  const MedicationStatisticsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsAsync = ref.watch(medicationStatisticsProvider);

    return statisticsAsync.when(
      data: (stats) => _buildStatisticsCard(context, stats),
      loading: () => _buildLoadingCard(context),
      error: (_, __) => _buildErrorCard(context),
    );
  }

  Widget _buildStatisticsCard(BuildContext context, Map<String, dynamic> stats) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.1),
              CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medication Overview',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Total',
                  stats['total'].toString(),
                  Icons.medication,
                  CareCircleDesignTokens.primaryMedicalBlue,
                ),
                _buildStatItem(
                  context,
                  'Active',
                  stats['active'].toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatItem(
                  context,
                  'Inactive',
                  stats['inactive'].toString(),
                  Icons.pause_circle,
                  Colors.grey,
                ),
                _buildStatItem(
                  context,
                  'Expiring',
                  stats['expiringSoon'].toString(),
                  Icons.warning,
                  Colors.orange,
                ),
              ],
            ),
            if ((stats['byForm'] as Map<String, int>).isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'By Form',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              _buildFormBreakdown(context, stats['byForm'] as Map<String, int>),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFormBreakdown(BuildContext context, Map<String, int> byForm) {
    final sortedEntries = byForm.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: sortedEntries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getFormIcon(entry.key),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 4),
              Text(
                '${entry.key}: ${entry.value}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 120,
        child: const Center(
          child: CircularProgressIndicator(
            color: CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 120,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red[400],
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load statistics',
                style: TextStyle(
                  color: Colors.red[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFormIcon(String form) {
    switch (form.toLowerCase()) {
      case 'tablet':
        return '💊';
      case 'capsule':
        return '💊';
      case 'liquid':
        return '🧴';
      case 'injection':
        return '💉';
      case 'patch':
        return '🩹';
      case 'inhaler':
        return '🫁';
      case 'cream':
        return '🧴';
      case 'drops':
        return '💧';
      case 'suppository':
        return '💊';
      default:
        return '💊';
    }
  }
}
