// CareCircle Healthcare Performance Optimizations
// 
// Performance optimization utilities specifically designed for healthcare
// applications with large medical datasets and real-time health monitoring.

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:collection';

/// Performance optimization strategies for healthcare dashboards
class HealthDashboardOptimizations {
  static final Map<String, dynamic> _healthDataCache = {};
  static final Map<String, Timer> _cacheTimers = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);

  /// Lazy loading for health metrics with caching
  static Widget buildLazyHealthMetrics({
    required List<String> metricTypes,
    required Function(String) onMetricTap,
    required Widget Function(String, dynamic) metricBuilder,
  }) {
    return LazyIndexedStack(
      children: metricTypes.map((type) {
        return FutureBuilder<dynamic>(
          future: _loadHealthMetricData(type),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingSkeleton();
            }
            
            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error);
            }
            
            return metricBuilder(type, snapshot.data);
          },
        );
      }).toList(),
    );
  }

  /// Efficient caching for health data with automatic cleanup
  static Future<dynamic> _loadHealthMetricData(String type) async {
    final cacheKey = '${type}_${DateTime.now().day}';
    
    if (_healthDataCache.containsKey(cacheKey)) {
      return _healthDataCache[cacheKey];
    }
    
    // Simulate API call - replace with actual health data repository
    await Future.delayed(const Duration(milliseconds: 500));
    final data = _generateMockHealthData(type);
    
    _healthDataCache[cacheKey] = data;
    
    // Set cache expiry timer
    _cacheTimers[cacheKey]?.cancel();
    _cacheTimers[cacheKey] = Timer(_cacheExpiry, () {
      _healthDataCache.remove(cacheKey);
      _cacheTimers.remove(cacheKey);
    });
    
    // Clean old cache entries
    _cleanCache();
    
    return data;
  }

  /// Memory optimization for large datasets
  static List<T> downsampleData<T>(List<T> data, int maxPoints) {
    if (data.length <= maxPoints) return data;
    
    final step = data.length / maxPoints;
    final downsampled = <T>[];
    
    for (int i = 0; i < maxPoints; i++) {
      final index = (i * step).round();
      if (index < data.length) {
        downsampled.add(data[index]);
      }
    }
    
    return downsampled;
  }

  /// Optimized chart rendering for large datasets
  static Widget buildOptimizedChart({
    required List<dynamic> data,
    required String metricType,
    required Widget Function(List<dynamic>, String) chartBuilder,
  }) {
    // Downsample data for performance if dataset is large
    final optimizedData = data.length > 1000 
      ? downsampleData(data, 1000)
      : data;
    
    return chartBuilder(optimizedData, metricType);
  }

  /// Clean old cache entries to prevent memory leaks
  static void _cleanCache() {
    final now = DateTime.now();
    final keysToRemove = <String>[];
    
    for (final key in _healthDataCache.keys) {
      // Remove entries older than 1 hour
      if (key.contains('_') && 
          now.difference(DateTime.parse(key.split('_').last)).inHours > 1) {
        keysToRemove.add(key);
      }
    }
    
    for (final key in keysToRemove) {
      _healthDataCache.remove(key);
      _cacheTimers[key]?.cancel();
      _cacheTimers.remove(key);
    }
  }

  /// Loading skeleton for health metrics
  static Widget _buildLoadingSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  /// Error state for failed health data loading
  static Widget _buildErrorState(Object? error) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 8),
          const Text('Failed to load health data'),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Generate mock health data for testing
  static Map<String, dynamic> _generateMockHealthData(String type) {
    switch (type) {
      case 'heart_rate':
        return {
          'value': 72.0,
          'unit': 'bpm',
          'timestamp': DateTime.now(),
          'status': 'normal',
        };
      case 'blood_pressure':
        return {
          'systolic': 120.0,
          'diastolic': 80.0,
          'unit': 'mmHg',
          'timestamp': DateTime.now(),
          'status': 'normal',
        };
      default:
        return {
          'value': 0.0,
          'unit': '',
          'timestamp': DateTime.now(),
          'status': 'unknown',
        };
    }
  }

  /// Dispose of all cached data and timers
  static void dispose() {
    for (final timer in _cacheTimers.values) {
      timer.cancel();
    }
    _cacheTimers.clear();
    _healthDataCache.clear();
  }
}

/// Lazy IndexedStack that only builds visible children
class LazyIndexedStack extends StatefulWidget {
  const LazyIndexedStack({
    super.key,
    this.index = 0,
    required this.children,
  });

  final int index;
  final List<Widget> children;

  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  late List<bool> _activated;

  @override
  void initState() {
    super.initState();
    _activated = List<bool>.filled(widget.children.length, false);
    _activated[widget.index] = true;
  }

  @override
  void didUpdateWidget(LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _activated[widget.index] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.index,
      children: widget.children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        
        return _activated[index] ? child : const SizedBox.shrink();
      }).toList(),
    );
  }
}

/// Virtual scrolling for large medication lists
class VirtualScrollView extends StatefulWidget {
  const VirtualScrollView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemExtent = 80.0,
    this.cacheExtent = 250.0,
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final double itemExtent;
  final double cacheExtent;

  @override
  State<VirtualScrollView> createState() => _VirtualScrollViewState();
}

class _VirtualScrollViewState extends State<VirtualScrollView> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, Widget> _cachedItems = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.itemCount,
      itemExtent: widget.itemExtent,
      cacheExtent: widget.cacheExtent,
      itemBuilder: (context, index) {
        if (!_cachedItems.containsKey(index)) {
          _cachedItems[index] = widget.itemBuilder(context, index);
        }
        return _cachedItems[index]!;
      },
    );
  }
}

/// Memory-efficient image cache for medical images
class MedicalImageCache {
  static final Map<String, ImageProvider> _cache = {};
  static final Queue<String> _accessOrder = Queue<String>();
  static const int _maxCacheSize = 50;

  static ImageProvider getImage(String url) {
    if (_cache.containsKey(url)) {
      // Move to end of access order
      _accessOrder.remove(url);
      _accessOrder.addLast(url);
      return _cache[url]!;
    }

    // Add new image to cache
    final image = NetworkImage(url);
    _cache[url] = image;
    _accessOrder.addLast(url);

    // Remove oldest if cache is full
    if (_cache.length > _maxCacheSize) {
      final oldest = _accessOrder.removeFirst();
      _cache.remove(oldest);
    }

    return image;
  }

  static void clear() {
    _cache.clear();
    _accessOrder.clear();
  }
}
