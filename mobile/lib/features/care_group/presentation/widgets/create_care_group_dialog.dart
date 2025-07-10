import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/design_tokens.dart';
import '../../domain/models/care_group_models.dart';
import '../providers/care_group_providers.dart';

class CreateCareGroupDialog extends ConsumerStatefulWidget {
  final Function(CareGroup)? onGroupCreated;

  const CreateCareGroupDialog({super.key, this.onGroupCreated});

  @override
  ConsumerState<CreateCareGroupDialog> createState() =>
      _CreateCareGroupDialogState();
}

class _CreateCareGroupDialogState extends ConsumerState<CreateCareGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;
  bool _allowHealthDataSharing = true;
  bool _allowMedicationSharing = true;
  bool _requireApprovalForNewMembers = false;
  bool _enableTaskNotifications = true;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildBasicInfo(context),
                  const SizedBox(height: 24),
                  _buildSettings(context),
                  const SizedBox(height: 32),
                  _buildActions(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.group_add,
            color: CareCircleDesignTokens.primaryMedicalBlue,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Care Group',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Set up a new care coordination group',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildBasicInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Group Name *',
            hintText: 'e.g., Smith Family Care',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.group),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a group name';
            }
            if (value.trim().length < 3) {
              return 'Group name must be at least 3 characters';
            }
            return null;
          },
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Description (Optional)',
            hintText: 'Describe the purpose of this care group',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.description),
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group Settings',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildSettingTile(
          'Allow Health Data Sharing',
          'Members can share health metrics and data',
          _allowHealthDataSharing,
          (value) => setState(() => _allowHealthDataSharing = value),
          Icons.health_and_safety,
        ),
        _buildSettingTile(
          'Allow Medication Sharing',
          'Members can share medication information',
          _allowMedicationSharing,
          (value) => setState(() => _allowMedicationSharing = value),
          Icons.medication,
        ),
        _buildSettingTile(
          'Require Approval for New Members',
          'Admin approval needed for new member invitations',
          _requireApprovalForNewMembers,
          (value) => setState(() => _requireApprovalForNewMembers = value),
          Icons.admin_panel_settings,
        ),
        _buildSettingTile(
          'Enable Task Notifications',
          'Send notifications for task assignments and updates',
          _enableTaskNotifications,
          (value) => setState(() => _enableTaskNotifications = value),
          Icons.notifications,
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        secondary: Icon(icon, color: CareCircleDesignTokens.primaryMedicalBlue),
        value: value,
        onChanged: onChanged,
        activeColor: CareCircleDesignTokens.primaryMedicalBlue,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _isLoading ? null : _createGroup,
          style: ElevatedButton.styleFrom(
            backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Create Group'),
        ),
      ],
    );
  }

  Future<void> _createGroup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final settings = CareGroupSettings(
        allowHealthDataSharing: _allowHealthDataSharing,
        allowMedicationSharing: _allowMedicationSharing,
        requireApprovalForNewMembers: _requireApprovalForNewMembers,
        enableTaskNotifications: _enableTaskNotifications,
      );

      final group = await ref
          .read(careGroupNotifierProvider.notifier)
          .createCareGroup(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            settings: settings,
          );

      if (mounted) {
        Navigator.of(context).pop();
        widget.onGroupCreated?.call(group);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Care group "${group.name}" created successfully!'),
            backgroundColor: CareCircleDesignTokens.healthGreen,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create care group: $error'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
