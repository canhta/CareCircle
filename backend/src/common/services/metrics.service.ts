import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { getCurrentContext } from '../middleware/request-context.middleware';

export interface MetricData {
  name: string;
  value: number;
  tags?: Record<string, string>;
  timestamp?: Date;
}

export interface PerformanceMetric {
  endpoint: string;
  method: string;
  duration: number;
  statusCode: number;
  userId?: string;
  timestamp: Date;
}

export interface BusinessMetric {
  metric: string;
  value: number;
  userId?: string;
  metadata?: any;
  timestamp: Date;
}

@Injectable()
export class MetricsService {
  private readonly logger = new Logger(MetricsService.name);
  private metricsBuffer: MetricData[] = [];
  private readonly bufferSize = 100;
  private readonly flushInterval = 30000; // 30 seconds

  constructor(private readonly prisma: PrismaService) {
    // Flush metrics periodically
    setInterval(() => {
      this.flushMetrics();
    }, this.flushInterval);
  }

  /**
   * Record a custom metric
   */
  recordMetric(metric: MetricData): void {
    const metricWithTimestamp = {
      ...metric,
      timestamp: metric.timestamp || new Date(),
    };

    this.metricsBuffer.push(metricWithTimestamp);

    // Flush if buffer is full
    if (this.metricsBuffer.length >= this.bufferSize) {
      this.flushMetrics();
    }
  }

  /**
   * Record API performance metrics
   */
  recordPerformanceMetric(metric: PerformanceMetric): void {
    this.recordMetric({
      name: 'api_request_duration',
      value: metric.duration,
      tags: {
        endpoint: metric.endpoint,
        method: metric.method,
        status_code: metric.statusCode.toString(),
        user_id: metric.userId || 'anonymous',
      },
      timestamp: metric.timestamp,
    });

    // Record error rate
    this.recordMetric({
      name: 'api_request_count',
      value: 1,
      tags: {
        endpoint: metric.endpoint,
        method: metric.method,
        status_code: metric.statusCode.toString(),
        success: metric.statusCode < 400 ? 'true' : 'false',
      },
      timestamp: metric.timestamp,
    });
  }

  /**
   * Record business metrics
   */
  recordBusinessMetric(metric: BusinessMetric): void {
    this.recordMetric({
      name: metric.metric,
      value: metric.value,
      tags: {
        user_id: metric.userId || 'system',
        ...(metric.metadata && { metadata: JSON.stringify(metric.metadata) }),
      },
      timestamp: metric.timestamp,
    });
  }

  /**
   * Record AI service usage metrics
   */
  recordAIUsage(
    service: string,
    tokens: number,
    cost: number,
    userId?: string,
  ): void {
    const context = getCurrentContext();

    this.recordMetric({
      name: 'ai_tokens_used',
      value: tokens,
      tags: {
        service,
        user_id: userId || context?.userId || 'anonymous',
      },
    });

    this.recordMetric({
      name: 'ai_cost',
      value: cost,
      tags: {
        service,
        user_id: userId || context?.userId || 'anonymous',
      },
    });
  }

  /**
   * Record database query metrics
   */
  recordDatabaseMetric(
    operation: string,
    duration: number,
    table?: string,
  ): void {
    this.recordMetric({
      name: 'database_query_duration',
      value: duration,
      tags: {
        operation,
        ...(table && { table }),
      },
    });
  }

  /**
   * Record cache metrics
   */
  recordCacheMetric(
    operation: 'hit' | 'miss' | 'set' | 'delete',
    key: string,
  ): void {
    this.recordMetric({
      name: 'cache_operation',
      value: 1,
      tags: {
        operation,
        key_prefix: key.split(':')[0] || 'unknown',
      },
    });
  }

  /**
   * Record notification metrics
   */
  recordNotificationMetric(
    type: string,
    status: 'sent' | 'failed' | 'delivered',
    userId?: string,
  ): void {
    this.recordMetric({
      name: 'notification_count',
      value: 1,
      tags: {
        type,
        status,
        user_id: userId || 'unknown',
      },
    });
  }

  /**
   * Get performance metrics for a specific endpoint
   */
  async getEndpointMetrics(endpoint: string, startDate: Date, endDate: Date) {
    try {
      const metrics = await this.prisma.metric.findMany({
        where: {
          name: 'api_request_duration',
          tags: {
            path: ['$.endpoint'],
            equals: endpoint,
          },
          timestamp: {
            gte: startDate,
            lte: endDate,
          },
        },
        orderBy: {
          timestamp: 'desc',
        },
      });

      return this.aggregateMetrics(metrics);
    } catch (error) {
      this.logger.error('Failed to get endpoint metrics', error.stack);
      return null;
    }
  }

  /**
   * Get AI usage metrics for cost tracking
   */
  async getAIUsageMetrics(startDate: Date, endDate: Date, userId?: string) {
    try {
      const where: any = {
        name: { in: ['ai_tokens_used', 'ai_cost'] },
        timestamp: {
          gte: startDate,
          lte: endDate,
        },
      };

      if (userId) {
        where.tags = {
          path: ['$.user_id'],
          equals: userId,
        };
      }

      const metrics = await this.prisma.metric.findMany({
        where,
        orderBy: {
          timestamp: 'desc',
        },
      });

      return this.aggregateAIMetrics(metrics);
    } catch (error) {
      this.logger.error('Failed to get AI usage metrics', error.stack);
      return null;
    }
  }

  /**
   * Get system health metrics
   */
  async getSystemHealthMetrics() {
    try {
      const now = new Date();
      const oneHourAgo = new Date(now.getTime() - 60 * 60 * 1000);

      const [errorRate, avgResponseTime, cacheHitRate] = await Promise.all([
        this.getErrorRate(oneHourAgo, now),
        this.getAverageResponseTime(oneHourAgo, now),
        this.getCacheHitRate(oneHourAgo, now),
      ]);

      return {
        errorRate,
        avgResponseTime,
        cacheHitRate,
        timestamp: now,
      };
    } catch (error) {
      this.logger.error('Failed to get system health metrics', error.stack);
      return null;
    }
  }

  private async flushMetrics(): Promise<void> {
    if (this.metricsBuffer.length === 0) {
      return;
    }

    const metricsToFlush = [...this.metricsBuffer];
    this.metricsBuffer = [];

    try {
      await this.prisma.metric.createMany({
        data: metricsToFlush.map((metric) => ({
          name: metric.name,
          value: metric.value,
          tags: metric.tags || {},
          timestamp: metric.timestamp || new Date(),
        })),
      });

      this.logger.debug(`Flushed ${metricsToFlush.length} metrics to database`);
    } catch (error) {
      this.logger.error('Failed to flush metrics', error.stack);
      // Put metrics back in buffer to retry later
      this.metricsBuffer.unshift(...metricsToFlush);
    }
  }

  private aggregateMetrics(metrics: any[]) {
    if (metrics.length === 0) return null;

    const values = metrics.map((m) => m.value);
    return {
      count: values.length,
      avg: values.reduce((a, b) => a + b, 0) / values.length,
      min: Math.min(...values),
      max: Math.max(...values),
      p95: this.percentile(values, 0.95),
      p99: this.percentile(values, 0.99),
    };
  }

  private aggregateAIMetrics(metrics: any[]) {
    const tokenMetrics = metrics.filter((m) => m.name === 'ai_tokens_used');
    const costMetrics = metrics.filter((m) => m.name === 'ai_cost');

    return {
      totalTokens: tokenMetrics.reduce((sum, m) => sum + m.value, 0),
      totalCost: costMetrics.reduce((sum, m) => sum + m.value, 0),
      requestCount: tokenMetrics.length,
    };
  }

  private async getErrorRate(startDate: Date, endDate: Date): Promise<number> {
    const totalRequests = await this.prisma.metric.count({
      where: {
        name: 'api_request_count',
        timestamp: { gte: startDate, lte: endDate },
      },
    });

    const errorRequests = await this.prisma.metric.count({
      where: {
        name: 'api_request_count',
        tags: {
          path: ['$.success'],
          equals: 'false',
        },
        timestamp: { gte: startDate, lte: endDate },
      },
    });

    return totalRequests > 0 ? (errorRequests / totalRequests) * 100 : 0;
  }

  private async getAverageResponseTime(
    startDate: Date,
    endDate: Date,
  ): Promise<number> {
    const result = await this.prisma.metric.aggregate({
      where: {
        name: 'api_request_duration',
        timestamp: { gte: startDate, lte: endDate },
      },
      _avg: {
        value: true,
      },
    });

    return result._avg.value || 0;
  }

  private async getCacheHitRate(
    startDate: Date,
    endDate: Date,
  ): Promise<number> {
    const totalCacheOps = await this.prisma.metric.count({
      where: {
        name: 'cache_operation',
        OR: [
          {
            tags: {
              path: ['operation'],
              equals: 'hit',
            },
          },
          {
            tags: {
              path: ['operation'],
              equals: 'miss',
            },
          },
        ],
        timestamp: { gte: startDate, lte: endDate },
      },
    });

    const cacheHits = await this.prisma.metric.count({
      where: {
        name: 'cache_operation',
        tags: {
          path: ['$.operation'],
          equals: 'hit',
        },
        timestamp: { gte: startDate, lte: endDate },
      },
    });

    return totalCacheOps > 0 ? (cacheHits / totalCacheOps) * 100 : 0;
  }

  private percentile(values: number[], p: number): number {
    const sorted = values.sort((a, b) => a - b);
    const index = Math.ceil(sorted.length * p) - 1;
    return sorted[index];
  }
}
