import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/health_service.dart';

/// Repository for managing health data synchronization with backend
class HealthDataRepository {
  static final HealthDataRepository _instance =
      HealthDataRepository._internal();
  factory HealthDataRepository() => _instance;
  HealthDataRepository._internal();

  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  String? _authToken;

  /// Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Get common headers for API requests
  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  /// Sync health data to backend
  Future<Map<String, dynamic>> syncHealthData(
    List<CareCircleHealthData> healthData,
    String source,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl/health-record/sync');

      final body = jsonEncode({
        'data': healthData.map((data) => data.toJson()).toList(),
        'source': source,
        'syncStartDate': startDate.toIso8601String(),
        'syncEndDate': endDate.toIso8601String(),
      });

      debugPrint(
        'HealthDataRepository: Syncing ${healthData.length} data points to $url',
      );

      final response = await http.post(url, headers: _headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('HealthDataRepository: Successfully synced health data');
        return jsonDecode(response.body);
      } else {
        debugPrint(
          'HealthDataRepository: Failed to sync health data - ${response.statusCode}: ${response.body}',
        );
        throw Exception(
          'Sync failed: ${response.statusCode} - ${response.body}',
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
      final url = Uri.parse('$_baseUrl/api/health-data/metrics').replace(
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );

      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        debugPrint(
          'HealthDataRepository: Failed to get health metrics - ${response.statusCode}: ${response.body}',
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
    required List<String> dataCategories,
    required String purpose,
    required bool consentGranted,
    required String consentVersion,
    String? careGroupId,
    bool shareWithFamily = false,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/api/health-data/consent');

      final body = jsonEncode({
        'consentType': consentType,
        'dataCategories': dataCategories,
        'purpose': purpose,
        'consentGranted': consentGranted,
        'consentVersion': consentVersion,
        'careGroupId': careGroupId,
        'shareWithFamily': shareWithFamily,
        'legalBasis': 'Vietnam Decree 13/2022',
      });

      final response = await http.post(url, headers: _headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('HealthDataRepository: Successfully updated health consent');
        return true;
      } else {
        debugPrint(
          'HealthDataRepository: Failed to update health consent - ${response.statusCode}: ${response.body}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error updating health consent - $e');
      return false;
    }
  }

  /// Get user's health data consents
  Future<List<Map<String, dynamic>>?> getHealthConsents() async {
    try {
      final url = Uri.parse('$_baseUrl/api/health-data/consent');

      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        debugPrint(
          'HealthDataRepository: Failed to get health consents - ${response.statusCode}: ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error getting health consents - $e');
      return null;
    }
  }

  /// Get health data access log for transparency
  Future<List<Map<String, dynamic>>?> getHealthAccessLog() async {
    try {
      final url = Uri.parse('$_baseUrl/api/health-record/access-log');

      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        debugPrint(
          'HealthDataRepository: Failed to get access log - ${response.statusCode}: ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error getting access log - $e');
      return null;
    }
  }

  /// Request data export for user transparency
  Future<bool> requestDataExport() async {
    try {
      final url = Uri.parse('$_baseUrl/api/health-record/export-data');

      final response = await http.post(url, headers: _headers);

      if (response.statusCode == 200 || response.statusCode == 202) {
        debugPrint('HealthDataRepository: Data export requested successfully');
        return true;
      } else {
        debugPrint(
          'HealthDataRepository: Failed to request data export - ${response.statusCode}: ${response.body}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error requesting data export - $e');
      return false;
    }
  }

  /// Request complete data deletion (GDPR/Decree 13/2023 compliance)
  Future<bool> requestDataDeletion() async {
    try {
      final url = Uri.parse('$_baseUrl/api/health-record/delete-all-data');

      final response = await http.delete(url, headers: _headers);

      if (response.statusCode == 200 || response.statusCode == 202) {
        debugPrint(
          'HealthDataRepository: Data deletion requested successfully',
        );
        return true;
      } else {
        debugPrint(
          'HealthDataRepository: Failed to request data deletion - ${response.statusCode}: ${response.body}',
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
    required String source,
    required String status,
    required int recordsCount,
    String? errorMessage,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/api/health-data/sync-status');

      final body = jsonEncode({
        'source': source,
        'status': status,
        'recordsCount': recordsCount,
        'errorMessage': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await http.post(url, headers: _headers, body: body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint(
          'HealthDataRepository: Failed to update sync status - ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error updating sync status - $e');
    }
  }

  /// Get sync history
  Future<List<Map<String, dynamic>>?> getSyncHistory() async {
    try {
      final url = Uri.parse('$_baseUrl/api/health-data/sync-history');

      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        debugPrint(
          'HealthDataRepository: Failed to get sync history - ${response.statusCode}: ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error getting sync history - $e');
      return null;
    }
  }

  /// Get health data analysis and insights
  Future<Map<String, dynamic>?> getHealthAnalysis({
    DateTime? startDate,
    DateTime? endDate,
    String period = 'week',
  }) async {
    try {
      final queryParams = <String, String>{'period': period};

      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }

      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final uri = Uri.parse(
        '$_baseUrl/health-record/analysis',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        debugPrint(
          'HealthDataRepository: Health analysis retrieved successfully',
        );
        return jsonDecode(response.body);
      } else {
        debugPrint(
          'HealthDataRepository: Failed to get health analysis - ${response.statusCode}: ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('HealthDataRepository: Error getting health analysis - $e');
      return null;
    }
  }

  /// Get latest health analysis for user
  Future<Map<String, dynamic>?> getLatestHealthAnalysis() async {
    try {
      final url = Uri.parse('$_baseUrl/health-record/analysis/latest');

      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        debugPrint(
          'HealthDataRepository: Latest health analysis retrieved successfully',
        );
        return jsonDecode(response.body);
      } else {
        debugPrint(
          'HealthDataRepository: Failed to get latest health analysis - ${response.statusCode}: ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint(
        'HealthDataRepository: Error getting latest health analysis - $e',
      );
      return null;
    }
  }
}
