import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/ai/ai_assistant_config.dart';
import '../providers/ai_assistant_providers.dart';
import '../models/conversation_models.dart' as models;

import '../widgets/healthcare_chat_theme.dart';
import '../widgets/emergency_detection_widget.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  final String? conversationId;

  const AiChatScreen({super.key, this.conversationId});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _chatController = InMemoryChatController();
  String? _currentConversationId;
  final String _currentUserId = 'user';
  final String _assistantId = 'assistant';

  @override
  void initState() {
    super.initState();
    _currentConversationId = widget.conversationId;

    if (_currentConversationId != null) {
      _loadMessages();
    }
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
      return const User(id: 'assistant', name: 'AI Assistant');
    }
  }

  Future<void> _loadMessages() async {
    if (_currentConversationId == null) return;

    try {
      final messages = await ref.read(
        messagesProvider(_currentConversationId!).future,
      );

      final chatMessages = messages
          .map((msg) => _convertToChatMessage(msg))
          .toList();
      _chatController.setMessages(chatMessages.reversed.toList());
    } catch (e) {
      _showError('Failed to load messages: ${e.toString()}');
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

    // Add user message to chat controller
    final userMessage = TextMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      authorId: _currentUserId,
      createdAt: DateTime.now().toUtc(),
      text: text,
    );

    _chatController.insertMessage(userMessage);

    try {
      // Create conversation if needed
      if (_currentConversationId == null) {
        final conversation = await ref
            .read(aiAssistantNotifierProvider.notifier)
            .createConversation(title: 'AI Chat', initialMessage: text);
        _currentConversationId = conversation.id;
        return; // The initial message is handled by createConversation
      }

      // Send message to existing conversation
      final response = await ref
          .read(aiAssistantNotifierProvider.notifier)
          .sendMessage(_currentConversationId!, text);

      // Add assistant response
      final assistantMessage = _convertToChatMessage(response.assistantMessage);
      _chatController.insertMessage(assistantMessage);
    } catch (e) {
      _showError('Failed to send message: ${e.toString()}');

      // Remove the user message on error
      _chatController.removeMessage(userMessage);
    }
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
