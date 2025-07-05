import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../common/logging/app_logger.dart';

/// Performance monitoring utility for tracking widget performance
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final AppLogger _logger = AppLogger('PerformanceMonitor');
  final Map<String, PerformanceMetrics> _metrics = {};
  bool _isEnabled = kDebugMode;

  /// Enable or disable performance monitoring
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Start tracking performance for a widget
  void startTracking(String widgetName) {
    if (!_isEnabled) return;

    _metrics[widgetName] = PerformanceMetrics(
      widgetName: widgetName,
      startTime: DateTime.now(),
    );
  }

  /// End tracking and log performance metrics
  void endTracking(String widgetName) {
    if (!_isEnabled) return;

    final metrics = _metrics[widgetName];
    if (metrics == null) return;

    final endTime = DateTime.now();
    final duration = endTime.difference(metrics.startTime);

    metrics.endTime = endTime;
    metrics.buildDuration = duration;

    // Log performance if it's slow
    if (duration.inMilliseconds > 16) {
      // More than one frame at 60fps
      _logger.warning(
        'Slow widget build detected: $widgetName took ${duration.inMilliseconds}ms',
        data: {
          'widget': widgetName,
          'duration_ms': duration.inMilliseconds,
          'frame_budget_exceeded': duration.inMilliseconds > 16,
        },
      );
    }

    _metrics.remove(widgetName);
  }

  /// Get performance summary
  Map<String, dynamic> getPerformanceSummary() {
    return {
      'active_tracking': _metrics.length,
      'monitoring_enabled': _isEnabled,
      'tracked_widgets': _metrics.keys.toList(),
    };
  }
}

/// Performance metrics for a widget
class PerformanceMetrics {
  final String widgetName;
  final DateTime startTime;
  DateTime? endTime;
  Duration? buildDuration;

  PerformanceMetrics({
    required this.widgetName,
    required this.startTime,
  });
}

/// Mixin for widgets that want to track their performance
mixin PerformanceTrackingMixin<T extends StatefulWidget> on State<T> {
  final PerformanceMonitor _monitor = PerformanceMonitor();
  String get widgetName => widget.runtimeType.toString();

  @override
  void initState() {
    super.initState();
    _monitor.startTracking(widgetName);
  }

  @override
  Widget build(BuildContext context) {
    _monitor.startTracking('${widgetName}_build');
    final widget = buildWidget(context);
    _monitor.endTracking('${widgetName}_build');
    return widget;
  }

  /// Override this instead of build() when using the mixin
  Widget buildWidget(BuildContext context);

  @override
  void dispose() {
    _monitor.endTracking(widgetName);
    super.dispose();
  }
}

/// Widget wrapper that automatically tracks performance
class PerformanceTrackedWidget extends StatelessWidget {
  final Widget child;
  final String? name;

  const PerformanceTrackedWidget({
    super.key,
    required this.child,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    final widgetName = name ?? child.runtimeType.toString();
    final monitor = PerformanceMonitor();

    monitor.startTracking(widgetName);

    return Builder(
      builder: (context) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          monitor.endTracking(widgetName);
        });
        return child;
      },
    );
  }
}

/// Performance-optimized StatefulWidget base class
abstract class PerformanceOptimizedStatefulWidget extends StatefulWidget {
  const PerformanceOptimizedStatefulWidget({super.key});

  @override
  PerformanceOptimizedState createState();
}

abstract class PerformanceOptimizedState<
        T extends PerformanceOptimizedStatefulWidget> extends State<T>
    with PerformanceTrackingMixin<T> {
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

/// Utility for measuring frame performance
class FramePerformanceTracker {
  static final FramePerformanceTracker _instance =
      FramePerformanceTracker._internal();
  factory FramePerformanceTracker() => _instance;
  FramePerformanceTracker._internal();

  final AppLogger _logger = AppLogger('FramePerformanceTracker');
  bool _isTracking = false;
  int _frameCount = 0;
  DateTime? _startTime;

  /// Start tracking frame performance
  void startTracking() {
    if (_isTracking) return;

    _isTracking = true;
    _frameCount = 0;
    _startTime = DateTime.now();

    SchedulerBinding.instance.addPersistentFrameCallback(_onFrame);
  }

  /// Stop tracking frame performance
  void stopTracking() {
    if (!_isTracking) return;

    _isTracking = false;
    // Note: Flutter doesn't provide removePersistentFrameCallback
    // The callback will stop being processed when _isTracking is false

    if (_startTime != null) {
      final duration = DateTime.now().difference(_startTime!);
      final fps = _frameCount / (duration.inMilliseconds / 1000);

      _logger.info(
        'Frame performance: ${fps.toStringAsFixed(1)} FPS over ${duration.inSeconds}s',
        data: {
          'fps': fps,
          'frame_count': _frameCount,
          'duration_seconds': duration.inSeconds,
        },
      );
    }
  }

  void _onFrame(Duration timestamp) {
    if (_isTracking) {
      _frameCount++;
    }
  }
}
