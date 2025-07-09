import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { ConversationRepository } from '../../domain/repositories/conversation.repository';
import { Conversation } from '../../domain/entities/conversation.entity';
import { Message } from '../../domain/entities/message.entity';
import { ConversationMetadata } from '../../domain/value-objects/conversation.value-objects';
import { MessageMetadata } from '../../domain/value-objects/message.value-objects';
import {
  Reference,
  Attachment,
} from '../../domain/value-objects/shared.value-objects';
import {
  Conversation as PrismaConversation,
  Message as PrismaMessage,
  ConversationStatus,
} from '@prisma/client';

@Injectable()
export class PrismaConversationRepository extends ConversationRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async create(conversation: Conversation): Promise<Conversation> {
    const created = await this.prisma.conversation.create({
      data: {
        id: conversation.id,
        userId: conversation.userId,
        title: conversation.title,
        status: conversation.status,
        metadata: conversation.metadata,
        createdAt: conversation.createdAt,
        updatedAt: conversation.updatedAt,
      },
      include: {
        messages: true,
      },
    });

    return this.mapToConversation(created);
  }

  async findById(id: string): Promise<Conversation | null> {
    const conversation = await this.prisma.conversation.findUnique({
      where: { id },
      include: {
        messages: {
          orderBy: { timestamp: 'asc' },
        },
      },
    });

    return conversation ? this.mapToConversation(conversation) : null;
  }

  async findByUserId(
    userId: string,
    status?: ConversationStatus,
  ): Promise<Conversation[]> {
    const conversations = await this.prisma.conversation.findMany({
      where: {
        userId,
        ...(status && { status }),
      },
      include: {
        messages: {
          orderBy: { timestamp: 'asc' },
        },
      },
      orderBy: { updatedAt: 'desc' },
    });

    return conversations.map((conv) => this.mapToConversation(conv));
  }

  async update(
    id: string,
    updates: Partial<Conversation>,
  ): Promise<Conversation> {
    const updated = await this.prisma.conversation.update({
      where: { id },
      data: {
        ...(updates.title && { title: updates.title }),
        ...(updates.status && { status: updates.status }),
        ...(updates.metadata && {
          metadata: updates.metadata,
        }),
        ...(updates.updatedAt && { updatedAt: updates.updatedAt }),
      },
      include: {
        messages: {
          orderBy: { timestamp: 'asc' },
        },
      },
    });

    return this.mapToConversation(updated);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.conversation.delete({
      where: { id },
    });
  }

  async addMessage(conversationId: string, message: Message): Promise<Message> {
    const created = await this.prisma.message.create({
      data: {
        id: message.id,
        conversationId: message.conversationId,
        role: message.role,
        content: message.content,
        timestamp: message.timestamp,
        metadata: message.metadata,
        references: message.references,
        attachments: message.attachments,
        isHidden: message.isHidden,
      },
    });

    return this.mapToMessage(created);
  }

  async getMessages(
    conversationId: string,
    limit?: number,
    beforeId?: string,
  ): Promise<Message[]> {
    const messages = await this.prisma.message.findMany({
      where: {
        conversationId,
        ...(beforeId && {
          timestamp: {
            lt: (
              await this.prisma.message.findUnique({
                where: { id: beforeId },
                select: { timestamp: true },
              })
            )?.timestamp,
          },
        }),
      },
      orderBy: { timestamp: 'desc' },
      take: limit,
    });

    return messages.map((msg) => this.mapToMessage(msg)).reverse();
  }

  async updateMessage(
    messageId: string,
    updates: Partial<Message>,
  ): Promise<Message> {
    const updated = await this.prisma.message.update({
      where: { id: messageId },
      data: {
        ...(updates.content && { content: updates.content }),
        ...(updates.metadata && {
          metadata: updates.metadata,
        }),
        ...(updates.references && {
          references: updates.references,
        }),
        ...(updates.attachments && {
          attachments: updates.attachments,
        }),
        ...(updates.isHidden !== undefined && { isHidden: updates.isHidden }),
      },
    });

    return this.mapToMessage(updated);
  }

  async deleteMessage(messageId: string): Promise<void> {
    await this.prisma.message.delete({
      where: { id: messageId },
    });
  }

  async getMessageCount(conversationId: string): Promise<number> {
    return this.prisma.message.count({
      where: { conversationId },
    });
  }

  async getConversationCount(userId: string): Promise<number> {
    return this.prisma.conversation.count({
      where: { userId },
    });
  }

  getTotalTokensUsed(_userId: string): Promise<number> {
    // TODO: Implement proper token counting from metadata
    // For now, return 0 as placeholder until we implement metadata aggregation
    return Promise.resolve(0);
  }

  async getActiveConversations(userId: string): Promise<Conversation[]> {
    return this.findByUserId(userId, ConversationStatus.ACTIVE);
  }

  private mapToConversation(
    data: PrismaConversation & { messages?: PrismaMessage[] },
  ): Conversation {
    const messages = Array.isArray(data.messages)
      ? data.messages.map((msg: PrismaMessage) => this.mapToMessage(msg))
      : [];

    return new Conversation(
      data.id,
      data.userId,
      data.title,
      data.createdAt,
      data.updatedAt,
      messages,
      data.metadata as ConversationMetadata,
      data.status,
    );
  }

  private mapToMessage(data: PrismaMessage): Message {
    return new Message(
      data.id,
      data.conversationId,
      data.role,
      data.content,
      data.timestamp,
      data.metadata as MessageMetadata,
      data.references as Reference[],
      data.attachments as Attachment[],
      data.isHidden,
    );
  }
}
