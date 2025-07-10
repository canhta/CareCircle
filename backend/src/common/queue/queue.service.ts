import { Injectable, Logger } from '@nestjs/common';
import { InjectQueue } from '@nestjs/bull';
import { Queue } from 'bull';

export interface QueueJobOptions {
  delay?: number;
  attempts?: number;
  priority?: number;
  removeOnComplete?: boolean | number;
  removeOnFail?: boolean | number;
}

@Injectable()
export class QueueService {
  private readonly logger = new Logger(QueueService.name);

  constructor(
    @InjectQueue('health-data-processing')
    private healthDataQueue: Queue,
    @InjectQueue('health-analytics')
    private healthAnalyticsQueue: Queue,
    @InjectQueue('notifications')
    private notificationsQueue: Queue,
    @InjectQueue('ai-insights')
    private aiInsightsQueue: Queue,
  ) {}

  /**
   * Add health metric validation job to queue
   */
  async addHealthMetricValidation(
    data: {
      userId: string;
      metricId: string;
      metricType: string;
      value: number;
      timestamp: Date;
    },
    options?: QueueJobOptions,
  ) {
    try {
      const job = await this.healthDataQueue.add('validate-metric', data, {
        delay: options?.delay || 0,
        attempts: options?.attempts || 3,
        priority: options?.priority || 0,
        removeOnComplete: options?.removeOnComplete ?? 10,
        removeOnFail: options?.removeOnFail ?? 5,
      });

      this.logger.log(
        `Added health metric validation job ${job.id} for user ${data.userId}`,
      );

      return job;
    } catch (error) {
      this.logger.error(
        `Failed to add health metric validation job:`,
        error.stack,
      );
      throw error;
    }
  }

  /**
   * Add health insights generation job to queue
   */
  async addHealthInsightsGeneration(
    data: {
      userId: string;
      metricType?: string;
      startDate?: Date;
      endDate?: Date;
    },
    options?: QueueJobOptions,
  ) {
    try {
      const job = await this.healthDataQueue.add('generate-insights', data, {
        delay: options?.delay || 0,
        attempts: options?.attempts || 3,
        priority: options?.priority || 0,
        removeOnComplete: options?.removeOnComplete ?? 10,
        removeOnFail: options?.removeOnFail ?? 5,
      });

      this.logger.log(
        `Added health insights generation job ${job.id} for user ${data.userId}`,
      );

      return job;
    } catch (error) {
      this.logger.error(
        `Failed to add health insights generation job:`,
        error.stack,
      );
      throw error;
    }
  }

  /**
   * Add anomaly detection job to queue
   */
  async addAnomalyDetection(
    data: {
      userId: string;
      metricType?: string;
    },
    options?: QueueJobOptions,
  ) {
    try {
      const job = await this.healthDataQueue.add('detect-anomalies', data, {
        delay: options?.delay || 0,
        attempts: options?.attempts || 3,
        priority: options?.priority || 1, // Higher priority for anomaly detection
        removeOnComplete: options?.removeOnComplete ?? 10,
        removeOnFail: options?.removeOnFail ?? 5,
      });

      this.logger.log(
        `Added anomaly detection job ${job.id} for user ${data.userId}`,
      );

      return job;
    } catch (error) {
      this.logger.error(`Failed to add anomaly detection job:`, error.stack);
      throw error;
    }
  }

  /**
   * Schedule recurring health analytics jobs
   */
  async scheduleRecurringAnalytics(
    userId: string,
    cronPattern: string = '0 2 * * *', // Daily at 2 AM
  ) {
    try {
      // Schedule daily insights generation
      const job = await this.healthAnalyticsQueue.add(
        'generate-daily-insights',
        { userId },
        {
          repeat: { cron: cronPattern },
          removeOnComplete: 5,
          removeOnFail: 3,
        },
      );

      this.logger.log(
        `Scheduled recurring analytics job ${job.id} for user ${userId}`,
      );

      return job;
    } catch (error) {
      this.logger.error(`Failed to schedule recurring analytics:`, error.stack);
      throw error;
    }
  }

  /**
   * Get queue statistics
   */
  async getQueueStats() {
    try {
      const [
        healthDataStats,
        healthAnalyticsStats,
        notificationsStats,
        aiInsightsStats,
      ] = await Promise.all([
        this.getQueueInfo(this.healthDataQueue),
        this.getQueueInfo(this.healthAnalyticsQueue),
        this.getQueueInfo(this.notificationsQueue),
        this.getQueueInfo(this.aiInsightsQueue),
      ]);

      return {
        healthData: healthDataStats,
        healthAnalytics: healthAnalyticsStats,
        notifications: notificationsStats,
        aiInsights: aiInsightsStats,
      };
    } catch (error) {
      this.logger.error(`Failed to get queue statistics:`, error.stack);
      throw error;
    }
  }

  private async getQueueInfo(queue: Queue) {
    const [waiting, active, completed, failed, delayed] = await Promise.all([
      queue.getWaiting(),
      queue.getActive(),
      queue.getCompleted(),
      queue.getFailed(),
      queue.getDelayed(),
    ]);

    return {
      name: queue.name,
      waiting: waiting.length,
      active: active.length,
      completed: completed.length,
      failed: failed.length,
      delayed: delayed.length,
    };
  }
}
