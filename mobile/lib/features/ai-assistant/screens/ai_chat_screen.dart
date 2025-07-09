import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../core/design/design_tokens.dart';
import '../../../core/ai/ai_assistant_config.dart';
import '../providers/ai_assistant_providers.dart';
import '../models/conversation_models.dart' as models;
import '../widgets/voice_input_button.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/healthcare_chat_theme.dart';
import '../widgets/emergency_detection_widget.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  final String? conversationId;

  const AiChatScreen({super.key, this.conversationId});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final List<types.Message> _messages = [];
  late types.User _user;
  late types.User _assistant;
  String? _currentConversationId;

  @override
  void initState() {
    super.initState();
    _initializeUsers();
    _currentConversationId = widget.conversationId;

    if (_currentConversationId != null) {
      _loadMessages();
    }
  }

  void _initializeUsers() {
    _user = const types.User(id: 'user', firstName: 'You');

    _assistant = const types.User(
      id: 'assistant',
      firstName: 'AI Assistant',
      imageUrl: 'https://via.placeholder.com/40x40/4285F4/FFFFFF?text=AI',
    );
  }

  Future<void> _loadMessages() async {
    if (_currentConversationId == null) return;

    try {
      final messages = await ref.read(
        messagesProvider(_currentConversationId!).future,
      );

      setState(() {
        _messages.clear();
        _messages.addAll(_convertToUIMessages(messages));
      });
    } catch (e) {
      _showError('Failed to load messages: ${e.toString()}');
    }
  }

  List<types.Message> _convertToUIMessages(List<models.Message> messages) {
    return messages
        .map((msg) {
          final user = msg.role == models.MessageRole.user ? _user : _assistant;

          return types.TextMessage(
            author: user,
            createdAt: msg.timestamp.millisecondsSinceEpoch,
            id: msg.id,
            text: msg.content,
            metadata: {
              'role': msg.role.name,
              'confidence': msg.metadata.confidence,
              'tokensUsed': msg.metadata.tokensUsed,
            },
          );
        })
        .toList()
        .reversed
        .toList(); // Chat UI expects newest first
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    // Check for emergency keywords
    if (EmergencyDetectionService.detectEmergency(message.text)) {
      _showEmergencyDialog(message.text);
      return;
    }

    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message.text,
    );

    _addMessage(textMessage);

    try {
      // Create conversation if needed
      if (_currentConversationId == null) {
        final conversation = await ref
            .read(aiAssistantNotifierProvider.notifier)
            .createConversation(initialMessage: message.text);
        _currentConversationId = conversation.id;
        return; // The initial message is handled by createConversation
      }

      // Send message to existing conversation
      final response = await ref
          .read(aiAssistantNotifierProvider.notifier)
          .sendMessage(_currentConversationId!, message.text);

      // Add assistant response
      final assistantMessage = types.TextMessage(
        author: _assistant,
        createdAt: response.assistantMessage.timestamp.millisecondsSinceEpoch,
        id: response.assistantMessage.id,
        text: response.assistantMessage.content,
        metadata: {
          'role': response.assistantMessage.role.name,
          'confidence': response.assistantMessage.metadata.confidence,
          'tokensUsed': response.assistantMessage.metadata.tokensUsed,
        },
      );

      _addMessage(assistantMessage);
    } catch (e) {
      _showError('Failed to send message: ${e.toString()}');

      // Remove the user message on error
      setState(() {
        _messages.removeWhere((msg) => msg.id == textMessage.id);
      });
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTyping = ref.watch(typingIndicatorProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Health Assistant'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showAssistantInfo,
          ),
        ],
      ),
      body: Column(
        children: [
          // Health context indicator
          if (AIAssistantConfig.personality.empathetic)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
                alpha: 0.1,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.health_and_safety,
                    color: CareCircleDesignTokens.primaryMedicalBlue,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AI assistant with access to your health context',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: CareCircleDesignTokens.primaryMedicalBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Chat interface
          Expanded(
            child: Chat(
              messages: _messages,
              onSendPressed: _handleSendPressed,
              user: _user,
              theme: HealthcareChatTheme.theme,
              customBottomWidget: _buildCustomInput(),
              showUserAvatars: false,
              showUserNames: true,
            ),
          ),

          // Typing indicator
          if (isTyping) const TypingIndicatorWidget(),
        ],
      ),
    );
  }

  Widget _buildCustomInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          // Voice input button
          if (AIAssistantConfig.enableVoiceInput)
            VoiceInputButton(
              onVoiceInput: (text) {
                if (text.isNotEmpty) {
                  _handleSendPressed(types.PartialText(text: text));
                }
              },
            ),

          const SizedBox(width: 8),

          // Text input
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Ask about your health...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (text) {
                if (text.trim().isNotEmpty) {
                  _handleSendPressed(types.PartialText(text: text.trim()));
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
          _handleSendPressed(types.PartialText(text: message));
        },
      ),
    );
  }

  void _handleEmergencyConfirmed(String message) {
    // Add emergency advice message
    final emergencyAdvice = EmergencyDetectionService.getEmergencyAdvice(
      message,
    );
    final systemMessage = types.SystemMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: emergencyAdvice,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    _addMessage(systemMessage);

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
              // TODO: Implement emergency calling functionality
              _showError('Emergency calling feature will be implemented');
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

  void _showAssistantInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Health Assistant'),
        content: const Text(
          'This AI assistant can help you with health-related questions and provide personalized guidance based on your health data.\n\n'
          '⚠️ Medical Disclaimer: This advice is for informational purposes only and should not replace professional medical consultation. '
          'For urgent health concerns, please contact your healthcare provider or emergency services immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
