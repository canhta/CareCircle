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
}

class CareCircleButton extends StatelessWidget {
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
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;

    // Determine button colors based on variant
    final buttonConfig = _getButtonConfiguration(isDisabled, theme);
    final buttonHeight = _getButtonHeight();
    final textStyle = _getTextStyle(theme, buttonConfig['foregroundColor']);

    Widget buttonChild = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(buttonConfig['foregroundColor']),
            ),
          ),
          SizedBox(width: CareCircleSpacingTokens.sm),
        ] else if (icon != null) ...[
          Icon(icon, size: 20, color: buttonConfig['foregroundColor']),
          SizedBox(width: CareCircleSpacingTokens.sm),
        ],
        if (isUrgent) ...[
          Icon(
            Icons.priority_high,
            size: 16,
            color: buttonConfig['foregroundColor'],
          ),
          SizedBox(width: CareCircleSpacingTokens.xs),
        ],
        Text(text, style: textStyle),
      ],
    );

    return Semantics(
      label: semanticLabel ?? _getDefaultSemanticLabel(),
      hint: semanticHint ?? _getDefaultSemanticHint(),
      button: true,
      enabled: !isDisabled,
      excludeSemantics: excludeSemantics,
      child: Container(
        height: buttonHeight,
        width: isFullWidth ? double.infinity : null,
        padding: padding,
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonConfig['backgroundColor'],
            foregroundColor: buttonConfig['foregroundColor'],
            elevation: _getElevation(),
            shadowColor: buttonConfig['backgroundColor'].withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
              side: buttonConfig['borderColor'] != null
                  ? BorderSide(color: buttonConfig['borderColor'], width: 1.5)
                  : BorderSide.none,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: CareCircleSpacingTokens.md,
              vertical: CareCircleSpacingTokens.sm,
            ),
          ),
          child: buttonChild,
        ),
      ),
    );
  }

  // Helper Methods

  /// Get button configuration based on variant and state
  Map<String, dynamic> _getButtonConfiguration(bool isDisabled, ThemeData theme) {
    Color backgroundColor;
    Color foregroundColor;
    Color? borderColor;

    switch (variant) {
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
    }

    return {
      'backgroundColor': backgroundColor,
      'foregroundColor': foregroundColor,
      'borderColor': borderColor,
    };
  }

  /// Get button height based on variant
  double _getButtonHeight() {
    switch (variant) {
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
    switch (variant) {
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
        ) ?? TextStyle(color: foregroundColor);
    }
  }

  /// Get elevation based on variant
  double _getElevation() {
    switch (variant) {
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
    String baseLabel = text;

    if (isUrgent) {
      baseLabel = 'Urgent: $baseLabel';
    }

    if (medicalContext != null) {
      baseLabel = '$baseLabel, $medicalContext';
    }

    if (healthcareType != null) {
      baseLabel = '$baseLabel, $healthcareType';
    }

    return baseLabel;
  }

  /// Get default semantic hint
  String _getDefaultSemanticHint() {
    switch (variant) {
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
