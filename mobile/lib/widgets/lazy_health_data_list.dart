import 'package:flutter/material.dart';
import '../features/health/health.dart';
import 'performance_optimized_widget.dart';

/// Lazy loading list specifically designed for health data
class LazyHealthDataList extends StatefulWidget {
  final Future<List<CareCircleHealthData>> Function(int page, int pageSize)
      onLoadData;
  final Widget Function(
      BuildContext context, CareCircleHealthData data, int index) itemBuilder;
  final int pageSize;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final ScrollController? scrollController;
  final List<CareCircleHealthDataType>? filterTypes;
  final DateTime? startDate;
  final DateTime? endDate;

  const LazyHealthDataList({
    super.key,
    required this.onLoadData,
    required this.itemBuilder,
    this.pageSize = 20,
    this.emptyWidget,
    this.errorWidget,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.scrollController,
    this.filterTypes,
    this.startDate,
    this.endDate,
  });

  @override
  State<LazyHealthDataList> createState() => _LazyHealthDataListState();
}

class _LazyHealthDataListState extends State<LazyHealthDataList> {
  final List<CareCircleHealthData> _allData = [];
  final Set<String> _loadedDataIds = {};
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  int _currentPage = 0;

  String _getDataId(CareCircleHealthData data) {
    return '${data.type.name}_${data.timestamp.millisecondsSinceEpoch}_${data.value}';
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void didUpdateWidget(LazyHealthDataList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reload data if filters changed
    if (oldWidget.filterTypes != widget.filterTypes ||
        oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      _resetAndReload();
    }
  }

  Future<void> _loadInitialData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await widget.onLoadData(0, widget.pageSize);
      final filteredData = _applyFilters(data);

      setState(() {
        _allData.clear();
        _loadedDataIds.clear();
        _allData.addAll(filteredData);
        _loadedDataIds.addAll(filteredData.map((d) => _getDataId(d)));
        _currentPage = 0;
        _hasMore = data.length >= widget.pageSize;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final nextPage = _currentPage + 1;
      final data = await widget.onLoadData(nextPage, widget.pageSize);
      final filteredData = _applyFilters(data);

      // Remove duplicates
      final newData = filteredData
          .where((d) => !_loadedDataIds.contains(_getDataId(d)))
          .toList();

      setState(() {
        _allData.addAll(newData);
        _loadedDataIds.addAll(newData.map((d) => _getDataId(d)));
        _currentPage = nextPage;
        _hasMore = data.length >= widget.pageSize;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<CareCircleHealthData> _applyFilters(List<CareCircleHealthData> data) {
    var filtered = data;

    // Filter by data types
    if (widget.filterTypes != null && widget.filterTypes!.isNotEmpty) {
      filtered =
          filtered.where((d) => widget.filterTypes!.contains(d.type)).toList();
    }

    // Filter by date range
    if (widget.startDate != null) {
      filtered = filtered
          .where((d) => d.timestamp.isAfter(widget.startDate!))
          .toList();
    }
    if (widget.endDate != null) {
      filtered =
          filtered.where((d) => d.timestamp.isBefore(widget.endDate!)).toList();
    }

    return filtered;
  }

  Future<void> _resetAndReload() async {
    setState(() {
      _allData.clear();
      _loadedDataIds.clear();
      _currentPage = 0;
      _hasMore = true;
      _error = null;
    });
    await _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    if (_allData.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_allData.isEmpty && _error != null) {
      return widget.errorWidget ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $_error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _resetAndReload,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
    }

    if (_allData.isEmpty) {
      return widget.emptyWidget ??
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.health_and_safety_outlined,
                    size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text('No health data available'),
              ],
            ),
          );
    }

    return RefreshIndicator(
      onRefresh: _resetAndReload,
      child: ListView.builder(
        controller: widget.scrollController,
        padding: widget.padding,
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        itemCount: _allData.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Load more data when approaching the end
          if (index >= _allData.length - 3 && _hasMore && !_isLoading) {
            _loadMoreData();
          }

          if (index == _allData.length) {
            // Loading indicator at the bottom
            return Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : _error != null
                      ? Column(
                          children: [
                            Text('Error: $_error'),
                            ElevatedButton(
                              onPressed: _loadMoreData,
                              child: const Text('Retry'),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
            );
          }

          // Wrap each item with performance optimization
          return PerformanceOptimizedWidget(
            useRepaintBoundary: true,
            debugLabel: 'HealthDataItem-${_getDataId(_allData[index])}',
            child: widget.itemBuilder(context, _allData[index], index),
          );
        },
      ),
    );
  }
}

/// Lazy loading chart widget for health data
class LazyHealthChart extends StatefulWidget {
  final Future<List<CareCircleHealthData>> Function(
      DateTime start, DateTime end) onLoadData;
  final Widget Function(List<CareCircleHealthData> data) chartBuilder;
  final DateTime startDate;
  final DateTime endDate;
  final Duration cacheDuration;
  final String? title;

  const LazyHealthChart({
    super.key,
    required this.onLoadData,
    required this.chartBuilder,
    required this.startDate,
    required this.endDate,
    this.cacheDuration = const Duration(minutes: 5),
    this.title,
  });

  @override
  State<LazyHealthChart> createState() => _LazyHealthChartState();
}

class _LazyHealthChartState extends State<LazyHealthChart> {
  List<CareCircleHealthData>? _cachedData;
  DateTime? _cacheTime;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  @override
  void didUpdateWidget(LazyHealthChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reload if date range changed
    if (oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      _loadChartData();
    }
  }

  bool get _isCacheValid {
    if (_cachedData == null || _cacheTime == null) return false;
    return DateTime.now().difference(_cacheTime!) < widget.cacheDuration;
  }

  Future<void> _loadChartData() async {
    if (_isCacheValid) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await widget.onLoadData(widget.startDate, widget.endDate);
      setState(() {
        _cachedData = data;
        _cacheTime = DateTime.now();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _cachedData == null) {
      return const Card(
        child: SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_error != null && _cachedData == null) {
      return Card(
        child: SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(height: 8),
                Text('Error: $_error'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _loadChartData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return OptimizedChart(
      title: widget.title,
      useRepaintBoundary: true,
      useKeepAlive: true,
      chart: widget.chartBuilder(_cachedData ?? []),
    );
  }
}
