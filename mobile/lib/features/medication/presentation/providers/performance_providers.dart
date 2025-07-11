import 'dart:async';
import 'dart:collection';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../../infrastructure/repositories/medication_repository.dart';

/// Performance-optimized providers for medication management
/// 
/// Features:
/// - Memory-efficient caching
/// - Intelligent data prefetching
/// - Automatic cache invalidation
/// - Performance monitoring
/// - Healthcare-compliant data handling

// Healthcare-compliant logger for medication context
final _logger = BoundedContextLoggers.medication;

/// Memory-efficient medication cache manager
class MedicationCacheManager {
  static final MedicationCacheManager _instance = MedicationCacheManager._internal();
  factory MedicationCacheManager() => _instance;
  MedicationCacheManager._internal();

  final Map<String, Medication> _medicationCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Map<String, List<Medication>> _listCache = {};
  final Queue<String> _accessOrder = Queue<String>();
  
  static const int _maxCacheSize = 100;
  static const Duration _cacheExpiry = Duration(minutes: 15);
  
  Timer? _cleanupTimer;

  void initialize() {
    // Start periodic cache cleanup
    _cleanupTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _performCacheCleanup(),
    );
  }

  void dispose() {
    _cleanupTimer?.cancel();
    clearAll();
  }

  /// Cache a single medication
  void cacheMedication(Medication medication) {
    final key = medication.id;
    
    // Remove if already exists to update access order
    if (_medicationCache.containsKey(key)) {
      _accessOrder.remove(key);
    }
    
    // Add to cache
    _medicationCache[key] = medication;
    _cacheTimestamps[key] = DateTime.now();
    _accessOrder.addLast(key);
    
    // Enforce cache size limit
    _enforceCacheLimit();
    
    _logger.debug('Cached medication: ${medication.name}');
  }

  /// Cache a list of medications
  void cacheMedicationList(String cacheKey, List<Medication> medications) {
    _listCache[cacheKey] = medications;
    _cacheTimestamps[cacheKey] = DateTime.now();
    
    // Also cache individual medications
    for (final medication in medications) {
      cacheMedication(medication);
    }
    
    _logger.debug('Cached medication list: $cacheKey (${medications.length} items)');
  }

  /// Get cached medication
  Medication? getCachedMedication(String id) {
    if (!_medicationCache.containsKey(id)) return null;
    
    final timestamp = _cacheTimestamps[id];
    if (timestamp == null || _isCacheExpired(timestamp)) {
      _removeCachedItem(id);
      return null;
    }
    
    // Update access order
    _accessOrder.remove(id);
    _accessOrder.addLast(id);
    
    return _medicationCache[id];
  }

  /// Get cached medication list
  List<Medication>? getCachedMedicationList(String cacheKey) {
    if (!_listCache.containsKey(cacheKey)) return null;
    
    final timestamp = _cacheTimestamps[cacheKey];
    if (timestamp == null || _isCacheExpired(timestamp)) {
      _listCache.remove(cacheKey);
      _cacheTimestamps.remove(cacheKey);
      return null;
    }
    
    return _listCache[cacheKey];
  }

  /// Invalidate specific medication
  void invalidateMedication(String id) {
    _removeCachedItem(id);
    
    // Also invalidate lists that might contain this medication
    final keysToRemove = <String>[];
    for (final entry in _listCache.entries) {
      if (entry.value.any((med) => med.id == id)) {
        keysToRemove.add(entry.key);
      }
    }
    
    for (final key in keysToRemove) {
      _listCache.remove(key);
      _cacheTimestamps.remove(key);
    }
    
    _logger.debug('Invalidated medication cache: $id');
  }

  /// Clear all cache
  void clearAll() {
    _medicationCache.clear();
    _listCache.clear();
    _cacheTimestamps.clear();
    _accessOrder.clear();
    _logger.debug('Cleared all medication cache');
  }

  void _enforceCacheLimit() {
    while (_medicationCache.length > _maxCacheSize && _accessOrder.isNotEmpty) {
      final oldestKey = _accessOrder.removeFirst();
      _removeCachedItem(oldestKey);
    }
  }

  void _removeCachedItem(String key) {
    _medicationCache.remove(key);
    _cacheTimestamps.remove(key);
    _accessOrder.remove(key);
  }

  bool _isCacheExpired(DateTime timestamp) {
    return DateTime.now().difference(timestamp) > _cacheExpiry;
  }

  void _performCacheCleanup() {
    final now = DateTime.now();
    final expiredKeys = <String>[];
    
    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value) > _cacheExpiry) {
        expiredKeys.add(entry.key);
      }
    }
    
    for (final key in expiredKeys) {
      _removeCachedItem(key);
      _listCache.remove(key);
    }
    
    if (expiredKeys.isNotEmpty) {
      _logger.debug('Cleaned up ${expiredKeys.length} expired cache entries');
    }
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'medicationCacheSize': _medicationCache.length,
      'listCacheSize': _listCache.length,
      'totalCacheSize': _medicationCache.length + _listCache.length,
      'maxCacheSize': _maxCacheSize,
      'cacheHitRatio': _calculateCacheHitRatio(),
    };
  }

  double _calculateCacheHitRatio() {
    // This would need to be tracked over time in a real implementation
    return 0.85; // Placeholder
  }
}

/// Provider for cache manager
final cacheManagerProvider = Provider<MedicationCacheManager>((ref) {
  final manager = MedicationCacheManager();
  manager.initialize();
  
  ref.onDispose(() {
    manager.dispose();
  });
  
  return manager;
});

/// Performance-optimized medication provider with intelligent caching
final performanceOptimizedMedicationsProvider = FutureProvider<List<Medication>>((ref) async {
  final repository = ref.read(medicationRepositoryProvider);
  final cacheManager = ref.read(cacheManagerProvider);
  
  const cacheKey = 'all_medications';
  
  // Try cache first
  final cached = cacheManager.getCachedMedicationList(cacheKey);
  if (cached != null) {
    _logger.debug('Returning cached medications (${cached.length} items)');
    return cached;
  }
  
  // Fetch from repository
  _logger.debug('Fetching medications from repository');
  final medications = await repository.getMedications();
  
  // Cache the results
  cacheManager.cacheMedicationList(cacheKey, medications);
  
  return medications;
});

/// Performance-optimized filtered medications provider
final performanceOptimizedFilteredMedicationsProvider = Provider<AsyncValue<List<Medication>>>((ref) {
  final medicationsAsync = ref.watch(performanceOptimizedMedicationsProvider);
  final searchTerm = ref.watch(performanceMedicationSearchTermProvider);
  final formFilter = ref.watch(performanceMedicationFormFilterProvider);
  final activeFilter = ref.watch(performanceMedicationActiveFilterProvider);
  
  return medicationsAsync.when(
    data: (medications) {
      // Use efficient filtering
      final filtered = _performEfficientFiltering(
        medications,
        searchTerm,
        formFilter,
        activeFilter,
      );
      
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

/// Efficient filtering implementation
List<Medication> _performEfficientFiltering(
  List<Medication> medications,
  String searchTerm,
  MedicationForm? formFilter,
  bool? activeFilter,
) {
  if (searchTerm.isEmpty && formFilter == null && activeFilter == null) {
    return medications;
  }
  
  final searchLower = searchTerm.toLowerCase();
  
  return medications.where((medication) {
    // Active filter (most selective, check first)
    if (activeFilter != null && medication.isActive != activeFilter) {
      return false;
    }
    
    // Form filter
    if (formFilter != null && medication.form != formFilter) {
      return false;
    }
    
    // Search term filter (most expensive, check last)
    if (searchTerm.isNotEmpty) {
      final nameMatch = medication.name.toLowerCase().contains(searchLower);
      final genericMatch = medication.genericName?.toLowerCase().contains(searchLower) ?? false;
      
      if (!nameMatch && !genericMatch) {
        return false;
      }
    }
    
    return true;
  }).toList();
}

/// Provider for medication prefetching
final medicationPrefetchProvider = Provider<void>((ref) {
  final cacheManager = ref.read(cacheManagerProvider);
  
  // Prefetch commonly accessed data
  Timer(const Duration(milliseconds: 500), () async {
    try {
      final repository = ref.read(medicationRepositoryProvider);
      
      // Prefetch active medications
      final activeMedications = await repository.getMedications(
        params: const MedicationQueryParams(isActive: true),
      );
      cacheManager.cacheMedicationList('active_medications', activeMedications);
      
      // Prefetch recent medications (if we had that data)
      _logger.debug('Prefetched medication data');
    } catch (e) {
      _logger.warning('Failed to prefetch medication data: $e');
    }
  });
});

/// Provider for performance monitoring
final medicationPerformanceProvider = StateNotifierProvider<MedicationPerformanceNotifier, MedicationPerformanceState>((ref) {
  return MedicationPerformanceNotifier();
});

class MedicationPerformanceState {
  final Map<String, Duration> operationTimes;
  final Map<String, int> operationCounts;
  final DateTime lastUpdate;

  const MedicationPerformanceState({
    this.operationTimes = const {},
    this.operationCounts = const {},
    required this.lastUpdate,
  });

  MedicationPerformanceState copyWith({
    Map<String, Duration>? operationTimes,
    Map<String, int>? operationCounts,
    DateTime? lastUpdate,
  }) {
    return MedicationPerformanceState(
      operationTimes: operationTimes ?? this.operationTimes,
      operationCounts: operationCounts ?? this.operationCounts,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

class MedicationPerformanceNotifier extends StateNotifier<MedicationPerformanceState> {
  MedicationPerformanceNotifier() : super(MedicationPerformanceState(lastUpdate: DateTime.now()));

  void recordOperation(String operation, Duration duration) {
    final newOperationTimes = Map<String, Duration>.from(state.operationTimes);
    final newOperationCounts = Map<String, int>.from(state.operationCounts);
    
    newOperationTimes[operation] = duration;
    newOperationCounts[operation] = (newOperationCounts[operation] ?? 0) + 1;
    
    state = state.copyWith(
      operationTimes: newOperationTimes,
      operationCounts: newOperationCounts,
      lastUpdate: DateTime.now(),
    );
    
    _logger.debug('Recorded operation: $operation took ${duration.inMilliseconds}ms');
  }

  Map<String, double> getAverageOperationTimes() {
    final averages = <String, double>{};
    
    for (final operation in state.operationTimes.keys) {
      final totalTime = state.operationTimes[operation]!.inMilliseconds.toDouble();
      final count = state.operationCounts[operation] ?? 1;
      averages[operation] = totalTime / count;
    }
    
    return averages;
  }
}

/// State providers for medication management (performance-optimized versions)
final performanceMedicationSearchTermProvider = StateProvider<String>((ref) => '');
final performanceMedicationFormFilterProvider = StateProvider<MedicationForm?>((ref) => null);
final performanceMedicationActiveFilterProvider = StateProvider<bool?>((ref) => null);
