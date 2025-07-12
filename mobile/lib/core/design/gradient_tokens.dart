import 'package:flutter/material.dart';
import 'color_tokens.dart';

/// CareCircle Gradient Token System
///
/// Modern gradient definitions for healthcare applications.
/// All gradients maintain WCAG compliance and professional medical appearance.
class CareCircleGradientTokens {
  // Primary Healthcare Gradients

  /// Primary medical gradient - Professional blue gradient
  static const LinearGradient primaryMedical = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1976D2), // Lighter medical blue
      CareCircleColorTokens.primaryMedicalBlue,
      Color(0xFF0D47A1), // Darker medical blue
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Health success gradient - Positive health indicators
  static const LinearGradient healthSuccess = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF43A047), // Lighter green
      CareCircleColorTokens.healthGreen,
      Color(0xFF1B5E20), // Darker green
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Critical alert gradient - Emergency and critical states
  static const LinearGradient criticalAlert = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE53935), // Lighter red
      CareCircleColorTokens.criticalAlert,
      Color(0xFFB71C1C), // Darker red
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Warning gradient - Caution and attention states
  static const LinearGradient warning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF9800), // Lighter orange
      CareCircleColorTokens.warningAmber,
      Color(0xFFE65100), // Darker orange
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // AI-Specific Gradients

  /// AI assistant gradient - Distinctive styling for AI features
  static const LinearGradient aiAssistant = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7C4DFF), // Purple
      Color(0xFF536DFE), // Indigo
      Color(0xFF448AFF), // Blue
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// AI processing gradient - For loading and processing states
  static const LinearGradient aiProcessing = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF7C4DFF), Color(0xFF536DFE), Color(0xFF7C4DFF)],
    stops: [0.0, 0.5, 1.0],
  );

  /// AI chat gradient - For conversation interfaces
  static const LinearGradient aiChat = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF3E5F5), // Light purple
      Color(0xFFE1F5FE), // Light blue
    ],
    stops: [0.0, 1.0],
  );

  // Subtle Background Gradients

  /// Soft background gradient - For main screens
  static const LinearGradient softBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFAFAFA), Color(0xFFF5F5F5)],
    stops: [0.0, 1.0],
  );

  /// Card background gradient - For elevated cards
  static const LinearGradient cardBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, Color(0xFFFCFCFC)],
    stops: [0.0, 1.0],
  );

  /// Health metrics gradient - For vital signs displays
  static const LinearGradient healthMetrics = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE8F5E8), // Light green
      Color(0xFFF1F8E9), // Very light green
    ],
    stops: [0.0, 1.0],
  );

  // Medication-Specific Gradients

  /// Prescription gradient - For prescription medications
  static const LinearGradient prescription = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
    stops: [0.0, 1.0],
  );

  /// OTC gradient - For over-the-counter medications
  static const LinearGradient otc = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
    stops: [0.0, 1.0],
  );

  /// Supplement gradient - For supplements and vitamins
  static const LinearGradient supplement = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9800), Color(0xFFED6C02)],
    stops: [0.0, 1.0],
  );

  // Radial Gradients for Special Effects

  /// Floating action button gradient - For prominent action buttons
  static const RadialGradient fabGradient = RadialGradient(
    center: Alignment.topLeft,
    radius: 1.5,
    colors: [Color(0xFF1976D2), CareCircleColorTokens.primaryMedicalBlue],
    stops: [0.0, 1.0],
  );

  /// Emergency button gradient - For emergency actions
  static const RadialGradient emergencyGradient = RadialGradient(
    center: Alignment.center,
    radius: 1.2,
    colors: [Color(0xFFE53935), CareCircleColorTokens.criticalAlert],
    stops: [0.0, 1.0],
  );

  // Utility Methods

  /// Get gradient for medication type
  static LinearGradient getMedicationGradient(String medicationType) {
    switch (medicationType.toLowerCase()) {
      case 'prescription':
      case 'rx':
        return prescription;
      case 'otc':
      case 'over_the_counter':
        return otc;
      case 'supplement':
      case 'vitamin':
        return supplement;
      default:
        return prescription;
    }
  }

  /// Get gradient for urgency level
  static LinearGradient getUrgencyGradient(String urgencyLevel) {
    switch (urgencyLevel.toLowerCase()) {
      case 'critical':
      case 'emergency':
        return criticalAlert;
      case 'high':
      case 'warning':
        return warning;
      case 'normal':
      case 'good':
        return healthSuccess;
      default:
        return primaryMedical;
    }
  }

  /// Create a custom gradient with healthcare-appropriate colors
  static LinearGradient createHealthcareGradient({
    required Color primaryColor,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
    double lightenFactor = 0.1,
    double darkenFactor = 0.1,
  }) {
    final HSLColor hsl = HSLColor.fromColor(primaryColor);
    final Color lighterColor = hsl
        .withLightness((hsl.lightness + lightenFactor).clamp(0.0, 1.0))
        .toColor();
    final Color darkerColor = hsl
        .withLightness((hsl.lightness - darkenFactor).clamp(0.0, 1.0))
        .toColor();

    return LinearGradient(
      begin: begin,
      end: end,
      colors: [lighterColor, primaryColor, darkerColor],
      stops: const [0.0, 0.5, 1.0],
    );
  }
}
