import { Injectable, Logger } from '@nestjs/common';
import {
  BaseHealthcareAgent,
  HealthcareContext,
  AgentResponse,
  AgentCapability,
} from './base-healthcare.agent';
import { PHIProtectionService } from '../../../common/compliance/phi-protection.service';
import { VietnameseNLPIntegrationService } from '../../infrastructure/services/vietnamese-nlp-integration.service';

export interface VietnameseMedicalContext extends HealthcareContext {
  traditionalMedicineHistory?: string[];
  modernMedicineHistory?: string[];
  culturalPreferences?: {
    preferTraditional: boolean;
    acceptsModern: boolean;
    familyInfluence: boolean;
  };
  regionalDialect?: string;
  familyMedicalTraditions?: string[];
}

export interface TraditionalMedicineRecommendation {
  herbName: string;
  vietnameseName: string;
  scientificName?: string;
  preparation: string;
  dosage: string;
  duration: string;
  contraindications: string[];
  interactions: string[];
  evidenceLevel: 'traditional' | 'limited_scientific' | 'well_studied';
  safetyRating: 'safe' | 'caution' | 'avoid';
}

export interface IntegrationGuidance {
  canCombineWithModern: boolean;
  requiredMonitoring: string[];
  potentialInteractions: string[];
  recommendedSequencing: string;
  physicianConsultationRequired: boolean;
}

@Injectable()
export class VietnameseMedicalAgent extends BaseHealthcareAgent {
  protected readonly logger = new Logger(VietnameseMedicalAgent.name);

  // Traditional Vietnamese medicine knowledge base
  private readonly traditionalMedicines = {
    gừng: {
      scientificName: 'Zingiber officinale',
      uses: ['nausea', 'digestive issues', 'cold symptoms'],
      preparation: 'tea, fresh slices, powder',
      contraindications: ['blood thinners', 'gallstones'],
      safetyRating: 'safe' as const,
    },
    nghệ: {
      scientificName: 'Curcuma longa',
      uses: ['inflammation', 'digestive issues', 'wound healing'],
      preparation: 'powder, fresh root, capsules',
      contraindications: ['blood thinners', 'gallbladder disease'],
      safetyRating: 'safe' as const,
    },
    'cam thảo': {
      scientificName: 'Glycyrrhiza glabra',
      uses: ['cough', 'sore throat', 'digestive issues'],
      preparation: 'tea, decoction, powder',
      contraindications: [
        'high blood pressure',
        'heart disease',
        'kidney disease',
      ],
      safetyRating: 'caution' as const,
    },
    'nhân sâm': {
      scientificName: 'Panax ginseng',
      uses: ['fatigue', 'immune support', 'cognitive function'],
      preparation: 'tea, extract, capsules',
      contraindications: [
        'high blood pressure',
        'diabetes medications',
        'blood thinners',
      ],
      safetyRating: 'caution' as const,
    },
  };

  constructor(
    phiProtectionService: PHIProtectionService,
    vietnameseNLPService: VietnameseNLPIntegrationService,
  ) {
    super('vietnamese_medical', phiProtectionService, vietnameseNLPService, {
      modelName: 'gpt-4',
      temperature: 0.3, // Slightly higher for cultural nuance
      maxTokens: 2500,
    });
  }

  protected defineCapabilities(): AgentCapability[] {
    return [
      {
        name: 'Traditional Vietnamese Medicine',
        description:
          'Provide guidance on Vietnamese traditional medicine (thuốc nam)',
        confidence: 0.85,
        requiresPhysicianReview: true,
        maxSeverityLevel: 6,
        supportedLanguages: ['vietnamese', 'mixed'],
        medicalSpecialties: [
          'traditional_medicine',
          'vietnamese_medicine',
          'herbal_medicine',
        ],
      },
      {
        name: 'Cultural Healthcare Context',
        description:
          'Understand Vietnamese cultural context in healthcare decisions',
        confidence: 0.9,
        requiresPhysicianReview: false,
        maxSeverityLevel: 5,
        supportedLanguages: ['vietnamese', 'mixed'],
        medicalSpecialties: ['cultural_medicine', 'patient_education'],
      },
      {
        name: 'Traditional-Modern Integration',
        description: 'Guide integration of traditional and modern medicine',
        confidence: 0.75,
        requiresPhysicianReview: true,
        maxSeverityLevel: 7,
        supportedLanguages: ['vietnamese', 'english', 'mixed'],
        medicalSpecialties: ['integrative_medicine', 'traditional_medicine'],
      },
    ];
  }

  protected async processAgentSpecificQuery(
    query: string,
    context: HealthcareContext,
  ): Promise<AgentResponse> {
    const startTime = Date.now();
    try {
      this.logger.log(
        `Processing Vietnamese medical query: ${query.substring(0, 50)}...`,
      );

      const vietnameseContext = context as VietnameseMedicalContext;

      // Enhanced context with Vietnamese NLP analysis
      const enhancedContext = await this.enhanceContextWithVietnameseNLP(
        query,
        context,
      );

      // Analyze traditional medicine components
      const traditionalAnalysis = await this.analyzeTraditionalMedicineQuery(
        query,
        enhancedContext,
      );

      // Generate cultural context guidance
      const culturalGuidance = await this.generateCulturalGuidance(
        query,
        enhancedContext,
      );

      // Assess integration with modern medicine
      const integrationGuidance = await this.assessModernIntegration(
        traditionalAnalysis,
        enhancedContext,
      );

      // Generate comprehensive Vietnamese medical response
      const response = await this.generateVietnameseMedicalResponse(
        query,
        traditionalAnalysis,
        culturalGuidance,
        integrationGuidance,
        enhancedContext,
      );

      return {
        agentType: 'vietnamese_medical',
        response,
        confidence: this.calculateVietnameseConfidence(
          traditionalAnalysis,
          enhancedContext,
        ),
        urgencyLevel: (enhancedContext.vietnameseNLPAnalysis as any)?.urgencyAnalysis?.urgency_level || 0.3,
        requiresEscalation: integrationGuidance.physicianConsultationRequired,
        metadata: {
          processingTime: Date.now() - startTime,
          modelUsed: 'gpt-4',
          tokensConsumed: 0,
          costUsd: 0,
          phiDetected: false,
          complianceFlags: [],
          traditionalMedicineRecommendations:
            traditionalAnalysis.recommendations,
          culturalContext: culturalGuidance,
          integrationGuidance,
          vietnameseNLPAnalysis: enhancedContext.vietnameseNLPAnalysis,
          languageDetected:
            enhancedContext.vietnameseNLPAnalysis?.languageMetrics.isVietnamese,
          traditionalMedicineTerms:
            enhancedContext.vietnameseNLPAnalysis?.traditionalMedicineTerms,
        },
      };
    } catch (error) {
      this.logger.error('Vietnamese medical agent processing failed:', error);
      throw new Error(`Vietnamese medical processing failed: ${error.message}`);
    }
  }

  private async analyzeTraditionalMedicineQuery(
    query: string,
    context: HealthcareContext,
  ): Promise<{
    recommendations: TraditionalMedicineRecommendation[];
    warnings: string[];
  }> {
    const recommendations: TraditionalMedicineRecommendation[] = [];
    const warnings: string[] = [];

    // Extract traditional medicine terms from Vietnamese NLP analysis
    const traditionalTerms =
      context.vietnameseNLPAnalysis?.traditionalMedicineTerms || [];

    // Analyze each mentioned traditional medicine
    for (const term of traditionalTerms) {
      const medicine = this.traditionalMedicines[term.toLowerCase()];
      if (medicine) {
        recommendations.push({
          herbName: term,
          vietnameseName: term,
          scientificName: medicine.scientificName,
          preparation: medicine.preparation,
          dosage: 'Theo hướng dẫn của thầy thuốc hoặc kinh nghiệm gia đình',
          duration: 'Theo triệu chứng, thường 7-14 ngày',
          contraindications: medicine.contraindications,
          interactions: this.checkTraditionalInteractions(
            term,
            context.currentMedications || [],
          ),
          evidenceLevel: 'traditional',
          safetyRating: medicine.safetyRating,
        });

        // Add warnings for high-risk combinations
        if (medicine.safetyRating === 'caution') {
          warnings.push(
            `Cần thận trọng khi sử dụng ${term}, đặc biệt nếu đang dùng thuốc tây`,
          );
        }
      }
    }

    return { recommendations, warnings };
  }

  private async generateCulturalGuidance(
    query: string,
    context: HealthcareContext,
  ): Promise<{
    culturalConsiderations: string[];
    familyInvolvement: string[];
    respectfulApproach: string[];
  }> {
    const isTraditionalFocused =
      context.vietnameseNLPAnalysis?.culturalContext.isTraditionalMedicine;

    return {
      culturalConsiderations: [
        'Tôn trọng kinh nghiệm y học cổ truyền của gia đình',
        'Cân nhắc ảnh hưởng của văn hóa địa phương',
        isTraditionalFocused
          ? 'Ưu tiên phương pháp điều trị truyền thống'
          : 'Kết hợp y học hiện đại và cổ truyền',
      ],
      familyInvolvement: [
        'Tham khảo ý kiến người lớn tuổi trong gia đình',
        'Thảo luận với gia đình về phương pháp điều trị',
        'Tôn trọng quyết định chung của gia đình',
      ],
      respectfulApproach: [
        'Không phủ nhận hoàn toàn y học cổ truyền',
        'Giải thích rõ ràng về lợi ích của y học hiện đại',
        'Tìm cách kết hợp an toàn cả hai phương pháp',
      ],
    };
  }

  private async assessModernIntegration(
    traditionalAnalysis: any,
    context: HealthcareContext,
  ): Promise<IntegrationGuidance> {
    const hasModernMedications = (context.currentMedications || []).length > 0;
    const hasHighRiskHerbs = traditionalAnalysis.recommendations.some(
      (rec: TraditionalMedicineRecommendation) =>
        rec.safetyRating === 'caution',
    );

    return {
      canCombineWithModern: !hasHighRiskHerbs || !hasModernMedications,
      requiredMonitoring: hasHighRiskHerbs
        ? [
            'Theo dõi tác dụng phụ',
            'Kiểm tra định kỳ với bác sĩ',
            'Theo dõi tương tác thuốc',
          ]
        : [],
      potentialInteractions: this.identifyPotentialInteractions(
        traditionalAnalysis,
        context,
      ),
      recommendedSequencing: 'Tham khảo bác sĩ trước khi kết hợp',
      physicianConsultationRequired: hasHighRiskHerbs && hasModernMedications,
    };
  }

  private async generateVietnameseMedicalResponse(
    query: string,
    traditionalAnalysis: any,
    culturalGuidance: any,
    integrationGuidance: IntegrationGuidance,
    context: HealthcareContext,
  ): Promise<string> {
    let response = '';

    // Greeting in Vietnamese
    response += '🌿 **Tư vấn Y học Cổ truyền Việt Nam**\n\n';

    // Traditional medicine recommendations
    if (traditionalAnalysis.recommendations.length > 0) {
      response += '**Các loại thuốc nam được đề xuất:**\n';
      traditionalAnalysis.recommendations.forEach(
        (rec: TraditionalMedicineRecommendation) => {
          response += `• **${rec.herbName}** (${rec.scientificName || 'N/A'})\n`;
          response += `  - Cách dùng: ${rec.preparation}\n`;
          response += `  - Liều lượng: ${rec.dosage}\n`;
          if (rec.contraindications.length > 0) {
            response += `  - Chống chỉ định: ${rec.contraindications.join(', ')}\n`;
          }
          response += '\n';
        },
      );
    }

    // Cultural considerations
    response += '**Lưu ý văn hóa:**\n';
    culturalGuidance.culturalConsiderations.forEach((consideration: string) => {
      response += `• ${consideration}\n`;
    });
    response += '\n';

    // Integration guidance
    if (integrationGuidance.physicianConsultationRequired) {
      response +=
        '⚠️ **Quan trọng**: Cần tham khảo ý kiến bác sĩ trước khi kết hợp thuốc nam với thuốc tây.\n\n';
    }

    // Safety warnings
    if (traditionalAnalysis.warnings.length > 0) {
      response += '**Cảnh báo an toàn:**\n';
      traditionalAnalysis.warnings.forEach((warning: string) => {
        response += `⚠️ ${warning}\n`;
      });
      response += '\n';
    }

    // Medical disclaimer in Vietnamese
    response +=
      '**Lưu ý quan trọng**: Thông tin này chỉ mang tính chất tham khảo dựa trên kiến thức y học cổ truyền. ';
    response +=
      'Luôn tham khảo ý kiến bác sĩ hoặc thầy thuốc có kinh nghiệm trước khi sử dụng bất kỳ loại thuốc nào.';

    return response;
  }

  private checkTraditionalInteractions(
    herb: string,
    medications: string[],
  ): string[] {
    const interactions: string[] = [];
    const medicine = this.traditionalMedicines[herb.toLowerCase()];

    if (medicine && medications.length > 0) {
      // Check for known interactions
      medications.forEach((med) => {
        if (
          med.toLowerCase().includes('warfarin') &&
          medicine.contraindications.includes('blood thinners')
        ) {
          interactions.push(
            'Có thể tăng nguy cơ chảy máu khi dùng với thuốc chống đông máu',
          );
        }
        if (med.toLowerCase().includes('metformin') && herb === 'nhân sâm') {
          interactions.push('Có thể ảnh hưởng đến đường huyết');
        }
      });
    }

    return interactions;
  }

  private identifyPotentialInteractions(
    traditionalAnalysis: any,
    context: HealthcareContext,
  ): string[] {
    const interactions: string[] = [];

    traditionalAnalysis.recommendations.forEach(
      (rec: TraditionalMedicineRecommendation) => {
        if (rec.interactions.length > 0) {
          interactions.push(...rec.interactions);
        }
      },
    );

    return interactions;
  }

  private calculateVietnameseConfidence(
    traditionalAnalysis: any,
    context: HealthcareContext,
  ): number {
    let confidence = 0.8;

    // Higher confidence for Vietnamese language queries
    if (context.vietnameseNLPAnalysis?.languageMetrics.isVietnamese) {
      confidence += 0.1;
    }

    // Higher confidence for traditional medicine focus
    if (context.vietnameseNLPAnalysis?.culturalContext.isTraditionalMedicine) {
      confidence += 0.05;
    }

    // Lower confidence for complex integration scenarios
    if (
      traditionalAnalysis.recommendations.some(
        (rec: TraditionalMedicineRecommendation) =>
          rec.safetyRating === 'caution',
      )
    ) {
      confidence -= 0.1;
    }

    return Math.min(Math.max(confidence, 0.5), 1.0);
  }
}
