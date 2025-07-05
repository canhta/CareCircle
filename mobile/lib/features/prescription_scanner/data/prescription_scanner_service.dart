import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import '../../../common/common.dart';
import '../domain/scanner_models.dart';
import '../domain/prescription_scanner_repository.dart';

/// Prescription scanner service implementation
class PrescriptionScannerService extends BaseRepository
    implements PrescriptionScannerRepository {
  static const String _folderName = 'prescription_images';
  final image_picker.ImagePicker _picker = image_picker.ImagePicker();

  PrescriptionScannerService({
    required super.apiClient,
    required super.logger,
  });

  /// Generate a unique ID for images
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }

  @override
  Future<Result<ScannerPermissions>> requestPermissions() async {
    try {
      logger.info('Requesting scanner permissions');

      // Check camera permission
      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        cameraStatus = await Permission.camera.request();
      }

      // Handle storage permissions based on platform
      bool hasStoragePermission = false;
      bool hasPhotosPermission = false;

      if (Platform.isIOS) {
        // iOS: Check photos permission
        var photosStatus = await Permission.photos.status;
        if (!photosStatus.isGranted && !photosStatus.isPermanentlyDenied) {
          photosStatus = await Permission.photos.request();
        }
        hasPhotosPermission = photosStatus.isGranted;
        hasStoragePermission = hasPhotosPermission;
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

        hasPhotosPermission = photosStatus.isGranted;
        hasStoragePermission = photosStatus.isGranted ||
            storageStatus.isGranted ||
            storageStatus.isLimited;
      }

      final permissions = ScannerPermissions(
        camera: cameraStatus.isGranted,
        storage: hasStoragePermission,
        photos: hasPhotosPermission,
      );

      logger.info('Scanner permissions result', data: {
        'camera': permissions.camera,
        'storage': permissions.storage,
        'photos': permissions.photos,
      });

      return Result.success(permissions);
    } catch (e) {
      logger.error('Error requesting scanner permissions', error: e);
      return Result.failure(
        NetworkException('Failed to request permissions: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<ScannerPermissions>> checkPermissions() async {
    try {
      logger.info('Checking scanner permissions');

      final cameraStatus = await Permission.camera.status;

      bool hasStoragePermission = false;
      bool hasPhotosPermission = false;

      if (Platform.isIOS) {
        final photosStatus = await Permission.photos.status;
        hasPhotosPermission = photosStatus.isGranted;
        hasStoragePermission = hasPhotosPermission;
      } else {
        final photosStatus = await Permission.photos.status;
        final storageStatus = await Permission.storage.status;

        hasPhotosPermission = photosStatus.isGranted;
        hasStoragePermission = photosStatus.isGranted ||
            storageStatus.isGranted ||
            storageStatus.isLimited;
      }

      final permissions = ScannerPermissions(
        camera: cameraStatus.isGranted,
        storage: hasStoragePermission,
        photos: hasPhotosPermission,
      );

      return Result.success(permissions);
    } catch (e) {
      logger.error('Error checking scanner permissions', error: e);
      return Result.failure(
        NetworkException('Failed to check permissions: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<CapturedImage>> captureFromCamera({
    ImageCaptureOptions? options,
  }) async {
    try {
      logger.info('Capturing image from camera');

      // Check permissions first
      final permissionResult = await requestPermissions();
      if (permissionResult.isFailure) {
        return Result.failure(permissionResult.exception!);
      }

      final permissions = permissionResult.data!;
      if (!permissions.hasAllPermissions) {
        return Result.failure(
          NetworkException(
            'Camera or storage permission denied. Please enable permissions in Settings.',
            type: NetworkExceptionType.forbidden,
          ),
        );
      }

      final captureOptions =
          options ?? ImageCaptureOptions(source: ImageSource.camera);

      final image_picker.XFile? image = await _picker.pickImage(
        source: image_picker.ImageSource.camera,
        maxWidth: captureOptions.maxWidth.toDouble(),
        maxHeight: captureOptions.maxHeight.toDouble(),
        imageQuality: captureOptions.imageQuality,
      );

      if (image == null) {
        return Result.failure(
          NetworkException('No image captured',
              type: NetworkExceptionType.cancel),
        );
      }

      final sourceFile = File(image.path);
      final saveResult = await saveImageToAppDirectory(
        sourceFile,
        description: 'Camera capture',
      );

      if (saveResult.isFailure) {
        return Result.failure(saveResult.exception!);
      }

      logger.info('Successfully captured image from camera');
      return Result.success(saveResult.data!);
    } catch (e) {
      logger.error('Error capturing image from camera', error: e);
      return Result.failure(
        NetworkException('Failed to capture image: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<CapturedImage>> selectFromGallery({
    ImageCaptureOptions? options,
  }) async {
    try {
      logger.info('Selecting image from gallery');

      final captureOptions =
          options ?? ImageCaptureOptions(source: ImageSource.gallery);

      final image_picker.XFile? image = await _picker.pickImage(
        source: image_picker.ImageSource.gallery,
        maxWidth: captureOptions.maxWidth.toDouble(),
        maxHeight: captureOptions.maxHeight.toDouble(),
        imageQuality: captureOptions.imageQuality,
      );

      if (image == null) {
        return Result.failure(
          NetworkException('No image selected',
              type: NetworkExceptionType.cancel),
        );
      }

      final sourceFile = File(image.path);
      final saveResult = await saveImageToAppDirectory(
        sourceFile,
        description: 'Gallery selection',
      );

      if (saveResult.isFailure) {
        return Result.failure(saveResult.exception!);
      }

      logger.info('Successfully selected image from gallery');
      return Result.success(saveResult.data!);
    } catch (e) {
      logger.error('Error selecting image from gallery', error: e);
      return Result.failure(
        NetworkException('Failed to select image: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<CapturedImage>> saveImageToAppDirectory(
    File sourceFile, {
    String? customName,
    String? description,
  }) async {
    try {
      logger.info('Saving image to app directory');

      final directoryResult = await getSavedImagesDirectory();
      if (directoryResult.isFailure) {
        return Result.failure(directoryResult.exception!);
      }

      final directory = directoryResult.data!;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(sourceFile.path);
      final fileName = customName ?? 'prescription_$timestamp$extension';
      final savedFile = File(path.join(directory.path, fileName));

      // Copy the file to app directory
      await sourceFile.copy(savedFile.path);

      // Get file stats
      final fileStat = await savedFile.stat();

      final capturedImage = CapturedImage(
        id: _generateId(),
        file: savedFile,
        fileName: fileName,
        fileSize: fileStat.size,
        capturedAt: DateTime.now(),
        source: description?.contains('Camera') == true
            ? ImageSource.camera
            : ImageSource.gallery,
        description: description,
      );

      logger.info('Successfully saved image to app directory');
      return Result.success(capturedImage);
    } catch (e) {
      logger.error('Error saving image to app directory', error: e);
      return Result.failure(
        NetworkException('Failed to save image: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<Directory>> getSavedImagesDirectory() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(appDocDir.path, _folderName));

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      return Result.success(imagesDir);
    } catch (e) {
      logger.error('Error getting saved images directory', error: e);
      return Result.failure(
        NetworkException('Failed to get images directory: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<List<CapturedImage>>> getAllSavedImages() async {
    try {
      logger.info('Getting all saved images');

      final directoryResult = await getSavedImagesDirectory();
      if (directoryResult.isFailure) {
        return Result.failure(directoryResult.exception!);
      }

      final directory = directoryResult.data!;
      final files = directory
          .listSync()
          .whereType<File>()
          .where((file) => _isImageFile(file.path))
          .toList();

      final images = <CapturedImage>[];
      for (final file in files) {
        try {
          final fileStat = await file.stat();
          final fileName = path.basename(file.path);

          final image = CapturedImage(
            id: _generateId(),
            file: file,
            fileName: fileName,
            fileSize: fileStat.size,
            capturedAt: fileStat.modified,
            source: ImageSource.gallery, // Default for existing files
          );

          images.add(image);
        } catch (e) {
          logger.warning('Failed to process image file: ${file.path}');
        }
      }

      // Sort by capture date (newest first)
      images.sort((a, b) => b.capturedAt.compareTo(a.capturedAt));

      logger.info('Found ${images.length} saved images');
      return Result.success(images);
    } catch (e) {
      logger.error('Error getting all saved images', error: e);
      return Result.failure(
        NetworkException('Failed to get saved images: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> deleteSavedImage(String imageId) async {
    try {
      logger.info('Deleting saved image', data: {'imageId': imageId});

      final imagesResult = await getAllSavedImages();
      if (imagesResult.isFailure) {
        return Result.failure(imagesResult.exception!);
      }

      final images = imagesResult.data!;
      final image = images.where((img) => img.id == imageId).firstOrNull;

      if (image == null) {
        return Result.failure(
          NetworkException('Image not found',
              type: NetworkExceptionType.notFound),
        );
      }

      if (await image.file.exists()) {
        await image.file.delete();
      }

      logger.info('Successfully deleted saved image');
      return const Result.success(null);
    } catch (e) {
      logger.error('Error deleting saved image', error: e);
      return Result.failure(
        NetworkException('Failed to delete image: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> clearAllSavedImages() async {
    try {
      logger.info('Clearing all saved images');

      final directoryResult = await getSavedImagesDirectory();
      if (directoryResult.isFailure) {
        return Result.failure(directoryResult.exception!);
      }

      final directory = directoryResult.data!;
      final files = directory.listSync().whereType<File>();

      for (final file in files) {
        if (_isImageFile(file.path)) {
          await file.delete();
        }
      }

      logger.info('Successfully cleared all saved images');
      return const Result.success(null);
    } catch (e) {
      logger.error('Error clearing all saved images', error: e);
      return Result.failure(
        NetworkException('Failed to clear images: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getImageMetadata(File imageFile) async {
    try {
      logger.info('Getting image metadata');

      if (!await imageFile.exists()) {
        return Result.failure(
          NetworkException('Image file does not exist',
              type: NetworkExceptionType.notFound),
        );
      }

      final fileStat = await imageFile.stat();

      final metadata = {
        'path': imageFile.path,
        'fileName': path.basename(imageFile.path),
        'fileSize': fileStat.size,
        'modified': fileStat.modified.toIso8601String(),
        'created': fileStat.accessed.toIso8601String(),
        'extension': path.extension(imageFile.path),
        'isImageFile': _isImageFile(imageFile.path),
      };

      return Result.success(metadata);
    } catch (e) {
      logger.error('Error getting image metadata', error: e);
      return Result.failure(
        NetworkException('Failed to get metadata: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<File>> compressImage(
    File sourceFile, {
    int quality = 85,
    int? maxWidth,
    int? maxHeight,
  }) async {
    try {
      logger.info('Compressing image', data: {
        'quality': quality,
        'maxWidth': maxWidth,
        'maxHeight': maxHeight,
      });

      // For now, return the original file
      // In a real implementation, you would use an image compression library
      // like flutter_image_compress

      logger.info('Image compression not implemented, returning original file');
      return Result.success(sourceFile);
    } catch (e) {
      logger.error('Error compressing image', error: e);
      return Result.failure(
        NetworkException('Failed to compress image: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  /// Helper method to check if file is an image
  bool _isImageFile(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp']
        .contains(extension);
  }
}
