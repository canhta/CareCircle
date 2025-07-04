import 'package:flutter/material.dart';
import '../models/daily_check_in_models.dart';
import '../services/daily_check_in_service.dart';
import 'personalized_questions_screen.dart';
import 'check_in_history_screen.dart';
import 'insights_screen.dart';

class DailyCheckInScreen extends StatefulWidget {
  const DailyCheckInScreen({super.key});

  @override
  State<DailyCheckInScreen> createState() => _DailyCheckInScreenState();
}

class _DailyCheckInScreenState extends State<DailyCheckInScreen> {
  final DailyCheckInService _service = DailyCheckInService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();

  // Form state
  double _moodScore = 5;
  double _energyLevel = 5;
  double _sleepQuality = 5;
  double _painLevel = 0;
  double _stressLevel = 5;
  List<String> _symptoms = [];
  String _notes = '';

  // UI state
  bool _isLoading = false;
  DailyCheckIn? _todaysCheckIn;
  bool _isEditing = false;

  // Common symptoms for quick selection
  final List<String> _commonSymptoms = [
    'Headache',
    'Nausea',
    'Fatigue',
    'Joint pain',
    'Muscle aches',
    'Dizziness',
    'Anxiety',
    'Difficulty sleeping',
    'Loss of appetite',
    'Shortness of breath',
  ];

  @override
  void initState() {
    super.initState();
    _loadTodaysCheckIn();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  Future<void> _loadTodaysCheckIn() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final checkIn = await _service.getTodayCheckIn();
      if (mounted) {
        setState(() {
          _todaysCheckIn = checkIn;
          if (checkIn != null) {
            _populateFormFromCheckIn(checkIn);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Failed to load today\'s check-in: ${e.toString()}');
      }
    }
  }

  void _populateFormFromCheckIn(DailyCheckIn checkIn) {
    _moodScore = checkIn.moodScore?.toDouble() ?? 5;
    _energyLevel = checkIn.energyLevel?.toDouble() ?? 5;
    _sleepQuality = checkIn.sleepQuality?.toDouble() ?? 5;
    _painLevel = checkIn.painLevel?.toDouble() ?? 0;
    _stressLevel = checkIn.stressLevel?.toDouble() ?? 5;
    _symptoms = List<String>.from(checkIn.symptoms);
    _notes = checkIn.notes ?? '';
    _notesController.text = _notes;
    _symptomsController.text = _symptoms.join(', ');
  }

  Future<void> _saveCheckIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = CreateDailyCheckInRequest(
        date: _service.formatDateForApi(DateTime.now()),
        moodScore: _moodScore.round(),
        energyLevel: _energyLevel.round(),
        sleepQuality: _sleepQuality.round(),
        painLevel: _painLevel.round(),
        stressLevel: _stressLevel.round(),
        symptoms: _symptoms,
        notes: _notes.isNotEmpty ? _notes : null,
        completed: true,
      );

      final savedCheckIn = await _service.createOrUpdateTodaysCheckIn(request);

      if (mounted) {
        setState(() {
          _todaysCheckIn = savedCheckIn;
          _isEditing = false;
          _isLoading = false;
        });

        _showSuccessSnackBar('Check-in saved successfully!');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Failed to save check-in: ${e.toString()}');
      }
    }
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_symptoms.contains(symptom)) {
        _symptoms.remove(symptom);
      } else {
        _symptoms.add(symptom);
      }
      _symptomsController.text = _symptoms.join(', ');
    });
  }

  void _addCustomSymptom() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Custom Symptom'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter symptom...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _symptoms.add(controller.text);
                    _symptomsController.text = _symptoms.join(', ');
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-in'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CheckInHistoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.insights),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InsightsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
      floatingActionButton: _todaysCheckIn != null && !_isEditing
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonalizedQuestionsScreen(),
                  ),
                );
              },
              child: const Icon(Icons.quiz),
            )
          : null,
    );
  }

  Widget _buildContent() {
    if (_todaysCheckIn != null && !_isEditing) {
      return _buildCompletedCheckIn();
    }

    return _buildCheckInForm();
  }

  Widget _buildCompletedCheckIn() {
    final checkIn = _todaysCheckIn!;
    final healthScore = _service.calculateHealthScore(checkIn);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today\'s Check-in Complete',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Health Score: ${healthScore.toStringAsFixed(1)}/10',
                    style: TextStyle(
                      fontSize: 16,
                      color: _getHealthScoreColor(healthScore),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Metrics Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Metrics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMetricSummary('Mood', checkIn.moodScore),
                  _buildMetricSummary('Energy', checkIn.energyLevel),
                  _buildMetricSummary('Sleep Quality', checkIn.sleepQuality),
                  _buildMetricSummary('Pain Level', checkIn.painLevel),
                  _buildMetricSummary('Stress Level', checkIn.stressLevel),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Symptoms
          if (checkIn.symptoms.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Symptoms',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: checkIn.symptoms.map((symptom) {
                        return Chip(
                          label: Text(symptom),
                          backgroundColor: Colors.orange[100],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Notes
          if (checkIn.notes != null && checkIn.notes!.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(checkIn.notes!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // AI Insights
          if (checkIn.aiInsights != null && checkIn.aiInsights!.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Insights',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(checkIn.aiInsights!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What\'s Next?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.quiz),
                    title: const Text('Answer Personalized Questions'),
                    subtitle:
                        const Text('Get deeper insights about your health'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PersonalizedQuestionsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.insights),
                    title: const Text('View Insights'),
                    subtitle: const Text('See trends and recommendations'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InsightsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricSummary(String label, int? value) {
    if (value == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '$value/10',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Color _getHealthScoreColor(double score) {
    if (score >= 7) return Colors.green;
    if (score >= 5) return Colors.orange;
    return Colors.red;
  }

  Widget _buildCheckInForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEditing
                          ? 'Edit Today\'s Check-in'
                          : 'How are you feeling today?',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Take a moment to check in with yourself. Your responses help us understand your health better.',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Mood Score
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mood',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How would you rate your overall mood today? (${_moodScore.round()}/10)',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Slider(
                      value: _moodScore,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: _moodScore.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _moodScore = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Very Low',
                            style: TextStyle(color: Colors.grey[600])),
                        Text('Excellent',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Energy Level
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Energy Level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How energetic do you feel today? (${_energyLevel.round()}/10)',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Slider(
                      value: _energyLevel,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: _energyLevel.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _energyLevel = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Exhausted',
                            style: TextStyle(color: Colors.grey[600])),
                        Text('Very Energetic',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Sleep Quality
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sleep Quality',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How well did you sleep last night? (${_sleepQuality.round()}/10)',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Slider(
                      value: _sleepQuality,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: _sleepQuality.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _sleepQuality = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Very Poor',
                            style: TextStyle(color: Colors.grey[600])),
                        Text('Excellent',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Pain Level
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pain Level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How much pain are you experiencing today? (${_painLevel.round()}/10)',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Slider(
                      value: _painLevel,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: _painLevel.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _painLevel = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('No Pain',
                            style: TextStyle(color: Colors.grey[600])),
                        Text('Severe Pain',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Stress Level
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stress Level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How stressed do you feel today? (${_stressLevel.round()}/10)',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Slider(
                      value: _stressLevel,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: _stressLevel.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _stressLevel = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Very Relaxed',
                            style: TextStyle(color: Colors.grey[600])),
                        Text('Very Stressed',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Symptoms
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Symptoms',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: _addCustomSymptom,
                          child: const Text('Add Custom'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select any symptoms you\'re experiencing today:',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _commonSymptoms.map((symptom) {
                        final isSelected = _symptoms.contains(symptom);
                        return FilterChip(
                          label: Text(symptom),
                          selected: isSelected,
                          onSelected: (selected) {
                            _toggleSymptom(symptom);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Notes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Additional Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Any additional thoughts or observations about your health today?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your notes here...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        setState(() {
                          _notes = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveCheckIn,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _isEditing ? 'Update Check-in' : 'Complete Check-in',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Cancel Button (only show when editing)
            if (_isEditing)
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                      if (_todaysCheckIn != null) {
                        _populateFormFromCheckIn(_todaysCheckIn!);
                      }
                    });
                  },
                  child: const Text('Cancel'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
