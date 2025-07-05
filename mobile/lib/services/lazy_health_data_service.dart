import 'package:flutter/foundation.dart';
import '../features/health/health.dart';

/// Service for lazy loading health data with caching and pagination
class LazyHealthDataService {
  final HealthService _healthService;
  final Map<String, List<CareCircleHealthData>> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Duration _cacheDuration = const Duration(minutes: 5);

  LazyHealthDataService(this._healthService);

  /// Generate cache key for the given parameters
  String _generateCacheKey({
    int? page,
    int? pageSize,
    List<CareCircleHealthDataType>? types,
    DateTime? startDate,
    DateTime? endDate,
    String? prefix,
  }) {
    final parts = [
      prefix ?? 'health_data',
      page?.toString() ?? '',
      pageSize?.toString() ?? '',
      types?.map((t) => t.name).join(',') ?? '',
      startDate?.toIso8601String() ?? '',
      endDate?.toIso8601String() ?? '',
    ];
    return parts.join('_');
  }

  /// Check if cache is valid for the given key
  bool _isCacheValid(String key) {
    final timestamp = _cacheTimestamps[key];
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp) < _cacheDuration;
  }

  /// Get cached data or null if not available/expired
  List<CareCircleHealthData>? _getCachedData(String key) {
    if (_isCacheValid(key)) {
      return _cache[key];
    }
    return null;
  }

  /// Cache data with timestamp
  void _cacheData(String key, List<CareCircleHealthData> data) {
    _cache[key] = data;
    _cacheTimestamps[key] = DateTime.now();
  }

  /// Clear all cached data
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  /// Clear cache for specific key pattern
  void clearCachePattern(String pattern) {
    final keysToRemove =
        _cache.keys.where((key) => key.contains(pattern)).toList();
    for (final key in keysToRemove) {
      _cache.remove(key);
      _cacheTimestamps.remove(key);
    }
  }

  /// Load health data with pagination
  Future<List<CareCircleHealthData>> loadHealthData({
    int page = 0,
    int pageSize = 20,
    List<CareCircleHealthDataType>? types,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final cacheKey = _generateCacheKey(
      page: page,
      pageSize: pageSize,
      types: types,
      startDate: startDate,
      endDate: endDate,
    );

    // Try to get from cache first
    final cachedData = _getCachedData(cacheKey);
    if (cachedData != null) {
      debugPrint('LazyHealthDataService: Returning cached data for page $page');
      return cachedData;
    }

    try {
      debugPrint('LazyHealthDataService: Loading data for page $page');

      // Calculate date range if not provided
      final end = endDate ?? DateTime.now();
      final start = startDate ?? end.subtract(const Duration(days: 30));

      // Load data from health service
      final request = HealthDataRequest(
        types: types ?? CareCircleHealthDataType.values,
        startDate: start,
        endDate: end,
      );

      final result = await _healthService.getHealthDataPaginated(
        request,
        page: page,
        pageSize: pageSize,
      );

      if (result.isFailure) {
        throw Exception('Failed to load health data: ${result.exception}');
      }

      final pageData = result.data!;

      // Cache the result
      _cacheData(cacheKey, pageData);

      debugPrint(
          'LazyHealthDataService: Loaded ${pageData.length} items for page $page');
      return pageData;
    } catch (e) {
      debugPrint('LazyHealthDataService: Error loading data - $e');
      rethrow;
    }
  }

  /// Load health data for charts with date range
  Future<List<CareCircleHealthData>> loadChartData({
    required DateTime startDate,
    required DateTime endDate,
    List<CareCircleHealthDataType>? types,
  }) async {
    final cacheKey = _generateCacheKey(
      types: types,
      startDate: startDate,
      endDate: endDate,
      prefix: 'chart_data',
    );

    // Try to get from cache first
    final cachedData = _getCachedData(cacheKey);
    if (cachedData != null) {
      debugPrint('LazyHealthDataService: Returning cached chart data');
      return cachedData;
    }

    try {
      debugPrint('LazyHealthDataService: Loading chart data');

      final request = HealthDataRequest(
        types: types ?? CareCircleHealthDataType.values,
        startDate: startDate,
        endDate: endDate,
      );

      final result = await _healthService.getHealthData(request);

      if (result.isFailure) {
        throw Exception('Failed to load chart data: ${result.exception}');
      }

      final data = result.data!;

      // Sort by date for charts
      data.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      // Cache the result
      _cacheData(cacheKey, data);

      debugPrint(
          'LazyHealthDataService: Loaded ${data.length} chart data points');
      return data;
    } catch (e) {
      debugPrint('LazyHealthDataService: Error loading chart data - $e');
      rethrow;
    }
  }

  /// Load recent health data (last N days)
  Future<List<CareCircleHealthData>> loadRecentData({
    int days = 7,
    List<CareCircleHealthDataType>? types,
    int? limit,
  }) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));

    final cacheKey = _generateCacheKey(
      types: types,
      startDate: startDate,
      endDate: endDate,
      prefix: 'recent_${days}d_${limit ?? 'all'}',
    );

    // Try to get from cache first
    final cachedData = _getCachedData(cacheKey);
    if (cachedData != null) {
      debugPrint('LazyHealthDataService: Returning cached recent data');
      return cachedData;
    }

    try {
      debugPrint('LazyHealthDataService: Loading recent data ($days days)');

      final request = HealthDataRequest(
        types: types ?? CareCircleHealthDataType.values,
        startDate: startDate,
        endDate: endDate,
      );

      final result = await _healthService.getHealthData(request);

      if (result.isFailure) {
        throw Exception('Failed to load recent data: ${result.exception}');
      }

      var data = result.data!;

      // Sort by date (newest first)
      data.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Apply limit if specified
      if (limit != null && data.length > limit) {
        data = data.take(limit).toList();
      }

      // Cache the result
      _cacheData(cacheKey, data);

      debugPrint(
          'LazyHealthDataService: Loaded ${data.length} recent data points');
      return data;
    } catch (e) {
      debugPrint('LazyHealthDataService: Error loading recent data - $e');
      rethrow;
    }
  }

  /// Load aggregated data for summary cards
  Future<Map<CareCircleHealthDataType, double>> loadSummaryData({
    required DateTime startDate,
    required DateTime endDate,
    required List<CareCircleHealthDataType> types,
  }) async {
    try {
      debugPrint('LazyHealthDataService: Loading summary data');

      final request = HealthDataRequest(
        types: types,
        startDate: startDate,
        endDate: endDate,
      );

      final result = await _healthService.getHealthData(request);

      if (result.isFailure) {
        throw Exception('Failed to load summary data: ${result.exception}');
      }

      final data = result.data!;

      final summaryResult = <CareCircleHealthDataType, double>{};

      for (final type in types) {
        final typeData = data.where((d) => d.type == type).toList();
        if (typeData.isNotEmpty) {
          // Calculate appropriate aggregation based on data type
          switch (type) {
            case CareCircleHealthDataType.steps:
            case CareCircleHealthDataType.activeEnergyBurned:
              // Sum for cumulative metrics
              summaryResult[type] =
                  typeData.fold(0.0, (sum, d) => sum + d.value);
              break;
            case CareCircleHealthDataType.weight:
            case CareCircleHealthDataType.heartRate:
            case CareCircleHealthDataType.bloodPressure:
              // Average for point-in-time metrics
              summaryResult[type] =
                  typeData.fold(0.0, (sum, d) => sum + d.value) /
                      typeData.length;
              break;
            default:
              // Default to latest value
              summaryResult[type] = typeData.last.value;
          }
        }
      }

      debugPrint(
          'LazyHealthDataService: Loaded summary for ${summaryResult.length} data types');
      return summaryResult;
    } catch (e) {
      debugPrint('LazyHealthDataService: Error loading summary data - $e');
      rethrow;
    }
  }

  /// Preload data for better performance
  Future<void> preloadData({
    List<CareCircleHealthDataType>? types,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      debugPrint('LazyHealthDataService: Preloading data');

      // Preload first few pages
      await Future.wait([
        loadHealthData(
            page: 0,
            pageSize: 20,
            types: types,
            startDate: startDate,
            endDate: endDate),
        loadHealthData(
            page: 1,
            pageSize: 20,
            types: types,
            startDate: startDate,
            endDate: endDate),
      ]);

      // Preload recent data
      await loadRecentData(days: 7, types: types);

      debugPrint('LazyHealthDataService: Preloading completed');
    } catch (e) {
      debugPrint('LazyHealthDataService: Error preloading data - $e');
      // Don't rethrow for preloading errors
    }
  }
}
