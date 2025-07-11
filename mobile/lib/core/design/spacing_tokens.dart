/// CareCircle Spacing Token System
/// 
/// Comprehensive spacing system based on 8px grid with healthcare-specific considerations.
/// Ensures accessibility compliance and consistent visual rhythm.
class CareCircleSpacingTokens {
  // Base 8px Grid System
  /// Base unit for all spacing calculations (8px)
  static const double baseUnit = 8.0;

  // Core Spacing Scale
  /// No spacing (0px)
  static const double none = 0.0;
  
  /// Extra small spacing (4px) - baseUnit * 0.5
  static const double xs = baseUnit * 0.5; // 4px
  
  /// Small spacing (8px) - baseUnit * 1
  static const double sm = baseUnit * 1; // 8px
  
  /// Medium spacing (16px) - baseUnit * 2
  static const double md = baseUnit * 2; // 16px
  
  /// Large spacing (24px) - baseUnit * 3
  static const double lg = baseUnit * 3; // 24px
  
  /// Extra large spacing (32px) - baseUnit * 4
  static const double xl = baseUnit * 4; // 32px
  
  /// Double extra large spacing (48px) - baseUnit * 6
  static const double xxl = baseUnit * 6; // 48px
  
  /// Triple extra large spacing (64px) - baseUnit * 8
  static const double xxxl = baseUnit * 8; // 64px

  // Healthcare-Specific Touch Targets
  
  /// Minimum touch target for iOS (44px) - Apple HIG requirement
  static const double touchTargetMin = 44.0;
  
  /// Minimum touch target for Android (48px) - Material Design requirement
  static const double touchTargetAndroid = 48.0;
  
  /// Emergency button minimum size (56px) - Enhanced for critical actions
  static const double emergencyButtonMin = 56.0;
  
  /// Medication interaction minimum size (52px) - Important medical actions
  static const double medicationButtonMin = 52.0;
  
  /// Vital signs interaction minimum size (48px) - Standard medical data
  static const double vitalSignsButtonMin = 48.0;

  // Medical Component Spacing
  
  /// Padding for medication cards
  static const double medicationCardPadding = md; // 16px
  
  /// Spacing between vital signs elements
  static const double vitalSignsSpacing = lg; // 24px
  
  /// Padding for appointment cards
  static const double appointmentCardPadding = md; // 16px
  
  /// Spacing for emergency action areas
  static const double emergencySpacing = xl; // 32px
  
  /// Padding for medical forms
  static const double medicalFormPadding = md; // 16px
  
  /// Spacing between health metrics
  static const double healthMetricSpacing = lg; // 24px

  // Layout Spacing
  
  /// Standard screen edge padding
  static const double screenPadding = md; // 16px
  
  /// Screen padding for tablets/large screens
  static const double screenPaddingLarge = xl; // 32px
  
  /// Standard card padding
  static const double cardPadding = md; // 16px
  
  /// Spacing between major sections
  static const double sectionSpacing = xl; // 32px
  
  /// Spacing between related components
  static const double componentSpacing = sm; // 8px
  
  /// Spacing between list items
  static const double listItemSpacing = xs; // 4px
  
  /// Padding for navigation areas
  static const double navigationPadding = sm; // 8px

  // Form Spacing
  
  /// Spacing between form fields
  static const double formFieldSpacing = md; // 16px
  
  /// Spacing between form sections
  static const double formSectionSpacing = xl; // 32px
  
  /// Spacing between buttons in forms
  static const double buttonSpacing = md; // 16px
  
  /// Padding inside form fields
  static const double formFieldPadding = md; // 16px
  
  /// Spacing for form labels
  static const double formLabelSpacing = xs; // 4px

  // Chart and Data Visualization Spacing
  
  /// Padding around charts
  static const double chartPadding = md; // 16px
  
  /// Spacing between chart elements
  static const double chartElementSpacing = sm; // 8px
  
  /// Margin for chart legends
  static const double chartLegendMargin = lg; // 24px
  
  /// Spacing for data points
  static const double dataPointSpacing = xs; // 4px

  // Modal and Dialog Spacing
  
  /// Padding for modal content
  static const double modalPadding = lg; // 24px
  
  /// Spacing between modal elements
  static const double modalElementSpacing = md; // 16px
  
  /// Padding for dialog content
  static const double dialogPadding = lg; // 24px
  
  /// Spacing for dialog actions
  static const double dialogActionSpacing = sm; // 8px

  // Notification and Alert Spacing
  
  /// Padding for notification content
  static const double notificationPadding = md; // 16px
  
  /// Spacing between notification elements
  static const double notificationElementSpacing = sm; // 8px
  
  /// Padding for alert banners
  static const double alertPadding = md; // 16px
  
  /// Spacing for emergency alerts
  static const double emergencyAlertSpacing = lg; // 24px

  // Accessibility Spacing
  
  /// Minimum spacing for screen reader navigation
  static const double accessibilityMinSpacing = sm; // 8px
  
  /// Enhanced spacing for high contrast mode
  static const double highContrastSpacing = md; // 16px
  
  /// Focus indicator padding
  static const double focusPadding = xs; // 4px

  // Responsive Breakpoint Spacing
  
  /// Compact screen spacing (phones)
  static const double compactSpacing = sm; // 8px
  
  /// Medium screen spacing (tablets)
  static const double mediumSpacing = md; // 16px
  
  /// Expanded screen spacing (desktop)
  static const double expandedSpacing = lg; // 24px

  // Helper Methods
  
  /// Get appropriate touch target size based on platform
  static double getTouchTargetSize(bool isAndroid) {
    return isAndroid ? touchTargetAndroid : touchTargetMin;
  }

  /// Get spacing based on screen size category
  static double getResponsiveSpacing(String screenSize) {
    switch (screenSize.toLowerCase()) {
      case 'compact':
        return compactSpacing;
      case 'medium':
        return mediumSpacing;
      case 'expanded':
        return expandedSpacing;
      default:
        return mediumSpacing;
    }
  }

  /// Get medical component spacing based on urgency
  static double getMedicalSpacing(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'emergency':
      case 'critical':
        return emergencySpacing;
      case 'urgent':
      case 'high':
        return lg;
      case 'normal':
      case 'routine':
        return md;
      default:
        return md;
    }
  }

  /// Get form spacing based on field type
  static double getFormSpacing(String fieldType) {
    switch (fieldType.toLowerCase()) {
      case 'section':
        return formSectionSpacing;
      case 'field':
        return formFieldSpacing;
      case 'button':
        return buttonSpacing;
      case 'label':
        return formLabelSpacing;
      default:
        return formFieldSpacing;
    }
  }

  /// Calculate spacing with accessibility multiplier
  static double getAccessibleSpacing(double baseSpacing, {bool highContrast = false}) {
    if (highContrast) {
      return baseSpacing * 1.5;
    }
    return baseSpacing;
  }

  /// Get minimum button size for medical action type
  static double getMedicalButtonSize(String actionType) {
    switch (actionType.toLowerCase()) {
      case 'emergency':
        return emergencyButtonMin;
      case 'medication':
        return medicationButtonMin;
      case 'vitals':
        return vitalSignsButtonMin;
      default:
        return touchTargetMin;
    }
  }

  /// Get chart spacing based on data density
  static double getChartSpacing(String density) {
    switch (density.toLowerCase()) {
      case 'dense':
        return xs;
      case 'normal':
        return sm;
      case 'sparse':
        return md;
      default:
        return sm;
    }
  }
}
