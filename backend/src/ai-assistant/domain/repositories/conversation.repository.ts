import { Conversation } from '../entities/conversation.entity';
import { Message } from '../entities/message.entity';
import { ConversationStatus } from '@prisma/client';

export abstract class ConversationRepository {
  abstract create(conversation: Conversation): Promise<Conversation>;
  abstract findById(id: string): Promise<Conversation | null>;
  abstract findByUserId(
    userId: string,
    status?: ConversationStatus,
  ): Promise<Conversation[]>;
  abstract update(
    id: string,
    updates: Partial<Conversation>,
  ): Promise<Conversation>;
  abstract delete(id: string): Promise<void>;

  // Message operations
  abstract addMessage(
    conversationId: string,
    message: Message,
  ): Promise<Message>;
  abstract getMessages(
    conversationId: string,
    limit?: number,
    beforeId?: string,
  ): Promise<Message[]>;
  abstract updateMessage(
    messageId: string,
    updates: Partial<Message>,
  ): Promise<Message>;
  abstract deleteMessage(messageId: string): Promise<void>;
  abstract getMessageCount(conversationId: string): Promise<number>;

  // Conversation statistics
  abstract getConversationCount(userId: string): Promise<number>;
  abstract getTotalTokensUsed(userId: string): Promise<number>;
  abstract getActiveConversations(userId: string): Promise<Conversation[]>;
}
