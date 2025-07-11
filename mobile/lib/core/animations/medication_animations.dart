// CareCircle Medication Animations
//
// This file provides medication-specific animations for adherence tracking,
// reminders, and medication management workflows.

import 'package:flutter/material.dart';
import '../design/design_tokens.dart';
import 'healthcare_animations.dart';

/// Medication reminder animations for different states
class MedicationReminderAnimations {
  /// Creates a pulse animation for overdue medications
  static AnimationController createPulseAnimation(TickerProvider vsync) {
    return AnimationController(
      duration: HealthcareAnimationTokens.medicationPulseDuration,
      vsync: vsync,
    )..repeat(reverse: true);
  }

  /// Creates a success confirmation animation for taken doses
  static AnimationController createSuccessAnimation(TickerProvider vsync) {
    return AnimationController(
      duration: HealthcareAnimationTokens.successConfirmationDuration,
      vsync: vsync,
    );
  }

  /// Creates a streak celebration animation for adherence milestones
  static AnimationController createStreakAnimation(TickerProvider vsync) {
    return AnimationController(
      duration: HealthcareAnimationTokens.streakCelebrationDuration,
      vsync: vsync,
    );
  }

  /// Builds an animated medication reminder card
  static Widget buildAnimatedReminderCard({
    required Widget child,
    required AnimationController controller,
    required MedicationReminderState state,
    VoidCallback? onTap,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return GestureDetector(
          onTap: onTap,
          child: Transform.scale(
            scale: _getScaleForState(state, controller.value),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CareCircleSpacingTokens.md),
                boxShadow: _getShadowForState(state, controller.value),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Builds a dose taken confirmation animation
  static Widget buildDoseTakenConfirmation({
    required AnimationController controller,
    required String medicationName,
    required String dosage,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final slideAnimation =
            Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
              CurvedAnimation(
                parent: controller,
                curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
              ),
            );

        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
          ),
        );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Container(
              padding: EdgeInsets.all(CareCircleSpacingTokens.md),
              decoration: BoxDecoration(
                color: CareCircleColorTokens.healthGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(CareCircleSpacingTokens.md),
                border: Border.all(
                  color: CareCircleColorTokens.healthGreen,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: CareCircleColorTokens.healthGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: CareCircleSpacingTokens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Dose Taken',
                          style: CareCircleTypographyTokens.healthMetricTitle
                              .copyWith(
                                color: CareCircleColorTokens.healthGreen,
                              ),
                        ),
                        Text(
                          '$medicationName - $dosage',
                          style: CareCircleTypographyTokens.medicalLabel,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds an adherence streak celebration animation
  static Widget buildStreakCelebration({
    required AnimationController controller,
    required int streakDays,
    required String message,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
          ),
        );

        final rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
          ),
        );

        final glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
          ),
        );

        return Transform.scale(
          scale: scaleAnimation.value,
          child: Transform.rotate(
            angle: rotationAnimation.value,
            child: Container(
              padding: EdgeInsets.all(CareCircleSpacingTokens.lg),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.orange.withValues(alpha: glowAnimation.value * 0.3),
                    Colors.yellow.withValues(alpha: glowAnimation.value * 0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(CareCircleSpacingTokens.lg),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.orange, Colors.yellow],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(
                            alpha: glowAnimation.value * 0.5,
                          ),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$streakDays',
                          style: CareCircleTypographyTokens.healthMetricValue
                              .copyWith(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'DAYS',
                          style: CareCircleTypographyTokens.medicalLabel
                              .copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: CareCircleSpacingTokens.md),
                  Text(
                    message,
                    style: CareCircleTypographyTokens.healthMetricTitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Gets the scale factor for different medication reminder states
  static double _getScaleForState(
    MedicationReminderState state,
    double animationValue,
  ) {
    switch (state) {
      case MedicationReminderState.upcoming:
        return 1.0;
      case MedicationReminderState.due:
        return 1.0 + (animationValue * 0.02);
      case MedicationReminderState.overdue:
        return 1.0 + (animationValue * 0.05);
      case MedicationReminderState.taken:
        return 1.0;
      case MedicationReminderState.missed:
        return 1.0;
    }
  }

  /// Gets the shadow for different medication reminder states
  static List<BoxShadow> _getShadowForState(
    MedicationReminderState state,
    double animationValue,
  ) {
    switch (state) {
      case MedicationReminderState.upcoming:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ];
      case MedicationReminderState.due:
        return [
          BoxShadow(
            color: CareCircleColorTokens.warningAmber.withValues(
              alpha: 0.3 + (animationValue * 0.2),
            ),
            blurRadius: 8 + (animationValue * 4),
            offset: const Offset(0, 4),
          ),
        ];
      case MedicationReminderState.overdue:
        return [
          BoxShadow(
            color: CareCircleColorTokens.emergencyRed.withValues(
              alpha: 0.4 + (animationValue * 0.3),
            ),
            blurRadius: 12 + (animationValue * 8),
            offset: const Offset(0, 6),
          ),
        ];
      case MedicationReminderState.taken:
        return [
          BoxShadow(
            color: CareCircleColorTokens.healthGreen.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ];
      case MedicationReminderState.missed:
        return [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ];
    }
  }
}

/// Medication reminder states for animations
enum MedicationReminderState { upcoming, due, overdue, taken, missed }
