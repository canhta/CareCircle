import { Injectable, Logger } from '@nestjs/common';
import { BaseHealthcareAgent, HealthcareContext, AgentResponse, AgentCapability } from './base-healthcare.agent';
import { PHIProtectionService } from '../../../common/compliance/phi-protection.service';
import { VietnameseNLPIntegrationService } from '../../infrastructure/services/vietnamese-nlp-integration.service';

export interface EmergencyContext extends HealthcareContext {
  age?: number;
  gender?: 'male' | 'female' | 'other';
  medicalHistory?: string[];
  currentSymptoms?: string[];
  symptomDuration?: string;
  symptomSeverity?: number; // 1-10 scale
  vitalSigns?: {
    bloodPressure?: string;
    heartRate?: number;
    temperature?: number;
    respiratoryRate?: number;
    oxygenSaturation?: number;
  };
  consciousness?: 'alert' | 'confused' | 'unconscious';
  location?: {
    latitude?: number;
    longitude?: number;
    address?: string;
  };
}

export interface TriageAssessment {
  severity: number; // 0.0-1.0 scale
  urgencyLevel: 'routine' | 'urgent' | 'emergency' | 'critical';
  recommendedAction: string;
  timeframe: string;
  indicators: string[];
  confidence: number;
  requiresImmediateAttention: boolean;
  emergencyServices: boolean;
}

export interface EmergencyProtocol {
  condition: string;
  immediateActions: string[];
  emergencyContacts: Array<{
    service: string;
    number: string;
    country: string;
  }>;
  criticalWarnings: string[];
}

@Injectable()
export class EmergencyTriageAgent extends BaseHealthcareAgent {
  private readonly logger = new Logger(EmergencyTriageAgent.name);

  // Vietnamese emergency keywords
  private readonly vietnameseEmergencyKeywords = [
    'cấp cứu', 'khẩn cấp', 'nguy hiểm', 'nghiêm trọng',
    'đau dữ dội', 'khó thở nặng', 'mất ý thức', 'co giật',
    'xuất huyết', 'đau tim', 'đột quỵ', 'ngộ độc',
    'sốc phản vệ', 'đau ngực', 'khó thở', 'chảy máu'
  ];

  // English emergency keywords
  private readonly englishEmergencyKeywords = [
    'emergency', 'urgent', 'severe', 'critical',
    'chest pain', 'difficulty breathing', 'unconscious', 'seizure',
    'severe bleeding', 'heart attack', 'stroke', 'overdose',
    'anaphylaxis', 'severe allergic reaction', 'choking', 'poisoning'
  ];

  constructor(
    phiProtectionService: PHIProtectionService,
    vietnameseNLPService: VietnameseNLPIntegrationService,
  ) {
    super('emergency_triage', phiProtectionService, vietnameseNLPService, {
      modelName: 'gpt-4',
      temperature: 0.0, // Zero temperature for emergency consistency
      maxTokens: 2000,
    });
  }

  protected defineCapabilities(): AgentCapability[] {
    return [
      {
        name: 'Emergency Triage Assessment',
        description: 'Assess emergency severity using established triage protocols',
        confidence: 0.85,
        requiresPhysicianReview: true,
        maxSeverityLevel: 10, // Can handle all emergency levels
        supportedLanguages: ['vietnamese', 'english', 'mixed'],
        medicalSpecialties: ['emergency_medicine', 'triage', 'critical_care'],
      },
      {
        name: 'Vietnamese Emergency Detection',
        description: 'Detect emergency situations in Vietnamese language and cultural context',
        confidence: 0.9,
        requiresPhysicianReview: true,
        maxSeverityLevel: 10,
        supportedLanguages: ['vietnamese', 'mixed'],
        medicalSpecialties: ['emergency_medicine', 'vietnamese_healthcare'],
      },
      {
        name: 'Crisis Intervention',
        description: 'Provide immediate guidance for medical emergencies',
        confidence: 0.8,
        requiresPhysicianReview: true,
        maxSeverityLevel: 10,
        supportedLanguages: ['vietnamese', 'english', 'mixed'],
        medicalSpecialties: ['emergency_medicine', 'crisis_intervention'],
      },
    ];
  }

  protected async processAgentSpecificQuery(
    query: string,
    context: HealthcareContext,
  ): Promise<AgentResponse> {
    try {
      this.logger.log(`Processing emergency query: ${query.substring(0, 50)}...`);

      const emergencyContext = context as EmergencyContext;

      // Immediate emergency keyword detection
      const emergencyKeywords = this.detectEmergencyKeywords(query);
      
      // Assess emergency severity
      const triageAssessment = await this.assessEmergencySeverity(query, emergencyContext);

      // Generate emergency protocols if needed
      const protocols = await this.generateEmergencyProtocols(triageAssessment, emergencyContext);

      // Create immediate response
      const response = await this.generateEmergencyResponse(
        query,
        triageAssessment,
        protocols,
        emergencyContext
      );

      // Log emergency interaction for audit
      if (triageAssessment.severity >= 0.8) {
        this.logger.warn(`HIGH SEVERITY EMERGENCY DETECTED: ${query.substring(0, 100)}`, {
          severity: triageAssessment.severity,
          urgencyLevel: triageAssessment.urgencyLevel,
          userId: context.userId,
        });
      }

      return {
        agentType: 'emergency_triage',
        response,
        confidence: triageAssessment.confidence,
        requiresEscalation: triageAssessment.severity >= 0.7,
        metadata: {
          triageAssessment,
          emergencyKeywords,
          protocols,
          emergencyServicesRecommended: triageAssessment.emergencyServices,
          severityScore: triageAssessment.severity,
          urgencyLevel: triageAssessment.urgencyLevel,
          requiresImmediateAttention: triageAssessment.requiresImmediateAttention,
        },
      };
    } catch (error) {
      this.logger.error('Emergency triage processing failed:', error);
      
      // For emergency agent, always provide a safe fallback response
      return {
        agentType: 'emergency_triage',
        response: this.getEmergencyFallbackResponse(),
        confidence: 0.5,
        requiresEscalation: true,
        metadata: {
          error: 'Emergency processing failed - using fallback response',
          emergencyFallback: true,
        },
      };
    }
  }

  private detectEmergencyKeywords(query: string): string[] {
    const queryLower = query.toLowerCase();
    const detectedKeywords: string[] = [];

    // Check Vietnamese emergency keywords
    this.vietnameseEmergencyKeywords.forEach(keyword => {
      if (queryLower.includes(keyword)) {
        detectedKeywords.push(keyword);
      }
    });

    // Check English emergency keywords
    this.englishEmergencyKeywords.forEach(keyword => {
      if (queryLower.includes(keyword)) {
        detectedKeywords.push(keyword);
      }
    });

    return detectedKeywords;
  }

  private async assessEmergencySeverity(query: string, context: EmergencyContext): Promise<TriageAssessment> {
    const triagePrompt = `Assess the emergency severity of these symptoms using established triage protocols:

Query: "${query}"

Patient Context:
- Age: ${context.age || 'unknown'}
- Gender: ${context.gender || 'unknown'}
- Medical History: ${context.medicalHistory?.join(', ') || 'none provided'}
- Current Symptoms: ${context.currentSymptoms?.join(', ') || 'as described in query'}
- Symptom Duration: ${context.symptomDuration || 'unknown'}
- Consciousness Level: ${context.consciousness || 'unknown'}

Vital Signs (if available):
- Blood Pressure: ${context.vitalSigns?.bloodPressure || 'unknown'}
- Heart Rate: ${context.vitalSigns?.heartRate || 'unknown'}
- Temperature: ${context.vitalSigns?.temperature || 'unknown'}
- Respiratory Rate: ${context.vitalSigns?.respiratoryRate || 'unknown'}
- Oxygen Saturation: ${context.vitalSigns?.oxygenSaturation || 'unknown'}

Provide severity score (0.0-1.0) where:
- 0.9-1.0: Life-threatening emergency (call emergency services immediately)
- 0.7-0.8: Urgent medical attention needed (emergency room within 1-2 hours)
- 0.5-0.6: Medical consultation recommended (within 24 hours)
- 0.3-0.4: Routine medical care (within few days)
- 0.0-0.2: Self-care or wellness advice

Consider Vietnamese emergency protocols and cultural factors.
Identify specific emergency indicators and recommended timeframe for care.`;

    const response = await this.model.invoke([
      { role: 'system', content: triagePrompt },
      { role: 'user', content: query },
    ]);

    return this.parseTriageAssessment(response.content as string, query);
  }

  private parseTriageAssessment(content: string, originalQuery: string): TriageAssessment {
    // Extract severity score
    const severityMatch = content.match(/severity[:\s]*([0-9.]+)/i);
    const severity = severityMatch ? parseFloat(severityMatch[1]) : this.calculateFallbackSeverity(originalQuery);

    // Determine urgency level
    let urgencyLevel: TriageAssessment['urgencyLevel'] = 'routine';
    if (severity >= 0.9) urgencyLevel = 'critical';
    else if (severity >= 0.7) urgencyLevel = 'emergency';
    else if (severity >= 0.5) urgencyLevel = 'urgent';

    // Extract indicators
    const indicators = this.extractEmergencyIndicators(content, originalQuery);

    // Determine recommended action
    const recommendedAction = this.determineRecommendedAction(severity, urgencyLevel);

    // Determine timeframe
    const timeframe = this.determineTimeframe(severity);

    return {
      severity,
      urgencyLevel,
      recommendedAction,
      timeframe,
      indicators,
      confidence: 0.85,
      requiresImmediateAttention: severity >= 0.7,
      emergencyServices: severity >= 0.8,
    };
  }

  private calculateFallbackSeverity(query: string): number {
    const queryLower = query.toLowerCase();
    let severity = 0.3; // Default to routine

    // High severity indicators
    const criticalKeywords = ['unconscious', 'not breathing', 'chest pain', 'stroke', 'heart attack', 'mất ý thức', 'đau tim', 'đột quỵ'];
    if (criticalKeywords.some(keyword => queryLower.includes(keyword))) {
      severity = 0.9;
    }

    // Medium-high severity indicators
    const urgentKeywords = ['severe pain', 'difficulty breathing', 'bleeding', 'đau dữ dội', 'khó thở', 'chảy máu'];
    if (urgentKeywords.some(keyword => queryLower.includes(keyword))) {
      severity = Math.max(severity, 0.7);
    }

    // Medium severity indicators
    const moderateKeywords = ['pain', 'fever', 'nausea', 'đau', 'sốt', 'buồn nôn'];
    if (moderateKeywords.some(keyword => queryLower.includes(keyword))) {
      severity = Math.max(severity, 0.5);
    }

    return severity;
  }

  private extractEmergencyIndicators(content: string, query: string): string[] {
    const indicators: string[] = [];
    
    // Extract from AI response
    const lines = content.split('\n');
    lines.forEach(line => {
      if (line.toLowerCase().includes('indicator') || line.toLowerCase().includes('warning') || line.toLowerCase().includes('sign')) {
        indicators.push(line.trim());
      }
    });

    // Add detected emergency keywords
    const emergencyKeywords = this.detectEmergencyKeywords(query);
    indicators.push(...emergencyKeywords);

    return indicators;
  }

  private determineRecommendedAction(severity: number, urgencyLevel: string): string {
    if (severity >= 0.9) {
      return 'Call emergency services immediately (115 in Vietnam, 911 in US)';
    } else if (severity >= 0.7) {
      return 'Go to emergency room immediately or call emergency services';
    } else if (severity >= 0.5) {
      return 'Seek urgent medical care within 24 hours';
    } else if (severity >= 0.3) {
      return 'Schedule medical consultation within few days';
    } else {
      return 'Monitor symptoms and consider routine medical care if needed';
    }
  }

  private determineTimeframe(severity: number): string {
    if (severity >= 0.9) return 'Immediately (within minutes)';
    if (severity >= 0.7) return 'Within 1-2 hours';
    if (severity >= 0.5) return 'Within 24 hours';
    if (severity >= 0.3) return 'Within 2-3 days';
    return 'As needed';
  }

  private async generateEmergencyProtocols(assessment: TriageAssessment, context: EmergencyContext): Promise<EmergencyProtocol[]> {
    if (assessment.severity < 0.7) return [];

    const protocols: EmergencyProtocol[] = [];

    // High severity protocols
    if (assessment.severity >= 0.8) {
      protocols.push({
        condition: 'Life-threatening emergency',
        immediateActions: [
          'Call emergency services immediately',
          'Stay with the patient',
          'Monitor breathing and consciousness',
          'Be prepared to perform CPR if trained',
          'Gather medical information for emergency responders'
        ],
        emergencyContacts: [
          { service: 'Medical Emergency (Vietnam)', number: '115', country: 'VN' },
          { service: 'Medical Emergency (US)', number: '911', country: 'US' },
          { service: 'Poison Control (Vietnam)', number: '1900 4595', country: 'VN' },
        ],
        criticalWarnings: [
          'Do not leave patient alone',
          'Do not give food or water unless instructed',
          'Do not move patient unless in immediate danger'
        ]
      });
    }

    return protocols;
  }

  private async generateEmergencyResponse(
    query: string,
    assessment: TriageAssessment,
    protocols: EmergencyProtocol[],
    context: EmergencyContext
  ): Promise<string> {
    const isVietnamese = this.detectLanguage(query) === 'vietnamese';

    if (assessment.severity >= 0.8) {
      // Critical emergency response
      const emergencyResponse = isVietnamese ? 
        `🚨 TÌNH HUỐNG KHẨN CẤP - GỌI CẤP CỨU NGAY LẬP TỨC!

Gọi ngay: 115 (Việt Nam) hoặc 911 (Mỹ)

Hành động ngay lập tức:
• Gọi cấp cứu ngay
• Ở bên cạnh bệnh nhân
• Theo dõi hô hấp và ý thức
• Chuẩn bị thông tin y tế cho đội cấp cứu

⚠️ Đây có thể là tình huống đe dọa tính mạng. Hãy tìm kiếm sự chăm sóc y tế khẩn cấp ngay lập tức.` :
        `🚨 MEDICAL EMERGENCY - CALL EMERGENCY SERVICES IMMEDIATELY!

Call now: 911 (US) or 115 (Vietnam)

Immediate actions:
• Call emergency services now
• Stay with the patient
• Monitor breathing and consciousness
• Prepare medical information for emergency responders

⚠️ This may be a life-threatening situation. Seek immediate emergency medical care.`;

      return emergencyResponse;
    } else if (assessment.severity >= 0.7) {
      // Urgent care response
      return isVietnamese ?
        `⚠️ TÌNH HUỐNG KHẨN CẤP - CẦN CHĂM SÓC Y TẾ NGAY

Hành động được khuyến nghị:
• Đến phòng cấp cứu trong vòng 1-2 giờ
• Hoặc gọi 115 nếu không thể di chuyển
• Theo dõi triệu chứng chặt chẽ

Đây là tình huống y tế khẩn cấp cần được chăm sóc chuyên nghiệp ngay lập tức.` :
        `⚠️ URGENT MEDICAL SITUATION - IMMEDIATE CARE NEEDED

Recommended actions:
• Go to emergency room within 1-2 hours
• Or call 911/115 if unable to travel
• Monitor symptoms closely

This is an urgent medical situation requiring immediate professional care.`;
    } else {
      // Standard medical guidance
      return `Based on your symptoms, I recommend ${assessment.recommendedAction.toLowerCase()} ${assessment.timeframe.toLowerCase()}.

${assessment.indicators.length > 0 ? `Key concerns identified: ${assessment.indicators.join(', ')}` : ''}

Please remember that this is general guidance and not a substitute for professional medical evaluation. If symptoms worsen or you feel this is an emergency, seek immediate medical care.`;
    }
  }

  private getEmergencyFallbackResponse(): string {
    return `🚨 I'm experiencing technical difficulties but want to ensure your safety.

If this is a medical emergency:
• Call 911 (US) or 115 (Vietnam) immediately
• Go to the nearest emergency room
• Contact your healthcare provider

If symptoms are severe or life-threatening, do not wait - seek immediate medical attention.

This is a safety fallback response. Please consult with healthcare professionals for proper medical evaluation.`;
  }
}
