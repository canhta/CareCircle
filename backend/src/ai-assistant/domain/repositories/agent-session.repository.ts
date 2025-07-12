import {
  AgentSession,
  AgentSessionType,
  AgentSessionStatus,
} from '../entities/agent-session.entity';
import { AgentInteraction } from '../entities/agent-interaction.entity';

export interface AgentSessionFilters {
  userId?: string;
  patientId?: string;
  sessionType?: AgentSessionType;
  status?: AgentSessionStatus;
  createdAfter?: Date;
  createdBefore?: Date;
  hasEmergencyContext?: boolean;
  hasVietnameseContext?: boolean;
  hasMedicationContext?: boolean;
  escalationTriggered?: boolean;
  phiDetected?: boolean;
}

export interface AgentSessionStats {
  totalSessions: number;
  activeSessions: number;
  completedSessions: number;
  escalatedSessions: number;
  averageDuration: number;
  averageTokensUsed: number;
  averageConfidence: number;
  totalCost: number;
  sessionsByType: Record<AgentSessionType, number>;
  sessionsByAgent: Record<string, number>;
  complianceIssues: number;
  emergencyEscalations: number;
}

export interface PaginationOptions {
  page: number;
  limit: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}

export interface PaginatedResult<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export abstract class AgentSessionRepository {
  // Basic CRUD operations
  abstract create(session: AgentSession): Promise<AgentSession>;
  abstract findById(id: string): Promise<AgentSession | null>;
  abstract update(
    id: string,
    updates: Partial<AgentSession>,
  ): Promise<AgentSession>;
  abstract delete(id: string): Promise<void>;

  // Query operations
  abstract findByUserId(
    userId: string,
    filters?: Partial<AgentSessionFilters>,
    pagination?: PaginationOptions,
  ): Promise<PaginatedResult<AgentSession>>;

  abstract findByPatientId(
    patientId: string,
    filters?: Partial<AgentSessionFilters>,
    pagination?: PaginationOptions,
  ): Promise<PaginatedResult<AgentSession>>;

  abstract findWithFilters(
    filters: AgentSessionFilters,
    pagination?: PaginationOptions,
  ): Promise<PaginatedResult<AgentSession>>;

  // Session management
  abstract findActiveSessions(userId: string): Promise<AgentSession[]>;
  abstract findExpiredSessions(): Promise<AgentSession[]>;
  abstract cleanupExpiredSessions(): Promise<number>;

  // Healthcare-specific queries
  abstract findEmergencySessions(timeRange?: {
    start: Date;
    end: Date;
  }): Promise<AgentSession[]>;

  abstract findSessionsWithCompliance(
    complianceIssues: boolean,
    timeRange?: { start: Date; end: Date },
  ): Promise<AgentSession[]>;

  abstract findVietnameseHealthcareSessions(timeRange?: {
    start: Date;
    end: Date;
  }): Promise<AgentSession[]>;

  abstract findMedicationSessions(timeRange?: {
    start: Date;
    end: Date;
  }): Promise<AgentSession[]>;

  // Analytics and reporting
  abstract getSessionStats(
    filters?: Partial<AgentSessionFilters>,
    timeRange?: { start: Date; end: Date },
  ): Promise<AgentSessionStats>;

  abstract getSessionsByTimeRange(
    start: Date,
    end: Date,
    groupBy: 'hour' | 'day' | 'week' | 'month',
  ): Promise<Array<{ period: string; count: number; avgDuration: number }>>;

  abstract getTopAgents(
    limit: number,
    timeRange?: { start: Date; end: Date },
  ): Promise<
    Array<{ agentName: string; sessionCount: number; avgConfidence: number }>
  >;

  abstract getUserSessionSummary(
    userId: string,
    timeRange?: { start: Date; end: Date },
  ): Promise<{
    totalSessions: number;
    totalDuration: number;
    totalCost: number;
    favoriteAgents: string[];
    healthTopics: string[];
    riskLevel: 'low' | 'medium' | 'high' | 'critical';
  }>;

  // Interaction management
  abstract addInteraction(
    sessionId: string,
    interaction: AgentInteraction,
  ): Promise<AgentInteraction>;

  abstract getSessionInteractions(
    sessionId: string,
    pagination?: PaginationOptions,
  ): Promise<PaginatedResult<AgentInteraction>>;

  abstract updateInteraction(
    interactionId: string,
    updates: Partial<AgentInteraction>,
  ): Promise<AgentInteraction>;

  abstract deleteInteraction(interactionId: string): Promise<void>;

  // Compliance and audit
  abstract findSessionsForAudit(criteria: {
    phiDetected?: boolean;
    lowCompliance?: boolean;
    emergencyEscalation?: boolean;
    timeRange?: { start: Date; end: Date };
  }): Promise<AgentSession[]>;

  abstract getComplianceReport(timeRange: { start: Date; end: Date }): Promise<{
    totalSessions: number;
    phiDetections: number;
    complianceViolations: number;
    emergencyEscalations: number;
    auditTrail: Array<{
      sessionId: string;
      timestamp: Date;
      issue: string;
      severity: 'low' | 'medium' | 'high' | 'critical';
    }>;
  }>;

  // Performance monitoring
  abstract getPerformanceMetrics(timeRange: {
    start: Date;
    end: Date;
  }): Promise<{
    averageResponseTime: number;
    averageConfidence: number;
    totalTokensUsed: number;
    totalCost: number;
    errorRate: number;
    agentPerformance: Array<{
      agentType: string;
      avgResponseTime: number;
      avgConfidence: number;
      usageCount: number;
    }>;
  }>;

  // Healthcare outcomes
  abstract getHealthcareOutcomes(timeRange: {
    start: Date;
    end: Date;
  }): Promise<{
    emergencyDetections: number;
    medicationInteractions: number;
    preventiveCareRecommendations: number;
    traditionalMedicineConsultations: number;
    physicianReferrals: number;
    patientSatisfactionScore: number;
  }>;

  // Search and discovery
  abstract searchSessions(
    query: string,
    filters?: Partial<AgentSessionFilters>,
    pagination?: PaginationOptions,
  ): Promise<PaginatedResult<AgentSession>>;

  abstract findSimilarSessions(
    sessionId: string,
    limit: number,
  ): Promise<AgentSession[]>;

  // Bulk operations
  abstract bulkUpdateSessions(
    sessionIds: string[],
    updates: Partial<AgentSession>,
  ): Promise<number>;

  abstract bulkDeleteSessions(sessionIds: string[]): Promise<number>;

  // Export and backup
  abstract exportSessionData(
    filters: AgentSessionFilters,
    format: 'json' | 'csv',
  ): Promise<string>;

  abstract backupSessions(timeRange: {
    start: Date;
    end: Date;
  }): Promise<{ backupId: string; sessionCount: number; size: number }>;
}
