import 'package:flutter/material.dart';
import '../features/daily_check_in/daily_check_in.dart';
import '../common/common.dart';

class PersonalizedQuestionsScreen extends StatefulWidget {
  const PersonalizedQuestionsScreen({super.key});

  @override
  State<PersonalizedQuestionsScreen> createState() =>
      _PersonalizedQuestionsScreenState();
}

class _PersonalizedQuestionsScreenState
    extends State<PersonalizedQuestionsScreen> {
  late final DailyCheckInService _service;

  bool _isLoading = false;
  bool _isSubmitting = false;
  List<PersonalizedQuestion> _questions = [];
  final Map<String, dynamic> _answers = {};
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _service = DailyCheckInService(
      apiClient: ApiClient.instance,
      logger: AppLogger('PersonalizedQuestionsScreen'),
    );
    _loadPersonalizedQuestions();
  }

  Future<void> _loadPersonalizedQuestions() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _service.generatePersonalizedQuestions();

    result.fold(
      (questions) {
        if (mounted) {
          setState(() {
            _questions = questions;
            _isLoading = false;
          });
        }
      },
      (error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackBar('Failed to load questions: ${error.toString()}');
        }
      },
    );
  }

  Future<void> _submitAnswer(String questionId, dynamic answer) async {
    setState(() {
      _answers[questionId] = answer;
    });

    // Note: In this implementation, we'll collect answers and submit them all together
    // Individual answer submission would need a different service method
  }

  Future<void> _completeQuestionnaire() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Submit any remaining answers
      for (final question in _questions) {
        if (_answers.containsKey(question.id)) {
          await _submitAnswer(question.id, _answers[question.id]);
        }
      }

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        _showSuccessSnackBar('Questionnaire completed successfully!');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        _showErrorSnackBar('Failed to complete questionnaire: ${e.toString()}');
      }
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _completeQuestionnaire();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
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
        title: const Text('Personalized Questions'),
        actions: [
          if (_questions.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '${_currentQuestionIndex + 1}/${_questions.length}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _questions.isEmpty
              ? _buildEmptyState()
              : _buildQuestionnaire(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No personalized questions available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete your daily check-in first to get personalized questions.',
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionnaire() {
    final question = _questions[_currentQuestionIndex];

    return Column(
      children: [
        // Progress indicator
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _questions.length,
        ),

        // Question content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question category
                if (question.category != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      question.category!.toUpperCase(),
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Question text
                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                // Answer input
                _buildAnswerInput(question),
              ],
            ),
          ),
        ),

        // Navigation buttons
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous button
              _currentQuestionIndex > 0
                  ? TextButton(
                      onPressed: _previousQuestion,
                      child: const Text('Previous'),
                    )
                  : const SizedBox.shrink(),

              // Next/Complete button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _nextQuestion,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _currentQuestionIndex == _questions.length - 1
                            ? 'Complete'
                            : 'Next',
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerInput(PersonalizedQuestion question) {
    switch (question.type) {
      case 'scale':
        return _buildScaleInput(question);
      case 'multiple_choice':
        return _buildMultipleChoiceInput(question);
      case 'boolean':
        return _buildBooleanInput(question);
      case 'text':
        return _buildTextInput(question);
      default:
        return _buildTextInput(question);
    }
  }

  Widget _buildScaleInput(PersonalizedQuestion question) {
    final minValue = 1;
    final maxValue = 10;
    final currentValue = _answers[question.id] ?? minValue.toDouble();

    return Column(
      children: [
        Text(
          'Selected: ${currentValue.round()}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Slider(
          value: currentValue.toDouble(),
          min: minValue.toDouble(),
          max: maxValue.toDouble(),
          divisions: maxValue - minValue,
          label: currentValue.round().toString(),
          onChanged: (value) {
            setState(() {
              _answers[question.id] = value.round();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$minValue'),
            Text('$maxValue'),
          ],
        ),
      ],
    );
  }

  Widget _buildMultipleChoiceInput(PersonalizedQuestion question) {
    final options = question.options ?? [];
    final selectedOption = _answers[question.id] as String?;

    return Column(
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              _answers[question.id] = value;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildBooleanInput(PersonalizedQuestion question) {
    final selectedValue = _answers[question.id] as bool?;

    return Column(
      children: [
        RadioListTile<bool>(
          title: const Text('Yes'),
          value: true,
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              _answers[question.id] = value;
            });
          },
        ),
        RadioListTile<bool>(
          title: const Text('No'),
          value: false,
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              _answers[question.id] = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTextInput(PersonalizedQuestion question) {
    final controller = TextEditingController();
    controller.text = _answers[question.id] as String? ?? '';

    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Enter your answer...',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      onChanged: (value) {
        setState(() {
          _answers[question.id] = value;
        });
      },
    );
  }
}
