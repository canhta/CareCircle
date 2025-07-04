import 'dart:io';
import 'package:flutter/material.dart';
import '../features/prescription/prescription.dart';
import '../features/prescription_scanner/prescription_scanner.dart';
import '../common/common.dart';
import '../widgets/optimized_image.dart';
import 'prescription_ocr_results_screen.dart';
import 'prescription_manual_entry_screen.dart';

/// Screen for prescription scanning and management
class PrescriptionScannerScreen extends StatefulWidget {
  const PrescriptionScannerScreen({super.key});

  @override
  State<PrescriptionScannerScreen> createState() =>
      _PrescriptionScannerScreenState();
}

class _PrescriptionScannerScreenState extends State<PrescriptionScannerScreen> {
  late final PrescriptionService _prescriptionService;
  late final PrescriptionScannerService _scannerService;
  List<CapturedImage> _prescriptionImages = [];
  bool _isLoading = false;
  String _totalSize = '0 B';
  final Map<String, bool> _scanningImages = {};

  @override
  void initState() {
    super.initState();
    _prescriptionService = PrescriptionService(
      apiClient: ApiClient.instance,
      logger: AppLogger('PrescriptionScannerScreen'),
    );
    _scannerService = PrescriptionScannerService(
      apiClient: ApiClient.instance,
      logger: AppLogger('PrescriptionScannerService'),
    );
    _loadPrescriptionImages();
  }

  /// Loads all prescription images from storage
  Future<void> _loadPrescriptionImages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _scannerService.getAllSavedImages();

      result.fold(
        (images) {
          // Calculate total size
          int totalBytes = 0;
          for (final image in images) {
            try {
              final stats = image.file.statSync();
              totalBytes += stats.size;
            } catch (e) {
              // Skip files that can't be read
            }
          }

          setState(() {
            _prescriptionImages = images;
            _totalSize = _formatFileSize(totalBytes);
            _isLoading = false;
          });
        },
        (error) {
          setState(() {
            _prescriptionImages = [];
            _totalSize = '0 B';
            _isLoading = false;
          });
          _showErrorSnackBar(
              'Error loading images: ${error is NetworkException ? error.message : error.toString()}');
        },
      );
    } catch (e) {
      setState(() {
        _prescriptionImages = [];
        _totalSize = '0 B';
        _isLoading = false;
      });
      _showErrorSnackBar('Error loading images: $e');
    }
  }

  /// Show image source dialog
  Future<CapturedImage?> _showImageSourceDialog(BuildContext context) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Add Prescription Image'),
          content:
              const Text('Choose how you want to add the prescription image:'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(dialogContext, null),
            ),
            TextButton(
              child: const Text('Gallery'),
              onPressed: () => Navigator.pop(dialogContext, 'gallery'),
            ),
            TextButton(
              child: const Text('Camera'),
              onPressed: () => Navigator.pop(dialogContext, 'camera'),
            ),
          ],
        );
      },
    );

    if (choice == null) return null;

    // Handle the choice after dialog is closed
    switch (choice) {
      case 'gallery':
        return await _selectFromGallery();
      case 'camera':
        return await _captureFromCamera();
      default:
        return null;
    }
  }

  /// Capture image from camera
  Future<CapturedImage?> _captureFromCamera() async {
    try {
      final result = await _scannerService.captureFromCamera();
      return result.fold(
        (capturedImage) => capturedImage,
        (error) {
          _showErrorSnackBar(
              'Camera error: ${error is NetworkException ? error.message : error.toString()}');
          return null;
        },
      );
    } catch (e) {
      _showErrorSnackBar('Camera error: $e');
      return null;
    }
  }

  /// Select image from gallery
  Future<CapturedImage?> _selectFromGallery() async {
    try {
      final result = await _scannerService.selectFromGallery();
      return result.fold(
        (capturedImage) => capturedImage,
        (error) {
          _showErrorSnackBar(
              'Gallery error: ${error is NetworkException ? error.message : error.toString()}');
          return null;
        },
      );
    } catch (e) {
      _showErrorSnackBar('Gallery error: $e');
      return null;
    }
  }

  /// Format file size helper
  String _formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    var size = bytes.toDouble();
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Handles adding a new prescription image
  Future<void> _addPrescriptionImage() async {
    try {
      final capturedImage = await _showImageSourceDialog(context);
      if (capturedImage != null) {
        await _loadPrescriptionImages();
        _showSuccessSnackBar('Prescription image added successfully');
      }
    } catch (e) {
      _showErrorSnackBar('Error adding prescription image: $e');
    }
  }

  /// Handles scanning a prescription image with OCR
  Future<void> _scanPrescriptionImage(CapturedImage capturedImage) async {
    final imagePath = capturedImage.file.path;

    setState(() {
      _scanningImages[imagePath] = true;
    });

    try {
      final result =
          await _prescriptionService.scanPrescription(capturedImage.file);

      if (mounted) {
        result.fold(
          (response) {
            // Navigate to OCR results screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrescriptionOCRResultsScreen(
                  imageFile: capturedImage.file,
                  ocrResult: response, // PrescriptionOCRResponse from service
                ),
              ),
            );
          },
          (error) {
            _showErrorSnackBar('Failed to scan prescription: $error');
          },
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error scanning prescription: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _scanningImages.remove(imagePath);
        });
      }
    }
  }

  /// Delete prescription image helper
  Future<bool> _deleteImageFile(CapturedImage capturedImage) async {
    try {
      final result = await _scannerService.deleteSavedImage(capturedImage.id);
      return result.fold(
        (_) => true,
        (error) {
          AppLogger('PrescriptionScannerScreen')
              .error('Error deleting image', error: error);
          return false;
        },
      );
    } catch (e) {
      AppLogger('PrescriptionScannerScreen')
          .error('Error deleting image', error: e);
      return false;
    }
  }

  /// Handles deleting a prescription image
  Future<void> _deletePrescriptionImage(CapturedImage capturedImage) async {
    final confirmed = await _showDeleteConfirmationDialog();
    if (confirmed) {
      try {
        final success = await _deleteImageFile(capturedImage);
        if (success) {
          await _loadPrescriptionImages();
          _showSuccessSnackBar('Prescription image deleted successfully');
        } else {
          _showErrorSnackBar('Failed to delete prescription image');
        }
      } catch (e) {
        _showErrorSnackBar('Error deleting prescription image: $e');
      }
    }
  }

  /// Shows confirmation dialog for deleting an image
  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Prescription Image'),
              content: const Text(
                'Are you sure you want to delete this prescription image? This action cannot be undone.',
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  /// Shows image in full screen
  void _showFullScreenImage(File imageFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenImageView(imageFile: imageFile),
      ),
    );
  }

  /// Shows success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  /// Shows error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Scanner'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPrescriptionImages,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Summary Card
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prescription Images',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Images: ${_prescriptionImages.length}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Size: $_totalSize',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Image Grid
                Expanded(
                  child: _prescriptionImages.isEmpty
                      ? _buildEmptyState()
                      : _buildImageGrid(),
                ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _addManualPrescription,
            tooltip: 'Add Manual Prescription',
            heroTag: 'manual',
            child: const Icon(Icons.edit),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _addPrescriptionImage,
            tooltip: 'Add Prescription Image',
            heroTag: 'camera',
            child: const Icon(Icons.add_a_photo),
          ),
        ],
      ),
    );
  }

  /// Handles adding a manual prescription
  Future<void> _addManualPrescription() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PrescriptionManualEntryScreen(),
        ),
      );

      if (result != null && result is PrescriptionExtractedData) {
        _showSuccessSnackBar('Prescription added successfully');
        // You could save the prescription data to local storage or database here
      }
    } catch (e) {
      _showErrorSnackBar('Error adding manual prescription: $e');
    }
  }

  /// Builds empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No prescription images yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the camera button to add your first prescription image',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds image grid
  Widget _buildImageGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: _prescriptionImages.length,
      itemBuilder: (context, index) {
        final capturedImage = _prescriptionImages[index];
        return _buildImageTile(capturedImage);
      },
    );
  }

  /// Builds individual image tile
  Widget _buildImageTile(CapturedImage capturedImage) {
    final imagePath = capturedImage.file.path;
    final isScanning = _scanningImages[imagePath] ?? false;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Image
          PrescriptionImage(
            imageFile: capturedImage.file,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            onTap: () => _showFullScreenImage(capturedImage.file),
          ),
          // Scanning overlay
          if (isScanning)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Scanning...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Delete button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => _deletePrescriptionImage(capturedImage),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
          // Scan button
          if (!isScanning)
            Positioned(
              top: 8,
              left: 8,
              child: GestureDetector(
                onTap: () => _scanPrescriptionImage(capturedImage),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.document_scanner,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          // Image info overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Text(
                _getImageInfo(capturedImage.file),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Gets image info string
  String _getImageInfo(File imageFile) {
    try {
      final stats = imageFile.statSync();
      final size = _formatFileSize(stats.size);
      final date = DateTime.fromMillisecondsSinceEpoch(
        stats.modified.millisecondsSinceEpoch,
      );
      return '$size • ${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown size';
    }
  }
}

/// Full screen image view
class _FullScreenImageView extends StatelessWidget {
  final File imageFile;

  const _FullScreenImageView({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Image'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          panEnabled: false,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4.0,
          child: OptimizedImage(
            imageFile: imageFile,
            fit: BoxFit.contain,
            memCacheWidth: 800,
            memCacheHeight: 800,
          ),
        ),
      ),
    );
  }
}
