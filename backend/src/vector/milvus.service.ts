import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { MilvusClient, DataType, MetricType } from '@zilliz/milvus2-sdk-node';

export interface UserInteractionVector {
  id: string;
  userId: string;
  checkInId: string;
  interactionType: string;
  timestamp: Date;
  vector: number[];
  metadata: {
    questionId?: string;
    responseText?: string;
    sentiment?: number;
    moodScore?: number;
    energyLevel?: number;
    sleepQuality?: number;
    painLevel?: number;
    stressLevel?: number;
    symptoms?: string[];
    riskScore?: number;
    category?: string;
  };
}

export interface SimilarInteraction {
  id: string;
  userId: string;
  similarity: number;
  metadata: UserInteractionVector['metadata'];
  timestamp: Date;
}

@Injectable()
export class MilvusService {
  private readonly logger = new Logger(MilvusService.name);
  private client: MilvusClient;
  private readonly collectionName = 'user_interactions';
  private readonly vectorDimension = 1536; // OpenAI embedding dimension
  private isInitialized = false;

  constructor(private configService: ConfigService) {
    void this.initializeMilvus();
  }

  private async initializeMilvus() {
    try {
      this.client = new MilvusClient({
        address: this.configService.get('MILVUS_HOST', 'localhost:19530'),
        username: this.configService.get('MILVUS_USER', ''),
        password: this.configService.get('MILVUS_PASSWORD', ''),
      });

      await this.createCollection();
      this.isInitialized = true;
      this.logger.log('Milvus service initialized successfully');
    } catch (error) {
      this.logger.error('Failed to initialize Milvus service', error);
      throw error;
    }
  }

  private async createCollection() {
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
            name: 'checkInId',
            data_type: DataType.VarChar,
            max_length: 100,
          },
          {
            name: 'interactionType',
            data_type: DataType.VarChar,
            max_length: 50,
          },
          {
            name: 'timestamp',
            data_type: DataType.Int64,
          },
          {
            name: 'vector',
            data_type: DataType.FloatVector,
            dim: this.vectorDimension,
          },
          {
            name: 'metadata',
            data_type: DataType.JSON,
          },
        ],
        index_params: {
          field_name: 'vector',
          index_type: 'IVF_FLAT',
          metric_type: MetricType.COSINE,
          params: { nlist: 100 },
        },
      });

      this.logger.log('Milvus collection created successfully');
    }

    // Load collection
    await this.client.loadCollection({
      collection_name: this.collectionName,
    });
  }

  async storeUserInteraction(
    interaction: UserInteractionVector,
  ): Promise<void> {
    if (!this.isInitialized) {
      throw new Error('Milvus service not initialized');
    }

    try {
      await this.client.insert({
        collection_name: this.collectionName,
        data: [
          {
            id: interaction.id,
            userId: interaction.userId,
            checkInId: interaction.checkInId,
            interactionType: interaction.interactionType,
            timestamp: interaction.timestamp.getTime(),
            vector: interaction.vector,
            metadata: interaction.metadata,
          },
        ],
      });

      this.logger.log(
        `Stored interaction vector for user ${interaction.userId}`,
      );
    } catch (error) {
      this.logger.error('Failed to store user interaction', error);
      throw error;
    }
  }

  async findSimilarInteractions(
    userId: string,
    queryVector: number[],
    topK: number = 10,
    includeOtherUsers: boolean = false,
  ): Promise<SimilarInteraction[]> {
    if (!this.isInitialized) {
      throw new Error('Milvus service not initialized');
    }

    try {
      const searchParams = {
        collection_name: this.collectionName,
        vectors: [queryVector],
        search_params: {
          anns_field: 'vector',
          topk: topK,
          metric_type: MetricType.COSINE,
          params: { nprobe: 10 },
        },
        output_fields: [
          'id',
          'userId',
          'checkInId',
          'interactionType',
          'timestamp',
          'metadata',
        ],
        filter: includeOtherUsers ? undefined : `userId == "${userId}"`,
      };

      const results = await this.client.search(searchParams);

      return results.results.map((result) => ({
        id: result.id,
        userId: result.userId as string,
        similarity: result.score,
        metadata: result.metadata as UserInteractionVector['metadata'],
        timestamp: new Date(result.timestamp as number),
      }));
    } catch (error) {
      this.logger.error('Failed to find similar interactions', error);
      throw error;
    }
  }

  async getUserInteractionHistory(
    userId: string,
    limit: number = 50,
    offset: number = 0,
  ): Promise<UserInteractionVector[]> {
    if (!this.isInitialized) {
      throw new Error('Milvus service not initialized');
    }

    try {
      const results = await this.client.query({
        collection_name: this.collectionName,
        filter: `userId == "${userId}"`,
        output_fields: [
          'id',
          'userId',
          'checkInId',
          'interactionType',
          'timestamp',
          'metadata',
        ],
        limit,
        offset,
      });

      return results.data.map((result) => ({
        id: result.id as string,
        userId: result.userId as string,
        checkInId: result.checkInId as string,
        interactionType: result.interactionType as string,
        timestamp: new Date(result.timestamp as number),
        vector: [], // Vector not included in query results for performance
        metadata: result.metadata as UserInteractionVector['metadata'],
      }));
    } catch (error) {
      this.logger.error('Failed to get user interaction history', error);
      throw error;
    }
  }

  async deleteUserInteractions(userId: string): Promise<void> {
    if (!this.isInitialized) {
      throw new Error('Milvus service not initialized');
    }

    try {
      await this.client.delete({
        collection_name: this.collectionName,
        filter: `userId == "${userId}"`,
      });

      this.logger.log(`Deleted interaction vectors for user ${userId}`);
    } catch (error) {
      this.logger.error('Failed to delete user interactions', error);
      throw error;
    }
  }

  async getInteractionStats(userId: string): Promise<{
    totalInteractions: number;
    averageSentiment: number;
    mostCommonSymptoms: string[];
    trendingTopics: string[];
  }> {
    if (!this.isInitialized) {
      throw new Error('Milvus service not initialized');
    }

    try {
      const interactions = await this.getUserInteractionHistory(userId, 100);

      const totalInteractions = interactions.length;
      const sentiments = interactions
        .map((i) => i.metadata.sentiment)
        .filter((s) => s !== undefined);

      const averageSentiment =
        sentiments.length > 0
          ? sentiments.reduce((sum, s) => sum + s, 0) / sentiments.length
          : 0;

      const allSymptoms = interactions
        .flatMap((i) => i.metadata.symptoms || [])
        .filter((s) => s);

      const symptomCounts = allSymptoms.reduce(
        (counts, symptom) => {
          counts[symptom] = (counts[symptom] || 0) + 1;
          return counts;
        },
        {} as Record<string, number>,
      );

      const mostCommonSymptoms = Object.entries(symptomCounts)
        .sort(([, a], [, b]) => b - a)
        .slice(0, 5)
        .map(([symptom]) => symptom);

      const categories = interactions
        .map((i) => i.metadata.category)
        .filter((c) => c);

      const categoryCounts = categories.reduce(
        (counts, category) => {
          if (category) {
            counts[category] = (counts[category] || 0) + 1;
          }
          return counts;
        },
        {} as Record<string, number>,
      );

      const trendingTopics = Object.entries(categoryCounts)
        .sort(([, a], [, b]) => b - a)
        .slice(0, 5)
        .map(([category]) => category);

      return {
        totalInteractions,
        averageSentiment,
        mostCommonSymptoms,
        trendingTopics,
      };
    } catch (error) {
      this.logger.error('Failed to get interaction stats', error);
      throw error;
    }
  }
}
