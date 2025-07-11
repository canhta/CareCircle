// CareCircle Healthcare Micro-Interactions
//
// Comprehensive micro-interaction system for healthcare applications
// with accessibility-compliant feedback and medical workflow optimization.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../design/design_tokens.dart';
import '../animations/healthcare_animations.dart';

/// Healthcare Micro-Interactions Manager
class HealthcareMicroInteractions {
  /// Provides haptic feedback for medical actions
  static void provideMedicalFeedback(MedicalActionType actionType) {
    switch (actionType) {
      case MedicalActionType.doseTaken:
        HapticFeedback.lightImpact();
        break;
      case MedicalActionType.emergencyActivated:
        HapticFeedback.heavyImpact();
        break;
      case MedicalActionType.vitalSignRecorded:
        HapticFeedback.selectionClick();
        break;
      case MedicalActionType.appointmentScheduled:
        HapticFeedback.mediumImpact();
        break;
      case MedicalActionType.dataUpdated:
        HapticFeedback.lightImpact();
        break;
    }
  }

  /// Creates a healthcare-optimized button with micro-interactions
  static Widget buildInteractiveButton({
    required Widget child,
    required VoidCallback onPressed,
    MedicalActionType actionType = MedicalActionType.dataUpdated,
    bool enableHaptics = true,
    bool enableScaleAnimation = true,
    bool enableRipple = true,
    Color? rippleColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
  }) {
    return _InteractiveButton(
      onPressed: onPressed,
      actionType: actionType,
      enableHaptics: enableHaptics,
      enableScaleAnimation: enableScaleAnimation,
      enableRipple: enableRipple,
      rippleColor: rippleColor,
      borderRadius: borderRadius,
      padding: padding,
      child: child,
    );
  }

  /// Creates a floating action button with healthcare micro-interactions
  static Widget buildHealthcareFAB({
    required VoidCallback onPressed,
    required IconData icon,
    String? tooltip,
    bool isEmergency = false,
    bool showPulse = false,
  }) {
    return _HealthcareFAB(
      onPressed: onPressed,
      icon: icon,
      tooltip: tooltip,
      isEmergency: isEmergency,
      showPulse: showPulse,
    );
  }

  /// Creates a card with hover and tap micro-interactions
  static Widget buildInteractiveCard({
    required Widget child,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool enableHoverEffect = true,
    bool enableTapEffect = true,
    EdgeInsets? margin,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
  }) {
    return _InteractiveCard(
      onTap: onTap,
      onLongPress: onLongPress,
      enableHoverEffect: enableHoverEffect,
      enableTapEffect: enableTapEffect,
      margin: margin,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      child: child,
    );
  }

  /// Creates a progress indicator with healthcare-appropriate animations
  static Widget buildHealthcareProgress({
    required double progress,
    required String label,
    Color? progressColor,
    Color? backgroundColor,
    bool showPercentage = true,
    bool animate = true,
  }) {
    return _HealthcareProgressIndicator(
      progress: progress,
      label: label,
      progressColor: progressColor,
      backgroundColor: backgroundColor,
      showPercentage: showPercentage,
      animate: animate,
    );
  }

  /// Creates a toggle switch with healthcare micro-interactions
  static Widget buildHealthcareToggle({
    required bool value,
    required Function(bool) onChanged,
    required String label,
    String? description,
    bool isEnabled = true,
    MedicalActionType actionType = MedicalActionType.dataUpdated,
  }) {
    return _HealthcareToggle(
      value: value,
      onChanged: onChanged,
      label: label,
      description: description,
      isEnabled: isEnabled,
      actionType: actionType,
    );
  }
}

/// Medical action types for appropriate feedback
enum MedicalActionType {
  doseTaken,
  emergencyActivated,
  vitalSignRecorded,
  appointmentScheduled,
  dataUpdated,
}

/// Interactive Button with healthcare micro-interactions
class _InteractiveButton extends StatefulWidget {
  const _InteractiveButton({
    required this.child,
    required this.onPressed,
    required this.actionType,
    required this.enableHaptics,
    required this.enableScaleAnimation,
    required this.enableRipple,
    this.rippleColor,
    this.borderRadius,
    this.padding,
  });

  final Widget child;
  final VoidCallback onPressed;
  final MedicalActionType actionType;
  final bool enableHaptics;
  final bool enableScaleAnimation;
  final bool enableRipple;
  final Color? rippleColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  @override
  State<_InteractiveButton> createState() => _InteractiveButtonState();
}

class _InteractiveButtonState extends State<_InteractiveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: HealthcareAnimationTokens.buttonPress,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget button = GestureDetector(
      onTapDown: widget.enableScaleAnimation
          ? (_) => _controller.forward()
          : null,
      onTapUp: widget.enableScaleAnimation
          ? (_) => _controller.reverse()
          : null,
      onTapCancel: widget.enableScaleAnimation
          ? () => _controller.reverse()
          : null,
      onTap: () {
        if (widget.enableHaptics) {
          HealthcareMicroInteractions.provideMedicalFeedback(widget.actionType);
        }
        widget.onPressed();
      },
      child: Container(
        padding: widget.padding ?? EdgeInsets.all(CareCircleSpacingTokens.md),
        child: widget.child,
      ),
    );

    if (widget.enableScaleAnimation) {
      button = AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: button,
      );
    }

    if (widget.enableRipple) {
      button = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.enableHaptics) {
              HealthcareMicroInteractions.provideMedicalFeedback(
                widget.actionType,
              );
            }
            widget.onPressed();
          },
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(CareCircleSpacingTokens.sm),
          splashColor:
              widget.rippleColor ??
              CareCircleColorTokens.primaryMedicalBlue.withValues(alpha: 0.2),
          highlightColor:
              widget.rippleColor?.withValues(alpha: 0.1) ??
              CareCircleColorTokens.primaryMedicalBlue.withValues(alpha: 0.1),
          child: button,
        ),
      );
    }

    return button;
  }
}

/// Healthcare FAB with micro-interactions
class _HealthcareFAB extends StatefulWidget {
  const _HealthcareFAB({
    required this.onPressed,
    required this.icon,
    this.tooltip,
    required this.isEmergency,
    required this.showPulse,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;
  final bool isEmergency;
  final bool showPulse;

  @override
  State<_HealthcareFAB> createState() => _HealthcareFABState();
}

class _HealthcareFABState extends State<_HealthcareFAB>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: HealthcareAnimationTokens.emergencyPulseDuration,
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.showPulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_HealthcareFAB oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showPulse != oldWidget.showPulse) {
      if (widget.showPulse) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.showPulse ? _pulseAnimation.value : 1.0,
          child: FloatingActionButton(
            heroTag: 'healthcare_micro_fab',
            onPressed: () {
              HealthcareMicroInteractions.provideMedicalFeedback(
                widget.isEmergency
                    ? MedicalActionType.emergencyActivated
                    : MedicalActionType.dataUpdated,
              );
              widget.onPressed();
            },
            backgroundColor: widget.isEmergency
                ? CareCircleColorTokens.emergencyRed
                : CareCircleColorTokens.primaryMedicalBlue,
            foregroundColor: Colors.white,
            tooltip: widget.tooltip,
            elevation: widget.isEmergency ? 8 : 6,
            child: Icon(widget.icon),
          ),
        );
      },
    );
  }
}

/// Interactive Card with hover and tap effects
class _InteractiveCard extends StatefulWidget {
  const _InteractiveCard({
    required this.child,
    this.onTap,
    this.onLongPress,
    required this.enableHoverEffect,
    required this.enableTapEffect,
    this.margin,
    this.borderRadius,
    this.boxShadow,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enableHoverEffect;
  final bool enableTapEffect;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;

  @override
  State<_InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<_InteractiveCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: HealthcareAnimationTokens.cardHover,
      vsync: this,
    );
    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _elevationAnimation,
      builder: (context, child) {
        return Container(
          margin: widget.margin,
          child: Material(
            elevation: widget.enableHoverEffect
                ? _elevationAnimation.value
                : 2.0,
            borderRadius:
                widget.borderRadius ??
                BorderRadius.circular(CareCircleSpacingTokens.md),
            child: InkWell(
              onTap: widget.onTap != null
                  ? () {
                      HealthcareMicroInteractions.provideMedicalFeedback(
                        MedicalActionType.dataUpdated,
                      );
                      widget.onTap!();
                    }
                  : null,
              onLongPress: widget.onLongPress,
              onHover: widget.enableHoverEffect
                  ? (hovering) {
                      if (hovering) {
                        _controller.forward();
                      } else {
                        _controller.reverse();
                      }
                    }
                  : null,
              borderRadius:
                  widget.borderRadius ??
                  BorderRadius.circular(CareCircleSpacingTokens.md),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

/// Healthcare Progress Indicator with animations
class _HealthcareProgressIndicator extends StatefulWidget {
  const _HealthcareProgressIndicator({
    required this.progress,
    required this.label,
    this.progressColor,
    this.backgroundColor,
    required this.showPercentage,
    required this.animate,
  });

  final double progress;
  final String label;
  final Color? progressColor;
  final Color? backgroundColor;
  final bool showPercentage;
  final bool animate;

  @override
  State<_HealthcareProgressIndicator> createState() =>
      _HealthcareProgressIndicatorState();
}

class _HealthcareProgressIndicatorState
    extends State<_HealthcareProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: HealthcareAnimationTokens.chartDataUpdate,
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_HealthcareProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        final currentProgress = widget.animate
            ? _progressAnimation.value
            : widget.progress;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label,
                  style: CareCircleTypographyTokens.medicalLabel,
                ),
                if (widget.showPercentage)
                  Text(
                    '${(currentProgress * 100).round()}%',
                    style: CareCircleTypographyTokens.medicalLabel.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            SizedBox(height: CareCircleSpacingTokens.xs),
            LinearProgressIndicator(
              value: currentProgress,
              backgroundColor:
                  widget.backgroundColor ?? Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.progressColor ?? CareCircleColorTokens.healthGreen,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Healthcare Toggle with micro-interactions
class _HealthcareToggle extends StatelessWidget {
  const _HealthcareToggle({
    required this.value,
    required this.onChanged,
    required this.label,
    this.description,
    required this.isEnabled,
    required this.actionType,
  });

  final bool value;
  final Function(bool) onChanged;
  final String label;
  final String? description;
  final bool isEnabled;
  final MedicalActionType actionType;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: CareCircleTypographyTokens.healthMetricTitle),
      subtitle: description != null
          ? Text(description!, style: CareCircleTypographyTokens.medicalLabel)
          : null,
      trailing: Switch(
        value: value,
        onChanged: isEnabled
            ? (newValue) {
                HealthcareMicroInteractions.provideMedicalFeedback(actionType);
                onChanged(newValue);
              }
            : null,
        activeColor: CareCircleColorTokens.healthGreen,
      ),
      enabled: isEnabled,
      onTap: isEnabled
          ? () {
              HealthcareMicroInteractions.provideMedicalFeedback(actionType);
              onChanged(!value);
            }
          : null,
    );
  }
}
