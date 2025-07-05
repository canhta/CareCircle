import { Injectable, Logger, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { AuditService } from './audit.service';
import { getCurrentContext } from '../middleware/request-context.middleware';

export interface ConsentRecord {
  userId: string;
  consentType:
    | 'DATA_PROCESSING'
    | 'DATA_SHARING'
    | 'MARKETING'
    | 'ANALYTICS'
    | 'AI_PROCESSING';
  granted: boolean;
  timestamp: Date;
  version: string;
  ipAddress?: string;
  userAgent?: string;
}

export interface DataAccessRequest {
  userId: string;
  requestType: 'ACCESS' | 'EXPORT' | 'DELETE' | 'RECTIFICATION';
  status: 'PENDING' | 'APPROVED' | 'REJECTED' | 'COMPLETED';
  requestedBy: string;
  requestDate: Date;
  completedDate?: Date;
  details?: any;
}

@Injectable()
export class ComplianceService {
  private readonly logger = new Logger(ComplianceService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly auditService: AuditService,
  ) {}

  /**
   * Record user consent for data processing
   */
  async recordConsent(consent: ConsentRecord): Promise<void> {
    try {
      const context = getCurrentContext();

      await this.prisma.userConsent.create({
        data: {
          userId: consent.userId,
          consentType: consent.consentType,
          granted: consent.granted,
          version: consent.version,
          ipAddress: consent.ipAddress || context?.ip,
          userAgent: consent.userAgent || context?.userAgent,
          timestamp: consent.timestamp,
        },
      });

      await this.auditService.logSystemEvent({
        userId: consent.userId,
        action: 'CONSENT_RECORDED',
        resource: `consent/${consent.consentType}`,
        details: {
          granted: consent.granted,
          version: consent.version,
        },
        timestamp: new Date(),
      });

      this.logger.log(
        `Consent recorded: ${consent.consentType} - ${consent.granted ? 'GRANTED' : 'REVOKED'} for user ${consent.userId}`,
      );
    } catch (error) {
      this.logger.error('Failed to record consent', error.stack);
      throw error;
    }
  }

  /**
   * Check if user has granted specific consent
   */
  async hasConsent(
    userId: string,
    consentType: ConsentRecord['consentType'],
  ): Promise<boolean> {
    try {
      const latestConsent = await this.prisma.userConsent.findFirst({
        where: {
          userId,
          consentType,
        },
        orderBy: {
          timestamp: 'desc',
        },
      });

      return latestConsent?.granted || false;
    } catch (error) {
      this.logger.error('Failed to check consent', error.stack);
      return false;
    }
  }

  /**
   * Enforce consent before data processing
   */
  async enforceConsent(
    userId: string,
    consentType: ConsentRecord['consentType'],
  ): Promise<void> {
    const hasConsent = await this.hasConsent(userId, consentType);

    if (!hasConsent) {
      await this.auditService.logSecurityEvent({
        userId,
        action: 'CONSENT_VIOLATION',
        resource: `consent/${consentType}`,
        details: {
          consentType,
          hasConsent: false,
        },
        timestamp: new Date(),
        severity: 'HIGH',
        eventType: 'COMPLIANCE',
      });

      throw new ForbiddenException(
        `User has not granted consent for ${consentType}. Data processing is not allowed.`,
      );
    }
  }

  /**
   * Create data access request (GDPR Article 15, 17, 20)
   */
  async createDataAccessRequest(
    request: Omit<DataAccessRequest, 'status' | 'requestDate'>,
  ): Promise<string> {
    try {
      const dataRequest = await this.prisma.dataAccessRequest.create({
        data: {
          userId: request.userId,
          requestType: request.requestType,
          requestedBy: request.requestedBy,
          status: 'PENDING',
          requestDate: new Date(),
          details: request.details,
        },
      });

      await this.auditService.logSystemEvent({
        userId: request.userId,
        action: 'DATA_ACCESS_REQUEST_CREATED',
        resource: `data-request/${dataRequest.id}`,
        details: {
          requestType: request.requestType,
          requestedBy: request.requestedBy,
        },
        timestamp: new Date(),
      });

      this.logger.log(
        `Data access request created: ${request.requestType} for user ${request.userId}`,
      );

      return dataRequest.id;
    } catch (error) {
      this.logger.error('Failed to create data access request', error.stack);
      throw error;
    }
  }

  /**
   * Process data deletion request (Right to be forgotten)
   */
  async processDataDeletion(userId: string, requestId: string): Promise<void> {
    try {
      // Start transaction for data deletion
      await this.prisma.$transaction(async (tx) => {
        // Anonymize or delete user data based on retention policies
        await this.anonymizeUserData(userId, tx);

        // Update request status
        await tx.dataAccessRequest.update({
          where: { id: requestId },
          data: {
            status: 'COMPLETED',
            completedDate: new Date(),
          },
        });
      });

      await this.auditService.logSystemEvent({
        userId,
        action: 'DATA_DELETION_COMPLETED',
        resource: `data-request/${requestId}`,
        details: {
          requestType: 'DELETE',
        },
        timestamp: new Date(),
      });

      this.logger.log(`Data deletion completed for user ${userId}`);
    } catch (error) {
      this.logger.error('Failed to process data deletion', error.stack);
      throw error;
    }
  }

  /**
   * Export user data (GDPR Article 20)
   */
  async exportUserData(userId: string): Promise<any> {
    try {
      const userData = await this.prisma.user.findUnique({
        where: { id: userId },
        include: {
          healthRecords: true,
          prescriptions: true,
          checkIns: true,
          careGroupMembers: {
            include: {
              careGroup: true,
            },
          },
          notifications: true,
          subscriptions: true,
        },
      });

      if (!userData) {
        throw new Error('User not found');
      }

      // Remove sensitive internal fields
      const exportData = {
        ...userData,
        password: undefined,
        refreshToken: undefined,
        mfaSecret: undefined,
      };

      await this.auditService.logPHIAccess({
        userId,
        action: 'DATA_EXPORT',
        resource: 'user/export',
        details: {
          exportType: 'FULL_EXPORT',
        },
        timestamp: new Date(),
      });

      return exportData;
    } catch (error) {
      this.logger.error('Failed to export user data', error.stack);
      throw error;
    }
  }

  /**
   * Check data retention compliance
   */
  async checkDataRetention(): Promise<void> {
    try {
      const retentionPeriod = 7 * 365 * 24 * 60 * 60 * 1000; // 7 years in milliseconds
      const cutoffDate = new Date(Date.now() - retentionPeriod);

      // Find old data that should be archived or deleted
      const oldRecords = await this.prisma.healthRecord.findMany({
        where: {
          createdAt: {
            lt: cutoffDate,
          },
        },
        select: {
          id: true,
          userId: true,
          createdAt: true,
        },
      });

      for (const record of oldRecords) {
        await this.auditService.logSystemEvent({
          userId: record.userId,
          action: 'DATA_RETENTION_CHECK',
          resource: `health-record/${record.id}`,
          details: {
            recordAge: Date.now() - record.createdAt.getTime(),
            retentionPeriod,
          },
          timestamp: new Date(),
        });
      }

      this.logger.log(
        `Data retention check completed. Found ${oldRecords.length} old records.`,
      );
    } catch (error) {
      this.logger.error('Failed to check data retention', error.stack);
    }
  }

  private async anonymizeUserData(userId: string, tx: any): Promise<void> {
    // Anonymize personal identifiers while keeping statistical data
    await tx.user.update({
      where: { id: userId },
      data: {
        email: `anonymized-${userId}@deleted.local`,
        firstName: 'Deleted',
        lastName: 'User',
        phoneNumber: null,
        dateOfBirth: null,
        address: null,
        emergencyContact: null,
        isActive: false,
        deletedAt: new Date(),
      },
    });

    // Anonymize health records
    await tx.healthRecord.updateMany({
      where: { userId },
      data: {
        notes: 'Data anonymized per user request',
        metadata: {},
      },
    });

    // Delete sensitive prescription data
    await tx.prescription.deleteMany({
      where: { userId },
    });
  }
}
