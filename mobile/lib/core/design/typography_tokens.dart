import 'package:flutter/material.dart';

/// CareCircle Typography Token System
/// 
/// Comprehensive typography system optimized for medical data display and healthcare UI.
/// Supports Dynamic Type and accessibility requirements.
class CareCircleTypographyTokens {
  // Medical Data Display Typography
  
  /// Large vital signs display (e.g., main dashboard readings)
  static const TextStyle vitalSignsLarge = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// Medium vital signs display (e.g., secondary readings)
  static const TextStyle vitalSignsMedium = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.25,
    height: 1.3,
  );

  /// Small vital signs display (e.g., historical data)
  static const TextStyle vitalSignsSmall = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4,
  );

  /// Medication dosage display
  static const TextStyle medicationDosage = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    height: 1.3,
  );

  /// Medical ID numbers (patient ID, prescription numbers, etc.)
  static const TextStyle medicalId = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.4,
  );

  /// Time stamps for medical data
  static const TextStyle medicalTimestamp = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.3,
  );

  // Healthcare UI Typography

  /// Emergency button text
  static const TextStyle emergencyButton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.2,
  );

  /// Medical form labels
  static const TextStyle medicalLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.4,
  );

  /// Health metric titles
  static const TextStyle healthMetricTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.3,
  );

  /// Health metric values
  static const TextStyle healthMetricValue = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// Patient name display
  static const TextStyle patientName = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.2,
  );

  /// Medical professional name
  static const TextStyle providerName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.3,
  );

  /// Appointment time display
  static const TextStyle appointmentTime = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    height: 1.3,
  );

  /// Medical note text
  static const TextStyle medicalNote = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.5,
  );

  /// Alert message text
  static const TextStyle alertMessage = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    height: 1.4,
  );

  /// Medication name display
  static const TextStyle medicationName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.3,
  );

  /// Medication instructions
  static const TextStyle medicationInstructions = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.5,
  );

  // Complete Material Design 3 Text Theme
  static const TextTheme textTheme = TextTheme(
    // Display styles
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
    ),

    // Headline styles
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.33,
    ),

    // Title styles
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.50,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
    ),

    // Body styles
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.50,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),

    // Label styles
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
    ),
  );

  // Accessibility Typography Variants

  /// Large text for accessibility (minimum 18pt)
  static const TextStyle accessibilityLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );

  /// High contrast text style
  static const TextStyle highContrast = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    height: 1.5,
  );

  // Helper Methods

  /// Get text style for vital sign type
  static TextStyle getVitalSignStyle(String size) {
    switch (size.toLowerCase()) {
      case 'large':
        return vitalSignsLarge;
      case 'medium':
        return vitalSignsMedium;
      case 'small':
        return vitalSignsSmall;
      default:
        return vitalSignsMedium;
    }
  }

  /// Get text style with dynamic type scaling
  static TextStyle withDynamicType(TextStyle baseStyle, double scaleFactor) {
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14) * scaleFactor,
    );
  }

  /// Get high contrast variant of a text style
  static TextStyle withHighContrast(TextStyle baseStyle) {
    return baseStyle.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: (baseStyle.letterSpacing ?? 0) + 0.25,
    );
  }

  /// Get medical data text style based on urgency
  static TextStyle getMedicalDataStyle(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'emergency':
      case 'critical':
        return emergencyButton;
      case 'urgent':
      case 'high':
        return alertMessage;
      case 'normal':
      case 'routine':
        return medicalNote;
      default:
        return medicalNote;
    }
  }
}
