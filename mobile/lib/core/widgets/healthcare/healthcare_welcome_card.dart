import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';
import '../../design/care_circle_icons.dart';

/// Health status levels for the welcome card
enum HealthStatus { excellent, good, fair, needsAttention, unknown }

/// Healthcare-optimized welcome card component
///
/// Displays personalized welcome message with health status overview,
/// last health update, and quick access to health check functionality.
class HealthcareWelcomeCard extends StatelessWidget {
  const HealthcareWelcomeCard({
    super.key,
    required this.userName,
    this.lastHealthUpdate,
    this.healthStatus = HealthStatus.unknown,
    this.onHealthCheckTap,
    this.semanticLabel,
    this.semanticHint,
    this.customMessage,
    this.showHealthStatus = true,
    this.showQuickActions = true,
  });

  final String userName;
  final DateTime? lastHealthUpdate;
  final HealthStatus healthStatus;
  final VoidCallback? onHealthCheckTap;
  final String? semanticLabel;
  final String? semanticHint;
  final String? customMessage;
  final bool showHealthStatus;
  final bool showQuickActions;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Welcome section',
      hint:
          semanticHint ??
          'Your current health overview and quick health check access',
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(CareCircleSpacingTokens.lg),
        decoration: BoxDecoration(
          gradient: _getHealthStatusGradient(),
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.md),
          boxShadow: [
            BoxShadow(
              color: CareCircleColorTokens.lightColorScheme.shadow.withValues(
                alpha: 0.1,
              ),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(context),
            if (showHealthStatus) ...[
              SizedBox(height: CareCircleSpacingTokens.md),
              _buildHealthStatusSection(context),
            ],
            if (lastHealthUpdate != null) ...[
              SizedBox(height: CareCircleSpacingTokens.sm),
              _buildLastUpdateSection(context),
            ],
            if (showQuickActions) ...[
              SizedBox(height: CareCircleSpacingTokens.md),
              _buildQuickActionsSection(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    final timeOfDay = _getTimeOfDayGreeting();
    final message = customMessage ?? _getHealthStatusMessage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$timeOfDay, $userName!',
          style: CareCircleTypographyTokens.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: CareCircleSpacingTokens.xs),
        Text(
          message,
          style: CareCircleTypographyTokens.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthStatusSection(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(CareCircleSpacingTokens.sm),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
          ),
          child: Icon(_getHealthStatusIcon(), color: Colors.white, size: 24),
        ),
        SizedBox(width: CareCircleSpacingTokens.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Health Status',
                style: CareCircleTypographyTokens.medicalLabel.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              Text(
                _getHealthStatusText(),
                style: CareCircleTypographyTokens.healthMetricTitle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdateSection(BuildContext context) {
    final timeAgo = _formatTimeAgo(lastHealthUpdate!);

    return Row(
      children: [
        Icon(
          CareCircleIcons.sync,
          color: Colors.white.withValues(alpha: 0.7),
          size: 16,
        ),
        SizedBox(width: CareCircleSpacingTokens.xs),
        Text(
          'Last updated $timeAgo',
          style: CareCircleTypographyTokens.medicalTimestamp.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Row(
      children: [
        if (onHealthCheckTap != null)
          Expanded(
            child: _buildQuickActionButton(
              context,
              icon: CareCircleIcons.healthMetrics,
              label: 'Quick Health Check',
              onTap: onHealthCheckTap!,
            ),
          ),
        SizedBox(width: CareCircleSpacingTokens.sm),
        Expanded(
          child: _buildQuickActionButton(
            context,
            icon: CareCircleIcons.chart,
            label: 'View Trends',
            onTap: () {
              // Navigate to health trends
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: label,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: CareCircleSpacingTokens.md,
            vertical: CareCircleSpacingTokens.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              SizedBox(width: CareCircleSpacingTokens.xs),
              Flexible(
                child: Text(
                  label,
                  style: CareCircleTypographyTokens.medicalLabel.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods
  LinearGradient _getHealthStatusGradient() {
    switch (healthStatus) {
      case HealthStatus.excellent:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CareCircleColorTokens.healthGreen,
            CareCircleColorTokens.normalRange,
          ],
        );
      case HealthStatus.good:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CareCircleColorTokens.primaryMedicalBlue,
            CareCircleColorTokens.healthGreen,
          ],
        );
      case HealthStatus.fair:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CareCircleColorTokens.warningAmber,
            CareCircleColorTokens.primaryMedicalBlue,
          ],
        );
      case HealthStatus.needsAttention:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CareCircleColorTokens.criticalAlert,
            CareCircleColorTokens.warningAmber,
          ],
        );
      case HealthStatus.unknown:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CareCircleColorTokens.primaryMedicalBlue,
            CareCircleColorTokens.primaryMedicalBlue.withValues(alpha: 0.8),
          ],
        );
    }
  }

  IconData _getHealthStatusIcon() {
    switch (healthStatus) {
      case HealthStatus.excellent:
        return CareCircleIcons.success;
      case HealthStatus.good:
        return CareCircleIcons.normal;
      case HealthStatus.fair:
        return CareCircleIcons.caution;
      case HealthStatus.needsAttention:
        return CareCircleIcons.warning;
      case HealthStatus.unknown:
        return CareCircleIcons.unknown;
    }
  }

  String _getHealthStatusText() {
    switch (healthStatus) {
      case HealthStatus.excellent:
        return 'Excellent';
      case HealthStatus.good:
        return 'Good';
      case HealthStatus.fair:
        return 'Fair';
      case HealthStatus.needsAttention:
        return 'Needs Attention';
      case HealthStatus.unknown:
        return 'Unknown';
    }
  }

  String _getHealthStatusMessage() {
    switch (healthStatus) {
      case HealthStatus.excellent:
        return 'Your health metrics are looking great!';
      case HealthStatus.good:
        return 'Your health is on track. Keep it up!';
      case HealthStatus.fair:
        return 'Some metrics could use attention.';
      case HealthStatus.needsAttention:
        return 'Please review your health metrics.';
      case HealthStatus.unknown:
        return 'How are you feeling today?';
    }
  }

  String _getTimeOfDayGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
