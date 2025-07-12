import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/design/design_tokens.dart';
import '../../../../core/ai/ai_assistant_config.dart';
import '../../../../core/logging/logging.dart';
import '../providers/ai_assistant_providers.dart';
import '../../domain/models/conversation_models.dart' as models;
import '../widgets/voice_input_button.dart';
import '../widgets/emergency_detection_widget.dart';
import '../widgets/healthcare_chat_theme.dart';

class AIAssistantHomeScreen extends ConsumerStatefulWidget {
  const AIAssistantHomeScreen({super.key});

  @override
  ConsumerState<AIAssistantHomeScreen> createState() =>
      _AIAssistantHomeScreenState();
}

class _AIAssistantHomeScreenState extends ConsumerState<AIAssistantHomeScreen> {
  final _chatController = InMemoryChatController();
  String? _currentConversationId;
  bool _isInitialized = false;
  final String _currentUserId = 'user';
  final String _assistantId = 'assistant';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeConversation();
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  Future<User> _resolveUser(String userId) async {
    if (userId == _currentUserId) {
      return const User(id: 'user', name: 'You');
    } else {
      return const User(id: 'assistant', name: 'CareCircle AI');
    }
  }

  Future<void> _initializeConversation() async {
    if (_isInitialized) return;

    try {
      // Get or create a default conversation
      final conversations = await ref
          .read(aiAssistantNotifierProvider.notifier)
          .getUserConversations();

      if (conversations.isNotEmpty) {
        // Use the most recent conversation
        _currentConversationId = conversations.first.id;
        await _loadMessages();
      } else {
        // Create a new conversation
        await _createNewConversation();
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize conversation: $e');
      // Add welcome message even if conversation creation fails
      _addWelcomeMessage();
    }
  }

  Future<void> _createNewConversation() async {
    try {
      final conversation = await ref
          .read(aiAssistantNotifierProvider.notifier)
          .createConversation(
            title: 'Health Assistant Chat',
            initialMessage:
                'Hello! I\'m your AI health assistant. How can I help you today?',
          );

      _currentConversationId = conversation.id;
      await _loadMessages();
    } catch (e) {
      debugPrint('Failed to create conversation: $e');
      _addWelcomeMessage();
    }
  }

  void _addWelcomeMessage() {
    if (!mounted) return;

    final welcomeMessage = TextMessage(
      id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
      authorId: _assistantId,
      createdAt: DateTime.now().toUtc(),
      text:
          'Hello! I\'m your AI health assistant. I can help you with health questions, medication reminders, and wellness guidance. How can I assist you today?',
    );

    _chatController.insertMessage(welcomeMessage);
  }

  Future<void> _loadMessages() async {
    if (_currentConversationId == null || !mounted) return;

    try {
      final messages = await ref
          .read(aiAssistantNotifierProvider.notifier)
          .getMessages(_currentConversationId!);

      if (!mounted) return;

      final chatMessages = messages
          .map((msg) => _convertToChatMessage(msg))
          .toList();

      // Clear existing messages and add new ones
      _chatController.setMessages(chatMessages.reversed.toList());
    } catch (e) {
      debugPrint('Failed to load messages: $e');
    }
  }

  TextMessage _convertToChatMessage(models.Message message) {
    final authorId = message.role.name == 'USER'
        ? _currentUserId
        : _assistantId;

    return TextMessage(
      id: message.id,
      authorId: authorId,
      createdAt: message.timestamp.toUtc(),
      text: message.content,
    );
  }

  Future<void> _handleMessageSend(String text) async {
    // Check for emergency keywords
    if (EmergencyDetectionService.detectEmergency(text)) {
      _showEmergencyDialog(text);
      return;
    }

    if (_currentConversationId == null) {
      await _createNewConversation();
    }

    if (_currentConversationId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to send message. Please try again.'),
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    // Add user message to chat controller
    final userMessage = TextMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      authorId: _currentUserId,
      createdAt: DateTime.now().toUtc(),
      text: text,
    );

    _chatController.insertMessage(userMessage);

    try {
      // Send message to backend
      final response = await ref
          .read(aiAssistantNotifierProvider.notifier)
          .sendMessage(_currentConversationId!, text);

      if (!mounted) return;

      // Add assistant response
      final assistantMessage = _convertToChatMessage(response.assistantMessage);
      _chatController.insertMessage(assistantMessage);
    } catch (e) {
      debugPrint('Failed to send message: $e');

      if (mounted) {
        // Remove the user message on error
        _chatController.removeMessage(userMessage);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to send message: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: CareCircleDesignTokens.primaryMedicalBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CareCircle AI',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Your Health Assistant',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _chatController.setMessages([]);
                _isInitialized = false;
              });
              _initializeConversation();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Health context indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
              alpha: 0.1,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.health_and_safety,
                  size: 16,
                  color: CareCircleDesignTokens.primaryMedicalBlue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI has access to your health profile for personalized responses',
                    style: TextStyle(
                      fontSize: 12,
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chat interface with healthcare theming
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: HealthcareChatTheme.backgroundColor,
              ),
              child: Chat(
                chatController: _chatController,
                currentUserId: _currentUserId,
                onMessageSend: _handleMessageSend,
                resolveUser: _resolveUser,
              ),
            ),
          ),

          // Voice input button
          if (AIAssistantConfig.enableVoiceInput)
            Container(
              padding: const EdgeInsets.all(16),
              child: VoiceInputButton(
                onVoiceInput: (text) {
                  if (text.isNotEmpty) {
                    _handleMessageSend(text);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showEmergencyDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EmergencyDetectionWidget(
        message: message,
        onEmergencyConfirmed: () {
          Navigator.of(context).pop();
          _handleEmergencyConfirmed(message);
        },
        onFalseAlarm: () {
          Navigator.of(context).pop();
          _handleMessageSend(message);
        },
      ),
    );
  }

  void _handleEmergencyConfirmed(String message) {
    if (!mounted) return;

    // Add emergency advice message
    final emergencyAdvice = EmergencyDetectionService.getEmergencyAdvice(
      message,
    );
    final systemMessage = TextMessage(
      id: 'emergency_${DateTime.now().millisecondsSinceEpoch}',
      authorId: 'system',
      createdAt: DateTime.now().toUtc(),
      text: emergencyAdvice,
    );

    _chatController.insertMessage(systemMessage);

    // Show emergency services dialog
    _showEmergencyServicesDialog();
  }

  void _showEmergencyServicesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Services'),
        content: const Text(
          'Would you like to call emergency services now?\n\n'
          'Emergency Numbers:\n'
          '• 911 (US Emergency)\n'
          '• 115 (Vietnam Emergency)\n'
          '• 113 (Police)',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Not now'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _makeEmergencyCall();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Call Emergency',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makeEmergencyCall() async {
    try {
      // Log emergency call attempt for healthcare compliance
      AppLogger.info('Emergency call initiated from AI Assistant Home', {
        'timestamp': DateTime.now().toIso8601String(),
        'source': 'ai_assistant_home_screen',
      });

      // Determine emergency number based on locale/region
      // Default to 911 for US, but could be enhanced with location detection
      const emergencyNumber = '911';
      final Uri phoneUri = Uri(scheme: 'tel', path: emergencyNumber);

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);

        AppLogger.info('Emergency call launched successfully', {
          'number': emergencyNumber,
          'timestamp': DateTime.now().toIso8601String(),
        });
      } else {
        throw Exception('Cannot launch phone dialer');
      }
    } catch (e) {
      AppLogger.error('Failed to initiate emergency call', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to make emergency call: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}
