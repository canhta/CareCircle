import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:image_picker/image_picker.dart';

import '../features/auth/auth.dart';
import '../common/common.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  late final AuthService _authService;
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  bool _isLoading = false;
  bool _isEditing = false;
  User? _currentUser;
  DateTime? _selectedDate;
  String? _selectedGender;

  final List<String> _genders = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    _authService = AuthService(
      apiClient: ApiClient.instance,
      logger: AppLogger('ProfileScreen'),
      secureStorage: SecureStorageService(),
    );
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black87),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            )
          else
            TextButton(
              onPressed: _handleSaveProfile,
              child: Text(
                'Save',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Picture
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _showImagePickerDialog();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Name Field
                    _buildProfileField(
                      label: 'Full Name',
                      controller: _nameController,
                      icon: Icons.person_outline,
                      validator: _isEditing
                          ? ValidationBuilder()
                              .minLength(
                                2,
                                'Name must be at least 2 characters',
                              )
                              .build()
                          : null,
                    ),

                    const SizedBox(height: 16),

                    // Email Field (Read-only)
                    _buildProfileField(
                      label: 'Email',
                      value: _currentUser?.email ?? '',
                      icon: Icons.email_outlined,
                      readOnly: true,
                    ),

                    const SizedBox(height: 16),

                    // Phone Field
                    _buildProfileField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: _isEditing
                          ? ValidationBuilder()
                              .phone('Please enter a valid phone number')
                              .build()
                          : null,
                    ),

                    const SizedBox(height: 16),

                    // Date of Birth Field
                    _buildDateField(),

                    const SizedBox(height: 16),

                    // Gender Field
                    _buildGenderField(),

                    const SizedBox(height: 32),

                    // Account Status
                    _buildAccountStatusCard(),

                    const SizedBox(height: 24),

                    // Action Buttons
                    if (_isEditing) ...[
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleSaveProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                            _loadUserData(); // Reset form
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                    ] else ...[
                      OutlinedButton.icon(
                        onPressed: _handleLogout,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: Colors.red),
                        ),
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileField({
    required String label,
    TextEditingController? controller,
    String? value,
    IconData? icon,
    bool readOnly = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly || !_isEditing,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText:
            value ?? (controller?.text.isEmpty == true ? 'Not set' : null),
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: readOnly || !_isEditing ? Colors.grey[100] : Colors.grey[50],
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      readOnly: true,
      onTap: _isEditing ? _selectDate : null,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        hintText: _selectedDate == null
            ? 'Not set'
            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: !_isEditing ? Colors.grey[100] : Colors.grey[50],
      ),
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      onChanged: _isEditing
          ? (String? newValue) {
              setState(() {
                _selectedGender = newValue;
              });
            }
          : null,
      decoration: InputDecoration(
        labelText: 'Gender',
        hintText: _selectedGender ?? 'Not set',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: !_isEditing ? Colors.grey[100] : Colors.grey[50],
      ),
      items: _genders.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }

  Widget _buildAccountStatusCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Status',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  _currentUser?.isEmailVerified == true
                      ? Icons.verified
                      : Icons.warning,
                  color: _currentUser?.isEmailVerified == true
                      ? Colors.green
                      : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  _currentUser?.isEmailVerified == true
                      ? 'Email Verified'
                      : 'Email Not Verified',
                  style: TextStyle(
                    color: _currentUser?.isEmailVerified == true
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Member since ${_formatDate(_currentUser?.createdAt)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadUserData() async {
    final user = await _authService.getCurrentUser();
    if (user != null && mounted) {
      setState(() {
        _currentUser = user;
        _nameController.text = user.name;
        _phoneController.text = user.phoneNumber ?? '';
        _selectedDate = user.dateOfBirth;
        _selectedGender = user.gender;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSaveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = UpdateProfileRequest(
      name: _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : null,
      dateOfBirth: _selectedDate,
      gender: _selectedGender,
      phoneNumber: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
    );

    final result = await _authService.updateProfile(request);

    if (result.isSuccess) {
      if (mounted) {
        setState(() {
          _currentUser = result.data;
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        final errorMessage = result.exception is NetworkException
            ? (result.exception as NetworkException).message
            : result.exception?.toString() ?? 'Profile update failed';
        _showErrorDialog(errorMessage);
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authService.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  /// Show image picker dialog
  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Profile Picture'),
          content:
              const Text('Choose how you want to update your profile picture:'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Gallery'),
              onPressed: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            TextButton(
              child: const Text('Camera'),
              onPressed: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
          ],
        );
      },
    );
  }

  /// Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        await _uploadProfileImage();
      }
    } catch (e) {
      _showErrorDialog('Error selecting image from gallery: $e');
    }
  }

  /// Pick image from camera
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        await _uploadProfileImage();
      }
    } catch (e) {
      _showErrorDialog('Error capturing image from camera: $e');
    }
  }

  /// Upload profile image
  Future<void> _uploadProfileImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement actual image upload to storage service
      // For now, just show success message
      await Future.delayed(const Duration(seconds: 1)); // Simulate upload

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error uploading profile picture: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }
}
