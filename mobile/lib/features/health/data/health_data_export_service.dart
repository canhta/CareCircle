import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import '../../../common/common.dart';
import '../domain/health_models.dart';

/// Export formats supported by the health data export service
enum HealthDataExportFormat {
  csv,
  json,
}

/// Export options for health data
class HealthDataExportOptions {
  final HealthDataExportFormat format;
  final DateTime startDate;
  final DateTime endDate;
  final List<CareCircleHealthDataType>? dataTypes;
  final String? fileName;

  const HealthDataExportOptions({
    required this.format,
    required this.startDate,
    required this.endDate,
    this.dataTypes,
    this.fileName,
  });
}

/// Result of health data export operation
class HealthDataExportResult {
  final File file;
  final String fileName;
  final int recordCount;
  final HealthDataExportFormat format;

  const HealthDataExportResult({
    required this.file,
    required this.fileName,
    required this.recordCount,
    required this.format,
  });
}

/// Service for exporting health data in various formats
class HealthDataExportService extends BaseRepository {
  HealthDataExportService({
    required super.apiClient,
    required super.logger,
  });

  /// Export health data to file
  Future<Result<HealthDataExportResult>> exportHealthData(
    List<CareCircleHealthData> healthData,
    HealthDataExportOptions options,
  ) async {
    try {
      logger.info('Starting health data export', data: {
        'format': options.format.name,
        'recordCount': healthData.length,
        'startDate': options.startDate.toIso8601String(),
        'endDate': options.endDate.toIso8601String(),
      });

      // Filter data by date range and types if specified
      final filteredData = _filterHealthData(healthData, options);

      if (filteredData.isEmpty) {
        return Result.failure(
          NetworkException(
            'No health data found for the specified criteria',
            type: NetworkExceptionType.notFound,
          ),
        );
      }

      // Generate file content based on format
      final String content;
      final String fileExtension;

      switch (options.format) {
        case HealthDataExportFormat.csv:
          content = _generateCsvContent(filteredData);
          fileExtension = 'csv';
          break;
        case HealthDataExportFormat.json:
          content = _generateJsonContent(filteredData);
          fileExtension = 'json';
          break;
      }

      // Create file
      final fileName = options.fileName ??
          'health_data_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      final file = await _createExportFile(content, fileName);

      final result = HealthDataExportResult(
        file: file,
        fileName: fileName,
        recordCount: filteredData.length,
        format: options.format,
      );

      logger.info('Health data export completed successfully', data: {
        'fileName': fileName,
        'recordCount': filteredData.length,
        'fileSize': await file.length(),
      });

      return Result.success(result);
    } catch (e) {
      logger.error('Error exporting health data', error: e);
      return Result.failure(
        NetworkException(
          'Failed to export health data: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  /// Share exported health data file
  Future<Result<void>> shareExportedData(
      HealthDataExportResult exportResult) async {
    try {
      logger.info('Sharing exported health data', data: {
        'fileName': exportResult.fileName,
        'format': exportResult.format.name,
      });

      final xFile = XFile(
        exportResult.file.path,
        name: exportResult.fileName,
        mimeType: _getMimeType(exportResult.format),
      );

      // Using SharePlus.instance.share() for sharing files
      await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
          subject: 'Health Data Export - ${exportResult.fileName}',
          text:
              'Your health data export containing ${exportResult.recordCount} records.',
        ),
      );

      logger.info('Health data shared successfully');
      return Result.success(null);
    } catch (e) {
      logger.error('Error sharing health data', error: e);
      return Result.failure(
        NetworkException(
          'Failed to share health data: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  /// Filter health data based on export options
  List<CareCircleHealthData> _filterHealthData(
    List<CareCircleHealthData> data,
    HealthDataExportOptions options,
  ) {
    return data.where((item) {
      // Filter by date range
      final isInDateRange = item.timestamp
              .isAfter(options.startDate.subtract(const Duration(days: 1))) &&
          item.timestamp.isBefore(options.endDate.add(const Duration(days: 1)));

      // Filter by data types if specified
      final isIncludedType = options.dataTypes?.contains(item.type) ?? true;

      return isInDateRange && isIncludedType;
    }).toList();
  }

  /// Generate CSV content from health data
  String _generateCsvContent(List<CareCircleHealthData> data) {
    final buffer = StringBuffer();

    // CSV header
    buffer.writeln('Type,Value,Unit,Timestamp,Source,Metadata');

    // CSV rows
    for (final item in data) {
      final metadata = item.metadata != null
          ? jsonEncode(item.metadata).replaceAll('"', '""')
          : '';

      buffer.writeln([
        item.type.name,
        item.value,
        item.unit,
        item.timestamp.toIso8601String(),
        item.source ?? '',
        '"$metadata"',
      ].join(','));
    }

    return buffer.toString();
  }

  /// Generate JSON content from health data
  String _generateJsonContent(List<CareCircleHealthData> data) {
    final exportData = {
      'exportedAt': DateTime.now().toIso8601String(),
      'recordCount': data.length,
      'data': data.map((item) => item.toJson()).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  /// Create export file in app directory
  Future<File> _createExportFile(String content, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final exportsDir = Directory(path.join(directory.path, 'health_exports'));

    if (!await exportsDir.exists()) {
      await exportsDir.create(recursive: true);
    }

    final file = File(path.join(exportsDir.path, fileName));
    await file.writeAsString(content);

    return file;
  }

  /// Get MIME type for export format
  String _getMimeType(HealthDataExportFormat format) {
    switch (format) {
      case HealthDataExportFormat.csv:
        return 'text/csv';
      case HealthDataExportFormat.json:
        return 'application/json';
    }
  }

  /// Get available data types from health data
  static List<CareCircleHealthDataType> getAvailableDataTypes(
    List<CareCircleHealthData> data,
  ) {
    final types = <CareCircleHealthDataType>{};
    for (final item in data) {
      types.add(item.type);
    }
    return types.toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Get date range from health data
  static DateTimeRange? getDataDateRange(List<CareCircleHealthData> data) {
    if (data.isEmpty) return null;

    DateTime earliest = data.first.timestamp;
    DateTime latest = data.first.timestamp;

    for (final item in data) {
      if (item.timestamp.isBefore(earliest)) {
        earliest = item.timestamp;
      }
      if (item.timestamp.isAfter(latest)) {
        latest = item.timestamp;
      }
    }

    return DateTimeRange(start: earliest, end: latest);
  }
}

/// Date range helper class
class DateTimeRange {
  final DateTime start;
  final DateTime end;

  const DateTimeRange({
    required this.start,
    required this.end,
  });

  Duration get duration => end.difference(start);
}
