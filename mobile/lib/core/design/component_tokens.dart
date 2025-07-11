import 'spacing_tokens.dart';

/// CareCircle Component Token System
///
/// Component-specific design tokens for consistent styling across the application.
/// Defines reusable component configurations for healthcare UI elements.
class CareCircleComponentTokens {
  // Button Component Tokens

  /// Standard button configuration
  static const Map<String, dynamic> standardButton = {
    'minHeight': CareCircleSpacingTokens.touchTargetMin,
    'minWidth': CareCircleSpacingTokens.touchTargetMin,
    'borderRadius': CareCircleSpacingTokens.sm,
    'paddingHorizontal': CareCircleSpacingTokens.md,
    'paddingVertical': CareCircleSpacingTokens.sm,
    'elevation': 2.0,
  };

  /// Emergency button configuration
  static const Map<String, dynamic> emergencyButton = {
    'minHeight': CareCircleSpacingTokens.emergencyButtonMin,
    'minWidth': CareCircleSpacingTokens.emergencyButtonMin,
    'borderRadius': CareCircleSpacingTokens.sm,
    'paddingHorizontal': CareCircleSpacingTokens.lg,
    'paddingVertical': CareCircleSpacingTokens.md,
    'elevation': 4.0,
  };

  /// Medication button configuration
  static const Map<String, dynamic> medicationButton = {
    'minHeight': CareCircleSpacingTokens.medicationButtonMin,
    'minWidth': CareCircleSpacingTokens.medicationButtonMin,
    'borderRadius': CareCircleSpacingTokens.sm,
    'paddingHorizontal': CareCircleSpacingTokens.md,
    'paddingVertical': CareCircleSpacingTokens.sm,
    'elevation': 2.0,
  };

  /// Floating action button configuration
  static const Map<String, dynamic> floatingActionButton = {
    'size': CareCircleSpacingTokens.emergencyButtonMin,
    'elevation': 6.0,
    'highlightElevation': 12.0,
  };

  // Card Component Tokens

  /// Standard card configuration
  static const Map<String, dynamic> standardCard = {
    'borderRadius': CareCircleSpacingTokens.sm,
    'padding': CareCircleSpacingTokens.cardPadding,
    'margin': CareCircleSpacingTokens.sm,
    'elevation': 2.0,
  };

  /// Medication card configuration
  static const Map<String, dynamic> medicationCard = {
    'borderRadius': CareCircleSpacingTokens.sm,
    'padding': CareCircleSpacingTokens.medicationCardPadding,
    'margin': CareCircleSpacingTokens.sm,
    'elevation': 2.0,
  };

  /// Appointment card configuration
  static const Map<String, dynamic> appointmentCard = {
    'borderRadius': CareCircleSpacingTokens.sm,
    'padding': CareCircleSpacingTokens.appointmentCardPadding,
    'margin': CareCircleSpacingTokens.sm,
    'elevation': 2.0,
  };

  /// Vital signs card configuration
  static const Map<String, dynamic> vitalSignsCard = {
    'borderRadius': CareCircleSpacingTokens.sm,
    'padding': CareCircleSpacingTokens.md,
    'margin': CareCircleSpacingTokens.sm,
    'elevation': 2.0,
    'minHeight': 120.0,
  };

  /// Emergency alert card configuration
  static const Map<String, dynamic> emergencyCard = {
    'borderRadius': CareCircleSpacingTokens.sm,
    'padding': CareCircleSpacingTokens.lg,
    'margin': CareCircleSpacingTokens.md,
    'elevation': 8.0,
    'borderWidth': 2.0,
  };

  // Form Component Tokens

  /// Standard form field configuration
  static const Map<String, dynamic> standardFormField = {
    'borderRadius': CareCircleSpacingTokens.sm,
    'paddingHorizontal': CareCircleSpacingTokens.formFieldPadding,
    'paddingVertical': CareCircleSpacingTokens.formFieldPadding,
    'borderWidth': 1.0,
    'focusBorderWidth': 2.0,
  };

  /// Medical form field configuration
  static const Map<String, dynamic> medicalFormField = {
    'borderRadius': CareCircleSpacingTokens.sm,
    'paddingHorizontal': CareCircleSpacingTokens.medicalFormPadding,
    'paddingVertical': CareCircleSpacingTokens.medicalFormPadding,
    'borderWidth': 1.0,
    'focusBorderWidth': 2.0,
    'minHeight': CareCircleSpacingTokens.touchTargetMin,
  };

  /// Dropdown field configuration
  static const Map<String, dynamic> dropdownField = {
    'borderRadius': CareCircleSpacingTokens.sm,
    'paddingHorizontal': CareCircleSpacingTokens.md,
    'paddingVertical': CareCircleSpacingTokens.sm,
    'borderWidth': 1.0,
    'minHeight': CareCircleSpacingTokens.touchTargetMin,
  };

  // Navigation Component Tokens

  /// Bottom navigation bar configuration
  static const Map<String, dynamic> bottomNavigationBar = {
    'height': 80.0,
    'elevation': 8.0,
    'paddingHorizontal': CareCircleSpacingTokens.navigationPadding,
    'paddingVertical': CareCircleSpacingTokens.navigationPadding,
  };

  /// App bar configuration
  static const Map<String, dynamic> appBar = {
    'height': 56.0,
    'elevation': 0.0,
    'paddingHorizontal': CareCircleSpacingTokens.md,
    'centerTitle': true,
  };

  /// Tab bar configuration
  static const Map<String, dynamic> tabBar = {
    'height': 48.0,
    'paddingHorizontal': CareCircleSpacingTokens.md,
    'indicatorWeight': 3.0,
  };

  // List Component Tokens

  /// Standard list tile configuration
  static const Map<String, dynamic> standardListTile = {
    'minHeight': CareCircleSpacingTokens.touchTargetMin,
    'paddingHorizontal': CareCircleSpacingTokens.md,
    'paddingVertical': CareCircleSpacingTokens.sm,
    'contentPadding': CareCircleSpacingTokens.sm,
  };

  /// Medical list tile configuration
  static const Map<String, dynamic> medicalListTile = {
    'minHeight': CareCircleSpacingTokens.touchTargetMin,
    'paddingHorizontal': CareCircleSpacingTokens.md,
    'paddingVertical': CareCircleSpacingTokens.md,
    'contentPadding': CareCircleSpacingTokens.sm,
  };

  // Chart Component Tokens

  /// Standard chart configuration
  static const Map<String, dynamic> standardChart = {
    'padding': CareCircleSpacingTokens.chartPadding,
    'margin': CareCircleSpacingTokens.sm,
    'borderRadius': CareCircleSpacingTokens.sm,
    'minHeight': 200.0,
  };

  /// Vital signs chart configuration
  static const Map<String, dynamic> vitalSignsChart = {
    'padding': CareCircleSpacingTokens.chartPadding,
    'margin': CareCircleSpacingTokens.sm,
    'borderRadius': CareCircleSpacingTokens.sm,
    'minHeight': 250.0,
    'legendMargin': CareCircleSpacingTokens.chartLegendMargin,
  };

  // Modal Component Tokens

  /// Standard modal configuration
  static const Map<String, dynamic> standardModal = {
    'borderRadius': CareCircleSpacingTokens.md,
    'padding': CareCircleSpacingTokens.modalPadding,
    'margin': CareCircleSpacingTokens.lg,
    'elevation': 24.0,
  };

  /// Medical modal configuration
  static const Map<String, dynamic> medicalModal = {
    'borderRadius': CareCircleSpacingTokens.md,
    'padding': CareCircleSpacingTokens.modalPadding,
    'margin': CareCircleSpacingTokens.lg,
    'elevation': 24.0,
    'barrierDismissible': false,
  };

  // Alert Component Tokens

  /// Standard alert configuration
  static const Map<String, dynamic> standardAlert = {
    'borderRadius': CareCircleSpacingTokens.sm,
    'padding': CareCircleSpacingTokens.alertPadding,
    'margin': CareCircleSpacingTokens.sm,
    'borderWidth': 1.0,
  };

  /// Emergency alert configuration
  static const Map<String, dynamic> emergencyAlert = {
    'borderRadius': CareCircleSpacingTokens.sm,
    'padding': CareCircleSpacingTokens.emergencyAlertSpacing,
    'margin': CareCircleSpacingTokens.md,
    'borderWidth': 2.0,
    'elevation': 4.0,
  };

  // Helper Methods

  /// Get button configuration by type
  static Map<String, dynamic> getButtonConfig(String buttonType) {
    switch (buttonType.toLowerCase()) {
      case 'emergency':
        return emergencyButton;
      case 'medication':
        return medicationButton;
      case 'fab':
      case 'floating':
        return floatingActionButton;
      default:
        return standardButton;
    }
  }

  /// Get card configuration by type
  static Map<String, dynamic> getCardConfig(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'medication':
        return medicationCard;
      case 'appointment':
        return appointmentCard;
      case 'vitals':
      case 'vital_signs':
        return vitalSignsCard;
      case 'emergency':
        return emergencyCard;
      default:
        return standardCard;
    }
  }

  /// Get form field configuration by type
  static Map<String, dynamic> getFormFieldConfig(String fieldType) {
    switch (fieldType.toLowerCase()) {
      case 'medical':
        return medicalFormField;
      case 'dropdown':
        return dropdownField;
      default:
        return standardFormField;
    }
  }

  /// Get chart configuration by type
  static Map<String, dynamic> getChartConfig(String chartType) {
    switch (chartType.toLowerCase()) {
      case 'vitals':
      case 'vital_signs':
        return vitalSignsChart;
      default:
        return standardChart;
    }
  }

  /// Get alert configuration by urgency
  static Map<String, dynamic> getAlertConfig(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'emergency':
      case 'critical':
        return emergencyAlert;
      default:
        return standardAlert;
    }
  }
}
