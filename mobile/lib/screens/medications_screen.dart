import 'package:flutter/material.dart';
import '../features/prescription/prescription.dart';
import '../common/common.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  late final PrescriptionService _prescriptionService;
  late final AppLogger _logger;

  List<PrescriptionModel> _medications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _logger = AppLogger('MedicationsScreen');
    _prescriptionService = PrescriptionService(
      apiClient: ApiClient.instance,
      logger: _logger,
    );
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _prescriptionService.getPrescriptions();

    result.fold(
      (response) => setState(() {
        _medications = response.prescriptions;
        _isLoading = false;
      }),
      (error) => setState(() {
        _error = error.toString();
        _isLoading = false;
      }),
    );
  }

  Future<void> _addMedication() async {
    // Navigate to prescription manual entry screen
    final result = await Navigator.pushNamed(
      context,
      '/prescription-manual-entry',
    );

    if (result == true) {
      _loadMedications();
    }
  }

  Future<void> _scanPrescription() async {
    // Navigate to prescription scanner screen
    final result = await Navigator.pushNamed(
      context,
      '/prescription-scanner',
    );

    if (result == true) {
      _loadMedications();
    }
  }

  Future<void> _toggleMedicationStatus(PrescriptionModel medication) async {
    final updatedData = {
      'status': medication.status == PrescriptionStatus.active
          ? 'inactive'
          : 'active',
    };

    final result = await _prescriptionService.updatePrescription(
      medication.id,
      updatedData,
    );

    result.fold(
      (success) => _loadMedications(),
      (error) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      ),
    );
  }

  Future<void> _deleteMedication(PrescriptionModel medication) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medication'),
        content:
            Text('Are you sure you want to delete ${medication.drugName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result =
          await _prescriptionService.deletePrescription(medication.id);

      result.fold(
        (success) => _loadMedications(),
        (error) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.toString()}')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medications'),
        actions: [
          IconButton(
            onPressed: _loadMedications,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMedicationOptions,
        label: const Text('Add Medication'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading medications',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMedications,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_medications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medication_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No medications added yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first medication to get started',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _medications.length,
      itemBuilder: (context, index) {
        final medication = _medications[index];
        return _buildMedicationCard(medication);
      },
    );
  }

  Widget _buildMedicationCard(PrescriptionModel medication) {
    final isActive = medication.status == PrescriptionStatus.active;

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive ? Colors.green : Colors.grey,
          child: Icon(
            Icons.medication,
            color: Colors.white,
          ),
        ),
        title: Text(
          medication.drugName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration:
                isActive ? TextDecoration.none : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dosage: ${medication.dosage}'),
            Text('Frequency: ${medication.frequency}'),
            if (medication.instructions.isNotEmpty)
              Text('Instructions: ${medication.instructions}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'toggle':
                _toggleMedicationStatus(medication);
                break;
              case 'edit':
                // Navigate to edit screen
                Navigator.pushNamed(
                  context,
                  '/prescription-manual-entry',
                  arguments: medication,
                );
                break;
              case 'delete':
                _deleteMedication(medication);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'toggle',
              child: Text(isActive ? 'Deactivate' : 'Activate'),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMedicationOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Scan Prescription'),
              onTap: () {
                Navigator.pop(context);
                _scanPrescription();
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Add Manually'),
              onTap: () {
                Navigator.pop(context);
                _addMedication();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
