// Invite Member Screen
// Allows users to invite new members to a care group

import 'package:flutter/material.dart';
import 'dart:developer';
import '../features/care_group/domain/care_group_models.dart';
import '../features/care_group/data/care_group_service.dart';
import '../common/common.dart';

class InviteMemberScreen extends StatefulWidget {
  final CareGroup careGroup;

  const InviteMemberScreen({
    super.key,
    required this.careGroup,
  });

  @override
  State<InviteMemberScreen> createState() => _InviteMemberScreenState();
}

class _InviteMemberScreenState extends State<InviteMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  late final CareGroupService _careGroupService;

  CareGroupRole _selectedRole = CareGroupRole.member;
  bool _canViewHealth = false;
  bool _canReceiveAlerts = true;
  bool _canManageSettings = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _careGroupService = CareGroupService(
      apiClient: ApiClient.instance,
      logger: AppLogger('InviteMemberScreen'),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Member'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16),

            // Header
            _buildHeader(),

            const SizedBox(height: 32),

            // Email Field
            _buildEmailField(),

            const SizedBox(height: 24),

            // Role Selection
            _buildRoleSelection(),

            const SizedBox(height: 24),

            // Permissions
            _buildPermissions(),

            const SizedBox(height: 24),

            // Optional Message
            _buildMessageField(),

            const SizedBox(height: 32),

            // Send Invitation Button
            _buildSendButton(),

            const SizedBox(height: 16),

            // Cancel Button
            _buildCancelButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_add,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Invite to ${widget.careGroup.name}',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Send an invitation to join your care group and start sharing health updates.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email Address',
        hintText: 'Enter the email address of the person to invite',
        prefixIcon: Icon(Icons.email_outlined),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an email address';
        }

        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Please enter a valid email address';
        }

        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Role',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Select the role for this member in your care group.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        ...CareGroupRole.values.map(
          (role) => _buildRoleOption(role),
        ),
      ],
    );
  }

  Widget _buildRoleOption(CareGroupRole role) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: RadioListTile<CareGroupRole>(
        value: role,
        groupValue: _selectedRole,
        onChanged: (CareGroupRole? value) {
          setState(() {
            _selectedRole = value!;
            _updatePermissionsForRole(value);
          });
        },
        title: Text(_getRoleDisplayName(role)),
        subtitle: Text(_getRoleDescription(role)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildPermissions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Permissions',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Customize what this member can access and do.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              _buildPermissionTile(
                title: 'View Health Data',
                subtitle: 'Can view health check-ins and medical information',
                icon: Icons.health_and_safety,
                value: _canViewHealth,
                onChanged: (value) {
                  setState(() {
                    _canViewHealth = value;
                  });
                },
              ),
              const Divider(height: 1),
              _buildPermissionTile(
                title: 'Receive Alerts',
                subtitle: 'Will receive notifications about health alerts',
                icon: Icons.notifications,
                value: _canReceiveAlerts,
                onChanged: (value) {
                  setState(() {
                    _canReceiveAlerts = value;
                  });
                },
              ),
              const Divider(height: 1),
              _buildPermissionTile(
                title: 'Manage Settings',
                subtitle: 'Can modify group settings and member permissions',
                icon: Icons.settings,
                value: _canManageSettings,
                onChanged: _selectedRole == CareGroupRole.admin
                    ? (value) {
                        setState(() {
                          _canManageSettings = value;
                        });
                      }
                    : null,
                enabled: _selectedRole == CareGroupRole.admin,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool>? onChanged,
    bool enabled = true,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          color: enabled ? null : Colors.grey,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: enabled ? null : Colors.grey,
        ),
      ),
      secondary: Icon(
        icon,
        color: enabled ? Theme.of(context).colorScheme.primary : Colors.grey,
      ),
      value: value,
      onChanged: enabled ? onChanged : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildMessageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Message (Optional)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _messageController,
          decoration: const InputDecoration(
            hintText: 'Add a personal message to the invitation...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) {
            if (value != null && value.trim().length > 200) {
              return 'Message must be less than 200 characters';
            }
            return null;
          },
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _sendInvitation,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Send Invitation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: _isLoading ? null : () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    );
  }

  // Helper functions for role display
  String _getRoleDisplayName(CareGroupRole role) {
    switch (role) {
      case CareGroupRole.admin:
        return 'Admin';
      case CareGroupRole.member:
        return 'Member';
      case CareGroupRole.viewer:
        return 'Viewer';
    }
  }

  String _getRoleDescription(CareGroupRole role) {
    switch (role) {
      case CareGroupRole.admin:
        return 'Full access to manage the group and its members';
      case CareGroupRole.member:
        return 'Can view and interact with group content';
      case CareGroupRole.viewer:
        return 'Can only view group content';
    }
  }

  void _updatePermissionsForRole(CareGroupRole role) {
    switch (role) {
      case CareGroupRole.admin:
        _canViewHealth = true;
        _canReceiveAlerts = true;
        _canManageSettings = true;
        break;
      case CareGroupRole.member:
        _canViewHealth = false;
        _canReceiveAlerts = true;
        _canManageSettings = false;
        break;
      case CareGroupRole.viewer:
        _canViewHealth = false;
        _canReceiveAlerts = false;
        _canManageSettings = false;
        break;
    }
  }

  Future<void> _sendInvitation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = SendInvitationRequest(
        email: _emailController.text.trim(),
      );

      final result = await _careGroupService.sendInvitation(
        widget.careGroup.id,
        request,
      );

      result.fold(
        (invitation) {
          if (mounted) {
            _showInvitationSentDialog();
          }
        },
        (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to send invitation: ${error.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    } catch (e) {
      log('Error sending invitation: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send invitation: ${e.toString()}'),
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

  void _showInvitationSentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Invitation Sent!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The invitation has been sent to ${_emailController.text.trim()}.',
            ),
            const SizedBox(height: 16),
            const Text(
              'They will receive an email with instructions to join the group.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(true); // Go back to previous screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
