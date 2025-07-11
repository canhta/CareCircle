import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/design/care_circle_icons.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/widgets/care_circle_button.dart';
import '../../../core/widgets/healthcare/healthcare_welcome_card.dart';
import '../../../core/widgets/healthcare/healthcare_action_card.dart';
import '../../../core/widgets/layout/care_circle_responsive_grid.dart';
import '../../../core/widgets/navigation/care_circle_tab_bar.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../notification/presentation/providers/notification_providers.dart';
import 'modern_ui_showcase_screen.dart';

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
              // Healthcare Welcome Card
              HealthcareWelcomeCard(
                userName:
                    profile?.displayName ??
                    (user?.isGuest == true ? 'Guest' : 'User'),
                lastHealthUpdate: DateTime.now().subtract(
                  const Duration(hours: 2),
                ),
                healthStatus: _getHealthStatus(user),
                onHealthCheckTap: () {
                  NavigationService.navigateToHealthData(context);
                },
                customMessage: user?.isGuest == true
                    ? 'Create an account to save your health data and access all features.'
                    : null,
                semanticLabel: 'Welcome section with health overview',
                semanticHint:
                    'Your current health status and quick access to health check',
              ),

              // Guest Account Conversion
              if (user?.isGuest == true) ...[
                const SizedBox(height: 16),
                CareCircleButton(
                  onPressed: () {
                    context.push('/auth/convert-guest');
                  },
                  text: 'Create Account',
                  variant: CareCircleButtonVariant.primary,
                  isFullWidth: false,
                  semanticLabel: 'Create account button',
                  semanticHint:
                      'Convert guest account to full account to save data',
                ),
              ],

              const SizedBox(height: 32),

              // Healthcare Quick Actions
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: CareCircleSpacingTokens.md,
                  vertical: CareCircleSpacingTokens.sm,
                ),
                decoration: CareCircleGlassmorphismTokens.lightCardGlass(
                  borderRadius: CareCircleModernEffectsTokens.radiusSM,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(CareCircleSpacingTokens.xs),
                      decoration: BoxDecoration(
                        gradient: CareCircleGradientTokens.primaryMedical,
                        borderRadius: CareCircleModernEffectsTokens.radiusXS,
                      ),
                      child: const Icon(
                        Icons.dashboard,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: CareCircleSpacingTokens.sm),
                    Text(
                      'Quick Actions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CareCircleColorTokens.primaryMedicalBlue,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: CareCircleResponsiveGrid(
                  mobileColumns: 2,
                  tabletColumns: 3,
                  desktopColumns: 4,
                  semanticLabel: 'Healthcare quick actions grid',
                  children: [
                    HealthcareActionCard(
                      icon: CareCircleIcons.healthMetrics,
                      title: 'Health Metrics',
                      subtitle: 'Track vitals and trends',
                      color: CareCircleColorTokens.healthGreen,
                      onTap: () {
                        NavigationService.navigateToHealthData(context);
                      },
                      semanticLabel: 'Health metrics',
                      semanticHint:
                          'View and track your vital signs and health trends',
                      lastUpdated: DateTime.now().subtract(
                        const Duration(hours: 1),
                      ),
                      urgencyLevel: _getHealthMetricsUrgency(),
                    ),
                    HealthcareActionCard(
                      icon: CareCircleIcons.medication,
                      title: 'Medications',
                      subtitle: 'Manage prescriptions',
                      color: CareCircleColorTokens.prescriptionBlue,
                      onTap: () {
                        NavigationService.navigateToMedications(context);
                      },
                      semanticLabel: 'Medications',
                      semanticHint:
                          'Manage your medications and view reminders',
                      badge: _getMedicationsBadge(),
                      urgencyLevel: _getMedicationsUrgency(),
                      lastUpdated: DateTime.now().subtract(
                        const Duration(minutes: 30),
                      ),
                    ),
                    HealthcareActionCard(
                      icon: CareCircleIcons.careCircle,
                      title: 'Care Circle',
                      subtitle: 'Family & caregivers',
                      color: CareCircleColorTokens.primaryMedicalBlue,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Care circle coming soon'),
                          ),
                        );
                      },
                      semanticLabel: 'Care circle',
                      semanticHint:
                          'Connect with your care team and family members',
                      isEnabled: false, // Coming soon
                    ),
                    HealthcareActionCard(
                      icon: CareCircleIcons.emergency,
                      title: 'Emergency',
                      subtitle: 'Quick access',
                      color: CareCircleColorTokens.emergencyRed,
                      onTap: () {
                        _showEmergencyDialog(context);
                      },
                      semanticLabel: 'Emergency access',
                      semanticHint:
                          'Quick access to emergency contacts and services',
                      urgencyLevel: UrgencyLevel.critical,
                    ),
                    HealthcareActionCard(
                      icon: Icons.palette,
                      title: 'Modern UI Showcase',
                      subtitle: 'See new design features',
                      color: const Color(0xFF7C4DFF),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ModernUIShowcaseScreen(),
                          ),
                        );
                      },
                      semanticLabel: 'Modern UI showcase',
                      semanticHint:
                          'View the new modern design features and components',
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

  // Helper methods for healthcare functionality
  HealthStatus _getHealthStatus(dynamic user) {
    if (user?.isGuest == true) {
      return HealthStatus.unknown;
    }
    // TODO: Implement actual health status calculation
    return HealthStatus.good;
  }

  UrgencyLevel _getHealthMetricsUrgency() {
    // TODO: Implement health metrics urgency calculation
    return UrgencyLevel.none;
  }

  String? _getMedicationsBadge() {
    // TODO: Implement medications badge calculation
    // Return number of missed medications or null
    return null;
  }

  UrgencyLevel _getMedicationsUrgency() {
    // TODO: Implement medications urgency calculation
    return UrgencyLevel.none;
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Access'),
        content: const Text(
          'Emergency features are coming soon. In case of a real emergency, please call 911 or your local emergency services.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
