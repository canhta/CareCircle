import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { MilvusClient, DataType, MetricType } from '@zilliz/milvus2-sdk-node';
import { OpenAIService } from './openai.service';

export interface VietnameseMedicalDocument {
  id: string;
  content: string;
  title: string;
  source: 'vinmec' | 'bachmai' | 'moh' | 'traditional_medicine' | 'pharmaceutical';
  language: 'vietnamese' | 'english' | 'mixed';
  medicalSpecialty: string;
  documentType: 'article' | 'guideline' | 'research' | 'traditional_recipe' | 'drug_info';
  keywords: string[];
  lastUpdated: Date;
  embedding?: number[];
  metadata: Record<string, any>;
}

export interface VectorSearchResult {
  id: string;
  score: number;
  document: VietnameseMedicalDocument;
}

export interface VietnameseMedicalQuery {
  query: string;
  language: 'vietnamese' | 'english' | 'mixed';
  medicalSpecialty?: string;
  documentTypes?: string[];
  sources?: string[];
  topK?: number;
  scoreThreshold?: number;
}

@Injectable()
export class VectorDatabaseService implements OnModuleInit {
  private readonly logger = new Logger(VectorDatabaseService.name);
  private milvusClient: MilvusClient;
  private readonly collectionName = 'vietnamese_medical_knowledge';
  private readonly embeddingDimension = 1536; // OpenAI ada-002

  constructor(
    private readonly configService: ConfigService,
    private readonly openaiService: OpenAIService,
  ) {}

  async onModuleInit() {
    await this.initializeMilvusConnection();
    await this.ensureCollectionExists();
  }

  private async initializeMilvusConnection() {
    try {
      const milvusUrl = this.configService.get<string>('MILVUS_URL', 'localhost:19530');
      
      this.milvusClient = new MilvusClient({
        address: milvusUrl,
        ssl: false,
        username: this.configService.get<string>('MILVUS_USERNAME'),
        password: this.configService.get<string>('MILVUS_PASSWORD'),
      });

      // Test connection
      const health = await this.milvusClient.checkHealth();
      this.logger.log(`Milvus connection established: ${health.isHealthy ? 'Healthy' : 'Unhealthy'}`);
    } catch (error) {
      this.logger.error('Failed to connect to Milvus:', error);
      throw new Error('Vector database connection failed');
    }
  }

  private async ensureCollectionExists() {
    try {
      const hasCollection = await this.milvusClient.hasCollection({
        collection_name: this.collectionName,
      });

      if (!hasCollection.value) {
        await this.createVietnameseMedicalCollection();
      } else {
        this.logger.log(`Collection ${this.collectionName} already exists`);
      }
    } catch (error) {
      this.logger.error('Error checking/creating collection:', error);
      throw error;
    }
  }

  private async createVietnameseMedicalCollection() {
    try {
      const schema = {
        collection_name: this.collectionName,
        description: 'Vietnamese medical knowledge base with traditional and modern medicine',
        fields: [
          {
            name: 'id',
            description: 'Document unique identifier',
            data_type: DataType.VarChar,
            max_length: 100,
            is_primary_key: true,
          },
          {
            name: 'content',
            description: 'Document content text',
            data_type: DataType.VarChar,
            max_length: 65535,
          },
          {
            name: 'title',
            description: 'Document title',
            data_type: DataType.VarChar,
            max_length: 500,
          },
          {
            name: 'source',
            description: 'Document source',
            data_type: DataType.VarChar,
            max_length: 50,
          },
          {
            name: 'language',
            description: 'Document language',
            data_type: DataType.VarChar,
            max_length: 20,
          },
          {
            name: 'medical_specialty',
            description: 'Medical specialty category',
            data_type: DataType.VarChar,
            max_length: 100,
          },
          {
            name: 'document_type',
            description: 'Type of medical document',
            data_type: DataType.VarChar,
            max_length: 50,
          },
          {
            name: 'keywords',
            description: 'Document keywords as JSON array',
            data_type: DataType.VarChar,
            max_length: 1000,
          },
          {
            name: 'last_updated',
            description: 'Last update timestamp',
            data_type: DataType.Int64,
          },
          {
            name: 'embedding',
            description: 'Document embedding vector',
            data_type: DataType.FloatVector,
            dim: this.embeddingDimension,
          },
          {
            name: 'metadata',
            description: 'Additional metadata as JSON',
            data_type: DataType.VarChar,
            max_length: 2000,
          },
        ],
      };

      await this.milvusClient.createCollection(schema);
      this.logger.log(`Created collection: ${this.collectionName}`);

      // Create index for vector search
      await this.createVectorIndex();
    } catch (error) {
      this.logger.error('Error creating Vietnamese medical collection:', error);
      throw error;
    }
  }

  private async createVectorIndex() {
    try {
      const indexParams = {
        collection_name: this.collectionName,
        field_name: 'embedding',
        index_type: 'IVF_FLAT',
        metric_type: MetricType.COSINE,
        params: { nlist: 1024 },
      };

      await this.milvusClient.createIndex(indexParams);
      this.logger.log('Created vector index for Vietnamese medical knowledge');

      // Load collection into memory
      await this.milvusClient.loadCollection({
        collection_name: this.collectionName,
      });
      this.logger.log('Loaded collection into memory');
    } catch (error) {
      this.logger.error('Error creating vector index:', error);
      throw error;
    }
  }

  async addDocument(document: VietnameseMedicalDocument): Promise<void> {
    try {
      // Generate embedding if not provided
      if (!document.embedding) {
        document.embedding = await this.generateEmbedding(document.content);
      }

      const data = [
        {
          id: document.id,
          content: document.content,
          title: document.title,
          source: document.source,
          language: document.language,
          medical_specialty: document.medicalSpecialty,
          document_type: document.documentType,
          keywords: JSON.stringify(document.keywords),
          last_updated: document.lastUpdated.getTime(),
          embedding: document.embedding,
          metadata: JSON.stringify(document.metadata),
        },
      ];

      await this.milvusClient.insert({
        collection_name: this.collectionName,
        data,
      });

      this.logger.log(`Added document: ${document.id}`);
    } catch (error) {
      this.logger.error(`Error adding document ${document.id}:`, error);
      throw error;
    }
  }

  async searchSimilarDocuments(query: VietnameseMedicalQuery): Promise<VectorSearchResult[]> {
    try {
      // Generate embedding for query
      const queryEmbedding = await this.generateEmbedding(query.query);

      // Build search filter
      const filter = this.buildSearchFilter(query);

      const searchParams = {
        collection_name: this.collectionName,
        vector: queryEmbedding,
        filter,
        limit: query.topK || 10,
        output_fields: [
          'id', 'content', 'title', 'source', 'language', 
          'medical_specialty', 'document_type', 'keywords', 
          'last_updated', 'metadata'
        ],
        params: { nprobe: 16 },
      };

      const results = await this.milvusClient.search(searchParams);
      
      return results.results.map((result: any) => ({
        id: result.id,
        score: result.score,
        document: this.mapToDocument(result),
      })).filter(result => result.score >= (query.scoreThreshold || 0.7));
    } catch (error) {
      this.logger.error('Error searching documents:', error);
      throw error;
    }
  }

  private buildSearchFilter(query: VietnameseMedicalQuery): string {
    const filters: string[] = [];

    if (query.language) {
      filters.push(`language == "${query.language}"`);
    }

    if (query.medicalSpecialty) {
      filters.push(`medical_specialty == "${query.medicalSpecialty}"`);
    }

    if (query.documentTypes && query.documentTypes.length > 0) {
      const typeFilter = query.documentTypes.map(type => `document_type == "${type}"`).join(' || ');
      filters.push(`(${typeFilter})`);
    }

    if (query.sources && query.sources.length > 0) {
      const sourceFilter = query.sources.map(source => `source == "${source}"`).join(' || ');
      filters.push(`(${sourceFilter})`);
    }

    return filters.length > 0 ? filters.join(' && ') : '';
  }

  private mapToDocument(result: any): VietnameseMedicalDocument {
    return {
      id: result.id,
      content: result.content,
      title: result.title,
      source: result.source,
      language: result.language,
      medicalSpecialty: result.medical_specialty,
      documentType: result.document_type,
      keywords: JSON.parse(result.keywords || '[]'),
      lastUpdated: new Date(result.last_updated),
      metadata: JSON.parse(result.metadata || '{}'),
    };
  }

  private async generateEmbedding(text: string): Promise<number[]> {
    try {
      return await this.openaiService.generateEmbedding(text);
    } catch (error) {
      this.logger.error('Error generating embedding:', error);
      throw error;
    }
  }

  async getCollectionStats(): Promise<any> {
    try {
      const stats = await this.milvusClient.getCollectionStatistics({
        collection_name: this.collectionName,
      });
      return stats;
    } catch (error) {
      this.logger.error('Error getting collection stats:', error);
      throw error;
    }
  }
}
