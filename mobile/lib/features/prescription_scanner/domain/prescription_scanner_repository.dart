import 'dart:io';
import '../../../common/common.dart';
import 'scanner_models.dart';

/// Repository interface for prescription scanner operations
abstract class PrescriptionScannerRepository {
  /// Request necessary permissions for camera and storage
  Future<Result<ScannerPermissions>> requestPermissions();

  /// Check current permission status
  Future<Result<ScannerPermissions>> checkPermissions();

  /// Capture image from camera
  Future<Result<CapturedImage>> captureFromCamera({
    ImageCaptureOptions? options,
  });

  /// Select image from gallery
  Future<Result<CapturedImage>> selectFromGallery({
    ImageCaptureOptions? options,
  });

  /// Save image to app directory
  Future<Result<CapturedImage>> saveImageToAppDirectory(
    File sourceFile, {
    String? customName,
    String? description,
  });

  /// Get saved images directory
  Future<Result<Directory>> getSavedImagesDirectory();

  /// List all saved images
  Future<Result<List<CapturedImage>>> getAllSavedImages();

  /// Delete saved image
  Future<Result<void>> deleteSavedImage(String imageId);

  /// Clear all saved images
  Future<Result<void>> clearAllSavedImages();

  /// Get image metadata
  Future<Result<Map<String, dynamic>>> getImageMetadata(File imageFile);

  /// Compress image
  Future<Result<File>> compressImage(
    File sourceFile, {
    int quality = 85,
    int? maxWidth,
    int? maxHeight,
  });
}
