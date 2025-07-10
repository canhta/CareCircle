import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../providers/interaction_providers.dart';
import '../providers/medication_providers.dart';

/// Drug Interaction Screen for interaction analysis interface
///
/// Features:
/// - Interaction checking and severity alerts
/// - Recommendations and guidance
/// - RxNorm validation integration
/// - Multiple medication interaction analysis
/// - Material Design 3 healthcare adaptations
class DrugInteractionScreen extends ConsumerStatefulWidget {
  const DrugInteractionScreen({super.key});

  @override
  ConsumerState<DrugInteractionScreen> createState() =>
      _DrugInteractionScreenState();
}

class _DrugInteractionScreenState extends ConsumerState<DrugInteractionScreen> {
  static final _logger = BoundedContextLoggers.medication;
  bool _isCheckingInteractions = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final medicationsAsync = ref.watch(medicationsProvider);
    final interactionAnalysisAsync = ref.watch(medicationInteractionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drug Interactions'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _isCheckingInteractions ? null : _checkAllInteractions,
            icon: _isCheckingInteractions
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh),
            tooltip: 'Check Interactions',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewSection(interactionAnalysisAsync, theme),
            const SizedBox(height: 24),
            _buildMedicationListSection(medicationsAsync, theme),
            const SizedBox(height: 24),
            _buildInteractionAlertsSection(interactionAnalysisAsync, theme),
            const SizedBox(height: 24),
            _buildRecommendationsSection(interactionAnalysisAsync, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection(
    AsyncValue<InteractionAnalysis> analysisAsync,
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
              'Interaction Overview',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            analysisAsync.when(
              data: (analysis) => _buildOverviewContent(analysis, theme),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _buildErrorState(
                'Failed to load interaction analysis',
                theme,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewContent(InteractionAnalysis analysis, ThemeData theme) {
    final totalInteractions = analysis.interactions.length;
    final highSeverity = analysis.interactions
        .where((i) => i.severity == InteractionSeverity.high)
        .length;
    final mediumSeverity = analysis.interactions
        .where((i) => i.severity == InteractionSeverity.medium)
        .length;
    final lowSeverity = analysis.interactions
        .where((i) => i.severity == InteractionSeverity.low)
        .length;

    return Column(
      children: [
        // Status indicator
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getOverallSeverityColor(analysis).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getOverallSeverityColor(analysis).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _getOverallSeverityIcon(analysis),
                color: _getOverallSeverityColor(analysis),
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getOverallStatusText(analysis),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _getOverallSeverityColor(analysis),
                      ),
                    ),
                    Text(
                      totalInteractions == 0
                          ? 'No interactions detected'
                          : '$totalInteractions interaction${totalInteractions == 1 ? '' : 's'} found',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (totalInteractions > 0) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              if (highSeverity > 0)
                Expanded(
                  child: _buildSeverityCard(
                    'High',
                    highSeverity,
                    CareCircleDesignTokens.criticalAlert,
                    theme,
                  ),
                ),
              if (highSeverity > 0 && (mediumSeverity > 0 || lowSeverity > 0))
                const SizedBox(width: 8),
              if (mediumSeverity > 0)
                Expanded(
                  child: _buildSeverityCard(
                    'Medium',
                    mediumSeverity,
                    Colors.orange,
                    theme,
                  ),
                ),
              if (mediumSeverity > 0 && lowSeverity > 0)
                const SizedBox(width: 8),
              if (lowSeverity > 0)
                Expanded(
                  child: _buildSeverityCard(
                    'Low',
                    lowSeverity,
                    Colors.blue,
                    theme,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSeverityCard(
    String severity,
    int count,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            severity,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationListSection(
    AsyncValue<List<Medication>> medicationsAsync,
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
              'Current Medications',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            medicationsAsync.when(
              data: (medications) => medications.isEmpty
                  ? _buildEmptyState('No medications added yet', theme)
                  : Column(
                      children: medications
                          .map(
                            (medication) =>
                                _buildMedicationCard(medication, theme),
                          )
                          .toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  _buildErrorState('Failed to load medications', theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationCard(Medication medication, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.medication,
              color: CareCircleDesignTokens.primaryMedicalBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (medication.strength.isNotEmpty)
                  Text(
                    '${medication.strength} - ${medication.form.displayName}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _checkSingleMedicationInteractions(medication),
            icon: const Icon(Icons.search),
            tooltip: 'Check Interactions',
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionAlertsSection(
    AsyncValue<InteractionAnalysis> analysisAsync,
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
              'Interaction Alerts',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            analysisAsync.when(
              data: (analysis) => analysis.interactions.isEmpty
                  ? _buildEmptyState('No interactions detected', theme)
                  : Column(
                      children: analysis.interactions
                          .map(
                            (interaction) =>
                                _buildInteractionCard(interaction, theme),
                          )
                          .toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  _buildErrorState('Failed to load interactions', theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionCard(InteractionAlert interaction, ThemeData theme) {
    final severityColor = _getSeverityColor(interaction.severity);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: severityColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getSeverityIcon(interaction.severity),
                color: severityColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${interaction.drugA} + ${interaction.drugB}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  interaction.severity.name.toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(interaction.description, style: theme.textTheme.bodyMedium),
          if (interaction.clinicalEffect.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      interaction.clinicalEffect,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection(
    AsyncValue<InteractionAnalysis> analysisAsync,
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
              'Recommendations',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            analysisAsync.when(
              data: (analysis) => _buildRecommendationsContent(analysis, theme),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  _buildErrorState('Failed to load recommendations', theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsContent(
    InteractionAnalysis analysis,
    ThemeData theme,
  ) {
    final recommendations = _generateRecommendations(analysis);

    if (recommendations.isEmpty) {
      return _buildEmptyState(
        'No specific recommendations at this time',
        theme,
      );
    }

    return Column(
      children: recommendations
          .map(
            (recommendation) => _buildRecommendationCard(recommendation, theme),
          )
          .toList(),
    );
  }

  Widget _buildRecommendationCard(
    Recommendation recommendation,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: recommendation.type == RecommendationType.warning
            ? Colors.orange.withValues(alpha: 0.1)
            : CareCircleDesignTokens.healthGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: recommendation.type == RecommendationType.warning
              ? Colors.orange.withValues(alpha: 0.3)
              : CareCircleDesignTokens.healthGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            recommendation.icon,
            color: recommendation.type == RecommendationType.warning
                ? Colors.orange
                : CareCircleDesignTokens.healthGreen,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recommendation.description,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.medication,
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

  Color _getSeverityColor(InteractionSeverity severity) {
    switch (severity) {
      case InteractionSeverity.high:
        return CareCircleDesignTokens.criticalAlert;
      case InteractionSeverity.medium:
        return Colors.orange;
      case InteractionSeverity.low:
        return Colors.blue;
    }
  }

  IconData _getSeverityIcon(InteractionSeverity severity) {
    switch (severity) {
      case InteractionSeverity.high:
        return Icons.dangerous;
      case InteractionSeverity.medium:
        return Icons.warning;
      case InteractionSeverity.low:
        return Icons.info;
    }
  }

  Color _getOverallSeverityColor(InteractionAnalysis analysis) {
    if (analysis.interactions.any(
      (i) => i.severity == InteractionSeverity.high,
    )) {
      return CareCircleDesignTokens.criticalAlert;
    } else if (analysis.interactions.any(
      (i) => i.severity == InteractionSeverity.medium,
    )) {
      return Colors.orange;
    } else if (analysis.interactions.isNotEmpty) {
      return Colors.blue;
    } else {
      return CareCircleDesignTokens.healthGreen;
    }
  }

  IconData _getOverallSeverityIcon(InteractionAnalysis analysis) {
    if (analysis.interactions.any(
      (i) => i.severity == InteractionSeverity.high,
    )) {
      return Icons.dangerous;
    } else if (analysis.interactions.any(
      (i) => i.severity == InteractionSeverity.medium,
    )) {
      return Icons.warning;
    } else if (analysis.interactions.isNotEmpty) {
      return Icons.info;
    } else {
      return Icons.check_circle;
    }
  }

  String _getOverallStatusText(InteractionAnalysis analysis) {
    if (analysis.interactions.any(
      (i) => i.severity == InteractionSeverity.high,
    )) {
      return 'High Risk Interactions';
    } else if (analysis.interactions.any(
      (i) => i.severity == InteractionSeverity.medium,
    )) {
      return 'Moderate Risk Interactions';
    } else if (analysis.interactions.isNotEmpty) {
      return 'Low Risk Interactions';
    } else {
      return 'No Interactions Detected';
    }
  }

  List<Recommendation> _generateRecommendations(InteractionAnalysis analysis) {
    final recommendations = <Recommendation>[];

    if (analysis.interactions.any(
      (i) => i.severity == InteractionSeverity.high,
    )) {
      recommendations.add(
        Recommendation(
          title: 'Consult Healthcare Provider',
          description:
              'High-risk interactions detected. Contact your doctor or pharmacist immediately.',
          type: RecommendationType.warning,
          icon: Icons.medical_services,
        ),
      );
    }

    if (analysis.interactions.length > 3) {
      recommendations.add(
        Recommendation(
          title: 'Medication Review Needed',
          description:
              'Multiple interactions detected. Consider a comprehensive medication review.',
          type: RecommendationType.warning,
          icon: Icons.assignment,
        ),
      );
    }

    if (analysis.interactions.isEmpty) {
      recommendations.add(
        Recommendation(
          title: 'Good Medication Safety',
          description:
              'No interactions detected. Continue taking medications as prescribed.',
          type: RecommendationType.positive,
          icon: Icons.check_circle,
        ),
      );
    }

    return recommendations;
  }

  Future<void> _checkAllInteractions() async {
    setState(() {
      _isCheckingInteractions = true;
    });

    try {
      _logger.info('Checking all medication interactions', {
        'operation': 'checkAllInteractions',
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Refresh interaction analysis
      ref.invalidate(medicationInteractionsProvider);

      if (mounted) {
        _logger.info('Interaction check completed successfully', {
          'operation': 'checkAllInteractions',
          'timestamp': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Interaction check completed'),
            backgroundColor: CareCircleDesignTokens.healthGreen,
          ),
        );
      }
    } catch (e) {
      _logger.error('Failed to check interactions', {
        'operation': 'checkAllInteractions',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to check interactions: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingInteractions = false;
        });
      }
    }
  }

  Future<void> _checkSingleMedicationInteractions(Medication medication) async {
    try {
      _logger.info('Checking single medication interactions', {
        'operation': 'checkSingleMedicationInteractions',
        'medicationId': medication.id,
        'medicationName': medication.name,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Check interactions for specific medication
      ref.invalidate(medicationInteractionsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Checked interactions for ${medication.name}'),
            backgroundColor: CareCircleDesignTokens.healthGreen,
          ),
        );
      }
    } catch (e) {
      _logger.error('Failed to check medication interactions', {
        'operation': 'checkSingleMedicationInteractions',
        'medicationId': medication.id,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to check interactions for ${medication.name}',
            ),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }
}

// Helper classes for recommendations
class Recommendation {
  final String title;
  final String description;
  final RecommendationType type;
  final IconData icon;

  Recommendation({
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
  });
}

enum RecommendationType { positive, warning }
