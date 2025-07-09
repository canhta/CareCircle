import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../core/config/app_config.dart';
import '../models/conversation_models.dart';

part 'ai_assistant_service.g.dart';

@RestApi(baseUrl: AppConfig.apiBaseUrl)
abstract class AiAssistantService {
  factory AiAssistantService(Dio dio, {String baseUrl}) = _AiAssistantService;

  @GET('/ai-assistant/conversations')
  Future<List<Conversation>> getUserConversations(
    @Query('status') String? status,
  );

  @POST('/ai-assistant/conversations')
  Future<Conversation> createConversation(
    @Body() CreateConversationRequest request,
  );

  @GET('/ai-assistant/conversations/{id}')
  Future<Conversation> getConversation(@Path('id') String id);

  @PUT('/ai-assistant/conversations/{id}')
  Future<Conversation> updateConversation(
    @Path('id') String id,
    @Body() Map<String, dynamic> updates,
  );

  @DELETE('/ai-assistant/conversations/{id}')
  Future<void> deleteConversation(@Path('id') String id);

  @POST('/ai-assistant/conversations/{id}/messages')
  Future<SendMessageResponse> sendMessage(
    @Path('id') String conversationId,
    @Body() SendMessageRequest request,
  );

  @GET('/ai-assistant/conversations/{id}/messages')
  Future<List<Message>> getMessages(
    @Path('id') String conversationId,
    @Query('limit') int? limit,
    @Query('beforeId') String? beforeId,
  );
}

class AiAssistantRepository {
  final AiAssistantService _service;

  AiAssistantRepository(Dio dio) : _service = AiAssistantService(dio);

  Future<List<Conversation>> getUserConversations({String? status}) async {
    try {
      return await _service.getUserConversations(status);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Conversation> createConversation(
    CreateConversationRequest request,
  ) async {
    try {
      return await _service.createConversation(request);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Conversation> getConversation(String id) async {
    try {
      return await _service.getConversation(id);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Conversation> updateConversationTitle(String id, String title) async {
    try {
      return await _service.updateConversation(id, {'title': title});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Conversation> updateConversationStatus(
    String id,
    ConversationStatus status,
  ) async {
    try {
      return await _service.updateConversation(id, {
        'status': status.name.toUpperCase(),
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteConversation(String id) async {
    try {
      await _service.deleteConversation(id);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<SendMessageResponse> sendMessage(
    String conversationId,
    String content,
  ) async {
    try {
      final request = SendMessageRequest(content: content);
      return await _service.sendMessage(conversationId, request);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Message>> getMessages(
    String conversationId, {
    int? limit,
    String? beforeId,
  }) async {
    try {
      return await _service.getMessages(conversationId, limit, beforeId);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message =
            e.response?.data?['message'] ?? 'Unknown error occurred';
        switch (statusCode) {
          case 400:
            return Exception('Bad request: $message');
          case 401:
            return Exception('Unauthorized. Please log in again.');
          case 403:
            return Exception('Access forbidden: $message');
          case 404:
            return Exception('Resource not found: $message');
          case 500:
            return Exception('Server error. Please try again later.');
          default:
            return Exception('Error $statusCode: $message');
        }
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      case DioExceptionType.unknown:
        return Exception('Network error. Please check your connection.');
      default:
        return Exception('An unexpected error occurred');
    }
  }
}
