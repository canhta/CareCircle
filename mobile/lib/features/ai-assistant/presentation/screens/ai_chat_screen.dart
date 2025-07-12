import 'dart:async';
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

import '../widgets/healthcare_chat_theme.dart';
import '../widgets/emergency_detection_widget.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/healthcare_ux_patterns.dart';

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
  StreamingSession? _currentSession;

  @override
  void initState() {
    super.initState();
    _currentConversationId = widget.conversationId;

    if (_currentConversationId != null) {
      _loadMessages();
      _restoreSession();
    }
  }

  @override
  void dispose() {
    _saveCurrentSession();
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
    if (_currentConversationId == null || !mounted) return;

    try {
      final messages = await ref.read(
        messagesProvider(_currentConversationId!).future,
      );

      if (!mounted) return;

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
      // Create conversation if needed
      if (_currentConversationId == null) {
        final conversation = await ref
            .read(aiAssistantNotifierProvider.notifier)
            .createConversation(title: 'AI Chat', initialMessage: text);
        _currentConversationId = conversation.id;
        return; // The initial message is handled by createConversation
      }

      // Use streaming for better user experience
      await _handleStreamingResponse(text);
    } catch (e) {
      _showError('Failed to send message: ${e.toString()}');

      if (mounted) {
        // Remove the user message on error
        _chatController.removeMessage(userMessage);
      }
    }
  }

  Future<void> _restoreSession() async {
    if (_currentConversationId == null) return;

    try {
      final sessionService = ref.read(sessionPersistenceProvider);

      // Restore active session
      final activeSession = await sessionService.restoreActiveSession();
      if (activeSession?.conversationId == _currentConversationId) {
        setState(() {
          _currentSession = activeSession;
        });

        // Restore conversation state
        final conversationState = await sessionService.restoreConversationState(
          _currentConversationId!,
        );
        if (conversationState != null) {
          // Apply restored state if needed
          _applyRestoredState(conversationState);
        }
      }
    } catch (e) {
      // Log error but don't block the UI
      BoundedContextLoggers.aiAssistant.error('Failed to restore session', {
        'conversationId': _currentConversationId,
        'error': e.toString(),
      });
    }
  }

  void _applyRestoredState(Map<String, dynamic> state) {
    // Apply any restored conversation state
    // This could include scroll position, draft messages, etc.
    BoundedContextLoggers.aiAssistant.logAiInteraction(
      'Conversation state restored',
      {'stateKeys': state.keys.toList()},
    );
  }

  Future<void> _saveCurrentSession() async {
    if (_currentSession == null) return;

    try {
      final sessionService = ref.read(sessionPersistenceProvider);
      await sessionService.saveActiveSession(_currentSession!);

      // Save current conversation state
      if (_currentConversationId != null) {
        final conversationState = {
          'lastActivity': DateTime.now().toIso8601String(),
          'messageCount': _chatController.messages.length,
          // Add other state as needed
        };
        await sessionService.saveConversationState(
          _currentConversationId!,
          conversationState,
        );
      }
    } catch (e) {
      // Log error but don't block disposal
      BoundedContextLoggers.aiAssistant.error('Failed to save session', {
        'conversationId': _currentConversationId,
        'error': e.toString(),
      });
    }
  }

  Future<void> _handleStreamingResponse(String text) async {
    if (_currentConversationId == null) return;

    // Create streaming infrastructure for future TextStreamMessage integration
    final streamController = StreamController<String>();

    // TODO: Add streaming message to chat UI when TextStreamMessage is properly integrated
    // For now, we'll collect the streaming response and display it as a complete message
    // This provides the foundation for progressive text display in future iterations

    try {
      // Send message to existing conversation using streaming
      final streamResponse = ref
          .read(aiAssistantNotifierProvider.notifier)
          .sendMessageStream(_currentConversationId!, text);

      String accumulatedText = '';

      // Stream chunks to the widget
      await for (final chunk in streamResponse) {
        if (mounted && chunk.isNotEmpty) {
          accumulatedText += chunk;
          streamController.add(chunk);
        }
      }

      // Close the stream
      streamController.close();

      if (mounted && accumulatedText.isNotEmpty) {
        // Add the complete assistant response
        final assistantMessage = TextMessage(
          id: 'assistant_${DateTime.now().millisecondsSinceEpoch}',
          authorId: _assistantId,
          createdAt: DateTime.now().toUtc(),
          text: accumulatedText,
        );

        _chatController.insertMessage(assistantMessage);
      }
    } catch (e) {
      streamController.addError(e);
      streamController.close();

      if (mounted) {
        // Add error message
        final errorMessage = TextMessage(
          id: 'error_${DateTime.now().millisecondsSinceEpoch}',
          authorId: _assistantId,
          createdAt: DateTime.now().toUtc(),
          text:
              "I apologize, but I'm experiencing technical difficulties. Please try again.",
        );

        _chatController.insertMessage(errorMessage);
      }
      rethrow;
    }
  }

  // Note: _onStreamingComplete method removed as it's not currently used
  // Will be re-added when TextStreamMessage integration is implemented

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
          // Medical disclaimer banner
          HealthcareUXPatterns.medicalDisclaimer(),

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
              child: Column(
                children: [
                  // Enhanced chat with streaming support
                  Expanded(
                    child: Chat(
                      chatController: _chatController,
                      currentUserId: _currentUserId,
                      onMessageSend: _handleMessageSend,
                      resolveUser: _resolveUser,
                    ),
                  ),

                  // Enhanced typing indicator
                  Consumer(
                    builder: (context, ref, child) {
                      final isTyping = ref.watch(typingIndicatorProvider);
                      final streamingState = ref.watch(streamingStateProvider);

                      if (isTyping || streamingState.isStreaming) {
                        return TypingIndicatorWidget(
                          isStreaming: streamingState.isStreaming,
                          customMessage: streamingState.isStreaming
                              ? 'AI is responding...'
                              : null,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),

          // Emergency escalation button
          HealthcareUXPatterns.emergencyEscalation(
            onPressed: () => _showEmergencyServicesDialog(),
          ),

          // Privacy notice
          HealthcareUXPatterns.privacyNotice(
            onLearnMore: () => _showPrivacyInfo(),
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

  void _showPrivacyInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy & Data Protection'),
        content: const Text(
          'Your health conversations are protected by:\n\n'
          '• End-to-end encryption\n'
          '• HIPAA compliance standards\n'
          '• Secure data processing\n'
          '• No data sharing with third parties\n\n'
          'Your medical information remains private and secure.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }

  Future<void> _makeEmergencyCall() async {
    try {
      // Log emergency call attempt for healthcare compliance
      AppLogger.info('Emergency call initiated from AI Assistant', {
        'timestamp': DateTime.now().toIso8601String(),
        'conversationId': widget.conversationId,
        'source': 'ai_chat_screen',
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
