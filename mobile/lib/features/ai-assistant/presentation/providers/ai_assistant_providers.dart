import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/app_config.dart';

import '../../auth/infrastructure/services/firebase_auth_service.dart';
import '../models/conversation_models.dart';
import '../services/ai_assistant_service.dart';

// Repository provider
final aiAssistantRepositoryProvider = Provider<AiAssistantRepository>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Add auth interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final firebaseAuthService = FirebaseAuthService();
        final idToken = await firebaseAuthService.getIdToken();
        if (idToken != null) {
          options.headers['Authorization'] = 'Bearer $idToken';
        }
        handler.next(options);
      },
    ),
  );

  return AiAssistantRepository(dio);
});

// Conversations list provider
final conversationsProvider = FutureProvider<List<Conversation>>((ref) async {
  final repository = ref.read(aiAssistantRepositoryProvider);
  return repository.getUserConversations();
});

// Active conversations provider
final activeConversationsProvider = FutureProvider<List<Conversation>>((ref) async {
  final repository = ref.read(aiAssistantRepositoryProvider);
  return repository.getUserConversations(status: 'ACTIVE');
});

// Single conversation provider
final conversationProvider = FutureProvider.family<Conversation, String>((ref, id) async {
  final repository = ref.read(aiAssistantRepositoryProvider);
  return repository.getConversation(id);
});

// Messages provider for a conversation
final messagesProvider = FutureProvider.family<List<Message>, String>((ref, conversationId) async {
  final repository = ref.read(aiAssistantRepositoryProvider);
  return repository.getMessages(conversationId);
});

// Current conversation state provider
final currentConversationProvider = StateProvider<Conversation?>((ref) => null);

// Chat input state provider
final chatInputProvider = StateProvider<String>((ref) => '');

// Typing indicator provider
final typingIndicatorProvider = StateProvider<bool>((ref) => false);

// Voice recording state provider
final voiceRecordingProvider = StateProvider<bool>((ref) => false);

// AI Assistant notifier for managing conversations
class AiAssistantNotifier extends StateNotifier<AsyncValue<List<Conversation>>> {
  final AiAssistantRepository _repository;
  final Ref _ref;

  AiAssistantNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    loadConversations();
  }

  Future<void> loadConversations() async {
    state = const AsyncValue.loading();
    try {
      final conversations = await _repository.getUserConversations();
      state = AsyncValue.data(conversations);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<Conversation> createConversation({String? title, String? initialMessage}) async {
    try {
      final request = CreateConversationRequest(title: title, initialMessage: initialMessage);

      final conversation = await _repository.createConversation(request);

      // Update the conversations list
      await loadConversations();

      // Set as current conversation
      _ref.read(currentConversationProvider.notifier).state = conversation;

      return conversation;
    } catch (error) {
      rethrow;
    }
  }

  Future<SendMessageResponse> sendMessage(String conversationId, String content) async {
    try {
      // Show typing indicator
      _ref.read(typingIndicatorProvider.notifier).state = true;

      final response = await _repository.sendMessage(conversationId, content);

      // Update current conversation if it matches
      final currentConv = _ref.read(currentConversationProvider);
      if (currentConv?.id == conversationId) {
        _ref.read(currentConversationProvider.notifier).state = response.conversation;
      }

      // Refresh messages for this conversation
      _ref.invalidate(messagesProvider(conversationId));

      return response;
    } finally {
      // Hide typing indicator
      _ref.read(typingIndicatorProvider.notifier).state = false;
    }
  }

  Future<void> updateConversationTitle(String id, String title) async {
    try {
      await _repository.updateConversationTitle(id, title);
      await loadConversations();

      // Update current conversation if it matches
      final currentConv = _ref.read(currentConversationProvider);
      if (currentConv?.id == id) {
        _ref.read(currentConversationProvider.notifier).state = currentConv?.copyWith(title: title);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Conversation>> getUserConversations() async {
    try {
      return await _repository.getUserConversations();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Message>> getMessages(String conversationId) async {
    try {
      return await _repository.getMessages(conversationId);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteConversation(String id) async {
    try {
      await _repository.deleteConversation(id);
      await loadConversations();

      // Clear current conversation if it matches
      final currentConv = _ref.read(currentConversationProvider);
      if (currentConv?.id == id) {
        _ref.read(currentConversationProvider.notifier).state = null;
      }
    } catch (error) {
      rethrow;
    }
  }

  void setCurrentConversation(Conversation? conversation) {
    _ref.read(currentConversationProvider.notifier).state = conversation;
  }
}

// AI Assistant notifier provider
final aiAssistantNotifierProvider = StateNotifierProvider<AiAssistantNotifier, AsyncValue<List<Conversation>>>((ref) {
  final repository = ref.read(aiAssistantRepositoryProvider);
  return AiAssistantNotifier(repository, ref);
});
