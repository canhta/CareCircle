import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_config.dart';

import '../../../auth/infrastructure/services/firebase_auth_service.dart';
import '../../domain/models/conversation_models.dart';
import '../../infrastructure/services/ai_assistant_service.dart';
import '../../infrastructure/services/session_persistence_service.dart';

// Enhanced streaming state models for progressive text display
class StreamingState {
  final bool isStreaming;
  final String currentContent;
  final bool isComplete;
  final String? messageId;
  final DateTime? startTime;
  final DateTime? endTime;
  final int charactersStreamed;
  final double? streamingSpeed; // characters per second
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  const StreamingState({
    this.isStreaming = false,
    this.currentContent = '',
    this.isComplete = false,
    this.messageId,
    this.startTime,
    this.endTime,
    this.charactersStreamed = 0,
    this.streamingSpeed,
    this.errorMessage,
    this.metadata,
  });

  StreamingState copyWith({
    bool? isStreaming,
    String? currentContent,
    bool? isComplete,
    String? messageId,
    DateTime? startTime,
    DateTime? endTime,
    int? charactersStreamed,
    double? streamingSpeed,
    String? errorMessage,
    Map<String, dynamic>? metadata,
  }) {
    return StreamingState(
      isStreaming: isStreaming ?? this.isStreaming,
      currentContent: currentContent ?? this.currentContent,
      isComplete: isComplete ?? this.isComplete,
      messageId: messageId ?? this.messageId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      charactersStreamed: charactersStreamed ?? this.charactersStreamed,
      streamingSpeed: streamingSpeed ?? this.streamingSpeed,
      errorMessage: errorMessage ?? this.errorMessage,
      metadata: metadata ?? this.metadata,
    );
  }

  // Calculate streaming performance metrics
  Duration? get streamingDuration {
    if (startTime == null) return null;
    final end = endTime ?? DateTime.now();
    return end.difference(startTime!);
  }

  double get averageStreamingSpeed {
    final duration = streamingDuration;
    if (duration == null || duration.inMilliseconds == 0) return 0.0;
    return charactersStreamed / (duration.inMilliseconds / 1000.0);
  }

  bool get hasError => errorMessage != null;
}

// Session management models
class StreamingSession {
  final String sessionId;
  final String conversationId;
  final DateTime createdAt;
  final DateTime? lastActivity;
  final List<String> messageIds;
  final bool isActive;
  final Map<String, dynamic>? sessionData;

  const StreamingSession({
    required this.sessionId,
    required this.conversationId,
    required this.createdAt,
    this.lastActivity,
    this.messageIds = const [],
    this.isActive = true,
    this.sessionData,
  });

  StreamingSession copyWith({
    String? sessionId,
    String? conversationId,
    DateTime? createdAt,
    DateTime? lastActivity,
    List<String>? messageIds,
    bool? isActive,
    Map<String, dynamic>? sessionData,
  }) {
    return StreamingSession(
      sessionId: sessionId ?? this.sessionId,
      conversationId: conversationId ?? this.conversationId,
      createdAt: createdAt ?? this.createdAt,
      lastActivity: lastActivity ?? this.lastActivity,
      messageIds: messageIds ?? this.messageIds,
      isActive: isActive ?? this.isActive,
      sessionData: sessionData ?? this.sessionData,
    );
  }

  // Check if session is inactive (no activity for >30 minutes)
  bool get isInactive {
    if (lastActivity == null) return false;
    final now = DateTime.now();
    return now.difference(lastActivity!).inMinutes > 30;
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'conversationId': conversationId,
      'createdAt': createdAt.toIso8601String(),
      'lastActivity': lastActivity?.toIso8601String(),
      'messageIds': messageIds,
      'isActive': isActive,
      'sessionData': sessionData,
    };
  }

  factory StreamingSession.fromJson(Map<String, dynamic> json) {
    return StreamingSession(
      sessionId: json['sessionId'] as String,
      conversationId: json['conversationId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActivity: json['lastActivity'] != null
          ? DateTime.parse(json['lastActivity'] as String)
          : null,
      messageIds: List<String>.from(json['messageIds'] as List? ?? []),
      isActive: json['isActive'] as bool? ?? true,
      sessionData: json['sessionData'] as Map<String, dynamic>?,
    );
  }
}

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
final activeConversationsProvider = FutureProvider<List<Conversation>>((
  ref,
) async {
  final repository = ref.read(aiAssistantRepositoryProvider);
  return repository.getUserConversations(status: 'ACTIVE');
});

// Single conversation provider
final conversationProvider = FutureProvider.family<Conversation, String>((
  ref,
  id,
) async {
  final repository = ref.read(aiAssistantRepositoryProvider);
  return repository.getConversation(id);
});

// Messages provider for a conversation
final messagesProvider = FutureProvider.family<List<Message>, String>((
  ref,
  conversationId,
) async {
  final repository = ref.read(aiAssistantRepositoryProvider);
  return repository.getMessages(conversationId);
});

// Current conversation state provider
final currentConversationProvider = StateProvider<Conversation?>((ref) => null);

// Chat input state provider
final chatInputProvider = StateProvider<String>((ref) => '');

// Typing indicator provider
final typingIndicatorProvider = StateProvider<bool>((ref) => false);

// Streaming state provider
final streamingStateProvider = StateProvider<StreamingState>(
  (ref) => const StreamingState(),
);

// Session management providers
final streamingSessionProvider = StateProvider<StreamingSession?>(
  (ref) => null,
);

// Active streaming sessions provider
final activeStreamingSessionsProvider =
    StateProvider<Map<String, StreamingSession>>((ref) => {});

// Session persistence provider
final sessionPersistenceProvider = Provider<SessionPersistenceService>((ref) {
  return SessionPersistenceService();
});

// Voice recording state provider
final voiceRecordingProvider = StateProvider<bool>((ref) => false);

// AI Assistant notifier for managing conversations
class AiAssistantNotifier
    extends StateNotifier<AsyncValue<List<Conversation>>> {
  final AiAssistantRepository _repository;
  final Ref _ref;

  AiAssistantNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
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

  Future<Conversation> createConversation({
    String? title,
    String? initialMessage,
  }) async {
    try {
      final request = CreateConversationRequest(
        title: title,
        initialMessage: initialMessage,
      );

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

  Future<SendMessageResponse> sendMessage(
    String conversationId,
    String content,
  ) async {
    try {
      // Show typing indicator
      _ref.read(typingIndicatorProvider.notifier).state = true;

      final response = await _repository.sendMessage(conversationId, content);

      // Update current conversation if it matches
      final currentConv = _ref.read(currentConversationProvider);
      if (currentConv?.id == conversationId) {
        _ref.read(currentConversationProvider.notifier).state =
            response.conversation;
      }

      // Refresh messages for this conversation
      _ref.invalidate(messagesProvider(conversationId));

      return response;
    } finally {
      // Hide typing indicator
      _ref.read(typingIndicatorProvider.notifier).state = false;
    }
  }

  Stream<String> sendMessageStream(
    String conversationId,
    String content,
  ) async* {
    final messageId = 'stream_${DateTime.now().millisecondsSinceEpoch}';
    final startTime = DateTime.now();

    try {
      // Create or update streaming session
      final sessionId =
          'session_${conversationId}_${DateTime.now().millisecondsSinceEpoch}';
      final session = StreamingSession(
        sessionId: sessionId,
        conversationId: conversationId,
        createdAt: startTime,
        lastActivity: startTime,
        messageIds: [messageId],
        isActive: true,
      );

      _ref.read(streamingSessionProvider.notifier).state = session;

      // Initialize streaming state with session info
      _ref.read(streamingStateProvider.notifier).state = StreamingState(
        isStreaming: true,
        currentContent: '',
        isComplete: false,
        messageId: messageId,
        startTime: startTime,
        charactersStreamed: 0,
      );

      // Get streaming response from repository
      final streamResponse = _repository.sendMessageStream(
        conversationId,
        content,
      );

      String accumulatedContent = '';
      int charactersStreamed = 0;

      await for (final chunk in streamResponse) {
        if (chunk.isNotEmpty) {
          accumulatedContent += chunk;
          charactersStreamed += chunk.length;

          // Calculate streaming speed
          final elapsed = DateTime.now().difference(startTime);
          final speed = elapsed.inMilliseconds > 0
              ? charactersStreamed / (elapsed.inMilliseconds / 1000.0)
              : 0.0;

          // Update streaming state with progress
          _ref.read(streamingStateProvider.notifier).state = StreamingState(
            isStreaming: true,
            currentContent: accumulatedContent,
            isComplete: false,
            messageId: messageId,
            startTime: startTime,
            charactersStreamed: charactersStreamed,
            streamingSpeed: speed,
          );

          // Update session activity
          final updatedSession = session.copyWith(lastActivity: DateTime.now());
          _ref.read(streamingSessionProvider.notifier).state = updatedSession;

          yield chunk;
        }
      }

      final endTime = DateTime.now();

      // Mark streaming as complete
      _ref.read(streamingStateProvider.notifier).state = StreamingState(
        isStreaming: false,
        currentContent: accumulatedContent,
        isComplete: true,
        messageId: messageId,
        startTime: startTime,
        endTime: endTime,
        charactersStreamed: charactersStreamed,
        streamingSpeed:
            charactersStreamed /
            (endTime.difference(startTime).inMilliseconds / 1000.0),
      );

      // Mark session as complete
      final completedSession = session.copyWith(
        lastActivity: endTime,
        isActive: false,
      );
      _ref.read(streamingSessionProvider.notifier).state = completedSession;

      // Persist session for restoration
      final sessionService = _ref.read(sessionPersistenceProvider);
      await sessionService.saveSession(completedSession);

      // Refresh messages and conversation
      _ref.invalidate(messagesProvider(conversationId));
      final currentConv = _ref.read(currentConversationProvider);
      if (currentConv?.id == conversationId) {
        // Refresh current conversation
        final updatedConv = await _repository.getConversation(conversationId);
        _ref.read(currentConversationProvider.notifier).state = updatedConv;
      }
    } catch (error) {
      final endTime = DateTime.now();

      // Reset streaming state on error
      _ref.read(streamingStateProvider.notifier).state = StreamingState(
        isStreaming: false,
        isComplete: true,
        messageId: messageId,
        startTime: startTime,
        endTime: endTime,
        errorMessage: error.toString(),
      );

      // Mark session as failed
      final currentSession = _ref.read(streamingSessionProvider);
      if (currentSession != null) {
        final failedSession = currentSession.copyWith(
          lastActivity: endTime,
          isActive: false,
          sessionData: {'error': error.toString()},
        );
        _ref.read(streamingSessionProvider.notifier).state = failedSession;
      }

      rethrow;
    }
  }

  Future<void> updateConversationTitle(String id, String title) async {
    try {
      await _repository.updateConversationTitle(id, title);
      await loadConversations();

      // Update current conversation if it matches
      final currentConv = _ref.read(currentConversationProvider);
      if (currentConv?.id == id) {
        _ref.read(currentConversationProvider.notifier).state = currentConv
            ?.copyWith(title: title);
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
final aiAssistantNotifierProvider =
    StateNotifierProvider<AiAssistantNotifier, AsyncValue<List<Conversation>>>((
      ref,
    ) {
      final repository = ref.read(aiAssistantRepositoryProvider);
      return AiAssistantNotifier(repository, ref);
    });
