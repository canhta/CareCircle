import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_models.freezed.dart';
part 'conversation_models.g.dart';

enum ConversationStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('ARCHIVED')
  archived,
  @JsonValue('DELETED')
  deleted,
}

enum MessageRole {
  @JsonValue('USER')
  user,
  @JsonValue('ASSISTANT')
  assistant,
  @JsonValue('SYSTEM')
  system,
}

@freezed
abstract class ConversationMetadata with _$ConversationMetadata {
  const factory ConversationMetadata({
    @Default(false) bool healthContextIncluded,
    @Default(false) bool medicationContextIncluded,
    @Default(UserPreferences()) UserPreferences userPreferences,
    @Default('gpt-4') String aiModelUsed,
    @Default(0) int tokensUsed,
  }) = _ConversationMetadata;

  factory ConversationMetadata.fromJson(Map<String, dynamic> json) =>
      _$ConversationMetadataFromJson(json);
}

@freezed
abstract class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default('en') String language,
    @Default('detailed') String responseLength, // 'concise' | 'detailed'
    @Default('simple')
    String technicalLevel, // 'simple' | 'moderate' | 'technical'
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}

@freezed
abstract class MessageMetadata with _$MessageMetadata {
  const factory MessageMetadata({
    @Default(0) int processingTime,
    @Default(1.0) double confidence,
    @Default(0) int tokensUsed,
    @Default('gpt-4') String modelVersion,
    @Default(false) bool flagged,
    String? flagReason,
  }) = _MessageMetadata;

  factory MessageMetadata.fromJson(Map<String, dynamic> json) =>
      _$MessageMetadataFromJson(json);
}

@freezed
abstract class Reference with _$Reference {
  const factory Reference({
    required String
    type, // 'medical_literature' | 'user_data' | 'health_guideline'
    required String title,
    required String description,
    String? url,
    @Default(1.0) double confidence,
  }) = _Reference;

  factory Reference.fromJson(Map<String, dynamic> json) =>
      _$ReferenceFromJson(json);
}

@freezed
abstract class Attachment with _$Attachment {
  const factory Attachment({
    required String type, // 'image' | 'document' | 'audio' | 'chart'
    required String url,
    required String contentType,
    required int size,
    @Default({}) Map<String, dynamic> metadata,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);
}

@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required String userId,
    required String title,
    @Default(ConversationStatus.active) ConversationStatus status,
    @Default(ConversationMetadata()) ConversationMetadata metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int messageCount,
    @Default(0) int totalTokensUsed,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}

@freezed
abstract class Message with _$Message {
  const factory Message({
    required String id,
    required String conversationId,
    required MessageRole role,
    required String content,
    required DateTime timestamp,
    @Default(MessageMetadata()) MessageMetadata metadata,
    @Default([]) List<Reference> references,
    @Default([]) List<Attachment> attachments,
    @Default(false) bool isHidden,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

@freezed
abstract class SendMessageRequest with _$SendMessageRequest {
  const factory SendMessageRequest({
    required String content,
    @Default([]) List<Attachment> attachments,
  }) = _SendMessageRequest;

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestFromJson(json);
}

@freezed
abstract class SendMessageResponse with _$SendMessageResponse {
  const factory SendMessageResponse({
    required Message userMessage,
    required Message assistantMessage,
    required Conversation conversation,
  }) = _SendMessageResponse;

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);
}

@freezed
abstract class CreateConversationRequest with _$CreateConversationRequest {
  const factory CreateConversationRequest({
    String? title,
    String? initialMessage,
    ConversationMetadata? metadata,
  }) = _CreateConversationRequest;

  factory CreateConversationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationRequestFromJson(json);
}
