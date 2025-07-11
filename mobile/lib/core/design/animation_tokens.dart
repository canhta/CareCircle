import 'package:flutter/material.dart';

/// CareCircle Animation Token System
/// 
/// Healthcare-appropriate motion and timing with accessibility considerations.
/// Supports reduced motion preferences and medical context animations.
class CareCircleAnimationTokens {
  // Duration Tokens
  
  /// Instant feedback (50ms) - For immediate responses
  static const Duration instant = Duration(milliseconds: 50);
  
  /// Quick transitions (100ms) - For simple state changes
  static const Duration quick = Duration(milliseconds: 100);
  
  /// Fast animations (200ms) - For UI feedback
  static const Duration fast = Duration(milliseconds: 200);
  
  /// Standard duration (300ms) - Default for most animations
  static const Duration standard = Duration(milliseconds: 300);
  
  /// Moderate duration (400ms) - For complex transitions
  static const Duration moderate = Duration(milliseconds: 400);
  
  /// Slow animations (500ms) - For emphasis
  static const Duration slow = Duration(milliseconds: 500);
  
  /// Extended duration (800ms) - For complex sequences
  static const Duration extended = Duration(milliseconds: 800);

  // Healthcare-Specific Durations
  
  /// Emergency alert animation (150ms) - Quick attention grabbing
  static const Duration emergencyAlert = Duration(milliseconds: 150);
  
  /// Vital signs pulse (1000ms) - Matches heart rate visualization
  static const Duration vitalSignsPulse = Duration(milliseconds: 1000);
  
  /// Medication reminder (600ms) - Gentle but noticeable
  static const Duration medicationReminder = Duration(milliseconds: 600);
  
  /// Data loading (400ms) - Medical data fetch feedback
  static const Duration dataLoading = Duration(milliseconds: 400);
  
  /// Chart animation (800ms) - Health metric visualization
  static const Duration chartAnimation = Duration(milliseconds: 800);
  
  /// Form validation (250ms) - Input feedback
  static const Duration formValidation = Duration(milliseconds: 250);

  // Accessibility Durations
  
  /// Reduced motion duration (200ms) - For accessibility compliance
  static const Duration reducedMotion = Duration(milliseconds: 200);
  
  /// Screen reader compatible (100ms) - Quick for assistive tech
  static const Duration screenReader = Duration(milliseconds: 100);
  
  /// Focus indicator (150ms) - Keyboard navigation feedback
  static const Duration focusIndicator = Duration(milliseconds: 150);

  // Easing Curves
  
  /// Standard ease curve - Default for most animations
  static const Curve standardEase = Curves.easeInOut;
  
  /// Gentle ease - For subtle transitions
  static const Curve gentleEase = Curves.easeOut;
  
  /// Sharp ease - For attention-grabbing animations
  static const Curve sharpEase = Curves.easeIn;
  
  /// Bounce ease - For playful feedback (use sparingly in healthcare)
  static const Curve bounceEase = Curves.elasticOut;
  
  /// Linear - For continuous animations like loading
  static const Curve linear = Curves.linear;

  // Healthcare-Specific Curves
  
  /// Emergency curve - Sharp and immediate
  static const Curve emergencyCurve = Curves.easeIn;
  
  /// Medical data curve - Smooth and professional
  static const Curve medicalDataCurve = Curves.easeInOut;
  
  /// Vital signs curve - Gentle like biological rhythms
  static const Curve vitalSignsCurve = Curves.easeInOutSine;
  
  /// Form interaction curve - Responsive and clear
  static const Curve formCurve = Curves.easeOut;

  // Stagger Delays
  
  /// Micro stagger (50ms) - For list items
  static const Duration microStagger = Duration(milliseconds: 50);
  
  /// Small stagger (100ms) - For card animations
  static const Duration smallStagger = Duration(milliseconds: 100);
  
  /// Medium stagger (150ms) - For section animations
  static const Duration mediumStagger = Duration(milliseconds: 150);
  
  /// Large stagger (200ms) - For page transitions
  static const Duration largeStagger = Duration(milliseconds: 200);

  // Medical Context Animations
  
  /// Heart rate animation parameters
  static const Duration heartRateInterval = Duration(milliseconds: 800);
  static const Curve heartRateCurve = Curves.easeInOutSine;
  
  /// Blood pressure animation parameters
  static const Duration bloodPressureAnimation = Duration(milliseconds: 600);
  static const Curve bloodPressureCurve = Curves.easeInOut;
  
  /// Temperature animation parameters
  static const Duration temperatureAnimation = Duration(milliseconds: 400);
  static const Curve temperatureCurve = Curves.easeOut;
  
  /// Medication intake animation parameters
  static const Duration medicationIntake = Duration(milliseconds: 500);
  static const Curve medicationCurve = Curves.easeInOut;

  // Page Transition Durations
  
  /// Page enter duration
  static const Duration pageEnter = Duration(milliseconds: 300);
  
  /// Page exit duration
  static const Duration pageExit = Duration(milliseconds: 200);
  
  /// Modal enter duration
  static const Duration modalEnter = Duration(milliseconds: 250);
  
  /// Modal exit duration
  static const Duration modalExit = Duration(milliseconds: 200);

  // Helper Methods
  
  /// Get duration based on animation type
  static Duration getDuration(String animationType) {
    switch (animationType.toLowerCase()) {
      case 'instant':
        return instant;
      case 'quick':
        return quick;
      case 'fast':
        return fast;
      case 'standard':
        return standard;
      case 'moderate':
        return moderate;
      case 'slow':
        return slow;
      case 'extended':
        return extended;
      default:
        return standard;
    }
  }

  /// Get curve based on animation context
  static Curve getCurve(String context) {
    switch (context.toLowerCase()) {
      case 'emergency':
        return emergencyCurve;
      case 'medical':
      case 'data':
        return medicalDataCurve;
      case 'vitals':
        return vitalSignsCurve;
      case 'form':
        return formCurve;
      case 'gentle':
        return gentleEase;
      case 'sharp':
        return sharpEase;
      default:
        return standardEase;
    }
  }

  /// Get medical animation parameters
  static Map<String, dynamic> getMedicalAnimation(String vitalType) {
    switch (vitalType.toLowerCase()) {
      case 'heart_rate':
        return {
          'duration': heartRateInterval,
          'curve': heartRateCurve,
        };
      case 'blood_pressure':
        return {
          'duration': bloodPressureAnimation,
          'curve': bloodPressureCurve,
        };
      case 'temperature':
        return {
          'duration': temperatureAnimation,
          'curve': temperatureCurve,
        };
      case 'medication':
        return {
          'duration': medicationIntake,
          'curve': medicationCurve,
        };
      default:
        return {
          'duration': standard,
          'curve': standardEase,
        };
    }
  }

  /// Get stagger delay based on index
  static Duration getStaggerDelay(int index, {Duration baseDelay = microStagger}) {
    return Duration(milliseconds: baseDelay.inMilliseconds * index);
  }

  /// Get accessibility-appropriate duration
  static Duration getAccessibleDuration(Duration baseDuration, {bool reducedMotion = false}) {
    if (reducedMotion) {
      return Duration(milliseconds: (baseDuration.inMilliseconds * 0.5).round());
    }
    return baseDuration;
  }

  /// Get emergency animation configuration
  static Map<String, dynamic> getEmergencyAnimation() {
    return {
      'duration': emergencyAlert,
      'curve': emergencyCurve,
      'repeat': true,
      'reverse': true,
    };
  }

  /// Get form validation animation
  static Map<String, dynamic> getFormValidationAnimation(bool isError) {
    return {
      'duration': formValidation,
      'curve': isError ? sharpEase : gentleEase,
    };
  }

  /// Get chart animation configuration
  static Map<String, dynamic> getChartAnimation(String chartType) {
    switch (chartType.toLowerCase()) {
      case 'line':
        return {
          'duration': chartAnimation,
          'curve': medicalDataCurve,
          'stagger': smallStagger,
        };
      case 'bar':
        return {
          'duration': moderate,
          'curve': standardEase,
          'stagger': microStagger,
        };
      case 'pie':
        return {
          'duration': slow,
          'curve': gentleEase,
        };
      default:
        return {
          'duration': chartAnimation,
          'curve': medicalDataCurve,
        };
    }
  }
}
