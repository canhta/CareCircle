import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap, catchError } from 'rxjs/operators';
import { Request, Response } from 'express';
import { AuditService } from '../services/audit.service';
import {
  RequestWithCorrelationId,
  PHIAccessAuditData,
} from '../interfaces/interceptor.interfaces';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private readonly logger = new Logger(LoggingInterceptor.name);

  constructor(private readonly auditService: AuditService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const request = context.switchToHttp().getRequest<Request>();
    const response = context.switchToHttp().getResponse<Response>();
    const { method, url, ip, headers } = request;
    const userAgent = headers['user-agent'] || '';
    const typedRequest = request as RequestWithCorrelationId;
    const userId = typedRequest.user?.id || 'anonymous';

    const startTime = Date.now();
    const correlationId = this.generateCorrelationId();

    // Add correlation ID to request for tracking
    typedRequest.correlationId = correlationId;

    // Log incoming request
    this.logger.log(
      `Incoming Request: ${method} ${url} - User: ${userId}, IP: ${ip}`,
      correlationId,
    );

    return next.handle().pipe(
      tap((data) => {
        const endTime = Date.now();
        const duration = endTime - startTime;
        const { statusCode } = response;

        // Log successful response
        this.logger.log(
          `Outgoing Response: ${method} ${url} ${statusCode} - ${duration}ms - User: ${userId}`,
          correlationId,
        );

        // Audit PHI access if applicable
        if (this.isPHIEndpoint(url)) {
          this.auditPHIAccess(request, response, duration, correlationId);
        }

        // Log slow requests
        if (duration > 5000) {
          this.logger.warn(
            `Slow Request: ${method} ${url} took ${duration}ms - User: ${userId}`,
            correlationId,
          );
        }
      }),
      catchError((error) => {
        const endTime = Date.now();
        const duration = endTime - startTime;

        this.logger.error(
          `Request Error: ${method} ${url} - ${duration}ms - User: ${userId} - Error: ${error.message}`,
          error.stack,
          correlationId,
        );

        throw error;
      }),
    );
  }

  private generateCorrelationId(): string {
    return `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }

  private isPHIEndpoint(url: string): boolean {
    const phiEndpoints = [
      '/health-records',
      '/prescriptions',
      '/daily-check-ins',
      '/care-groups',
      '/users/profile',
    ];

    return phiEndpoints.some((endpoint) => url.includes(endpoint));
  }

  private auditPHIAccess(
    request: Request,
    response: Response,
    duration: number,
    correlationId: string,
  ): void {
    const typedRequest = request as RequestWithCorrelationId;
    const userId = typedRequest.user?.id;
    const { method, url, ip, headers } = request;
    const { statusCode } = response;

    // Audit PHI access asynchronously
    setImmediate(() => {
      const auditData: PHIAccessAuditData = {
        userId,
        action: method,
        resource: url,
        statusCode,
        duration,
        ip,
        userAgent: headers['user-agent'],
        correlationId,
        timestamp: new Date(),
      };

      this.auditService.logPHIAccess(auditData).catch((auditError) => {
        this.logger.error(
          'Failed to audit PHI access',
          auditError.stack,
          correlationId,
        );
      });
    });
  }
}
