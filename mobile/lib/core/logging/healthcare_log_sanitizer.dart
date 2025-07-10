import 'dart:convert';

/// Healthcare-compliant log sanitizer for PII/PHI protection
///
/// This class ensures that sensitive healthcare data is never logged
/// in violation of HIPAA and other healthcare privacy regulations.
class HealthcareLogSanitizer {
  /// Sensitive data patterns that should be redacted from logs
  static const List<String> _sensitivePatterns = [
    // Personal identifiers
    r'\b\d{3}-\d{2}-\d{4}\b', // SSN pattern
    r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b', // Email pattern
    r'\b\d{3}-\d{3}-\d{4}\b', // Phone pattern (US)
    r'\b\(\d{3}\)\s*\d{3}-\d{4}\b', // Phone pattern (US with parentheses)
    r'\b\d{10}\b', // 10-digit phone number
    // Medical data patterns
    r'\b(blood pressure|bp):\s*\d+/\d+\b',
    r'\b(heart rate|hr):\s*\d+\s*(bpm)?\b',
    r'\b(weight):\s*\d+(\.\d+)?\s*(lbs?|kg|pounds?)\b',
    r'\b(height):\s*\d+(\.\d+)?\s*(ft|feet|cm|inches?|in)?\b',
    r'\b(temperature|temp):\s*\d+(\.\d+)?\s*(°?[CF]|degrees?)\b',
    r'\b(glucose|sugar):\s*\d+\s*(mg/dl|mmol/l)?\b',

    // Medical record numbers and IDs
    r'\b(mrn|medical record number):\s*[A-Z0-9-]+\b',
    r'\b(patient id|patient number):\s*[A-Z0-9-]+\b',
    r'\b(insurance id|policy number):\s*[A-Z0-9-]+\b',

    // Credit card patterns (for payment processing)
    r'\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b',

    // Date of birth patterns
    r'\b\d{1,2}[/-]\d{1,2}[/-]\d{4}\b',
    r'\b\d{4}[/-]\d{1,2}[/-]\d{1,2}\b',
  ];

  /// Field names that contain sensitive healthcare data
  static const List<String> _sensitiveFields = [
    // Personal information
    'email', 'phone', 'phoneNumber', 'ssn', 'socialSecurityNumber',
    'dateOfBirth', 'dob', 'birthDate', 'address', 'zipCode', 'postalCode',
    'firstName', 'lastName', 'fullName', 'name', 'middleName',

    // Medical identifiers
    'medicalRecordNumber', 'mrn', 'patientId', 'patientNumber',
    'insuranceId', 'policyNumber', 'memberId', 'subscriberId',

    // Health data
    'bloodPressure', 'systolic', 'diastolic', 'heartRate', 'pulse',
    'weight', 'height', 'bmi', 'bodyMassIndex', 'temperature',
    'glucose', 'bloodSugar', 'cholesterol', 'oxygenSaturation',

    // Medical information
    'medications', 'prescriptions', 'dosage', 'frequency', 'strength',
    'diagnoses', 'diagnosis', 'conditions', 'symptoms', 'allergies',
    'procedures', 'treatments', 'notes', 'observations', 'comments',
    'medicalHistory', 'familyHistory', 'surgicalHistory',

    // Emergency contacts
    'emergencyContact', 'emergencyPhone', 'nextOfKin',

    // Payment information
    'creditCard', 'cardNumber', 'cvv', 'expirationDate', 'billingAddress',

    // Authentication tokens (security)
    'password', 'token', 'accessToken', 'refreshToken', 'idToken',
    'apiKey', 'secret', 'privateKey', 'certificate',
  ];

  /// Sanitize a log message by removing sensitive patterns
  static String sanitizeMessage(String message) {
    if (message.isEmpty) return message;

    String sanitized = message;

    // Remove sensitive patterns using regex
    for (final pattern in _sensitivePatterns) {
      sanitized = sanitized.replaceAll(
        RegExp(pattern, caseSensitive: false),
        '[REDACTED]',
      );
    }

    return sanitized;
  }

  /// Sanitize a data map by removing or redacting sensitive fields
  static Map<String, dynamic> sanitizeData(Map<String, dynamic> data) {
    final sanitized = <String, dynamic>{};

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      // Check if field name is sensitive
      if (_isSensitiveField(key)) {
        sanitized[key] = '[REDACTED]';
      } else if (value is Map<String, dynamic>) {
        // Recursively sanitize nested maps
        sanitized[key] = sanitizeData(value);
      } else if (value is List) {
        // Sanitize lists
        sanitized[key] = _sanitizeList(value);
      } else if (value is String) {
        // Sanitize string values for patterns
        sanitized[key] = sanitizeMessage(value);
      } else {
        // Keep non-sensitive primitive values
        sanitized[key] = value;
      }
    }

    return sanitized;
  }

  /// Sanitize a JSON string
  static String sanitizeJson(String jsonString) {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final sanitized = sanitizeData(data);
      return jsonEncode(sanitized);
    } catch (e) {
      // If JSON parsing fails, treat as regular string
      return sanitizeMessage(jsonString);
    }
  }

  /// Check if a field name is considered sensitive
  static bool _isSensitiveField(String fieldName) {
    final lowerFieldName = fieldName.toLowerCase();

    // Direct match
    if (_sensitiveFields.contains(lowerFieldName)) {
      return true;
    }

    // Partial match for compound field names
    for (final sensitiveField in _sensitiveFields) {
      if (lowerFieldName.contains(sensitiveField) ||
          sensitiveField.contains(lowerFieldName)) {
        return true;
      }
    }

    return false;
  }

  /// Sanitize a list of values
  static List<dynamic> _sanitizeList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map<String, dynamic>) {
        return sanitizeData(item);
      } else if (item is String) {
        return sanitizeMessage(item);
      } else if (item is List) {
        return _sanitizeList(item);
      } else {
        return item;
      }
    }).toList();
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
