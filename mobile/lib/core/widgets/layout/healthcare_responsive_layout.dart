import 'package:flutter/material.dart';
import '../../design/spacing_tokens.dart';
import 'care_circle_breakpoints.dart';

/// Healthcare-optimized responsive layout wrapper
///
/// Provides consistent layout patterns for healthcare applications with
/// proper spacing, maximum content width, and accessibility considerations.
class HealthcareResponsiveLayout extends StatelessWidget {
  const HealthcareResponsiveLayout({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.backgroundColor,
    this.centerContent = true,
    this.semanticLabel,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool centerContent;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final maxContentWidth =
        maxWidth ?? CareCircleBreakpoints.getMaxContentWidth(context);
    final responsivePadding = padding ?? _getDefaultPadding(context);

    return Semantics(
      label: semanticLabel,
      child: Container(
        color: backgroundColor,
        child: centerContent
            ? Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Padding(padding: responsivePadding, child: child),
                ),
              )
            : ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Padding(padding: responsivePadding, child: child),
              ),
      ),
    );
  }

  EdgeInsetsGeometry _getDefaultPadding(BuildContext context) {
    return CareCircleBreakpoints.getResponsivePadding(
      context,
      mobile: EdgeInsets.all(CareCircleSpacingTokens.md),
      tablet: EdgeInsets.all(CareCircleSpacingTokens.lg),
      desktop: EdgeInsets.all(CareCircleSpacingTokens.xl),
    );
  }
}

/// Responsive two-column layout for healthcare content
///
/// Automatically switches between single and two-column layouts based on screen size.
/// Optimized for healthcare data display and form layouts.
class HealthcareTwoColumnLayout extends StatelessWidget {
  const HealthcareTwoColumnLayout({
    super.key,
    required this.primaryChild,
    required this.secondaryChild,
    this.primaryFlex = 2,
    this.secondaryFlex = 1,
    this.spacing,
    this.breakpoint = ScreenBreakpoint.tablet,
    this.semanticLabel,
  });

  final Widget primaryChild;
  final Widget secondaryChild;
  final int primaryFlex;
  final int secondaryFlex;
  final double? spacing;
  final ScreenBreakpoint breakpoint;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final currentBreakpoint = CareCircleBreakpoints.getBreakpointFromContext(
      context,
    );
    final shouldUseTwoColumns = _shouldUseTwoColumns(currentBreakpoint);
    final columnSpacing = spacing ?? CareCircleSpacingTokens.lg;

    return Semantics(
      label: semanticLabel ?? 'Healthcare two-column layout',
      child: shouldUseTwoColumns
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: primaryFlex, child: primaryChild),
                SizedBox(width: columnSpacing),
                Expanded(flex: secondaryFlex, child: secondaryChild),
              ],
            )
          : Column(
              children: [
                primaryChild,
                SizedBox(height: columnSpacing),
                secondaryChild,
              ],
            ),
    );
  }

  bool _shouldUseTwoColumns(ScreenBreakpoint currentBreakpoint) {
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return false; // Never use two columns for mobile breakpoint
      case ScreenBreakpoint.tablet:
        return currentBreakpoint == ScreenBreakpoint.tablet ||
            currentBreakpoint == ScreenBreakpoint.desktop;
      case ScreenBreakpoint.desktop:
        return currentBreakpoint == ScreenBreakpoint.desktop;
    }
  }
}

/// Responsive card layout for healthcare content
///
/// Provides consistent card layouts that adapt to different screen sizes
/// with proper spacing and accessibility considerations.
class HealthcareCardLayout extends StatelessWidget {
  const HealthcareCardLayout({
    super.key,
    required this.children,
    this.crossAxisCount,
    this.spacing,
    this.childAspectRatio,
    this.semanticLabel,
  });

  final List<Widget> children;
  final int? crossAxisCount;
  final double? spacing;
  final double? childAspectRatio;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final breakpoint = CareCircleBreakpoints.getBreakpointFromContext(context);
    final columnCount = crossAxisCount ?? _getDefaultColumnCount(breakpoint);
    final cardSpacing = spacing ?? CareCircleSpacingTokens.md;
    final aspectRatio = childAspectRatio ?? _getDefaultAspectRatio(breakpoint);

    return Semantics(
      label: semanticLabel ?? 'Healthcare card layout',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          crossAxisSpacing: cardSpacing,
          mainAxisSpacing: cardSpacing,
          childAspectRatio: aspectRatio,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }

  int _getDefaultColumnCount(ScreenBreakpoint breakpoint) {
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return 1; // Single column for mobile
      case ScreenBreakpoint.tablet:
        return 2; // Two columns for tablet
      case ScreenBreakpoint.desktop:
        return 3; // Three columns for desktop
    }
  }

  double _getDefaultAspectRatio(ScreenBreakpoint breakpoint) {
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return 3.0; // Wide cards for mobile
      case ScreenBreakpoint.tablet:
        return 2.0; // Balanced cards for tablet
      case ScreenBreakpoint.desktop:
        return 1.5; // Square-ish cards for desktop
    }
  }
}

/// Responsive form layout for healthcare forms
///
/// Optimizes form layouts for different screen sizes with proper field spacing
/// and accessibility considerations.
class HealthcareFormLayout extends StatelessWidget {
  const HealthcareFormLayout({
    super.key,
    required this.children,
    this.spacing,
    this.useCompactLayout = false,
    this.semanticLabel,
  });

  final List<Widget> children;
  final double? spacing;
  final bool useCompactLayout;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final breakpoint = CareCircleBreakpoints.getBreakpointFromContext(context);
    final shouldUseCompactLayout =
        useCompactLayout || _shouldUseCompactLayout(breakpoint);
    final formSpacing = spacing ?? _getDefaultSpacing(breakpoint);

    return Semantics(
      label: semanticLabel ?? 'Healthcare form layout',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(shouldUseCompactLayout, formSpacing),
      ),
    );
  }

  List<Widget> _buildFormChildren(bool compact, double spacing) {
    final List<Widget> formChildren = [];

    for (int i = 0; i < children.length; i++) {
      formChildren.add(children[i]);

      // Add spacing between children (except after the last one)
      if (i < children.length - 1) {
        formChildren.add(SizedBox(height: compact ? spacing * 0.75 : spacing));
      }
    }

    return formChildren;
  }

  bool _shouldUseCompactLayout(ScreenBreakpoint breakpoint) {
    // Use compact layout on mobile to save space
    return breakpoint == ScreenBreakpoint.mobile;
  }

  double _getDefaultSpacing(ScreenBreakpoint breakpoint) {
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return CareCircleSpacingTokens.md; // Compact spacing for mobile
      case ScreenBreakpoint.tablet:
        return CareCircleSpacingTokens.lg; // More spacing for tablet
      case ScreenBreakpoint.desktop:
        return CareCircleSpacingTokens.xl; // Maximum spacing for desktop
    }
  }
}

/// Responsive navigation layout for healthcare apps
///
/// Adapts navigation patterns based on screen size and orientation.
class HealthcareNavigationLayout extends StatelessWidget {
  const HealthcareNavigationLayout({
    super.key,
    required this.body,
    this.navigationRail,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.useNavigationRail = false,
    this.semanticLabel,
  });

  final Widget body;
  final Widget? navigationRail;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool useNavigationRail;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final breakpoint = CareCircleBreakpoints.getBreakpointFromContext(context);
    final shouldUseRail =
        useNavigationRail && _shouldUseNavigationRail(breakpoint);

    return Semantics(
      label: semanticLabel ?? 'Healthcare navigation layout',
      child: Scaffold(
        body: shouldUseRail && navigationRail != null
            ? Row(
                children: [
                  navigationRail!,
                  Expanded(child: body),
                ],
              )
            : body,
        bottomNavigationBar: shouldUseRail ? null : bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }

  bool _shouldUseNavigationRail(ScreenBreakpoint breakpoint) {
    // Use navigation rail on tablet and desktop
    return breakpoint == ScreenBreakpoint.tablet ||
        breakpoint == ScreenBreakpoint.desktop;
  }
}
