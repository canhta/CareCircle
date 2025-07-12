import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';

export interface HIPAAAuditEvent {
  eventType:
    | 'healthcare_query'
    | 'agent_interaction'
    | 'phi_access'
    | 'emergency_escalation'
    | 'medication_analysis';
  userId: string;
  agentType?: string;
  queryHash: string; // Hashed version of the query for privacy
  responseHash: string; // Hashed version of the response
  severity: 'low' | 'medium' | 'high' | 'critical';
  containsPHI: boolean;
  emergencyFlag: boolean;
  complianceFlags: string[];
  metadata: {
    sessionId?: string;
    ipAddress?: string;
    userAgent?: string;
    timestamp: Date;
    processingTimeMs: number;
    confidence?: number;
    escalationReason?: string;
    vietnameseLanguage?: boolean;
  };
}

export interface HIPAAComplianceReport {
  period: {
    startDate: Date;
    endDate: Date;
  };
  totalInteractions: number;
  phiAccessEvents: number;
  emergencyEscalations: number;
  complianceViolations: number;
  agentPerformance: Array<{
    agentType: string;
    interactions: number;
    averageConfidence: number;
    escalationRate: number;
  }>;
  riskAssessment: {
    overallRisk: 'low' | 'medium' | 'high';
    riskFactors: string[];
    recommendations: string[];
  };
}

@Injectable()
export class HIPAAAuditService {
  private readonly logger = new Logger(HIPAAAuditService.name);
  private readonly RETENTION_YEARS = 7; // HIPAA requirement

  constructor(private readonly prisma: PrismaService) {}

  async logHealthcareInteraction(event: HIPAAAuditEvent): Promise<void> {
    try {
      // Create tamper-proof audit record
      const auditRecord = await this.prisma.hIPAAAuditLog.create({
        data: {
          eventType: event.eventType,
          userId: event.userId,
          agentType: event.agentType,
          queryHash: event.queryHash,
          responseHash: event.responseHash,
          severity: event.severity,
          containsPHI: event.containsPHI,
          emergencyFlag: event.emergencyFlag,
          complianceFlags: event.complianceFlags,
          sessionId: event.metadata.sessionId,
          ipAddress: event.metadata.ipAddress,
          userAgent: event.metadata.userAgent,
          processingTimeMs: event.metadata.processingTimeMs,
          confidence: event.metadata.confidence,
          escalationReason: event.metadata.escalationReason,
          vietnameseLanguage: event.metadata.vietnameseLanguage,
          timestamp: event.metadata.timestamp,
          createdAt: new Date(),
        },
      });

      // Log critical events immediately
      if (event.severity === 'critical' || event.emergencyFlag) {
        this.logger.warn(`CRITICAL HEALTHCARE EVENT: ${event.eventType}`, {
          auditId: auditRecord.id,
          userId: event.userId,
          agentType: event.agentType,
          severity: event.severity,
          emergencyFlag: event.emergencyFlag,
        });
      }

      // Check for compliance violations
      await this.checkComplianceViolations(event, auditRecord.id);
    } catch (error) {
      this.logger.error('Failed to log HIPAA audit event:', error);
      // Critical: Audit logging failure should be escalated
      throw new Error(`HIPAA audit logging failed: ${error.message}`);
    }
  }

  async generateComplianceReport(
    startDate: Date,
    endDate: Date,
  ): Promise<HIPAAComplianceReport> {
    try {
      const auditLogs = await this.prisma.hIPAAAuditLog.findMany({
        where: {
          timestamp: {
            gte: startDate,
            lte: endDate,
          },
        },
      });

      const totalInteractions = auditLogs.length;
      const phiAccessEvents = auditLogs.filter((log) => log.containsPHI).length;
      const emergencyEscalations = auditLogs.filter(
        (log) => log.emergencyFlag,
      ).length;
      const complianceViolations = auditLogs.filter(
        (log) => log.complianceFlags && log.complianceFlags.length > 0,
      ).length;

      // Calculate agent performance metrics
      const agentStats = new Map<
        string,
        {
          interactions: number;
          totalConfidence: number;
          escalations: number;
        }
      >();

      auditLogs.forEach((log) => {
        if (log.agentType) {
          const stats = agentStats.get(log.agentType) || {
            interactions: 0,
            totalConfidence: 0,
            escalations: 0,
          };

          stats.interactions++;
          stats.totalConfidence += log.confidence || 0;
          if (log.escalationReason) stats.escalations++;

          agentStats.set(log.agentType, stats);
        }
      });

      const agentPerformance = Array.from(agentStats.entries()).map(
        ([agentType, stats]) => ({
          agentType,
          interactions: stats.interactions,
          averageConfidence:
            stats.interactions > 0
              ? stats.totalConfidence / stats.interactions
              : 0,
          escalationRate:
            stats.interactions > 0 ? stats.escalations / stats.interactions : 0,
        }),
      );

      // Risk assessment
      const riskAssessment = this.assessComplianceRisk(auditLogs);

      return {
        period: { startDate, endDate },
        totalInteractions,
        phiAccessEvents,
        emergencyEscalations,
        complianceViolations,
        agentPerformance,
        riskAssessment,
      };
    } catch (error) {
      this.logger.error('Failed to generate compliance report:', error);
      throw new Error(`Compliance report generation failed: ${error.message}`);
    }
  }

  async getAuditTrail(
    userId: string,
    startDate?: Date,
    endDate?: Date,
  ): Promise<HIPAAAuditEvent[]> {
    try {
      const where: any = { userId };

      if (startDate || endDate) {
        where.timestamp = {};
        if (startDate) where.timestamp.gte = startDate;
        if (endDate) where.timestamp.lte = endDate;
      }

      const auditLogs = await this.prisma.hIPAAAuditLog.findMany({
        where,
        orderBy: { timestamp: 'desc' },
      });

      return auditLogs.map((log) => ({
        eventType: log.eventType as HIPAAAuditEvent['eventType'],
        userId: log.userId,
        agentType: log.agentType || undefined,
        queryHash: log.queryHash,
        responseHash: log.responseHash,
        severity: log.severity as HIPAAAuditEvent['severity'],
        containsPHI: log.containsPHI,
        emergencyFlag: log.emergencyFlag,
        complianceFlags: log.complianceFlags || [],
        metadata: {
          sessionId: log.sessionId || undefined,
          ipAddress: log.ipAddress || undefined,
          userAgent: log.userAgent || undefined,
          timestamp: log.timestamp,
          processingTimeMs: log.processingTimeMs,
          confidence: log.confidence || undefined,
          escalationReason: log.escalationReason || undefined,
          vietnameseLanguage: log.vietnameseLanguage || undefined,
        },
      }));
    } catch (error) {
      this.logger.error('Failed to retrieve audit trail:', error);
      throw new Error(`Audit trail retrieval failed: ${error.message}`);
    }
  }

  async cleanupExpiredAuditLogs(): Promise<number> {
    try {
      const retentionDate = new Date();
      retentionDate.setFullYear(
        retentionDate.getFullYear() - this.RETENTION_YEARS,
      );

      const result = await this.prisma.hIPAAAuditLog.deleteMany({
        where: {
          createdAt: {
            lt: retentionDate,
          },
        },
      });

      this.logger.log(
        `Cleaned up ${result.count} expired audit logs older than ${this.RETENTION_YEARS} years`,
      );
      return result.count;
    } catch (error) {
      this.logger.error('Failed to cleanup expired audit logs:', error);
      throw new Error(`Audit log cleanup failed: ${error.message}`);
    }
  }

  private async checkComplianceViolations(
    event: HIPAAAuditEvent,
    auditId: string,
  ): Promise<void> {
    const violations: string[] = [];

    // Check for potential PHI exposure
    if (event.containsPHI && !event.complianceFlags.includes('phi_protected')) {
      violations.push('Potential PHI exposure without protection');
    }

    // Check for emergency escalation compliance
    if (event.emergencyFlag && !event.metadata.escalationReason) {
      violations.push('Emergency escalation without documented reason');
    }

    // Check for low confidence responses with PHI
    if (
      event.containsPHI &&
      event.metadata.confidence &&
      event.metadata.confidence < 0.7
    ) {
      violations.push('Low confidence response involving PHI');
    }

    // Check for missing audit metadata
    if (!event.metadata.sessionId || !event.metadata.ipAddress) {
      violations.push('Incomplete audit metadata');
    }

    if (violations.length > 0) {
      this.logger.warn(
        `COMPLIANCE VIOLATIONS DETECTED: ${violations.join(', ')}`,
        {
          auditId,
          userId: event.userId,
          violations,
        },
      );

      // Update audit record with violations
      await this.prisma.hIPAAAuditLog.update({
        where: { id: auditId },
        data: {
          complianceFlags: [...event.complianceFlags, ...violations],
        },
      });
    }
  }

  private assessComplianceRisk(
    auditLogs: any[],
  ): HIPAAComplianceReport['riskAssessment'] {
    const riskFactors: string[] = [];
    let riskScore = 0;

    // High PHI access rate
    const phiRate =
      auditLogs.filter((log) => log.containsPHI).length / auditLogs.length;
    if (phiRate > 0.5) {
      riskFactors.push('High rate of PHI access');
      riskScore += 2;
    }

    // High emergency escalation rate
    const emergencyRate =
      auditLogs.filter((log) => log.emergencyFlag).length / auditLogs.length;
    if (emergencyRate > 0.1) {
      riskFactors.push('High emergency escalation rate');
      riskScore += 1;
    }

    // Compliance violations
    const violationRate =
      auditLogs.filter(
        (log) => log.complianceFlags && log.complianceFlags.length > 0,
      ).length / auditLogs.length;
    if (violationRate > 0.05) {
      riskFactors.push('Compliance violations detected');
      riskScore += 3;
    }

    // Low average confidence
    const avgConfidence =
      auditLogs.reduce((sum, log) => sum + (log.confidence || 0), 0) /
      auditLogs.length;
    if (avgConfidence < 0.7) {
      riskFactors.push('Low average agent confidence');
      riskScore += 1;
    }

    let overallRisk: 'low' | 'medium' | 'high' = 'low';
    if (riskScore >= 4) overallRisk = 'high';
    else if (riskScore >= 2) overallRisk = 'medium';

    const recommendations: string[] = [];
    if (phiRate > 0.5) recommendations.push('Review PHI protection protocols');
    if (emergencyRate > 0.1)
      recommendations.push('Enhance emergency detection accuracy');
    if (violationRate > 0.05)
      recommendations.push('Implement additional compliance training');
    if (avgConfidence < 0.7)
      recommendations.push('Improve agent training and knowledge base');

    return {
      overallRisk,
      riskFactors,
      recommendations,
    };
  }

  // Hash sensitive data for audit logging
  private hashSensitiveData(data: string): string {
    const crypto = require('crypto');
    return crypto.createHash('sha256').update(data).digest('hex');
  }
}
