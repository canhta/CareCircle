import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/widgets/care_circle_button.dart';
import '../providers/auth_provider.dart';
import '../../domain/models/auth_models.dart';

class ConvertGuestScreen extends ConsumerWidget {
  const ConvertGuestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    'Create a permanent account to save your health data and sync across devices',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // Google Sign Up button
              CareCircleButton(
                onPressed: authState.isLoading
                    ? null
                    : () async {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .signInWithGoogle();
                      },
                text: 'Continue with Google',
                variant: CareCircleButtonVariant.primary,
                icon: Icons.g_mobiledata,
              ),

              const SizedBox(height: 16),

              // Apple Sign Up button
              CareCircleButton(
                onPressed: authState.isLoading
                    ? null
                    : () async {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .signInWithApple();
                      },
                text: 'Continue with Apple',
                variant: CareCircleButtonVariant.secondary,
                icon: Icons.apple,
              ),

              const SizedBox(height: 32),

              // Note about conversion
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
                      alpha: 0.2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Converting your guest account will preserve all your current health data and settings.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: CareCircleDesignTokens.primaryMedicalBlue,
                        ),
                      ),
                    ),
                  ],
                ),
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
    );
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
