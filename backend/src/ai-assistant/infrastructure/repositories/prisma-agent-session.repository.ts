import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import {
  AgentSessionRepository,
  AgentSessionFilters,
  AgentSessionStats,
  PaginationOptions,
  PaginatedResult,
} from '../../domain/repositories/agent-session.repository';
import {
  AgentSession,
  AgentSessionType,
  AgentSessionStatus,
} from '../../domain/entities/agent-session.entity';
import { AgentInteraction } from '../../domain/entities/agent-interaction.entity';

@Injectable()
export class PrismaAgentSessionRepository implements AgentSessionRepository {
  private readonly logger = new Logger(PrismaAgentSessionRepository.name);

  constructor(private readonly prisma: PrismaService) {}

  async create(session: AgentSession): Promise<AgentSession> {
    try {
      const created = await this.prisma.agentSession.create({
        data: {
          id: session.id,
          userId: session.userId,
          patientId: session.patientId,
          sessionType: session.sessionType as any,
          status: session.status as any,
          metadata: session.metadata as any,
          healthcareContext: session.healthcareContext as any,
          createdAt: session.createdAt,
          updatedAt: session.updatedAt,
          expiresAt: session.expiresAt,
        },
      });

      return this.mapToEntity(created);
    } catch (error) {
      this.logger.error('Error creating agent session:', error);
      throw new Error('Failed to create agent session');
    }
  }

  async findById(id: string): Promise<AgentSession | null> {
    try {
      const session = await this.prisma.agentSession.findUnique({
        where: { id },
      });

      return session ? this.mapToEntity(session) : null;
    } catch (error) {
      this.logger.error(`Error finding agent session ${id}:`, error);
      return null;
    }
  }

  async update(
    id: string,
    updates: Partial<AgentSession>,
  ): Promise<AgentSession> {
    try {
      const updated = await this.prisma.agentSession.update({
        where: { id },
        data: {
          status: updates.status as any,
          metadata: updates.metadata as any,
          healthcareContext: updates.healthcareContext as any,
          updatedAt: new Date(),
        },
      });

      return this.mapToEntity(updated);
    } catch (error) {
      this.logger.error(`Error updating agent session ${id}:`, error);
      throw new Error('Failed to update agent session');
    }
  }

  async delete(id: string): Promise<void> {
    try {
      await this.prisma.agentSession.delete({
        where: { id },
      });
    } catch (error) {
      this.logger.error(`Error deleting agent session ${id}:`, error);
      throw new Error('Failed to delete agent session');
    }
  }

  async findByUserId(
    userId: string,
    filters?: Partial<AgentSessionFilters>,
    pagination?: PaginationOptions,
  ): Promise<PaginatedResult<AgentSession>> {
    try {
      const where = this.buildWhereClause({ ...filters, userId });
      const { skip, take } = this.buildPagination(pagination);

      const [sessions, total] = await Promise.all([
        this.prisma.agentSession.findMany({
          where,
          skip,
          take,
          orderBy: { createdAt: 'desc' },
        }),
        this.prisma.agentSession.count({ where }),
      ]);

      return {
        data: sessions.map((s) => this.mapToEntity(s)),
        total,
        page: pagination?.page || 1,
        limit: pagination?.limit || 20,
        totalPages: Math.ceil(total / (pagination?.limit || 20)),
      };
    } catch (error) {
      this.logger.error(`Error finding sessions for user ${userId}:`, error);
      throw new Error('Failed to find user sessions');
    }
  }

  async findByPatientId(
    patientId: string,
    filters?: Partial<AgentSessionFilters>,
    pagination?: PaginationOptions,
  ): Promise<PaginatedResult<AgentSession>> {
    return this.findByUserId('', { ...filters, patientId }, pagination);
  }

  async findWithFilters(
    filters: AgentSessionFilters,
    pagination?: PaginationOptions,
  ): Promise<PaginatedResult<AgentSession>> {
    try {
      const where = this.buildWhereClause(filters);
      const { skip, take } = this.buildPagination(pagination);

      const [sessions, total] = await Promise.all([
        this.prisma.agentSession.findMany({
          where,
          skip,
          take,
          orderBy: { createdAt: 'desc' },
        }),
        this.prisma.agentSession.count({ where }),
      ]);

      return {
        data: sessions.map((s) => this.mapToEntity(s)),
        total,
        page: pagination?.page || 1,
        limit: pagination?.limit || 20,
        totalPages: Math.ceil(total / (pagination?.limit || 20)),
      };
    } catch (error) {
      this.logger.error('Error finding sessions with filters:', error);
      throw new Error('Failed to find sessions');
    }
  }

  async findActiveSessions(userId: string): Promise<AgentSession[]> {
    try {
      const sessions = await this.prisma.agentSession.findMany({
        where: {
          userId,
          status: AgentSessionStatus.ACTIVE as any,
          expiresAt: { gt: new Date() },
        },
        orderBy: { updatedAt: 'desc' },
      });

      return sessions.map((s) => this.mapToEntity(s));
    } catch (error) {
      this.logger.error(
        `Error finding active sessions for user ${userId}:`,
        error,
      );
      return [];
    }
  }

  async findExpiredSessions(): Promise<AgentSession[]> {
    try {
      const sessions = await this.prisma.agentSession.findMany({
        where: {
          OR: [
            { expiresAt: { lt: new Date() } },
            {
              status: AgentSessionStatus.ACTIVE as any,
              updatedAt: { lt: new Date(Date.now() - 24 * 60 * 60 * 1000) },
            },
          ],
        },
      });

      return sessions.map((s) => this.mapToEntity(s));
    } catch (error) {
      this.logger.error('Error finding expired sessions:', error);
      return [];
    }
  }

  async cleanupExpiredSessions(): Promise<number> {
    try {
      const result = await this.prisma.agentSession.updateMany({
        where: {
          OR: [
            { expiresAt: { lt: new Date() } },
            {
              status: AgentSessionStatus.ACTIVE as any,
              updatedAt: { lt: new Date(Date.now() - 24 * 60 * 60 * 1000) },
            },
          ],
        },
        data: {
          status: AgentSessionStatus.CANCELLED as any,
          updatedAt: new Date(),
        },
      });

      return result.count;
    } catch (error) {
      this.logger.error('Error cleaning up expired sessions:', error);
      return 0;
    }
  }

  async findEmergencySessions(timeRange?: {
    start: Date;
    end: Date;
  }): Promise<AgentSession[]> {
    try {
      const where: any = {
        OR: [
          { sessionType: AgentSessionType.EMERGENCY },
          { status: AgentSessionStatus.ESCALATED },
        ],
      };

      if (timeRange) {
        where.createdAt = {
          gte: timeRange.start,
          lte: timeRange.end,
        };
      }

      const sessions = await this.prisma.agentSession.findMany({
        where,
        orderBy: { createdAt: 'desc' },
      });

      return sessions.map((s) => this.mapToEntity(s));
    } catch (error) {
      this.logger.error('Error finding emergency sessions:', error);
      return [];
    }
  }

  async findSessionsWithCompliance(
    complianceIssues: boolean,
    timeRange?: { start: Date; end: Date },
  ): Promise<AgentSession[]> {
    try {
      const where: any = {};

      if (timeRange) {
        where.createdAt = {
          gte: timeRange.start,
          lte: timeRange.end,
        };
      }

      // Note: This would need to be implemented based on your Prisma schema
      // For now, returning empty array as placeholder
      return [];
    } catch (error) {
      this.logger.error(
        'Error finding sessions with compliance issues:',
        error,
      );
      return [];
    }
  }

  async findVietnameseHealthcareSessions(timeRange?: {
    start: Date;
    end: Date;
  }): Promise<AgentSession[]> {
    try {
      const where: any = {
        sessionType: AgentSessionType.VIETNAMESE_HEALTHCARE,
      };

      if (timeRange) {
        where.createdAt = {
          gte: timeRange.start,
          lte: timeRange.end,
        };
      }

      const sessions = await this.prisma.agentSession.findMany({
        where,
        orderBy: { createdAt: 'desc' },
      });

      return sessions.map((s) => this.mapToEntity(s));
    } catch (error) {
      this.logger.error('Error finding Vietnamese healthcare sessions:', error);
      return [];
    }
  }

  async findMedicationSessions(timeRange?: {
    start: Date;
    end: Date;
  }): Promise<AgentSession[]> {
    try {
      const where: any = {
        sessionType: AgentSessionType.MEDICATION,
      };

      if (timeRange) {
        where.createdAt = {
          gte: timeRange.start,
          lte: timeRange.end,
        };
      }

      const sessions = await this.prisma.agentSession.findMany({
        where,
        orderBy: { createdAt: 'desc' },
      });

      return sessions.map((s) => this.mapToEntity(s));
    } catch (error) {
      this.logger.error('Error finding medication sessions:', error);
      return [];
    }
  }

  // Placeholder implementations for remaining methods
  async getSessionStats(
    filters?: Partial<AgentSessionFilters>,
    timeRange?: { start: Date; end: Date },
  ): Promise<AgentSessionStats> {
    // Implementation would depend on your specific analytics needs
    return {
      totalSessions: 0,
      activeSessions: 0,
      completedSessions: 0,
      escalatedSessions: 0,
      averageDuration: 0,
      averageTokensUsed: 0,
      averageConfidence: 0,
      totalCost: 0,
      sessionsByType: {} as Record<AgentSessionType, number>,
      sessionsByAgent: {},
      complianceIssues: 0,
      emergencyEscalations: 0,
    };
  }

  async getSessionsByTimeRange(
    start: Date,
    end: Date,
    groupBy: 'hour' | 'day' | 'week' | 'month',
  ): Promise<Array<{ period: string; count: number; avgDuration: number }>> {
    return [];
  }

  async getTopAgents(
    limit: number,
    timeRange?: { start: Date; end: Date },
  ): Promise<
    Array<{ agentName: string; sessionCount: number; avgConfidence: number }>
  > {
    return [];
  }

  async getUserSessionSummary(
    userId: string,
    timeRange?: { start: Date; end: Date },
  ): Promise<any> {
    return {
      totalSessions: 0,
      totalDuration: 0,
      totalCost: 0,
      favoriteAgents: [],
      healthTopics: [],
      riskLevel: 'low' as const,
    };
  }

  async addInteraction(
    sessionId: string,
    interaction: AgentInteraction,
  ): Promise<AgentInteraction> {
    try {
      const created = await this.prisma.agentInteraction.create({
        data: {
          id: interaction.id,
          sessionId: interaction.sessionId,
          agentType: interaction.agentType as any,
          interactionType: interaction.interactionType as any,
          userQuery: interaction.userQuery,
          agentResponse: interaction.agentResponse,
          urgencyLevel: interaction.urgencyLevel as any,
          createdAt: interaction.createdAt,
          metadata: interaction.metadata as any,
          queryHash: interaction.queryHash,
          responseHash: interaction.responseHash,
        },
      });

      return this.mapInteractionToEntity(created);
    } catch (error) {
      this.logger.error('Error adding interaction:', error);
      throw new Error('Failed to add interaction');
    }
  }

  async getSessionInteractions(
    sessionId: string,
    pagination?: PaginationOptions,
  ): Promise<PaginatedResult<AgentInteraction>> {
    try {
      const { skip, take } = this.buildPagination(pagination);

      const [interactions, total] = await Promise.all([
        this.prisma.agentInteraction.findMany({
          where: { sessionId },
          skip,
          take,
          orderBy: { createdAt: 'desc' },
        }),
        this.prisma.agentInteraction.count({ where: { sessionId } }),
      ]);

      return {
        data: interactions.map((i) => this.mapInteractionToEntity(i)),
        total,
        page: pagination?.page || 1,
        limit: pagination?.limit || 20,
        totalPages: Math.ceil(total / (pagination?.limit || 20)),
      };
    } catch (error) {
      this.logger.error(
        `Error getting interactions for session ${sessionId}:`,
        error,
      );
      throw new Error('Failed to get session interactions');
    }
  }

  async updateInteraction(
    interactionId: string,
    updates: Partial<AgentInteraction>,
  ): Promise<AgentInteraction> {
    try {
      const updated = await this.prisma.agentInteraction.update({
        where: { id: interactionId },
        data: {
          metadata: updates.metadata as any,
        },
      });

      return this.mapInteractionToEntity(updated);
    } catch (error) {
      this.logger.error(`Error updating interaction ${interactionId}:`, error);
      throw new Error('Failed to update interaction');
    }
  }

  async deleteInteraction(interactionId: string): Promise<void> {
    try {
      await this.prisma.agentInteraction.delete({
        where: { id: interactionId },
      });
    } catch (error) {
      this.logger.error(`Error deleting interaction ${interactionId}:`, error);
      throw new Error('Failed to delete interaction');
    }
  }

  // Placeholder implementations for remaining methods
  async findSessionsForAudit(criteria: any): Promise<AgentSession[]> {
    return [];
  }
  async getComplianceReport(timeRange: {
    start: Date;
    end: Date;
  }): Promise<any> {
    return {};
  }
  async getPerformanceMetrics(timeRange: {
    start: Date;
    end: Date;
  }): Promise<any> {
    return {};
  }
  async getHealthcareOutcomes(timeRange: {
    start: Date;
    end: Date;
  }): Promise<any> {
    return {};
  }
  async searchSessions(
    query: string,
    filters?: Partial<AgentSessionFilters>,
    pagination?: PaginationOptions,
  ): Promise<PaginatedResult<AgentSession>> {
    return { data: [], total: 0, page: 1, limit: 20, totalPages: 0 };
  }
  async findSimilarSessions(
    sessionId: string,
    limit: number,
  ): Promise<AgentSession[]> {
    return [];
  }
  async bulkUpdateSessions(
    sessionIds: string[],
    updates: Partial<AgentSession>,
  ): Promise<number> {
    return 0;
  }
  async bulkDeleteSessions(sessionIds: string[]): Promise<number> {
    return 0;
  }
  async exportSessionData(
    filters: AgentSessionFilters,
    format: 'json' | 'csv',
  ): Promise<string> {
    return '';
  }
  async backupSessions(timeRange: {
    start: Date;
    end: Date;
  }): Promise<{ backupId: string; sessionCount: number; size: number }> {
    return { backupId: '', sessionCount: 0, size: 0 };
  }

  // Helper methods
  private buildWhereClause(filters: Partial<AgentSessionFilters>): any {
    const where: any = {};

    if (filters.userId) where.userId = filters.userId;
    if (filters.patientId) where.patientId = filters.patientId;
    if (filters.sessionType) where.sessionType = filters.sessionType;
    if (filters.status) where.status = filters.status;
    if (filters.createdAfter || filters.createdBefore) {
      where.createdAt = {};
      if (filters.createdAfter) where.createdAt.gte = filters.createdAfter;
      if (filters.createdBefore) where.createdAt.lte = filters.createdBefore;
    }

    return where;
  }

  private buildPagination(pagination?: PaginationOptions): {
    skip: number;
    take: number;
  } {
    const page = pagination?.page || 1;
    const limit = pagination?.limit || 20;
    return {
      skip: (page - 1) * limit,
      take: limit,
    };
  }

  private mapToEntity(data: any): AgentSession {
    return new AgentSession(
      data.id,
      data.userId,
      data.patientId,
      data.sessionType,
      data.createdAt,
      data.updatedAt,
      data.status,
      data.metadata,
      data.healthcareContext,
      data.expiresAt,
    );
  }

  private mapInteractionToEntity(data: any): AgentInteraction {
    return new AgentInteraction(
      data.id,
      data.sessionId,
      data.agentType,
      data.interactionType,
      data.userQuery,
      data.agentResponse,
      data.urgencyLevel,
      data.createdAt,
      data.metadata,
      data.queryHash,
      data.responseHash,
    );
  }
}
