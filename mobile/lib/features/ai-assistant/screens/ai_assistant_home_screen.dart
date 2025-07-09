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
import '../../auth/providers/auth_provider.dart';

class AIAssistantHomeScreen extends ConsumerStatefulWidget {
  const AIAssistantHomeScreen({super.key});

  @override
  ConsumerState<AIAssistantHomeScreen> createState() => _AIAssistantHomeScreenState();
}

class _AIAssistantHomeScreenState extends ConsumerState<AIAssistantHomeScreen> {
  final List<types.Message> _messages = [];
  late types.User _user;
  late types.User _assistant;
  String? _currentConversationId;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeUsers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeConversation();
    });
  }

  void _initializeUsers() {
    _user = const types.User(id: 'user', firstName: 'You');
    _assistant = const types.User(
      id: 'assistant',
      firstName: 'CareCircle AI',
      imageUrl: 'https://via.placeholder.com/40x40/4285F4/FFFFFF?text=AI',
    );
  }

  Future<void> _initializeConversation() async {
    if (_isInitialized) return;
    
    try {
      // Get or create a default conversation
      final conversations = await ref.read(aiAssistantNotifierProvider.notifier)
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
      final conversation = await ref.read(aiAssistantNotifierProvider.notifier)
          .createConversation(
            models.CreateConversationRequest(
              title: 'Health Assistant Chat',
              initialMessage: 'Hello! I\'m your AI health assistant. How can I help you today?',
            ),
          );
      
      _currentConversationId = conversation.id;
      await _loadMessages();
    } catch (e) {
      debugPrint('Failed to create conversation: $e');
      _addWelcomeMessage();
    }
  }

  void _addWelcomeMessage() {
    final welcomeMessage = types.TextMessage(
      author: _assistant,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
      text: 'Hello! I\'m your AI health assistant. I can help you with health questions, medication reminders, and wellness guidance. How can I assist you today?',
    );
    
    setState(() {
      _messages.insert(0, welcomeMessage);
    });
  }

  Future<void> _loadMessages() async {
    if (_currentConversationId == null) return;
    
    try {
      final messages = await ref.read(aiAssistantNotifierProvider.notifier)
          .getMessages(_currentConversationId!);
      
      final chatMessages = messages.map((msg) => _convertToChatMessage(msg)).toList();
      
      setState(() {
        _messages.clear();
        _messages.addAll(chatMessages.reversed);
      });
    } catch (e) {
      debugPrint('Failed to load messages: $e');
    }
  }

  types.Message _convertToChatMessage(models.Message message) {
    final author = message.role == 'USER' ? _user : _assistant;
    
    return types.TextMessage(
      author: author,
      createdAt: message.timestamp.millisecondsSinceEpoch,
      id: message.id,
      text: message.content,
    );
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    if (_currentConversationId == null) {
      await _createNewConversation();
    }
    
    if (_currentConversationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to send message. Please try again.')),
      );
      return;
    }

    // Add user message to UI immediately
    final userMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: message.text,
    );

    setState(() {
      _messages.insert(0, userMessage);
    });

    try {
      // Send message to backend
      final response = await ref.read(aiAssistantNotifierProvider.notifier)
          .sendMessage(_currentConversationId!, message.text);

      // Replace temporary message with actual response
      final actualUserMessage = _convertToChatMessage(response.userMessage);
      final assistantMessage = _convertToChatMessage(response.assistantMessage);

      setState(() {
        // Remove temporary message and add actual messages
        _messages.removeAt(0);
        _messages.insert(0, assistantMessage);
        _messages.insert(0, actualUserMessage);
      });
    } catch (e) {
      debugPrint('Failed to send message: $e');
      
      // Remove temporary message and show error
      setState(() {
        _messages.removeAt(0);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isTyping = ref.watch(typingIndicatorProvider);

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
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 20,
              ),
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
                _messages.clear();
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
            color: CareCircleDesignTokens.primaryMedicalBlue.withOpacity(0.1),
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
          
          // Emergency detection widget
          const EmergencyDetectionWidget(),
          
          // Chat interface
          Expanded(
            child: Chat(
              messages: _messages,
              onSendPressed: _handleSendPressed,
              user: _user,
              theme: HealthcareChatTheme.theme,
              showUserAvatars: false,
              showUserNames: false,
              customBottomWidget: isTyping ? const TypingIndicator() : null,
            ),
          ),
          
          // Voice input button
          if (AIAssistantConfig.enableVoiceInput)
            Container(
              padding: const EdgeInsets.all(16),
              child: const VoiceInputButton(),
            ),
        ],
      ),
    );
  }
}
