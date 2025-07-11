import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';

/// Healthcare-optimized tab for navigation
class CareCircleTab {
  const CareCircleTab({
    required this.icon,
    required this.label,
    this.semanticLabel,
    this.semanticHint,
    this.badge,
    this.urgencyIndicator,
    this.isEnabled = true,
  });

  final IconData icon;
  final String label;
  final String? semanticLabel;
  final String? semanticHint;
  final String? badge;
  final UrgencyLevel? urgencyIndicator;
  final bool isEnabled;
}

/// Urgency levels for healthcare navigation
enum UrgencyLevel { none, low, medium, high, critical }

/// Healthcare-optimized tab bar component
///
/// Provides accessible navigation with healthcare-specific features like
/// urgency indicators, badges, and medical context awareness.
class CareCircleTabBar extends StatelessWidget {
  const CareCircleTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.semanticLabel,
    this.enableModernEffects = true,
  });

  final List<CareCircleTab> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final String? semanticLabel;
  final bool enableModernEffects;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Healthcare navigation tabs',
      child: Container(
        decoration: enableModernEffects
            ? _getModernTabBarDecoration()
            : BoxDecoration(
                color: backgroundColor ??
                    CareCircleColorTokens.lightColorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: CareCircleColorTokens.lightColorScheme.shadow
                        .withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
        child: SafeArea(
          child: Container(
            height: 80,
            padding: EdgeInsets.symmetric(
              horizontal: CareCircleSpacingTokens.sm,
              vertical: CareCircleSpacingTokens.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final tab = entry.value;
                return _buildTabItem(context, tab, index);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// Get modern tab bar decoration with glassmorphism
  BoxDecoration _getModernTabBarDecoration() {
    return BoxDecoration(
      gradient: CareCircleGradientTokens.cardBackground,
      boxShadow: CareCircleModernEffectsTokens.softShadow,
      border: Border(
        top: BorderSide(
          color: CareCircleColorTokens.primaryMedicalBlue.withValues(alpha: 0.1),
          width: 1.0,
        ),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, CareCircleTab tab, int index) {
    final isSelected = index == currentIndex;
    final isEnabled = tab.isEnabled;

    return Semantics(
      label: tab.semanticLabel ?? tab.label,
      hint: tab.semanticHint ?? 'Tab ${index + 1} of ${tabs.length}',
      button: true,
      selected: isSelected,
      enabled: isEnabled,
      child: InkWell(
        onTap: isEnabled ? () => onTap(index) : null,
        borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
        child: Container(
          constraints: BoxConstraints(
            minWidth: CareCircleSpacingTokens.touchTargetMin,
            minHeight: CareCircleSpacingTokens.touchTargetMin,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: CareCircleSpacingTokens.xs,
            vertical: CareCircleSpacingTokens.xs,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTabIcon(context, tab, isSelected, isEnabled),
              SizedBox(height: CareCircleSpacingTokens.xs / 2),
              _buildTabLabel(context, tab, isSelected, isEnabled),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabIcon(
    BuildContext context,
    CareCircleTab tab,
    bool isSelected,
    bool isEnabled,
  ) {
    final iconColor = _getIconColor(context, isSelected, isEnabled);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(tab.icon, size: 24, color: iconColor),
        if (tab.urgencyIndicator != null &&
            tab.urgencyIndicator != UrgencyLevel.none)
          _buildUrgencyIndicator(tab.urgencyIndicator!),
        if (tab.badge != null) _buildBadge(tab.badge!),
      ],
    );
  }

  Widget _buildTabLabel(
    BuildContext context,
    CareCircleTab tab,
    bool isSelected,
    bool isEnabled,
  ) {
    final labelColor = _getLabelColor(context, isSelected, isEnabled);

    return Text(
      tab.label,
      style: CareCircleTypographyTokens.textTheme.labelSmall?.copyWith(
        color: labelColor,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildUrgencyIndicator(UrgencyLevel urgencyLevel) {
    final urgencyColor = _getUrgencyColor(urgencyLevel);

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

  Widget _buildBadge(String badgeText) {
    return Positioned(
      top: -6,
      right: -6,
      child: Container(
        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: CareCircleColorTokens.criticalAlert,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Text(
          badgeText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Color _getIconColor(BuildContext context, bool isSelected, bool isEnabled) {
    if (!isEnabled) {
      return CareCircleColorTokens.lightColorScheme.onSurfaceVariant.withValues(
        alpha: 0.5,
      );
    }

    if (isSelected) {
      return selectedItemColor ?? CareCircleColorTokens.primaryMedicalBlue;
    }

    return unselectedItemColor ??
        CareCircleColorTokens.lightColorScheme.onSurfaceVariant;
  }

  Color _getLabelColor(BuildContext context, bool isSelected, bool isEnabled) {
    if (!isEnabled) {
      return CareCircleColorTokens.lightColorScheme.onSurfaceVariant.withValues(
        alpha: 0.5,
      );
    }

    if (isSelected) {
      return selectedItemColor ?? CareCircleColorTokens.primaryMedicalBlue;
    }

    return unselectedItemColor ??
        CareCircleColorTokens.lightColorScheme.onSurfaceVariant;
  }

  Color _getUrgencyColor(UrgencyLevel urgencyLevel) {
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
}

/// Healthcare AI Assistant FAB component
///
/// Enhanced floating action button for AI assistant with healthcare context.
class HealthcareAIAssistantFAB extends StatelessWidget {
  const HealthcareAIAssistantFAB({
    super.key,
    required this.onPressed,
    this.semanticLabel,
    this.semanticHint,
    this.hasUrgentNotifications = false,
    this.lastInteraction,
    this.healthContext,
    this.emergencyMode = false,
  });

  final VoidCallback onPressed;
  final String? semanticLabel;
  final String? semanticHint;
  final bool hasUrgentNotifications;
  final DateTime? lastInteraction;
  final String? healthContext;
  final bool emergencyMode;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'AI Health Assistant',
      hint: semanticHint ?? 'Open AI health assistant for personalized healthcare guidance',
      button: true,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 56,
          height: 56,
          decoration: _getModernFABDecoration(),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  emergencyMode ? Icons.emergency : Icons.psychology,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              if (hasUrgentNotifications)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: CareCircleColorTokens.criticalAlert,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get modern FAB decoration with AI gradient
  BoxDecoration _getModernFABDecoration() {
    if (emergencyMode) {
      return BoxDecoration(
        gradient: CareCircleGradientTokens.criticalAlert,
        borderRadius: CareCircleModernEffectsTokens.radiusPill,
        boxShadow: CareCircleModernEffectsTokens.emergencyShadow,
      );
    }

    return BoxDecoration(
      gradient: CareCircleGradientTokens.aiAssistant,
      borderRadius: CareCircleModernEffectsTokens.radiusPill,
      boxShadow: hasUrgentNotifications
          ? CareCircleModernEffectsTokens.aiShadow
          : CareCircleModernEffectsTokens.mediumShadow,
    );
  }
}
