import 'dart:io';

/// Prescription scanner models for image capture and processing
class ScannerModels {}

/// Image capture source
enum ImageSource {
  camera,
  gallery,
}

/// Image capture options
class ImageCaptureOptions {
  final int maxWidth;
  final int maxHeight;
  final int imageQuality;
  final ImageSource source;

  const ImageCaptureOptions({
    this.maxWidth = 1920,
    this.maxHeight = 1080,
    this.imageQuality = 85,
    required this.source,
  });

  Map<String, dynamic> toJson() => {
        'maxWidth': maxWidth,
        'maxHeight': maxHeight,
        'imageQuality': imageQuality,
        'source': source.name,
      };

  factory ImageCaptureOptions.fromJson(Map<String, dynamic> json) {
    return ImageCaptureOptions(
      maxWidth: json['maxWidth'] ?? 1920,
      maxHeight: json['maxHeight'] ?? 1080,
      imageQuality: json['imageQuality'] ?? 85,
      source: ImageSource.values.firstWhere(
        (e) => e.name == json['source'],
        orElse: () => ImageSource.camera,
      ),
    );
  }
}

/// Captured image result
class CapturedImage {
  final String id;
  final File file;
  final String fileName;
  final int fileSize;
  final DateTime capturedAt;
  final ImageSource source;
  final String? description;

  const CapturedImage({
    required this.id,
    required this.file,
    required this.fileName,
    required this.fileSize,
    required this.capturedAt,
    required this.source,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileName': fileName,
        'fileSize': fileSize,
        'capturedAt': capturedAt.toIso8601String(),
        'source': source.name,
        'description': description,
      };

  factory CapturedImage.fromJson(Map<String, dynamic> json) {
    return CapturedImage(
      id: json['id'],
      file: File(json['filePath']), // Reconstructed from path
      fileName: json['fileName'],
      fileSize: json['fileSize'],
      capturedAt: DateTime.parse(json['capturedAt']),
      source: ImageSource.values.firstWhere(
        (e) => e.name == json['source'],
        orElse: () => ImageSource.camera,
      ),
      description: json['description'],
    );
  }
}

/// Permission status for scanner
class ScannerPermissions {
  final bool camera;
  final bool storage;
  final bool photos;

  const ScannerPermissions({
    required this.camera,
    required this.storage,
    required this.photos,
  });

  bool get hasAllPermissions => camera && (storage || photos);

  Map<String, dynamic> toJson() => {
        'camera': camera,
        'storage': storage,
        'photos': photos,
      };

  factory ScannerPermissions.fromJson(Map<String, dynamic> json) {
    return ScannerPermissions(
      camera: json['camera'] ?? false,
      storage: json['storage'] ?? false,
      photos: json['photos'] ?? false,
    );
  }
}

/// Image processing result
class ImageProcessingResult {
  final CapturedImage image;
  final bool success;
  final String? error;
  final Map<String, dynamic>? metadata;

  const ImageProcessingResult({
    required this.image,
    required this.success,
    this.error,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'image': image.toJson(),
        'success': success,
        'error': error,
        'metadata': metadata,
      };

  factory ImageProcessingResult.fromJson(Map<String, dynamic> json) {
    return ImageProcessingResult(
      image: CapturedImage.fromJson(json['image']),
      success: json['success'],
      error: json['error'],
      metadata: json['metadata'],
    );
  }
}
