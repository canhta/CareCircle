import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpStatus,
  Logger,
  Injectable,
} from '@nestjs/common';
import { Response } from 'express';

// Domain-specific exceptions
export class DomainException extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly statusCode: number = HttpStatus.BAD_REQUEST,
    public readonly details?: any,
  ) {
    super(message);
    this.name = 'DomainException';
  }
}

export class HealthDataException extends DomainException {
  constructor(message: string, details?: any) {
    super(message, 'HEALTH_DATA_ERROR', HttpStatus.BAD_REQUEST, details);
    this.name = 'HealthDataException';
  }
}

export class CareGroupException extends DomainException {
  constructor(message: string, details?: any) {
    super(message, 'CARE_GROUP_ERROR', HttpStatus.BAD_REQUEST, details);
    this.name = 'CareGroupException';
  }
}

export class SubscriptionException extends DomainException {
  constructor(message: string, details?: any) {
    super(message, 'SUBSCRIPTION_ERROR', HttpStatus.PAYMENT_REQUIRED, details);
    this.name = 'SubscriptionException';
  }
}

export class NotificationException extends DomainException {
  constructor(message: string, details?: any) {
    super(message, 'NOTIFICATION_ERROR', HttpStatus.BAD_REQUEST, details);
    this.name = 'NotificationException';
  }
}

export class PrescriptionException extends DomainException {
  constructor(message: string, details?: any) {
    super(message, 'PRESCRIPTION_ERROR', HttpStatus.BAD_REQUEST, details);
    this.name = 'PrescriptionException';
  }
}

export class AIServiceException extends DomainException {
  constructor(message: string, details?: any) {
    super(message, 'AI_SERVICE_ERROR', HttpStatus.SERVICE_UNAVAILABLE, details);
    this.name = 'AIServiceException';
  }
}

export class ComplianceException extends DomainException {
  constructor(message: string, details?: any) {
    super(message, 'COMPLIANCE_ERROR', HttpStatus.FORBIDDEN, details);
    this.name = 'ComplianceException';
  }
}

export class DataIntegrityException extends DomainException {
  constructor(message: string, details?: any) {
    super(message, 'DATA_INTEGRITY_ERROR', HttpStatus.CONFLICT, details);
    this.name = 'DataIntegrityException';
  }
}

@Injectable()
@Catch(DomainException)
export class DomainExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(DomainExceptionFilter.name);

  catch(exception: DomainException, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest();

    const status = exception.statusCode;
    const timestamp = new Date().toISOString();
    const path = request.url;
    const method = request.method;

    const errorResponse = {
      statusCode: status,
      timestamp,
      path,
      method,
      error: exception.name,
      code: exception.code,
      message: exception.message,
      ...(exception.details && { details: exception.details }),
    };

    // Log domain exceptions for monitoring
    this.logger.warn(
      `Domain Exception: ${exception.code} - ${exception.message}`,
      {
        path,
        method,
        statusCode: status,
        details: exception.details,
      },
    );

    response.status(status).json(errorResponse);
  }
}

// Utility functions for throwing domain exceptions
export const throwHealthDataError = (message: string, details?: any): never => {
  throw new HealthDataException(message, details);
};

export const throwCareGroupError = (message: string, details?: any): never => {
  throw new CareGroupException(message, details);
};

export const throwSubscriptionError = (
  message: string,
  details?: any,
): never => {
  throw new SubscriptionException(message, details);
};

export const throwNotificationError = (
  message: string,
  details?: any,
): never => {
  throw new NotificationException(message, details);
};

export const throwPrescriptionError = (
  message: string,
  details?: any,
): never => {
  throw new PrescriptionException(message, details);
};

export const throwAIServiceError = (message: string, details?: any): never => {
  throw new AIServiceException(message, details);
};

export const throwComplianceError = (message: string, details?: any): never => {
  throw new ComplianceException(message, details);
};

export const throwDataIntegrityError = (
  message: string,
  details?: any,
): never => {
  throw new DataIntegrityException(message, details);
};
