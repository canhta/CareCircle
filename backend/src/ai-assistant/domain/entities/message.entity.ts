import { MessageRole } from '@prisma/client';
import { MessageMetadata } from '../value-objects/message.value-objects';
import { Reference, Attachment } from '../value-objects/shared.value-objects';

export class Message {
  constructor(
    public readonly id: string,
    public readonly conversationId: string,
    public readonly role: MessageRole,
    public content: string,
    public readonly timestamp: Date,
    public metadata: MessageMetadata,
    public references?: Reference[],
    public attachments?: Attachment[],
    public isHidden: boolean = false,
  ) {}

  static create(data: {
    id: string;
    conversationId: string;
    role: MessageRole;
    content: string;
    metadata?: Partial<MessageMetadata>;
    references?: Reference[];
    attachments?: Attachment[];
  }): Message {
    const defaultMetadata: MessageMetadata = {
      processingTime: 0,
      confidence: 1.0,
      tokensUsed: 0,
      modelVersion: 'gpt-4',
      flagged: false,
    };

    return new Message(
      data.id,
      data.conversationId,
      data.role,
      data.content,
      new Date(),
      { ...defaultMetadata, ...data.metadata },
      data.references,
      data.attachments,
      false,
    );
  }

  static createUserMessage(data: {
    id: string;
    conversationId: string;
    content: string;
    attachments?: Attachment[];
  }): Message {
    return Message.create({
      ...data,
      role: MessageRole.user,
      metadata: {
        processingTime: 0,
        confidence: 1.0,
        tokensUsed: this.estimateTokens(data.content),
        modelVersion: 'user-input',
        flagged: false,
      },
    });
  }

  static createAssistantMessage(data: {
    id: string;
    conversationId: string;
    content: string;
    metadata: MessageMetadata;
    references?: Reference[];
  }): Message {
    return Message.create({
      ...data,
      role: MessageRole.assistant,
    });
  }

  static createSystemMessage(data: {
    id: string;
    conversationId: string;
    content: string;
  }): Message {
    return Message.create({
      ...data,
      role: MessageRole.system,
      metadata: {
        processingTime: 0,
        confidence: 1.0,
        tokensUsed: this.estimateTokens(data.content),
        modelVersion: 'system',
        flagged: false,
      },
    });
  }

  updateContent(content: string): void {
    this.content = content;
    this.metadata.tokensUsed = Message.estimateTokens(content);
  }

  addReference(reference: Reference): void {
    if (!this.references) {
      this.references = [];
    }
    this.references.push(reference);
  }

  addAttachment(attachment: Attachment): void {
    if (!this.attachments) {
      this.attachments = [];
    }
    this.attachments.push(attachment);
  }

  flag(reason: string): void {
    this.metadata.flagged = true;
    this.metadata.flagReason = reason;
  }

  hide(): void {
    this.isHidden = true;
  }

  show(): void {
    this.isHidden = false;
  }

  isFromUser(): boolean {
    return this.role === MessageRole.user;
  }

  isFromAssistant(): boolean {
    return this.role === MessageRole.assistant;
  }

  isSystemMessage(): boolean {
    return this.role === MessageRole.system;
  }

  private static estimateTokens(text: string): number {
    // Rough estimation: 1 token ≈ 4 characters for English text
    return Math.ceil(text.length / 4);
  }
}
