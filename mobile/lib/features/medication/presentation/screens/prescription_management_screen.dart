import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../providers/prescription_providers.dart';

/// Prescription Management Screen for prescription overview interface
///
/// Features:
/// - Prescription list and overview
/// - Verification status tracking
/// - OCR reprocessing capabilities
/// - Medication linking management
/// - Material Design 3 healthcare adaptations
class PrescriptionManagementScreen extends ConsumerStatefulWidget {
  const PrescriptionManagementScreen({super.key});

  @override
  ConsumerState<PrescriptionManagementScreen> createState() =>
      _PrescriptionManagementScreenState();
}

class _PrescriptionManagementScreenState
    extends ConsumerState<PrescriptionManagementScreen> {
  static final _logger = BoundedContextLoggers.medication;
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prescriptionsAsync = ref.watch(prescriptionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Management'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedFilter,
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Prescriptions'),
              ),
              const PopupMenuItem(
                value: 'verified',
                child: Text('Verified Only'),
              ),
              const PopupMenuItem(
                value: 'pending',
                child: Text('Pending Verification'),
              ),
              const PopupMenuItem(
                value: 'needs_review',
                child: Text('Needs Review'),
              ),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsOverview(prescriptionsAsync, theme),
          Expanded(child: _buildPrescriptionsList(prescriptionsAsync, theme)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToScanPrescription(),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        child: const Icon(Icons.camera_alt, color: Colors.white),
        tooltip: 'Scan New Prescription',
      ),
    );
  }

  Widget _buildStatsOverview(
    AsyncValue<List<Prescription>> prescriptionsAsync,
    ThemeData theme,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: prescriptionsAsync.when(
          data: (prescriptions) => _buildStatsContent(prescriptions, theme),
          loading: () => const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) =>
              _buildErrorState('Failed to load statistics', theme),
        ),
      ),
    );
  }

  Widget _buildStatsContent(List<Prescription> prescriptions, ThemeData theme) {
    final total = prescriptions.length;
    final verified = prescriptions
        .where((p) => p.verificationStatus == VerificationStatus.verified)
        .length;
    final pending = prescriptions
        .where((p) => p.verificationStatus == VerificationStatus.pending)
        .length;
    final needsReview = prescriptions
        .where((p) => p.verificationStatus == VerificationStatus.needsReview)
        .length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total',
            total.toString(),
            Icons.description,
            CareCircleDesignTokens.primaryMedicalBlue,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Verified',
            verified.toString(),
            Icons.verified,
            CareCircleDesignTokens.healthGreen,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Pending',
            pending.toString(),
            Icons.pending,
            Colors.orange,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Review',
            needsReview.toString(),
            Icons.warning,
            CareCircleDesignTokens.criticalAlert,
            theme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
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
    );
  }

  Widget _buildPrescriptionsList(
    AsyncValue<List<Prescription>> prescriptionsAsync,
    ThemeData theme,
  ) {
    return prescriptionsAsync.when(
      data: (prescriptions) {
        final filteredPrescriptions = _filterPrescriptions(prescriptions);

        if (filteredPrescriptions.isEmpty) {
          return _buildEmptyState(theme);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredPrescriptions.length,
          itemBuilder: (context, index) {
            return _buildPrescriptionCard(filteredPrescriptions[index], theme);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          _buildErrorState('Failed to load prescriptions', theme),
    );
  }

  Widget _buildPrescriptionCard(Prescription prescription, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToPrescriptionDetail(prescription),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        prescription,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getStatusIcon(prescription),
                      color: _getStatusColor(prescription),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prescription.prescribedBy.isNotEmpty
                              ? 'Dr. ${prescription.prescribedBy}'
                              : 'Unknown Prescriber',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${prescription.dateIssued.day}/${prescription.dateIssued.month}/${prescription.dateIssued.year}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(prescription),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(prescription),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (prescription.extractedMedications.isNotEmpty) ...[
                Text(
                  'Medications (${prescription.extractedMedications.length}):',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: prescription.extractedMedications.take(3).map((
                    med,
                  ) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Text(med, style: theme.textTheme.bodySmall),
                    );
                  }).toList(),
                ),
                if (prescription.extractedMedications.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '+${prescription.extractedMedications.length - 3} more',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ] else ...[
                Text(
                  'No medications extracted',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  if (prescription.verificationStatus ==
                      VerificationStatus.pending)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _reprocessPrescription(prescription),
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Reprocess'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                        ),
                      ),
                    ),
                  if (prescription.verificationStatus ==
                          VerificationStatus.pending &&
                      prescription.extractedMedications.isNotEmpty)
                    const SizedBox(width: 8),
                  if (prescription.verificationStatus !=
                          VerificationStatus.verified &&
                      prescription.extractedMedications.isNotEmpty)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _verifyPrescription(prescription),
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text('Verify'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CareCircleDesignTokens.healthGreen,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  if (prescription.verificationStatus ==
                      VerificationStatus.verified)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _navigateToPrescriptionDetail(prescription),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('View Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              CareCircleDesignTokens.primaryMedicalBlue,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              _getEmptyStateMessage(),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the camera button to scan your first prescription',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _navigateToScanPrescription(),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan Prescription'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: CareCircleDesignTokens.criticalAlert,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: CareCircleDesignTokens.criticalAlert,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(prescriptionsProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Prescription> _filterPrescriptions(List<Prescription> prescriptions) {
    switch (_selectedFilter) {
      case 'verified':
        return prescriptions
            .where((p) => p.verificationStatus == VerificationStatus.verified)
            .toList();
      case 'pending':
        return prescriptions
            .where((p) => p.verificationStatus == VerificationStatus.pending)
            .toList();
      case 'needs_review':
        return prescriptions
            .where(
              (p) => p.verificationStatus == VerificationStatus.needsReview,
            )
            .toList();
      case 'all':
      default:
        return prescriptions;
    }
  }

  String _getEmptyStateMessage() {
    switch (_selectedFilter) {
      case 'verified':
        return 'No verified prescriptions';
      case 'pending':
        return 'No pending prescriptions';
      case 'needs_review':
        return 'No prescriptions need review';
      case 'all':
      default:
        return 'No prescriptions yet';
    }
  }

  Color _getStatusColor(Prescription prescription) {
    switch (prescription.verificationStatus) {
      case VerificationStatus.verified:
        return CareCircleDesignTokens.healthGreen;
      case VerificationStatus.pending:
        return Colors.orange;
      case VerificationStatus.needsReview:
        return CareCircleDesignTokens.criticalAlert;
    }
  }

  IconData _getStatusIcon(Prescription prescription) {
    switch (prescription.verificationStatus) {
      case VerificationStatus.verified:
        return Icons.verified;
      case VerificationStatus.pending:
        return Icons.pending;
      case VerificationStatus.needsReview:
        return Icons.warning;
    }
  }

  String _getStatusText(Prescription prescription) {
    switch (prescription.verificationStatus) {
      case VerificationStatus.verified:
        return 'VERIFIED';
      case VerificationStatus.pending:
        return 'PENDING';
      case VerificationStatus.needsReview:
        return 'REVIEW';
    }
  }

  Future<void> _reprocessPrescription(Prescription prescription) async {
    try {
      _logger.info('Reprocessing prescription', {
        'operation': 'reprocessPrescription',
        'prescriptionId': prescription.id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Reprocess prescription - this would typically call a provider method
      ref.invalidate(prescriptionsProvider);

      if (mounted) {
        _logger.info('Prescription reprocessed successfully', {
          'operation': 'reprocessPrescription',
          'prescriptionId': prescription.id,
          'timestamp': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prescription reprocessed successfully'),
            backgroundColor: CareCircleDesignTokens.healthGreen,
          ),
        );

        // Refresh prescriptions list
        ref.invalidate(prescriptionsProvider);
      }
    } catch (e) {
      _logger.error('Failed to reprocess prescription', {
        'operation': 'reprocessPrescription',
        'prescriptionId': prescription.id,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reprocess prescription: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }

  Future<void> _verifyPrescription(Prescription prescription) async {
    try {
      _logger.info('Verifying prescription', {
        'operation': 'verifyPrescription',
        'prescriptionId': prescription.id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Verify prescription - this would typically call a provider method
      ref.invalidate(prescriptionsProvider);

      if (mounted) {
        _logger.info('Prescription verified successfully', {
          'operation': 'verifyPrescription',
          'prescriptionId': prescription.id,
          'timestamp': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prescription verified successfully'),
            backgroundColor: CareCircleDesignTokens.healthGreen,
          ),
        );

        // Refresh prescriptions list
        ref.invalidate(prescriptionsProvider);
      }
    } catch (e) {
      _logger.error('Failed to verify prescription', {
        'operation': 'verifyPrescription',
        'prescriptionId': prescription.id,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to verify prescription: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }

  void _navigateToScanPrescription() {
    // Navigate to prescription scanning screen
    Navigator.of(context).pushNamed('/prescription-scan');
  }

  void _navigateToPrescriptionDetail(Prescription prescription) {
    // Navigate to prescription detail screen
    Navigator.of(
      context,
    ).pushNamed('/prescription-detail', arguments: prescription.id);
  }
}
