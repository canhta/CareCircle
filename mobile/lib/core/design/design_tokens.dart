import 'package:flutter/material.dart';

class CareCircleDesignTokens {
  // Healthcare-optimized colors from design system
  static const Color primaryMedicalBlue = Color(0xFF1976D2);
  static const Color healthGreen = Color(0xFF4CAF50);
  static const Color criticalAlert = Color(0xFFD32F2F);

  // Extended color palette for notifications
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFD32F2F);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  // Background colors
  static const Color backgroundPrimary = Color(0xFFFAFAFA);
  static const Color backgroundSecondary = Color(0xFFF5F5F5);

  // Border colors
  static const Color borderLight = Color(0xFFE0E0E0);

  // Accessibility-compliant spacing
  static const double touchTargetMin = 48.0;
  static const double emergencyButtonMin = 56.0;

  // Medical data typography
  static const TextStyle vitalSignsStyle = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 32,
    fontWeight: FontWeight.w600,
  );
}
