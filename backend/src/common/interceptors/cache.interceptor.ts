import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Observable, of } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Reflector } from '@nestjs/core';
import { Request } from 'express';
import { Cache } from 'cache-manager';
import { Inject } from '@nestjs/common';
import { CACHE_MANAGER } from '@nestjs/cache-manager';

// Decorator to enable caching for specific endpoints
export const Cacheable = (ttl?: number, key?: string) => {
  return (
    target: any,
    propertyName: string,
    descriptor: PropertyDescriptor,
  ) => {
    Reflect.defineMetadata('cache:enabled', true, descriptor.value);
    if (ttl) {
      Reflect.defineMetadata('cache:ttl', ttl, descriptor.value);
    }
    if (key) {
      Reflect.defineMetadata('cache:key', key, descriptor.value);
    }
  };
};

// Decorator to exclude specific endpoints from caching
export const NoCache = () => {
  return (
    target: any,
    propertyName: string,
    descriptor: PropertyDescriptor,
  ) => {
    Reflect.defineMetadata('cache:disabled', true, descriptor.value);
  };
};

@Injectable()
export class CustomCacheInterceptor implements NestInterceptor {
  private readonly logger = new Logger(CustomCacheInterceptor.name);

  constructor(
    @Inject(CACHE_MANAGER) private cacheManager: Cache,
    private reflector: Reflector,
  ) {}

  async intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Promise<Observable<any>> {
    const request = context.switchToHttp().getRequest<Request>();
    const handler = context.getHandler();

    // Check if caching is disabled for this endpoint
    const cacheDisabled = this.reflector.get<boolean>(
      'cache:disabled',
      handler,
    );
    if (cacheDisabled) {
      return next.handle();
    }

    // Only cache GET requests
    if (request.method !== 'GET') {
      return next.handle();
    }

    // Check if caching is explicitly enabled
    const cacheEnabled = this.reflector.get<boolean>('cache:enabled', handler);
    if (!cacheEnabled && !this.shouldCacheByDefault(request.url)) {
      return next.handle();
    }

    // Don't cache requests with PHI data unless explicitly enabled
    if (this.containsPHI(request) && !cacheEnabled) {
      return next.handle();
    }

    const cacheKey = this.generateCacheKey(request, handler);
    const ttl = this.reflector.get<number>('cache:ttl', handler) || 300000; // 5 minutes default

    try {
      // Try to get from cache
      const cachedResult = await this.cacheManager.get(cacheKey);
      if (cachedResult) {
        this.logger.debug(`Cache hit for key: ${cacheKey}`);
        return of(cachedResult);
      }

      // If not in cache, execute the handler and cache the result
      return next.handle().pipe(
        tap(async (data) => {
          if (data && this.shouldCacheResponse(data)) {
            try {
              await this.cacheManager.set(cacheKey, data, ttl);
              this.logger.debug(
                `Cached result for key: ${cacheKey}, TTL: ${ttl}ms`,
              );
            } catch (error) {
              this.logger.error(
                `Failed to cache result for key: ${cacheKey}`,
                error.stack,
              );
            }
          }
        }),
      );
    } catch (error) {
      this.logger.error(`Cache error for key: ${cacheKey}`, error.stack);
      return next.handle();
    }
  }

  private generateCacheKey(request: Request, handler: Function): string {
    const customKey = this.reflector.get<string>('cache:key', handler);
    if (customKey) {
      return this.interpolateKey(customKey, request);
    }

    const userId = (request as any).user?.id || 'anonymous';
    const { method, url, query } = request;

    // Create a deterministic key from request parameters
    const queryString = Object.keys(query)
      .sort()
      .map((key) => `${key}=${query[key]}`)
      .join('&');

    return `${method}:${url}:${userId}:${queryString}`;
  }

  private interpolateKey(template: string, request: Request): string {
    const userId = (request as any).user?.id || 'anonymous';
    const params = request.params || {};
    const query = request.query || {};

    return template
      .replace('{userId}', userId)
      .replace(
        /{params\.(\w+)}/g,
        (match, paramName) => params[paramName] || '',
      )
      .replace(/{query\.(\w+)}/g, (match, queryName) =>
        String(query[queryName] || ''),
      );
  }

  private shouldCacheByDefault(url: string): boolean {
    // Cache these endpoints by default
    const cacheableEndpoints = [
      '/analytics',
      '/insights',
      '/recommendations',
      '/subscription/plans',
      '/care-groups/public',
    ];

    return cacheableEndpoints.some((endpoint) => url.includes(endpoint));
  }

  private containsPHI(request: Request): boolean {
    const phiEndpoints = [
      '/health-records',
      '/prescriptions',
      '/daily-check-ins',
      '/users/profile',
    ];

    return phiEndpoints.some((endpoint) => request.url.includes(endpoint));
  }

  private shouldCacheResponse(data: any): boolean {
    // Don't cache empty responses or error responses
    if (!data || data.error || data.statusCode >= 400) {
      return false;
    }

    // Don't cache responses that are too large (> 1MB)
    const dataSize = JSON.stringify(data).length;
    if (dataSize > 1024 * 1024) {
      return false;
    }

    return true;
  }
}
