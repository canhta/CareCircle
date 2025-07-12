import {
  Controller,
  Post,
  Get,
  Body,
  Param,
  Query,
  Request,
  UseGuards,
  HttpStatus,
  HttpException,
  Sse,
  MessageEvent,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import {
  FirebaseAuthGuard,
  FirebaseUserPayload,
} from '../../../identity-access/presentation/guards/firebase-auth.guard';
import {
  ChatAgentService,
  ChatAgentRequest,
  ChatAgentResponse,
} from '../../application/services/chat-agent.service';
import {
  AgentSessionType,
  AgentSessionStatus,
} from '../../domain/entities/agent-session.entity';

export class ChatRequest {
  message: string;
  sessionId?: string;
  patientContext?: {
    patientId?: string;
    age?: number;
    gender?: 'male' | 'female' | 'other';
    medicalHistory?: string[];
    currentMedications?: string[];
    allergies?: string[];
    vitalSigns?: {
      bloodPressure?: string;
      heartRate?: number;
      temperature?: number;
    };
  };
  urgencyOverride?: boolean;
  agentPreference?: string;
  streamResponse?: boolean;
}

export class SessionHistoryQuery {
  limit?: number = 50;
}

export class UserSessionsQuery {
  sessionType?: AgentSessionType;
  status?: AgentSessionStatus;
  startDate?: string;
  endDate?: string;
  page?: number = 1;
  limit?: number = 20;
}

@Controller('ai-assistant/chat')
@UseGuards(FirebaseAuthGuard)
export class ChatAgentController {
  constructor(private readonly chatAgentService: ChatAgentService) {}

  @Post()
  async processChat(
    @Request() req: { user: FirebaseUserPayload },
    @Body() chatRequest: ChatRequest,
  ): Promise<{
    success: boolean;
    data: ChatAgentResponse;
    timestamp: string;
  }> {
    try {
      const userId = req.user.id;

      // Validate request
      if (!chatRequest.message || chatRequest.message.trim().length === 0) {
        throw new HttpException('Message is required', HttpStatus.BAD_REQUEST);
      }

      if (chatRequest.message.length > 4000) {
        throw new HttpException(
          'Message too long (max 4000 characters)',
          HttpStatus.BAD_REQUEST,
        );
      }

      // Process the chat request
      const agentRequest: ChatAgentRequest = {
        message: chatRequest.message.trim(),
        sessionId: chatRequest.sessionId,
        patientContext: chatRequest.patientContext,
        urgencyOverride: chatRequest.urgencyOverride,
        agentPreference: chatRequest.agentPreference,
        streamResponse: chatRequest.streamResponse,
      };

      const response = await this.chatAgentService.processChat(
        userId,
        agentRequest,
      );

      return {
        success: true,
        data: response,
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      if (error instanceof HttpException) {
        throw error;
      }

      throw new HttpException(
        'Failed to process chat request',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Sse('stream')
  streamChat(
    @Request() req: { user: FirebaseUserPayload },
    @Query() query: { message: string; sessionId?: string },
  ): Observable<MessageEvent> {
    const userId = req.user.id;

    if (!query.message || query.message.trim().length === 0) {
      throw new HttpException('Message is required', HttpStatus.BAD_REQUEST);
    }

    const agentRequest: ChatAgentRequest = {
      message: query.message.trim(),
      sessionId: query.sessionId,
      streamResponse: true,
    };

    return new Observable<MessageEvent>((observer) => {
      (async () => {
        try {
          const stream = this.chatAgentService.streamChat(userId, agentRequest);

          for await (const chunk of stream) {
            observer.next({
              data: JSON.stringify(chunk),
              type: chunk.type,
            } as MessageEvent);
          }

          observer.complete();
        } catch (error) {
          observer.error(error);
        }
      })();
    });
  }

  @Get('sessions/:sessionId/history')
  async getSessionHistory(
    @Request() req: { user: FirebaseUserPayload },
    @Param('sessionId') sessionId: string,
    @Query() query: SessionHistoryQuery,
  ): Promise<{
    success: boolean;
    data: {
      session: any;
      interactions: any[];
      summary: any;
    };
  }> {
    try {
      const userId = req.user.id;
      const limit = Math.min(query.limit || 50, 100); // Cap at 100

      const history = await this.chatAgentService.getSessionHistory(
        userId,
        sessionId,
        limit,
      );

      return {
        success: true,
        data: history,
      };
    } catch (error) {
      if (
        error.message.includes('not found') ||
        error.message.includes('access denied')
      ) {
        throw new HttpException(
          'Session not found or access denied',
          HttpStatus.NOT_FOUND,
        );
      }

      throw new HttpException(
        'Failed to get session history',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('sessions')
  async getUserSessions(
    @Request() req: { user: FirebaseUserPayload },
    @Query() query: UserSessionsQuery,
  ): Promise<{
    success: boolean;
    data: any[];
    pagination: {
      page: number;
      limit: number;
      total: number;
    };
  }> {
    try {
      const userId = req.user.id;

      // Build filters
      const filters: any = {};
      if (query.sessionType) filters.sessionType = query.sessionType;
      if (query.status) filters.status = query.status;
      if (query.startDate || query.endDate) {
        filters.timeRange = {};
        if (query.startDate)
          filters.timeRange.start = new Date(query.startDate);
        if (query.endDate) filters.timeRange.end = new Date(query.endDate);
      }

      const sessions = await this.chatAgentService.getUserSessions(
        userId,
        filters,
      );

      // Simple pagination (in production, implement proper pagination)
      const page = query.page || 1;
      const limit = Math.min(query.limit || 20, 100);
      const startIndex = (page - 1) * limit;
      const endIndex = startIndex + limit;
      const paginatedSessions = sessions.slice(startIndex, endIndex);

      return {
        success: true,
        data: paginatedSessions,
        pagination: {
          page,
          limit,
          total: sessions.length,
        },
      };
    } catch (error) {
      throw new HttpException(
        'Failed to get user sessions',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('sessions/:sessionId')
  async getSession(
    @Request() req: { user: FirebaseUserPayload },
    @Param('sessionId') sessionId: string,
  ): Promise<{
    success: boolean;
    data: any;
  }> {
    try {
      const userId = req.user.id;

      const history = await this.chatAgentService.getSessionHistory(
        userId,
        sessionId,
        1,
      );

      return {
        success: true,
        data: {
          session: history.session,
          summary: history.summary,
        },
      };
    } catch (error) {
      if (
        error.message.includes('not found') ||
        error.message.includes('access denied')
      ) {
        throw new HttpException(
          'Session not found or access denied',
          HttpStatus.NOT_FOUND,
        );
      }

      throw new HttpException(
        'Failed to get session',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('health')
  async healthCheck(): Promise<{
    success: boolean;
    status: string;
    timestamp: string;
    services: {
      orchestrator: string;
      database: string;
      ai: string;
    };
  }> {
    try {
      // Basic health check - in production, implement proper service checks
      return {
        success: true,
        status: 'healthy',
        timestamp: new Date().toISOString(),
        services: {
          orchestrator: 'healthy',
          database: 'healthy',
          ai: 'healthy',
        },
      };
    } catch (error) {
      throw new HttpException(
        'Health check failed',
        HttpStatus.SERVICE_UNAVAILABLE,
      );
    }
  }

  @Get('agents/capabilities')
  async getAgentCapabilities(): Promise<{
    success: boolean;
    data: {
      agents: Array<{
        type: string;
        name: string;
        description: string;
        capabilities: string[];
        supportedLanguages: string[];
        culturalContexts: string[];
        maxSeverityLevel: number;
        requiresPhysicianReview: boolean;
      }>;
    };
  }> {
    try {
      const agents = [
        {
          type: 'supervisor',
          name: 'Healthcare Supervisor',
          description:
            'Coordinates and routes queries to specialized healthcare agents',
          capabilities: [
            'Query analysis and routing',
            'Agent coordination',
            'Escalation management',
            'Compliance monitoring',
          ],
          supportedLanguages: ['english', 'vietnamese'],
          culturalContexts: ['modern', 'traditional', 'mixed'],
          maxSeverityLevel: 10,
          requiresPhysicianReview: false,
        },
        {
          type: 'medication',
          name: 'Medication Management Agent',
          description:
            'Specialized in medication guidance, interactions, and adherence',
          capabilities: [
            'Drug interaction analysis',
            'Dosage recommendations',
            'Side effect information',
            'Medication adherence strategies',
            'Pharmacy guidance',
          ],
          supportedLanguages: ['english', 'vietnamese'],
          culturalContexts: ['modern'],
          maxSeverityLevel: 8,
          requiresPhysicianReview: true,
        },
        {
          type: 'emergency',
          name: 'Emergency Triage Agent',
          description:
            'Assesses urgency and provides immediate guidance for emergency situations',
          capabilities: [
            'Symptom severity assessment',
            'Emergency detection',
            'Immediate care guidance',
            'Emergency services routing',
            'Critical care protocols',
          ],
          supportedLanguages: ['english', 'vietnamese'],
          culturalContexts: ['modern', 'traditional'],
          maxSeverityLevel: 10,
          requiresPhysicianReview: true,
        },
        {
          type: 'clinical',
          name: 'Clinical Decision Support Agent',
          description:
            'Provides evidence-based medical guidance and symptom analysis',
          capabilities: [
            'Symptom analysis',
            'Differential diagnosis support',
            'Evidence-based recommendations',
            'Health monitoring guidance',
            'Preventive care advice',
          ],
          supportedLanguages: ['english', 'vietnamese'],
          culturalContexts: ['modern'],
          maxSeverityLevel: 7,
          requiresPhysicianReview: true,
        },
        {
          type: 'vietnamese_medical',
          name: 'Vietnamese Healthcare Specialist',
          description:
            'Culturally appropriate medical guidance integrating traditional and modern medicine',
          capabilities: [
            'Vietnamese medical terminology',
            'Traditional medicine integration',
            'Cultural healthcare practices',
            'Local healthcare system navigation',
            'Bilingual medical communication',
          ],
          supportedLanguages: ['vietnamese', 'english'],
          culturalContexts: ['traditional', 'mixed'],
          maxSeverityLevel: 8,
          requiresPhysicianReview: true,
        },
      ];

      return {
        success: true,
        data: { agents },
      };
    } catch (error) {
      throw new HttpException(
        'Failed to get agent capabilities',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
