import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../providers/medication_providers.dart';

class MedicationFormScreen extends ConsumerStatefulWidget {
  final Medication? medication; // null for add, non-null for edit
  final String? medicationId; // Alternative way to specify medication for editing

  const MedicationFormScreen({
    super.key,
    this.medication,
    this.medicationId,
  }) : assert(
         medication == null || medicationId == null,
         'Cannot provide both medication and medicationId',
       );

  @override
  ConsumerState<MedicationFormScreen> createState() =>
      _MedicationFormScreenState();
}

class _MedicationFormScreenState extends ConsumerState<MedicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _genericNameController = TextEditingController();
  final _strengthController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _notesController = TextEditingController();

  // Healthcare-compliant logger for medication context
  static final _logger = BoundedContextLoggers.medication;

  MedicationForm _selectedForm = MedicationForm.tablet;
  String _selectedClassification = 'Other';
  bool _isActive = true;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  final List<String> _classifications = [
    'Prescription',
    'Over-the-counter',
    'Supplement',
    'Vitamin',
    'Herbal',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.medication != null) {
      _populateFormWithMedication(widget.medication!);
    } else if (widget.medicationId != null) {
      // Load medication by ID and populate form
      _loadMedicationById(widget.medicationId!);
    } else {
      // New medication form
      _startDate = DateTime.now();
    }
  }

  void _populateFormWithMedication(Medication med) {
    _nameController.text = med.name;
    _genericNameController.text = med.genericName ?? '';
    _strengthController.text = med.strength;
    _manufacturerController.text = med.manufacturer ?? '';
    _notesController.text = med.notes ?? '';
    _selectedForm = med.form;
    _selectedClassification = med.classification ?? 'Other';
    _isActive = med.isActive;
    _startDate = med.startDate;
    _endDate = med.endDate;
  }

  Future<void> _loadMedicationById(String medicationId) async {
    setState(() => _isLoading = true);

    try {
      final medicationAsync = ref.read(medicationProvider(medicationId));
      medicationAsync.when(
        data: (medication) {
          if (medication != null) {
            _populateFormWithMedication(medication);
          }
        },
        loading: () {
          // Keep loading state
        },
        error: (error, stack) {
          _logger.error('Failed to load medication for editing', {
            'medicationId': medicationId,
            'error': error.toString(),
            'timestamp': DateTime.now().toIso8601String(),
          });
          // Show error to user
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load medication: ${error.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genericNameController.dispose();
    _strengthController.dispose();
    _manufacturerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.medication != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Medication' : 'Add Medication'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildMedicationDetailsSection(),
              const SizedBox(height: 24),
              _buildDatesSection(),
              const SizedBox(height: 24),
              _buildNotesSection(),
              const SizedBox(height: 32),
              _buildActionButtons(isEditing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Medication Name *',
                hintText: 'Enter medication name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Medication name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _genericNameController,
              decoration: const InputDecoration(
                labelText: 'Generic Name',
                hintText: 'Enter generic name (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _strengthController,
                    decoration: const InputDecoration(
                      labelText: 'Strength',
                      hintText: 'e.g., 500mg',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<MedicationForm>(
                    value: _selectedForm,
                    decoration: const InputDecoration(
                      labelText: 'Form *',
                      border: OutlineInputBorder(),
                    ),
                    items: MedicationForm.values.map((form) {
                      return DropdownMenuItem(
                        value: form,
                        child: Text(form.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedForm = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationDetailsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medication Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _manufacturerController,
              decoration: const InputDecoration(
                labelText: 'Manufacturer',
                hintText: 'Enter manufacturer name (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedClassification,
              decoration: const InputDecoration(
                labelText: 'Classification',
                border: OutlineInputBorder(),
              ),
              items: _classifications.map((classification) {
                return DropdownMenuItem(
                  value: classification,
                  child: Text(classification),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedClassification = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Active Medication'),
              subtitle: Text(
                _isActive
                    ? 'Currently taking this medication'
                    : 'No longer taking this medication',
              ),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
              activeColor: CareCircleDesignTokens.primaryMedicalBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dates',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _startDate != null
                            ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                            : 'Select start date',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'End Date (Optional)',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _endDate != null
                            ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                            : 'Select end date',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Additional Notes',
                hintText: 'Enter any additional notes about this medication...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isEditing) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveMedication,
            style: ElevatedButton.styleFrom(
              backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(isEditing ? 'Update' : 'Save'),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _saveMedication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isEditing = widget.medication != null;

      if (isEditing) {
        // Update existing medication
        final request = UpdateMedicationRequest(
          name: _nameController.text.trim(),
          genericName: _genericNameController.text.trim().isEmpty
              ? null
              : _genericNameController.text.trim(),
          strength: _strengthController.text.trim(),
          form: _selectedForm,
          manufacturer: _manufacturerController.text.trim().isEmpty
              ? null
              : _manufacturerController.text.trim(),
          classification: _selectedClassification,
          isActive: _isActive,
          startDate: _startDate,
          endDate: _endDate,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

        await ref
            .read(medicationNotifierProvider.notifier)
            .updateMedication(widget.medication!.id, request);

        _logger.logMedicationEvent('Medication updated via form', {
          'medicationId': widget.medication!.id,
          'medicationName': _nameController.text.trim(),
          'timestamp': DateTime.now().toIso8601String(),
        });
      } else {
        // Create new medication
        // Ensure we have a start date
        final startDate = _startDate ?? DateTime.now();

        // For create, strength is required
        final strength = _strengthController.text.trim().isEmpty
            ? 'N/A'
            : _strengthController.text.trim();

        final request = CreateMedicationRequest(
          name: _nameController.text.trim(),
          genericName: _genericNameController.text.trim().isEmpty
              ? null
              : _genericNameController.text.trim(),
          strength: strength,
          form: _selectedForm,
          manufacturer: _manufacturerController.text.trim().isEmpty
              ? null
              : _manufacturerController.text.trim(),
          classification: _selectedClassification,
          isActive: _isActive,
          startDate: startDate,
          endDate: _endDate,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

        await ref
            .read(medicationNotifierProvider.notifier)
            .createMedication(request);

        _logger.logMedicationEvent('Medication created via form', {
          'medicationName': request.name,
          'timestamp': DateTime.now().toIso8601String(),
        });
      }

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (error) {
      final isEditing = widget.medication != null;

      _logger.error('Failed to save medication via form', {
        'isEditing': isEditing,
        'medicationName': _nameController.text.trim(),
        'error': error.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to ${isEditing ? 'update' : 'save'} medication: $error',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
