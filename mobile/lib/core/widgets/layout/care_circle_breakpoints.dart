import 'package:flutter/material.dart';

/// Screen breakpoint categories for responsive design
enum ScreenBreakpoint {
  /// Mobile phones (< 600px)
  mobile,

  /// Tablets (600px - 1024px)
  tablet,

  /// Desktop and large screens (> 1024px)
  desktop,
}

/// CareCircle responsive breakpoint system
///
/// Provides consistent breakpoints and responsive utilities for healthcare UI.
/// Based on Material Design 3 breakpoints with healthcare-specific optimizations.
class CareCircleBreakpoints {
  // Breakpoint values in logical pixels
  /// Mobile breakpoint threshold (600px)
  static const double mobile = 600.0;

  /// Tablet breakpoint threshold (1024px)
  static const double tablet = 1024.0;

  /// Desktop breakpoint threshold (1440px)
  static const double desktop = 1440.0;

  // Healthcare-specific breakpoints
  /// Compact mobile (< 360px) - Small phones
  static const double compactMobile = 360.0;

  /// Large mobile (480px - 600px) - Large phones
  static const double largeMobile = 480.0;

  /// Small tablet (600px - 768px) - Small tablets
  static const double smallTablet = 768.0;

  /// Large tablet (768px - 1024px) - Large tablets
  static const double largeTablet = 1024.0;

  /// Get the current screen breakpoint based on width
  static ScreenBreakpoint getBreakpoint(double width) {
    if (width < mobile) {
      return ScreenBreakpoint.mobile;
    } else if (width < tablet) {
      return ScreenBreakpoint.tablet;
    } else {
      return ScreenBreakpoint.desktop;
    }
  }

  /// Get breakpoint from BuildContext
  static ScreenBreakpoint getBreakpointFromContext(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return getBreakpoint(width);
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return getBreakpointFromContext(context) == ScreenBreakpoint.mobile;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    return getBreakpointFromContext(context) == ScreenBreakpoint.tablet;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return getBreakpointFromContext(context) == ScreenBreakpoint.desktop;
  }

  /// Check if current screen is compact mobile (very small)
  static bool isCompactMobile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < compactMobile;
  }

  /// Check if current screen is large mobile
  static bool isLargeMobile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= largeMobile && width < mobile;
  }

  /// Get optimal column count for grid layouts
  static int getOptimalColumnCount(
    BuildContext context, {
    int mobileColumns = 2,
    int tabletColumns = 3,
    int desktopColumns = 4,
  }) {
    final breakpoint = getBreakpointFromContext(context);
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return mobileColumns;
      case ScreenBreakpoint.tablet:
        return tabletColumns;
      case ScreenBreakpoint.desktop:
        return desktopColumns;
    }
  }

  /// Get optimal aspect ratio for cards
  static double getOptimalAspectRatio(
    BuildContext context, {
    double mobileRatio = 1.2,
    double tabletRatio = 1.3,
    double desktopRatio = 1.4,
  }) {
    final breakpoint = getBreakpointFromContext(context);
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return mobileRatio;
      case ScreenBreakpoint.tablet:
        return tabletRatio;
      case ScreenBreakpoint.desktop:
        return desktopRatio;
    }
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    final breakpoint = getBreakpointFromContext(context);
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return mobile ?? const EdgeInsets.all(16.0);
      case ScreenBreakpoint.tablet:
        return tablet ?? const EdgeInsets.all(24.0);
      case ScreenBreakpoint.desktop:
        return desktop ?? const EdgeInsets.all(32.0);
    }
  }

  /// Get responsive font size scaling
  static double getResponsiveFontScale(
    BuildContext context, {
    double mobileScale = 1.0,
    double tabletScale = 1.1,
    double desktopScale = 1.2,
  }) {
    final breakpoint = getBreakpointFromContext(context);
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return mobileScale;
      case ScreenBreakpoint.tablet:
        return tabletScale;
      case ScreenBreakpoint.desktop:
        return desktopScale;
    }
  }

  /// Get responsive spacing based on screen size
  static double getResponsiveSpacing(
    BuildContext context, {
    double mobileSpacing = 8.0,
    double tabletSpacing = 12.0,
    double desktopSpacing = 16.0,
  }) {
    final breakpoint = getBreakpointFromContext(context);
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return mobileSpacing;
      case ScreenBreakpoint.tablet:
        return tabletSpacing;
      case ScreenBreakpoint.desktop:
        return desktopSpacing;
    }
  }

  /// Get healthcare-specific touch target size
  static double getHealthcareTouchTarget(BuildContext context) {
    final breakpoint = getBreakpointFromContext(context);
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return 44.0; // iOS minimum
      case ScreenBreakpoint.tablet:
        return 48.0; // Larger for tablet use
      case ScreenBreakpoint.desktop:
        return 52.0; // Even larger for desktop
    }
  }

  /// Get emergency button size based on screen
  static double getEmergencyButtonSize(BuildContext context) {
    final breakpoint = getBreakpointFromContext(context);
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return 56.0; // Standard emergency size
      case ScreenBreakpoint.tablet:
        return 64.0; // Larger for tablet
      case ScreenBreakpoint.desktop:
        return 72.0; // Largest for desktop
    }
  }

  /// Get maximum content width for readability
  static double getMaxContentWidth(BuildContext context) {
    final breakpoint = getBreakpointFromContext(context);
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return double.infinity; // Full width on mobile
      case ScreenBreakpoint.tablet:
        return 768.0; // Constrained on tablet
      case ScreenBreakpoint.desktop:
        return 1200.0; // Max width on desktop
    }
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape;
  }

  /// Get orientation-aware layout configuration
  static Map<String, dynamic> getOrientationConfig(BuildContext context) {
    final isLandscapeMode = isLandscape(context);
    final breakpoint = getBreakpointFromContext(context);

    return {
      'isLandscape': isLandscapeMode,
      'breakpoint': breakpoint,
      'shouldUseTabletLayout':
          isLandscapeMode && breakpoint == ScreenBreakpoint.mobile,
      'columnCount': isLandscapeMode
          ? getOptimalColumnCount(
              context,
              mobileColumns: 3,
              tabletColumns: 4,
              desktopColumns: 5,
            )
          : getOptimalColumnCount(context),
    };
  }
}
