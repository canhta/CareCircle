import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/design_tokens.dart';
import '../../../core/widgets/care_circle_button.dart';
import '../../../core/widgets/care_circle_text_field.dart';
import '../providers/auth_provider.dart';
import '../models/auth_models.dart';

class ConvertGuestScreen extends ConsumerStatefulWidget {
  const ConvertGuestScreen({super.key});

  @override
  ConsumerState<ConvertGuestScreen> createState() => _ConvertGuestScreenState();
}

class _ConvertGuestScreenState extends ConsumerState<ConvertGuestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    // Listen for auth state changes
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go('/home');
      }

      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
        ref.read(authNotifierProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: CareCircleDesignTokens.primaryMedicalBlue
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.person_add,
                        size: 40,
                        color: CareCircleDesignTokens.primaryMedicalBlue,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Convert Guest Account',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CareCircleDesignTokens.primaryMedicalBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create a permanent account to save your health data and access all features',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Form fields
                CareCircleTextField(
                  controller: _displayNameController,
                  label: 'Display Name',
                  hintText: 'Enter your display name',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your display name';
                    }
                    if (value.trim().length < 2) {
                      return 'Display name must be at least 2 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                CareCircleTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hintText: 'Enter your email address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                CareCircleTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: 'Create a strong password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (!RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
                    ).hasMatch(value)) {
                      return 'Password must contain uppercase, lowercase, and number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                CareCircleTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hintText: 'Confirm your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Convert button
                CareCircleButton(
                  onPressed: authState.isLoading ? null : _handleConvertGuest,
                  isLoading: authState.isLoading,
                  text: 'Create Account',
                ),

                const SizedBox(height: 24),

                // Benefits section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CareCircleDesignTokens.healthGreen.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: CareCircleDesignTokens.healthGreen.withValues(
                        alpha: 0.3,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.verified_user,
                            color: CareCircleDesignTokens.healthGreen,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Account Benefits',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: CareCircleDesignTokens.healthGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _BenefitItem(
                        icon: Icons.cloud_upload,
                        text: 'Secure cloud backup of your health data',
                      ),
                      const SizedBox(height: 8),
                      _BenefitItem(
                        icon: Icons.family_restroom,
                        text: 'Join and create care groups with family',
                      ),
                      const SizedBox(height: 8),
                      _BenefitItem(
                        icon: Icons.sync,
                        text: 'Sync data across all your devices',
                      ),
                      const SizedBox(height: 8),
                      _BenefitItem(
                        icon: Icons.psychology,
                        text: 'Personalized AI health insights',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Continue as guest option
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    'Continue as Guest',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleConvertGuest() {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(authNotifierProvider.notifier)
          .convertGuest(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: _displayNameController.text.trim(),
          );
    }
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 16, color: CareCircleDesignTokens.healthGreen),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }
}
