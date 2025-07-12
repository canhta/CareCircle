import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  Request,
  HttpCode,
  HttpStatus,
  UseGuards,
  Sse,
  MessageEvent,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { ConversationService } from '../../application/services/conversation.service';
import { ConversationStatus } from '@prisma/client';
import { FirebaseAuthGuard } from '../../../identity-access/presentation/guards/firebase-auth.guard';
import {
  CreateConversationDto,
  SendMessageDto,
  UpdateConversationDto,
  ConversationResponseDto,
  MessageResponseDto,
  SendMessageResponseDto,
} from '../dtos/conversation.dto';

@Controller('ai-assistant/conversations')
@UseGuards(FirebaseAuthGuard)
export class ConversationController {
  constructor(private readonly conversationService: ConversationService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async createConversation(
    @Body() createConversationDto: CreateConversationDto,
    @Request() req: { user: { id: string } },
  ): Promise<ConversationResponseDto> {
    const userId = req.user.id;

    const conversation = await this.conversationService.createConversation({
      userId,
      title: createConversationDto.title,
      metadata: createConversationDto.metadata,
    });

    return ConversationResponseDto.fromEntity(conversation);
  }

  @Get()
  async getUserConversations(
    @Request() req: Request & { user: { id: string } },
    @Query('status') status?: string,
  ): Promise<ConversationResponseDto[]> {
    const conversations = await this.conversationService.getUserConversations(
      req.user.id,
      status as ConversationStatus,
    );

    return conversations.map((conv) =>
      ConversationResponseDto.fromEntity(conv),
    );
  }

  @Get(':id')
  async getConversation(
    @Param('id') id: string,
  ): Promise<ConversationResponseDto> {
    const conversation = await this.conversationService.getConversationById(id);
    if (!conversation) {
      throw new Error('Conversation not found');
    }
    return ConversationResponseDto.fromEntity(conversation);
  }

  @Put(':id')
  async updateConversation(
    @Param('id') id: string,
    @Body() updateConversationDto: UpdateConversationDto,
  ): Promise<ConversationResponseDto> {
    let conversation = await this.conversationService.getConversationById(id);
    if (!conversation) {
      throw new Error('Conversation not found');
    }

    if (updateConversationDto.title || updateConversationDto.status) {
      conversation = await this.conversationService.updateConversation(id, {
        title: updateConversationDto.title,
        status: updateConversationDto.status,
      });
    }

    return ConversationResponseDto.fromEntity(conversation);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async deleteConversation(@Param('id') id: string): Promise<void> {
    await this.conversationService.deleteConversation(id);
  }

  @Post(':id/messages')
  @HttpCode(HttpStatus.CREATED)
  async sendMessage(
    @Param('id') conversationId: string,
    @Body() sendMessageDto: SendMessageDto,
    @Request() req: Request & { user: { id: string } },
  ): Promise<SendMessageResponseDto> {
    const result = await this.conversationService.sendMessage({
      conversationId,
      content: sendMessageDto.content,
      userId: req.user.id,
    });

    return {
      userMessage: MessageResponseDto.fromEntity(result.userMessage),
      assistantMessage: MessageResponseDto.fromEntity(result.assistantMessage),
      conversation: ConversationResponseDto.fromEntity(result.conversation),
    };
  }

  @Sse(':id/stream')
  streamMessage(
    @Param('id') conversationId: string,
    @Query('message') message: string,
    @Request() req: Request & { user: { id: string } },
  ): Observable<MessageEvent> {
    return new Observable((observer) => {
      this.conversationService
        .sendMessageStream({
          conversationId,
          content: message,
          userId: req.user.id,
        })
        .then(async (streamGenerator) => {
          try {
            // Send initial user message event
            observer.next({
              data: JSON.stringify({
                type: 'user_message',
                content: message,
                timestamp: new Date().toISOString(),
              }),
            } as MessageEvent);

            // Stream AI response chunks
            for await (const chunk of streamGenerator) {
              observer.next({
                data: JSON.stringify({
                  type: chunk.isComplete ? 'stream_complete' : 'stream_chunk',
                  content: chunk.content,
                  isComplete: chunk.isComplete,
                  metadata: chunk.metadata,
                  timestamp: new Date().toISOString(),
                }),
              } as MessageEvent);

              if (chunk.isComplete) {
                observer.complete();
                break;
              }
            }
          } catch (error) {
            console.error('Streaming error:', error);
            observer.next({
              data: JSON.stringify({
                type: 'error',
                error: 'Failed to generate streaming response',
                timestamp: new Date().toISOString(),
              }),
            } as MessageEvent);
            observer.complete();
          }
        })
        .catch((error) => {
          console.error('Stream initialization error:', error);
          observer.next({
            data: JSON.stringify({
              type: 'error',
              error: 'Failed to initialize streaming response',
              timestamp: new Date().toISOString(),
            }),
          } as MessageEvent);
          observer.complete();
        });
    });
  }

  @Get(':id/messages')
  async getMessages(
    @Param('id') conversationId: string,
    @Query('limit') limit?: string,
    @Query('beforeId') beforeId?: string,
  ): Promise<MessageResponseDto[]> {
    const messages = await this.conversationService.getMessages(
      conversationId,
      limit ? parseInt(limit) : undefined,
      beforeId,
    );

    return messages.map((msg) => MessageResponseDto.fromEntity(msg));
  }
}
