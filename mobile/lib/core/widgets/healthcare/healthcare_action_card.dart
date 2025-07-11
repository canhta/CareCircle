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
      child: Card(
        elevation: _getCardElevation(),
        color: _getCardColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.md),
          side: _getCardBorder(),
        ),
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.md),
          child: Container(
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(CareCircleSpacingTokens.sm),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
          ),
          child: Stack(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              if (urgencyLevel != UrgencyLevel.none)
                _buildUrgencyIndicator(),
            ],
          ),
        ),
        const Spacer(),
        if (badge != null)
          _buildBadge(),
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
        Icon(
          CareCircleIcons.sync,
          color: _getSubtitleColor(context),
          size: 12,
        ),
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
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 20,
      ),
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
  double _getCardElevation() {
    if (!isEnabled) return 1;
    
    switch (urgencyLevel) {
      case UrgencyLevel.critical:
        return 8;
      case UrgencyLevel.high:
        return 6;
      case UrgencyLevel.medium:
        return 4;
      default:
        return 2;
    }
  }

  Color _getCardColor(BuildContext context) {
    if (!isEnabled) {
      return CareCircleColorTokens.lightColorScheme.surfaceContainerHighest;
    }
    
    if (urgencyLevel == UrgencyLevel.critical) {
      return CareCircleColorTokens.criticalAlert.withValues(alpha: 0.05);
    }
    
    return CareCircleColorTokens.lightColorScheme.surface;
  }

  BorderSide _getCardBorder() {
    if (urgencyLevel == UrgencyLevel.critical) {
      return BorderSide(
        color: CareCircleColorTokens.criticalAlert.withValues(alpha: 0.3),
        width: 1,
      );
    }
    
    return BorderSide.none;
  }

  Color _getTextColor(BuildContext context) {
    if (!isEnabled) {
      return CareCircleColorTokens.lightColorScheme.onSurfaceVariant.withValues(alpha: 0.5);
    }
    
    return CareCircleColorTokens.lightColorScheme.onSurface;
  }

  Color _getSubtitleColor(BuildContext context) {
    if (!isEnabled) {
      return CareCircleColorTokens.lightColorScheme.onSurfaceVariant.withValues(alpha: 0.3);
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
}
