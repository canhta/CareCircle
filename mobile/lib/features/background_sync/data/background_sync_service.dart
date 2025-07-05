import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../common/common.dart';
import '../domain/background_sync_models.dart';
import '../domain/background_sync_repository.dart';

/// Background sync service implementation
class BackgroundSyncService extends BaseRepository
    implements BackgroundSyncRepository {
  static const String _configKey = 'background_sync_config';
  static const String _lastSyncKey = 'last_background_sync';
  static const String _tasksKey = 'background_sync_tasks';
  static const String _statisticsKey = 'background_sync_statistics';

  final SecureStorageService _secureStorage;
  final Connectivity _connectivity;

  bool _isInitialized = false;

  BackgroundSyncService({
    required super.apiClient,
    required super.logger,
    required SecureStorageService secureStorage,
  })  : _secureStorage = secureStorage,
        _connectivity = Connectivity();

  /// Generate a unique ID for sync tasks
  String _generateTaskId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }

  @override
  Future<Result<void>> initialize() async {
    try {
      if (_isInitialized) return const Result.success(null);

      logger.info('Initializing background sync service');

      // Initialize default configuration if not exists
      final configResult = await getSyncConfiguration();
      if (configResult.isFailure) {
        const defaultConfig = SyncConfiguration();
        await updateSyncConfiguration(defaultConfig);
      }

      _isInitialized = true;
      logger.info('Background sync service initialized successfully');
      return const Result.success(null);
    } catch (e) {
      logger.error('Failed to initialize background sync service', error: e);
      return Result.failure(
        NetworkException('Failed to initialize background sync service: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> registerPeriodicSync({
    SyncConfiguration? configuration,
  }) async {
    try {
      logger.info('Registering periodic sync');

      if (!_isInitialized) {
        final initResult = await initialize();
        if (initResult.isFailure) {
          return Result.failure(initResult.exception!);
        }
      }

      final config = configuration ?? const SyncConfiguration();
      await updateSyncConfiguration(config);

      // Note: In a real implementation, you would integrate with WorkManager
      // For now, we'll just store the configuration
      logger.info(
          'Periodic sync registered with ${config.frequency.inHours}h frequency');
      return const Result.success(null);
    } catch (e) {
      logger.error('Error registering periodic sync', error: e);
      return Result.failure(
        NetworkException('Failed to register periodic sync: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> registerOneTimeSync({
    SyncTaskType type = SyncTaskType.general,
    Duration? delay,
    Map<String, dynamic>? data,
  }) async {
    try {
      logger.info('Registering one-time sync', data: {
        'type': type.name,
        'delay': delay?.inSeconds,
      });

      final task = SyncTask(
        id: _generateTaskId(),
        type: type,
        status: SyncStatus.pending,
        createdAt: DateTime.now(),
        data: data,
      );

      final tasksResult = await _getSyncTasks();
      final tasks = tasksResult.data ?? <SyncTask>[];
      tasks.add(task);
      await _saveSyncTasks(tasks);

      logger.info('One-time sync task created');
      return const Result.success(null);
    } catch (e) {
      logger.error('Error registering one-time sync', error: e);
      return Result.failure(
        NetworkException('Failed to register one-time sync: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> registerRetrySync({
    Duration delay = const Duration(minutes: 15),
    SyncTaskType? type,
  }) async {
    try {
      logger.info('Registering retry sync', data: {
        'delay': delay.inMinutes,
        'type': type?.name,
      });

      return await registerOneTimeSync(
        type: type ?? SyncTaskType.general,
        delay: delay,
        data: {'isRetry': true},
      );
    } catch (e) {
      logger.error('Error registering retry sync', error: e);
      return Result.failure(
        NetworkException('Failed to register retry sync: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> cancelAllSyncTasks() async {
    try {
      logger.info('Cancelling all sync tasks');

      await _saveSyncTasks(<SyncTask>[]);
      logger.info('All sync tasks cancelled');
      return const Result.success(null);
    } catch (e) {
      logger.error('Error cancelling sync tasks', error: e);
      return Result.failure(
        NetworkException('Failed to cancel sync tasks: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> cancelSyncTask(String taskId) async {
    try {
      logger.info('Cancelling sync task', data: {'taskId': taskId});

      final tasksResult = await _getSyncTasks();
      if (tasksResult.isFailure) {
        return Result.failure(tasksResult.exception!);
      }

      final tasks = tasksResult.data!;
      final updatedTasks = tasks
          .map((task) => task.id == taskId
              ? task.copyWith(status: SyncStatus.cancelled)
              : task)
          .toList();

      await _saveSyncTasks(updatedTasks);
      logger.info('Sync task cancelled');
      return const Result.success(null);
    } catch (e) {
      logger.error('Error cancelling sync task', error: e);
      return Result.failure(
        NetworkException('Failed to cancel sync task: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<SyncStatistics>> getSyncStatistics() async {
    try {
      logger.info('Getting sync statistics');

      final tasksResult = await _getSyncTasks();
      final tasks = tasksResult.data ?? <SyncTask>[];

      final totalTasks = tasks.length;
      final pendingTasks =
          tasks.where((t) => t.status == SyncStatus.pending).length;
      final completedTasks =
          tasks.where((t) => t.status == SyncStatus.completed).length;
      final failedTasks =
          tasks.where((t) => t.status == SyncStatus.failed).length;

      final lastSyncResult = await getLastSyncTime();
      final lastSync = lastSyncResult.data;

      final configResult = await getSyncConfiguration();
      final config = configResult.data ?? const SyncConfiguration();
      final nextSync = lastSync?.add(config.frequency);

      final statistics = SyncStatistics(
        totalTasks: totalTasks,
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        failedTasks: failedTasks,
        lastSync: lastSync,
        nextSync: nextSync,
      );

      return Result.success(statistics);
    } catch (e) {
      logger.error('Error getting sync statistics', error: e);
      return Result.failure(
        NetworkException('Failed to get sync statistics: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<List<SyncTask>>> getPendingSyncTasks() async {
    try {
      final tasksResult = await _getSyncTasks();
      if (tasksResult.isFailure) {
        return Result.failure(tasksResult.exception!);
      }

      final pendingTasks = tasksResult.data!
          .where((task) => task.status == SyncStatus.pending)
          .toList();

      return Result.success(pendingTasks);
    } catch (e) {
      logger.error('Error getting pending sync tasks', error: e);
      return Result.failure(
        NetworkException('Failed to get pending sync tasks: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<List<SyncTask>>> getFailedSyncTasks() async {
    try {
      final tasksResult = await _getSyncTasks();
      if (tasksResult.isFailure) {
        return Result.failure(tasksResult.exception!);
      }

      final failedTasks = tasksResult.data!
          .where((task) => task.status == SyncStatus.failed)
          .toList();

      return Result.success(failedTasks);
    } catch (e) {
      logger.error('Error getting failed sync tasks', error: e);
      return Result.failure(
        NetworkException('Failed to get failed sync tasks: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> triggerManualSync({
    SyncTaskType? type,
  }) async {
    try {
      logger.info('Triggering manual sync', data: {'type': type?.name});

      return await registerOneTimeSync(
        type: type ?? SyncTaskType.general,
        data: {'isManual': true},
      );
    } catch (e) {
      logger.error('Error triggering manual sync', error: e);
      return Result.failure(
        NetworkException('Failed to trigger manual sync: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<NetworkStatus>> checkNetworkStatus() async {
    try {
      logger.info('Checking network status');

      final connectivityResults = await _connectivity.checkConnectivity();
      final isConnected = connectivityResults.isNotEmpty &&
          !connectivityResults.contains(ConnectivityResult.none);

      String connectionType = 'none';
      if (connectivityResults.contains(ConnectivityResult.wifi)) {
        connectionType = 'wifi';
      } else if (connectivityResults.contains(ConnectivityResult.mobile)) {
        connectionType = 'mobile';
      } else if (connectivityResults.contains(ConnectivityResult.ethernet)) {
        connectionType = 'ethernet';
      }

      final networkStatus = NetworkStatus(
        isConnected: isConnected,
        connectionType: connectionType,
        isMetered: connectionType == 'mobile',
      );

      return Result.success(networkStatus);
    } catch (e) {
      logger.error('Error checking network status', error: e);
      return Result.failure(
        NetworkException('Failed to check network status: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<DateTime?>> getLastSyncTime() async {
    try {
      final lastSyncString = await _secureStorage.readString(_lastSyncKey);
      if (lastSyncString == null) {
        return const Result.success(null);
      }

      final lastSync = DateTime.parse(lastSyncString);
      return Result.success(lastSync);
    } catch (e) {
      logger.error('Error getting last sync time', error: e);
      return Result.failure(
        NetworkException('Failed to get last sync time: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> updateSyncConfiguration(
      SyncConfiguration configuration) async {
    try {
      logger.info('Updating sync configuration');

      await _secureStorage.writeJson(_configKey, configuration.toJson());

      logger.info('Sync configuration updated');
      return const Result.success(null);
    } catch (e) {
      logger.error('Error updating sync configuration', error: e);
      return Result.failure(
        NetworkException('Failed to update sync configuration: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<SyncConfiguration>> getSyncConfiguration() async {
    try {
      final configJson = await _secureStorage.readJson(_configKey);
      if (configJson == null) {
        return const Result.success(SyncConfiguration());
      }

      final config = SyncConfiguration.fromJson(configJson);
      return Result.success(config);
    } catch (e) {
      logger.error('Error getting sync configuration', error: e);
      return const Result.success(SyncConfiguration());
    }
  }

  @override
  Future<Result<bool>> isBackgroundSyncSupported() async {
    try {
      // In a real implementation, check platform capabilities
      return const Result.success(true);
    } catch (e) {
      logger.error('Error checking background sync support', error: e);
      return Result.failure(
        NetworkException('Failed to check background sync support: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<bool>> requestBackgroundPermissions() async {
    try {
      logger.info('Requesting background permissions');

      // In a real implementation, request actual permissions
      logger.info('Background permissions granted (mock)');
      return const Result.success(true);
    } catch (e) {
      logger.error('Error requesting background permissions', error: e);
      return Result.failure(
        NetworkException('Failed to request background permissions: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> queueOfflineSync({
    required SyncTaskType type,
    required Map<String, dynamic> data,
  }) async {
    try {
      logger.info('Queueing offline sync', data: {'type': type.name});

      return await registerOneTimeSync(
        type: type,
        data: {...data, 'isOffline': true},
      );
    } catch (e) {
      logger.error('Error queueing offline sync', error: e);
      return Result.failure(
        NetworkException('Failed to queue offline sync: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> processOfflineSyncQueue() async {
    try {
      logger.info('Processing offline sync queue');

      final tasksResult = await _getSyncTasks();
      if (tasksResult.isFailure) {
        return Result.failure(tasksResult.exception!);
      }

      final offlineTasks = tasksResult.data!
          .where((task) =>
              task.status == SyncStatus.pending &&
              task.data?['isOffline'] == true)
          .toList();

      logger.info('Found ${offlineTasks.length} offline tasks to process');

      // In a real implementation, process each task
      for (final task in offlineTasks) {
        // Mark task as completed for now
        await _updateTaskStatus(task.id, SyncStatus.completed);
      }

      return const Result.success(null);
    } catch (e) {
      logger.error('Error processing offline sync queue', error: e);
      return Result.failure(
        NetworkException('Failed to process offline sync queue: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> clearSyncHistory() async {
    try {
      logger.info('Clearing sync history');

      await _saveSyncTasks(<SyncTask>[]);
      await _secureStorage.delete(_lastSyncKey);
      await _secureStorage.delete(_statisticsKey);

      logger.info('Sync history cleared');
      return const Result.success(null);
    } catch (e) {
      logger.error('Error clearing sync history', error: e);
      return Result.failure(
        NetworkException('Failed to clear sync history: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  // Private helper methods

  Future<Result<List<SyncTask>>> _getSyncTasks() async {
    try {
      final tasksJson = await _secureStorage.readJson(_tasksKey);
      if (tasksJson == null) {
        return const Result.success(<SyncTask>[]);
      }

      final tasksList =
          List<Map<String, dynamic>>.from(tasksJson['tasks'] ?? []);
      final tasks = tasksList.map((json) => SyncTask.fromJson(json)).toList();

      return Result.success(tasks);
    } catch (e) {
      return const Result.success(<SyncTask>[]);
    }
  }

  Future<void> _saveSyncTasks(List<SyncTask> tasks) async {
    final tasksData = {
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
    await _secureStorage.writeJson(_tasksKey, tasksData);
  }

  Future<void> _updateTaskStatus(String taskId, SyncStatus status) async {
    final tasksResult = await _getSyncTasks();
    if (tasksResult.isFailure) return;

    final tasks = tasksResult.data!;
    final updatedTasks = tasks
        .map((task) => task.id == taskId
            ? task.copyWith(
                status: status,
                completedAt:
                    status == SyncStatus.completed ? DateTime.now() : null,
              )
            : task)
        .toList();

    await _saveSyncTasks(updatedTasks);

    if (status == SyncStatus.completed) {
      await _secureStorage.writeString(
          _lastSyncKey, DateTime.now().toIso8601String());
    }
  }
}
