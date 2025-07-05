import 'package:flutter/material.dart';
import '../common/common.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  late final AppLogger _logger;

  @override
  void initState() {
    super.initState();
    _logger = AppLogger('RemindersScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddReminderDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildReminderTypes(),
            const SizedBox(height: 24),
            _buildActiveReminders(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Smart Reminders',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Set up personalized reminders for medications, check-ins, appointments, and more. '
              'Our smart system learns your routine and sends notifications at the best times.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reminder Types',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildReminderTypeCard(
              icon: Icons.medication,
              title: 'Medications',
              subtitle: 'Never miss a dose',
              color: Colors.blue,
              onTap: () => Navigator.pushNamed(context, '/medications'),
            ),
            _buildReminderTypeCard(
              icon: Icons.check_circle,
              title: 'Check-ins',
              subtitle: 'Daily health updates',
              color: Colors.green,
              onTap: () => _showComingSoonDialog('Daily Check-in Reminders'),
            ),
            _buildReminderTypeCard(
              icon: Icons.calendar_today,
              title: 'Appointments',
              subtitle: 'Doctor visits',
              color: Colors.orange,
              onTap: () => _showComingSoonDialog('Appointment Reminders'),
            ),
            _buildReminderTypeCard(
              icon: Icons.fitness_center,
              title: 'Exercise',
              subtitle: 'Stay active',
              color: Colors.purple,
              onTap: () => _showComingSoonDialog('Exercise Reminders'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReminderTypeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveReminders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Active Reminders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _showComingSoonDialog('Reminder Management'),
              child: const Text('Manage All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildRemindersList(),
      ],
    );
  }

  Widget _buildRemindersList() {
    // Sample reminder data
    final reminders = [
      {
        'title': 'Morning Medication',
        'subtitle': 'Take 2 tablets with breakfast',
        'time': '8:00 AM',
        'icon': Icons.medication,
        'color': Colors.blue,
        'enabled': true,
      },
      {
        'title': 'Daily Check-in',
        'subtitle': 'Record your health status',
        'time': '7:00 PM',
        'icon': Icons.check_circle,
        'color': Colors.green,
        'enabled': true,
      },
      {
        'title': 'Evening Walk',
        'subtitle': '30 minutes of light exercise',
        'time': '6:00 PM',
        'icon': Icons.directions_walk,
        'color': Colors.orange,
        'enabled': false,
      },
    ];

    return Column(
      children: reminders.map((reminder) {
        return Card(
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (reminder['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                reminder['icon'] as IconData,
                color: reminder['color'] as Color,
                size: 20,
              ),
            ),
            title: Text(reminder['title'] as String),
            subtitle: Text(reminder['subtitle'] as String),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  reminder['time'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: reminder['enabled'] as bool,
                  onChanged: (value) => _toggleReminder(reminder['title'] as String, value),
                ),
              ],
            ),
            onTap: () => _showReminderDetails(reminder),
          ),
        );
      }).toList(),
    );
  }

  void _showAddReminderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Reminder'),
        content: const Text(
          'Reminder creation will be available in a future update. '
          'For now, you can manage medication reminders through the Medications section.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/medications');
            },
            child: const Text('Go to Medications'),
          ),
        ],
      ),
    );
  }

  void _toggleReminder(String title, bool enabled) {
    _logger.info('Toggling reminder: $title to $enabled');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title reminder ${enabled ? 'enabled' : 'disabled'}'),
      ),
    );
  }

  void _showReminderDetails(Map<String, dynamic> reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reminder['title'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reminder['subtitle'] as String),
            const SizedBox(height: 8),
            Text('Time: ${reminder['time']}'),
            const SizedBox(height: 8),
            Text('Status: ${reminder['enabled'] ? 'Active' : 'Inactive'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoonDialog('Reminder Editing');
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: Text('$feature will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
