import 'package:flutter/material.dart';
import '../design/design_tokens.dart';

/// Enhanced button variants for healthcare applications
enum CareCircleButtonVariant {
  primary,
  secondary,
  emergency,
  ghost,
  medical,
  critical,
  medication,
  appointment,
  vitals,
  // Modern gradient variants
  primaryGradient,
  aiAssistant,
  aiGradient,
  emergencyGradient,
  healthGradient,
  glassmorphism,
}

class CareCircleButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final CareCircleButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;

  // Healthcare-specific properties
  final bool isUrgent;
  final String? medicalContext;
  final String? healthcareType;

  // Modern styling properties
  final bool enableModernEffects;
  final bool enableHoverEffects;
  final bool enablePressAnimation;

  // Accessibility properties
  final String? semanticLabel;
  final String? semanticHint;
  final bool excludeSemantics;

  const CareCircleButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.variant = CareCircleButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.padding,
    this.isUrgent = false,
    this.medicalContext,
    this.healthcareType,
    this.enableModernEffects = true,
    this.enableHoverEffects = true,
    this.enablePressAnimation = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
  });

  @override
  State<CareCircleButton> createState() => _CareCircleButtonState();
}

class _CareCircleButtonState extends State<CareCircleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enablePressAnimation && widget.onPressed != null) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enablePressAnimation) {
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enablePressAnimation) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = widget.onPressed == null || widget.isLoading;

    // Determine button configuration based on variant
    final buttonConfig = _getButtonConfiguration(isDisabled, theme);
    final buttonHeight = _getButtonHeight();
    final textStyle = _getTextStyle(theme, buttonConfig['foregroundColor']);

    // Build the button content
    Widget buttonContent = _buildButtonContent(context, textStyle);

    // Apply modern effects if enabled
    if (widget.enableModernEffects) {
      buttonContent = AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.enablePressAnimation ? _scaleAnimation.value : 1.0,
            child: child,
          );
        },
        child: buttonContent,
      );
    }

    return Semantics(
      label: widget.semanticLabel ?? _getDefaultSemanticLabel(),
      hint: widget.semanticHint ?? _getDefaultSemanticHint(),
      button: true,
      enabled: !isDisabled,
      excludeSemantics: widget.excludeSemantics,
      child: Container(
        height: buttonHeight,
        width: widget.isFullWidth ? double.infinity : null,
        padding: widget.padding,
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: isDisabled ? null : widget.onPressed,
          child: Container(
            decoration: _getButtonDecoration(buttonConfig),
            padding: EdgeInsets.symmetric(
              horizontal: CareCircleSpacingTokens.md,
              vertical: CareCircleSpacingTokens.sm,
            ),
            child: buttonContent,
          ),
        ),
      ),
    );
  }

  /// Build button content with icon and text
  Widget _buildButtonContent(BuildContext context, TextStyle textStyle) {
    return Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                textStyle.color ?? Colors.white,
              ),
            ),
          ),
          SizedBox(width: CareCircleSpacingTokens.sm),
        ] else if (widget.icon != null) ...[
          Icon(widget.icon, size: 20, color: textStyle.color),
          SizedBox(width: CareCircleSpacingTokens.sm),
        ],
        if (widget.isUrgent) ...[
          Icon(Icons.priority_high, size: 16, color: textStyle.color),
          SizedBox(width: CareCircleSpacingTokens.xs),
        ],
        Text(widget.text, style: textStyle),
      ],
    );
  }

  /// Get modern button decoration based on variant
  BoxDecoration _getButtonDecoration(Map<String, dynamic> buttonConfig) {
    // Import the new design tokens
    switch (widget.variant) {
      case CareCircleButtonVariant.primaryGradient:
        return BoxDecoration(
          gradient: CareCircleGradientTokens.primaryMedical,
          borderRadius: CareCircleModernEffectsTokens.radiusSM,
          boxShadow: CareCircleModernEffectsTokens.medicalShadow,
        );
      case CareCircleButtonVariant.aiAssistant:
      case CareCircleButtonVariant.aiGradient:
        return BoxDecoration(
          gradient: CareCircleGradientTokens.aiAssistant,
          borderRadius: CareCircleModernEffectsTokens.radiusLG,
          boxShadow: CareCircleModernEffectsTokens.aiShadow,
        );
      case CareCircleButtonVariant.emergencyGradient:
        return BoxDecoration(
          gradient: CareCircleGradientTokens.criticalAlert,
          borderRadius: CareCircleModernEffectsTokens.radiusSM,
          boxShadow: CareCircleModernEffectsTokens.emergencyShadow,
        );
      case CareCircleButtonVariant.healthGradient:
        return BoxDecoration(
          gradient: CareCircleGradientTokens.healthSuccess,
          borderRadius: CareCircleModernEffectsTokens.radiusSM,
          boxShadow: CareCircleModernEffectsTokens.softShadow,
        );
      case CareCircleButtonVariant.glassmorphism:
        return CareCircleGlassmorphismTokens.medicalCardGlass();
      default:
        return BoxDecoration(
          color: buttonConfig['backgroundColor'],
          borderRadius: CareCircleModernEffectsTokens.radiusSM,
          boxShadow: CareCircleModernEffectsTokens.getShadowForElevation(
            _getElevation().round(),
          ),
          border: buttonConfig['borderColor'] != null
              ? Border.all(color: buttonConfig['borderColor'], width: 1.5)
              : null,
        );
    }
  }

  // Helper Methods

  /// Get button configuration based on variant and state
  Map<String, dynamic> _getButtonConfiguration(
    bool isDisabled,
    ThemeData theme,
  ) {
    Color backgroundColor;
    Color foregroundColor;
    Color? borderColor;

    switch (widget.variant) {
      case CareCircleButtonVariant.primary:
        backgroundColor = isDisabled
            ? CareCircleColorTokens.primaryMedicalBlue.withValues(alpha: 0.3)
            : CareCircleColorTokens.primaryMedicalBlue;
        foregroundColor = Colors.white;
        break;
      case CareCircleButtonVariant.secondary:
        backgroundColor = isDisabled
            ? theme.colorScheme.surface.withValues(alpha: 0.3)
            : theme.colorScheme.surface;
        foregroundColor = isDisabled
            ? CareCircleColorTokens.primaryMedicalBlue.withValues(alpha: 0.3)
            : CareCircleColorTokens.primaryMedicalBlue;
        borderColor = isDisabled
            ? CareCircleColorTokens.primaryMedicalBlue.withValues(alpha: 0.3)
            : CareCircleColorTokens.primaryMedicalBlue;
        break;
      case CareCircleButtonVariant.emergency:
        backgroundColor = isDisabled
            ? CareCircleColorTokens.criticalAlert.withValues(alpha: 0.3)
            : CareCircleColorTokens.criticalAlert;
        foregroundColor = Colors.white;
        break;
      case CareCircleButtonVariant.critical:
        backgroundColor = isDisabled
            ? CareCircleColorTokens.emergencyRed.withValues(alpha: 0.3)
            : CareCircleColorTokens.emergencyRed;
        foregroundColor = Colors.white;
        break;
      case CareCircleButtonVariant.medical:
        backgroundColor = isDisabled
            ? CareCircleColorTokens.healthGreen.withValues(alpha: 0.3)
            : CareCircleColorTokens.healthGreen;
        foregroundColor = Colors.white;
        break;
      case CareCircleButtonVariant.medication:
        backgroundColor = isDisabled
            ? CareCircleColorTokens.prescriptionBlue.withValues(alpha: 0.3)
            : CareCircleColorTokens.prescriptionBlue;
        foregroundColor = Colors.white;
        break;
      case CareCircleButtonVariant.appointment:
        backgroundColor = isDisabled
            ? CareCircleColorTokens.scheduledBlue.withValues(alpha: 0.3)
            : CareCircleColorTokens.scheduledBlue;
        foregroundColor = Colors.white;
        break;
      case CareCircleButtonVariant.vitals:
        backgroundColor = isDisabled
            ? CareCircleColorTokens.heartRateRed.withValues(alpha: 0.3)
            : CareCircleColorTokens.heartRateRed;
        foregroundColor = Colors.white;
        break;
      case CareCircleButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = isDisabled
            ? CareCircleColorTokens.primaryMedicalBlue.withValues(alpha: 0.3)
            : CareCircleColorTokens.primaryMedicalBlue;
        break;
      // Modern gradient variants
      case CareCircleButtonVariant.primaryGradient:
        backgroundColor =
            Colors.transparent; // Gradient will be applied in decoration
        foregroundColor = Colors.white;
        break;
      case CareCircleButtonVariant.aiAssistant:
      case CareCircleButtonVariant.aiGradient:
        backgroundColor =
            Colors.transparent; // Gradient will be applied in decoration
        foregroundColor = Colors.white;
        break;
      case CareCircleButtonVariant.emergencyGradient:
        backgroundColor =
            Colors.transparent; // Gradient will be applied in decoration
        foregroundColor = Colors.white;
        break;
      case CareCircleButtonVariant.healthGradient:
        backgroundColor =
            Colors.transparent; // Gradient will be applied in decoration
        foregroundColor = Colors.white;
        break;
      case CareCircleButtonVariant.glassmorphism:
        backgroundColor =
            Colors.transparent; // Glassmorphism will be applied in decoration
        foregroundColor = CareCircleColorTokens.primaryMedicalBlue;
        break;
    }

    return {
      'backgroundColor': backgroundColor,
      'foregroundColor': foregroundColor,
      'borderColor': borderColor,
    };
  }

  /// Get button height based on variant
  double _getButtonHeight() {
    switch (widget.variant) {
      case CareCircleButtonVariant.emergency:
      case CareCircleButtonVariant.critical:
        return CareCircleSpacingTokens.emergencyButtonMin;
      case CareCircleButtonVariant.medication:
        return CareCircleSpacingTokens.medicationButtonMin;
      case CareCircleButtonVariant.vitals:
        return CareCircleSpacingTokens.vitalSignsButtonMin;
      default:
        return CareCircleSpacingTokens.touchTargetMin;
    }
  }

  /// Get text style based on variant
  TextStyle _getTextStyle(ThemeData theme, Color foregroundColor) {
    switch (widget.variant) {
      case CareCircleButtonVariant.emergency:
      case CareCircleButtonVariant.critical:
        return CareCircleTypographyTokens.emergencyButton.copyWith(
          color: foregroundColor,
        );
      case CareCircleButtonVariant.medication:
        return CareCircleTypographyTokens.medicationName.copyWith(
          color: foregroundColor,
          fontSize: 14,
        );
      default:
        return theme.textTheme.labelLarge?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ) ??
            TextStyle(color: foregroundColor);
    }
  }

  /// Get elevation based on variant
  double _getElevation() {
    switch (widget.variant) {
      case CareCircleButtonVariant.ghost:
        return 0;
      case CareCircleButtonVariant.emergency:
      case CareCircleButtonVariant.critical:
        return 4;
      default:
        return 2;
    }
  }

  /// Get default semantic label
  String _getDefaultSemanticLabel() {
    String baseLabel = widget.text;

    if (widget.isUrgent) {
      baseLabel = 'Urgent: $baseLabel';
    }

    if (widget.medicalContext != null) {
      baseLabel = '$baseLabel, ${widget.medicalContext}';
    }

    if (widget.healthcareType != null) {
      baseLabel = '$baseLabel, ${widget.healthcareType}';
    }

    return baseLabel;
  }

  /// Get default semantic hint
  String _getDefaultSemanticHint() {
    switch (widget.variant) {
      case CareCircleButtonVariant.emergency:
        return 'Emergency action button. Double-tap to activate.';
      case CareCircleButtonVariant.critical:
        return 'Critical medical action. Use with caution.';
      case CareCircleButtonVariant.medication:
        return 'Medication-related action.';
      case CareCircleButtonVariant.appointment:
        return 'Appointment-related action.';
      case CareCircleButtonVariant.vitals:
        return 'Vital signs related action.';
      case CareCircleButtonVariant.medical:
        return 'Medical action button.';
      default:
        return 'Button. Double-tap to activate.';
    }
  }
}
