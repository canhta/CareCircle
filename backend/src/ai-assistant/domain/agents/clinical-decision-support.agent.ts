import { Injectable, Logger } from '@nestjs/common';
import { BaseHealthcareAgent, HealthcareContext, AgentResponse, AgentCapability } from './base-healthcare.agent';
import { PHIProtectionService } from '../../../common/compliance/phi-protection.service';
import { VietnameseNLPIntegrationService } from '../../infrastructure/services/vietnamese-nlp-integration.service';

export interface ClinicalContext extends HealthcareContext {
  symptoms?: string[];
  symptomDuration?: string;
  symptomSeverity?: number; // 1-10 scale
  medicalHistory?: string[];
  familyHistory?: string[];
  currentMedications?: string[];
  recentLabResults?: Array<{
    test: string;
    value: string;
    normalRange: string;
    date: string;
  }>;
  vitalSigns?: {
    bloodPressure?: string;
    heartRate?: number;
    temperature?: number;
    weight?: number;
    height?: number;
  };
  lifestyle?: {
    smoking?: boolean;
    alcohol?: string;
    exercise?: string;
    diet?: string;
  };
}

export interface ClinicalGuidance {
  differentialDiagnosis: string[];
  recommendedTests: string[];
  redFlags: string[];
  followUpRecommendations: string[];
  patientEducation: string[];
  evidenceLevel: 'high' | 'moderate' | 'low';
  clinicalGuidelines: string[];
}

export interface SymptomAnalysis {
  primarySymptoms: string[];
  associatedSymptoms: string[];
  systemsInvolved: string[];
  urgencyIndicators: string[];
  chronicVsAcute: 'chronic' | 'acute' | 'acute_on_chronic';
}

@Injectable()
export class ClinicalDecisionSupportAgent extends BaseHealthcareAgent {
  private readonly logger = new Logger(ClinicalDecisionSupportAgent.name);

  constructor(
    phiProtectionService: PHIProtectionService,
    vietnameseNLPService: VietnameseNLPIntegrationService,
  ) {
    super('clinical_decision_support', phiProtectionService, vietnameseNLPService, {
      modelName: 'gpt-4',
      temperature: 0.2, // Low temperature for clinical consistency
      maxTokens: 3000,
    });
  }

  protected defineCapabilities(): AgentCapability[] {
    return [
      {
        name: 'Symptom Analysis',
        description: 'Analyze symptoms and provide differential diagnosis considerations',
        confidence: 0.8,
        requiresPhysicianReview: true,
        maxSeverityLevel: 7,
        supportedLanguages: ['vietnamese', 'english', 'mixed'],
        medicalSpecialties: ['internal_medicine', 'family_medicine', 'diagnostic_medicine'],
      },
      {
        name: 'Evidence-Based Guidance',
        description: 'Provide clinical guidance based on medical evidence and guidelines',
        confidence: 0.85,
        requiresPhysicianReview: true,
        maxSeverityLevel: 6,
        supportedLanguages: ['vietnamese', 'english', 'mixed'],
        medicalSpecialties: ['evidence_based_medicine', 'clinical_guidelines'],
      },
      {
        name: 'Vietnamese Clinical Context',
        description: 'Provide clinical guidance adapted for Vietnamese healthcare context',
        confidence: 0.75,
        requiresPhysicianReview: true,
        maxSeverityLevel: 6,
        supportedLanguages: ['vietnamese', 'mixed'],
        medicalSpecialties: ['vietnamese_medicine', 'cultural_medicine'],
      },
      {
        name: 'Patient Education',
        description: 'Provide evidence-based patient education and health information',
        confidence: 0.9,
        requiresPhysicianReview: false,
        maxSeverityLevel: 5,
        supportedLanguages: ['vietnamese', 'english', 'mixed'],
        medicalSpecialties: ['patient_education', 'health_promotion'],
      },
    ];
  }

  protected async processAgentSpecificQuery(
    query: string,
    context: HealthcareContext,
  ): Promise<AgentResponse> {
    try {
      this.logger.log(`Processing clinical query: ${query.substring(0, 50)}...`);

      const clinicalContext = context as ClinicalContext;

      // Analyze symptoms and clinical presentation
      const symptomAnalysis = await this.analyzeSymptoms(query, clinicalContext);

      // Generate clinical guidance
      const clinicalGuidance = await this.generateClinicalGuidance(query, symptomAnalysis, clinicalContext);

      // Assess need for immediate medical attention
      const urgencyAssessment = await this.assessClinicalUrgency(symptomAnalysis, clinicalContext);

      // Generate comprehensive clinical response
      const response = await this.generateClinicalResponse(
        query,
        symptomAnalysis,
        clinicalGuidance,
        urgencyAssessment,
        clinicalContext
      );

      return {
        agentType: 'clinical_decision_support',
        response,
        confidence: this.calculateClinicalConfidence(symptomAnalysis, clinicalGuidance),
        requiresEscalation: urgencyAssessment.requiresImmediateAttention,
        metadata: {
          symptomAnalysis,
          clinicalGuidance,
          urgencyAssessment,
          evidenceLevel: clinicalGuidance.evidenceLevel,
          systemsInvolved: symptomAnalysis.systemsInvolved,
          redFlags: clinicalGuidance.redFlags,
          recommendedTests: clinicalGuidance.recommendedTests,
        },
      };
    } catch (error) {
      this.logger.error('Clinical decision support processing failed:', error);
      throw new Error(`Clinical decision support failed: ${error.message}`);
    }
  }

  private async analyzeSymptoms(query: string, context: ClinicalContext): Promise<SymptomAnalysis> {
    const analysisPrompt = `Analyze the symptoms and clinical presentation described:

Query: "${query}"

Patient Context:
- Symptoms: ${context.symptoms?.join(', ') || 'as described in query'}
- Duration: ${context.symptomDuration || 'unknown'}
- Severity (1-10): ${context.symptomSeverity || 'unknown'}
- Medical History: ${context.medicalHistory?.join(', ') || 'none provided'}
- Current Medications: ${context.currentMedications?.join(', ') || 'none provided'}

Vital Signs:
- Blood Pressure: ${context.vitalSigns?.bloodPressure || 'unknown'}
- Heart Rate: ${context.vitalSigns?.heartRate || 'unknown'}
- Temperature: ${context.vitalSigns?.temperature || 'unknown'}

Provide analysis of:
1. Primary symptoms (main complaints)
2. Associated symptoms (related findings)
3. Body systems involved
4. Urgency indicators (red flags)
5. Whether this appears chronic, acute, or acute-on-chronic

Consider Vietnamese healthcare context and cultural factors in symptom presentation.`;

    const response = await this.model.invoke([
      { role: 'system', content: analysisPrompt },
      { role: 'user', content: query },
    ]);

    return this.parseSymptomAnalysis(response.content as string, query, context);
  }

  private async generateClinicalGuidance(
    query: string,
    symptomAnalysis: SymptomAnalysis,
    context: ClinicalContext
  ): Promise<ClinicalGuidance> {
    const guidancePrompt = `Provide evidence-based clinical guidance for this presentation:

Primary Symptoms: ${symptomAnalysis.primarySymptoms.join(', ')}
Systems Involved: ${symptomAnalysis.systemsInvolved.join(', ')}
Presentation Type: ${symptomAnalysis.chronicVsAcute}

Patient Context:
- Age: ${context.age || 'unknown'}
- Medical History: ${context.medicalHistory?.join(', ') || 'none'}
- Family History: ${context.familyHistory?.join(', ') || 'none'}
- Current Medications: ${context.currentMedications?.join(', ') || 'none'}

Provide:
1. Differential diagnosis considerations (most likely conditions to consider)
2. Recommended diagnostic tests or evaluations
3. Red flag symptoms requiring immediate attention
4. Follow-up recommendations and monitoring
5. Patient education points
6. Relevant clinical guidelines or evidence sources

Focus on evidence-based medicine and include Vietnamese healthcare considerations where relevant.
Always emphasize that this is educational information, not medical diagnosis.`;

    const response = await this.model.invoke([
      { role: 'system', content: guidancePrompt },
      { role: 'user', content: query },
    ]);

    return this.parseClinicalGuidance(response.content as string);
  }

  private async assessClinicalUrgency(
    symptomAnalysis: SymptomAnalysis,
    context: ClinicalContext
  ): Promise<{ requiresImmediateAttention: boolean; urgencyLevel: number; reasoning: string }> {
    // Check for red flag symptoms
    const redFlags = [
      'chest pain', 'difficulty breathing', 'severe headache', 'sudden weakness',
      'loss of consciousness', 'severe abdominal pain', 'high fever',
      'đau ngực', 'khó thở', 'đau đầu dữ dội', 'yếu liệt đột ngột'
    ];

    const hasRedFlags = symptomAnalysis.urgencyIndicators.length > 0 ||
      redFlags.some(flag => symptomAnalysis.primarySymptoms.some(symptom => 
        symptom.toLowerCase().includes(flag)
      ));

    // Assess severity based on context
    const highSeverity = context.symptomSeverity && context.symptomSeverity >= 8;
    const acuteOnset = symptomAnalysis.chronicVsAcute === 'acute';

    const urgencyLevel = hasRedFlags ? 0.8 : (highSeverity ? 0.6 : (acuteOnset ? 0.4 : 0.2));

    return {
      requiresImmediateAttention: urgencyLevel >= 0.7,
      urgencyLevel,
      reasoning: hasRedFlags ? 'Red flag symptoms detected' : 
                highSeverity ? 'High severity symptoms' :
                acuteOnset ? 'Acute onset symptoms' : 'Routine clinical assessment'
    };
  }

  private async generateClinicalResponse(
    query: string,
    symptomAnalysis: SymptomAnalysis,
    clinicalGuidance: ClinicalGuidance,
    urgencyAssessment: any,
    context: ClinicalContext
  ): Promise<string> {
    const isVietnamese = this.detectLanguage(query) === 'vietnamese';

    let response = '';

    // Urgency warning if needed
    if (urgencyAssessment.requiresImmediateAttention) {
      response += isVietnamese ? 
        '⚠️ CẢNH BÁO: Các triệu chứng này có thể cần chăm sóc y tế khẩn cấp. Hãy liên hệ với bác sĩ hoặc đến cơ sở y tế ngay lập tức.\n\n' :
        '⚠️ WARNING: These symptoms may require urgent medical attention. Please contact a healthcare provider or visit a medical facility immediately.\n\n';
    }

    // Clinical analysis
    response += isVietnamese ? 
      `📋 PHÂN TÍCH LÂM SÀNG:\n\nTriệu chứng chính: ${symptomAnalysis.primarySymptoms.join(', ')}\n` :
      `📋 CLINICAL ANALYSIS:\n\nPrimary symptoms: ${symptomAnalysis.primarySymptoms.join(', ')}\n`;

    if (symptomAnalysis.systemsInvolved.length > 0) {
      response += isVietnamese ?
        `Hệ thống cơ thể liên quan: ${symptomAnalysis.systemsInvolved.join(', ')}\n` :
        `Body systems involved: ${symptomAnalysis.systemsInvolved.join(', ')}\n`;
    }

    response += isVietnamese ?
      `Tính chất: ${symptomAnalysis.chronicVsAcute === 'acute' ? 'Cấp tính' : symptomAnalysis.chronicVsAcute === 'chronic' ? 'Mãn tính' : 'Cấp tính trên nền mãn tính'}\n\n` :
      `Nature: ${symptomAnalysis.chronicVsAcute}\n\n`;

    // Differential diagnosis
    if (clinicalGuidance.differentialDiagnosis.length > 0) {
      response += isVietnamese ?
        `🔍 CÁC TÌNH TRẠNG CẦN XEMXÉT:\n${clinicalGuidance.differentialDiagnosis.map(dx => `• ${dx}`).join('\n')}\n\n` :
        `🔍 CONDITIONS TO CONSIDER:\n${clinicalGuidance.differentialDiagnosis.map(dx => `• ${dx}`).join('\n')}\n\n`;
    }

    // Red flags
    if (clinicalGuidance.redFlags.length > 0) {
      response += isVietnamese ?
        `🚩 DẤU HIỆU CẢNH BÁO (cần chăm sóc y tế ngay):\n${clinicalGuidance.redFlags.map(flag => `• ${flag}`).join('\n')}\n\n` :
        `🚩 RED FLAGS (seek immediate medical care):\n${clinicalGuidance.redFlags.map(flag => `• ${flag}`).join('\n')}\n\n`;
    }

    // Recommended tests
    if (clinicalGuidance.recommendedTests.length > 0) {
      response += isVietnamese ?
        `🧪 XÉT NGHIỆM/ĐÁNH GIÁ ĐƯỢC KHUYẾN NGHỊ:\n${clinicalGuidance.recommendedTests.map(test => `• ${test}`).join('\n')}\n\n` :
        `🧪 RECOMMENDED TESTS/EVALUATIONS:\n${clinicalGuidance.recommendedTests.map(test => `• ${test}`).join('\n')}\n\n`;
    }

    // Follow-up recommendations
    if (clinicalGuidance.followUpRecommendations.length > 0) {
      response += isVietnamese ?
        `📅 KHUYẾN NGHỊ THEO DÕI:\n${clinicalGuidance.followUpRecommendations.map(rec => `• ${rec}`).join('\n')}\n\n` :
        `📅 FOLLOW-UP RECOMMENDATIONS:\n${clinicalGuidance.followUpRecommendations.map(rec => `• ${rec}`).join('\n')}\n\n`;
    }

    // Patient education
    if (clinicalGuidance.patientEducation.length > 0) {
      response += isVietnamese ?
        `📚 THÔNG TIN GIÁO DỤC BỆNH NHÂN:\n${clinicalGuidance.patientEducation.map(edu => `• ${edu}`).join('\n')}\n\n` :
        `📚 PATIENT EDUCATION:\n${clinicalGuidance.patientEducation.map(edu => `• ${edu}`).join('\n')}\n\n`;
    }

    // Medical disclaimer
    response += isVietnamese ?
      `⚠️ LƯU Ý QUAN TRỌNG: Thông tin này chỉ mang tính chất giáo dục và không thay thế cho việc khám và tư vấn y tế chuyên nghiệp. Hãy luôn tham khảo ý kiến bác sĩ để được chẩn đoán và điều trị chính xác.` :
      `⚠️ IMPORTANT DISCLAIMER: This information is for educational purposes only and does not replace professional medical consultation. Always consult with healthcare providers for proper diagnosis and treatment.`;

    return response;
  }

  private parseSymptomAnalysis(content: string, query: string, context: ClinicalContext): SymptomAnalysis {
    // Extract symptoms from query and context
    const primarySymptoms = context.symptoms || this.extractSymptomsFromText(query);
    
    // Determine systems involved based on symptoms
    const systemsInvolved = this.determineSystems(primarySymptoms);
    
    // Check for urgency indicators
    const urgencyIndicators = this.extractUrgencyIndicators(content, query);
    
    // Determine if chronic vs acute
    const chronicVsAcute = this.determineChronicVsAcute(context.symptomDuration, content);

    return {
      primarySymptoms,
      associatedSymptoms: this.extractAssociatedSymptoms(content),
      systemsInvolved,
      urgencyIndicators,
      chronicVsAcute,
    };
  }

  private parseClinicalGuidance(content: string): ClinicalGuidance {
    return {
      differentialDiagnosis: this.extractSection(content, 'differential|diagnosis|consider'),
      recommendedTests: this.extractSection(content, 'test|evaluation|investigation'),
      redFlags: this.extractSection(content, 'red flag|warning|urgent'),
      followUpRecommendations: this.extractSection(content, 'follow.?up|monitoring'),
      patientEducation: this.extractSection(content, 'education|patient|advice'),
      evidenceLevel: 'moderate', // Default to moderate
      clinicalGuidelines: this.extractSection(content, 'guideline|evidence|reference'),
    };
  }

  private extractSymptomsFromText(text: string): string[] {
    const commonSymptoms = [
      'headache', 'fever', 'cough', 'pain', 'nausea', 'fatigue', 'dizziness',
      'đau đầu', 'sốt', 'ho', 'đau', 'buồn nôn', 'mệt mỏi', 'chóng mặt'
    ];
    
    return commonSymptoms.filter(symptom => 
      text.toLowerCase().includes(symptom)
    );
  }

  private determineSystems(symptoms: string[]): string[] {
    const systems: string[] = [];
    const symptomText = symptoms.join(' ').toLowerCase();
    
    if (symptomText.includes('headache') || symptomText.includes('dizziness') || symptomText.includes('đau đầu')) {
      systems.push('neurological');
    }
    if (symptomText.includes('chest') || symptomText.includes('heart') || symptomText.includes('ngực')) {
      systems.push('cardiovascular');
    }
    if (symptomText.includes('cough') || symptomText.includes('breathing') || symptomText.includes('ho')) {
      systems.push('respiratory');
    }
    if (symptomText.includes('stomach') || symptomText.includes('nausea') || symptomText.includes('bụng')) {
      systems.push('gastrointestinal');
    }
    
    return systems;
  }

  private extractUrgencyIndicators(content: string, query: string): string[] {
    const urgencyKeywords = [
      'severe', 'sudden', 'acute', 'emergency', 'urgent',
      'nghiêm trọng', 'đột ngột', 'cấp tính', 'khẩn cấp'
    ];
    
    return urgencyKeywords.filter(keyword => 
      content.toLowerCase().includes(keyword) || query.toLowerCase().includes(keyword)
    );
  }

  private determineChronicVsAcute(duration?: string, content?: string): SymptomAnalysis['chronicVsAcute'] {
    if (!duration && !content) return 'acute';
    
    const durationText = (duration || '').toLowerCase();
    const contentText = (content || '').toLowerCase();
    
    if (durationText.includes('month') || durationText.includes('year') || 
        contentText.includes('chronic') || durationText.includes('tháng') || durationText.includes('năm')) {
      return 'chronic';
    }
    
    if (durationText.includes('sudden') || contentText.includes('acute') || 
        durationText.includes('đột ngột') || contentText.includes('cấp tính')) {
      return 'acute';
    }
    
    return 'acute';
  }

  private extractAssociatedSymptoms(content: string): string[] {
    // Extract associated symptoms mentioned in the analysis
    const lines = content.split('\n');
    const associatedSymptoms: string[] = [];
    
    lines.forEach(line => {
      if (line.toLowerCase().includes('associated') || line.toLowerCase().includes('related')) {
        associatedSymptoms.push(line.trim());
      }
    });
    
    return associatedSymptoms;
  }

  private extractSection(content: string, pattern: string): string[] {
    const regex = new RegExp(`(${pattern})[^\\n]*:?([^\\n]*(?:\\n[^\\n]*)*?)(?=\\n\\n|\\n[A-Z]|$)`, 'gi');
    const matches = content.match(regex);
    
    if (!matches) return [];
    
    return matches.flatMap(match => 
      match.split('\n')
        .filter(line => line.trim().startsWith('•') || line.trim().startsWith('-'))
        .map(line => line.replace(/^[•\-\s]+/, '').trim())
        .filter(line => line.length > 0)
    );
  }

  private calculateClinicalConfidence(symptomAnalysis: SymptomAnalysis, clinicalGuidance: ClinicalGuidance): number {
    let confidence = 0.8;
    
    // Reduce confidence if many systems involved (complex case)
    if (symptomAnalysis.systemsInvolved.length > 3) {
      confidence -= 0.1;
    }
    
    // Reduce confidence if many urgency indicators
    if (symptomAnalysis.urgencyIndicators.length > 2) {
      confidence -= 0.1;
    }
    
    // Increase confidence if evidence level is high
    if (clinicalGuidance.evidenceLevel === 'high') {
      confidence += 0.1;
    }
    
    return Math.max(confidence, 0.5);
  }
}
