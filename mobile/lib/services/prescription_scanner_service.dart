import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

/// Service for handling prescription image capture and management
class PrescriptionScannerService {
  static const String _folderName = 'prescription_images';
  final ImagePicker _picker = ImagePicker();

  /// Requests necessary permissions for camera and storage
  Future<bool> requestPermissions() async {
    try {
      // Check if camera permission is already granted
      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        cameraStatus = await Permission.camera.request();
      }

      // Handle storage permissions differently for iOS and Android
      bool hasStoragePermission = false;

      // iOS: Check photos permission
      if (Platform.isIOS) {
        var photosStatus = await Permission.photos.status;
        if (!photosStatus.isGranted && !photosStatus.isPermanentlyDenied) {
          photosStatus = await Permission.photos.request();
        }
        hasStoragePermission = photosStatus.isGranted;
      } else {
        // Android: Try photos permission first (Android 13+), then storage
        var photosStatus = await Permission.photos.status;
        var storageStatus = await Permission.storage.status;

        // Try photos permission first (for Android 13+)
        if (!photosStatus.isGranted && !photosStatus.isPermanentlyDenied) {
          photosStatus = await Permission.photos.request();
        }

        // Fallback to storage permission if photos is not available
        if (!photosStatus.isGranted &&
            !storageStatus.isGranted &&
            !storageStatus.isLimited) {
          storageStatus = await Permission.storage.request();
        }

        hasStoragePermission =
            photosStatus.isGranted ||
            storageStatus.isGranted ||
            storageStatus.isLimited;
      }

      bool hasPermissions = cameraStatus.isGranted && hasStoragePermission;

      if (!hasPermissions) {
        debugPrint(
          'Permissions denied - Camera: ${cameraStatus.name}, Storage/Photos permission: $hasStoragePermission',
        );
      }

      return hasPermissions;
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return false;
    }
  }

  /// Captures an image from the camera
  Future<File?> captureFromCamera() async {
    try {
      // Check permissions first
      if (!await requestPermissions()) {
        debugPrint('Camera permission denied');
        throw Exception(
          'Camera permission denied. Please enable camera and storage permissions in Settings.',
        );
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return await _saveImageToAppDirectory(image);
      }
      return null;
    } catch (e) {
      debugPrint('Error capturing image from camera: $e');
      rethrow;
    }
  }

  /// Selects an image from the gallery
  Future<File?> selectFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return await _saveImageToAppDirectory(image);
      }
      return null;
    } catch (e) {
      debugPrint('Error selecting image from gallery: $e');
      rethrow;
    }
  }

  /// Shows a dialog to let user choose between camera and gallery
  Future<File?> showImageSourceDialog(BuildContext context) async {
    return showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: const Text(
            'How would you like to add your prescription image?',
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final file = await captureFromCamera();
                  if (context.mounted) {
                    Navigator.pop(context, file);
                  }
                } catch (e) {
                  if (context.mounted) {
                    // Show error dialog for permission issues
                    _showPermissionErrorDialog(context, e.toString());
                  }
                }
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final file = await selectFromGallery();
                  if (context.mounted) {
                    Navigator.pop(context, file);
                  }
                } catch (e) {
                  if (context.mounted) {
                    _showPermissionErrorDialog(context, e.toString());
                  }
                }
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  /// Saves the captured/selected image to app's private directory
  Future<File> _saveImageToAppDirectory(XFile image) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final prescriptionDir = Directory(path.join(appDir.path, _folderName));

      // Create directory if it doesn't exist
      if (!await prescriptionDir.exists()) {
        await prescriptionDir.create(recursive: true);
      }

      // Generate unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(image.name);
      final fileName = 'prescription_$timestamp$extension';
      final filePath = path.join(prescriptionDir.path, fileName);

      // Copy the image to the app directory
      final File newFile = await File(image.path).copy(filePath);

      debugPrint('Image saved to: $filePath');
      return newFile;
    } catch (e) {
      debugPrint('Error saving image: $e');
      rethrow;
    }
  }

  /// Gets all prescription images from the app directory
  Future<List<File>> getPrescriptionImages() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final prescriptionDir = Directory(path.join(appDir.path, _folderName));

      if (!await prescriptionDir.exists()) {
        return [];
      }

      final entities = await prescriptionDir.list().toList();
      final imageFiles = entities
          .whereType<File>()
          .where((file) => _isImageFile(file.path))
          .toList();

      // Sort by creation date (newest first)
      imageFiles.sort(
        (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
      );

      return imageFiles;
    } catch (e) {
      debugPrint('Error getting prescription images: $e');
      return [];
    }
  }

  /// Deletes a prescription image
  Future<bool> deletePrescriptionImage(File imageFile) async {
    try {
      if (await imageFile.exists()) {
        await imageFile.delete();
        debugPrint('Deleted image: ${imageFile.path}');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  /// Checks if the file is an image based on extension
  bool _isImageFile(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    return [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp',
    ].contains(extension);
  }

  /// Gets the total size of all prescription images
  Future<int> getTotalImageSize() async {
    try {
      final images = await getPrescriptionImages();
      int totalSize = 0;

      for (final image in images) {
        if (await image.exists()) {
          totalSize += await image.length();
        }
      }

      return totalSize;
    } catch (e) {
      debugPrint('Error calculating total image size: $e');
      return 0;
    }
  }

  /// Formats file size in human-readable format
  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Shows an error dialog for permission issues
  void _showPermissionErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Error'),
          content: Text(
            'Unable to access camera or storage. Please check your permissions in settings.\n\nError: $error',
          ),
          actions: [
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
