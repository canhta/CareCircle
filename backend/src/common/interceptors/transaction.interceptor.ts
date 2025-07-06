import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap, catchError } from 'rxjs/operators';
import { Reflector } from '@nestjs/core';
import { PrismaService } from '../../prisma/prisma.service';
import {
  RequestWithCorrelationId,
  TransactionOptions,
} from '../interfaces/interceptor.interfaces';

// Decorator to enable database transactions for specific endpoints
export const Transactional = (
  isolationLevel?:
    | 'ReadUncommitted'
    | 'ReadCommitted'
    | 'RepeatableRead'
    | 'Serializable',
) => {
  return (
    target: object,
    propertyName: string,
    descriptor: PropertyDescriptor,
  ) => {
    Reflect.defineMetadata('transaction:enabled', true, descriptor.value);
    if (isolationLevel) {
      Reflect.defineMetadata(
        'transaction:isolation',
        isolationLevel,
        descriptor.value,
      );
    }
  };
};

// Extended request type with transaction property
export interface RequestWithTransaction extends RequestWithCorrelationId {
  transaction: unknown;
}

@Injectable()
export class TransactionInterceptor implements NestInterceptor {
  private readonly logger = new Logger(TransactionInterceptor.name);

  constructor(
    private reflector: Reflector,
    private prisma: PrismaService,
  ) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const handler = context.getHandler();
    const request = context
      .switchToHttp()
      .getRequest<RequestWithCorrelationId>();

    // Check if transaction is enabled for this endpoint
    const transactionEnabled = this.reflector.get<boolean>(
      'transaction:enabled',
      handler,
    );
    if (!transactionEnabled && !this.shouldUseTransactionByDefault(request)) {
      return next.handle();
    }

    const isolationLevel = this.reflector.get<string>(
      'transaction:isolation',
      handler,
    );
    const correlationId = request.correlationId || 'unknown';

    this.logger.debug(
      `Starting transaction for ${request.method} ${request.url}`,
      correlationId,
    );

    // Execute within a database transaction
    return new Observable((observer) => {
      this.prisma
        .$transaction(
          async (tx) => {
            // Attach transaction to request for use in services
            (request as RequestWithTransaction).transaction = tx;

            return new Promise((resolve, reject) => {
              next.handle().subscribe({
                next: (data) => {
                  resolve(data);
                },
                error: (error) => {
                  reject(error);
                },
                complete: () => {
                  // Transaction will be committed automatically if no error
                },
              });
            });
          },
          {
            isolationLevel: isolationLevel as
              | 'ReadUncommitted'
              | 'ReadCommitted'
              | 'RepeatableRead'
              | 'Serializable',
            timeout: this.getTransactionTimeout(request.url),
          },
        )
        .then(
          (result) => {
            this.logger.debug(
              `Transaction committed for ${request.method} ${request.url}`,
              correlationId,
            );
            observer.next(result);
            observer.complete();
          },
          (error) => {
            this.logger.error(
              `Transaction rolled back for ${request.method} ${request.url}: ${error.message}`,
              error.stack,
              correlationId,
            );
            observer.error(error);
          },
        );
    });
  }

  private shouldUseTransactionByDefault(
    request: RequestWithCorrelationId,
  ): boolean {
    const { method, url } = request;

    // Use transactions for these operations by default
    const transactionalOperations = [
      {
        method: 'POST',
        patterns: ['/care-groups', '/prescriptions', '/health-records'],
      },
      {
        method: 'PUT',
        patterns: [
          '/care-groups',
          '/prescriptions',
          '/health-records',
          '/users',
        ],
      },
      {
        method: 'PATCH',
        patterns: [
          '/care-groups',
          '/prescriptions',
          '/health-records',
          '/users',
        ],
      },
      {
        method: 'DELETE',
        patterns: ['/care-groups', '/prescriptions', '/health-records'],
      },
    ];

    return transactionalOperations.some(
      (op) =>
        op.method === method &&
        op.patterns.some((pattern) => url.includes(pattern)),
    );
  }

  private getTransactionTimeout(url: string): number {
    // Different timeouts for different types of operations
    const timeoutConfig = [
      { pattern: '/health-records/bulk', timeout: 60000 }, // Bulk operations - 60 seconds
      { pattern: '/care-groups/bulk', timeout: 45000 }, // Bulk care group operations - 45 seconds
      { pattern: '/prescriptions/batch', timeout: 30000 }, // Batch prescription processing - 30 seconds
      { pattern: '/analytics/', timeout: 45000 }, // Analytics operations - 45 seconds
    ];

    for (const config of timeoutConfig) {
      if (url.includes(config.pattern)) {
        return config.timeout;
      }
    }

    return 15000; // Default 15 seconds
  }
}
