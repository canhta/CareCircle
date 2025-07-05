import {
  SetMetadata,
  createParamDecorator,
  ExecutionContext,
} from '@nestjs/common';

// Metadata key for PHI access tracking
export const PHI_ACCESS_KEY = 'phi_access';

// PHI access levels
export enum PHIAccessLevel {
  READ = 'READ',
  WRITE = 'WRITE',
  DELETE = 'DELETE',
  EXPORT = 'EXPORT',
}

// PHI data types
export enum PHIDataType {
  HEALTH_RECORD = 'HEALTH_RECORD',
  PRESCRIPTION = 'PRESCRIPTION',
  PERSONAL_INFO = 'PERSONAL_INFO',
  BIOMETRIC = 'BIOMETRIC',
  MEDICAL_HISTORY = 'MEDICAL_HISTORY',
  CARE_PLAN = 'CARE_PLAN',
}

export interface PHIAccessMetadata {
  level: PHIAccessLevel;
  dataTypes: PHIDataType[];
  purpose: string;
  requiresConsent?: boolean;
  auditRequired?: boolean;
}

/**
 * Decorator to mark endpoints that access PHI data
 * This enables automatic audit logging and compliance checking
 */
export const PHIAccess = (metadata: PHIAccessMetadata) => {
  return SetMetadata(PHI_ACCESS_KEY, metadata);
};

/**
 * Decorator to get PHI access context in controllers
 */
export const PHIContext = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    return {
      userId: request.user?.id,
      correlationId: request.correlationId,
      ip: request.ip,
      userAgent: request.get('User-Agent'),
      timestamp: new Date(),
    };
  },
);

/**
 * Convenience decorators for common PHI access patterns
 */
export const ReadHealthRecord = (purpose: string) =>
  PHIAccess({
    level: PHIAccessLevel.READ,
    dataTypes: [PHIDataType.HEALTH_RECORD],
    purpose,
    auditRequired: true,
  });

export const WriteHealthRecord = (purpose: string) =>
  PHIAccess({
    level: PHIAccessLevel.WRITE,
    dataTypes: [PHIDataType.HEALTH_RECORD],
    purpose,
    requiresConsent: true,
    auditRequired: true,
  });

export const ReadPrescription = (purpose: string) =>
  PHIAccess({
    level: PHIAccessLevel.READ,
    dataTypes: [PHIDataType.PRESCRIPTION],
    purpose,
    auditRequired: true,
  });

export const WritePrescription = (purpose: string) =>
  PHIAccess({
    level: PHIAccessLevel.WRITE,
    dataTypes: [PHIDataType.PRESCRIPTION],
    purpose,
    requiresConsent: true,
    auditRequired: true,
  });

export const ReadPersonalInfo = (purpose: string) =>
  PHIAccess({
    level: PHIAccessLevel.READ,
    dataTypes: [PHIDataType.PERSONAL_INFO],
    purpose,
    auditRequired: true,
  });

export const WritePersonalInfo = (purpose: string) =>
  PHIAccess({
    level: PHIAccessLevel.WRITE,
    dataTypes: [PHIDataType.PERSONAL_INFO],
    purpose,
    requiresConsent: true,
    auditRequired: true,
  });

export const ExportPHI = (purpose: string, dataTypes: PHIDataType[]) =>
  PHIAccess({
    level: PHIAccessLevel.EXPORT,
    dataTypes,
    purpose,
    requiresConsent: true,
    auditRequired: true,
  });

export const DeletePHI = (purpose: string, dataTypes: PHIDataType[]) =>
  PHIAccess({
    level: PHIAccessLevel.DELETE,
    dataTypes,
    purpose,
    requiresConsent: true,
    auditRequired: true,
  });
