import { Injectable, Logger } from '@nestjs/common';
import { NotificationType, NotificationChannel } from '@prisma/client';

export interface PHIData {
  type:
    | 'name'
    | 'ssn'
    | 'email'
    | 'phone'
    | 'address'
    | 'medical_record'
    | 'insurance'
    | 'other';
  value: string;
  context: string;
  location: 'subject' | 'message' | 'metadata';
}

export interface ComplianceAuditLog {
  id: string;
  timestamp: Date;
  action: 'sanitize' | 'encrypt' | 'access' | 'transmit' | 'store';
  notificationId: string;
  userId: string;
  phiDetected: PHIData[];
  sanitizationApplied: boolean;
  encryptionApplied: boolean;
  accessLevel: 'read' | 'write' | 'admin';
  ipAddress?: string;
  userAgent?: string;
  metadata: Record<string, any>;
}

export interface SanitizationResult {
  originalContent: string;
  sanitizedContent: string;
  phiDetected: PHIData[];
  sanitizationApplied: boolean;
  complianceLevel: 'full' | 'partial' | 'none';
  warnings: string[];
}

export interface ConsentRecord {
  userId: string;
  consentType:
    | 'notification_delivery'
    | 'data_processing'
    | 'third_party_sharing';
  granted: boolean;
  grantedAt: Date;
  expiresAt?: Date;
  scope: string[];
  metadata: Record<string, any>;
}

export interface EncryptionConfig {
  algorithm: 'AES-256-GCM' | 'AES-256-CBC';
  keyRotationDays: number;
  encryptInTransit: boolean;
  encryptAtRest: boolean;
}

@Injectable()
export class HIPAAComplianceService {
  private readonly logger = new Logger(HIPAAComplianceService.name);

  // PHI detection patterns
  private readonly phiPatterns = {
    ssn: /\b\d{3}-?\d{2}-?\d{4}\b/g,
    phone:
      /\b(?:\+?1[-.\s]?)?\(?([0-9]{3})\)?[-.\s]?([0-9]{3})[-.\s]?([0-9]{4})\b/g,
    email: /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/g,
    creditCard: /\b\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}\b/g,
    medicalRecord:
      /\b(?:MRN|MR|Medical Record|Patient ID)[\s:]*([A-Z0-9]{6,})\b/gi,
    insurance: /\b(?:Insurance|Policy|Member)[\s#:]*([A-Z0-9]{8,})\b/gi,
    dob: /\b(?:DOB|Date of Birth|Born)[\s:]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})\b/gi,
  };

  private readonly encryptionConfig: EncryptionConfig = {
    algorithm: 'AES-256-GCM',
    keyRotationDays: 90,
    encryptInTransit: true,
    encryptAtRest: true,
  };

  /**
   * Sanitize notification content for HIPAA compliance
   */
  sanitizeNotificationContent(
    notificationId: string,
    userId: string,
    subject: string,
    message: string,
    metadata?: Record<string, any>,
  ): {
    subject: SanitizationResult;
    message: SanitizationResult;
    metadata: SanitizationResult;
  } {
    this.logger.log(
      `Sanitizing notification content for notification ${notificationId}`,
    );

    const subjectResult = this.sanitizeText(subject, 'subject');
    const messageResult = this.sanitizeText(message, 'message');
    const metadataResult = this.sanitizeMetadata(metadata || {});

    // Log compliance audit
    this.logComplianceAudit({
      action: 'sanitize',
      notificationId,
      userId,
      phiDetected: [
        ...subjectResult.phiDetected,
        ...messageResult.phiDetected,
        ...metadataResult.phiDetected,
      ],
      sanitizationApplied:
        subjectResult.sanitizationApplied ||
        messageResult.sanitizationApplied ||
        metadataResult.sanitizationApplied,
      encryptionApplied: false,
      accessLevel: 'write',
      metadata: {
        subjectCompliance: subjectResult.complianceLevel,
        messageCompliance: messageResult.complianceLevel,
        metadataCompliance: metadataResult.complianceLevel,
      },
    });

    return {
      subject: subjectResult,
      message: messageResult,
      metadata: metadataResult,
    };
  }

  /**
   * Validate notification for HIPAA compliance
   */
  validateNotificationCompliance(
    notificationId: string,
    type: NotificationType,
    channel: NotificationChannel,
    content: {
      subject: string;
      message: string;
      metadata?: Record<string, any>;
    },
  ): {
    isCompliant: boolean;
    violations: string[];
    recommendations: string[];
    riskLevel: 'low' | 'medium' | 'high' | 'critical';
  } {
    const violations: string[] = [];
    const recommendations: string[] = [];
    let riskLevel: 'low' | 'medium' | 'high' | 'critical' = 'low';

    // Check for PHI in content
    const allContent = `${content.subject} ${content.message} ${JSON.stringify(content.metadata || {})}`;
    const phiDetected = this.detectPHI(allContent);

    if (phiDetected.length > 0) {
      violations.push(
        `PHI detected in notification content: ${phiDetected.map((p) => p.type).join(', ')}`,
      );
      riskLevel = 'high';
      recommendations.push('Apply PHI sanitization before delivery');
    }

    // Check channel-specific compliance
    if (channel === NotificationChannel.EMAIL) {
      if (
        phiDetected.some((p) => p.type === 'ssn' || p.type === 'medical_record')
      ) {
        violations.push(
          'SSN or medical record numbers should not be sent via email',
        );
        riskLevel = 'critical';
      }
      recommendations.push(
        'Consider using secure messaging portal for sensitive information',
      );
    }

    if (channel === NotificationChannel.SMS) {
      if (phiDetected.length > 0) {
        violations.push('PHI should not be sent via SMS');
        riskLevel = 'critical';
      }
      recommendations.push(
        'Use SMS only for appointment reminders without PHI',
      );
    }

    // Check emergency alert compliance
    if (type === NotificationType.EMERGENCY_ALERT) {
      if (!content.message.toLowerCase().includes('emergency')) {
        violations.push(
          'Emergency alerts must clearly indicate emergency status',
        );
        riskLevel = 'medium';
      }
    }

    // Check medication reminder compliance
    if (type === NotificationType.MEDICATION_REMINDER) {
      if (
        content.message.includes('prescription') &&
        phiDetected.length === 0
      ) {
        recommendations.push(
          'Consider using generic medication reminders to avoid PHI exposure',
        );
      }
    }

    return {
      isCompliant: violations.length === 0,
      violations,
      recommendations,
      riskLevel,
    };
  }

  /**
   * Check user consent for notification delivery
   */
  checkUserConsent(
    userId: string,
    notificationType: NotificationType,
    channel: NotificationChannel,
  ): {
    hasConsent: boolean;
    consentRecord?: ConsentRecord;
    expiresAt?: Date;
    requiresRenewal: boolean;
  } {
    // In a real implementation, this would query the consent database
    // For now, return mock consent data

    const mockConsent: ConsentRecord = {
      userId,
      consentType: 'notification_delivery',
      granted: true,
      grantedAt: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // 30 days ago
      expiresAt: new Date(Date.now() + 335 * 24 * 60 * 60 * 1000), // 335 days from now
      scope: [notificationType, channel],
      metadata: {
        ipAddress: '192.168.1.1',
        userAgent: 'CareCircle Mobile App',
      },
    };

    const requiresRenewal = mockConsent.expiresAt
      ? mockConsent.expiresAt.getTime() - Date.now() < 30 * 24 * 60 * 60 * 1000 // 30 days before expiry
      : false;

    return {
      hasConsent: mockConsent.granted,
      consentRecord: mockConsent,
      expiresAt: mockConsent.expiresAt,
      requiresRenewal,
    };
  }

  /**
   * Encrypt sensitive notification data
   */
  encryptSensitiveData(
    data: string,
    context: string = 'notification',
  ): {
    encryptedData: string;
    keyId: string;
    algorithm: string;
    timestamp: Date;
  } {
    // In a real implementation, this would use proper encryption
    // For now, return mock encrypted data

    const keyId = `key_${Date.now()}`;
    const encryptedData = Buffer.from(data).toString('base64'); // Mock encryption

    this.logger.log(`Encrypted data for context: ${context}`);

    return {
      encryptedData,
      keyId,
      algorithm: this.encryptionConfig.algorithm,
      timestamp: new Date(),
    };
  }

  /**
   * Create audit trail for notification access
   */
  createAccessAuditTrail(
    notificationId: string,
    userId: string,
    accessType: 'view' | 'deliver' | 'modify' | 'delete',
    ipAddress?: string,
    userAgent?: string,
  ): void {
    this.logComplianceAudit({
      action: 'access',
      notificationId,
      userId,
      phiDetected: [],
      sanitizationApplied: false,
      encryptionApplied: false,
      accessLevel: accessType === 'view' ? 'read' : 'write',
      ipAddress,
      userAgent,
      metadata: {
        accessType,
        timestamp: new Date().toISOString(),
      },
    });
  }

  /**
   * Generate compliance report
   */
  generateComplianceReport(
    _startDate: Date,
    _endDate: Date,
    _userId?: string,
  ): {
    totalNotifications: number;
    phiDetectionCount: number;
    sanitizationRate: number;
    encryptionRate: number;
    complianceViolations: number;
    auditTrailEntries: number;
    riskAssessment: {
      low: number;
      medium: number;
      high: number;
      critical: number;
    };
  } {
    // In a real implementation, this would query audit logs
    // For now, return mock report data

    return {
      totalNotifications: 1250,
      phiDetectionCount: 45,
      sanitizationRate: 0.98,
      encryptionRate: 1.0,
      complianceViolations: 2,
      auditTrailEntries: 3750,
      riskAssessment: {
        low: 1200,
        medium: 35,
        high: 13,
        critical: 2,
      },
    };
  }

  /**
   * Sanitize text content
   */
  private sanitizeText(
    text: string,
    location: 'subject' | 'message',
  ): SanitizationResult {
    let sanitizedContent = text;
    const phiDetected: PHIData[] = [];
    let sanitizationApplied = false;
    const warnings: string[] = [];

    // Detect and sanitize PHI
    for (const [type, pattern] of Object.entries(this.phiPatterns)) {
      const matches = text.match(pattern);
      if (matches) {
        for (const match of matches) {
          phiDetected.push({
            type: type as PHIData['type'],
            value: match,
            context: `Found in ${location}`,
            location,
          });

          // Apply sanitization
          const sanitized = this.sanitizePHIValue(
            match,
            type as PHIData['type'],
          );
          sanitizedContent = sanitizedContent.replace(match, sanitized);
          sanitizationApplied = true;
        }
      }
    }

    // Additional healthcare-specific sanitization
    if (location === 'message') {
      // Sanitize medication names that might be too specific
      const medicationPattern =
        /\b([A-Z][a-z]+(?:zole|pril|statin|mycin|cillin))\b/g;
      const medicationMatches = text.match(medicationPattern);
      if (medicationMatches) {
        warnings.push(
          'Specific medication names detected - consider using generic terms',
        );
      }
    }

    const complianceLevel: 'full' | 'partial' | 'none' =
      phiDetected.length === 0
        ? 'full'
        : sanitizationApplied
          ? 'partial'
          : 'none';

    return {
      originalContent: text,
      sanitizedContent,
      phiDetected,
      sanitizationApplied,
      complianceLevel,
      warnings,
    };
  }

  /**
   * Sanitize metadata
   */
  private sanitizeMetadata(metadata: Record<string, any>): SanitizationResult {
    const sanitizedMetadata = { ...metadata };
    const phiDetected: PHIData[] = [];
    let sanitizationApplied = false;
    const warnings: string[] = [];

    // Check for PHI in metadata values
    for (const [key, value] of Object.entries(metadata)) {
      if (typeof value === 'string') {
        const detected = this.detectPHI(value);
        if (detected.length > 0) {
          phiDetected.push(
            ...detected.map((phi) => ({
              ...phi,
              context: `Found in metadata.${key}`,
              location: 'metadata' as const,
            })),
          );

          // Sanitize the value
          let sanitizedValue = value;
          for (const phi of detected) {
            const sanitized = this.sanitizePHIValue(phi.value, phi.type);
            sanitizedValue = sanitizedValue.replace(phi.value, sanitized);
          }
          sanitizedMetadata[key] = sanitizedValue;
          sanitizationApplied = true;
        }
      }
    }

    const complianceLevel: 'full' | 'partial' | 'none' =
      phiDetected.length === 0
        ? 'full'
        : sanitizationApplied
          ? 'partial'
          : 'none';

    return {
      originalContent: JSON.stringify(metadata),
      sanitizedContent: JSON.stringify(sanitizedMetadata),
      phiDetected,
      sanitizationApplied,
      complianceLevel,
      warnings,
    };
  }

  /**
   * Detect PHI in text
   */
  private detectPHI(text: string): PHIData[] {
    const detected: PHIData[] = [];

    for (const [type, pattern] of Object.entries(this.phiPatterns)) {
      const matches = text.match(pattern);
      if (matches) {
        for (const match of matches) {
          detected.push({
            type: type as PHIData['type'],
            value: match,
            context: 'Detected in content',
            location: 'message',
          });
        }
      }
    }

    return detected;
  }

  /**
   * Sanitize PHI value
   */
  private sanitizePHIValue(value: string, type: string): string {
    switch (type) {
      case 'ssn':
        return 'XXX-XX-' + value.slice(-4);
      case 'phone':
        return 'XXX-XXX-' + value.slice(-4);
      case 'email': {
        const [local, domain] = value.split('@');
        return local.charAt(0) + '***@' + domain;
      }
      case 'creditCard':
        return '**** **** **** ' + value.slice(-4);
      case 'medicalRecord':
        return 'MRN: ***' + value.slice(-3);
      case 'insurance':
        return 'Policy: ***' + value.slice(-3);
      default:
        return '[REDACTED]';
    }
  }

  /**
   * Log compliance audit
   */
  private logComplianceAudit(
    auditData: Omit<ComplianceAuditLog, 'id' | 'timestamp'>,
  ): void {
    const auditLog: ComplianceAuditLog = {
      id: `audit_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      timestamp: new Date(),
      ...auditData,
    };

    // In a real implementation, this would be stored in a secure audit database
    this.logger.log(
      `Compliance audit logged: ${auditLog.id} - ${auditLog.action}`,
    );

    // Log to secure audit system
    console.log('HIPAA_AUDIT:', JSON.stringify(auditLog));
  }
}
