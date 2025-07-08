import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/widgets/care_circle_button.dart';
import '../providers/auth_provider.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),

              // App Logo and Title
              Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'CareCircle',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your healthcare companion for better health management',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const Spacer(),

              // Feature highlights
              Column(
                children: [
                  _FeatureItem(
                    icon: Icons.health_and_safety,
                    title: 'Health Tracking',
                    description: 'Monitor your vital signs and health metrics',
                  ),
                  const SizedBox(height: 16),
                  _FeatureItem(
                    icon: Icons.medication,
                    title: 'Medication Management',
                    description: 'Never miss a dose with smart reminders',
                  ),
                  const SizedBox(height: 16),
                  _FeatureItem(
                    icon: Icons.family_restroom,
                    title: 'Care Circle',
                    description: 'Connect with family and caregivers',
                  ),
                ],
              ),

              const Spacer(),

              // Action buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CareCircleButton(
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              context.push('/auth/register');
                            },
                      text: 'Get Started',
                      variant: CareCircleButtonVariant.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CareCircleButton(
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              context.push('/auth/login');
                            },
                      text: 'Sign In',
                      variant: CareCircleButtonVariant.secondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: authState.isLoading
                        ? null
                        : () async {
                            await ref
                                .read(authNotifierProvider.notifier)
                                .loginAsGuest();
                          },
                    child: Text(
                      'Continue as Guest',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: CareCircleDesignTokens.primaryMedicalBlue,
                      ),
                    ),
                  ),
                  if (authState.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: CareCircleDesignTokens.healthGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: CareCircleDesignTokens.healthGreen,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
