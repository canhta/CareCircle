import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../providers/interaction_providers.dart';

/// Interactions tab for medication detail screen
/// 
/// Displays drug interaction information including:
/// - Current medication interactions
/// - Interaction severity levels
/// - Recommendations and warnings
/// - RxNorm integration
class MedicationInteractionsTab extends ConsumerWidget {
  final String medicationId;
  static final _logger = BoundedContextLoggers.medication;

  const MedicationInteractionsTab({
    super.key,
    required this.medicationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interactionsAsync = ref.watch(userMedicationInteractionsProvider);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInteractionsHeader(theme),
          const SizedBox(height: 16),
          interactionsAsync.when(
            data: (analysis) => _buildInteractionsContent(analysis, theme),
            loading: () => _buildLoadingState(theme),
            error: (error, stackTrace) => _buildErrorState(error, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionsHeader(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.warning_amber,
          color: Colors.orange,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          'Drug Interactions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () => _checkInteractions(),
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Refresh'),
          style: TextButton.styleFrom(
            foregroundColor: CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildInteractionsContent(InteractionAnalysis analysis, ThemeData theme) {
    if (analysis.interactions.isEmpty) {
      return _buildNoInteractionsState(theme);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInteractionsSummary(analysis, theme),
        const SizedBox(height: 24),
        _buildInteractionsList(analysis.interactions, theme),
      ],
    );
  }

  Widget _buildInteractionsSummary(InteractionAnalysis analysis, ThemeData theme) {
    final majorCount = analysis.interactions.where((i) => i.severity == InteractionSeverity.major).length;
    final moderateCount = analysis.interactions.where((i) => i.severity == InteractionSeverity.moderate).length;
    final minorCount = analysis.interactions.where((i) => i.severity == InteractionSeverity.minor).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interaction Summary',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSeverityCard(
                  'Major',
                  majorCount,
                  CareCircleDesignTokens.criticalAlert,
                  theme,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSeverityCard(
                  'Moderate',
                  moderateCount,
                  Colors.orange,
                  theme,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSeverityCard(
                  'Minor',
                  minorCount,
                  Colors.amber,
                  theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityCard(String label, int count, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionsList(List<InteractionAlert> interactions, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interaction Details',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...interactions.map((interaction) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildInteractionCard(interaction, theme),
        )),
      ],
    );
  }

  Widget _buildInteractionCard(InteractionAlert interaction, ThemeData theme) {
    final severityColor = _getSeverityColor(interaction.severity);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${interaction.primaryMedication}${interaction.secondaryMedication != null ? ' + ${interaction.secondaryMedication}' : ''}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildSeverityChip(interaction.severity, severityColor, theme),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              interaction.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            if (interaction.clinicalEffect.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildEffectsList([interaction.clinicalEffect], theme),
            ],
            if (interaction.recommendations.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildRecommendation(interaction.recommendations.first, theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityChip(InteractionSeverity severity, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        _getSeverityText(severity),
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEffectsList(List<String> effects, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clinical Effects:',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 4),
        ...effects.map((effect) => Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Expanded(
                child: Text(
                  effect,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildRecommendation(String recommendation, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: CareCircleDesignTokens.primaryMedicalBlue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommendation:',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CareCircleDesignTokens.primaryMedicalBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recommendation,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoInteractionsState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: CareCircleDesignTokens.healthGreen,
            ),
            const SizedBox(height: 16),
            Text(
              'No Interactions Found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: CareCircleDesignTokens.healthGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This medication has no known interactions with your other medications.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Checking interactions...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: CareCircleDesignTokens.criticalAlert,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to Check Interactions',
              style: theme.textTheme.titleMedium?.copyWith(
                color: CareCircleDesignTokens.criticalAlert,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again later',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _checkInteractions(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(InteractionSeverity severity) {
    switch (severity) {
      case InteractionSeverity.contraindicated:
        return Colors.black;
      case InteractionSeverity.major:
        return CareCircleDesignTokens.criticalAlert;
      case InteractionSeverity.moderate:
        return Colors.orange;
      case InteractionSeverity.minor:
        return Colors.amber;
    }
  }

  String _getSeverityText(InteractionSeverity severity) {
    switch (severity) {
      case InteractionSeverity.contraindicated:
        return 'Contraindicated';
      case InteractionSeverity.major:
        return 'Major';
      case InteractionSeverity.moderate:
        return 'Moderate';
      case InteractionSeverity.minor:
        return 'Minor';
    }
  }

  void _checkInteractions() {
    _logger.info('Manual interaction check requested', {
      'medicationId': medicationId,
      'timestamp': DateTime.now().toIso8601String(),
    });
    // TODO: Implement manual interaction check
  }
}
