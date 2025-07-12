import {
  Controller,
  Post,
  Body,
  UseGuards,
  Request,
  Get,
  Param,
  Logger,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
// import { FirebaseAuthGuard } from '../../../auth/guards/firebase-auth.guard';
// import { FirebaseUserPayload } from '../../../auth/interfaces/firebase-user.interface';
import { VietnameseMedicalAgentService } from '../../infrastructure/services/vietnamese-medical-agent.service';
import { FirecrawlVietnameseHealthcareService } from '../../infrastructure/services/firecrawl-vietnamese-healthcare.service';
import { VectorDatabaseService } from '../../infrastructure/services/vector-database.service';

export class VietnameseHealthcareQueryDto {
  message: string;
  culturalContext?: 'traditional' | 'modern' | 'mixed';
  languagePreference?: 'vietnamese' | 'english' | 'mixed';
  medicalHistory?: string[];
  currentMedications?: string[];
  allergies?: string[];
  urgentQuery?: boolean;
}

export class CrawlRequestDto {
  sites?: string[];
  forceRefresh?: boolean;
}

export class KnowledgeSearchDto {
  query: string;
  language?: 'vietnamese' | 'english' | 'mixed';
  medicalSpecialty?: string;
  documentTypes?: string[];
  topK?: number;
}

@Controller('api/v1/ai-assistant/vietnamese-healthcare')
// @UseGuards(FirebaseAuthGuard)
export class VietnameseHealthcareAgentController {
  private readonly logger = new Logger(
    VietnameseHealthcareAgentController.name,
  );

  constructor(
    private readonly vietnameseMedicalAgentService: VietnameseMedicalAgentService,
    private readonly firecrawlService: FirecrawlVietnameseHealthcareService,
    private readonly vectorDatabaseService: VectorDatabaseService,
  ) {}

  @Post('chat')
  async processVietnameseHealthcareQuery(
    @Body() queryDto: VietnameseHealthcareQueryDto,
    @Request() req: { user: { uid: string } },
  ) {
    try {
      this.logger.log(`Vietnamese healthcare query from user: ${req.user.uid}`);

      if (!queryDto.message || queryDto.message.trim().length === 0) {
        throw new HttpException('Message is required', HttpStatus.BAD_REQUEST);
      }

      // Prepare patient context
      const patientContext = {
        userId: req.user.uid,
        sessionId: `session_${Date.now()}`,
        medicalHistory: queryDto.medicalHistory || [],
        currentMedications: queryDto.currentMedications || [],
        allergies: queryDto.allergies || [],
        culturalContext: queryDto.culturalContext || 'mixed',
        languagePreference: queryDto.languagePreference || 'vietnamese',
        urgentQuery: queryDto.urgentQuery || false,
      };

      // Process the query using the enhanced Vietnamese Medical Agent
      const response =
        await this.vietnameseMedicalAgentService.processVietnameseMedicalQuery(
          queryDto.message,
          patientContext,
        );

      this.logger.log(
        `Vietnamese healthcare response generated with confidence: ${response.confidence}`,
      );

      return {
        success: true,
        data: {
          response: response.response,
          responseLanguage: response.responseLanguage,
          traditionalMedicineAdvice: response.traditionalMedicineAdvice,
          modernMedicineAdvice: response.modernMedicineAdvice,
          culturalConsiderations: response.culturalConsiderations,
          recommendedActions: response.recommendedActions,
          urgencyLevel: response.urgencyLevel,
          confidence: response.confidence,
          requiresPhysicianReview: response.requiresPhysicianReview,
          metadata: {
            agentType: 'VIETNAMESE_MEDICAL',
            processingTime: Date.now(),
            culturalContext: patientContext.culturalContext,
            languagePreference: patientContext.languagePreference,
          },
        },
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      this.logger.error('Error processing Vietnamese healthcare query:', error);
      throw new HttpException(
        'Failed to process Vietnamese healthcare query',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Post('crawl')
  async crawlVietnameseHealthcareSites(
    @Body() crawlDto: CrawlRequestDto,
    @Request() req: { user: { uid: string } },
  ) {
    try {
      this.logger.log(
        `Vietnamese healthcare crawl requested by user: ${req.user.uid}`,
      );

      // Start crawling Vietnamese healthcare sites
      const crawlResults =
        await this.firecrawlService.crawlAllVietnameseHealthcareSites();

      return {
        success: true,
        data: {
          crawlResults,
          totalSites: crawlResults.length,
          totalDocuments: crawlResults.reduce(
            (sum, result) => sum + result.documentsStored,
            0,
          ),
          crawlTime: crawlResults.reduce(
            (sum, result) => sum + result.crawlTime,
            0,
          ),
        },
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      this.logger.error('Error crawling Vietnamese healthcare sites:', error);
      throw new HttpException(
        'Failed to crawl Vietnamese healthcare sites',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Post('search-knowledge')
  async searchVietnameseMedicalKnowledge(
    @Body() searchDto: KnowledgeSearchDto,
    @Request() req: { user: { uid: string } },
  ) {
    try {
      this.logger.log(
        `Vietnamese medical knowledge search by user: ${req.user.uid}`,
      );

      if (!searchDto.query || searchDto.query.trim().length === 0) {
        throw new HttpException(
          'Search query is required',
          HttpStatus.BAD_REQUEST,
        );
      }

      const searchResults =
        await this.vectorDatabaseService.searchSimilarDocuments({
          query: searchDto.query,
          language: searchDto.language || 'vietnamese',
          medicalSpecialty: searchDto.medicalSpecialty,
          documentTypes: searchDto.documentTypes,
          topK: searchDto.topK || 10,
          scoreThreshold: 0.7,
        });

      return {
        success: true,
        data: {
          results: searchResults.map((result) => ({
            id: result.id,
            title: result.document.title,
            content: result.document.content.substring(0, 500) + '...',
            source: result.document.source,
            medicalSpecialty: result.document.medicalSpecialty,
            documentType: result.document.documentType,
            score: result.score,
            keywords: result.document.keywords,
          })),
          totalResults: searchResults.length,
          query: searchDto.query,
        },
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      this.logger.error('Error searching Vietnamese medical knowledge:', error);
      throw new HttpException(
        'Failed to search Vietnamese medical knowledge',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('status')
  async getVietnameseHealthcareStatus(
    @Request() req: { user: { uid: string } },
  ) {
    try {
      // Get status from all services
      const firecrawlStatus = await this.firecrawlService.getCrawlStatus();
      const vectorDbStats =
        await this.vectorDatabaseService.getCollectionStats();

      return {
        success: true,
        data: {
          services: {
            vietnameseMedicalAgent: {
              status: 'active',
              capabilities: [
                'vietnamese_consultation',
                'traditional_medicine',
                'cultural_context',
              ],
            },
            firecrawlService: firecrawlStatus,
            vectorDatabase: {
              status: 'active',
              stats: vectorDbStats,
            },
          },
          features: {
            vietnameseLanguageSupport: true,
            traditionalMedicineIntegration: true,
            culturalContextAwareness: true,
            phiProtection: true,
            knowledgeBaseSearch: true,
            emergencyDetection: true,
          },
        },
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      this.logger.error('Error getting Vietnamese healthcare status:', error);
      throw new HttpException(
        'Failed to get Vietnamese healthcare status',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('crawl-status')
  async getCrawlStatus(@Request() req: { user: { uid: string } }) {
    try {
      const status = await this.firecrawlService.getCrawlStatus();

      return {
        success: true,
        data: status,
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      this.logger.error('Error getting crawl status:', error);
      throw new HttpException(
        'Failed to get crawl status',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('knowledge-stats')
  async getKnowledgeBaseStats(@Request() req: { user: { uid: string } }) {
    try {
      const stats = await this.vectorDatabaseService.getCollectionStats();

      return {
        success: true,
        data: {
          collectionStats: stats,
          supportedLanguages: ['vietnamese', 'english', 'mixed'],
          supportedSources: [
            'vinmec',
            'bachmai',
            'moh',
            'traditional_medicine',
            'pharmaceutical',
          ],
          documentTypes: [
            'article',
            'guideline',
            'research',
            'traditional_recipe',
            'drug_info',
          ],
        },
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      this.logger.error('Error getting knowledge base stats:', error);
      throw new HttpException(
        'Failed to get knowledge base stats',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
