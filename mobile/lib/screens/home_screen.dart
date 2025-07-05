import 'package:flutter/material.dart';
import '../config/router_config.dart';
import '../widgets/error_boundary.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CareCircle'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () => context.goToNotifications(),
              tooltip: 'Notifications',
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => context.goToProfile(),
              tooltip: 'Profile',
            ),
          ],
        ),
        body: ErrorBoundary(
          errorMessage: 'Unable to load home screen content',
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.health_and_safety,
                                color: Theme.of(context).primaryColor,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome to CareCircle',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Your health journey starts here',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Features Title
                  const Text(
                    'Features',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Features Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _buildFeatureCard(
                        context,
                        icon: Icons.health_and_safety,
                        title: 'Health Data',
                        subtitle: 'Sync with Apple Health & Google Fit',
                        color: Colors.blue,
                        onTap: () => context.goToHealthData(),
                      ),
                      _buildFeatureCard(
                        context,
                        icon: Icons.medication,
                        title: 'Prescriptions',
                        subtitle: 'Manage medications',
                        color: Colors.green,
                        onTap: () => context.goToPrescriptionScanner(),
                      ),
                      _buildFeatureCard(
                        context,
                        icon: Icons.notifications,
                        title: 'Reminders',
                        subtitle: 'Smart notifications',
                        color: Colors.orange,
                        onTap: () => Navigator.pushNamed(context, '/reminders'),
                      ),
                      _buildFeatureCard(
                        context,
                        icon: Icons.check_circle_outline,
                        title: 'Daily Check-ins',
                        subtitle: 'Track your wellness',
                        color: Colors.purple,
                        onTap: () => context.goToHealthCheck(),
                      ),
                      _buildFeatureCard(
                        context,
                        icon: Icons.group,
                        title: 'Care Circle',
                        subtitle: 'Family & caregivers',
                        color: Colors.teal,
                        onTap: () => context.goToCareGroup(),
                      ),
                      _buildFeatureCard(
                        context,
                        icon: Icons.analytics,
                        title: 'Insights',
                        subtitle: 'Health analytics',
                        color: Colors.indigo,
                        onTap: () => Navigator.pushNamed(context, '/insights'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
