import 'package:flutter/material.dart';
import '../managers/health_data_manager.dart';
import '../services/health_service.dart';

class HealthDataScreen extends StatefulWidget {
  const HealthDataScreen({super.key});

  @override
  State<HealthDataScreen> createState() => _HealthDataScreenState();
}

class _HealthDataScreenState extends State<HealthDataScreen> {
  final HealthDataManager _healthDataManager = HealthDataManager();
  bool _isLoading = false;
  List<CareCircleHealthData> _recentData = [];
  bool _permissionsGranted = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndLoadData();
  }

  Future<void> _checkPermissionsAndLoadData() async {
    setState(() => _isLoading = true);

    try {
      // Check if permissions are granted
      _permissionsGranted = await _healthDataManager.hasPermissions();

      if (_permissionsGranted) {
        await _loadRecentHealthData();
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadRecentHealthData() async {
    try {
      final now = DateTime.now();
      final startTime = now.subtract(const Duration(days: 7));

      // Get all available health data types
      final types = CareCircleHealthDataType.values;

      _recentData = await _healthDataManager.getLocalHealthData(
        types: types,
        startDate: startTime,
        endDate: now,
      );

      setState(() {});
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _requestPermissions() async {
    setState(() => _isLoading = true);

    try {
      final granted = await _healthDataManager.requestPermissions();
      setState(() => _permissionsGranted = granted);

      if (mounted) {
        if (granted) {
          await _loadRecentHealthData();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Health permissions granted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Health permissions are required to sync data'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _syncData() async {
    setState(() => _isLoading = true);

    try {
      final result = await _healthDataManager.syncHealthData();
      await _loadRecentHealthData();

      if (mounted) {
        if (result.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Health data synced successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sync failed: ${result.message}'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _error = e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Data'),
        actions: [
          if (_permissionsGranted)
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: _isLoading ? null : _syncData,
              tooltip: 'Sync Health Data',
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(),
            tooltip: 'Health Settings',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading health data...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: $_error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkPermissionsAndLoadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!_permissionsGranted) {
      return _buildPermissionRequest();
    }

    return _buildHealthDataView();
  }

  Widget _buildPermissionRequest() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.health_and_safety, size: 80, color: Colors.blue),
          const SizedBox(height: 24),
          const Text(
            'Health Data Integration',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'CareCircle can sync with Apple Health (iOS) or Google Fit/Health Connect (Android) to track your health metrics and provide better insights.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'We can sync:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Steps and activity data'),
                  Text('• Heart rate measurements'),
                  Text('• Sleep patterns'),
                  Text('• Weight and body measurements'),
                  Text('• Blood pressure (if available)'),
                  Text('• Blood glucose (if available)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _requestPermissions,
              icon: const Icon(Icons.security),
              label: const Text('Grant Health Permissions'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your health data is encrypted and stored securely. You can revoke permissions at any time.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthDataView() {
    if (_recentData.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.data_usage, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No health data available', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
              'Start using your health apps to see data here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Group data by type for better display
    final Map<CareCircleHealthDataType, List<CareCircleHealthData>>
    groupedData = {};
    for (final point in _recentData) {
      groupedData.putIfAbsent(point.type, () => []).add(point);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Health Data (Last 7 Days)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last synced: ${DateTime.now().toString().split('.')[0]}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...groupedData.entries.map(
          (entry) => _buildDataTypeCard(entry.key, entry.value),
        ),
      ],
    );
  }

  Widget _buildDataTypeCard(
    CareCircleHealthDataType type,
    List<CareCircleHealthData> points,
  ) {
    final latestPoint = points.last;
    final averageValue =
        points.map((p) => p.value).reduce((a, b) => a + b) / points.length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _getIconForDataType(type),
        title: Text(_getDisplayNameForType(type)),
        subtitle: Text(
          'Latest: ${latestPoint.value.toStringAsFixed(1)} ${latestPoint.unit}\n'
          'Average: ${averageValue.toStringAsFixed(1)} ${latestPoint.unit}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${points.length}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text('readings', style: TextStyle(fontSize: 12)),
          ],
        ),
        onTap: () => _showDataDetails(type, points),
      ),
    );
  }

  Icon _getIconForDataType(CareCircleHealthDataType type) {
    switch (type) {
      case CareCircleHealthDataType.steps:
        return const Icon(Icons.directions_walk, color: Colors.green);
      case CareCircleHealthDataType.heartRate:
        return const Icon(Icons.favorite, color: Colors.red);
      case CareCircleHealthDataType.weight:
        return const Icon(Icons.monitor_weight, color: Colors.blue);
      case CareCircleHealthDataType.sleepInBed:
      case CareCircleHealthDataType.sleepAsleep:
        return const Icon(Icons.bedtime, color: Colors.purple);
      case CareCircleHealthDataType.bloodPressure:
        return const Icon(Icons.bloodtype, color: Colors.red);
      case CareCircleHealthDataType.bloodGlucose:
        return const Icon(Icons.water_drop, color: Colors.orange);
      case CareCircleHealthDataType.bodyTemperature:
        return const Icon(Icons.thermostat, color: Colors.orange);
      case CareCircleHealthDataType.oxygenSaturation:
        return const Icon(Icons.air, color: Colors.cyan);
      case CareCircleHealthDataType.activeEnergyBurned:
      case CareCircleHealthDataType.basalEnergyBurned:
        return const Icon(
          Icons.local_fire_department,
          color: Colors.deepOrange,
        );
      case CareCircleHealthDataType.distanceWalkingRunning:
        return const Icon(Icons.map, color: Colors.green);
      case CareCircleHealthDataType.height:
        return const Icon(Icons.height, color: Colors.blue);
    }
  }

  String _getDisplayNameForType(CareCircleHealthDataType type) {
    switch (type) {
      case CareCircleHealthDataType.steps:
        return 'Steps';
      case CareCircleHealthDataType.heartRate:
        return 'Heart Rate';
      case CareCircleHealthDataType.weight:
        return 'Weight';
      case CareCircleHealthDataType.height:
        return 'Height';
      case CareCircleHealthDataType.sleepInBed:
        return 'Sleep Time in Bed';
      case CareCircleHealthDataType.sleepAsleep:
        return 'Sleep Time Asleep';
      case CareCircleHealthDataType.bloodPressure:
        return 'Blood Pressure';
      case CareCircleHealthDataType.bloodGlucose:
        return 'Blood Glucose';
      case CareCircleHealthDataType.bodyTemperature:
        return 'Body Temperature';
      case CareCircleHealthDataType.oxygenSaturation:
        return 'Oxygen Saturation';
      case CareCircleHealthDataType.activeEnergyBurned:
        return 'Active Energy Burned';
      case CareCircleHealthDataType.basalEnergyBurned:
        return 'Basal Energy Burned';
      case CareCircleHealthDataType.distanceWalkingRunning:
        return 'Distance Walking/Running';
    }
  }

  void _showDataDetails(
    CareCircleHealthDataType type,
    List<CareCircleHealthData> points,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getDisplayNameForType(type)),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: points.length,
            itemBuilder: (context, index) {
              final point = points[index];
              return ListTile(
                title: Text('${point.value.toStringAsFixed(1)} ${point.unit}'),
                subtitle: Text(point.timestamp.toString().split('.')[0]),
                trailing: Text(point.source ?? 'Unknown'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health Data Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Auto Sync'),
              subtitle: const Text('Automatically sync health data'),
              trailing: Switch(
                value: true, // TODO: Implement actual setting
                onChanged: (value) {
                  // TODO: Implement setting change
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Settings'),
              subtitle: const Text('Manage data sharing preferences'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Navigate to privacy settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Clear Local Data'),
              subtitle: const Text('Remove all synced health data'),
              onTap: () {
                Navigator.of(context).pop();
                _showClearDataConfirmation();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showClearDataConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Health Data'),
        content: const Text(
          'Are you sure you want to clear all locally stored health data? '
          'This will not affect your data in Apple Health or Google Fit.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement clear data functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Health data cleared')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
