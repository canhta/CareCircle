import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { MilvusClient, DataType, MetricType } from '@zilliz/milvus2-sdk-node';

export interface UserBehaviorVector {
  id: string;
  userId: string;
  vector: number[];
  metadata: {
    timestamp: number;
    notificationType: string;
    action: string;
    timeOfDay: number;
    dayOfWeek: number;
    responseTime?: number;
    deviceType?: string;
  };
}

export interface SimilarUser {
  userId: string;
  similarity: number;
  metadata: Record<string, any>;
}

@Injectable()
export class MilvusService implements OnModuleInit {
  private readonly logger = new Logger(MilvusService.name);
  private client: MilvusClient;
  private readonly collectionName = 'user_behavior_vectors';
  private readonly dimension = 128; // Vector dimension for user behavior embeddings

  constructor(private readonly configService: ConfigService) {}

  async onModuleInit() {
    await this.connect();
    await this.initializeCollection();
  }

  /**
   * Connect to Milvus database
   */
  private async connect(): Promise<void> {
    try {
      const host = this.configService.get<string>('MILVUS_HOST', 'localhost');
      const port = this.configService.get<string>('MILVUS_PORT', '19530');

      this.client = new MilvusClient({
        address: `${host}:${port}`,
      });

      // Test connection
      const response = await this.client.checkHealth();
      this.logger.log(`Connected to Milvus: ${JSON.stringify(response)}`);
    } catch (error) {
      this.logger.error(
        `Failed to connect to Milvus: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  /**
   * Initialize collection for user behavior vectors
   */
  private async initializeCollection(): Promise<void> {
    try {
      // Check if collection exists
      const hasCollection = await this.client.hasCollection({
        collection_name: this.collectionName,
      });

      if (!hasCollection.value) {
        // Create collection
        await this.client.createCollection({
          collection_name: this.collectionName,
          fields: [
            {
              name: 'id',
              data_type: DataType.VarChar,
              max_length: 100,
              is_primary_key: true,
            },
            {
              name: 'userId',
              data_type: DataType.VarChar,
              max_length: 100,
            },
            {
              name: 'vector',
              data_type: DataType.FloatVector,
              dim: this.dimension,
            },
            {
              name: 'timestamp',
              data_type: DataType.Int64,
            },
            {
              name: 'notificationType',
              data_type: DataType.VarChar,
              max_length: 50,
            },
            {
              name: 'action',
              data_type: DataType.VarChar,
              max_length: 20,
            },
            {
              name: 'timeOfDay',
              data_type: DataType.Int32,
            },
            {
              name: 'dayOfWeek',
              data_type: DataType.Int32,
            },
            {
              name: 'responseTime',
              data_type: DataType.Int64,
            },
            {
              name: 'deviceType',
              data_type: DataType.VarChar,
              max_length: 20,
            },
          ],
        });

        // Create index for vector field
        await this.client.createIndex({
          collection_name: this.collectionName,
          field_name: 'vector',
          index_type: 'IVF_FLAT',
          metric_type: MetricType.COSINE,
          params: { nlist: 1024 },
        });

        // Load collection
        await this.client.loadCollection({
          collection_name: this.collectionName,
        });

        this.logger.log(
          `Created and loaded collection: ${this.collectionName}`,
        );
      } else {
        // Load existing collection
        await this.client.loadCollection({
          collection_name: this.collectionName,
        });
        this.logger.log(`Loaded existing collection: ${this.collectionName}`);
      }
    } catch (error) {
      this.logger.error(
        `Failed to initialize collection: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  /**
   * Store user behavior vector
   */
  async storeUserBehaviorVector(
    behaviorVector: UserBehaviorVector,
  ): Promise<void> {
    try {
      const data = {
        id: [behaviorVector.id],
        userId: [behaviorVector.userId],
        vector: [behaviorVector.vector],
        timestamp: [behaviorVector.metadata.timestamp],
        notificationType: [behaviorVector.metadata.notificationType],
        action: [behaviorVector.metadata.action],
        timeOfDay: [behaviorVector.metadata.timeOfDay],
        dayOfWeek: [behaviorVector.metadata.dayOfWeek],
        responseTime: [behaviorVector.metadata.responseTime || 0],
        deviceType: [behaviorVector.metadata.deviceType || ''],
      };

      await this.client.insert({
        collection_name: this.collectionName,
        data: [data],
      });

      this.logger.debug(
        `Stored behavior vector for user: ${behaviorVector.userId}`,
      );
    } catch (error) {
      this.logger.error(
        `Failed to store behavior vector: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  /**
   * Find similar users based on behavior patterns
   */
  async findSimilarUsers(
    userId: string,
    behaviorVector: number[],
    limit: number = 5,
  ): Promise<SimilarUser[]> {
    try {
      const searchResult = await this.client.search({
        collection_name: this.collectionName,
        vector: behaviorVector,
        filter: `userId != "${userId}"`, // Exclude the user themselves
        limit,
        output_fields: ['userId', 'timestamp', 'notificationType', 'action'],
        params: { nprobe: 10 },
      });

      const similarUsers: SimilarUser[] = searchResult.results.map(
        (result: any) => ({
          userId: result.userId,
          similarity: result.score,
          metadata: {
            timestamp: result.timestamp,
            notificationType: result.notificationType,
            action: result.action,
          },
        }),
      );

      this.logger.debug(
        `Found ${similarUsers.length} similar users for: ${userId}`,
      );
      return similarUsers;
    } catch (error) {
      this.logger.error(
        `Failed to find similar users: ${error.message}`,
        error.stack,
      );
      return [];
    }
  }

  /**
   * Get user behavior vectors
   */
  async getUserBehaviorVectors(
    userId: string,
    limit: number = 100,
  ): Promise<UserBehaviorVector[]> {
    try {
      const queryResult = await this.client.query({
        collection_name: this.collectionName,
        filter: `userId == "${userId}"`,
        output_fields: ['*'],
        limit,
      });

      const vectors: UserBehaviorVector[] = queryResult.data.map(
        (item: any) => ({
          id: item.id,
          userId: item.userId,
          vector: item.vector,
          metadata: {
            timestamp: item.timestamp,
            notificationType: item.notificationType,
            action: item.action,
            timeOfDay: item.timeOfDay,
            dayOfWeek: item.dayOfWeek,
            responseTime: item.responseTime,
            deviceType: item.deviceType,
          },
        }),
      );

      return vectors;
    } catch (error) {
      this.logger.error(
        `Failed to get user behavior vectors: ${error.message}`,
        error.stack,
      );
      return [];
    }
  }

  /**
   * Delete user behavior data (GDPR compliance)
   */
  async deleteUserData(userId: string): Promise<void> {
    try {
      await this.client.delete({
        collection_name: this.collectionName,
        filter: `userId == "${userId}"`,
      });

      this.logger.log(`Deleted behavior data for user: ${userId}`);
    } catch (error) {
      this.logger.error(
        `Failed to delete user data: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  /**
   * Get collection statistics
   */
  async getCollectionStats(): Promise<any> {
    try {
      const stats = await this.client.getCollectionStatistics({
        collection_name: this.collectionName,
      });

      return {
        collectionName: this.collectionName,
        rowCount: stats.data.row_count,
        dimension: this.dimension,
      };
    } catch (error) {
      this.logger.error(
        `Failed to get collection stats: ${error.message}`,
        error.stack,
      );
      return null;
    }
  }

  /**
   * Create behavior vector from user interaction data
   */
  createBehaviorVector(behaviorData: {
    timeOfDay: number;
    dayOfWeek: number;
    action: string;
    notificationType: string;
    responseTime?: number;
    deviceType?: string;
    recentActions?: string[];
  }): number[] {
    // Create a behavior vector by encoding various features
    const vector = new Array(this.dimension).fill(0);

    // Time features (0-23 hours -> first 24 dimensions)
    if (behaviorData.timeOfDay >= 0 && behaviorData.timeOfDay <= 23) {
      vector[behaviorData.timeOfDay] = 1.0;
    }

    // Day of week features (24-30 dimensions)
    if (behaviorData.dayOfWeek >= 0 && behaviorData.dayOfWeek <= 6) {
      vector[24 + behaviorData.dayOfWeek] = 1.0;
    }

    // Action type encoding (31-40 dimensions)
    const actionMap = {
      opened: 31,
      dismissed: 32,
      snoozed: 33,
      clicked: 34,
      ignored: 35,
    };
    if (actionMap[behaviorData.action]) {
      vector[actionMap[behaviorData.action]] = 1.0;
    }

    // Notification type encoding (41-50 dimensions)
    const notificationTypeMap = {
      medication_reminder: 41,
      health_check: 42,
      care_group_update: 43,
      system_alert: 44,
      ai_insight: 45,
    };
    if (notificationTypeMap[behaviorData.notificationType]) {
      vector[notificationTypeMap[behaviorData.notificationType]] = 1.0;
    }

    // Response time features (51-60 dimensions)
    if (behaviorData.responseTime) {
      // Normalize response time (in minutes) and map to dimensions
      const responseMinutes = Math.min(
        behaviorData.responseTime / (1000 * 60),
        60,
      );
      const responseIndex = Math.floor(responseMinutes / 6); // 6-minute buckets
      if (responseIndex < 10) {
        vector[51 + responseIndex] = responseMinutes / 60; // Normalized value
      }
    }

    // Device type encoding (61-65 dimensions)
    const deviceTypeMap: Record<string, number> = {
      mobile: 61,
      tablet: 62,
      desktop: 63,
      watch: 64,
    };
    if (behaviorData.deviceType && deviceTypeMap[behaviorData.deviceType]) {
      vector[deviceTypeMap[behaviorData.deviceType]] = 1.0;
    }

    // Recent action patterns (66-127 dimensions for sequence encoding)
    if (behaviorData.recentActions && behaviorData.recentActions.length > 0) {
      behaviorData.recentActions.slice(0, 10).forEach((action, index) => {
        if (actionMap[action] && index < 10) {
          vector[66 + index * 6 + (actionMap[action] - 31)] = 1.0;
        }
      });
    }

    // Normalize the vector
    const magnitude = Math.sqrt(
      vector.reduce((sum, val) => sum + val * val, 0),
    );
    if (magnitude > 0) {
      return vector.map((val) => val / magnitude);
    }

    return vector;
  }

  /**
   * Health check for Milvus connection
   */
  async healthCheck(): Promise<boolean> {
    try {
      const response = await this.client.checkHealth();
      return response.isHealthy;
    } catch (error) {
      this.logger.error(`Milvus health check failed: ${error.message}`);
      return false;
    }
  }
}
