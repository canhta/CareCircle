import { Logger } from '@nestjs/common';
import { ChatOpenAI } from '@langchain/openai';
import { PHIProtectionService, PHIDetectionResult } from '../../../common/compliance/phi-protection.service';
import { VietnameseNLPIntegrationService, VietnameseNLPAnalysis } from '../../infrastructure/services/vietnamese-nlp-integration.service';

export interface HealthcareContext {
  patientId?: string;
  userId: string;
  sessionId: string;
  medicalHistory?: string[];
  currentMedications?: string[];
  allergies?: string[];
  vitalSigns?: {
    bloodPressure?: string;
    heartRate?: number;
    temperature?: number;
    weight?: number;
    height?: number;
  };
  emergencyContacts?: Array<{
    name: string;
    relationship: string;
    phone: string;
  }>;
  culturalContext?: 'traditional' | 'modern' | 'mixed';
  languagePreference?: 'vietnamese' | 'english' | 'mixed';
  riskFactors?: string[];
  chronicConditions?: string[];
  vietnameseNLPAnalysis?: VietnameseNLPAnalysis; // Enhanced with Vietnamese NLP
}

export interface AgentResponse {
  agentType: string;
  response: string;
  confidence: number;
  urgencyLevel: number; // 0.0-1.0 scale
  requiresEscalation: boolean;
  recommendedActions?: string[];
  metadata: {
    processingTime: number;
    modelUsed: string;
    tokensConsumed: number;
    costUsd: number;
    phiDetected: boolean;
    complianceFlags: string[];
    medicalEntities?: Array<{
      text: string;
      type: string;
      confidence: number;
    }>;
    culturalConsiderations?: string[];
    traditionalMedicineReferences?: string[];
  };
}

export interface AgentCapability {
  name: string;
  description: string;
  confidence: number;
  requiresPhysicianReview: boolean;
  maxSeverityLevel: number;
  supportedLanguages: string[];
  medicalSpecialties: string[];
}

export abstract class BaseHealthcareAgent {
  protected readonly logger: Logger;
  protected readonly model: ChatOpenAI;
  protected readonly agentType: string;
  protected readonly capabilities: AgentCapability[];

  constructor(
    agentType: string,
    protected readonly phiProtectionService: PHIProtectionService,
    protected readonly vietnameseNLPService?: VietnameseNLPIntegrationService,
    modelConfig?: {
      modelName?: string;
      temperature?: number;
      maxTokens?: number;
    },
  ) {
    this.agentType = agentType;
    this.logger = new Logger(`${agentType}Agent`);
    
    this.model = new ChatOpenAI({
      modelName: modelConfig?.modelName || 'gpt-4',
      temperature: modelConfig?.temperature || 0.1, // Low temperature for medical accuracy
      maxTokens: modelConfig?.maxTokens || 2000,
    });

    this.capabilities = this.defineCapabilities();
  }

  /**
   * Main entry point for processing healthcare queries
   */
  async processQuery(
    query: string,
    context: HealthcareContext,
  ): Promise<AgentResponse> {
    const startTime = Date.now();

    try {
      this.logger.log(`Processing query for agent ${this.agentType}: ${query.substring(0, 100)}...`);

      // Step 1: PHI Detection and Protection
      const phiResult = await this.detectAndProtectPHI(query);
      
      // Step 2: Validate agent capability for this query
      await this.validateCapability(phiResult.maskedText, context);

      // Step 3: Enhance context with agent-specific data
      const enhancedContext = await this.enhanceContext(context);

      // Step 4: Process the query with agent-specific logic
      const response = await this.processAgentSpecificQuery(
        phiResult.maskedText,
        enhancedContext,
      );

      // Step 5: Post-process response for compliance and safety
      const finalResponse = await this.postProcessResponse(response, phiResult, context);

      // Step 6: Calculate processing metrics
      const processingTime = Date.now() - startTime;
      
      return {
        ...finalResponse,
        metadata: {
          ...finalResponse.metadata,
          processingTime,
          phiDetected: phiResult.detectedPHI.length > 0,
          complianceFlags: phiResult.detectedPHI.map(phi => phi.type),
        },
      };
    } catch (error) {
      this.logger.error(`Error processing query in ${this.agentType}:`, error);
      throw new Error(`Agent processing failed: ${error.message}`);
    }
  }

  /**
   * Detect and protect PHI in the query
   */
  protected async detectAndProtectPHI(query: string): Promise<PHIDetectionResult> {
    return await this.phiProtectionService.detectAndMaskPHI(query);
  }

  /**
   * Validate if this agent can handle the query
   */
  protected async validateCapability(query: string, context: HealthcareContext): Promise<void> {
    const urgencyLevel = await this.assessUrgency(query, context);
    
    // Check if urgency exceeds agent capability
    const maxSeverity = Math.max(...this.capabilities.map(cap => cap.maxSeverityLevel));
    if (urgencyLevel > maxSeverity) {
      throw new Error(`Query urgency (${urgencyLevel}) exceeds agent capability (${maxSeverity})`);
    }

    // Check language support
    const detectedLanguage = this.detectLanguage(query);
    const supportsLanguage = this.capabilities.some(cap => 
      cap.supportedLanguages.includes(detectedLanguage)
    );
    
    if (!supportsLanguage) {
      this.logger.warn(`Language ${detectedLanguage} not fully supported by ${this.agentType}`);
    }
  }

  /**
   * Enhance context with agent-specific data
   */
  protected async enhanceContext(context: HealthcareContext): Promise<HealthcareContext> {
    // Base implementation - can be overridden by specific agents
    return {
      ...context,
      agentType: this.agentType,
      timestamp: new Date().toISOString(),
    };
  }

  /**
   * Enhance context with Vietnamese NLP analysis
   */
  protected async enhanceContextWithVietnameseNLP(
    query: string,
    context: HealthcareContext,
  ): Promise<HealthcareContext> {
    if (!this.vietnameseNLPService) {
      return context;
    }

    try {
      // Perform Vietnamese NLP analysis
      const nlpAnalysis = await this.vietnameseNLPService.analyzeHealthcareText(query);

      // Extract medical entities
      const medicalEntities = await this.vietnameseNLPService.extractMedicalEntities(query);

      // Detect emergency context
      const emergencyContext = await this.vietnameseNLPService.detectEmergencyContext(query);

      return {
        ...context,
        vietnameseNLPAnalysis: nlpAnalysis,
        languagePreference: nlpAnalysis.languageMetrics.isVietnamese ? 'vietnamese' : context.languagePreference,
        culturalContext: nlpAnalysis.culturalContext.isTraditionalMedicine ? 'traditional' :
                        nlpAnalysis.culturalContext.modernMedicineTerms.length > 0 ? 'modern' :
                        context.culturalContext,
        // Enhance symptoms with extracted entities
        symptoms: [
          ...(context.symptoms || []),
          ...medicalEntities.symptoms,
        ].filter((symptom, index, self) => self.indexOf(symptom) === index), // Remove duplicates
        // Add emergency indicators
        emergencyIndicators: emergencyContext.emergencyKeywords,
        urgencyLevel: emergencyContext.urgencyLevel,
      };

    } catch (error) {
      this.logger.warn('Vietnamese NLP enhancement failed, continuing without it:', error);
      return context;
    }
  }

  /**
   * Post-process response for compliance and safety
   */
  protected async postProcessResponse(
    response: AgentResponse,
    phiResult: PHIDetectionResult,
    context: HealthcareContext,
  ): Promise<AgentResponse> {
    // Add compliance disclaimers for high-risk responses
    if (response.urgencyLevel > 0.7 || response.requiresEscalation) {
      response.response += '\n\n⚠️ Lưu ý: Thông tin này chỉ mang tính chất tham khảo. Vui lòng tham khảo ý kiến bác sĩ để được chẩn đoán và điều trị chính xác.';
    }

    // Add cultural considerations for Vietnamese context
    if (context.culturalContext && context.languagePreference === 'vietnamese') {
      response.metadata.culturalConsiderations = await this.generateCulturalConsiderations(context);
    }

    return response;
  }

  /**
   * Assess urgency level of the query
   */
  protected async assessUrgency(query: string, context: HealthcareContext): Promise<number> {
    const emergencyKeywords = [
      'emergency', 'urgent', 'severe', 'critical', 'life-threatening',
      'cấp cứu', 'khẩn cấp', 'nguy hiểm', 'nghiêm trọng', 'đe dọa tính mạng'
    ];

    const queryLower = query.toLowerCase();
    const hasEmergencyKeywords = emergencyKeywords.some(keyword => 
      queryLower.includes(keyword)
    );

    if (hasEmergencyKeywords) return 0.9;
    
    // Check for high-risk medical conditions
    const highRiskConditions = context.chronicConditions?.filter(condition =>
      ['heart disease', 'diabetes', 'hypertension', 'stroke'].includes(condition.toLowerCase())
    ) || [];

    if (highRiskConditions.length > 0) return 0.6;

    return 0.3; // Default routine level
  }

  /**
   * Detect language of the query
   */
  protected detectLanguage(text: string): 'vietnamese' | 'english' | 'mixed' {
    const vietnamesePattern = /[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]/i;
    const englishPattern = /[a-zA-Z]/;

    const hasVietnamese = vietnamesePattern.test(text);
    const hasEnglish = englishPattern.test(text);

    if (hasVietnamese && hasEnglish) return 'mixed';
    if (hasVietnamese) return 'vietnamese';
    return 'english';
  }

  /**
   * Generate cultural considerations for Vietnamese healthcare context
   */
  protected async generateCulturalConsiderations(context: HealthcareContext): Promise<string[]> {
    const considerations: string[] = [];

    if (context.culturalContext === 'traditional') {
      considerations.push('Tôn trọng truyền thống y học cổ truyền của gia đình');
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

  /**
   * Calculate confidence score based on agent capabilities and query complexity
   */
  protected calculateConfidence(query: string, context: HealthcareContext): number {
    let baseConfidence = 0.8;

    // Adjust based on language match
    const queryLanguage = this.detectLanguage(query);
    const languageMatch = context.languagePreference === queryLanguage;
    if (!languageMatch) baseConfidence -= 0.1;

    // Adjust based on medical specialty match
    const hasSpecialtyMatch = this.capabilities.some(cap =>
      cap.medicalSpecialties.some(specialty =>
        query.toLowerCase().includes(specialty.toLowerCase())
      )
    );
    if (hasSpecialtyMatch) baseConfidence += 0.1;

    return Math.min(Math.max(baseConfidence, 0.0), 1.0);
  }

  // Abstract methods to be implemented by specific agents
  protected abstract defineCapabilities(): AgentCapability[];
  
  protected abstract processAgentSpecificQuery(
    query: string,
    context: HealthcareContext,
  ): Promise<AgentResponse>;

  // Utility methods for common healthcare operations
  protected formatMedicalResponse(content: string, urgencyLevel: number): string {
    const disclaimer = urgencyLevel > 0.7 
      ? '\n\n⚠️ Thông tin này cần được xác nhận bởi chuyên gia y tế.'
      : '\n\nLưu ý: Thông tin này chỉ mang tính chất tham khảo.';
    
    return content + disclaimer;
  }

  protected extractMedicalEntities(text: string): Array<{ text: string; type: string; confidence: number }> {
    // Basic medical entity extraction - can be enhanced with NLP libraries
    const entities: Array<{ text: string; type: string; confidence: number }> = [];
    
    const symptomKeywords = ['đau', 'sốt', 'ho', 'khó thở', 'mệt mỏi', 'chóng mặt'];
    const medicationKeywords = ['thuốc', 'paracetamol', 'aspirin', 'ibuprofen'];
    
    symptomKeywords.forEach(keyword => {
      if (text.toLowerCase().includes(keyword)) {
        entities.push({ text: keyword, type: 'symptom', confidence: 0.8 });
      }
    });

    medicationKeywords.forEach(keyword => {
      if (text.toLowerCase().includes(keyword)) {
        entities.push({ text: keyword, type: 'medication', confidence: 0.9 });
      }
    });

    return entities;
  }
}
