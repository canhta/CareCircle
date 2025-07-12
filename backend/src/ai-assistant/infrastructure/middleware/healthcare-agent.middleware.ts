import { Injectable, NestMiddleware, Logger } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import {
  HIPAAAuditService,
  HIPAAAuditEvent,
} from '../../../common/compliance/hipaa-audit.service';
import { PHIProtectionService } from '../../../common/compliance/phi-protection.service';
import { VietnameseNLPIntegrationService } from '../services/vietnamese-nlp-integration.service';
import * as crypto from 'crypto';

export interface HealthcareRequest extends Request {
  healthcareContext?: {
    userId: string;
    sessionId: string;
    agentType?: string;
    startTime: number;
    ipAddress: string;
    userAgent: string;
    containsPHI?: boolean;
    vietnameseLanguage?: boolean;
    emergencyFlag?: boolean;
    complianceFlags?: string[];
  };
}

@Injectable()
export class HealthcareAgentMiddleware implements NestMiddleware {
  private readonly logger = new Logger(HealthcareAgentMiddleware.name);

  constructor(
    private readonly hipaaAuditService: HIPAAAuditService,
    private readonly phiProtectionService: PHIProtectionService,
    private readonly vietnameseNLPService: VietnameseNLPIntegrationService,
  ) {}

  async use(req: HealthcareRequest, res: Response, next: NextFunction) {
    const startTime = Date.now();

    try {
      // Initialize healthcare context
      req.healthcareContext = {
        userId: this.extractUserId(req),
        sessionId: this.extractSessionId(req),
        startTime,
        ipAddress: this.getClientIP(req),
        userAgent: req.get('User-Agent') || 'unknown',
        complianceFlags: [],
      };

      // Pre-process request for healthcare compliance
      await this.preprocessHealthcareRequest(req);

      // Set up response interceptor for audit logging
      this.setupResponseInterceptor(req, res);

      next();
    } catch (error) {
      this.logger.error('Healthcare middleware error:', error);

      // Log the error but don't block the request
      await this.logHealthcareError(req, error);
      next();
    }
  }

  private async preprocessHealthcareRequest(
    req: HealthcareRequest,
  ): Promise<void> {
    const body = req.body;

    if (!body || !body.query) {
      return;
    }

    const query = body.query as string;

    try {
      // 1. PHI Detection
      const phiResult = await this.phiProtectionService.detectAndMaskPHI(query);
      if (phiResult.detectedPHI.length > 0) {
        req.healthcareContext!.containsPHI = true;
        req.healthcareContext!.complianceFlags!.push('phi_detected');
        this.logger.warn('PHI detected in healthcare request', {
          userId: req.healthcareContext!.userId,
          sessionId: req.healthcareContext!.sessionId,
        });
      }

      // 2. Vietnamese Language Detection
      const nlpAnalysis =
        await this.vietnameseNLPService.analyzeHealthcareText(query);
      if (nlpAnalysis.languageMetrics.isVietnamese) {
        req.healthcareContext!.vietnameseLanguage = true;
      }

      // 3. Emergency Detection
      const emergencyContext =
        await this.vietnameseNLPService.detectEmergencyContext(query);
      if (emergencyContext.isEmergency) {
        req.healthcareContext!.emergencyFlag = true;
        req.healthcareContext!.complianceFlags!.push('emergency_detected');
        this.logger.warn('Emergency situation detected', {
          userId: req.healthcareContext!.userId,
          urgencyLevel: emergencyContext.urgencyLevel,
          keywords: emergencyContext.emergencyKeywords,
        });
      }

      // 4. Agent Type Detection
      req.healthcareContext!.agentType = this.detectAgentType(req.path);
    } catch (error) {
      this.logger.error('Healthcare preprocessing failed:', error);
      req.healthcareContext!.complianceFlags!.push('preprocessing_error');
    }
  }

  private setupResponseInterceptor(
    req: HealthcareRequest,
    res: Response,
  ): void {
    const originalSend = res.send;
    const originalJson = res.json;

    // Intercept res.send()
    res.send = function (body: any) {
      handleResponse.call(this, body);
      return originalSend.call(this, body);
    };

    // Intercept res.json()
    res.json = function (body: any) {
      handleResponse.call(this, body);
      return originalJson.call(this, body);
    };

    const self = this;
    async function handleResponse(responseBody: any) {
      try {
        await self.logHealthcareInteraction(req, res, responseBody);
      } catch (error) {
        self.logger.error('Failed to log healthcare interaction:', error);
      }
    }
  }

  private async logHealthcareInteraction(
    req: HealthcareRequest,
    res: Response,
    responseBody: any,
  ): Promise<void> {
    const context = req.healthcareContext!;
    const processingTime = Date.now() - context.startTime;

    try {
      // Extract query and response for hashing
      const query = req.body?.query || '';
      const response =
        typeof responseBody === 'string'
          ? responseBody
          : JSON.stringify(responseBody);

      // Determine severity based on context
      let severity: HIPAAAuditEvent['severity'] = 'low';
      if (context.emergencyFlag) severity = 'critical';
      else if (context.containsPHI) severity = 'high';
      else if (res.statusCode >= 400) severity = 'medium';

      // Determine event type
      let eventType: HIPAAAuditEvent['eventType'] = 'healthcare_query';
      if (context.emergencyFlag) eventType = 'emergency_escalation';
      else if (context.agentType === 'medication_management')
        eventType = 'medication_analysis';
      else if (context.containsPHI) eventType = 'phi_access';

      // Create audit event
      const auditEvent: HIPAAAuditEvent = {
        eventType,
        userId: context.userId,
        agentType: context.agentType,
        queryHash: this.hashSensitiveData(query),
        responseHash: this.hashSensitiveData(response),
        severity,
        containsPHI: context.containsPHI || false,
        emergencyFlag: context.emergencyFlag || false,
        complianceFlags: context.complianceFlags || [],
        metadata: {
          sessionId: context.sessionId,
          ipAddress: context.ipAddress,
          userAgent: context.userAgent,
          timestamp: new Date(),
          processingTimeMs: processingTime,
          confidence: this.extractConfidence(responseBody),
          escalationReason: context.emergencyFlag
            ? 'Emergency detected'
            : undefined,
          vietnameseLanguage: context.vietnameseLanguage,
        },
      };

      // Log to HIPAA audit system
      await this.hipaaAuditService.logHealthcareInteraction(auditEvent);

      // Additional logging for high-severity events
      if (severity === 'critical' || severity === 'high') {
        this.logger.warn(`High-severity healthcare interaction logged`, {
          eventType,
          severity,
          userId: context.userId,
          agentType: context.agentType,
          processingTime,
        });
      }
    } catch (error) {
      this.logger.error('HIPAA audit logging failed:', error);
      // This is critical - audit logging failure should be escalated
      throw new Error(`HIPAA audit logging failed: ${error.message}`);
    }
  }

  private async logHealthcareError(
    req: HealthcareRequest,
    error: any,
  ): Promise<void> {
    try {
      const context = req.healthcareContext!;

      const auditEvent: HIPAAAuditEvent = {
        eventType: 'healthcare_query',
        userId: context.userId,
        agentType: context.agentType,
        queryHash: this.hashSensitiveData(req.body?.query || ''),
        responseHash: this.hashSensitiveData(`Error: ${error.message}`),
        severity: 'high',
        containsPHI: context.containsPHI || false,
        emergencyFlag: context.emergencyFlag || false,
        complianceFlags: [
          ...(context.complianceFlags || []),
          'middleware_error',
        ],
        metadata: {
          sessionId: context.sessionId,
          ipAddress: context.ipAddress,
          userAgent: context.userAgent,
          timestamp: new Date(),
          processingTimeMs: Date.now() - context.startTime,
          vietnameseLanguage: context.vietnameseLanguage,
        },
      };

      await this.hipaaAuditService.logHealthcareInteraction(auditEvent);
    } catch (auditError) {
      this.logger.error(
        'Failed to log healthcare error to audit system:',
        auditError,
      );
    }
  }

  private extractUserId(req: Request): string {
    // Extract user ID from JWT token, session, or request headers
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
      try {
        // In a real implementation, you would decode the JWT token
        // For now, return a placeholder
        return (req.headers['x-user-id'] as string) || 'anonymous';
      } catch (error) {
        this.logger.warn('Failed to extract user ID from token');
      }
    }

    return (req.headers['x-user-id'] as string) || 'anonymous';
  }

  private extractSessionId(req: Request): string {
    return (
      (req.headers['x-session-id'] as string) ||
      (req as any).sessionID ||
      `session_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
    );
  }

  private getClientIP(req: Request): string {
    return (
      (req.headers['x-forwarded-for'] as string)?.split(',')[0] ||
      (req.headers['x-real-ip'] as string) ||
      req.connection.remoteAddress ||
      req.socket.remoteAddress ||
      'unknown'
    );
  }

  private detectAgentType(path: string): string {
    if (path.includes('/vietnamese-healthcare')) return 'vietnamese_medical';
    if (path.includes('/medication')) return 'medication_management';
    if (path.includes('/emergency')) return 'emergency_triage';
    if (path.includes('/clinical')) return 'clinical_decision_support';
    if (path.includes('/chat')) return 'healthcare_supervisor';
    return 'general';
  }

  private extractConfidence(responseBody: any): number | undefined {
    if (typeof responseBody === 'object' && responseBody.confidence) {
      return responseBody.confidence;
    }
    if (typeof responseBody === 'object' && responseBody.metadata?.confidence) {
      return responseBody.metadata.confidence;
    }
    return undefined;
  }

  private hashSensitiveData(data: string): string {
    return crypto.createHash('sha256').update(data).digest('hex');
  }
}

// Rate limiting middleware for healthcare agents
@Injectable()
export class HealthcareRateLimitMiddleware implements NestMiddleware {
  private readonly logger = new Logger(HealthcareRateLimitMiddleware.name);
  private readonly requestCounts = new Map<
    string,
    { count: number; resetTime: number }
  >();
  private readonly RATE_LIMIT = 100; // requests per hour
  private readonly WINDOW_MS = 60 * 60 * 1000; // 1 hour

  use(req: Request, res: Response, next: NextFunction) {
    const clientId = this.getClientIdentifier(req);
    const now = Date.now();

    // Clean up expired entries
    this.cleanupExpiredEntries(now);

    // Get or create rate limit entry
    let entry = this.requestCounts.get(clientId);
    if (!entry || now > entry.resetTime) {
      entry = { count: 0, resetTime: now + this.WINDOW_MS };
      this.requestCounts.set(clientId, entry);
    }

    // Check rate limit
    if (entry.count >= this.RATE_LIMIT) {
      this.logger.warn(`Rate limit exceeded for client: ${clientId}`);
      return res.status(429).json({
        error: 'Rate limit exceeded',
        message: 'Too many healthcare requests. Please try again later.',
        retryAfter: Math.ceil((entry.resetTime - now) / 1000),
      });
    }

    // Increment counter
    entry.count++;

    // Add rate limit headers
    res.set({
      'X-RateLimit-Limit': this.RATE_LIMIT.toString(),
      'X-RateLimit-Remaining': (this.RATE_LIMIT - entry.count).toString(),
      'X-RateLimit-Reset': new Date(entry.resetTime).toISOString(),
    });

    next();
  }

  private getClientIdentifier(req: Request): string {
    // Use user ID if available, otherwise fall back to IP
    const userId = req.headers['x-user-id'] as string;
    if (userId) return `user:${userId}`;

    const ip =
      (req.headers['x-forwarded-for'] as string) ||
      req.connection.remoteAddress;
    return `ip:${ip}`;
  }

  private cleanupExpiredEntries(now: number): void {
    for (const [key, entry] of this.requestCounts.entries()) {
      if (now > entry.resetTime) {
        this.requestCounts.delete(key);
      }
    }
  }
}
