import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { getCurrentContext } from '../middleware/request-context.middleware';

export interface AuditLogEntry {
  userId?: string;
  action: string;
  resource: string;
  details?: any;
  timestamp: Date;
  ip?: string;
  userAgent?: string;
  correlationId?: string;
}

export interface PHIAccessLog extends AuditLogEntry {
  statusCode?: number;
  duration?: number;
}

export interface SecurityEvent extends AuditLogEntry {
  severity: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
  eventType:
    | 'AUTHENTICATION'
    | 'AUTHORIZATION'
    | 'DATA_ACCESS'
    | 'SYSTEM'
    | 'COMPLIANCE';
}

@Injectable()
export class AuditService {
  private readonly logger = new Logger(AuditService.name);

  constructor(private readonly prisma: PrismaService) {}

  async logPHIAccess(entry: PHIAccessLog): Promise<void> {
    try {
      const context = getCurrentContext();

      await this.prisma.auditLog.create({
        data: {
          userId: entry.userId || context?.userId,
          action: entry.action,
          resource: entry.resource,
          details: {
            ...entry.details,
            statusCode: entry.statusCode,
            duration: entry.duration,
            type: 'PHI_ACCESS',
          },
          ip: entry.ip || context?.ip,
          userAgent: entry.userAgent || context?.userAgent,
          correlationId: entry.correlationId || context?.correlationId,
          timestamp: entry.timestamp,
        },
      });

      this.logger.log(
        `PHI Access: ${entry.action} ${entry.resource} by user ${entry.userId}`,
        entry.correlationId,
      );
    } catch (error) {
      this.logger.error('Failed to log PHI access', error.stack);
      // Don't throw error to avoid breaking the main request
    }
  }

  async logSecurityEvent(event: SecurityEvent): Promise<void> {
    try {
      const context = getCurrentContext();

      await this.prisma.auditLog.create({
        data: {
          userId: event.userId || context?.userId,
          action: event.action,
          resource: event.resource,
          details: {
            ...event.details,
            severity: event.severity,
            eventType: event.eventType,
            type: 'SECURITY_EVENT',
          },
          ip: event.ip || context?.ip,
          userAgent: event.userAgent || context?.userAgent,
          correlationId: event.correlationId || context?.correlationId,
          timestamp: event.timestamp,
        },
      });

      // Log high severity events immediately
      if (['HIGH', 'CRITICAL'].includes(event.severity)) {
        this.logger.error(
          `Security Event [${event.severity}]: ${event.action} - ${event.resource}`,
          JSON.stringify(event.details),
          event.correlationId,
        );
      } else {
        this.logger.warn(
          `Security Event [${event.severity}]: ${event.action} - ${event.resource}`,
          event.correlationId,
        );
      }
    } catch (error) {
      this.logger.error('Failed to log security event', error.stack);
    }
  }

  async logDataAccess(entry: AuditLogEntry): Promise<void> {
    try {
      const context = getCurrentContext();

      await this.prisma.auditLog.create({
        data: {
          userId: entry.userId || context?.userId,
          action: entry.action,
          resource: entry.resource,
          details: {
            ...entry.details,
            type: 'DATA_ACCESS',
          },
          ip: entry.ip || context?.ip,
          userAgent: entry.userAgent || context?.userAgent,
          correlationId: entry.correlationId || context?.correlationId,
          timestamp: entry.timestamp,
        },
      });
    } catch (error) {
      this.logger.error('Failed to log data access', error.stack);
    }
  }

  async logSystemEvent(entry: AuditLogEntry): Promise<void> {
    try {
      const context = getCurrentContext();

      await this.prisma.auditLog.create({
        data: {
          userId: entry.userId || context?.userId,
          action: entry.action,
          resource: entry.resource,
          details: {
            ...entry.details,
            type: 'SYSTEM_EVENT',
          },
          ip: entry.ip || context?.ip,
          userAgent: entry.userAgent || context?.userAgent,
          correlationId: entry.correlationId || context?.correlationId,
          timestamp: entry.timestamp,
        },
      });
    } catch (error) {
      this.logger.error('Failed to log system event', error.stack);
    }
  }

  async getAuditLogs(filters: {
    userId?: string;
    action?: string;
    resource?: string;
    startDate?: Date;
    endDate?: Date;
    limit?: number;
    offset?: number;
  }) {
    try {
      const where: any = {};

      if (filters.userId) where.userId = filters.userId;
      if (filters.action)
        where.action = { contains: filters.action, mode: 'insensitive' };
      if (filters.resource)
        where.resource = { contains: filters.resource, mode: 'insensitive' };
      if (filters.startDate || filters.endDate) {
        where.timestamp = {};
        if (filters.startDate) where.timestamp.gte = filters.startDate;
        if (filters.endDate) where.timestamp.lte = filters.endDate;
      }

      const [logs, total] = await Promise.all([
        this.prisma.auditLog.findMany({
          where,
          orderBy: { timestamp: 'desc' },
          take: filters.limit || 100,
          skip: filters.offset || 0,
          include: {
            user: {
              select: {
                id: true,
                email: true,
                firstName: true,
                lastName: true,
              },
            },
          },
        }),
        this.prisma.auditLog.count({ where }),
      ]);

      return { logs, total };
    } catch (error) {
      this.logger.error('Failed to retrieve audit logs', error.stack);
      throw error;
    }
  }
}
