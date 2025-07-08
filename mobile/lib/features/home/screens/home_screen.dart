import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/widgets/care_circle_button.dart';
import '../../auth/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final profile = authState.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CareCircle'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.isGuest == true
                          ? 'Welcome, Guest!'
                          : 'Welcome back!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CareCircleDesignTokens.primaryMedicalBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile?.displayName ?? 'Guest User',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: CareCircleDesignTokens.primaryMedicalBlue
                            .withValues(alpha: 0.8),
                      ),
                    ),
                    if (user?.isGuest == true) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Create an account to save your health data and access all features.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CareCircleButton(
                        onPressed: () {
                          context.push('/auth/convert-guest');
                        },
                        text: 'Create Account',
                        variant: CareCircleButtonVariant.primary,
                        isFullWidth: false,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Quick actions
              Text(
                'Quick Actions',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _QuickActionCard(
                      icon: Icons.health_and_safety,
                      title: 'Health Metrics',
                      subtitle: 'Track vitals',
                      color: CareCircleDesignTokens.healthGreen,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Health metrics coming soon'),
                          ),
                        );
                      },
                    ),
                    _QuickActionCard(
                      icon: Icons.medication,
                      title: 'Medications',
                      subtitle: 'Manage pills',
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Medications coming soon'),
                          ),
                        );
                      },
                    ),
                    _QuickActionCard(
                      icon: Icons.family_restroom,
                      title: 'Care Circle',
                      subtitle: 'Family & caregivers',
                      color: Colors.purple,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Care circle coming soon'),
                          ),
                        );
                      },
                    ),
                    _QuickActionCard(
                      icon: Icons.smart_toy,
                      title: 'AI Assistant',
                      subtitle: 'Health insights',
                      color: Colors.orange,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('AI assistant coming soon'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
