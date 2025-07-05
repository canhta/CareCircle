import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/health_models.dart';
import '../../data/health_data_export_service.dart';

/// Dialog for configuring health data export options
class HealthDataExportDialog extends StatefulWidget {
  final List<CareCircleHealthData> healthData;
  final Function(HealthDataExportOptions) onExport;

  const HealthDataExportDialog({
    super.key,
    required this.healthData,
    required this.onExport,
  });

  @override
  State<HealthDataExportDialog> createState() => _HealthDataExportDialogState();
}

class _HealthDataExportDialogState extends State<HealthDataExportDialog> {
  HealthDataExportFormat _selectedFormat = HealthDataExportFormat.csv;
  DateTime? _startDate;
  DateTime? _endDate;
  List<CareCircleHealthDataType> _availableTypes = [];
  Set<CareCircleHealthDataType> _selectedTypes = {};
  bool _selectAllTypes = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _availableTypes =
        HealthDataExportService.getAvailableDataTypes(widget.healthData);
    _selectedTypes = Set.from(_availableTypes);

    final dateRange =
        HealthDataExportService.getDataDateRange(widget.healthData);
    if (dateRange != null) {
      _startDate = dateRange.start;
      _endDate = dateRange.end;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Export Health Data'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormatSelection(),
            const SizedBox(height: 16),
            _buildDateRangeSelection(),
            const SizedBox(height: 16),
            _buildDataTypeSelection(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _canExport() ? _handleExport : null,
          child: const Text('Export'),
        ),
      ],
    );
  }

  Widget _buildFormatSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Export Format',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<HealthDataExportFormat>(
                title: const Text('CSV'),
                subtitle: const Text('Spreadsheet format'),
                value: HealthDataExportFormat.csv,
                groupValue: _selectedFormat,
                onChanged: (value) {
                  setState(() {
                    _selectedFormat = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<HealthDataExportFormat>(
                title: const Text('JSON'),
                subtitle: const Text('Data format'),
                value: HealthDataExportFormat.json,
                groupValue: _selectedFormat,
                onChanged: (value) {
                  setState(() {
                    _selectedFormat = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateRangeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectStartDate(),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _startDate != null
                        ? DateFormat('MMM dd, yyyy').format(_startDate!)
                        : 'Select date',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectEndDate(),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'End Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _endDate != null
                        ? DateFormat('MMM dd, yyyy').format(_endDate!)
                        : 'Select date',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Data Types',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectAllTypes = !_selectAllTypes;
                  if (_selectAllTypes) {
                    _selectedTypes = Set.from(_availableTypes);
                  } else {
                    _selectedTypes.clear();
                  }
                });
              },
              child: Text(_selectAllTypes ? 'Deselect All' : 'Select All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(
            child: Column(
              children: _availableTypes.map((type) {
                return CheckboxListTile(
                  title: Text(_getDisplayNameForType(type)),
                  value: _selectedTypes.contains(type),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedTypes.add(type);
                      } else {
                        _selectedTypes.remove(type);
                      }
                      _selectAllTypes =
                          _selectedTypes.length == _availableTypes.length;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          _startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: _endDate ?? DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _startDate = date;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate:
          _startDate ?? DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  bool _canExport() {
    return _startDate != null &&
        _endDate != null &&
        _selectedTypes.isNotEmpty &&
        _startDate!.isBefore(_endDate!.add(const Duration(days: 1)));
  }

  void _handleExport() {
    if (!_canExport()) return;

    final options = HealthDataExportOptions(
      format: _selectedFormat,
      startDate: _startDate!,
      endDate: _endDate!,
      dataTypes: _selectedTypes.toList(),
    );

    Navigator.of(context).pop();
    widget.onExport(options);
  }

  String _getDisplayNameForType(CareCircleHealthDataType type) {
    switch (type) {
      case CareCircleHealthDataType.steps:
        return 'Steps';
      case CareCircleHealthDataType.heartRate:
        return 'Heart Rate';
      case CareCircleHealthDataType.weight:
        return 'Weight';
      case CareCircleHealthDataType.height:
        return 'Height';
      case CareCircleHealthDataType.sleepInBed:
        return 'Sleep Time in Bed';
      case CareCircleHealthDataType.sleepAsleep:
        return 'Sleep Time Asleep';
      case CareCircleHealthDataType.bloodPressure:
        return 'Blood Pressure';
      case CareCircleHealthDataType.bloodGlucose:
        return 'Blood Glucose';
      case CareCircleHealthDataType.bodyTemperature:
        return 'Body Temperature';
      case CareCircleHealthDataType.oxygenSaturation:
        return 'Oxygen Saturation';
      case CareCircleHealthDataType.activeEnergyBurned:
        return 'Active Energy Burned';
      case CareCircleHealthDataType.basalEnergyBurned:
        return 'Basal Energy Burned';
      case CareCircleHealthDataType.distanceWalkingRunning:
        return 'Distance Walking/Running';
    }
  }
}
