// Healthcare compliance service for mobile app
// Consolidates PII/PHI sanitization and healthcare compliance logic
import 'dart:convert';

/// Healthcare compliance service for mobile app
/// 
/// Provides centralized healthcare compliance functionality including:
/// - PII/PHI detection and sanitization
/// - Healthcare-compliant logging
/// - Data validation for healthcare standards
/// - HIPAA compliance utilities
class HealthcareComplianceService {
  static const HealthcareComplianceService _instance = HealthcareComplianceService._internal();
  
  factory HealthcareComplianceService() => _instance;
  
  const HealthcareComplianceService._internal();

  /// PHI detection patterns aligned with backend service
  static const Map<String, String> _phiPatterns = {
    'ssn': r'\b\d{3}-?\d{2}-?\d{4}\b',
    'phone': r'\b(?:\+?1[-.\s]?)?\(?([0-9]{3})\)?[-.\s]?([0-9]{3})[-.\s]?([0-9]{4})\b',
    'email': r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
    'creditCard': r'\b\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}\b',
    'medicalRecord': r'\b(?:MRN|MR|Medical Record|Patient ID)[\s:]*([A-Z0-9]{6,})\b',
    'insurance': r'\b(?:Insurance|Policy|Member)[\s#:]*([A-Z0-9]{8,})\b',
    'dob': r'\b(?:DOB|Date of Birth|Born)[\s:]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})\b',
  };

  /// Sensitive field names that should be redacted
  static const List<String> _sensitiveFields = [
    'ssn', 'socialSecurityNumber', 'social_security_number',
    'email', 'emailAddress', 'email_address',
    'phone', 'phoneNumber', 'phone_number', 'mobile',
    'address', 'streetAddress', 'street_address',
    'firstName', 'first_name', 'lastName', 'last_name', 'fullName', 'full_name',
    'dateOfBirth', 'date_of_birth', 'dob', 'birthDate', 'birth_date',
    'medicalRecordNumber', 'medical_record_number', 'mrn',
    'insuranceNumber', 'insurance_number', 'policyNumber', 'policy_number',
    'creditCard', 'credit_card', 'cardNumber', 'card_number',
    'password', 'token', 'apiKey', 'api_key', 'secret',
    'bloodPressure', 'blood_pressure', 'heartRate', 'heart_rate',
    'weight', 'height', 'bmi', 'glucose', 'cholesterol',
    'medication', 'prescription', 'diagnosis', 'symptoms',
  ];

  /// Healthcare-specific medication patterns
  static const List<String> _medicationPatterns = [
    r'\b[A-Z][a-z]+(?:zole|pril|statin|mycin|cillin)\b', // Common medication suffixes
    r'\b\d+\s*mg\b', // Dosage patterns
    r'\b\d+\s*ml\b', // Volume patterns
    r'\btake\s+\d+\s+times?\s+(?:daily|per day)\b', // Dosage instructions
  ];

  /// Detect PHI in text content
  List<PHIDetection> detectPHI(String text) {
    final detections = <PHIDetection>[];
    
    for (final entry in _phiPatterns.entries) {
      final pattern = RegExp(entry.value, caseSensitive: false);
      final matches = pattern.allMatches(text);
      
      for (final match in matches) {
        detections.add(PHIDetection(
          type: entry.key,
          value: match.group(0) ?? '',
          startIndex: match.start,
          endIndex: match.end,
          context: 'Detected in content',
        ));
      }
    }
    
    return detections;
  }

  /// Sanitize text content by removing PHI
  SanitizationResult sanitizeText(String text) {
    String sanitized = text;
    final phiDetected = <PHIDetection>[];
    bool sanitizationApplied = false;
    final warnings = <String>[];

    // Detect and sanitize PHI
    for (final entry in _phiPatterns.entries) {
      final pattern = RegExp(entry.value, caseSensitive: false);
      final matches = pattern.allMatches(text);
      
      for (final match in matches) {
        final detection = PHIDetection(
          type: entry.key,
          value: match.group(0) ?? '',
          startIndex: match.start,
          endIndex: match.end,
          context: 'Found in text content',
        );
        phiDetected.add(detection);
        
        // Replace with sanitized value
        final sanitizedValue = _sanitizePHIValue(detection.value, detection.type);
        sanitized = sanitized.replaceAll(detection.value, sanitizedValue);
        sanitizationApplied = true;
      }
    }

    // Check for medication patterns
    for (final pattern in _medicationPatterns) {
      final regex = RegExp(pattern, caseSensitive: false);
      if (regex.hasMatch(text)) {
        warnings.add('Specific medication information detected - consider using generic terms');
      }
    }

    return SanitizationResult(
      originalContent: text,
      sanitizedContent: sanitized,
      phiDetected: phiDetected,
      sanitizationApplied: sanitizationApplied,
      complianceLevel: phiDetected.isEmpty ? ComplianceLevel.full : 
                      sanitizationApplied ? ComplianceLevel.partial : ComplianceLevel.none,
      warnings: warnings,
    );
  }

  /// Sanitize data map by removing or redacting sensitive fields
  Map<String, dynamic> sanitizeData(Map<String, dynamic> data) {
    final sanitized = <String, dynamic>{};

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (_isSensitiveField(key)) {
        sanitized[key] = '[REDACTED]';
      } else if (value is Map<String, dynamic>) {
        sanitized[key] = sanitizeData(value);
      } else if (value is List) {
        sanitized[key] = _sanitizeList(value);
      } else if (value is String) {
        final result = sanitizeText(value);
        sanitized[key] = result.sanitizedContent;
      } else {
        sanitized[key] = value;
      }
    }

    return sanitized;
  }

  /// Sanitize JSON string
  String sanitizeJson(String jsonString) {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final sanitized = sanitizeData(data);
      return jsonEncode(sanitized);
    } catch (e) {
      final result = sanitizeText(jsonString);
      return result.sanitizedContent;
    }
  }

  /// Create healthcare-compliant log message
  String createCompliantLogMessage(String message, [Map<String, dynamic>? data]) {
    final result = sanitizeText(message);
    
    if (data != null) {
      final sanitizedData = sanitizeData(data);
      return '${result.sanitizedContent} | Data: ${jsonEncode(sanitizedData)}';
    }
    
    return result.sanitizedContent;
  }

  /// Check if field name is sensitive
  bool isSensitiveField(String fieldName) {
    final lowerField = fieldName.toLowerCase();
    return _sensitiveFields.any((sensitive) =>
      lowerField.contains(sensitive.toLowerCase()));
  }

  /// Private method for internal use
  bool _isSensitiveField(String fieldName) => isSensitiveField(fieldName);

  /// Sanitize PHI value based on type
  String _sanitizePHIValue(String value, String type) {
    switch (type) {
      case 'ssn':
        return 'XXX-XX-XXXX';
      case 'phone':
        return 'XXX-XXX-XXXX';
      case 'email':
        return '[EMAIL_REDACTED]';
      case 'creditCard':
        return 'XXXX-XXXX-XXXX-XXXX';
      case 'medicalRecord':
        return '[MRN_REDACTED]';
      case 'insurance':
        return '[INSURANCE_REDACTED]';
      case 'dob':
        return '[DOB_REDACTED]';
      default:
        return '[REDACTED]';
    }
  }

  /// Sanitize list values
  List<dynamic> _sanitizeList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map<String, dynamic>) {
        return sanitizeData(item);
      } else if (item is String) {
        final result = sanitizeText(item);
        return result.sanitizedContent;
      } else {
        return item;
      }
    }).toList();
  }
}

/// PHI detection result
class PHIDetection {
  final String type;
  final String value;
  final int startIndex;
  final int endIndex;
  final String context;

  const PHIDetection({
    required this.type,
    required this.value,
    required this.startIndex,
    required this.endIndex,
    required this.context,
  });
}

/// Text sanitization result
class SanitizationResult {
  final String originalContent;
  final String sanitizedContent;
  final List<PHIDetection> phiDetected;
  final bool sanitizationApplied;
  final ComplianceLevel complianceLevel;
  final List<String> warnings;

  const SanitizationResult({
    required this.originalContent,
    required this.sanitizedContent,
    required this.phiDetected,
    required this.sanitizationApplied,
    required this.complianceLevel,
    required this.warnings,
  });
}

/// Compliance level enum
enum ComplianceLevel {
  full,
  partial,
  none,
}
