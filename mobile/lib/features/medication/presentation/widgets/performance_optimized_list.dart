import 'dart:collection';
import 'package:flutter/material.dart';
import '../../../../core/design/design_tokens.dart';
import '../../domain/models/models.dart';
import 'medication_card.dart';

/// Advanced performance-optimized list for medication management
///
/// Features:
/// - Memory-efficient virtualization
/// - Intelligent caching and preloading
/// - Frame-rate aware rendering
/// - Adaptive performance based on device capabilities
/// - Healthcare-compliant smooth animations
class PerformanceOptimizedMedicationList extends StatefulWidget {
  final List<Medication> medications;
  final Function(Medication) onMedicationTap;
  final Function(Medication) onMedicationEdit;
  final Function(Medication) onMedicationDelete;
  final ScrollController? scrollController;
  final bool enableAnimations;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;

  const PerformanceOptimizedMedicationList({
    super.key,
    required this.medications,
    required this.onMedicationTap,
    required this.onMedicationEdit,
    required this.onMedicationDelete,
    this.scrollController,
    this.enableAnimations = true,
    this.onLoadMore,
    this.isLoadingMore = false,
  });

  @override
  State<PerformanceOptimizedMedicationList> createState() =>
      _PerformanceOptimizedMedicationListState();
}

class _PerformanceOptimizedMedicationListState
    extends State<PerformanceOptimizedMedicationList>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _staggerController;

  // Performance optimization: Cache rendered widgets
  final Map<String, Widget> _widgetCache = {};
  final LRUCache<String, Widget> _lruCache = LRUCache(maxSize: 50);

  // Performance monitoring
  final Stopwatch _renderStopwatch = Stopwatch();
  final List<double> _frameTimes = [];

  // Adaptive performance settings
  bool _highPerformanceMode = true;
  int _maxCacheSize = 50;
  Duration _animationDuration = const Duration(milliseconds: 400);

  // Viewport tracking for efficient rendering
  final Set<int> _visibleIndices = <int>{};
  final Set<int> _preloadedIndices = <int>{};

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();

    _initializePerformanceSettings();

    _staggerController = AnimationController(
      duration: _animationDuration * 3, // Stagger animation is 3x base duration
      vsync: this,
    );

    _setupScrollListener();

    // Start stagger animation
    if (widget.enableAnimations) {
      _staggerController.forward();
    }
  }

  @override
  void dispose() {
    _staggerController.dispose();
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _initializePerformanceSettings() {
    // Detect device performance capabilities
    final binding = WidgetsBinding.instance;
    final devicePixelRatio =
        binding.platformDispatcher.views.first.devicePixelRatio;

    // Adjust settings based on device capabilities
    if (devicePixelRatio > 2.0) {
      // High-DPI device, might need performance adjustments
      _maxCacheSize = 30;
      _animationDuration = const Duration(milliseconds: 300);
    }

    // Monitor frame performance
    binding.addPostFrameCallback(_monitorFramePerformance);
  }

  void _monitorFramePerformance(Duration timestamp) {
    if (_renderStopwatch.isRunning) {
      final frameTime = _renderStopwatch.elapsedMilliseconds.toDouble();
      _frameTimes.add(frameTime);

      // Keep only recent frame times
      if (_frameTimes.length > 60) {
        _frameTimes.removeAt(0);
      }

      // Adaptive performance adjustment
      final avgFrameTime =
          _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
      if (avgFrameTime > 16.67) {
        // 60fps threshold
        _adjustPerformanceSettings(false);
      } else if (avgFrameTime < 10.0) {
        _adjustPerformanceSettings(true);
      }
    }

    _renderStopwatch.reset();
    _renderStopwatch.start();

    // Schedule next frame monitoring
    WidgetsBinding.instance.addPostFrameCallback(_monitorFramePerformance);
  }

  void _adjustPerformanceSettings(bool increasePerformance) {
    if (!mounted) return;

    setState(() {
      if (increasePerformance && !_highPerformanceMode) {
        _highPerformanceMode = true;
        _maxCacheSize = 50;
        _animationDuration = const Duration(milliseconds: 400);
        _updateAnimationController();
      } else if (!increasePerformance && _highPerformanceMode) {
        _highPerformanceMode = false;
        _maxCacheSize = 20;
        _animationDuration = const Duration(milliseconds: 200);
        _updateAnimationController();
        _clearExcessCache();
      }
    });
  }

  void _updateAnimationController() {
    _staggerController.duration = _animationDuration * 3;
  }

  void _clearExcessCache() {
    if (_widgetCache.length > _maxCacheSize) {
      final keysToRemove = _widgetCache.keys.take(
        _widgetCache.length - _maxCacheSize,
      );
      for (final key in keysToRemove) {
        _widgetCache.remove(key);
      }
    }
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      _updateVisibleIndices();
      _preloadNearbyItems();
      _checkLoadMore();
    });
  }

  void _updateVisibleIndices() {
    if (!_scrollController.hasClients) return;

    final scrollOffset = _scrollController.offset;
    final viewportHeight = _scrollController.position.viewportDimension;

    // Estimate item height (can be made more precise with actual measurements)
    const estimatedItemHeight = 120.0;

    final startIndex = (scrollOffset / estimatedItemHeight).floor().clamp(
      0,
      widget.medications.length - 1,
    );
    final endIndex = ((scrollOffset + viewportHeight) / estimatedItemHeight)
        .ceil()
        .clamp(0, widget.medications.length - 1);

    _visibleIndices.clear();
    for (int i = startIndex; i <= endIndex; i++) {
      _visibleIndices.add(i);
    }
  }

  void _preloadNearbyItems() {
    const preloadBuffer = 5;
    final indicesToPreload = <int>{};

    for (final index in _visibleIndices) {
      for (
        int i = (index - preloadBuffer).clamp(0, widget.medications.length - 1);
        i <= (index + preloadBuffer).clamp(0, widget.medications.length - 1);
        i++
      ) {
        indicesToPreload.add(i);
      }
    }

    // Preload widgets for nearby items
    for (final index in indicesToPreload) {
      if (!_preloadedIndices.contains(index)) {
        _preloadWidget(index);
        _preloadedIndices.add(index);
      }
    }
  }

  void _preloadWidget(int index) {
    if (index >= widget.medications.length) return;

    final medication = widget.medications[index];
    final cacheKey = '${medication.id}_$index';

    if (!_widgetCache.containsKey(cacheKey) &&
        _widgetCache.length < _maxCacheSize) {
      final preloadWidget = _buildMedicationCard(medication, index);
      _widgetCache[cacheKey] = preloadWidget;
      _lruCache.put(cacheKey, preloadWidget);
    }
  }

  void _checkLoadMore() {
    if (widget.onLoadMore == null || widget.isLoadingMore) return;

    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentScrollOffset = _scrollController.offset;

    if (currentScrollOffset >= maxScrollExtent * 0.8) {
      widget.onLoadMore!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          _updateVisibleIndices();
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.medications.length + (widget.isLoadingMore ? 1 : 0),
        // Performance optimization: Use cached extent for consistent scrolling
        cacheExtent: 1000.0,
        itemBuilder: (context, index) {
          if (index >= widget.medications.length) {
            return _buildLoadingIndicator();
          }

          return _buildOptimizedListItem(index);
        },
      ),
    );
  }

  Widget _buildOptimizedListItem(int index) {
    final medication = widget.medications[index];
    final cacheKey = '${medication.id}_$index';

    // Try to get from cache first
    Widget? cachedWidget = _widgetCache[cacheKey] ?? _lruCache.get(cacheKey);

    if (cachedWidget != null) {
      // Update LRU cache
      _lruCache.put(cacheKey, cachedWidget);
      return cachedWidget;
    }

    // Build new widget
    final newWidget = _buildMedicationCard(medication, index);

    // Cache if we have space
    if (_widgetCache.length < _maxCacheSize) {
      _widgetCache[cacheKey] = newWidget;
      _lruCache.put(cacheKey, newWidget);
    }

    return newWidget;
  }

  Widget _buildMedicationCard(Medication medication, int index) {
    final card = RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: MedicationCard(
          medication: medication,
          animationDelay: widget.enableAnimations ? index : null,
          onTap: () => widget.onMedicationTap(medication),
          onEdit: () => widget.onMedicationEdit(medication),
          onDelete: () => widget.onMedicationDelete(medication),
        ),
      ),
    );

    // Add performance-aware animations
    if (widget.enableAnimations && _highPerformanceMode) {
      return AnimatedBuilder(
        animation: _staggerController,
        builder: (context, child) {
          final animationProgress = Curves.easeOut.transform(
            (_staggerController.value - (index * 0.1)).clamp(0.0, 1.0),
          );

          return Transform.translate(
            offset: Offset(0, 20 * (1 - animationProgress)),
            child: Opacity(opacity: animationProgress, child: card),
          );
        },
      );
    }

    return card;
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading more medications...',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }
}

/// LRU Cache implementation for widget caching
class LRUCache<K, V> {
  final int maxSize;
  final LinkedHashMap<K, V> _cache = LinkedHashMap<K, V>();

  LRUCache({required this.maxSize});

  V? get(K key) {
    if (_cache.containsKey(key)) {
      // Move to end (most recently used)
      final value = _cache.remove(key);
      if (value != null) {
        _cache[key] = value;
        return value;
      }
    }
    return null;
  }

  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    } else if (_cache.length >= maxSize) {
      // Remove least recently used
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = value;
  }

  void clear() {
    _cache.clear();
  }

  int get length => _cache.length;
}

/// Performance metrics widget for debugging
class PerformanceMetrics extends StatelessWidget {
  final List<double> frameTimes;
  final bool highPerformanceMode;
  final int cacheSize;

  const PerformanceMetrics({
    super.key,
    required this.frameTimes,
    required this.highPerformanceMode,
    required this.cacheSize,
  });

  @override
  Widget build(BuildContext context) {
    if (frameTimes.isEmpty) return const SizedBox.shrink();

    final avgFrameTime = frameTimes.reduce((a, b) => a + b) / frameTimes.length;
    final fps = 1000 / avgFrameTime;

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Performance Metrics',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'FPS: ${fps.toStringAsFixed(1)}',
            style: TextStyle(
              color: fps >= 55
                  ? Colors.green
                  : fps >= 30
                  ? Colors.orange
                  : Colors.red,
            ),
          ),
          Text(
            'Mode: ${highPerformanceMode ? "High" : "Optimized"}',
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            'Cache: $cacheSize items',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
