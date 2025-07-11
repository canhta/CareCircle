import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Advanced animation performance manager for healthcare applications
/// 
/// Features:
/// - Frame-rate aware animation scaling
/// - Battery-conscious animation management
/// - Accessibility-aware animation controls
/// - Healthcare-appropriate animation timing
/// - Performance monitoring and adaptive optimization
class AnimationPerformanceManager {
  static final AnimationPerformanceManager _instance = AnimationPerformanceManager._internal();
  factory AnimationPerformanceManager() => _instance;
  AnimationPerformanceManager._internal();

  // Performance monitoring
  final List<double> _frameTimes = [];
  final Stopwatch _frameStopwatch = Stopwatch();
  Timer? _performanceMonitorTimer;
  
  // Animation settings
  bool _animationsEnabled = true;
  bool _reducedMotion = false;
  double _animationScale = 1.0;
  bool _batteryOptimizationMode = false;
  
  // Performance thresholds
  static const double _targetFPS = 60.0;
  static const double _minimumFPS = 30.0;
  static const int _frameHistorySize = 120; // 2 seconds at 60fps
  
  // Animation presets
  static const Duration _fastDuration = Duration(milliseconds: 150);
  static const Duration _normalDuration = Duration(milliseconds: 300);
  static const Duration _slowDuration = Duration(milliseconds: 500);
  
  bool get animationsEnabled => _animationsEnabled && !_reducedMotion;
  double get animationScale => _animationScale;
  bool get isHighPerformance => _getAverageFrameRate() >= 55.0;
  
  /// Initialize the animation performance manager
  void initialize() {
    _checkAccessibilitySettings();
    _startPerformanceMonitoring();
    _setupBatteryOptimization();
  }

  /// Dispose resources
  void dispose() {
    _performanceMonitorTimer?.cancel();
    _frameStopwatch.stop();
  }

  void _checkAccessibilitySettings() {
    // Check for reduced motion preference
    final binding = WidgetsBinding.instance;
    final platformDispatcher = binding.platformDispatcher;
    
    // Note: In a real implementation, you'd check platform-specific accessibility settings
    _reducedMotion = false; // Placeholder - implement platform-specific checks
  }

  void _startPerformanceMonitoring() {
    _frameStopwatch.start();
    
    // Monitor frame performance
    WidgetsBinding.instance.addPostFrameCallback(_recordFrameTime);
    
    // Periodic performance evaluation
    _performanceMonitorTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _evaluatePerformance(),
    );
  }

  void _recordFrameTime(Duration timestamp) {
    if (_frameStopwatch.isRunning) {
      final frameTime = _frameStopwatch.elapsedMicroseconds / 1000.0; // Convert to milliseconds
      _frameTimes.add(frameTime);
      
      // Keep only recent frame times
      if (_frameTimes.length > _frameHistorySize) {
        _frameTimes.removeAt(0);
      }
    }
    
    _frameStopwatch.reset();
    _frameStopwatch.start();
    
    // Schedule next frame monitoring
    WidgetsBinding.instance.addPostFrameCallback(_recordFrameTime);
  }

  void _evaluatePerformance() {
    if (_frameTimes.length < 30) return; // Need enough data
    
    final averageFrameRate = _getAverageFrameRate();
    
    if (averageFrameRate < _minimumFPS) {
      // Performance is poor, reduce animation complexity
      _animationScale = 0.5;
      _batteryOptimizationMode = true;
    } else if (averageFrameRate < 45.0) {
      // Moderate performance, scale down slightly
      _animationScale = 0.75;
      _batteryOptimizationMode = false;
    } else if (averageFrameRate >= 55.0) {
      // Good performance, enable full animations
      _animationScale = 1.0;
      _batteryOptimizationMode = false;
    }
  }

  double _getAverageFrameRate() {
    if (_frameTimes.isEmpty) return 60.0;
    
    final averageFrameTime = _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
    return 1000.0 / averageFrameTime; // Convert to FPS
  }

  void _setupBatteryOptimization() {
    // In a real implementation, you'd check battery level and power state
    // For now, we'll use performance as a proxy
  }

  /// Get optimized duration based on current performance
  Duration getOptimizedDuration(Duration baseDuration) {
    if (!animationsEnabled) return Duration.zero;
    
    final scaledDuration = Duration(
      milliseconds: (baseDuration.inMilliseconds * _animationScale).round(),
    );
    
    // Ensure minimum duration for accessibility
    const minDuration = Duration(milliseconds: 100);
    return scaledDuration < minDuration ? minDuration : scaledDuration;
  }

  /// Get optimized curve based on performance
  Curve getOptimizedCurve(Curve baseCurve) {
    if (!animationsEnabled) return Curves.linear;
    
    if (_batteryOptimizationMode) {
      // Use simpler curves for better performance
      return Curves.easeOut;
    }
    
    return baseCurve;
  }

  /// Create performance-optimized animation
  Widget createOptimizedAnimation({
    required Widget child,
    Duration? duration,
    Curve? curve,
    Offset? slideOffset,
    double? fadeOpacity,
    double? scaleValue,
    int? delay,
  }) {
    if (!animationsEnabled) return child;
    
    final optimizedDuration = getOptimizedDuration(duration ?? _normalDuration);
    final optimizedCurve = getOptimizedCurve(curve ?? Curves.easeOut);
    final delayDuration = delay != null 
        ? Duration(milliseconds: (delay * _animationScale).round())
        : Duration.zero;
    
    Widget animatedChild = child;
    
    // Apply animations based on performance
    if (fadeOpacity != null) {
      animatedChild = animatedChild
          .animate(delay: delayDuration)
          .fadeIn(
            duration: optimizedDuration,
            curve: optimizedCurve,
            begin: fadeOpacity,
          );
    }
    
    if (slideOffset != null) {
      animatedChild = animatedChild
          .animate(delay: delayDuration)
          .slideX(
            duration: optimizedDuration,
            curve: optimizedCurve,
            begin: slideOffset.dx,
            end: 0,
          )
          .slideY(
            duration: optimizedDuration,
            curve: optimizedCurve,
            begin: slideOffset.dy,
            end: 0,
          );
    }
    
    if (scaleValue != null) {
      animatedChild = animatedChild
          .animate(delay: delayDuration)
          .scaleXY(
            duration: optimizedDuration,
            curve: optimizedCurve,
            begin: scaleValue,
            end: 1.0,
          );
    }
    
    return animatedChild;
  }

  /// Create staggered list animation
  Widget createStaggeredListAnimation({
    required Widget child,
    required int index,
    int maxStagger = 10,
  }) {
    if (!animationsEnabled) return child;
    
    final staggerDelay = (index * 50 * _animationScale).clamp(0, maxStagger * 50).round();
    
    return createOptimizedAnimation(
      child: child,
      duration: _normalDuration,
      fadeOpacity: 0.0,
      slideOffset: const Offset(0.3, 0),
      delay: staggerDelay,
    );
  }

  /// Create healthcare-appropriate loading animation
  Widget createLoadingAnimation({
    required Widget child,
    bool isPulsing = true,
  }) {
    if (!animationsEnabled) return child;
    
    if (isPulsing && !_batteryOptimizationMode) {
      return child
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scaleXY(
            duration: getOptimizedDuration(const Duration(milliseconds: 1000)),
            curve: Curves.easeInOut,
            begin: 0.95,
            end: 1.05,
          );
    }
    
    return child
        .animate(onPlay: (controller) => controller.repeat())
        .rotate(
          duration: getOptimizedDuration(const Duration(milliseconds: 2000)),
          curve: Curves.linear,
        );
  }

  /// Create interaction feedback animation
  Widget createInteractionFeedback({
    required Widget child,
    bool isPressed = false,
  }) {
    if (!animationsEnabled) return child;
    
    return child
        .animate(target: isPressed ? 1 : 0)
        .scaleXY(
          duration: getOptimizedDuration(_fastDuration),
          curve: Curves.easeInOut,
          begin: 1.0,
          end: 0.95,
        );
  }

  /// Get performance metrics for debugging
  Map<String, dynamic> getPerformanceMetrics() {
    return {
      'animationsEnabled': animationsEnabled,
      'animationScale': _animationScale,
      'averageFrameRate': _getAverageFrameRate(),
      'batteryOptimizationMode': _batteryOptimizationMode,
      'reducedMotion': _reducedMotion,
      'frameHistorySize': _frameTimes.length,
    };
  }

  /// Force enable/disable animations (for testing)
  void setAnimationsEnabled(bool enabled) {
    _animationsEnabled = enabled;
  }

  /// Set reduced motion mode
  void setReducedMotion(bool reduced) {
    _reducedMotion = reduced;
  }
}

/// Widget that provides animation performance context
class AnimationPerformanceProvider extends InheritedWidget {
  final AnimationPerformanceManager manager;

  const AnimationPerformanceProvider({
    super.key,
    required this.manager,
    required super.child,
  });

  static AnimationPerformanceManager? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AnimationPerformanceProvider>()
        ?.manager;
  }

  @override
  bool updateShouldNotify(AnimationPerformanceProvider oldWidget) {
    return manager != oldWidget.manager;
  }
}

/// Extension for easy access to animation performance manager
extension AnimationPerformanceContext on BuildContext {
  AnimationPerformanceManager get animationManager {
    return AnimationPerformanceProvider.of(this) ?? AnimationPerformanceManager();
  }
}

/// Performance-aware animated widget
class PerformanceAwareAnimatedWidget extends StatelessWidget {
  final Widget child;
  final Duration? duration;
  final Curve? curve;
  final Offset? slideOffset;
  final double? fadeOpacity;
  final double? scaleValue;
  final int? delay;

  const PerformanceAwareAnimatedWidget({
    super.key,
    required this.child,
    this.duration,
    this.curve,
    this.slideOffset,
    this.fadeOpacity,
    this.scaleValue,
    this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final manager = context.animationManager;
    
    return manager.createOptimizedAnimation(
      child: child,
      duration: duration,
      curve: curve,
      slideOffset: slideOffset,
      fadeOpacity: fadeOpacity,
      scaleValue: scaleValue,
      delay: delay,
    );
  }
}
