import '../../../common/common.dart';
import 'background_sync_models.dart';

/// Repository interface for background sync operations
abstract class BackgroundSyncRepository {
  /// Initialize the background sync service
  Future<Result<void>> initialize();

  /// Register periodic health data sync
  Future<Result<void>> registerPeriodicSync({
    SyncConfiguration? configuration,
  });

  /// Register one-time sync task
  Future<Result<void>> registerOneTimeSync({
    SyncTaskType type,
    Duration? delay,
    Map<String, dynamic>? data,
  });

  /// Register retry sync for failed operations
  Future<Result<void>> registerRetrySync({
    Duration delay,
    SyncTaskType? type,
  });

  /// Cancel all sync tasks
  Future<Result<void>> cancelAllSyncTasks();

  /// Cancel specific sync task
  Future<Result<void>> cancelSyncTask(String taskId);

  /// Get sync statistics
  Future<Result<SyncStatistics>> getSyncStatistics();

  /// Get pending sync tasks
  Future<Result<List<SyncTask>>> getPendingSyncTasks();

  /// Get failed sync tasks
  Future<Result<List<SyncTask>>> getFailedSyncTasks();

  /// Manually trigger sync
  Future<Result<void>> triggerManualSync({
    SyncTaskType? type,
  });

  /// Check network connectivity
  Future<Result<NetworkStatus>> checkNetworkStatus();

  /// Get last sync time
  Future<Result<DateTime?>> getLastSyncTime();

  /// Update sync configuration
  Future<Result<void>> updateSyncConfiguration(SyncConfiguration configuration);

  /// Get current sync configuration
  Future<Result<SyncConfiguration>> getSyncConfiguration();

  /// Check if background sync is supported
  Future<Result<bool>> isBackgroundSyncSupported();

  /// Request background execution permissions
  Future<Result<bool>> requestBackgroundPermissions();

  /// Queue sync task for offline execution
  Future<Result<void>> queueOfflineSync({
    required SyncTaskType type,
    required Map<String, dynamic> data,
  });

  /// Process offline sync queue
  Future<Result<void>> processOfflineSyncQueue();

  /// Clear sync history
  Future<Result<void>> clearSyncHistory();
}
