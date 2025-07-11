import 'package:flutter/material.dart';
import '../../design/spacing_tokens.dart';
import 'care_circle_breakpoints.dart';

/// Responsive grid widget optimized for healthcare UI
/// 
/// Automatically adapts column count, spacing, and aspect ratios based on screen size.
/// Follows healthcare design principles for optimal touch targets and readability.
class CareCircleResponsiveGrid extends StatelessWidget {
  const CareCircleResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio,
    this.mobileColumns = 2,
    this.tabletColumns = 3,
    this.desktopColumns = 4,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
    this.padding,
    this.semanticLabel,
  });

  final List<Widget> children;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final double? childAspectRatio;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return _buildEmptyState(context);
    }

    final breakpoint = CareCircleBreakpoints.getBreakpointFromContext(context);
    final orientationConfig = CareCircleBreakpoints.getOrientationConfig(context);
    
    return Semantics(
      label: semanticLabel ?? 'Healthcare content grid',
      child: Padding(
        padding: padding ?? _getDefaultPadding(context),
        child: GridView.builder(
          shrinkWrap: shrinkWrap,
          physics: physics,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getCrossAxisCount(breakpoint, orientationConfig),
            crossAxisSpacing: _getCrossAxisSpacing(context),
            mainAxisSpacing: _getMainAxisSpacing(context),
            childAspectRatio: _getChildAspectRatio(breakpoint),
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Semantics(
      label: 'No content available',
      child: Container(
        padding: EdgeInsets.all(CareCircleSpacingTokens.xl),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.grid_view,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: CareCircleSpacingTokens.md),
              Text(
                'No items to display',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
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

  int _getCrossAxisCount(ScreenBreakpoint breakpoint, Map<String, dynamic> orientationConfig) {
    // Use orientation-aware column count if available
    if (orientationConfig['columnCount'] != null) {
      return orientationConfig['columnCount'] as int;
    }
    
    // Fallback to breakpoint-based column count
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return mobileColumns;
      case ScreenBreakpoint.tablet:
        return tabletColumns;
      case ScreenBreakpoint.desktop:
        return desktopColumns;
    }
  }

  double _getCrossAxisSpacing(BuildContext context) {
    if (crossAxisSpacing != null) return crossAxisSpacing!;
    
    return CareCircleBreakpoints.getResponsiveSpacing(
      context,
      mobileSpacing: CareCircleSpacingTokens.sm,
      tabletSpacing: CareCircleSpacingTokens.md,
      desktopSpacing: CareCircleSpacingTokens.lg,
    );
  }

  double _getMainAxisSpacing(BuildContext context) {
    if (mainAxisSpacing != null) return mainAxisSpacing!;
    
    return CareCircleBreakpoints.getResponsiveSpacing(
      context,
      mobileSpacing: CareCircleSpacingTokens.sm,
      tabletSpacing: CareCircleSpacingTokens.md,
      desktopSpacing: CareCircleSpacingTokens.lg,
    );
  }

  double _getChildAspectRatio(ScreenBreakpoint breakpoint) {
    if (childAspectRatio != null) return childAspectRatio!;
    
    // Healthcare-optimized aspect ratios for different screen sizes
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return 1.2; // Slightly taller for mobile readability
      case ScreenBreakpoint.tablet:
        return 1.3; // More square for tablet viewing
      case ScreenBreakpoint.desktop:
        return 1.4; // Wider for desktop layouts
    }
  }
}

/// Responsive staggered grid for healthcare content with varying heights
class CareCircleStaggeredGrid extends StatelessWidget {
  const CareCircleStaggeredGrid({
    super.key,
    required this.children,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.mobileColumns = 2,
    this.tabletColumns = 3,
    this.desktopColumns = 4,
    this.padding,
    this.semanticLabel,
  });

  final List<Widget> children;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return _buildEmptyState(context);
    }

    final breakpoint = CareCircleBreakpoints.getBreakpointFromContext(context);
    final columnCount = _getColumnCount(breakpoint);
    
    return Semantics(
      label: semanticLabel ?? 'Healthcare staggered content grid',
      child: Padding(
        padding: padding ?? _getDefaultPadding(context),
        child: _buildStaggeredLayout(context, columnCount),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(CareCircleSpacingTokens.xl),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dashboard,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: CareCircleSpacingTokens.md),
            Text(
              'No content available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaggeredLayout(BuildContext context, int columnCount) {
    final columns = List.generate(columnCount, (index) => <Widget>[]);
    
    // Distribute children across columns
    for (int i = 0; i < children.length; i++) {
      final columnIndex = i % columnCount;
      columns[columnIndex].add(children[i]);
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns.map((column) => Expanded(
        child: Column(
          children: column.map((child) => Padding(
            padding: EdgeInsets.only(
              bottom: _getMainAxisSpacing(context),
              right: _getCrossAxisSpacing(context) / 2,
              left: _getCrossAxisSpacing(context) / 2,
            ),
            child: child,
          )).toList(),
        ),
      )).toList(),
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

  int _getColumnCount(ScreenBreakpoint breakpoint) {
    switch (breakpoint) {
      case ScreenBreakpoint.mobile:
        return mobileColumns;
      case ScreenBreakpoint.tablet:
        return tabletColumns;
      case ScreenBreakpoint.desktop:
        return desktopColumns;
    }
  }

  double _getCrossAxisSpacing(BuildContext context) {
    if (crossAxisSpacing != null) return crossAxisSpacing!;
    
    return CareCircleBreakpoints.getResponsiveSpacing(
      context,
      mobileSpacing: CareCircleSpacingTokens.sm,
      tabletSpacing: CareCircleSpacingTokens.md,
      desktopSpacing: CareCircleSpacingTokens.lg,
    );
  }

  double _getMainAxisSpacing(BuildContext context) {
    if (mainAxisSpacing != null) return mainAxisSpacing!;
    
    return CareCircleBreakpoints.getResponsiveSpacing(
      context,
      mobileSpacing: CareCircleSpacingTokens.sm,
      tabletSpacing: CareCircleSpacingTokens.md,
      desktopSpacing: CareCircleSpacingTokens.lg,
    );
  }
}
