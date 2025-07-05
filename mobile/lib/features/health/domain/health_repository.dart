import '../../../common/common.dart';
import 'health_models.dart';

/// Abstract repository for health data operations
abstract class HealthRepository {
  /// Initialize the health service
  Future<Result<void>> initialize();

  /// Check if health service is available
  bool get isAvailable;

  /// Request permissions for health data types
  Future<Result<HealthPermissions>> requestPermissions(
    List<CareCircleHealthDataType> types,
  );

  /// Check current permissions
  Future<Result<HealthPermissions>> checkPermissions(
    List<CareCircleHealthDataType> types,
  );

  /// Get health data from device
  Future<Result<List<CareCircleHealthData>>> getHealthData(
    HealthDataRequest request,
  );

  /// Get total steps for a date range
  Future<Result<int>> getTotalSteps({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Write health data to device
  Future<Result<bool>> writeHealthData(
    CareCircleHealthData healthData,
  );

  /// Write blood pressure data (special case)
  Future<Result<bool>> writeBloodPressure({
    required double systolic,
    required double diastolic,
    required DateTime timestamp,
  });

  /// Sync health data to backend
  Future<Result<HealthSyncStatus>> syncToBackend(
    List<CareCircleHealthData> healthData,
  );

  /// Get sync status from backend
  Future<Result<HealthSyncStatus>> getSyncStatus();

  /// Perform complete health data sync
  Future<Result<HealthSyncStatus>> performSync();

  /// Get last sync timestamp
  Future<Result<DateTime?>> getLastSyncTime();

  /// Set last sync timestamp
  Future<Result<void>> setLastSyncTime(DateTime timestamp);

  /// Get health data from backend
  Future<Result<List<CareCircleHealthData>>> getHealthDataFromBackend(
    HealthDataRequest request,
  );

  /// Delete health data from backend
  Future<Result<void>> deleteHealthDataFromBackend(
    List<String> healthDataIds,
  );

  /// Get consent settings from backend
  Future<Result<Map<String, dynamic>>> getConsentSettings();

  /// Update consent settings in backend
  Future<Result<void>> updateConsentSettings(Map<String, bool> settings);

  /// Get consent history from backend
  Future<Result<List<Map<String, dynamic>>>> getConsentHistory();

  /// Get access log from backend
  Future<Result<List<Map<String, dynamic>>>> getAccessLog();

  /// Request data export from backend
  Future<Result<void>> requestDataExport();

  /// Request account deletion from backend
  Future<Result<void>> requestAccountDeletion();
}
