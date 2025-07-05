import 'package:flutter/material.dart';

/// A widget that wraps expensive widgets with performance optimizations
class PerformanceOptimizedWidget extends StatelessWidget {
  final Widget child;
  final bool useRepaintBoundary;
  final bool useKeepAlive;
  final String? debugLabel;

  const PerformanceOptimizedWidget({
    super.key,
    required this.child,
    this.useRepaintBoundary = true,
    this.useKeepAlive = false,
    this.debugLabel,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget = child;

    // Add RepaintBoundary for expensive widgets
    if (useRepaintBoundary) {
      widget = RepaintBoundary(
        child: widget,
      );
    }

    // Add AutomaticKeepAlive for widgets that should stay alive
    if (useKeepAlive) {
      widget = AutomaticKeepAliveWrapper(
        child: widget,
      );
    }

    return widget;
  }
}

/// Widget to add AutomaticKeepAlive functionality
class AutomaticKeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const AutomaticKeepAliveWrapper({
    super.key,
    required this.child,
  });

  @override
  State<AutomaticKeepAliveWrapper> createState() =>
      _AutomaticKeepAliveWrapperState();
}

class _AutomaticKeepAliveWrapperState extends State<AutomaticKeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

/// Optimized list item widget with performance enhancements
class OptimizedListItem extends StatelessWidget {
  final Widget child;
  final Key? itemKey;
  final int? index;
  final bool useRepaintBoundary;

  const OptimizedListItem({
    super.key,
    required this.child,
    this.itemKey,
    this.index,
    this.useRepaintBoundary = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget = child;

    // Add key for efficient list updates
    if (itemKey != null) {
      widget = KeyedSubtree(
        key: itemKey,
        child: widget,
      );
    }

    // Add RepaintBoundary for complex list items
    if (useRepaintBoundary) {
      widget = RepaintBoundary(
        child: widget,
      );
    }

    return widget;
  }
}

/// Optimized chart widget wrapper
class OptimizedChart extends StatelessWidget {
  final Widget chart;
  final String? title;
  final bool useRepaintBoundary;
  final bool useKeepAlive;

  const OptimizedChart({
    super.key,
    required this.chart,
    this.title,
    this.useRepaintBoundary = true,
    this.useKeepAlive = false,
  });

  @override
  Widget build(BuildContext context) {
    return PerformanceOptimizedWidget(
      useRepaintBoundary: useRepaintBoundary,
      useKeepAlive: useKeepAlive,
      debugLabel: title != null ? 'Chart: $title' : 'Chart',
      child: chart,
    );
  }
}

/// Optimized image widget with memory management
class OptimizedImageWidget extends StatelessWidget {
  final Widget image;
  final double? width;
  final double? height;
  final bool useRepaintBoundary;

  const OptimizedImageWidget({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.useRepaintBoundary = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget = image;

    // Add size constraints to prevent layout thrashing
    if (width != null || height != null) {
      widget = SizedBox(
        width: width,
        height: height,
        child: widget,
      );
    }

    // Add RepaintBoundary for images
    if (useRepaintBoundary) {
      widget = RepaintBoundary(
        child: widget,
      );
    }

    return widget;
  }
}

/// Mixin for widgets that need to optimize rebuilds
mixin OptimizedRebuildMixin<T extends StatefulWidget> on State<T> {
  /// Override this to control when the widget should rebuild
  bool shouldRebuild(T oldWidget) {
    return widget != oldWidget;
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!shouldRebuild(oldWidget)) {
      return;
    }
  }
}

/// Optimized stateful widget base class
abstract class OptimizedStatefulWidget extends StatefulWidget {
  const OptimizedStatefulWidget({super.key});

  @override
  OptimizedState createState();
}

abstract class OptimizedState<T extends OptimizedStatefulWidget>
    extends State<T> with OptimizedRebuildMixin<T> {
  /// Override this method to implement the widget's build logic
  Widget buildOptimized(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return buildOptimized(context);
  }
}

/// Performance monitoring widget for debugging
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final String? label;
  final bool enabled;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.label,
    this.enabled = false, // Only enable in debug mode
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  int _buildCount = 0;
  DateTime? _lastBuildTime;

  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
      _buildCount++;
      final now = DateTime.now();
      if (_lastBuildTime != null) {
        final timeSinceLastBuild = now.difference(_lastBuildTime!);
        debugPrint(
          'PerformanceMonitor[${widget.label ?? 'Unknown'}]: '
          'Build #$_buildCount, Time since last build: ${timeSinceLastBuild.inMilliseconds}ms',
        );
      }
      _lastBuildTime = now;
    }

    return widget.child;
  }
}
