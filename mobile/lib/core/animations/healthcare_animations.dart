// CareCircle Healthcare Animations
// 
// This file provides healthcare-specific animations and micro-interactions
// that enhance the user experience for medical workflows.

import 'package:flutter/material.dart';
import '../design/design_tokens.dart';

/// Healthcare-specific animation durations and curves
class HealthcareAnimationTokens {
  // Medication-related animations
  static const Duration medicationPulseDuration = Duration(milliseconds: 1500);
  static const Duration successConfirmationDuration = Duration(milliseconds: 800);
  static const Duration streakCelebrationDuration = Duration(milliseconds: 1200);

  // Emergency animations
  static const Duration emergencyPulseDuration = Duration(milliseconds: 1000);
  static const Duration urgentGlowDuration = Duration(milliseconds: 2000);

  // Activity ring animations
  static const Duration activityRingFillDuration = Duration(milliseconds: 2000);
  static const Curve activityRingCurve = Curves.easeInOutCubic;

  // General healthcare animations
  static const Duration healthStatusTransition = Duration(milliseconds: 600);
  static const Duration vitalSignUpdate = Duration(milliseconds: 400);
  static const Duration chartDataUpdate = Duration(milliseconds: 800);

  // Micro-interaction animations
  static const Duration buttonPress = Duration(milliseconds: 150);
  static const Duration cardHover = Duration(milliseconds: 200);
  static const Duration tooltipShow = Duration(milliseconds: 300);

  // Animation curves
  static const Curve medicalEaseInOut = Curves.easeInOutQuart;
  static const Curve emergencyEase = Curves.easeOutBack;
  static const Curve successEase = Curves.elasticOut;
}

/// Base class for healthcare animations
abstract class HealthcareAnimation {
  final TickerProvider vsync;
  late final AnimationController controller;
  late final Animation<double> animation;
  
  HealthcareAnimation({
    required this.vsync,
    required Duration duration,
    Curve curve = Curves.easeInOut,
  }) {
    controller = AnimationController(duration: duration, vsync: vsync);
    animation = CurvedAnimation(parent: controller, curve: curve);
  }
  
  void start() => controller.forward();
  void stop() => controller.stop();
  void reset() => controller.reset();
  void reverse() => controller.reverse();
  void repeat() => controller.repeat();
  void dispose() => controller.dispose();
}

/// Pulse animation for overdue medications
class MedicationPulseAnimation extends HealthcareAnimation {
  MedicationPulseAnimation({required super.vsync})
      : super(
          duration: HealthcareAnimationTokens.medicationPulseDuration,
          curve: Curves.easeInOut,
        );
  
  void startPulse() {
    controller.repeat(reverse: true);
  }
  
  Widget buildPulsingWidget({
    required Widget child,
    double minScale = 0.95,
    double maxScale = 1.05,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final scale = minScale + (maxScale - minScale) * animation.value;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
    );
  }
}

/// Success confirmation animation with checkmark
class SuccessConfirmationAnimation extends HealthcareAnimation {
  SuccessConfirmationAnimation({required super.vsync})
      : super(
          duration: HealthcareAnimationTokens.successConfirmationDuration,
          curve: HealthcareAnimationTokens.successEase,
        );
  
  Widget buildSuccessCheckmark({
    double size = 24.0,
    Color color = Colors.green,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform.scale(
          scale: animation.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: size * 0.6,
            ),
          ),
        );
      },
    );
  }
}

/// Streak celebration animation
class StreakCelebrationAnimation extends HealthcareAnimation {
  StreakCelebrationAnimation({required super.vsync})
      : super(
          duration: HealthcareAnimationTokens.streakCelebrationDuration,
          curve: HealthcareAnimationTokens.successEase,
        );
  
  Widget buildCelebrationEffect({
    required Widget child,
    List<Color> colors = const [Colors.orange, Colors.yellow, Colors.green],
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: colors.map((c) => c.withValues(alpha: animation.value * 0.3)).toList(),
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(CareCircleSpacingTokens.md),
          ),
          child: Transform.scale(
            scale: 1.0 + (animation.value * 0.1),
            child: child,
          ),
        );
      },
    );
  }
}

/// Emergency button urgent state animation
class EmergencyUrgentAnimation extends HealthcareAnimation {
  EmergencyUrgentAnimation({required super.vsync})
      : super(
          duration: HealthcareAnimationTokens.emergencyPulseDuration,
          curve: Curves.easeInOut,
        );
  
  void startUrgentPulse() {
    controller.repeat(reverse: true);
  }
  
  Widget buildUrgentButton({
    required Widget child,
    required VoidCallback onPressed,
    bool isUrgent = false,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final glowIntensity = isUrgent ? animation.value : 0.0;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
            boxShadow: isUrgent ? [
              BoxShadow(
                color: CareCircleColorTokens.emergencyRed.withValues(
                  alpha: 0.3 + (glowIntensity * 0.4),
                ),
                blurRadius: 8 + (glowIntensity * 8),
                spreadRadius: 2 + (glowIntensity * 2),
              ),
            ] : null,
          ),
          child: Transform.scale(
            scale: isUrgent ? 1.0 + (glowIntensity * 0.05) : 1.0,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isUrgent 
                  ? CareCircleColorTokens.emergencyRed
                  : CareCircleColorTokens.primaryMedicalBlue,
                foregroundColor: Colors.white,
                elevation: isUrgent ? 4 + (glowIntensity * 4) : 2,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Health status transition animation
class HealthStatusTransitionAnimation extends HealthcareAnimation {
  HealthStatusTransitionAnimation({required super.vsync})
      : super(
          duration: HealthcareAnimationTokens.healthStatusTransition,
          curve: HealthcareAnimationTokens.medicalEaseInOut,
        );
  
  Widget buildStatusTransition({
    required Color fromColor,
    required Color toColor,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final color = Color.lerp(fromColor, toColor, animation.value)!;
        return Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(CareCircleSpacingTokens.md),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: child,
        );
      },
    );
  }
}

/// Vital sign update animation
class VitalSignUpdateAnimation extends HealthcareAnimation {
  VitalSignUpdateAnimation({required super.vsync})
      : super(
          duration: HealthcareAnimationTokens.vitalSignUpdate,
          curve: HealthcareAnimationTokens.medicalEaseInOut,
        );
  
  Widget buildValueUpdate({
    required String oldValue,
    required String newValue,
    required TextStyle textStyle,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        if (animation.value < 0.5) {
          // Fade out old value
          return Opacity(
            opacity: 1.0 - (animation.value * 2),
            child: Text(oldValue, style: textStyle),
          );
        } else {
          // Fade in new value
          return Opacity(
            opacity: (animation.value - 0.5) * 2,
            child: Text(newValue, style: textStyle),
          );
        }
      },
    );
  }
}
