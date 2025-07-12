import { Injectable, Logger } from '@nestjs/common';
import { ChatOpenAI } from '@langchain/openai';
import { z } from 'zod';

export interface MedicationContext {
  currentMedications: string[];
  allergies: string[];
  medicalConditions: string[];
  age?: number;
  weight?: number;
  pregnancyStatus?: 'pregnant' | 'breastfeeding' | 'not_applicable';
  kidneyFunction?:
    | 'normal'
    | 'mild_impairment'
    | 'moderate_impairment'
    | 'severe_impairment';
  liverFunction?:
    | 'normal'
    | 'mild_impairment'
    | 'moderate_impairment'
    | 'severe_impairment';
}

export interface DrugInteractionCheck {
  severity: 'minor' | 'moderate' | 'major' | 'contraindicated';
  description: string;
  mechanism: string;
  clinicalEffect: string;
  management: string;
  confidence: number;
}

export interface MedicationRecommendation {
  type:
    | 'dosage_adjustment'
    | 'timing_optimization'
    | 'alternative_medication'
    | 'monitoring_required'
    | 'lifestyle_modification';
  priority: 'low' | 'medium' | 'high' | 'critical';
  description: string;
  rationale: string;
  actionRequired: string;
}

export interface MedicationResponse {
  response: string;
  drugInteractions: DrugInteractionCheck[];
  recommendations: MedicationRecommendation[];
  safetyAlerts: string[];
  adherenceAdvice: string[];
  monitoringRequirements: string[];
  urgencyLevel: number;
  requiresPharmacistConsultation: boolean;
  requiresPhysicianConsultation: boolean;
  confidence: number;
}

@Injectable()
export class MedicationManagementAgentService {
  private readonly logger = new Logger(MedicationManagementAgentService.name);
  private model: ChatOpenAI;

  // Vietnamese medication name mappings
  private readonly vietnameseMedications = new Map([
    ['paracetamol', 'acetaminophen'],
    ['aspirin', 'acetylsalicylic acid'],
    ['ibuprofen', 'ibuprofen'],
    ['amoxicillin', 'amoxicillin'],
    ['metformin', 'metformin'],
    ['lisinopril', 'lisinopril'],
    ['atorvastatin', 'atorvastatin'],
    ['omeprazole', 'omeprazole'],
  ]);

  // Common drug interaction patterns
  private readonly majorInteractions = new Map([
    ['warfarin+aspirin', 'Increased bleeding risk'],
    ['metformin+contrast', 'Lactic acidosis risk'],
    ['ace_inhibitor+potassium', 'Hyperkalemia risk'],
    ['statin+fibrate', 'Rhabdomyolysis risk'],
    ['digoxin+diuretic', 'Digitalis toxicity'],
  ]);

  // Medication adherence factors
  private readonly adherenceFactors = [
    'complex_regimen',
    'side_effects',
    'cost_concerns',
    'forgetfulness',
    'lack_of_understanding',
    'cultural_beliefs',
    'multiple_medications',
  ];

  constructor() {
    this.model = new ChatOpenAI({
      modelName: 'gpt-4',
      temperature: 0.1, // Very low temperature for medication safety
    });
  }

  async processMedicationQuery(
    query: string,
    medicationContext: MedicationContext,
  ): Promise<MedicationResponse> {
    try {
      this.logger.log(
        `Processing medication query: ${query.substring(0, 50)}...`,
      );

      // Analyze medication safety
      const safetyAnalysis = await this.analyzeMedicationSafety(
        query,
        medicationContext,
      );

      // Check drug interactions
      const interactions = await this.checkDrugInteractions(medicationContext);

      // Generate recommendations
      const recommendations = await this.generateMedicationRecommendations(
        query,
        medicationContext,
      );

      // Generate comprehensive response
      const response = await this.generateMedicationResponse(
        query,
        medicationContext,
        {
          safetyAnalysis,
          interactions,
          recommendations,
        },
      );

      return response;
    } catch (error) {
      this.logger.error('Error processing medication query:', error);
      throw new Error('Failed to process medication query');
    }
  }

  private async analyzeMedicationSafety(
    query: string,
    context: MedicationContext,
  ): Promise<{
    riskLevel: 'low' | 'medium' | 'high' | 'critical';
    riskFactors: string[];
    safetyAlerts: string[];
  }> {
    const riskFactors: string[] = [];
    const safetyAlerts: string[] = [];
    let riskLevel: 'low' | 'medium' | 'high' | 'critical' = 'low';

    // Age-related risks
    if (context.age && (context.age < 18 || context.age > 65)) {
      riskFactors.push('age_related_risk');
      if (context.age > 75) {
        riskLevel = 'medium';
        safetyAlerts.push(
          'Elderly patients require careful medication monitoring',
        );
      }
    }

    // Pregnancy/breastfeeding risks
    if (
      context.pregnancyStatus === 'pregnant' ||
      context.pregnancyStatus === 'breastfeeding'
    ) {
      riskLevel = 'high';
      riskFactors.push('pregnancy_breastfeeding');
      safetyAlerts.push(
        'Special precautions required during pregnancy/breastfeeding',
      );
    }

    // Organ function impairment
    if (context.kidneyFunction && context.kidneyFunction !== 'normal') {
      riskFactors.push('kidney_impairment');
      if (context.kidneyFunction === 'severe_impairment') {
        riskLevel = 'high';
        safetyAlerts.push('Severe kidney impairment requires dose adjustments');
      }
    }

    if (context.liverFunction && context.liverFunction !== 'normal') {
      riskFactors.push('liver_impairment');
      if (context.liverFunction === 'severe_impairment') {
        riskLevel = 'high';
        safetyAlerts.push('Severe liver impairment requires dose adjustments');
      }
    }

    // Polypharmacy risk
    if (context.currentMedications.length >= 5) {
      riskFactors.push('polypharmacy');
      riskLevel = riskLevel === 'low' ? 'medium' : riskLevel;
      safetyAlerts.push('Multiple medications increase interaction risk');
    }

    // Allergy considerations
    if (context.allergies.length > 0) {
      riskFactors.push('drug_allergies');
      safetyAlerts.push('Check for cross-reactivity with known allergies');
    }

    return { riskLevel, riskFactors, safetyAlerts };
  }

  private async checkDrugInteractions(
    context: MedicationContext,
  ): Promise<DrugInteractionCheck[]> {
    const interactions: DrugInteractionCheck[] = [];

    // Check pairwise interactions
    for (let i = 0; i < context.currentMedications.length; i++) {
      for (let j = i + 1; j < context.currentMedications.length; j++) {
        const drug1 = context.currentMedications[i].toLowerCase();
        const drug2 = context.currentMedications[j].toLowerCase();

        const interaction = this.findKnownInteraction(drug1, drug2);
        if (interaction) {
          interactions.push(interaction);
        }
      }
    }

    return interactions;
  }

  private findKnownInteraction(
    drug1: string,
    drug2: string,
  ): DrugInteractionCheck | null {
    // Simplified interaction checking - in production, use comprehensive drug database
    const interactionKey = `${drug1}+${drug2}`;
    const reverseKey = `${drug2}+${drug1}`;

    const knownInteraction =
      this.majorInteractions.get(interactionKey) ||
      this.majorInteractions.get(reverseKey);

    if (knownInteraction) {
      return {
        severity: 'major',
        description: `Interaction between ${drug1} and ${drug2}`,
        mechanism: knownInteraction,
        clinicalEffect: 'Potential adverse effects',
        management: 'Monitor closely and consider alternatives',
        confidence: 0.8,
      };
    }

    // Check for class-based interactions
    if (this.isAnticoagulant(drug1) && this.isAnticoagulant(drug2)) {
      return {
        severity: 'major',
        description: 'Multiple anticoagulants',
        mechanism: 'Additive anticoagulant effects',
        clinicalEffect: 'Increased bleeding risk',
        management: 'Avoid combination or monitor INR closely',
        confidence: 0.9,
      };
    }

    return null;
  }

  private isAnticoagulant(medication: string): boolean {
    const anticoagulants = [
      'warfarin',
      'heparin',
      'rivaroxaban',
      'apixaban',
      'dabigatran',
    ];
    return anticoagulants.some((drug) =>
      medication.toLowerCase().includes(drug),
    );
  }

  private async generateMedicationRecommendations(
    query: string,
    context: MedicationContext,
  ): Promise<MedicationRecommendation[]> {
    const recommendations: MedicationRecommendation[] = [];

    // Adherence optimization
    if (context.currentMedications.length >= 3) {
      recommendations.push({
        type: 'timing_optimization',
        priority: 'medium',
        description: 'Consider medication timing optimization',
        rationale: 'Multiple medications can be complex to manage',
        actionRequired: 'Discuss with pharmacist about timing schedules',
      });
    }

    // Age-specific recommendations
    if (context.age && context.age > 65) {
      recommendations.push({
        type: 'monitoring_required',
        priority: 'high',
        description: 'Enhanced monitoring for elderly patients',
        rationale: 'Age-related changes in drug metabolism',
        actionRequired: 'Regular follow-up with healthcare provider',
      });
    }

    // Organ function adjustments
    if (context.kidneyFunction && context.kidneyFunction !== 'normal') {
      recommendations.push({
        type: 'dosage_adjustment',
        priority: 'high',
        description: 'Dose adjustment may be required',
        rationale: 'Impaired kidney function affects drug clearance',
        actionRequired: 'Consult physician for dose modification',
      });
    }

    return recommendations;
  }

  private async generateMedicationResponse(
    query: string,
    context: MedicationContext,
    analysis: any,
  ): Promise<MedicationResponse> {
    const systemPrompt = `You are a specialized medication management AI assistant with expertise in:
- Drug interactions and contraindications
- Dosage optimization and timing
- Medication adherence strategies
- Safety monitoring requirements
- Vietnamese medication practices and preferences

Patient Context:
- Current medications: ${context.currentMedications.join(', ')}
- Known allergies: ${context.allergies.join(', ')}
- Medical conditions: ${context.medicalConditions.join(', ')}
- Age: ${context.age || 'Not specified'}

Safety Analysis:
- Risk level: ${analysis.safetyAnalysis.riskLevel}
- Risk factors: ${analysis.safetyAnalysis.riskFactors.join(', ')}

Provide comprehensive medication guidance including:
1. Direct answer to the medication question
2. Safety considerations and warnings
3. Adherence improvement strategies
4. Monitoring requirements
5. When to consult healthcare providers

Always emphasize medication safety and the importance of professional oversight.
Include Vietnamese cultural considerations for medication adherence when relevant.`;

    const response = await this.model.invoke([
      { role: 'system', content: systemPrompt },
      { role: 'user', content: query },
    ]);

    const urgencyLevel = this.calculateMedicationUrgency(analysis);

    return {
      response: response.content as string,
      drugInteractions: analysis.interactions,
      recommendations: analysis.recommendations,
      safetyAlerts: analysis.safetyAnalysis.safetyAlerts,
      adherenceAdvice: this.generateAdherenceAdvice(context),
      monitoringRequirements: this.generateMonitoringRequirements(context),
      urgencyLevel,
      requiresPharmacistConsultation:
        analysis.interactions.length > 0 ||
        context.currentMedications.length >= 5,
      requiresPhysicianConsultation:
        urgencyLevel > 0.7 || analysis.safetyAnalysis.riskLevel === 'critical',
      confidence: 0.85,
    };
  }

  private calculateMedicationUrgency(analysis: any): number {
    let urgency = 0.1;

    // Critical interactions
    const criticalInteractions = analysis.interactions.filter(
      (i: DrugInteractionCheck) =>
        i.severity === 'contraindicated' || i.severity === 'major',
    );
    urgency += criticalInteractions.length * 0.3;

    // High-risk patient factors
    if (analysis.safetyAnalysis.riskLevel === 'critical') urgency += 0.4;
    if (analysis.safetyAnalysis.riskLevel === 'high') urgency += 0.2;

    return Math.min(1.0, urgency);
  }

  private generateAdherenceAdvice(context: MedicationContext): string[] {
    const advice: string[] = [
      'Take medications at the same time each day',
      'Use a pill organizer for multiple medications',
      'Set phone reminders for medication times',
      'Keep a medication list updated',
    ];

    if (context.currentMedications.length >= 5) {
      advice.push(
        'Consider asking pharmacist about medication synchronization',
      );
      advice.push('Review all medications with healthcare provider regularly');
    }

    // Vietnamese cultural considerations
    advice.push('Discuss any traditional medicine use with your doctor');
    advice.push('Involve family members in medication management if helpful');

    return advice;
  }

  private generateMonitoringRequirements(context: MedicationContext): string[] {
    const requirements: string[] = [];

    // Age-based monitoring
    if (context.age && context.age > 65) {
      requirements.push('Regular medication review every 3-6 months');
      requirements.push('Monitor for side effects more frequently');
    }

    // Organ function monitoring
    if (context.kidneyFunction && context.kidneyFunction !== 'normal') {
      requirements.push('Regular kidney function tests');
    }

    if (context.liverFunction && context.liverFunction !== 'normal') {
      requirements.push('Regular liver function tests');
    }

    // Polypharmacy monitoring
    if (context.currentMedications.length >= 5) {
      requirements.push('Comprehensive medication review quarterly');
      requirements.push('Drug interaction screening');
    }

    return requirements;
  }
}
