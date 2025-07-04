import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../config/app_config.dart';

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
}

/// API error model
class PrescriptionOCRError {
  final String message;
  final String code;
  final dynamic details;

  PrescriptionOCRError({
    required this.message,
    required this.code,
    this.details,
  });

  factory PrescriptionOCRError.fromJson(Map<String, dynamic> json) {
    return PrescriptionOCRError(
      message: json['message'] ?? 'Unknown error',
      code: json['code'] ?? 'UNKNOWN_ERROR',
      details: json['details'],
    );
  }
}

/// API result wrapper for handling success/error states
class PrescriptionOCRResult {
  final bool success;
  final PrescriptionOCRResponse? data;
  final String? error;

  PrescriptionOCRResult.success(this.data)
      : success = true,
        error = null;
  PrescriptionOCRResult.error(this.error)
      : success = false,
        data = null;
}

/// Service for handling prescription OCR API communication
class PrescriptionAPIService {
  static const String _prescriptionEndpoint = '/prescriptions/scan';

  /// Scans a prescription image using OCR API
  Future<PrescriptionOCRResult> scanPrescription(File imageFile) async {
    try {
      // Validate file before processing
      if (!PrescriptionAPIService.isValidImageFile(imageFile)) {
        return PrescriptionOCRResult.error('Invalid image file format');
      }

      final isValidSize = await PrescriptionAPIService.isFileSizeValid(
        imageFile,
      );
      if (!isValidSize) {
        return PrescriptionOCRResult.error('File size too large (max 10MB)');
      }

      final response = await scanPrescriptionImage(imageFile);
      return PrescriptionOCRResult.success(response);
    } catch (e) {
      return PrescriptionOCRResult.error(e.toString());
    }
  }

  /// Uploads a prescription image to the backend for OCR processing
  Future<PrescriptionOCRResponse> scanPrescriptionImage(File imageFile) async {
    try {
      debugPrint('Starting prescription OCR API call...');

      final dio = Dio();
      final url = '${AppConfig.apiBaseUrl}$_prescriptionEndpoint';
      debugPrint('API URL: $url');

      // Create form data with the image file
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: _getFileName(imageFile),
        ),
      });

      final imageLength = await imageFile.length();
      debugPrint('Sending request with file: ${_getFileName(imageFile)}');
      debugPrint('File size: ${_formatFileSize(imageLength)}');

      // Send the request with timeout
      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
          sendTimeout: Duration(milliseconds: AppConfig.apiTimeout),
          receiveTimeout: Duration(milliseconds: AppConfig.apiTimeout),
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        debugPrint('OCR processing successful');
        return PrescriptionOCRResponse.fromJson(responseData);
      } else {
        // Handle error response
        debugPrint('API error: ${response.statusCode} - ${response.data}');
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      debugPrint('Error during OCR API call: $e');
      rethrow;
    }
  }

  /// Handles error responses from the API
  PrescriptionOCRError _handleErrorResponse(Response response) {
    try {
      final errorData = response.data;
      return PrescriptionOCRError.fromJson(errorData);
    } catch (e) {
      // If we can't parse the error response, return a generic error
      return PrescriptionOCRError(
        message: 'API request failed with status ${response.statusCode}',
        code: 'HTTP_${response.statusCode}',
        details: response.data.toString(),
      );
    }
  }

  /// Gets the filename from the file path
  String _getFileName(File file) {
    final path = file.path;
    final lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    return lastSeparator != -1 ? path.substring(lastSeparator + 1) : path;
  }

  /// Formats file size in human-readable format
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Validates if an image file is suitable for OCR processing
  static bool isValidImageFile(File file) {
    final extension = file.path.toLowerCase();
    return extension.endsWith('.jpg') ||
        extension.endsWith('.jpeg') ||
        extension.endsWith('.png') ||
        extension.endsWith('.webp');
  }

  /// Gets the maximum allowed file size (10MB)
  static int get maxFileSize => 10 * 1024 * 1024;

  /// Validates file size
  static Future<bool> isFileSizeValid(File file) async {
    try {
      final fileSize = await file.length();
      return fileSize <= maxFileSize;
    } catch (e) {
      debugPrint('Error checking file size: $e');
      return false;
    }
  }
}
