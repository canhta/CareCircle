import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  RequestTimeoutException,
  Logger,
} from '@nestjs/common';
import { Observable, throwError, TimeoutError } from 'rxjs';
import { timeout, catchError } from 'rxjs/operators';
import { Reflector } from '@nestjs/core';
import { RequestWithCorrelationId } from '../interfaces/interceptor.interfaces';

// Timeout response error shape
export interface TimeoutErrorResponse {
  message: string;
  timeout: number;
  path: string;
  method: string;
  correlationId: string;
}

// Decorator to set custom timeout for specific endpoints
export const Timeout = (ms: number) => {
  return (
    target: object,
    propertyName: string,
    descriptor: PropertyDescriptor,
  ) => {
    Reflect.defineMetadata('timeout', ms, descriptor.value);
  };
};

@Injectable()
export class TimeoutInterceptor implements NestInterceptor {
  private readonly logger = new Logger(TimeoutInterceptor.name);
  private readonly defaultTimeout = 30000; // 30 seconds

  constructor(private reflector: Reflector) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const handler = context.getHandler();
    const request = context
      .switchToHttp()
      .getRequest<RequestWithCorrelationId>();

    // Get custom timeout or use default based on endpoint type
    const customTimeout = this.reflector.get<number>('timeout', handler);
    const timeoutMs = customTimeout || this.getTimeoutForEndpoint(request.url);

    const correlationId = request.correlationId || 'unknown';

    return next.handle().pipe(
      timeout(timeoutMs),
      catchError((error) => {
        if (error instanceof TimeoutError) {
          this.logger.error(
            `Request timeout after ${timeoutMs}ms: ${request.method} ${request.url}`,
            undefined,
            correlationId,
          );

          const errorResponse: TimeoutErrorResponse = {
            message: `Request timeout after ${timeoutMs}ms`,
            timeout: timeoutMs,
            path: request.url,
            method: request.method,
            correlationId,
          };

          return throwError(() => new RequestTimeoutException(errorResponse));
        }
        return throwError(() => error);
      }),
    );
  }

  private getTimeoutForEndpoint(url: string): number {
    // Different timeouts for different types of operations
    const timeoutConfig = [
      { pattern: '/ai/', timeout: 60000 }, // AI operations - 60 seconds
      { pattern: '/analytics/', timeout: 45000 }, // Analytics - 45 seconds
      { pattern: '/health-records/export', timeout: 120000 }, // Data export - 2 minutes
      { pattern: '/prescriptions/ocr', timeout: 30000 }, // OCR processing - 30 seconds
      { pattern: '/notifications/bulk', timeout: 45000 }, // Bulk notifications - 45 seconds
      { pattern: '/subscription/webhook', timeout: 15000 }, // Webhooks - 15 seconds
      { pattern: '/auth/', timeout: 10000 }, // Authentication - 10 seconds
      { pattern: '/upload', timeout: 60000 }, // File uploads - 60 seconds
    ];

    for (const config of timeoutConfig) {
      if (url.includes(config.pattern)) {
        return config.timeout;
      }
    }

    return this.defaultTimeout;
  }
}
