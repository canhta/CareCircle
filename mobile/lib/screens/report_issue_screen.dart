import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import '../config/service_locator.dart';
import '../common/logging/app_logger.dart';

/// Screen for reporting issues and bugs
class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stepsController = TextEditingController();

  String _selectedCategory = 'Bug Report';
  String _selectedPriority = 'Medium';
  bool _includeDeviceInfo = true;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Bug Report',
    'Feature Request',
    'Performance Issue',
    'UI/UX Issue',
    'Data Sync Issue',
    'Notification Issue',
    'Other',
  ];

  final List<String> _priorities = [
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Issue'),
        backgroundColor: Colors.red.shade50,
        foregroundColor: Colors.red.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildCategorySection(),
              const SizedBox(height: 16),
              _buildPrioritySection(),
              const SizedBox(height: 16),
              _buildTitleField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 16),
              _buildStepsField(),
              const SizedBox(height: 16),
              _buildDeviceInfoSection(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bug_report,
                  color: Colors.red.shade700,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Report an Issue',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Help us improve CareCircle by reporting bugs, suggesting features, or sharing feedback. '
              'Your input is valuable to us!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: _categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Priority',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _priorities.map((priority) {
            final isSelected = _selectedPriority == priority;
            Color color;
            switch (priority) {
              case 'Low':
                color = Colors.green;
                break;
              case 'Medium':
                color = Colors.orange;
                break;
              case 'High':
                color = Colors.red;
                break;
              case 'Critical':
                color = Colors.purple;
                break;
              default:
                color = Colors.grey;
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(priority),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPriority = priority;
                    });
                  },
                  selectedColor: color.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? color : Colors.grey.shade700,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Issue Title',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Brief description of the issue',
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a title for the issue';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Describe the issue in detail...',
            contentPadding: EdgeInsets.all(12),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please provide a description of the issue';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStepsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Steps to Reproduce (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _stepsController,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '1. Go to...\n2. Tap on...\n3. Notice that...',
            contentPadding: EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.phone_android, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Device Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: _includeDeviceInfo,
                  onChanged: (value) {
                    setState(() {
                      _includeDeviceInfo = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _includeDeviceInfo
                  ? 'Device information will be included to help us debug the issue.'
                  : 'Device information will not be included.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitIssue,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isSubmitting
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Submitting...'),
                ],
              )
            : const Text(
                'Submit Issue Report',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> _submitIssue() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final logger = ServiceLocator.get<AppLogger>();

      // Collect device information if enabled
      String deviceInfo = '';
      if (_includeDeviceInfo) {
        deviceInfo = await _collectDeviceInfo();
      }

      // Create issue report data
      final issueReport = {
        'category': _selectedCategory,
        'priority': _selectedPriority,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'stepsToReproduce': _stepsController.text.trim(),
        'deviceInfo': deviceInfo,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Log the issue report (in a real app, this would be sent to a server)
      logger.info('Issue report submitted', data: issueReport);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Issue report submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit issue report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<String> _collectDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final buffer = StringBuffer();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        buffer.writeln('Platform: Android');
        buffer.writeln('Model: ${androidInfo.model}');
        buffer.writeln('Manufacturer: ${androidInfo.manufacturer}');
        buffer.writeln('Android Version: ${androidInfo.version.release}');
        buffer.writeln('SDK Version: ${androidInfo.version.sdkInt}');
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        buffer.writeln('Platform: iOS');
        buffer.writeln('Model: ${iosInfo.model}');
        buffer.writeln('System Name: ${iosInfo.systemName}');
        buffer.writeln('System Version: ${iosInfo.systemVersion}');
      }

      return buffer.toString();
    } catch (e) {
      return 'Failed to collect device information: $e';
    }
  }
}
