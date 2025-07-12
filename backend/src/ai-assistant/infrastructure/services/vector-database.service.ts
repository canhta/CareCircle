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
    await this.populateVietnameseMedicalKnowledge();
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

  /**
   * Populate the vector database with Vietnamese medical knowledge
   */
  private async populateVietnameseMedicalKnowledge(): Promise<void> {
    try {
      this.logger.log('Checking if Vietnamese medical knowledge needs to be populated...');

      // Check if collection already has data
      const stats = await this.getCollectionStats();
      if (stats.row_count && stats.row_count > 0) {
        this.logger.log(`Collection already contains ${stats.row_count} documents`);
        return;
      }

      this.logger.log('Populating Vietnamese medical knowledge base...');

      // Vietnamese medical knowledge base
      const medicalKnowledge = await this.getVietnameseMedicalKnowledgeBase();

      // Process and insert documents in batches
      const batchSize = 50;
      for (let i = 0; i < medicalKnowledge.length; i += batchSize) {
        const batch = medicalKnowledge.slice(i, i + batchSize);
        await this.insertDocumentBatch(batch);
        this.logger.log(`Inserted batch ${Math.floor(i / batchSize) + 1}/${Math.ceil(medicalKnowledge.length / batchSize)}`);
      }

      this.logger.log(`Successfully populated ${medicalKnowledge.length} Vietnamese medical documents`);

    } catch (error) {
      this.logger.error('Failed to populate Vietnamese medical knowledge:', error);
      // Don't throw error to prevent application startup failure
    }
  }

  /**
   * Get Vietnamese medical knowledge base
   */
  private async getVietnameseMedicalKnowledgeBase(): Promise<VietnameseMedicalDocument[]> {
    return [
      // Traditional Medicine Knowledge
      {
        id: 'traditional_001',
        title: 'Gừng (Zingiber officinale) - Tác dụng và cách sử dụng',
        content: 'Gừng là một loại thuốc nam phổ biến trong y học cổ truyền Việt Nam. Gừng có tác dụng ấm bụng, tiêu hóa, chống nôn, và giảm viêm. Cách sử dụng: Có thể dùng gừng tươi thái lát pha trà, hoặc sử dụng bột gừng khô. Liều lượng: 2-4g mỗi ngày. Chống chỉ định: Người có bệnh về máu, đang dùng thuốc chống đông máu.',
        source: 'traditional_medicine',
        language: 'vietnamese',
        medicalSpecialty: 'traditional_medicine',
        documentType: 'traditional_recipe',
        keywords: ['gừng', 'thuốc nam', 'tiêu hóa', 'chống nôn', 'y học cổ truyền'],
        lastUpdated: new Date(),
        metadata: {
          scientificName: 'Zingiber officinale',
          safetyRating: 'safe',
          evidenceLevel: 'traditional',
        },
      },
      {
        id: 'traditional_002',
        title: 'Nghệ (Curcuma longa) - Công dụng và liều dùng',
        content: 'Nghệ là vị thuốc quý trong y học cổ truyền, có tác dụng chống viêm, giảm đau, hỗ trợ tiêu hóa và lành vết thương. Nghệ chứa curcumin có tác dụng chống oxy hóa mạnh. Cách dùng: Bột nghệ pha với nước ấm, hoặc nghệ tươi nấu với sữa. Liều lượng: 1-3g bột nghệ mỗi ngày. Lưu ý: Không dùng cho người có sỏi mật, đang dùng thuốc chống đông máu.',
        source: 'traditional_medicine',
        language: 'vietnamese',
        medicalSpecialty: 'traditional_medicine',
        documentType: 'traditional_recipe',
        keywords: ['nghệ', 'curcumin', 'chống viêm', 'tiêu hóa', 'thuốc nam'],
        lastUpdated: new Date(),
        metadata: {
          scientificName: 'Curcuma longa',
          safetyRating: 'safe',
          evidenceLevel: 'well_studied',
        },
      },
      {
        id: 'emergency_001',
        title: 'Nhận biết và xử lý cấp cứu tim mạch',
        content: 'Các dấu hiệu cảnh báo đau tim: đau ngực dữ dội, đau lan ra cánh tay trái, khó thở, đổ mồ hôi lạnh, buồn nôn. Xử lý: Gọi 115 ngay lập tức, cho bệnh nhân nằm nghiêng, nới lỏng quần áo, không cho ăn uống. Nếu có aspirin và bệnh nhân không dị ứng, có thể cho nhai 1 viên 300mg. Thực hiện CPR nếu bệnh nhân ngừng thở.',
        source: 'moh',
        language: 'vietnamese',
        medicalSpecialty: 'emergency_medicine',
        documentType: 'guideline',
        keywords: ['cấp cứu', 'đau tim', 'tim mạch', '115', 'CPR'],
        lastUpdated: new Date(),
        metadata: {
          urgencyLevel: 'critical',
          evidenceLevel: 'high',
        },
      },
      {
        id: 'medication_001',
        title: 'Paracetamol - Liều dùng và tương tác thuốc',
        content: 'Paracetamol (Acetaminophen) là thuốc giảm đau, hạ sốt phổ biến. Liều dùng người lớn: 500-1000mg mỗi 4-6 giờ, tối đa 4000mg/ngày. Trẻ em: 10-15mg/kg cân nặng mỗi 4-6 giờ. Tương tác: Cần thận trọng khi dùng với rượu, thuốc chống đông máu. Chống chỉ định: Bệnh gan nặng, dị ứng paracetamol. Tác dụng phụ: Hiếm gặp ở liều điều trị, có thể gây độc gan nếu quá liều.',
        source: 'pharmaceutical',
        language: 'vietnamese',
        medicalSpecialty: 'pharmacology',
        documentType: 'drug_info',
        keywords: ['paracetamol', 'acetaminophen', 'giảm đau', 'hạ sốt', 'tương tác thuốc'],
        lastUpdated: new Date(),
        metadata: {
          drugClass: 'analgesic_antipyretic',
          safetyRating: 'safe',
          prescriptionRequired: false,
        },
      },
      {
        id: 'clinical_001',
        title: 'Chẩn đoán và điều trị cao huyết áp',
        content: 'Cao huyết áp được chẩn đoán khi huyết áp ≥140/90 mmHg đo ít nhất 2 lần khác nhau. Phân loại: Độ 1 (140-159/90-99), Độ 2 (160-179/100-109), Độ 3 (≥180/110). Điều trị không dùng thuốc: Giảm muối, tăng vận động, giảm cân, hạn chế rượu bia. Điều trị bằng thuốc: ACE inhibitor, ARB, thuốc lợi tiểu, chẹn kênh canxi. Theo dõi: Đo huyết áp định kỳ, xét nghiệm chức năng thận.',
        source: 'vinmec',
        language: 'vietnamese',
        medicalSpecialty: 'cardiology',
        documentType: 'guideline',
        keywords: ['cao huyết áp', 'huyết áp', 'tim mạch', 'ACE inhibitor', 'chẩn đoán'],
        lastUpdated: new Date(),
        metadata: {
          evidenceLevel: 'high',
          guidelineSource: 'vietnamese_cardiology_society',
        },
      },
      {
        id: 'diabetes_001',
        title: 'Quản lý đái tháo đường type 2',
        content: 'Đái tháo đường type 2 được chẩn đoán khi glucose máu lúc đói ≥7.0 mmol/L hoặc HbA1c ≥6.5%. Mục tiêu điều trị: HbA1c <7%, glucose máu lúc đói 4-7 mmol/L. Điều trị: Thay đổi lối sống (ăn uống, vận động), Metformin là thuốc đầu tay, có thể phối hợp insulin khi cần. Biến chứng: Bệnh thận, mắt, thần kinh, tim mạch. Theo dõi: HbA1c 3-6 tháng/lần, khám mắt hàng năm.',
        source: 'bachmai',
        language: 'vietnamese',
        medicalSpecialty: 'endocrinology',
        documentType: 'guideline',
        keywords: ['đái tháo đường', 'diabetes', 'glucose', 'HbA1c', 'metformin'],
        lastUpdated: new Date(),
        metadata: {
          evidenceLevel: 'high',
          chronicDisease: true,
        },
      },
      {
        id: 'respiratory_001',
        title: 'Hen suyễn - Nhận biết và xử trí',
        content: 'Hen suyễn là bệnh viêm mãn tính đường hô hấp. Triệu chứng: Khó thở, thở khò khè, ho khan, tức ngực. Yếu tố kích thích: Dị nguyên, khói thuốc, không khí lạnh, stress. Điều trị: Thuốc giãn phế quản (Salbutamol), thuốc chống viêm (corticosteroid hít). Cấp cứu: Dùng thuốc xịt giãn phế quản, ngồi thẳng, thở chậm sâu. Nếu không đỡ sau 15 phút, đến bệnh viện ngay.',
        source: 'vinmec',
        language: 'vietnamese',
        medicalSpecialty: 'pulmonology',
        documentType: 'guideline',
        keywords: ['hen suyễn', 'asthma', 'khó thở', 'salbutamol', 'corticosteroid'],
        lastUpdated: new Date(),
        metadata: {
          chronicDisease: true,
          emergencyPotential: true,
        },
      },
      {
        id: 'pediatric_001',
        title: 'Sốt ở trẻ em - Xử trí và theo dõi',
        content: 'Sốt ở trẻ em được định nghĩa là nhiệt độ ≥38°C. Nguyên nhân: Nhiễm khuẩn, virus, vaccine. Xử trí: Hạ sốt bằng paracetamol (10-15mg/kg) hoặc ibuprofen (5-10mg/kg), chườm mát, cho uống nhiều nước. Dấu hiệu nguy hiểm: Sốt >39°C ở trẻ <3 tháng, co giật, khó thở, nôn nhiều, da tím tái. Khi nào đến bệnh viện: Sốt kéo dài >3 ngày, có dấu hiệu nguy hiểm.',
        source: 'bachmai',
        language: 'vietnamese',
        medicalSpecialty: 'pediatrics',
        documentType: 'guideline',
        keywords: ['sốt', 'trẻ em', 'paracetamol', 'ibuprofen', 'co giật'],
        lastUpdated: new Date(),
        metadata: {
          ageGroup: 'pediatric',
          urgencyLevel: 'medium',
        },
      },
    ];
  }

  /**
   * Insert a batch of documents into the vector database
   */
  private async insertDocumentBatch(documents: VietnameseMedicalDocument[]): Promise<void> {
    try {
      // Generate embeddings for all documents
      const documentsWithEmbeddings = await Promise.all(
        documents.map(async (doc) => {
          const embedding = await this.openaiService.generateEmbedding(
            `${doc.title} ${doc.content} ${doc.keywords.join(' ')}`
          );
          return { ...doc, embedding };
        })
      );

      // Prepare data for insertion
      const insertData = documentsWithEmbeddings.map(doc => ({
        id: doc.id,
        title: doc.title,
        content: doc.content,
        source: doc.source,
        language: doc.language,
        medical_specialty: doc.medicalSpecialty,
        document_type: doc.documentType,
        keywords: doc.keywords.join(','),
        last_updated: doc.lastUpdated.toISOString(),
        metadata: JSON.stringify(doc.metadata),
        embedding: doc.embedding,
      }));

      // Insert into Milvus
      await this.milvusClient.insert({
        collection_name: this.collectionName,
        data: insertData,
      });

    } catch (error) {
      this.logger.error('Failed to insert document batch:', error);
      throw error;
    }
  }
}
