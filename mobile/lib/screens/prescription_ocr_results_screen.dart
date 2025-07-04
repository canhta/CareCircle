import 'dart:io';
import 'package:flutter/material.dart';
import '../services/prescription_api_service.dart';
import 'prescription_manual_entry_screen.dart';

/// Screen for displaying OCR results from prescription scanning
class PrescriptionOCRResultsScreen extends StatefulWidget {
  final File imageFile;
  final PrescriptionOCRResult ocrResult;

  const PrescriptionOCRResultsScreen({
    super.key,
    required this.imageFile,
    required this.ocrResult,
  });

  @override
  State<PrescriptionOCRResultsScreen> createState() =>
      _PrescriptionOCRResultsScreenState();
}

class _PrescriptionOCRResultsScreenState
    extends State<PrescriptionOCRResultsScreen> {
  bool _showRawText = false;

  @override
  Widget build(BuildContext context) {
    final ocrData = widget.ocrResult.data!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Results'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: Icon(_showRawText ? Icons.view_list : Icons.text_fields),
            onPressed: () {
              setState(() {
                _showRawText = !_showRawText;
              });
            },
            tooltip: _showRawText ? 'Show Structured Data' : 'Show Raw Text',
          ),
        ],
      ),
      body: Column(
        children: [
          // Image preview
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(widget.imageFile, fit: BoxFit.cover),
            ),
          ),

          // OCR confidence and status
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'OCR Confidence',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      _buildConfidenceChip(ocrData.confidence),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Validation',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      _buildValidationChip(ocrData.validation),
                    ],
                  ),
                  if (ocrData.validation.issues.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Issues: ${ocrData.validation.issues.join(', ')}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.orange),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Content based on toggle
          Expanded(
            child: _showRawText
                ? _buildRawTextView(ocrData)
                : _buildStructuredDataView(ocrData),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: ocrData.validation.isValid
                    ? () => _saveToMedications(ocrData)
                    : null,
                child: const Text('Save to Medications'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editPrescription(ocrData),
        label: const Text('Edit'),
        icon: const Icon(Icons.edit),
        tooltip: 'Edit prescription details',
      ),
    );
  }

  Widget _buildConfidenceChip(double confidence) {
    Color color;
    String text;

    if (confidence >= 80) {
      color = Colors.green;
      text = 'High (${confidence.toStringAsFixed(1)}%)';
    } else if (confidence >= 60) {
      color = Colors.orange;
      text = 'Medium (${confidence.toStringAsFixed(1)}%)';
    } else {
      color = Colors.red;
      text = 'Low (${confidence.toStringAsFixed(1)}%)';
    }

    return Chip(
      label: Text(text),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildValidationChip(PrescriptionValidation validation) {
    Color color;
    String text;

    if (validation.isValid && validation.confidence == 'high') {
      color = Colors.green;
      text = 'Valid (High)';
    } else if (validation.isValid) {
      color = Colors.blue;
      text = 'Valid (${validation.confidence})';
    } else {
      color = Colors.red;
      text = 'Invalid';
    }

    return Chip(
      label: Text(text),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildStructuredDataView(PrescriptionOCRResponse ocrData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Extracted Information',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildDataCard(
            'Drug Name',
            ocrData.extractedData.drugName,
            Icons.medication,
          ),
          _buildDataCard('Dosage', ocrData.extractedData.dosage, Icons.science),
          _buildDataCard(
            'Frequency',
            ocrData.extractedData.frequency,
            Icons.schedule,
          ),
          _buildDataCard(
            'Quantity',
            ocrData.extractedData.quantity,
            Icons.numbers,
          ),
          _buildDataCard(
            'Prescriber',
            ocrData.extractedData.prescriber,
            Icons.person,
          ),
          _buildDataCard(
            'Instructions',
            ocrData.extractedData.instructions,
            Icons.description,
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(String label, String? value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(label),
        subtitle: Text(
          value ?? 'Not detected',
          style: TextStyle(
            color: value != null ? null : Colors.grey,
            fontStyle: value != null ? null : FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildRawTextView(PrescriptionOCRResponse ocrData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Raw OCR Text', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Extracted Text:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      ocrData.text.isNotEmpty
                          ? ocrData.text
                          : 'No text detected',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: ocrData.text.isNotEmpty ? null : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to manual entry screen for editing
  void _editPrescription(PrescriptionOCRResponse ocrData) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrescriptionManualEntryScreen(
          imageFile: widget.imageFile,
          initialData: ocrData.extractedData,
          isEditMode: true,
        ),
      ),
    );

    if (result != null && result is PrescriptionExtractedData) {
      // Handle the edited prescription data
      _showSuccessSnackBar('Prescription updated successfully');
      // You could update local state or navigate back
    }
  }

  /// Shows success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _saveToMedications(PrescriptionOCRResponse ocrData) {
    // TODO: Implement saving to local medications database or navigate to edit screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save to Medications'),
        content: const Text(
          'This feature will be implemented to save the prescription data to your medications list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
