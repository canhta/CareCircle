import '../compliance/healthcare_compliance_service.dart';

/// Healthcare-compliant log sanitizer for PII/PHI protection
///
/// This class ensures that sensitive healthcare data is never logged
/// in violation of HIPAA and other healthcare privacy regulations.
///
/// Now uses the consolidated HealthcareComplianceService for consistency.
class HealthcareLogSanitizer {
  static final HealthcareComplianceService _complianceService = HealthcareComplianceService();

  /// Sanitize a log message by removing sensitive patterns
  static String sanitizeMessage(String message) {
    if (message.isEmpty) return message;

    final result = _complianceService.sanitizeText(message);
    return result.sanitizedContent;
  }

  /// Sanitize a data map by removing or redacting sensitive fields
  static Map<String, dynamic> sanitizeData(Map<String, dynamic> data) {
    return _complianceService.sanitizeData(data);
  }

  /// Sanitize a JSON string
  static String sanitizeJson(String jsonString) {
    return _complianceService.sanitizeJson(jsonString);
  }

  /// Check if a field name is considered sensitive
  static bool _isSensitiveField(String fieldName) {
    // Use the consolidated compliance service for consistency
    return _complianceService.isSensitiveField(fieldName);
  }



  /// Create a sanitized summary of an object for logging
  static Map<String, dynamic> createSanitizedSummary(
    Map<String, dynamic> data, {
    List<String> allowedFields = const [],
  }) {
    final summary = <String, dynamic>{};

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (allowedFields.contains(key)) {
        // Explicitly allowed fields
        summary[key] = value;
      } else if (!_isSensitiveField(key)) {
        // Non-sensitive fields
        if (value is String) {
          summary[key] = sanitizeMessage(value);
        } else if (value is Map || value is List) {
          summary[key] = '[OBJECT]';
        } else {
          summary[key] = value;
        }
      } else {
        // Sensitive fields - show type only
        summary[key] = '[${value.runtimeType}]';
      }
    }

    return summary;
  }
}
