import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';
import '../../design/care_circle_icons.dart';
import '../navigation/care_circle_tab_bar.dart';

/// Healthcare action card component
///
/// Displays healthcare actions with urgency indicators, badges, and accessibility support.
/// Optimized for quick access to healthcare functionality from the home screen.
class HealthcareActionCard extends StatelessWidget {
  const HealthcareActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.semanticLabel,
    this.semanticHint,
    this.urgencyLevel = UrgencyLevel.none,
    this.badge,
    this.lastUpdated,
    this.isEnabled = true,
    this.showProgress = false,
    this.progressValue,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final String? semanticLabel;
  final String? semanticHint;
  final UrgencyLevel urgencyLevel;
  final String? badge;
  final DateTime? lastUpdated;
  final bool isEnabled;
  final bool showProgress;
  final double? progressValue;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? '$title: $subtitle',
      hint: semanticHint ?? 'Tap to access $title',
      button: true,
      enabled: isEnabled,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          decoration: _getModernCardDecoration(context),
          padding: EdgeInsets.all(CareCircleSpacingTokens.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: CareCircleSpacingTokens.sm),
              _buildContent(context),
              if (showProgress && progressValue != null) ...[
                SizedBox(height: CareCircleSpacingTokens.sm),
                _buildProgressIndicator(context),
              ],
              if (lastUpdated != null) ...[
                SizedBox(height: CareCircleSpacingTokens.xs),
                _buildLastUpdated(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(CareCircleSpacingTokens.sm),
          decoration: _getIconContainerDecoration(),
          child: Stack(
            children: [
              Icon(icon, color: _getIconColor(), size: 24),
              if (urgencyLevel != UrgencyLevel.none) _buildUrgencyIndicator(),
            ],
          ),
        ),
        const Spacer(),
        if (badge != null) _buildBadge(),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: CareCircleTypographyTokens.healthMetricTitle.copyWith(
            color: _getTextColor(context),
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: CareCircleSpacingTokens.xs),
        Text(
          subtitle,
          style: CareCircleTypographyTokens.medicalNote.copyWith(
            color: _getSubtitleColor(context),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: CareCircleTypographyTokens.medicalLabel.copyWith(
                color: _getSubtitleColor(context),
              ),
            ),
            Text(
              '${(progressValue! * 100).toInt()}%',
              style: CareCircleTypographyTokens.medicalLabel.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: CareCircleSpacingTokens.xs),
        LinearProgressIndicator(
          value: progressValue,
          backgroundColor: color.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 4,
        ),
      ],
    );
  }

  Widget _buildLastUpdated(BuildContext context) {
    final timeAgo = _formatTimeAgo(lastUpdated!);

    return Row(
      children: [
        Icon(CareCircleIcons.sync, color: _getSubtitleColor(context), size: 12),
        SizedBox(width: CareCircleSpacingTokens.xs / 2),
        Text(
          timeAgo,
          style: CareCircleTypographyTokens.medicalTimestamp.copyWith(
            color: _getSubtitleColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildUrgencyIndicator() {
    final urgencyColor = _getUrgencyColor();

    return Positioned(
      top: -2,
      right: -2,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: urgencyColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      padding: EdgeInsets.symmetric(
        horizontal: CareCircleSpacingTokens.xs,
        vertical: CareCircleSpacingTokens.xs / 2,
      ),
      decoration: BoxDecoration(
        color: CareCircleColorTokens.criticalAlert,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        badge!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Helper methods

  Color _getTextColor(BuildContext context) {
    if (!isEnabled) {
      return CareCircleColorTokens.lightColorScheme.onSurfaceVariant.withValues(
        alpha: 0.5,
      );
    }

    return CareCircleColorTokens.lightColorScheme.onSurface;
  }

  Color _getSubtitleColor(BuildContext context) {
    if (!isEnabled) {
      return CareCircleColorTokens.lightColorScheme.onSurfaceVariant.withValues(
        alpha: 0.3,
      );
    }

    return CareCircleColorTokens.lightColorScheme.onSurfaceVariant;
  }

  Color _getUrgencyColor() {
    switch (urgencyLevel) {
      case UrgencyLevel.none:
        return Colors.transparent;
      case UrgencyLevel.low:
        return CareCircleColorTokens.normalRange;
      case UrgencyLevel.medium:
        return CareCircleColorTokens.warningAmber;
      case UrgencyLevel.high:
        return CareCircleColorTokens.criticalAlert;
      case UrgencyLevel.critical:
        return CareCircleColorTokens.emergencyRed;
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

  /// Get modern icon container decoration
  BoxDecoration _getIconContainerDecoration() {
    // AI-related icons get special gradient treatment
    if (title.toLowerCase().contains('ai') ||
        title.toLowerCase().contains('assistant')) {
      return BoxDecoration(
        gradient: CareCircleGradientTokens.createHealthcareGradient(
          primaryColor: const Color(0xFF7C4DFF),
          lightenFactor: 0.3,
          darkenFactor: 0.1,
        ),
        borderRadius: CareCircleModernEffectsTokens.radiusSM,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C4DFF).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      );
    }

    // High urgency items get glassmorphism
    if (urgencyLevel == UrgencyLevel.critical ||
        urgencyLevel == UrgencyLevel.high) {
      return CareCircleGlassmorphismTokens.getUrgencyGlass(
        urgencyLevel.name,
        borderRadius: CareCircleModernEffectsTokens.radiusSM,
      );
    }

    // Default modern gradient background
    return BoxDecoration(
      gradient: CareCircleGradientTokens.createHealthcareGradient(
        primaryColor: color,
        lightenFactor: 0.4,
        darkenFactor: 0.1,
      ),
      borderRadius: CareCircleModernEffectsTokens.radiusSM,
      boxShadow: CareCircleModernEffectsTokens.subtleShadow,
    );
  }

  /// Get icon color based on container decoration
  Color _getIconColor() {
    // AI icons use white for better contrast on gradient
    if (title.toLowerCase().contains('ai') ||
        title.toLowerCase().contains('assistant')) {
      return Colors.white;
    }

    // High urgency items use the original color
    if (urgencyLevel == UrgencyLevel.critical ||
        urgencyLevel == UrgencyLevel.high) {
      return color;
    }

    // Default uses white for better contrast on gradient
    return Colors.white;
  }

  /// Get modern card decoration with glassmorphism and gradients
  BoxDecoration _getModernCardDecoration(BuildContext context) {
    // Use glassmorphism for high urgency items
    if (urgencyLevel == UrgencyLevel.critical ||
        urgencyLevel == UrgencyLevel.high) {
      return CareCircleGlassmorphismTokens.getUrgencyGlass(
        urgencyLevel.name,
        borderRadius: CareCircleModernEffectsTokens.radiusMD,
      );
    }

    // Use gradient background for AI-related cards
    if (title.toLowerCase().contains('ai') ||
        title.toLowerCase().contains('assistant')) {
      return BoxDecoration(
        gradient: CareCircleGradientTokens.aiChat,
        borderRadius: CareCircleModernEffectsTokens.radiusMD,
        boxShadow: CareCircleModernEffectsTokens.aiShadow,
        border: Border.all(color: const Color(0x337C4DFF), width: 1.5),
      );
    }

    // Use subtle gradient for health-related cards
    if (title.toLowerCase().contains('health') ||
        title.toLowerCase().contains('vital')) {
      return BoxDecoration(
        gradient: CareCircleGradientTokens.healthMetrics,
        borderRadius: CareCircleModernEffectsTokens.radiusMD,
        boxShadow: CareCircleModernEffectsTokens.softShadow,
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.0),
      );
    }

    // Default modern card with subtle gradient
    return BoxDecoration(
      gradient: CareCircleGradientTokens.cardBackground,
      borderRadius: CareCircleModernEffectsTokens.radiusMD,
      boxShadow: CareCircleModernEffectsTokens.softShadow,
      border: Border.all(color: color.withValues(alpha: 0.2), width: 1.0),
    );
  }
}
