import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Logger,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AuditService } from '../services/audit.service';
import { ComplianceService } from '../services/compliance.service';
import {
  PHI_ACCESS_KEY,
  PHIAccessMetadata,
  PHIDataType,
} from '../decorators/phi-access.decorator';
import {
  RequestIPData,
  PHIAccessAuditData,
} from '../interfaces/guards.interfaces';
import { SecurityEventType } from '../interfaces/exception.interfaces';

@Injectable()
export class PHIAccessGuard implements CanActivate {
  private readonly logger = new Logger(PHIAccessGuard.name);

  constructor(
    private readonly reflector: Reflector,
    private readonly auditService: AuditService,
    private readonly complianceService: ComplianceService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    // Get PHI access metadata from the route
    const phiMetadata = this.reflector.get<PHIAccessMetadata>(
      PHI_ACCESS_KEY,
      context.getHandler(),
    );

    // If no PHI metadata, allow access (not a PHI endpoint)
    if (!phiMetadata) {
      return true;
    }

    const request = context.switchToHttp().getRequest<RequestIPData>();
    const user = request.user;

    if (!user) {
      throw new ForbiddenException('Authentication required for PHI access');
    }

    const userId = user.id || user.sub;
    const correlationId = request.correlationId || 'unknown';

    try {
      // Check consent requirements
      if (phiMetadata.requiresConsent) {
        await this.checkConsent(userId, phiMetadata);
      }

      // Audit PHI access attempt
      if (phiMetadata.auditRequired) {
        await this.auditPHIAccess(request, phiMetadata, userId, correlationId);
      }

      // Check rate limiting for PHI access
      await this.checkPHIRateLimit(userId, phiMetadata);

      return true;
    } catch (error) {
      const err = error instanceof Error ? error : new Error(String(error));
      this.logger.error(
        `PHI access denied for user ${userId}: ${err.message}`,
        err.stack,
        correlationId,
      );

      // Audit the access denial
      await this.auditService.logSecurityEvent({
        userId,
        action: 'PHI_ACCESS_DENIED',
        resource: `${request.method} ${request.url}`,
        details: {
          reason: err.message,
          phiMetadata,
        },
        timestamp: new Date(),
        severity: 'HIGH',
        eventType: 'DATA_ACCESS' as SecurityEventType,
      });

      throw error;
    }
  }

  private async checkConsent(
    userId: string,
    metadata: PHIAccessMetadata,
  ): Promise<void> {
    // Check different consent types based on PHI data types
    const consentChecks: Promise<void>[] = [];

    if (metadata.dataTypes.includes(PHIDataType.HEALTH_RECORD)) {
      consentChecks.push(
        this.complianceService.enforceConsent(userId, 'DATA_PROCESSING'),
      );
    }

    if (metadata.dataTypes.includes(PHIDataType.PRESCRIPTION)) {
      consentChecks.push(
        this.complianceService.enforceConsent(userId, 'DATA_PROCESSING'),
      );
    }

    if (metadata.level === 'EXPORT') {
      consentChecks.push(
        this.complianceService.enforceConsent(userId, 'DATA_SHARING'),
      );
    }

    // Wait for all consent checks to complete
    await Promise.all(consentChecks);
  }

  private async auditPHIAccess(
    request: RequestIPData,
    metadata: PHIAccessMetadata,
    userId: string,
    correlationId: string,
  ): Promise<void> {
    const auditData: PHIAccessAuditData = {
      userId,
      action: `PHI_${metadata.level}`,
      resource: `${request.method} ${request.url}`,
      details: {
        purpose: metadata.purpose,
        dataTypes: metadata.dataTypes,
        level: metadata.level,
      },
      ip: request.ip,
      userAgent: request.get('User-Agent'),
      correlationId,
      timestamp: new Date(),
    };

    try {
      await this.auditService.logPHIAccess(auditData);
    } catch (error) {
      const err = error instanceof Error ? error : new Error(String(error));
      this.logger.error(
        `Failed to audit PHI access: ${err.message}`,
        err.stack,
      );
    }
  }

  private async checkPHIRateLimit(
    userId: string,
    metadata: PHIAccessMetadata,
  ): Promise<void> {
    // Implement rate limiting for PHI access based on access level
    const rateLimits = {
      READ: { requests: 100, window: 3600 }, // 100 reads per hour
      WRITE: { requests: 50, window: 3600 }, // 50 writes per hour
      DELETE: { requests: 10, window: 3600 }, // 10 deletes per hour
      EXPORT: { requests: 5, window: 86400 }, // 5 exports per day
    };

    const limit = rateLimits[metadata.level];
    if (!limit) return;

    // Check rate limit (this would typically use Redis or similar)
    const key = `phi_rate_limit:${userId}:${metadata.level}`;
    const windowStart = new Date(Date.now() - limit.window * 1000);

    // Count recent PHI access attempts
    const recentAccess = await this.auditService.getAuditLogs({
      userId,
      action: `PHI_${metadata.level}`,
      startDate: windowStart,
      endDate: new Date(),
    });

    if (recentAccess.total >= limit.requests) {
      throw new ForbiddenException(
        `PHI access rate limit exceeded. Maximum ${limit.requests} ${metadata.level} operations per ${limit.window / 3600} hours.`,
      );
    }
  }
}
