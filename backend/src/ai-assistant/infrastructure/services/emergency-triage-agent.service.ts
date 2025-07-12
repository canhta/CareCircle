import { Injectable, Logger } from '@nestjs/common';
import { ChatOpenAI } from '@langchain/openai';
import { z } from 'zod';

export interface EmergencyContext {
  symptoms: string[];
  duration: string;
  severity: 'mild' | 'moderate' | 'severe' | 'critical';
  vitalSigns?: {
    bloodPressure?: string;
    heartRate?: number;
    temperature?: number;
    respiratoryRate?: number;
    oxygenSaturation?: number;
  };
  patientAge?: number;
  medicalHistory?: string[];
  currentMedications?: string[];
  allergies?: string[];
  consciousnessLevel?: 'alert' | 'confused' | 'drowsy' | 'unconscious';
  location?: string;
}

export interface TriageAssessment {
  triageLevel: 1 | 2 | 3 | 4 | 5; // 1 = Immediate, 5 = Non-urgent
  triageColor: 'red' | 'orange' | 'yellow' | 'green' | 'blue';
  urgencyDescription: string;
  estimatedWaitTime: string;
  immediateActions: string[];
  warningSigns: string[];
  dispositionRecommendation:
    | 'emergency_department'
    | 'urgent_care'
    | 'primary_care'
    | 'self_care'
    | 'call_911';
}

export interface EmergencyResponse {
  response: string;
  triageAssessment: TriageAssessment;
  immediateInstructions: string[];
  emergencyContacts: {
    vietnam: string[];
    international: string[];
  };
  redFlags: string[];
  safetyInstructions: string[];
  followUpGuidance: string[];
  confidence: number;
  requiresImmediateAction: boolean;
}

@Injectable()
export class EmergencyTriageAgentService {
  private readonly logger = new Logger(EmergencyTriageAgentService.name);
  private model: ChatOpenAI;

  // Critical emergency symptoms (Red flags)
  private readonly criticalSymptoms = new Set([
    'chest pain',
    'difficulty breathing',
    'severe bleeding',
    'unconscious',
    'stroke symptoms',
    'severe head injury',
    'severe burns',
    'poisoning',
    'severe allergic reaction',
    'cardiac arrest',
    'đau ngực',
    'khó thở',
    'xuất huyết nặng',
    'bất tỉnh',
    'đột quỵ',
    'chấn thương đầu nặng',
  ]);

  // High-priority symptoms (Orange)
  private readonly highPrioritySymptoms = new Set([
    'severe pain',
    'high fever',
    'vomiting blood',
    'severe dehydration',
    'severe abdominal pain',
    'suspected fracture',
    'severe headache',
    'vision changes',
    'đau dữ dội',
    'sốt cao',
    'nôn ra máu',
    'mất nước nặng',
    'đau bụng dữ dội',
  ]);

  // Vietnamese emergency contacts
  private readonly vietnamEmergencyContacts = [
    '115 - Cấp cứu y tế',
    '113 - Công an',
    '114 - Cứu hỏa',
    '1900 4595 - Trung tâm chống độc',
  ];

  constructor() {
    this.model = new ChatOpenAI({
      modelName: 'gpt-4',
      temperature: 0.05, // Extremely low temperature for emergency accuracy
    });
  }

  async processEmergencyQuery(
    query: string,
    emergencyContext: EmergencyContext,
  ): Promise<EmergencyResponse> {
    try {
      this.logger.log(
        `Processing emergency query: ${query.substring(0, 50)}...`,
      );

      // Immediate triage assessment
      const triageAssessment = await this.performTriageAssessment(
        query,
        emergencyContext,
      );

      // Generate emergency response
      const response = await this.generateEmergencyResponse(
        query,
        emergencyContext,
        triageAssessment,
      );

      // Log critical cases for monitoring
      if (triageAssessment.triageLevel <= 2) {
        this.logger.warn(
          `Critical emergency case detected: Triage Level ${triageAssessment.triageLevel}`,
        );
      }

      return response;
    } catch (error) {
      this.logger.error('Error processing emergency query:', error);

      // Return safe fallback for emergencies
      return this.generateEmergencyFallbackResponse();
    }
  }

  private async performTriageAssessment(
    query: string,
    context: EmergencyContext,
  ): Promise<TriageAssessment> {
    const symptoms = this.extractSymptoms(query, context);
    const vitalSigns = context.vitalSigns;

    // Determine triage level based on symptoms and vital signs
    let triageLevel: 1 | 2 | 3 | 4 | 5 = 5;
    let triageColor: 'red' | 'orange' | 'yellow' | 'green' | 'blue' = 'blue';
    let urgencyDescription = 'Non-urgent';
    let estimatedWaitTime = '2-4 hours';
    let dispositionRecommendation:
      | 'emergency_department'
      | 'urgent_care'
      | 'primary_care'
      | 'self_care'
      | 'call_911' = 'self_care';

    // Check for critical symptoms (Triage Level 1 - Red)
    if (
      this.hasCriticalSymptoms(symptoms) ||
      this.hasCriticalVitals(vitalSigns)
    ) {
      triageLevel = 1;
      triageColor = 'red';
      urgencyDescription = 'Immediate - Life threatening';
      estimatedWaitTime = 'Immediate';
      dispositionRecommendation = 'call_911';
    }
    // Check for high-priority symptoms (Triage Level 2 - Orange)
    else if (
      this.hasHighPrioritySymptoms(symptoms) ||
      this.hasAbnormalVitals(vitalSigns)
    ) {
      triageLevel = 2;
      triageColor = 'orange';
      urgencyDescription = 'Urgent - Potentially life threatening';
      estimatedWaitTime = '15-30 minutes';
      dispositionRecommendation = 'emergency_department';
    }
    // Moderate priority (Triage Level 3 - Yellow)
    else if (
      context.severity === 'moderate' ||
      this.hasModerateSymptoms(symptoms)
    ) {
      triageLevel = 3;
      triageColor = 'yellow';
      urgencyDescription = 'Less urgent - Stable but needs care';
      estimatedWaitTime = '1-2 hours';
      dispositionRecommendation = 'urgent_care';
    }
    // Low priority (Triage Level 4 - Green)
    else if (context.severity === 'mild') {
      triageLevel = 4;
      triageColor = 'green';
      urgencyDescription = 'Non-urgent - Stable';
      estimatedWaitTime = '2-4 hours';
      dispositionRecommendation = 'primary_care';
    }

    const immediateActions = this.generateImmediateActions(
      triageLevel,
      symptoms,
    );
    const warningSigns = this.generateWarningSigns(symptoms, context);

    return {
      triageLevel,
      triageColor,
      urgencyDescription,
      estimatedWaitTime,
      immediateActions,
      warningSigns,
      dispositionRecommendation,
    };
  }

  private extractSymptoms(query: string, context: EmergencyContext): string[] {
    const symptoms = [...context.symptoms];
    const lowerQuery = query.toLowerCase();

    // Extract additional symptoms from query text
    const symptomKeywords = [
      'pain',
      'bleeding',
      'breathing',
      'chest',
      'head',
      'fever',
      'nausea',
      'đau',
      'chảy máu',
      'thở',
      'ngực',
      'đầu',
      'sốt',
      'buồn nôn',
    ];

    symptomKeywords.forEach((keyword) => {
      if (lowerQuery.includes(keyword) && !symptoms.includes(keyword)) {
        symptoms.push(keyword);
      }
    });

    return symptoms;
  }

  private hasCriticalSymptoms(symptoms: string[]): boolean {
    return symptoms.some((symptom) =>
      Array.from(this.criticalSymptoms).some((critical) =>
        symptom.toLowerCase().includes(critical.toLowerCase()),
      ),
    );
  }

  private hasHighPrioritySymptoms(symptoms: string[]): boolean {
    return symptoms.some((symptom) =>
      Array.from(this.highPrioritySymptoms).some((priority) =>
        symptom.toLowerCase().includes(priority.toLowerCase()),
      ),
    );
  }

  private hasModerateSymptoms(symptoms: string[]): boolean {
    const moderateSymptoms = [
      'headache',
      'fever',
      'abdominal pain',
      'back pain',
    ];
    return symptoms.some((symptom) =>
      moderateSymptoms.some((moderate) =>
        symptom.toLowerCase().includes(moderate),
      ),
    );
  }

  private hasCriticalVitals(
    vitalSigns?: EmergencyContext['vitalSigns'],
  ): boolean {
    if (!vitalSigns) return false;

    // Critical vital sign ranges
    if (
      vitalSigns.heartRate &&
      (vitalSigns.heartRate < 40 || vitalSigns.heartRate > 150)
    )
      return true;
    if (
      vitalSigns.temperature &&
      (vitalSigns.temperature < 35 || vitalSigns.temperature > 40)
    )
      return true;
    if (vitalSigns.oxygenSaturation && vitalSigns.oxygenSaturation < 90)
      return true;
    if (
      vitalSigns.respiratoryRate &&
      (vitalSigns.respiratoryRate < 8 || vitalSigns.respiratoryRate > 30)
    )
      return true;

    return false;
  }

  private hasAbnormalVitals(
    vitalSigns?: EmergencyContext['vitalSigns'],
  ): boolean {
    if (!vitalSigns) return false;

    // Abnormal but not critical vital sign ranges
    if (
      vitalSigns.heartRate &&
      (vitalSigns.heartRate < 50 || vitalSigns.heartRate > 120)
    )
      return true;
    if (
      vitalSigns.temperature &&
      (vitalSigns.temperature < 36 || vitalSigns.temperature > 38.5)
    )
      return true;
    if (vitalSigns.oxygenSaturation && vitalSigns.oxygenSaturation < 95)
      return true;

    return false;
  }

  private generateImmediateActions(
    triageLevel: number,
    symptoms: string[],
  ): string[] {
    const actions: string[] = [];

    if (triageLevel === 1) {
      actions.push('Call 911/115 immediately');
      actions.push('Do not leave patient alone');
      actions.push('Be prepared to perform CPR if needed');
      actions.push('Keep airway clear');
    } else if (triageLevel === 2) {
      actions.push('Seek immediate medical attention');
      actions.push('Go to emergency department');
      actions.push('Monitor vital signs');
      actions.push('Do not eat or drink');
    } else if (triageLevel === 3) {
      actions.push('Seek medical care within 2-4 hours');
      actions.push('Monitor symptoms closely');
      actions.push('Take pain medication if appropriate');
    }

    return actions;
  }

  private generateWarningSigns(
    symptoms: string[],
    context: EmergencyContext,
  ): string[] {
    const warningSigns: string[] = [
      'Worsening symptoms',
      'New or different symptoms',
      'Difficulty breathing',
      'Chest pain',
      'Loss of consciousness',
      'Severe bleeding',
    ];

    // Add Vietnamese warning signs
    warningSigns.push(
      'Triệu chứng trở nên tệ hơn',
      'Xuất hiện triệu chứng mới',
      'Khó thở',
      'Đau ngực',
      'Mất ý thức',
      'Chảy máu nhiều',
    );

    return warningSigns;
  }

  private async generateEmergencyResponse(
    query: string,
    context: EmergencyContext,
    triageAssessment: TriageAssessment,
  ): Promise<EmergencyResponse> {
    const systemPrompt = `You are an emergency triage AI assistant specializing in Vietnamese healthcare emergency protocols.

Triage Assessment:
- Level: ${triageAssessment.triageLevel} (${triageAssessment.triageColor})
- Urgency: ${triageAssessment.urgencyDescription}
- Disposition: ${triageAssessment.dispositionRecommendation}

Patient Context:
- Symptoms: ${context.symptoms.join(', ')}
- Severity: ${context.severity}
- Age: ${context.patientAge || 'Not specified'}
- Medical History: ${context.medicalHistory?.join(', ') || 'None specified'}

CRITICAL INSTRUCTIONS:
1. If triage level 1-2: Emphasize immediate medical attention
2. Provide clear, actionable instructions
3. Include Vietnamese emergency contacts when relevant
4. Never provide medical diagnosis - focus on triage and safety
5. Always emphasize professional medical evaluation

Respond with clear emergency guidance appropriate for the triage level.`;

    const response = await this.model.invoke([
      { role: 'system', content: systemPrompt },
      { role: 'user', content: query },
    ]);

    return {
      response: response.content as string,
      triageAssessment,
      immediateInstructions: triageAssessment.immediateActions,
      emergencyContacts: {
        vietnam: this.vietnamEmergencyContacts,
        international: ['911 (US)', '999 (UK)', '112 (EU)'],
      },
      redFlags: this.generateRedFlags(context),
      safetyInstructions: this.generateSafetyInstructions(
        triageAssessment.triageLevel,
      ),
      followUpGuidance: this.generateFollowUpGuidance(triageAssessment),
      confidence: 0.95,
      requiresImmediateAction: triageAssessment.triageLevel <= 2,
    };
  }

  private generateRedFlags(context: EmergencyContext): string[] {
    return [
      'Difficulty breathing or shortness of breath',
      'Chest pain or pressure',
      "Severe bleeding that won't stop",
      'Loss of consciousness or confusion',
      'Severe allergic reaction',
      'Signs of stroke (face drooping, arm weakness, speech difficulty)',
      'Khó thở hoặc thở gấp',
      'Đau ngực hoặc cảm giác bị ép',
      'Chảy máu nhiều không cầm được',
      'Mất ý thức hoặc lú lẫn',
      'Phản ứng dị ứng nặng',
      'Dấu hiệu đột quỵ',
    ];
  }

  private generateSafetyInstructions(triageLevel: number): string[] {
    const instructions: string[] = [
      'Stay calm and assess the situation',
      'Ensure scene safety before approaching',
      'Call for help if needed',
    ];

    if (triageLevel <= 2) {
      instructions.push(
        'Do not move patient unless in immediate danger',
        'Keep patient warm and comfortable',
        'Monitor breathing and consciousness',
        'Be prepared to perform first aid',
      );
    }

    return instructions;
  }

  private generateFollowUpGuidance(
    triageAssessment: TriageAssessment,
  ): string[] {
    const guidance: string[] = [];

    if (triageAssessment.triageLevel <= 2) {
      guidance.push('Follow up with emergency department');
      guidance.push('Continue monitoring as directed by medical staff');
    } else {
      guidance.push('Follow up with primary care physician');
      guidance.push('Return if symptoms worsen');
      guidance.push('Take medications as prescribed');
    }

    return guidance;
  }

  private generateEmergencyFallbackResponse(): EmergencyResponse {
    return {
      response:
        'I apologize, but I encountered an error processing your emergency query. For any medical emergency, please call 911 (US) or 115 (Vietnam) immediately. Do not delay seeking professional medical help.',
      triageAssessment: {
        triageLevel: 1,
        triageColor: 'red',
        urgencyDescription: 'Immediate medical attention required',
        estimatedWaitTime: 'Immediate',
        immediateActions: ['Call emergency services immediately'],
        warningSigns: ['Any worsening symptoms'],
        dispositionRecommendation: 'call_911',
      },
      immediateInstructions: ['Call emergency services immediately'],
      emergencyContacts: {
        vietnam: this.vietnamEmergencyContacts,
        international: ['911 (US)', '999 (UK)', '112 (EU)'],
      },
      redFlags: ['Any concerning symptoms'],
      safetyInstructions: ['Seek immediate professional medical help'],
      followUpGuidance: ['Follow emergency medical guidance'],
      confidence: 1.0,
      requiresImmediateAction: true,
    };
  }
}
