import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/widgets/care_circle_button.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../notification/presentation/providers/notification_providers.dart';

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
          // Notification icon with badge
          Consumer(
            builder: (context, ref, child) {
              final unreadCountAsync = ref.watch(
                unreadNotificationCountProvider,
              );
              return unreadCountAsync.when(
                data: (unreadCount) => Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () => context.push('/notifications'),
                      tooltip: 'Notifications',
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: CareCircleDesignTokens.errorRed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            unreadCount > 99 ? '99+' : unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                loading: () => IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => context.push('/notifications'),
                  tooltip: 'Notifications',
                ),
                error: (_, _) => IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => context.push('/notifications'),
                  tooltip: 'Notifications',
                ),
              );
            },
          ),
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
                        NavigationService.navigateToHealthData(context);
                      },
                    ),
                    _QuickActionCard(
                      icon: Icons.medication,
                      title: 'Medications',
                      subtitle: 'Manage pills',
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                      onTap: () {
                        NavigationService.navigateToMedications(context);
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
                      icon: Icons.emergency,
                      title: 'Emergency',
                      subtitle: 'Quick access',
                      color: Colors.red,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Emergency features coming soon'),
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
