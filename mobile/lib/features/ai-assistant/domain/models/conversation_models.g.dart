// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationMetadata _$ConversationMetadataFromJson(
  Map<String, dynamic> json,
) => _ConversationMetadata(
  healthContextIncluded: json['healthContextIncluded'] as bool? ?? false,
  medicationContextIncluded:
      json['medicationContextIncluded'] as bool? ?? false,
  userPreferences: json['userPreferences'] == null
      ? const UserPreferences()
      : UserPreferences.fromJson(
          json['userPreferences'] as Map<String, dynamic>,
        ),
  aiModelUsed: json['aiModelUsed'] as String? ?? 'gpt-4',
  tokensUsed: (json['tokensUsed'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ConversationMetadataToJson(
  _ConversationMetadata instance,
) => <String, dynamic>{
  'healthContextIncluded': instance.healthContextIncluded,
  'medicationContextIncluded': instance.medicationContextIncluded,
  'userPreferences': instance.userPreferences,
  'aiModelUsed': instance.aiModelUsed,
  'tokensUsed': instance.tokensUsed,
};

_UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    _UserPreferences(
      language: json['language'] as String? ?? 'en',
      responseLength: json['responseLength'] as String? ?? 'detailed',
      technicalLevel: json['technicalLevel'] as String? ?? 'simple',
    );

Map<String, dynamic> _$UserPreferencesToJson(_UserPreferences instance) =>
    <String, dynamic>{
      'language': instance.language,
      'responseLength': instance.responseLength,
      'technicalLevel': instance.technicalLevel,
    };

_MessageMetadata _$MessageMetadataFromJson(Map<String, dynamic> json) =>
    _MessageMetadata(
      processingTime: (json['processingTime'] as num?)?.toInt() ?? 0,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
      tokensUsed: (json['tokensUsed'] as num?)?.toInt() ?? 0,
      modelVersion: json['modelVersion'] as String? ?? 'gpt-4',
      flagged: json['flagged'] as bool? ?? false,
      flagReason: json['flagReason'] as String?,
    );

Map<String, dynamic> _$MessageMetadataToJson(_MessageMetadata instance) =>
    <String, dynamic>{
      'processingTime': instance.processingTime,
      'confidence': instance.confidence,
      'tokensUsed': instance.tokensUsed,
      'modelVersion': instance.modelVersion,
      'flagged': instance.flagged,
      'flagReason': instance.flagReason,
    };

_Reference _$ReferenceFromJson(Map<String, dynamic> json) => _Reference(
  type: json['type'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  url: json['url'] as String?,
  confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
);

Map<String, dynamic> _$ReferenceToJson(_Reference instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'confidence': instance.confidence,
    };

_Attachment _$AttachmentFromJson(Map<String, dynamic> json) => _Attachment(
  type: json['type'] as String,
  url: json['url'] as String,
  contentType: json['contentType'] as String,
  size: (json['size'] as num).toInt(),
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$AttachmentToJson(_Attachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'url': instance.url,
      'contentType': instance.contentType,
      'size': instance.size,
      'metadata': instance.metadata,
    };

_Conversation _$ConversationFromJson(Map<String, dynamic> json) =>
    _Conversation(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      status:
          $enumDecodeNullable(_$ConversationStatusEnumMap, json['status']) ??
          ConversationStatus.active,
      metadata: json['metadata'] == null
          ? const ConversationMetadata()
          : ConversationMetadata.fromJson(
              json['metadata'] as Map<String, dynamic>,
            ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      messageCount: (json['messageCount'] as num?)?.toInt() ?? 0,
      totalTokensUsed: (json['totalTokensUsed'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ConversationToJson(_Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'status': _$ConversationStatusEnumMap[instance.status]!,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'messageCount': instance.messageCount,
      'totalTokensUsed': instance.totalTokensUsed,
    };

const _$ConversationStatusEnumMap = {
  ConversationStatus.active: 'ACTIVE',
  ConversationStatus.archived: 'ARCHIVED',
  ConversationStatus.deleted: 'DELETED',
};

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String,
  role: $enumDecode(_$MessageRoleEnumMap, json['role']),
  content: json['content'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  metadata: json['metadata'] == null
      ? const MessageMetadata()
      : MessageMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
  references:
      (json['references'] as List<dynamic>?)
          ?.map((e) => Reference.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isHidden: json['isHidden'] as bool? ?? false,
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'role': _$MessageRoleEnumMap[instance.role]!,
  'content': instance.content,
  'timestamp': instance.timestamp.toIso8601String(),
  'metadata': instance.metadata,
  'references': instance.references,
  'attachments': instance.attachments,
  'isHidden': instance.isHidden,
};

const _$MessageRoleEnumMap = {
  MessageRole.user: 'USER',
  MessageRole.assistant: 'ASSISTANT',
  MessageRole.system: 'SYSTEM',
};

_SendMessageRequest _$SendMessageRequestFromJson(Map<String, dynamic> json) =>
    _SendMessageRequest(
      content: json['content'] as String,
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SendMessageRequestToJson(_SendMessageRequest instance) =>
    <String, dynamic>{
      'content': instance.content,
      'attachments': instance.attachments,
    };

_SendMessageResponse _$SendMessageResponseFromJson(Map<String, dynamic> json) =>
    _SendMessageResponse(
      userMessage: Message.fromJson(
        json['userMessage'] as Map<String, dynamic>,
      ),
      assistantMessage: Message.fromJson(
        json['assistantMessage'] as Map<String, dynamic>,
      ),
      conversation: Conversation.fromJson(
        json['conversation'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$SendMessageResponseToJson(
  _SendMessageResponse instance,
) => <String, dynamic>{
  'userMessage': instance.userMessage,
  'assistantMessage': instance.assistantMessage,
  'conversation': instance.conversation,
};

_CreateConversationRequest _$CreateConversationRequestFromJson(
  Map<String, dynamic> json,
) => _CreateConversationRequest(
  title: json['title'] as String?,
  initialMessage: json['initialMessage'] as String?,
  metadata: json['metadata'] == null
      ? null
      : ConversationMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreateConversationRequestToJson(
  _CreateConversationRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'initialMessage': instance.initialMessage,
  'metadata': instance.metadata,
};
