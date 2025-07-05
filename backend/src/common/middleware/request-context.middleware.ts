import { Injectable, NestMiddleware, Logger } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { AsyncLocalStorage } from 'async_hooks';

export interface RequestContext {
  correlationId: string;
  userId?: string;
  userEmail?: string;
  userRole?: string;
  ip: string;
  userAgent: string;
  startTime: number;
  path: string;
  method: string;
}

// Global async local storage for request context
export const requestContextStorage = new AsyncLocalStorage<RequestContext>();

@Injectable()
export class RequestContextMiddleware implements NestMiddleware {
  private readonly logger = new Logger(RequestContextMiddleware.name);

  use(req: Request, res: Response, next: NextFunction) {
    const correlationId = this.generateCorrelationId();
    const startTime = Date.now();

    // Extract request information
    const context: RequestContext = {
      correlationId,
      userId: (req as any).user?.id,
      userEmail: (req as any).user?.email,
      userRole: (req as any).user?.role,
      ip: req.ip || req.connection.remoteAddress || 'unknown',
      userAgent: req.get('User-Agent') || 'unknown',
      startTime,
      path: req.path,
      method: req.method,
    };

    // Add correlation ID to request and response headers
    (req as any).correlationId = correlationId;
    res.setHeader('X-Correlation-ID', correlationId);

    // Store context in async local storage
    requestContextStorage.run(context, () => {
      next();
    });
  }

  private generateCorrelationId(): string {
    return `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }
}

// Utility function to get current request context
export function getCurrentContext(): RequestContext | undefined {
  return requestContextStorage.getStore();
}

// Utility function to get correlation ID
export function getCorrelationId(): string {
  const context = getCurrentContext();
  return context?.correlationId || 'unknown';
}

// Utility function to get current user ID
export function getCurrentUserId(): string | undefined {
  const context = getCurrentContext();
  return context?.userId;
}

// Utility function to get current user info
export function getCurrentUser(): {
  id?: string;
  email?: string;
  role?: string;
} {
  const context = getCurrentContext();
  return {
    id: context?.userId,
    email: context?.userEmail,
    role: context?.userRole,
  };
}
