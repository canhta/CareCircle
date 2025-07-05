import 'dart:io';

/// Domain models for prescription feature

/// Response model for prescription OCR API
class PrescriptionOCRResponse {
  final String text;
  final double confidence;
  final PrescriptionExtractedData extractedData;
  final PrescriptionValidation validation;
  final String processedAt;

  PrescriptionOCRResponse({
    required this.text,
    required this.confidence,
    required this.extractedData,
    required this.validation,
    required this.processedAt,
  });

  factory PrescriptionOCRResponse.fromJson(Map<String, dynamic> json) {
    return PrescriptionOCRResponse(
      text: json['text'] ?? '',
      confidence: (json['confidence'] ?? 0).toDouble(),
      extractedData: PrescriptionExtractedData.fromJson(
        json['extractedData'] ?? {},
      ),
      validation: PrescriptionValidation.fromJson(json['validation'] ?? {}),
      processedAt: json['processedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'confidence': confidence,
      'extractedData': extractedData.toJson(),
      'validation': validation.toJson(),
      'processedAt': processedAt,
    };
  }
}

/// Extracted prescription data model
class PrescriptionExtractedData {
  final String? drugName;
  final String? dosage;
  final String? frequency;
  final String? quantity;
  final String? prescriber;
  final String? instructions;

  PrescriptionExtractedData({
    this.drugName,
    this.dosage,
    this.frequency,
    this.quantity,
    this.prescriber,
    this.instructions,
  });

  factory PrescriptionExtractedData.fromJson(Map<String, dynamic> json) {
    return PrescriptionExtractedData(
      drugName: json['drugName'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      quantity: json['quantity'],
      prescriber: json['prescriber'],
      instructions: json['instructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'drugName': drugName,
      'dosage': dosage,
      'frequency': frequency,
      'quantity': quantity,
      'prescriber': prescriber,
      'instructions': instructions,
    };
  }
}

/// Validation result model
class PrescriptionValidation {
  final bool isValid;
  final String confidence;
  final List<String> issues;

  PrescriptionValidation({
    required this.isValid,
    required this.confidence,
    required this.issues,
  });

  factory PrescriptionValidation.fromJson(Map<String, dynamic> json) {
    return PrescriptionValidation(
      isValid: json['isValid'] ?? false,
      confidence: json['confidence'] ?? 'low',
      issues: List<String>.from(json['issues'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      'confidence': confidence,
      'issues': issues,
    };
  }
}

/// Prescription scanning options
class PrescriptionScanOptions {
  final int maxFileSize;
  final List<String> allowedFormats;
  final int timeout;

  const PrescriptionScanOptions({
    this.maxFileSize = 10 * 1024 * 1024, // 10MB
    this.allowedFormats = const ['.jpg', '.jpeg', '.png', '.webp'],
    this.timeout = 30000, // 30 seconds
  });

  /// Validates if a file is suitable for scanning
  bool isValidFile(File file) {
    final extension = file.path.toLowerCase();
    return allowedFormats.any((format) => extension.endsWith(format));
  }

  /// Validates file size
  Future<bool> isFileSizeValid(File file) async {
    try {
      final fileSize = await file.length();
      return fileSize <= maxFileSize;
    } catch (e) {
      return false;
    }
  }
}

/// Prescription model for storing in database
class PrescriptionModel {
  final String id;
  final String userId;
  final String? patientId;
  final String drugName;
  final String dosage;
  final String frequency;
  final String quantity;
  final String prescriber;
  final String instructions;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final PrescriptionStatus status;
  final String? imageUrl;
  final PrescriptionOCRResponse? ocrData;

  PrescriptionModel({
    required this.id,
    required this.userId,
    this.patientId,
    required this.drugName,
    required this.dosage,
    required this.frequency,
    required this.quantity,
    required this.prescriber,
    required this.instructions,
    required this.createdAt,
    this.updatedAt,
    required this.status,
    this.imageUrl,
    this.ocrData,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      patientId: json['patientId'] as String?,
      drugName: json['drugName'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      quantity: json['quantity'] as String,
      prescriber: json['prescriber'] as String,
      instructions: json['instructions'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      status: _parseStatus(json['status'] as String),
      imageUrl: json['imageUrl'] as String?,
      ocrData: json['ocrData'] != null
          ? PrescriptionOCRResponse.fromJson(
              json['ocrData'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'patientId': patientId,
      'drugName': drugName,
      'dosage': dosage,
      'frequency': frequency,
      'quantity': quantity,
      'prescriber': prescriber,
      'instructions': instructions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status.name,
      'imageUrl': imageUrl,
      'ocrData': ocrData?.toJson(),
    };
  }

  static PrescriptionStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return PrescriptionStatus.active;
      case 'completed':
        return PrescriptionStatus.completed;
      case 'cancelled':
        return PrescriptionStatus.cancelled;
      case 'expired':
        return PrescriptionStatus.expired;
      default:
        return PrescriptionStatus.active;
    }
  }

  PrescriptionModel copyWith({
    String? id,
    String? userId,
    String? patientId,
    String? drugName,
    String? dosage,
    String? frequency,
    String? quantity,
    String? prescriber,
    String? instructions,
    DateTime? createdAt,
    DateTime? updatedAt,
    PrescriptionStatus? status,
    String? imageUrl,
    PrescriptionOCRResponse? ocrData,
  }) {
    return PrescriptionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      patientId: patientId ?? this.patientId,
      drugName: drugName ?? this.drugName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      quantity: quantity ?? this.quantity,
      prescriber: prescriber ?? this.prescriber,
      instructions: instructions ?? this.instructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      ocrData: ocrData ?? this.ocrData,
    );
  }
}

/// Prescription status enum
enum PrescriptionStatus {
  active,
  completed,
  cancelled,
  expired,
}

/// Prescription filter options
class PrescriptionFilterOptions {
  final PrescriptionStatus? status;
  final String? patientId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchTerm;

  const PrescriptionFilterOptions({
    this.status,
    this.patientId,
    this.startDate,
    this.endDate,
    this.searchTerm,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status?.name,
      'patientId': patientId,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'searchTerm': searchTerm,
    };
  }
}

/// Paginated prescription response
class PrescriptionPaginatedResponse {
  final List<PrescriptionModel> prescriptions;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  PrescriptionPaginatedResponse({
    required this.prescriptions,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PrescriptionPaginatedResponse.fromJson(Map<String, dynamic> json) {
    return PrescriptionPaginatedResponse(
      prescriptions: (json['prescriptions'] as List<dynamic>?)
              ?.map(
                  (e) => PrescriptionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      totalPages: json['totalPages'] as int,
      hasNext: json['hasNext'] as bool,
      hasPrevious: json['hasPrevious'] as bool,
    );
  }
}
