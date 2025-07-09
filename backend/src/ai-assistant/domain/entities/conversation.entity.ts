import { ConversationMetadata } from '../value-objects/conversation.value-objects';
import { ConversationStatus } from '@prisma/client';
import { Message } from './message.entity';

export class Conversation {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public title: string,
    public readonly createdAt: Date,
    public updatedAt: Date,
    public messages: Message[],
    public metadata: ConversationMetadata,
    public status: ConversationStatus,
  ) {}

  static create(data: {
    id: string;
    userId: string;
    title?: string;
    metadata?: Partial<ConversationMetadata>;
  }): Conversation {
    const now = new Date();
    const defaultMetadata: ConversationMetadata = {
      healthContextIncluded: false,
      medicationContextIncluded: false,
      userPreferences: {
        language: 'en',
        responseLength: 'detailed',
        technicalLevel: 'simple',
      },
      aiModelUsed: 'gpt-4',
      tokensUsed: 0,
    };

    return new Conversation(
      data.id,
      data.userId,
      data.title || 'New Conversation',
      now,
      now,
      [],
      { ...defaultMetadata, ...data.metadata },
      ConversationStatus.ACTIVE,
    );
  }

  addMessage(message: Message): void {
    this.messages.push(message);
    this.updatedAt = new Date();
    this.metadata.tokensUsed += message.metadata.tokensUsed;
  }

  updateTitle(title: string): void {
    this.title = title;
    this.updatedAt = new Date();
  }

  updateStatus(status: ConversationStatus): void {
    this.status = status;
    this.updatedAt = new Date();
  }

  updateMetadata(metadata: Partial<ConversationMetadata>): void {
    this.metadata = { ...this.metadata, ...metadata };
    this.updatedAt = new Date();
  }

  getRecentMessages(limit: number = 10): Message[] {
    return this.messages
      .sort((a, b) => b.timestamp.getTime() - a.timestamp.getTime())
      .slice(0, limit);
  }

  getTotalTokensUsed(): number {
    return this.metadata.tokensUsed;
  }

  isActive(): boolean {
    return this.status === ConversationStatus.ACTIVE;
  }

  canAddMessage(): boolean {
    return this.isActive();
  }
}
