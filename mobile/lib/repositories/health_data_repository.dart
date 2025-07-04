import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/health_service.dart';

/// Repository for managing health data synchronization with backend
class HealthDataRepository {
  static final HealthDataRepository _instance =
      HealthDataRepository._internal();
  factory HealthDataRepository() => _instance;
  HealthDataRepository._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        }
        options.headers['Content-Type'] = 'application/json';
        handler.next(options);
      },
    ));
  }

  late final Dio _dio;
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  String? _authToken;

  /// Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Sync health data to the server
  Future<Map<String, dynamic>> syncHealthData(
    List<CareCircleHealthData> healthData,
    String source,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final data = {
        'data': healthData.map((data) => data.toJson()).toList(),
        'source': source,
        'syncStartDate': startDate.toIso8601String(),
        'syncEndDate': endDate.toIso8601String(),
      };

      debugPrint(
        'HealthDataRepository: Syncing ${healthData.length} data points',
      );

      final response = await _dio.post('/health-record/sync', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('HealthDataRepository: Successfully synced health data');
        return response.data;
      } else {
        debugPrint(
          'HealthDataRepository: Failed to sync health data - ${response.statusCode}: ${response.data}',
        );
        throw Exception(
          'Sync failed: ${response.statusCode} - ${response.data}',
        );
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error syncing health data - $e');
      rethrow;
    }
  }

  /// Get health metrics for a date range
  Future<List<Map<String, dynamic>>?> getHealthMetrics({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dio.get(
        '/api/health-data/metrics',
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.cast<Map<String, dynamic>>();
      } else {
        debugPrint(
          'HealthDataRepository: Failed to get health metrics - ${response.statusCode}: ${response.data}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error getting health metrics - $e');
      return null;
    }
  }

  /// Create or update health consent
  Future<bool> updateHealthConsent({
    required String consentType,
    required bool granted,
    List<String>? dataCategories,
    String? purpose,
    bool? consentGranted,
    String? consentVersion,
    String? careGroupId,
    bool? shareWithFamily,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final data = {
        'consentType': consentType,
        'granted': granted,
        'dataCategories': dataCategories,
        'purpose': purpose,
        'consentGranted': consentGranted ?? granted,
        'consentVersion': consentVersion,
        'careGroupId': careGroupId,
        'shareWithFamily': shareWithFamily,
        'timestamp': DateTime.now().toIso8601String(),
        'metadata': metadata ?? {},
      };

      final response = await _dio.post('/api/health-consent', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('HealthDataRepository: Successfully updated health consent');
        return true;
      } else {
        debugPrint(
          'HealthDataRepository: Failed to update health consent - ${response.statusCode}: ${response.data}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error updating health consent - $e');
      return false;
    }
  }

  /// Get all health consents for the user
  Future<List<Map<String, dynamic>>?> getHealthConsents() async {
    try {
      final response = await _dio.get('/api/health-consent');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.cast<Map<String, dynamic>>();
      } else {
        debugPrint(
          'HealthDataRepository: Failed to get health consents - ${response.statusCode}: ${response.data}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error getting health consents - $e');
      return null;
    }
  }

  /// Get health data access log
  Future<List<Map<String, dynamic>>?> getHealthAccessLog() async {
    try {
      final response = await _dio.get('/api/health-data/access-log');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.cast<Map<String, dynamic>>();
      } else {
        debugPrint(
          'HealthDataRepository: Failed to get health access log - ${response.statusCode}: ${response.data}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error getting health access log - $e');
      return null;
    }
  }

  /// Request data export
  Future<bool> requestDataExport() async {
    try {
      final response = await _dio.post('/api/health-data/export');

      if (response.statusCode == 200 || response.statusCode == 202) {
        debugPrint('HealthDataRepository: Successfully requested data export');
        return true;
      } else {
        debugPrint(
          'HealthDataRepository: Failed to request data export - ${response.statusCode}: ${response.data}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error requesting data export - $e');
      return false;
    }
  }

  /// Request data deletion
  Future<bool> requestDataDeletion() async {
    try {
      final response = await _dio.delete('/api/health-data');

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint(
            'HealthDataRepository: Successfully requested data deletion');
        return true;
      } else {
        debugPrint(
          'HealthDataRepository: Failed to request data deletion - ${response.statusCode}: ${response.data}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error requesting data deletion - $e');
      return false;
    }
  }

  /// Update sync status
  Future<void> updateSyncStatus({
    required String status,
    required int recordCount,
    String? source,
    int? recordsCount,
    String? error,
    String? errorMessage,
  }) async {
    try {
      final data = {
        'status': status,
        'recordCount': recordCount,
        'source': source,
        'recordsCount': recordsCount ?? recordCount,
        'timestamp': DateTime.now().toIso8601String(),
        'error': error ?? errorMessage,
      };

      final response =
          await _dio.post('/api/health-data/sync-status', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('HealthDataRepository: Successfully updated sync status');
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error updating sync status - $e');
    }
  }

  /// Get sync history
  Future<List<Map<String, dynamic>>?> getSyncHistory() async {
    try {
      final response = await _dio.get('/api/health-data/sync-history');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.cast<Map<String, dynamic>>();
      } else {
        debugPrint(
          'HealthDataRepository: Failed to get sync history - ${response.statusCode}: ${response.data}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error getting sync history - $e');
      return null;
    }
  }

  /// Get health analysis
  Future<Map<String, dynamic>?> getHealthAnalysis({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? includeMetrics,
  }) async {
    try {
      final queryParams = {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

      if (includeMetrics != null && includeMetrics.isNotEmpty) {
        queryParams['metrics'] = includeMetrics.join(',');
      }

      final response = await _dio.get(
        '/api/health-analysis',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        debugPrint(
          'HealthDataRepository: Failed to get health analysis - ${response.statusCode}: ${response.data}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error getting health analysis - $e');
      return null;
    }
  }

  /// Get latest health analysis
  Future<Map<String, dynamic>?> getLatestHealthAnalysis() async {
    try {
      final response = await _dio.get('/api/health-analysis/latest');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        debugPrint(
          'HealthDataRepository: Failed to get latest health analysis - ${response.statusCode}: ${response.data}',
        );
        return null;
      }
    } catch (e) {
      debugPrint(
          'HealthDataRepository: Error getting latest health analysis - $e');
      return null;
    }
  }
}
