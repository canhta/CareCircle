import 'package:flutter/material.dart';
import '../screens/health_data_screen.dart';
import '../utils/notification_test_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CareCircle'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to CareCircle',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Manage your health and care activities',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              
              // Debug notification test widget (only in debug mode)
              if (const bool.fromEnvironment('dart.vm.product') == false)
                const NotificationTestWidget(),
              
              const SizedBox(height: 16),
              SizedBox(
                height: 400, // Fixed height for the grid
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                  _buildFeatureCard(
                    context,
                    icon: Icons.health_and_safety,
                    title: 'Health Data',
                    subtitle: 'Sync with Apple Health & Google Fit',
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HealthDataScreen(),
                      ),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.medication,
                    title: 'Prescriptions',
                    subtitle: 'Manage medications',
                    color: Colors.green,
                    onTap: () =>
                        Navigator.pushNamed(context, '/prescription-scanner'),
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.notifications,
                    title: 'Reminders',
                    subtitle: 'Smart notifications',
                    color: Colors.orange,
                    onTap: () => _showComingSoon(context, 'Reminders'),
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.check_circle_outline,
                    title: 'Daily Check-ins',
                    subtitle: 'Track your wellness',
                    color: Colors.purple,
                    onTap: () => _showComingSoon(context, 'Daily Check-ins'),
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.group,
                    title: 'Care Circle',
                    subtitle: 'Family & caregivers',
                    color: Colors.teal,
                    onTap: () => _showComingSoon(context, 'Care Circle'),
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.analytics,
                    title: 'Insights',
                    subtitle: 'Health analytics',
                    color: Colors.indigo,
                    onTap: () => _showComingSoon(context, 'Insights'),
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

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: Text('$feature feature is coming soon!'),
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
