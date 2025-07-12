import { Injectable, Logger } from '@nestjs/common';
import { ChatOpenAI } from '@langchain/openai';
import { z } from 'zod';
import { PythonShell } from 'python-shell';
import * as crypto from 'crypto-js';
import {
  BaseHealthcareAgent,
  HealthcareContext,
  AgentResponse,
  AgentCapability,
} from '../../domain/agents/base-healthcare.agent';
import {
  VectorDatabaseService,
  VietnameseMedicalQuery,
} from './vector-database.service';
import { PHIProtectionService } from '../../../common/compliance/phi-protection.service';

export interface VietnameseMedicalContext {
  query: string;
  detectedLanguage: 'vietnamese' | 'english' | 'mixed';
  traditionalMedicineTerms: string[];
  modernMedicineTerms: string[];
  culturalContext: 'traditional' | 'modern' | 'mixed';
  medicalEntities: Array<{
    text: string;
    type: 'symptom' | 'disease' | 'medication' | 'treatment' | 'body_part';
    confidence: number;
  }>;
  urgencyIndicators: string[];
}

export interface VietnameseMedicalResponse {
  response: string;
  responseLanguage: 'vietnamese' | 'english';
  traditionalMedicineAdvice?: string;
  modernMedicineAdvice?: string;
  culturalConsiderations: string[];
  recommendedActions: string[];
  urgencyLevel: number;
  confidence: number;
  requiresPhysicianReview: boolean;
}

@Injectable()
export class VietnameseMedicalAgentService extends BaseHealthcareAgent {
  protected readonly logger = new Logger(VietnameseMedicalAgentService.name);

  constructor(
    phiProtectionService: PHIProtectionService,
    protected readonly vietnameseNLPService: any, // VietnameseNLPIntegrationService,
    private readonly vectorDatabaseService: VectorDatabaseService,
  ) {
    super('VIETNAMESE_MEDICAL', phiProtectionService, vietnameseNLPService, {
      modelName: 'gpt-4',
      temperature: 0.1,
      maxTokens: 2000,
    });
  }

  // Vietnamese medical terminology mappings
  private readonly vietnameseSymptoms = new Map([
    ['đau đầu', 'headache'],
    ['sốt', 'fever'],
    ['ho', 'cough'],
    ['đau bụng', 'stomach pain'],
    ['buồn nôn', 'nausea'],
    ['chóng mặt', 'dizziness'],
    ['mệt mỏi', 'fatigue'],
    ['khó thở', 'difficulty breathing'],
    ['đau ngực', 'chest pain'],
    ['tiêu chảy', 'diarrhea'],
  ]);

  private readonly traditionalMedicineTerms = new Map([
    ['thuốc nam', 'traditional Vietnamese medicine'],
    ['đông y', 'traditional Chinese medicine'],
    ['thảo dược', 'herbal medicine'],
    ['châm cứu', 'acupuncture'],
    ['bấm huyệt', 'acupressure'],
    ['gừng', 'ginger'],
    ['nghệ', 'turmeric'],
    ['lá lốt', 'wild betel leaf'],
    ['rau má', 'pennywort'],
    ['trà xanh', 'green tea'],
  ]);

  private readonly urgencyKeywords = [
    'cấp cứu',
    'khẩn cấp',
    'nguy hiểm',
    'đau dữ dội',
    'khó thở nặng',
    'mất ý thức',
    'co giật',
    'xuất huyết',
    'đau tim',
    'đột quỵ',
  ];

  protected defineCapabilities(): AgentCapability[] {
    return [
      {
        name: 'Vietnamese Medical Consultation',
        description:
          'Provide medical advice in Vietnamese with cultural context',
        confidence: 0.9,
        requiresPhysicianReview: true,
        maxSeverityLevel: 7,
        supportedLanguages: ['vietnamese', 'english', 'mixed'],
        medicalSpecialties: [
          'tổng quát',
          'nội khoa',
          'ngoại khoa',
          'sản phụ khoa',
          'nhi khoa',
          'tim mạch',
          'thần kinh',
          'da liễu',
          'y học cổ truyền',
        ],
      },
      {
        name: 'Traditional Medicine Integration',
        description:
          'Integrate Vietnamese traditional medicine (thuốc nam) with modern medicine',
        confidence: 0.8,
        requiresPhysicianReview: true,
        maxSeverityLevel: 5,
        supportedLanguages: ['vietnamese', 'mixed'],
        medicalSpecialties: [
          'y học cổ truyền',
          'dinh dưỡng',
          'phục hồi chức năng',
        ],
      },
      {
        name: 'Cultural Healthcare Context',
        description:
          'Provide healthcare advice considering Vietnamese cultural practices',
        confidence: 0.85,
        requiresPhysicianReview: false,
        maxSeverityLevel: 4,
        supportedLanguages: ['vietnamese', 'mixed'],
        medicalSpecialties: ['tổng quát', 'tâm thần', 'dinh dưỡng'],
      },
    ];
  }

  protected async processAgentSpecificQuery(
    query: string,
    context: HealthcareContext,
  ): Promise<AgentResponse> {
    try {
      this.logger.log(
        `Processing Vietnamese medical query: ${query.substring(0, 50)}...`,
      );

      // Search for relevant Vietnamese medical knowledge
      const knowledgeResults =
        await this.searchVietnameseMedicalKnowledge(query);

      // Analyze Vietnamese medical context
      const vietnameseContext =
        await this.analyzeVietnameseMedicalContext(query);

      // Enhanced Vietnamese NLP processing
      const nlpResult = await this.processWithVietnameseNLP(query);

      // Generate culturally appropriate response
      const response = await this.generateVietnameseMedicalResponse(
        query,
        vietnameseContext,
        context,
        knowledgeResults,
        nlpResult,
      );

      return {
        agentType: this.agentType,
        response: response.response,
        confidence: response.confidence,
        urgencyLevel: response.urgencyLevel,
        requiresEscalation: response.requiresPhysicianReview,
        recommendedActions: response.recommendedActions,
        metadata: {
          processingTime: 0, // Will be set by base class
          modelUsed: 'gpt-4',
          tokensConsumed: 0, // Estimate based on response length
          costUsd: 0, // Calculate based on tokens
          phiDetected: false, // Will be set by base class
          complianceFlags: [],
          medicalEntities: this.extractMedicalEntities(query),
          culturalConsiderations: response.culturalConsiderations,
          traditionalMedicineReferences:
            this.extractTraditionalMedicineReferences(response.response),
        },
      };
    } catch (error) {
      this.logger.error('Error processing Vietnamese medical query:', error);
      throw new Error('Failed to process Vietnamese medical query');
    }
  }

  private async searchVietnameseMedicalKnowledge(query: string) {
    try {
      const searchQuery: VietnameseMedicalQuery = {
        query,
        language: this.detectLanguage(query),
        topK: 5,
        scoreThreshold: 0.7,
      };

      return await this.vectorDatabaseService.searchSimilarDocuments(
        searchQuery,
      );
    } catch (error) {
      this.logger.warn(
        'Vector database search failed, continuing without knowledge base:',
        error,
      );
      return [];
    }
  }

  private extractTraditionalMedicineReferences(response: string): string[] {
    const traditionalTerms = [
      'thuốc nam',
      'đông y',
      'y học cổ truyền',
      'bài thuốc',
      'thảo dược',
      'châm cứu',
      'bấm huyệt',
      'giác hơi',
      'xoa bóp',
      'âm dương',
      'ngũ hành',
    ];

    const references: string[] = [];
    const responseLower = response.toLowerCase();

    for (const term of traditionalTerms) {
      if (responseLower.includes(term)) {
        references.push(term);
      }
    }

    return references;
  }

  async processVietnameseMedicalQuery(
    query: string,
    patientContext?: any,
  ): Promise<VietnameseMedicalResponse> {
    try {
      this.logger.log(
        `Processing Vietnamese medical query: ${query.substring(0, 50)}...`,
      );

      // Use the new BaseHealthcareAgent infrastructure
      const healthcareContext: HealthcareContext = {
        userId: patientContext?.userId || 'anonymous',
        sessionId: patientContext?.sessionId || 'temp-session',
        medicalHistory: patientContext?.medicalHistory || [],
        currentMedications: patientContext?.currentMedications || [],
        allergies: patientContext?.allergies || [],
        culturalContext: this.determineCulturalContext(query),
        languagePreference: this.detectLanguage(query),
        ...patientContext,
      };

      const agentResponse = await this.processQuery(query, healthcareContext);

      // Convert to legacy format for backward compatibility
      return {
        response: agentResponse.response,
        responseLanguage:
          (healthcareContext.languagePreference === 'mixed'
            ? 'vietnamese'
            : healthcareContext.languagePreference) || 'vietnamese',
        traditionalMedicineAdvice: this.extractTraditionalAdvice(
          agentResponse.response,
        ),
        modernMedicineAdvice: this.extractModernAdvice(agentResponse.response),
        culturalConsiderations:
          agentResponse.metadata.culturalConsiderations || [],
        recommendedActions: agentResponse.recommendedActions || [],
        urgencyLevel: agentResponse.urgencyLevel,
        confidence: agentResponse.confidence,
        requiresPhysicianReview: agentResponse.requiresEscalation,
      };
    } catch (error) {
      this.logger.error('Error processing Vietnamese medical query:', error);
      throw new Error('Failed to process Vietnamese medical query');
    }
  }

  private determineCulturalContext(
    query: string,
  ): 'traditional' | 'modern' | 'mixed' {
    const traditionalKeywords = [
      'thuốc nam',
      'đông y',
      'y học cổ truyền',
      'bài thuốc',
      'thầy thuốc',
    ];
    const modernKeywords = [
      'bác sĩ',
      'bệnh viện',
      'thuốc tây',
      'xét nghiệm',
      'chẩn đoán',
    ];

    const queryLower = query.toLowerCase();
    const hasTraditional = traditionalKeywords.some((keyword) =>
      queryLower.includes(keyword),
    );
    const hasModern = modernKeywords.some((keyword) =>
      queryLower.includes(keyword),
    );

    if (hasTraditional && hasModern) return 'mixed';
    if (hasTraditional) return 'traditional';
    return 'modern';
  }

  private extractTraditionalAdvice(response: string): string {
    const lines = response.split('\n');
    const traditionalSection = lines.find(
      (line) =>
        line.toLowerCase().includes('y học cổ truyền') ||
        line.toLowerCase().includes('thuốc nam'),
    );
    return traditionalSection || '';
  }

  private extractModernAdvice(response: string): string {
    const lines = response.split('\n');
    const modernSection = lines.find(
      (line) =>
        line.toLowerCase().includes('y học hiện đại') ||
        line.toLowerCase().includes('điều trị'),
    );
    return modernSection || '';
  }

  private async analyzeVietnameseMedicalContext(
    query: string,
  ): Promise<VietnameseMedicalContext> {
    const context: VietnameseMedicalContext = {
      query,
      detectedLanguage: this.detectLanguage(query),
      traditionalMedicineTerms: this.extractTraditionalMedicineTerms(query),
      modernMedicineTerms: this.extractModernMedicineTerms(query),
      culturalContext: 'modern',
      medicalEntities: this.extractMedicalEntities(query) as Array<{
        text: string;
        type: 'symptom' | 'disease' | 'medication' | 'treatment' | 'body_part';
        confidence: number;
      }>,
      urgencyIndicators: this.detectUrgencyIndicators(query),
    };

    // Determine cultural context
    if (context.traditionalMedicineTerms.length > 0) {
      context.culturalContext =
        context.modernMedicineTerms.length > 0 ? 'mixed' : 'traditional';
    }

    return context;
  }

  protected detectLanguage(text: string): 'vietnamese' | 'english' | 'mixed' {
    const vietnamesePattern =
      /[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]/i;
    const englishPattern = /[a-zA-Z]/;

    const hasVietnamese = vietnamesePattern.test(text);
    const hasEnglish = englishPattern.test(text);

    if (hasVietnamese && hasEnglish) return 'mixed';
    if (hasVietnamese) return 'vietnamese';
    return 'english';
  }

  private extractTraditionalMedicineTerms(text: string): string[] {
    const terms: string[] = [];
    const lowerText = text.toLowerCase();

    for (const [vietnamese, english] of this.traditionalMedicineTerms) {
      if (lowerText.includes(vietnamese)) {
        terms.push(vietnamese);
      }
    }

    return terms;
  }

  private extractModernMedicineTerms(text: string): string[] {
    // Simple extraction - in production, use proper Vietnamese NLP
    const modernTerms = [
      'thuốc tây',
      'bác sĩ',
      'bệnh viện',
      'phòng khám',
      'xét nghiệm',
      'chụp x-quang',
      'siêu âm',
      'nội soi',
      'phẫu thuật',
      'tiêm',
    ];

    const lowerText = text.toLowerCase();
    return modernTerms.filter((term) => lowerText.includes(term));
  }

  protected extractMedicalEntities(text: string): Array<{
    text: string;
    type: string;
    confidence: number;
  }> {
    const entities: Array<{
      text: string;
      type: string;
      confidence: number;
    }> = [];

    const lowerText = text.toLowerCase();

    // Extract symptoms
    for (const [vietnamese, english] of this.vietnameseSymptoms) {
      if (lowerText.includes(vietnamese)) {
        entities.push({
          text: vietnamese,
          type: 'symptom',
          confidence: 0.9,
        });
      }
    }

    return entities;
  }

  private detectUrgencyIndicators(text: string): string[] {
    const lowerText = text.toLowerCase();
    return this.urgencyKeywords.filter((keyword) =>
      lowerText.includes(keyword),
    );
  }

  private async generateVietnameseMedicalResponse(
    query: string,
    context: VietnameseMedicalContext,
    healthcareContext: HealthcareContext,
    knowledgeResults: any[] = [],
    nlpResult: any = {},
  ): Promise<VietnameseMedicalResponse> {
    const systemPrompt = this.buildVietnameseSystemPrompt(
      context,
      knowledgeResults,
      nlpResult,
    );

    const response = await this.model.invoke([
      { role: 'system', content: systemPrompt },
      { role: 'user', content: query },
    ]);

    const responseText = response.content as string;

    // Determine urgency level
    const urgencyLevel = this.calculateUrgencyLevel(context);

    // Generate recommendations
    const recommendations = this.generateRecommendations(context, urgencyLevel);

    return {
      response: responseText,
      responseLanguage:
        context.detectedLanguage === 'vietnamese' ? 'vietnamese' : 'english',
      traditionalMedicineAdvice:
        context.traditionalMedicineTerms.length > 0
          ? this.generateTraditionalMedicineAdvice(context)
          : undefined,
      modernMedicineAdvice: this.generateModernMedicineAdvice(context),
      culturalConsiderations:
        this.generateVietnameseCulturalConsiderations(context),
      recommendedActions: recommendations,
      urgencyLevel,
      confidence: 0.85,
      requiresPhysicianReview:
        urgencyLevel > 0.6 || context.urgencyIndicators.length > 0,
    };
  }

  private buildVietnameseSystemPrompt(
    context: VietnameseMedicalContext,
    knowledgeResults: any[] = [],
    nlpResult: any = {},
  ): string {
    let basePrompt = `Bạn là một chuyên gia y tế Việt Nam, có kiến thức sâu về cả y học hiện đại và y học cổ truyền Việt Nam.

Ngữ cảnh văn hóa: ${context.culturalContext}
Ngôn ngữ phát hiện: ${context.detectedLanguage}
Thuật ngữ y học cổ truyền: ${context.traditionalMedicineTerms.join(', ')}
Thuật ngữ y học hiện đại: ${context.modernMedicineTerms.join(', ')}
Các triệu chứng phát hiện: ${context.medicalEntities.map((e) => e.text).join(', ')}

Hướng dẫn trả lời:
1. Trả lời bằng tiếng Việt nếu câu hỏi bằng tiếng Việt
2. Tích hợp kiến thức y học cổ truyền và hiện đại một cách phù hợp
3. Tôn trọng văn hóa và truyền thống y học Việt Nam
4. Đưa ra lời khuyên an toàn và có căn cứ khoa học
5. Khuyến khích tham khảo ý kiến bác sĩ khi cần thiết
6. Giải thích rõ ràng và dễ hiểu cho người dân Việt Nam

Lưu ý quan trọng: Luôn nhấn mạnh rằng đây chỉ là thông tin tham khảo, không thay thế cho việc khám và điều trị y tế chuyên nghiệp.`;

    // Add knowledge base context if available
    if (knowledgeResults.length > 0) {
      const knowledgeContext = knowledgeResults
        .slice(0, 3) // Use top 3 results
        .map(
          (result, index) =>
            `${index + 1}. ${result.document.title}: ${result.document.content.substring(0, 200)}...`,
        )
        .join('\n');

      basePrompt += `\n\nThông tin y tế Việt Nam có liên quan:\n${knowledgeContext}`;
    }

    // Add NLP analysis if available
    if (nlpResult.urgencyAnalysis?.is_emergency) {
      basePrompt += `\n\nCẢNH BÁO NLP: Phát hiện tình huống khẩn cấp với độ tin cậy ${nlpResult.urgencyAnalysis.urgency_level}`;
    }

    if (nlpResult.entities?.length > 0) {
      const medicalEntities = nlpResult.entities
        .filter((entity) =>
          ['symptom', 'disease', 'medication'].includes(entity.type),
        )
        .map((entity) => `${entity.text} (${entity.type})`)
        .join(', ');

      if (medicalEntities) {
        basePrompt += `\n\nCác thực thể y tế được phát hiện: ${medicalEntities}`;
      }
    }

    if (context.urgencyIndicators.length > 0) {
      return (
        basePrompt +
        `\n\nCẢNH BÁO: Phát hiện các dấu hiệu khẩn cấp. Ưu tiên khuyến nghị tìm kiếm sự chăm sóc y tế ngay lập tức.`
      );
    }

    return basePrompt;
  }

  private calculateUrgencyLevel(context: VietnameseMedicalContext): number {
    let urgency = 0.1; // Base level

    // Emergency indicators
    urgency += context.urgencyIndicators.length * 0.3;

    // High-risk symptoms
    const highRiskSymptoms = ['đau ngực', 'khó thở', 'mất ý thức', 'co giật'];
    const detectedHighRisk = context.medicalEntities.filter((entity) =>
      highRiskSymptoms.some((symptom) => entity.text.includes(symptom)),
    );
    urgency += detectedHighRisk.length * 0.25;

    return Math.min(1.0, urgency);
  }

  private generateRecommendations(
    context: VietnameseMedicalContext,
    urgencyLevel: number,
  ): string[] {
    const recommendations: string[] = [];

    if (urgencyLevel >= 0.8) {
      recommendations.push('Tìm kiếm sự chăm sóc y tế khẩn cấp ngay lập tức');
      recommendations.push('Gọi cấp cứu 115 hoặc đến bệnh viện gần nhất');
    } else if (urgencyLevel >= 0.5) {
      recommendations.push('Nên đi khám bác sĩ trong ngày');
      recommendations.push('Theo dõi triệu chứng và ghi chép lại');
    } else {
      recommendations.push('Theo dõi triệu chứng trong vài ngày');
      recommendations.push('Đi khám nếu triệu chứng không cải thiện');
    }

    if (context.traditionalMedicineTerms.length > 0) {
      recommendations.push(
        'Tham khảo thầy thuốc y học cổ truyền có kinh nghiệm',
      );
    }

    return recommendations;
  }

  private generateTraditionalMedicineAdvice(
    context: VietnameseMedicalContext,
  ): string {
    const advice = [
      'Y học cổ truyền Việt Nam có thể hỗ trợ điều trị',
      'Nên kết hợp với y học hiện đại để đạt hiệu quả tốt nhất',
      'Tham khảo thầy thuốc có chuyên môn và kinh nghiệm',
    ];

    return advice.join('. ') + '.';
  }

  private generateModernMedicineAdvice(
    context: VietnameseMedicalContext,
  ): string {
    return 'Khuyến khích thăm khám bác sĩ để được chẩn đoán chính xác và điều trị phù hợp theo y học hiện đại.';
  }

  private generateVietnameseCulturalConsiderations(
    context: VietnameseMedicalContext,
  ): string[] {
    const considerations: string[] = [];

    if (context.culturalContext === 'traditional') {
      considerations.push(
        'Tôn trọng truyền thống y học cổ truyền của gia đình',
      );
      considerations.push('Có thể kết hợp với phương pháp điều trị hiện đại');
    }

    if (context.culturalContext === 'mixed') {
      considerations.push('Cân bằng giữa y học cổ truyền và hiện đại');
      considerations.push('Thảo luận với cả thầy thuốc và bác sĩ');
    }

    considerations.push('Xem xét yếu tố văn hóa và tôn giáo trong điều trị');
    considerations.push('Tham khảo ý kiến gia đình khi đưa ra quyết định y tế');

    return considerations;
  }

  // Enhanced Vietnamese NLP integration with microservice
  private async processWithVietnameseNLP(text: string): Promise<any> {
    try {
      const nlpServiceUrl =
        process.env.VIETNAMESE_NLP_SERVICE_URL || 'http://localhost:8080';

      const response = await fetch(`${nlpServiceUrl}/analyze`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ text }),
      });

      if (!response.ok) {
        throw new Error(
          `NLP service responded with status: ${response.status}`,
        );
      }

      const result = await response.json();

      this.logger.log('Vietnamese NLP processing completed', {
        entityCount: result.entities?.length || 0,
        isEmergency: result.urgency_analysis?.is_emergency || false,
        sentiment: result.sentiment?.sentiment || 'neutral',
      });

      return {
        tokens: result.tokenization?.tokens || [],
        entities: result.entities || [],
        sentiment: result.sentiment?.sentiment || 'neutral',
        urgencyAnalysis: result.urgency_analysis || {},
        summary: result.summary || {},
      };
    } catch (error) {
      this.logger.warn(
        'Vietnamese NLP processing failed, using fallback:',
        error,
      );

      // Fallback to basic processing
      return {
        tokens: text.split(' '),
        entities: this.extractMedicalEntities(text),
        sentiment: 'neutral',
        urgencyAnalysis: { urgency_level: 0.3, is_emergency: false },
        summary: { has_medical_terms: false },
      };
    }
  }
}
