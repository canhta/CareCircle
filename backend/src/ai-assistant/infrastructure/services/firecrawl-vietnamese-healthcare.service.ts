import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import FirecrawlApp, {
  CrawlParams,
  CrawlStatusResponse,
} from '@mendable/firecrawl-js';
import {
  VectorDatabaseService,
  VietnameseMedicalDocument,
} from './vector-database.service';
import { PHIProtectionService } from '../../../common/compliance/phi-protection.service';

export interface VietnameseHealthcareSite {
  name: string;
  baseUrl: string;
  type:
    | 'hospital'
    | 'government'
    | 'traditional_medicine'
    | 'pharmaceutical'
    | 'research';
  crawlConfig: {
    limit: number;
    excludePaths: string[];
    includePaths?: string[];
    onlyMainContent: boolean;
  };
  contentSelectors?: {
    title?: string;
    content?: string;
    author?: string;
    publishDate?: string;
  };
}

export interface CrawlResult {
  siteId: string;
  siteName: string;
  documentsProcessed: number;
  documentsStored: number;
  errors: string[];
  crawlTime: number;
  lastCrawled: Date;
}

@Injectable()
export class FirecrawlVietnameseHealthcareService implements OnModuleInit {
  private readonly logger = new Logger(
    FirecrawlVietnameseHealthcareService.name,
  );
  private firecrawlApp: FirecrawlApp;

  // Vietnamese healthcare websites configuration
  private readonly vietnameseHealthcareSites: VietnameseHealthcareSite[] = [
    {
      name: 'Vinmec Hospital',
      baseUrl: 'https://www.vinmec.com/vie/bai-viet/',
      type: 'hospital',
      crawlConfig: {
        limit: 200,
        excludePaths: [
          'tin-tuc/*',
          'khuyen-mai/*',
          'dich-vu/*',
          'lien-he/*',
          'tim-kiem/*',
        ],
        includePaths: [
          'bai-viet/suc-khoe-tong-quat/*',
          'bai-viet/benh-hoc/*',
          'bai-viet/dinh-duong/*',
          'bai-viet/cham-soc-suc-khoe/*',
        ],
        onlyMainContent: true,
      },
    },
    {
      name: 'Bach Mai Hospital',
      baseUrl: 'https://benhvienbachmai.vn',
      type: 'hospital',
      crawlConfig: {
        limit: 150,
        excludePaths: ['tin-tuc/*', 'thong-bao/*', 'lien-he/*', 'dang-ky/*'],
        onlyMainContent: true,
      },
    },
    {
      name: 'Ministry of Health Vietnam',
      baseUrl: 'https://moh.gov.vn',
      type: 'government',
      crawlConfig: {
        limit: 100,
        excludePaths: ['tin-tuc/*', 'thong-bao/*', 'van-ban/*', 'lien-he/*'],
        includePaths: [
          'chuong-trinh-muc-tieu/*',
          'hoat-dong-chuyen-mon/*',
          'phong-chong-dich-benh/*',
        ],
        onlyMainContent: true,
      },
    },
    {
      name: 'Vietnamese Traditional Medicine Institute',
      baseUrl: 'https://yhoccotruyen.vn',
      type: 'traditional_medicine',
      crawlConfig: {
        limit: 100,
        excludePaths: ['tin-tuc/*', 'lien-he/*', 'dang-ky/*'],
        includePaths: [
          'thuoc-nam/*',
          'bai-thuoc/*',
          'chua-benh/*',
          'dinh-duong/*',
        ],
        onlyMainContent: true,
      },
    },
    {
      name: 'Vietnam Pharmaceutical Information',
      baseUrl: 'https://drugbank.vn',
      type: 'pharmaceutical',
      crawlConfig: {
        limit: 300,
        excludePaths: ['tin-tuc/*', 'lien-he/*', 'dang-ky/*'],
        includePaths: [
          'thuoc/*',
          'hoat-chat/*',
          'tuong-tac-thuoc/*',
          'lieu-dung/*',
        ],
        onlyMainContent: true,
      },
    },
  ];

  constructor(
    private readonly configService: ConfigService,
    private readonly vectorDatabaseService: VectorDatabaseService,
    private readonly phiProtectionService: PHIProtectionService,
  ) {}

  async onModuleInit() {
    await this.initializeFirecrawl();
  }

  private async initializeFirecrawl() {
    try {
      const apiKey = this.configService.get<string>('FIRECRAWL_API_KEY');

      if (!apiKey) {
        this.logger.warn(
          'Firecrawl API key not configured. Vietnamese healthcare crawling disabled.',
        );
        return;
      }

      this.firecrawlApp = new FirecrawlApp({ apiKey });
      this.logger.log('Firecrawl Vietnamese Healthcare service initialized');
    } catch (error) {
      this.logger.error('Failed to initialize Firecrawl:', error);
      throw new Error('Firecrawl initialization failed');
    }
  }

  async crawlAllVietnameseHealthcareSites(): Promise<CrawlResult[]> {
    this.logger.log('Starting comprehensive Vietnamese healthcare sites crawl');

    const results: CrawlResult[] = [];

    for (const site of this.vietnameseHealthcareSites) {
      try {
        const result = await this.crawlSite(site);
        results.push(result);

        // Add delay between sites to be respectful
        await this.delay(5000);
      } catch (error) {
        this.logger.error(`Failed to crawl ${site.name}:`, error);
        results.push({
          siteId: this.generateSiteId(site),
          siteName: site.name,
          documentsProcessed: 0,
          documentsStored: 0,
          errors: [error.message],
          crawlTime: 0,
          lastCrawled: new Date(),
        });
      }
    }

    this.logger.log(
      `Completed crawling ${results.length} Vietnamese healthcare sites`,
    );
    return results;
  }

  async crawlSite(site: VietnameseHealthcareSite): Promise<CrawlResult> {
    const startTime = Date.now();
    const siteId = this.generateSiteId(site);

    this.logger.log(`Starting crawl for ${site.name}: ${site.baseUrl}`);

    try {
      // Configure crawl parameters
      const crawlParams: CrawlParams = {
        limit: site.crawlConfig.limit,
        scrapeOptions: {
          formats: ['markdown', 'html'],
          onlyMainContent: site.crawlConfig.onlyMainContent,
          includePaths: site.crawlConfig.includePaths,
        },
      };

      // Perform the crawl
      const crawlResponse = (await this.firecrawlApp.crawlUrl(
        site.baseUrl,
        crawlParams,
      )) as CrawlStatusResponse;

      if (!crawlResponse.success || !crawlResponse.data) {
        throw new Error(
          `Crawl failed for ${site.name}: ${(crawlResponse as any).error || 'Unknown error'}`,
        );
      }

      // Process crawled documents
      const processedDocuments = await this.processAndStoreCrawledData(
        crawlResponse.data,
        site,
      );

      const crawlTime = Date.now() - startTime;

      this.logger.log(
        `Successfully crawled ${site.name}: ${processedDocuments.stored}/${processedDocuments.total} documents stored`,
      );

      return {
        siteId,
        siteName: site.name,
        documentsProcessed: processedDocuments.total,
        documentsStored: processedDocuments.stored,
        errors: processedDocuments.errors,
        crawlTime,
        lastCrawled: new Date(),
      };
    } catch (error) {
      this.logger.error(`Error crawling ${site.name}:`, error);
      throw error;
    }
  }

  private async processAndStoreCrawledData(
    crawlData: any[],
    site: VietnameseHealthcareSite,
  ): Promise<{ total: number; stored: number; errors: string[] }> {
    let stored = 0;
    const errors: string[] = [];

    for (const item of crawlData) {
      try {
        // Extract content and metadata
        const content = item.markdown || item.html || '';
        const metadata = item.metadata || {};

        if (!content || content.length < 100) {
          errors.push(
            `Skipped document with insufficient content: ${metadata.sourceURL || 'unknown'}`,
          );
          continue;
        }

        // Detect and protect PHI
        const phiResult =
          await this.phiProtectionService.detectAndMaskPHI(content);

        if (
          phiResult.riskLevel === 'critical' ||
          phiResult.riskLevel === 'high'
        ) {
          errors.push(
            `Skipped document with high PHI risk: ${metadata.sourceURL || 'unknown'}`,
          );
          continue;
        }

        // Create Vietnamese medical document
        const document: VietnameseMedicalDocument = {
          id: this.generateDocumentId(metadata.sourceURL || '', site.name),
          content: phiResult.maskedText,
          title: metadata.title || this.extractTitleFromContent(content),
          source: this.mapSiteTypeToSource(site.type),
          language: this.detectLanguage(content),
          medicalSpecialty: await this.extractMedicalSpecialty(content),
          documentType: this.determineDocumentType(content, metadata),
          keywords: await this.extractKeywords(content),
          lastUpdated: new Date(),
          metadata: {
            originalUrl: metadata.sourceURL,
            siteName: site.name,
            siteType: site.type,
            crawledAt: new Date().toISOString(),
            phiDetected: phiResult.detectedPHI.length > 0,
            phiRiskLevel: phiResult.riskLevel,
            ...metadata,
          },
        };

        // Store in vector database
        await this.vectorDatabaseService.addDocument(document);
        stored++;

        this.logger.debug(`Stored document: ${document.title}`);
      } catch (error) {
        errors.push(`Failed to process document: ${error.message}`);
        this.logger.warn(`Failed to process document:`, error);
      }
    }

    return {
      total: crawlData.length,
      stored,
      errors,
    };
  }

  private generateSiteId(site: VietnameseHealthcareSite): string {
    return `${site.type}_${site.name.toLowerCase().replace(/\s+/g, '_')}`;
  }

  private generateDocumentId(url: string, siteName: string): string {
    const urlHash = Buffer.from(url).toString('base64').substring(0, 8);
    const timestamp = Date.now().toString(36);
    return `${siteName.toLowerCase().replace(/\s+/g, '_')}_${urlHash}_${timestamp}`;
  }

  private mapSiteTypeToSource(
    type: string,
  ): 'vinmec' | 'bachmai' | 'moh' | 'traditional_medicine' | 'pharmaceutical' {
    const mapping = {
      hospital: 'vinmec',
      government: 'moh',
      traditional_medicine: 'traditional_medicine',
      pharmaceutical: 'pharmaceutical',
      research: 'vinmec',
    };
    return mapping[type] || 'vinmec';
  }

  private detectLanguage(content: string): 'vietnamese' | 'english' | 'mixed' {
    const vietnamesePattern =
      /[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]/i;
    const englishPattern = /[a-zA-Z]/;

    const hasVietnamese = vietnamesePattern.test(content);
    const hasEnglish = englishPattern.test(content);

    if (hasVietnamese && hasEnglish) return 'mixed';
    if (hasVietnamese) return 'vietnamese';
    return 'english';
  }

  private async extractMedicalSpecialty(content: string): Promise<string> {
    const specialties = [
      'tim mạch',
      'nội khoa',
      'ngoại khoa',
      'sản phụ khoa',
      'nhi khoa',
      'thần kinh',
      'ung bướu',
      'da liễu',
      'mắt',
      'tai mũi họng',
      'răng hàm mặt',
      'chấn thương chỉnh hình',
      'tâm thần',
      'dinh dưỡng',
      'y học cổ truyền',
      'phục hồi chức năng',
    ];

    const contentLower = content.toLowerCase();
    for (const specialty of specialties) {
      if (contentLower.includes(specialty)) {
        return specialty;
      }
    }

    return 'tổng quát';
  }

  private determineDocumentType(
    content: string,
    metadata: any,
  ): 'article' | 'guideline' | 'research' | 'traditional_recipe' | 'drug_info' {
    const contentLower = content.toLowerCase();

    if (
      contentLower.includes('hướng dẫn') ||
      contentLower.includes('quy trình')
    ) {
      return 'guideline';
    }
    if (
      contentLower.includes('nghiên cứu') ||
      contentLower.includes('báo cáo')
    ) {
      return 'research';
    }
    if (
      contentLower.includes('bài thuốc') ||
      contentLower.includes('thuốc nam')
    ) {
      return 'traditional_recipe';
    }
    if (contentLower.includes('thuốc') || contentLower.includes('dược phẩm')) {
      return 'drug_info';
    }

    return 'article';
  }

  private async extractKeywords(content: string): Promise<string[]> {
    // Basic keyword extraction - can be enhanced with Vietnamese NLP service
    const keywords: string[] = [];
    const medicalTerms = [
      'bệnh',
      'triệu chứng',
      'điều trị',
      'thuốc',
      'chẩn đoán',
      'phòng ngừa',
      'sức khỏe',
      'y tế',
      'bác sĩ',
      'bệnh viện',
      'khám bệnh',
      'xét nghiệm',
    ];

    const contentLower = content.toLowerCase();
    for (const term of medicalTerms) {
      if (contentLower.includes(term)) {
        keywords.push(term);
      }
    }

    return keywords.slice(0, 10); // Limit to 10 keywords
  }

  private extractTitleFromContent(content: string): string {
    // Extract title from first line or heading
    const lines = content.split('\n').filter((line) => line.trim());
    if (lines.length > 0) {
      const firstLine = lines[0].replace(/^#+\s*/, '').trim();
      return firstLine.substring(0, 200);
    }
    return 'Untitled Document';
  }

  private delay(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  async getCrawlStatus(): Promise<any> {
    // Return status of last crawl operations
    return {
      service: 'firecrawl-vietnamese-healthcare',
      status: 'active',
      sitesConfigured: this.vietnameseHealthcareSites.length,
      lastCrawl: new Date(),
    };
  }
}
