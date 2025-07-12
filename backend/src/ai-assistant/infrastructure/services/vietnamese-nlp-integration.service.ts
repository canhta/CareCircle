import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios, { AxiosInstance } from 'axios';

export interface VietnameseNLPAnalysis {
  tokens: string[];
  medicalEntities: Array<{
    text: string;
    label: string;
    confidence: number;
    start: number;
    end: number;
  }>;
  emergencyKeywords: string[];
  traditionalMedicineTerms: string[];
  culturalContext: {
    isTraditionalMedicine: boolean;
    modernMedicineTerms: string[];
    culturalIndicators: string[];
  };
  sentiment: {
    polarity: number; // -1 to 1
    urgency: number; // 0 to 1
  };
  languageMetrics: {
    isVietnamese: boolean;
    confidence: number;
    dialect?: string;
  };
}

export interface MedicalEntityExtraction {
  symptoms: string[];
  medications: string[];
  conditions: string[];
  bodyParts: string[];
  procedures: string[];
  traditionalMedicine: string[];
  emergencyTerms: string[];
}

@Injectable()
export class VietnameseNLPIntegrationService {
  private readonly logger = new Logger(VietnameseNLPIntegrationService.name);
  private readonly httpClient: AxiosInstance;
  private readonly nlpServiceUrl: string;

  // Vietnamese emergency keywords for enhanced detection
  private readonly emergencyKeywords = [
    'cấp cứu',
    'khẩn cấp',
    'nguy hiểm',
    'nghiêm trọng',
    'đau dữ dội',
    'khó thở nặng',
    'mất ý thức',
    'co giật',
    'xuất huyết',
    'đau tim',
    'đột quỵ',
    'ngộ độc',
    'sốc phản vệ',
    'đau ngực',
    'khó thở',
    'chảy máu',
    'bất tỉnh',
    'ngất xỉu',
    'sốt cao',
    'kinh phong',
  ];

  // Traditional medicine terms
  private readonly traditionalMedicineTerms = [
    'thuốc nam',
    'đông y',
    'y học cổ truyền',
    'bài thuốc',
    'thang thuốc',
    'cao dược liệu',
    'lá thuốc',
    'rễ cây',
    'nhân sâm',
    'đông quai',
    'cam thảo',
    'hoàng kỳ',
    'bạch truật',
    'phục linh',
    'đương quy',
    'xuyên khung',
    'nghệ',
    'gừng',
    'tỏi',
    'hành',
    'lá lốt',
    'rau má',
  ];

  // Medical terminology mapping
  private readonly medicalTermMapping = {
    symptoms: [
      'đau đầu',
      'sốt',
      'ho',
      'đau',
      'buồn nôn',
      'mệt mỏi',
      'chóng mặt',
      'khó thở',
      'đau bụng',
      'tiêu chảy',
      'táo bón',
      'mất ngủ',
      'lo âu',
      'trầm cảm',
    ],
    bodyParts: [
      'đầu',
      'mắt',
      'tai',
      'mũi',
      'miệng',
      'cổ',
      'vai',
      'tay',
      'ngực',
      'bụng',
      'lưng',
      'chân',
      'tim',
      'phổi',
      'gan',
      'thận',
      'dạ dày',
      'ruột',
      'não',
      'xương',
    ],
    conditions: [
      'cao huyết áp',
      'tiểu đường',
      'tim mạch',
      'ung thư',
      'viêm gan',
      'viêm phổi',
      'hen suyễn',
      'dị ứng',
      'trầm cảm',
      'lo âu',
      'mất ngủ',
      'đau khớp',
    ],
  };

  constructor(private readonly configService: ConfigService) {
    this.nlpServiceUrl = this.configService.get<string>(
      'VIETNAMESE_NLP_SERVICE_URL',
      'http://localhost:5001',
    );

    this.httpClient = axios.create({
      baseURL: this.nlpServiceUrl,
      timeout: 10000,
      headers: {
        'Content-Type': 'application/json',
      },
    });

    // Add request/response interceptors for logging
    this.httpClient.interceptors.request.use(
      (config) => {
        this.logger.debug(
          `Vietnamese NLP request: ${config.method?.toUpperCase()} ${config.url}`,
        );
        return config;
      },
      (error) => {
        this.logger.error('Vietnamese NLP request error:', error);
        return Promise.reject(error);
      },
    );

    this.httpClient.interceptors.response.use(
      (response) => {
        this.logger.debug(
          `Vietnamese NLP response: ${response.status} ${response.config.url}`,
        );
        return response;
      },
      (error) => {
        this.logger.error(
          'Vietnamese NLP response error:',
          error.response?.data || error.message,
        );
        return Promise.reject(error);
      },
    );
  }

  async analyzeHealthcareText(text: string): Promise<VietnameseNLPAnalysis> {
    try {
      this.logger.log(
        `Analyzing Vietnamese healthcare text: ${text.substring(0, 100)}...`,
      );

      // Call the Vietnamese NLP service
      const response = await this.httpClient.post('/analyze', {
        text,
        include_medical_entities: true,
        include_sentiment: true,
        include_emergency_detection: true,
      });

      const nlpResult = response.data;

      // Enhanced analysis with healthcare-specific processing
      const analysis: VietnameseNLPAnalysis = {
        tokens: nlpResult.tokens || [],
        medicalEntities: this.enhanceMedicalEntities(nlpResult.entities || []),
        emergencyKeywords: this.detectEmergencyKeywords(text),
        traditionalMedicineTerms: this.detectTraditionalMedicine(text),
        culturalContext: this.analyzeCulturalContext(text, nlpResult),
        sentiment: {
          polarity: nlpResult.sentiment?.polarity || 0,
          urgency: this.calculateUrgency(text, nlpResult),
        },
        languageMetrics: {
          isVietnamese: this.isVietnameseText(text),
          confidence: nlpResult.language_confidence || 0.8,
          dialect: nlpResult.dialect,
        },
      };

      this.logger.log('Vietnamese NLP analysis completed', {
        emergencyKeywords: analysis.emergencyKeywords.length,
        medicalEntities: analysis.medicalEntities.length,
        isTraditionalMedicine: analysis.culturalContext.isTraditionalMedicine,
        urgency: analysis.sentiment.urgency,
      });

      return analysis;
    } catch (error) {
      this.logger.error('Vietnamese NLP analysis failed:', error);

      // Fallback analysis using local processing
      return this.fallbackAnalysis(text);
    }
  }

  async extractMedicalEntities(text: string): Promise<MedicalEntityExtraction> {
    try {
      const analysis = await this.analyzeHealthcareText(text);

      return {
        symptoms: this.extractEntitiesByType(
          analysis.medicalEntities,
          'SYMPTOM',
        ),
        medications: this.extractEntitiesByType(
          analysis.medicalEntities,
          'MEDICATION',
        ),
        conditions: this.extractEntitiesByType(
          analysis.medicalEntities,
          'CONDITION',
        ),
        bodyParts: this.extractEntitiesByType(
          analysis.medicalEntities,
          'BODY_PART',
        ),
        procedures: this.extractEntitiesByType(
          analysis.medicalEntities,
          'PROCEDURE',
        ),
        traditionalMedicine: analysis.traditionalMedicineTerms,
        emergencyTerms: analysis.emergencyKeywords,
      };
    } catch (error) {
      this.logger.error('Medical entity extraction failed:', error);
      return this.fallbackEntityExtraction(text);
    }
  }

  async detectEmergencyContext(text: string): Promise<{
    isEmergency: boolean;
    urgencyLevel: number;
    emergencyKeywords: string[];
    recommendedAction: string;
  }> {
    try {
      const analysis = await this.analyzeHealthcareText(text);

      const isEmergency =
        analysis.emergencyKeywords.length > 0 ||
        analysis.sentiment.urgency > 0.7;
      const urgencyLevel = Math.max(
        analysis.sentiment.urgency,
        analysis.emergencyKeywords.length * 0.3,
      );

      let recommendedAction = 'Theo dõi triệu chứng';
      if (urgencyLevel > 0.8) {
        recommendedAction = 'Gọi cấp cứu ngay lập tức (115)';
      } else if (urgencyLevel > 0.6) {
        recommendedAction = 'Đến bệnh viện trong vòng 2 giờ';
      } else if (urgencyLevel > 0.4) {
        recommendedAction = 'Tham khảo ý kiến bác sĩ trong 24 giờ';
      }

      return {
        isEmergency,
        urgencyLevel,
        emergencyKeywords: analysis.emergencyKeywords,
        recommendedAction,
      };
    } catch (error) {
      this.logger.error('Emergency detection failed:', error);
      return {
        isEmergency: false,
        urgencyLevel: 0.3,
        emergencyKeywords: [],
        recommendedAction: 'Tham khảo ý kiến bác sĩ',
      };
    }
  }

  private enhanceMedicalEntities(
    entities: any[],
  ): VietnameseNLPAnalysis['medicalEntities'] {
    return entities.map((entity) => ({
      text: entity.text || entity.word,
      label: this.mapEntityLabel(entity.label || entity.type),
      confidence: entity.confidence || entity.score || 0.8,
      start: entity.start || 0,
      end: entity.end || 0,
    }));
  }

  private mapEntityLabel(label: string): string {
    const labelMapping: Record<string, string> = {
      PERSON: 'PERSON',
      ORG: 'ORGANIZATION',
      LOC: 'LOCATION',
      MISC: 'MISCELLANEOUS',
      SYMPTOM: 'SYMPTOM',
      DISEASE: 'CONDITION',
      MEDICATION: 'MEDICATION',
      BODY_PART: 'BODY_PART',
      PROCEDURE: 'PROCEDURE',
    };

    return labelMapping[label.toUpperCase()] || 'MISCELLANEOUS';
  }

  private detectEmergencyKeywords(text: string): string[] {
    const textLower = text.toLowerCase();
    return this.emergencyKeywords.filter((keyword) =>
      textLower.includes(keyword),
    );
  }

  private detectTraditionalMedicine(text: string): string[] {
    const textLower = text.toLowerCase();
    return this.traditionalMedicineTerms.filter((term) =>
      textLower.includes(term),
    );
  }

  private analyzeCulturalContext(
    text: string,
    nlpResult: any,
  ): VietnameseNLPAnalysis['culturalContext'] {
    const traditionalTerms = this.detectTraditionalMedicine(text);
    const modernTerms = this.detectModernMedicine(text);

    return {
      isTraditionalMedicine: traditionalTerms.length > 0,
      modernMedicineTerms: modernTerms,
      culturalIndicators: this.detectCulturalIndicators(text),
    };
  }

  private detectModernMedicine(text: string): string[] {
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
      'kháng sinh',
      'vitamin',
      'paracetamol',
      'aspirin',
      'ibuprofen',
    ];

    const textLower = text.toLowerCase();
    return modernTerms.filter((term) => textLower.includes(term));
  }

  private detectCulturalIndicators(text: string): string[] {
    const culturalTerms = [
      'ông bà',
      'tổ tiên',
      'kinh nghiệm dân gian',
      'phương pháp truyền thống',
      'lương y',
      'thầy thuốc',
      'bà đỡ',
      'cúng bái',
      'tâm linh',
    ];

    const textLower = text.toLowerCase();
    return culturalTerms.filter((term) => textLower.includes(term));
  }

  private calculateUrgency(text: string, nlpResult: any): number {
    let urgency = 0;

    // Emergency keywords contribute to urgency
    const emergencyCount = this.detectEmergencyKeywords(text).length;
    urgency += emergencyCount * 0.3;

    // Sentiment polarity (negative = more urgent)
    const sentiment = nlpResult.sentiment?.polarity || 0;
    if (sentiment < -0.5) urgency += 0.3;

    // Pain indicators
    const painKeywords = [
      'đau dữ dội',
      'đau nhiều',
      'đau không chịu được',
      'rất đau',
    ];
    const painCount = painKeywords.filter((keyword) =>
      text.toLowerCase().includes(keyword),
    ).length;
    urgency += painCount * 0.2;

    return Math.min(urgency, 1.0);
  }

  private isVietnameseText(text: string): boolean {
    // Check for Vietnamese diacritics
    const vietnamesePattern =
      /[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]/;
    return vietnamesePattern.test(text);
  }

  private extractEntitiesByType(
    entities: VietnameseNLPAnalysis['medicalEntities'],
    type: string,
  ): string[] {
    return entities
      .filter((entity) => entity.label === type)
      .map((entity) => entity.text);
  }

  private fallbackAnalysis(text: string): VietnameseNLPAnalysis {
    this.logger.warn('Using fallback Vietnamese NLP analysis');

    return {
      tokens: text.split(/\s+/),
      medicalEntities: [],
      emergencyKeywords: this.detectEmergencyKeywords(text),
      traditionalMedicineTerms: this.detectTraditionalMedicine(text),
      culturalContext: {
        isTraditionalMedicine: this.detectTraditionalMedicine(text).length > 0,
        modernMedicineTerms: this.detectModernMedicine(text),
        culturalIndicators: this.detectCulturalIndicators(text),
      },
      sentiment: {
        polarity: 0,
        urgency: this.detectEmergencyKeywords(text).length > 0 ? 0.7 : 0.3,
      },
      languageMetrics: {
        isVietnamese: this.isVietnameseText(text),
        confidence: 0.6,
      },
    };
  }

  private fallbackEntityExtraction(text: string): MedicalEntityExtraction {
    const textLower = text.toLowerCase();

    return {
      symptoms: this.medicalTermMapping.symptoms.filter((symptom) =>
        textLower.includes(symptom),
      ),
      medications: [],
      conditions: this.medicalTermMapping.conditions.filter((condition) =>
        textLower.includes(condition),
      ),
      bodyParts: this.medicalTermMapping.bodyParts.filter((part) =>
        textLower.includes(part),
      ),
      procedures: [],
      traditionalMedicine: this.detectTraditionalMedicine(text),
      emergencyTerms: this.detectEmergencyKeywords(text),
    };
  }
}
