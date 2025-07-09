import {
  IsString,
  IsOptional,
  IsEnum,
  IsObject,
  IsArray,
} from 'class-validator';
import { Conversation } from '../../domain/entities/conversation.entity';
import { Message } from '../../domain/entities/message.entity';
import { ConversationMetadata } from '../../domain/value-objects/conversation.value-objects';
import { ConversationStatus } from '@prisma/client';
import { MessageMetadata } from '../../domain/value-objects/message.value-objects';
import { MessageRole } from '@prisma/client';
import {
  Reference,
  Attachment,
} from '../../domain/value-objects/shared.value-objects';

export class CreateConversationDto {
  @IsOptional()
  @IsString()
  title?: string;

  @IsOptional()
  @IsString()
  initialMessage?: string;

  @IsOptional()
  @IsObject()
  metadata?: Partial<ConversationMetadata>;
}

export class UpdateConversationDto {
  @IsOptional()
  @IsString()
  title?: string;

  @IsOptional()
  @IsEnum(ConversationStatus)
  status?: ConversationStatus;
}

export class SendMessageDto {
  @IsString()
  content: string;

  @IsOptional()
  @IsArray()
  attachments?: Attachment[];
}

export class ConversationResponseDto {
  id: string;
  userId: string;
  title: string;
  status: ConversationStatus;
  metadata: ConversationMetadata;
  createdAt: Date;
  updatedAt: Date;
  messageCount: number;
  totalTokensUsed: number;

  static fromEntity(conversation: Conversation): ConversationResponseDto {
    const dto = new ConversationResponseDto();
    dto.id = conversation.id;
    dto.userId = conversation.userId;
    dto.title = conversation.title;
    dto.status = conversation.status;
    dto.metadata = conversation.metadata;
    dto.createdAt = conversation.createdAt;
    dto.updatedAt = conversation.updatedAt;
    dto.messageCount = conversation.messages.length;
    dto.totalTokensUsed = conversation.getTotalTokensUsed();
    return dto;
  }
}

export class MessageResponseDto {
  id: string;
  conversationId: string;
  role: MessageRole;
  content: string;
  timestamp: Date;
  metadata: MessageMetadata;
  references?: Reference[];
  attachments?: Attachment[];
  isHidden: boolean;

  static fromEntity(message: Message): MessageResponseDto {
    const dto = new MessageResponseDto();
    dto.id = message.id;
    dto.conversationId = message.conversationId;
    dto.role = message.role;
    dto.content = message.content;
    dto.timestamp = message.timestamp;
    dto.metadata = message.metadata;
    dto.references = message.references;
    dto.attachments = message.attachments;
    dto.isHidden = message.isHidden;
    return dto;
  }
}

export class SendMessageResponseDto {
  userMessage: MessageResponseDto;
  assistantMessage: MessageResponseDto;
  conversation: ConversationResponseDto;
}
