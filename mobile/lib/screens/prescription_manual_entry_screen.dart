import 'dart:io';
import 'package:flutter/material.dart';
import '../services/prescription_api_service.dart';

/// Screen for manual prescription entry and editing
class PrescriptionManualEntryScreen extends StatefulWidget {
  final File? imageFile;
  final PrescriptionExtractedData? initialData;
  final bool isEditMode;

  const PrescriptionManualEntryScreen({
    super.key,
    this.imageFile,
    this.initialData,
    this.isEditMode = false,
  });

  @override
  State<PrescriptionManualEntryScreen> createState() =>
      _PrescriptionManualEntryScreenState();
}

class _PrescriptionManualEntryScreenState
    extends State<PrescriptionManualEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _drugNameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _quantityController = TextEditingController();
  final _prescriberController = TextEditingController();
  final _instructionsController = TextEditingController();

  bool _isLoading = false;
  String? _selectedFrequency;
  String? _selectedDosageUnit;

  // Predefined options for dropdowns
  final List<String> _frequencyOptions = [
    'Once daily',
    'Twice daily',
    'Three times daily',
    'Four times daily',
    'Every 4 hours',
    'Every 6 hours',
    'Every 8 hours',
    'Every 12 hours',
    'As needed',
    'Before meals',
    'After meals',
    'At bedtime',
    'Other',
  ];

  final List<String> _dosageUnits = [
    'mg',
    'g',
    'ml',
    'tablets',
    'capsules',
    'drops',
    'puffs',
    'units',
    'patches',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  /// Initialize form with existing data if in edit mode
  void _initializeForm() {
    if (widget.initialData != null) {
      _drugNameController.text = widget.initialData!.drugName ?? '';
      _dosageController.text = widget.initialData!.dosage ?? '';
      _frequencyController.text = widget.initialData!.frequency ?? '';
      _quantityController.text = widget.initialData!.quantity ?? '';
      _prescriberController.text = widget.initialData!.prescriber ?? '';
      _instructionsController.text = widget.initialData!.instructions ?? '';

      // Set selected frequency if it matches predefined options
      if (widget.initialData!.frequency != null &&
          _frequencyOptions.contains(widget.initialData!.frequency)) {
        _selectedFrequency = widget.initialData!.frequency;
      }
    }
  }

  @override
  void dispose() {
    _drugNameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _quantityController.dispose();
    _prescriberController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  /// Validates and saves the prescription data
  Future<void> _savePrescription() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prescriptionData = PrescriptionExtractedData(
        drugName: _drugNameController.text.trim(),
        dosage: _dosageController.text.trim(),
        frequency: _selectedFrequency ?? _frequencyController.text.trim(),
        quantity: _quantityController.text.trim(),
        prescriber: _prescriberController.text.trim(),
        instructions: _instructionsController.text.trim(),
      );

      // Here you would typically save to a database or local storage
      // For now, we'll just show a success message and navigate back

      _showSuccessSnackBar(
        widget.isEditMode
            ? 'Prescription updated successfully'
            : 'Prescription saved successfully',
      );

      // Navigate back with the prescription data
      Navigator.pop(context, prescriptionData);
    } catch (e) {
      _showErrorSnackBar('Error saving prescription: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
        title: Text(
          widget.isEditMode ? 'Edit Prescription' : 'New Prescription',
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          if (widget.imageFile != null)
            IconButton(
              icon: const Icon(Icons.image),
              onPressed: () => _showImageDialog(),
              tooltip: 'View Image',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header text
                    Text(
                      widget.isEditMode
                          ? 'Edit the prescription details below'
                          : 'Enter prescription details manually',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),

                    // Drug Name
                    _buildTextFormField(
                      controller: _drugNameController,
                      label: 'Drug Name',
                      hint: 'e.g., Metformin, Aspirin',
                      icon: Icons.medication,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the drug name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Dosage
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTextFormField(
                            controller: _dosageController,
                            label: 'Dosage',
                            hint: 'e.g., 500, 25',
                            icon: Icons.science,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter the dosage';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: _buildDropdownField(
                            value: _selectedDosageUnit,
                            items: _dosageUnits,
                            label: 'Unit',
                            hint: 'mg',
                            onChanged: (value) {
                              setState(() {
                                _selectedDosageUnit = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Frequency
                    _buildDropdownField(
                      value: _selectedFrequency,
                      items: _frequencyOptions,
                      label: 'Frequency',
                      hint: 'Select frequency',
                      icon: Icons.schedule,
                      onChanged: (value) {
                        setState(() {
                          _selectedFrequency = value;
                          if (value == 'Other') {
                            _frequencyController.clear();
                          }
                        });
                      },
                    ),

                    // Custom frequency input (shown when 'Other' is selected)
                    if (_selectedFrequency == 'Other') ...[
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _frequencyController,
                        label: 'Custom Frequency',
                        hint: 'e.g., Every other day',
                        icon: Icons.edit,
                        validator: (value) {
                          if (_selectedFrequency == 'Other' &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Please enter custom frequency';
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 16),

                    // Quantity
                    _buildTextFormField(
                      controller: _quantityController,
                      label: 'Quantity',
                      hint: 'e.g., 30 tablets, 100ml',
                      icon: Icons.inventory,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the quantity';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Prescriber
                    _buildTextFormField(
                      controller: _prescriberController,
                      label: 'Prescriber',
                      hint: 'e.g., Dr. Smith',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the prescriber name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Instructions
                    _buildTextFormField(
                      controller: _instructionsController,
                      label: 'Instructions',
                      hint: 'e.g., Take with food, Avoid alcohol',
                      icon: Icons.info,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter instructions';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _savePrescription,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          widget.isEditMode
                              ? 'Update Prescription'
                              : 'Save Prescription',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Builds a text form field with consistent styling
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  /// Builds a dropdown field with consistent styling
  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String label,
    required String hint,
    IconData? icon,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  /// Shows the prescription image in a dialog
  void _showImageDialog() {
    if (widget.imageFile == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Prescription Image'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: InteractiveViewer(child: Image.file(widget.imageFile!)),
            ),
          ],
        ),
      ),
    );
  }
}
