import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/widgets/care_circle_button.dart';
import '../../../../core/widgets/care_circle_text_field.dart';
import '../../infrastructure/services/firebase_auth_service.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firebaseAuthService = FirebaseAuthService();

  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
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
                    child: Icon(
                      _emailSent ? Icons.mark_email_read : Icons.lock_reset,
                      size: 40,
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _emailSent ? 'Check Your Email' : 'Reset Your Password',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _emailSent
                        ? 'We\'ve sent a password reset link to your email address. Please check your inbox and follow the instructions to reset your password.'
                        : 'Enter your email address and we\'ll send you a link to reset your password.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              if (!_emailSent) ...[
                // Email form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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

                      const SizedBox(height: 32),

                      // Send reset email button
                      CareCircleButton(
                        onPressed: _isLoading ? null : _handleSendResetEmail,
                        isLoading: _isLoading,
                        text: 'Send Reset Link',
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Email sent confirmation
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
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: CareCircleDesignTokens.healthGreen,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Reset link sent!',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CareCircleDesignTokens.healthGreen,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Check your email for the password reset link. It may take a few minutes to arrive.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.8,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Resend email button
                OutlinedButton(
                  onPressed: _isLoading ? null : _handleResendEmail,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Resend Email',
                          style: TextStyle(
                            color: CareCircleDesignTokens.primaryMedicalBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],

              const SizedBox(height: 32),

              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Instructions',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _InstructionItem(
                      number: '1',
                      text: 'Check your email inbox for the reset link',
                    ),
                    const SizedBox(height: 8),
                    _InstructionItem(
                      number: '2',
                      text:
                          'Click the link in the email to open the reset page',
                    ),
                    const SizedBox(height: 8),
                    _InstructionItem(
                      number: '3',
                      text: 'Enter your new password and confirm it',
                    ),
                    const SizedBox(height: 8),
                    _InstructionItem(
                      number: '4',
                      text:
                          'Return to the app and sign in with your new password',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Back to login
              TextButton(
                onPressed: () => context.go('/auth/login'),
                child: Text(
                  'Back to Sign In',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: CareCircleDesignTokens.primaryMedicalBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSendResetEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _firebaseAuthService.sendPasswordResetEmail(
          _emailController.text.trim(),
        );
        setState(() {
          _emailSent = true;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: CareCircleDesignTokens.criticalAlert,
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

  Future<void> _handleResendEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _firebaseAuthService.sendPasswordResetEmail(
        _emailController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Reset link sent again!'),
            backgroundColor: CareCircleDesignTokens.healthGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
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

class _InstructionItem extends StatelessWidget {
  final String number;
  final String text;

  const _InstructionItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: CareCircleDesignTokens.primaryMedicalBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              number,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
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
