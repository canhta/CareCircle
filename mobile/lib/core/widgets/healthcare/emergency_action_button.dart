// CareCircle Emergency Action Button
//
// Healthcare-optimized emergency button with urgent state animations,
// accessibility compliance, and emergency workflow integration.

import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';
import '../../animations/healthcare_animations.dart';

/// Emergency Action Button with healthcare-specific features
class EmergencyActionButton extends StatefulWidget {
  const EmergencyActionButton({
    super.key,
    required this.onPressed,
    this.label = 'Emergency',
    this.isUrgent = false,
    this.emergencyType = EmergencyType.general,
    this.size = EmergencyButtonSize.standard,
    this.semanticLabel,
    this.semanticHint,
  });

  final VoidCallback onPressed;
  final String label;
  final bool isUrgent;
  final EmergencyType emergencyType;
  final EmergencyButtonSize size;
  final String? semanticLabel;
  final String? semanticHint;

  @override
  State<EmergencyActionButton> createState() => _EmergencyActionButtonState();
}

class _EmergencyActionButtonState extends State<EmergencyActionButton>
    with TickerProviderStateMixin {
  late EmergencyUrgentAnimation _urgentAnimation;
  late AnimationController _pressController;
  late Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();
    _urgentAnimation = EmergencyUrgentAnimation(vsync: this);

    _pressController = AnimationController(
      duration: HealthcareAnimationTokens.buttonPress,
      vsync: this,
    );

    _pressAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );

    if (widget.isUrgent) {
      _urgentAnimation.startUrgentPulse();
    }
  }

  @override
  void didUpdateWidget(EmergencyActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isUrgent != oldWidget.isUrgent) {
      if (widget.isUrgent) {
        _urgentAnimation.startUrgentPulse();
      } else {
        _urgentAnimation.stop();
      }
    }
  }

  @override
  void dispose() {
    _urgentAnimation.dispose();
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel ?? '${widget.label} button',
      hint:
          widget.semanticHint ?? 'Tap for ${widget.emergencyType.description}',
      button: true,
      child: GestureDetector(
        onTapDown: (_) => _pressController.forward(),
        onTapUp: (_) => _pressController.reverse(),
        onTapCancel: () => _pressController.reverse(),
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _pressAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pressAnimation.value,
              child: _urgentAnimation.buildUrgentButton(
                isUrgent: widget.isUrgent,
                onPressed: widget.onPressed,
                child: _buildButtonContent(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    final buttonSize = _getButtonSize();
    final iconSize = _getIconSize();
    final textStyle = _getTextStyle();

    return Container(
      width: buttonSize.width,
      height: buttonSize.height,
      decoration: BoxDecoration(
        color: _getButtonColor(),
        borderRadius: BorderRadius.circular(CareCircleSpacingTokens.md),
        border: Border.all(
          color: widget.isUrgent
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getEmergencyIcon(),
            size: iconSize,
            color: Colors.white,
            semanticLabel: '${widget.emergencyType.description} icon',
          ),
          if (widget.size != EmergencyButtonSize.compact) ...[
            SizedBox(height: CareCircleSpacingTokens.xs),
            Text(widget.label, style: textStyle, textAlign: TextAlign.center),
          ],
          if (widget.isUrgent && widget.size == EmergencyButtonSize.large) ...[
            SizedBox(height: CareCircleSpacingTokens.xs),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: CareCircleSpacingTokens.sm,
                vertical: CareCircleSpacingTokens.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(CareCircleSpacingTokens.xs),
              ),
              child: Text(
                'URGENT',
                style: CareCircleTypographyTokens.medicalLabel.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Size _getButtonSize() {
    switch (widget.size) {
      case EmergencyButtonSize.compact:
        return const Size(60, 60);
      case EmergencyButtonSize.standard:
        return const Size(120, 80);
      case EmergencyButtonSize.large:
        return const Size(160, 120);
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case EmergencyButtonSize.compact:
        return 24;
      case EmergencyButtonSize.standard:
        return 32;
      case EmergencyButtonSize.large:
        return 40;
    }
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case EmergencyButtonSize.compact:
        return CareCircleTypographyTokens.medicalLabel.copyWith(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        );
      case EmergencyButtonSize.standard:
        return CareCircleTypographyTokens.medicalLabel.copyWith(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        );
      case EmergencyButtonSize.large:
        return CareCircleTypographyTokens.healthMetricTitle.copyWith(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        );
    }
  }

  Color _getButtonColor() {
    if (widget.isUrgent) {
      return CareCircleColorTokens.emergencyRed;
    }

    switch (widget.emergencyType) {
      case EmergencyType.medical:
        return CareCircleColorTokens.emergencyRed;
      case EmergencyType.medication:
        return CareCircleColorTokens.warningAmber;
      case EmergencyType.general:
        return CareCircleColorTokens.primaryMedicalBlue;
    }
  }

  IconData _getEmergencyIcon() {
    switch (widget.emergencyType) {
      case EmergencyType.medical:
        return Icons.local_hospital;
      case EmergencyType.medication:
        return Icons.medication;
      case EmergencyType.general:
        return Icons.emergency;
    }
  }
}

/// Emergency button types for different healthcare scenarios
enum EmergencyType { medical, medication, general }

extension EmergencyTypeExtension on EmergencyType {
  String get description {
    switch (this) {
      case EmergencyType.medical:
        return 'medical emergency';
      case EmergencyType.medication:
        return 'medication emergency';
      case EmergencyType.general:
        return 'emergency assistance';
    }
  }
}

/// Emergency button sizes for different use cases
enum EmergencyButtonSize { compact, standard, large }

/// Emergency Button Animations utility class
class EmergencyButtonAnimations {
  /// Builds an urgent state button with glow animation
  static Widget buildUrgentStateButton({
    required VoidCallback onPressed,
    required bool isUrgent,
    required String label,
    EmergencyType type = EmergencyType.general,
    EmergencyButtonSize size = EmergencyButtonSize.standard,
  }) {
    return EmergencyActionButton(
      onPressed: onPressed,
      label: label,
      isUrgent: isUrgent,
      emergencyType: type,
      size: size,
      semanticLabel: '$label emergency button',
      semanticHint: isUrgent
          ? 'Urgent: Tap immediately for emergency assistance'
          : 'Tap for emergency assistance',
    );
  }

  /// Creates a floating emergency button for overlay use
  static Widget buildFloatingEmergencyButton({
    required VoidCallback onPressed,
    required bool isVisible,
    Alignment alignment = Alignment.bottomRight,
  }) {
    return AnimatedPositioned(
      duration: HealthcareAnimationTokens.healthStatusTransition,
      curve: HealthcareAnimationTokens.emergencyEase,
      bottom: isVisible ? 20 : -100,
      right: 20,
      child: EmergencyActionButton(
        onPressed: onPressed,
        label: 'SOS',
        isUrgent: true,
        emergencyType: EmergencyType.medical,
        size: EmergencyButtonSize.compact,
        semanticLabel: 'Emergency SOS button',
        semanticHint: 'Tap for immediate emergency assistance',
      ),
    );
  }

  /// Creates an emergency action sheet with multiple options
  static void showEmergencyActionSheet({
    required BuildContext context,
    required VoidCallback onCall911,
    required VoidCallback onCallDoctor,
    required VoidCallback onCallCaregiver,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(CareCircleSpacingTokens.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(CareCircleSpacingTokens.lg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Emergency Options',
              style: CareCircleTypographyTokens.healthMetricTitle.copyWith(
                color: CareCircleColorTokens.emergencyRed,
              ),
            ),
            SizedBox(height: CareCircleSpacingTokens.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EmergencyActionButton(
                  onPressed: onCall911,
                  label: 'Call 911',
                  isUrgent: true,
                  emergencyType: EmergencyType.medical,
                  size: EmergencyButtonSize.standard,
                ),
                EmergencyActionButton(
                  onPressed: onCallDoctor,
                  label: 'Call Doctor',
                  emergencyType: EmergencyType.medical,
                  size: EmergencyButtonSize.standard,
                ),
                EmergencyActionButton(
                  onPressed: onCallCaregiver,
                  label: 'Call Caregiver',
                  emergencyType: EmergencyType.general,
                  size: EmergencyButtonSize.standard,
                ),
              ],
            ),
            SizedBox(height: CareCircleSpacingTokens.lg),
          ],
        ),
      ),
    );
  }
}
