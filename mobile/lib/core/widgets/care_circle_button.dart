import 'package:flutter/material.dart';
import '../design/design_tokens.dart';

enum CareCircleButtonVariant { primary, secondary, emergency, ghost }

class CareCircleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final CareCircleButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;

  const CareCircleButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.variant = CareCircleButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;

    // Determine button colors based on variant
    Color backgroundColor;
    Color foregroundColor;
    Color? borderColor;

    switch (variant) {
      case CareCircleButtonVariant.primary:
        backgroundColor = isDisabled
            ? CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.3)
            : CareCircleDesignTokens.primaryMedicalBlue;
        foregroundColor = Colors.white;
        break;
      case CareCircleButtonVariant.secondary:
        backgroundColor = isDisabled
            ? theme.colorScheme.surface.withValues(alpha: 0.3)
            : theme.colorScheme.surface;
        foregroundColor = isDisabled
            ? CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.3)
            : CareCircleDesignTokens.primaryMedicalBlue;
        borderColor = isDisabled
            ? CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.3)
            : CareCircleDesignTokens.primaryMedicalBlue;
        break;
      case CareCircleButtonVariant.emergency:
        backgroundColor = isDisabled
            ? CareCircleDesignTokens.criticalAlert.withValues(alpha: 0.3)
            : CareCircleDesignTokens.criticalAlert;
        foregroundColor = Colors.white;
        break;
      case CareCircleButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = isDisabled
            ? CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.3)
            : CareCircleDesignTokens.primaryMedicalBlue;
        break;
    }

    final buttonHeight = variant == CareCircleButtonVariant.emergency
        ? CareCircleDesignTokens.emergencyButtonMin
        : CareCircleDesignTokens.touchTargetMin;

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
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          ),
          const SizedBox(width: 12),
        ] else if (icon != null) ...[
          Icon(icon, size: 20, color: foregroundColor),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    return Container(
      height: buttonHeight,
      width: isFullWidth ? double.infinity : null,
      padding: padding,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: variant == CareCircleButtonVariant.ghost ? 0 : 2,
          shadowColor: backgroundColor.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderColor != null
                ? BorderSide(color: borderColor, width: 1.5)
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: buttonChild,
      ),
    );
  }
}
