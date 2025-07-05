import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
  Injectable,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { PrismaClientKnownRequestError } from '@prisma/client/runtime/library';
import { ThrottlerException } from '@nestjs/throttler';
import { AuditService } from '../services/audit.service';

export interface ErrorResponse {
  statusCode: number;
  timestamp: string;
  path: string;
  method: string;
  message: string | string[];
  error?: string;
  correlationId: string;
  details?: any;
}

@Injectable()
@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalExceptionFilter.name);

  constructor(private readonly auditService: AuditService) {}

  catch(exception: unknown, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    const correlationId = this.generateCorrelationId();
    const timestamp = new Date().toISOString();
    const path = request.url;
    const method = request.method;

    let status: number;
    let message: string | string[] = 'Internal server error';
    let error: string = 'Unknown Error';
    let details: any;

    // Handle different types of exceptions
    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const exceptionResponse = exception.getResponse();

      if (typeof exceptionResponse === 'string') {
        message = exceptionResponse;
        error = exception.name;
      } else if (typeof exceptionResponse === 'object') {
        message = (exceptionResponse as any).message || exception.message;
        error = (exceptionResponse as any).error || exception.name;
        details = (exceptionResponse as any).details;
      }
    } else if (exception instanceof PrismaClientKnownRequestError) {
      status = HttpStatus.BAD_REQUEST;
      message = this.handlePrismaError(exception);
      error = 'Database Error';
      details = { code: exception.code };
    } else if (exception instanceof ThrottlerException) {
      status = HttpStatus.TOO_MANY_REQUESTS;
      message = 'Too many requests. Please try again later.';
      error = 'Rate Limit Exceeded';
    } else if (exception instanceof Error) {
      status = HttpStatus.INTERNAL_SERVER_ERROR;
      message = 'Internal server error';
      error = exception.name;

      // Log the full error for debugging
      this.logger.error(
        `Unhandled exception: ${exception.message}`,
        exception.stack,
        correlationId,
      );
    } else {
      status = HttpStatus.INTERNAL_SERVER_ERROR;
      message = 'Internal server error';
      error = 'Unknown Error';

      this.logger.error(
        `Unknown exception type: ${typeof exception}`,
        JSON.stringify(exception),
        correlationId,
      );
    }

    const errorResponse: ErrorResponse = {
      statusCode: status,
      timestamp,
      path,
      method,
      message,
      error,
      correlationId,
      ...(details && { details }),
    };

    // Log the error
    this.logError(exception, errorResponse, request);

    // Audit security-related errors
    if (this.isSecurityRelatedError(status)) {
      this.auditSecurityError(request, errorResponse);
    }

    response.status(status).json(errorResponse);
  }

  private generateCorrelationId(): string {
    return `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }

  private handlePrismaError(error: PrismaClientKnownRequestError): string {
    switch (error.code) {
      case 'P2002':
        return 'A record with this information already exists';
      case 'P2014':
        return 'The change you are trying to make would violate the required relation';
      case 'P2003':
        return 'Foreign key constraint failed';
      case 'P2025':
        return 'Record not found';
      default:
        return 'Database operation failed';
    }
  }

  private logError(
    exception: unknown,
    errorResponse: ErrorResponse,
    request: Request,
  ): void {
    const { statusCode, correlationId, message } = errorResponse;
    const userId = (request as any).user?.id || 'anonymous';
    const userAgent = request.get('User-Agent') || 'unknown';
    const ip = request.ip || request.connection.remoteAddress;

    const logMessage = `${statusCode} ${message} - User: ${userId}, IP: ${ip}, UA: ${userAgent}`;

    if (statusCode >= 500) {
      this.logger.error(
        logMessage,
        exception instanceof Error ? exception.stack : '',
        correlationId,
      );
    } else if (statusCode >= 400) {
      this.logger.warn(logMessage, correlationId);
    }
  }

  private isSecurityRelatedError(statusCode: number): boolean {
    return [401, 403, 429].includes(statusCode);
  }

  private auditSecurityError(
    request: Request,
    errorResponse: ErrorResponse,
  ): void {
    const userId = (request as any).user?.id;
    const ip = request.ip || request.connection.remoteAddress;

    // Audit the security event asynchronously
    setImmediate(() => {
      this.auditService
        .logSecurityEvent({
          userId,
          action: 'SECURITY_ERROR',
          resource: errorResponse.path,
          details: {
            statusCode: errorResponse.statusCode,
            error: errorResponse.error,
            ip,
            userAgent: request.get('User-Agent'),
            correlationId: errorResponse.correlationId,
          },
          timestamp: new Date(),
          severity: this.getSecuritySeverity(errorResponse.statusCode),
          eventType: 'SYSTEM',
        })
        .catch((auditError) => {
          this.logger.error('Failed to audit security error', auditError.stack);
        });
    });
  }

  private getSecuritySeverity(
    statusCode: number,
  ): 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL' {
    if (statusCode >= 500) return 'CRITICAL';
    if (statusCode === 403 || statusCode === 401) return 'HIGH';
    if (statusCode === 429) return 'MEDIUM';
    return 'LOW';
  }
}
