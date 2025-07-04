import 'dart:io';
import 'package:flutter/material.dart';
import '../services/prescription_scanner_service.dart';
import '../services/prescription_api_service.dart';
import 'prescription_ocr_results_screen.dart';

/// Screen for prescription scanning and management
class PrescriptionScannerScreen extends StatefulWidget {
  const PrescriptionScannerScreen({super.key});

  @override
  State<PrescriptionScannerScreen> createState() =>
      _PrescriptionScannerScreenState();
}

class _PrescriptionScannerScreenState extends State<PrescriptionScannerScreen> {
  final PrescriptionScannerService _scannerService =
      PrescriptionScannerService();
  final PrescriptionAPIService _apiService = PrescriptionAPIService();
  List<File> _prescriptionImages = [];
  bool _isLoading = false;
  String _totalSize = '0 B';
  Map<String, bool> _scanningImages = {};

  @override
  void initState() {
    super.initState();
    _loadPrescriptionImages();
  }

  /// Loads all prescription images from storage
  Future<void> _loadPrescriptionImages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final images = await _scannerService.getPrescriptionImages();
      final totalSize = await _scannerService.getTotalImageSize();

      setState(() {
        _prescriptionImages = images;
        _totalSize = _scannerService.formatFileSize(totalSize);
      });
    } catch (e) {
      _showErrorSnackBar('Error loading prescription images: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Handles adding a new prescription image
  Future<void> _addPrescriptionImage() async {
    try {
      final file = await _scannerService.showImageSourceDialog(context);
      if (file != null) {
        await _loadPrescriptionImages();
        _showSuccessSnackBar('Prescription image added successfully');
      }
    } catch (e) {
      _showErrorSnackBar('Error adding prescription image: $e');
    }
  }

  /// Handles scanning a prescription image with OCR
  Future<void> _scanPrescriptionImage(File imageFile) async {
    final imagePath = imageFile.path;

    setState(() {
      _scanningImages[imagePath] = true;
    });

    try {
      final result = await _apiService.scanPrescription(imageFile);

      if (result.success) {
        // Navigate to results screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrescriptionOCRResultsScreen(
              imageFile: imageFile,
              ocrResult: result,
            ),
          ),
        );
      } else {
        _showErrorSnackBar(result.error ?? 'Failed to scan prescription');
      }
    } catch (e) {
      _showErrorSnackBar('Error scanning prescription: $e');
    } finally {
      setState(() {
        _scanningImages.remove(imagePath);
      });
    }
  }

  /// Handles deleting a prescription image
  Future<void> _deletePrescriptionImage(File imageFile) async {
    final confirmed = await _showDeleteConfirmationDialog();
    if (confirmed) {
      try {
        final success = await _scannerService.deletePrescriptionImage(
          imageFile,
        );
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addPrescriptionImage,
        tooltip: 'Add Prescription Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
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
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
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
        final imageFile = _prescriptionImages[index];
        return _buildImageTile(imageFile);
      },
    );
  }

  /// Builds individual image tile
  Widget _buildImageTile(File imageFile) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Image
          GestureDetector(
            onTap: () => _showFullScreenImage(imageFile),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(imageFile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Delete button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => _deletePrescriptionImage(imageFile),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
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
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
              child: Text(
                _getImageInfo(imageFile),
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
      final size = _scannerService.formatFileSize(stats.size);
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
          child: Image.file(imageFile, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
