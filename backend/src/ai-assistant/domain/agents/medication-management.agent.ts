import { Injectable, Logger } from '@nestjs/common';
import {
  BaseHealthcareAgent,
  HealthcareContext,
  AgentResponse,
  AgentCapability,
} from './base-healthcare.agent';
import { PHIProtectionService } from '../../../common/compliance/phi-protection.service';
import { VietnameseNLPIntegrationService } from '../../infrastructure/services/vietnamese-nlp-integration.service';

export interface MedicationContext extends HealthcareContext {
  currentMedications?: Array<{
    name: string;
    dosage: string;
    frequency: string;
    startDate?: string;
    prescribedBy?: string;
  }>;
  allergies?: string[];
  medicalConditions?: string[];
  age?: number;
  weight?: number;
  kidneyFunction?: 'normal' | 'mild' | 'moderate' | 'severe';
  liverFunction?: 'normal' | 'mild' | 'moderate' | 'severe';
}

export interface DrugInteraction {
  severity: 'minor' | 'moderate' | 'major' | 'contraindicated';
  description: string;
  mechanism: string;
  recommendation: string;
  evidenceLevel: 'low' | 'moderate' | 'high';
  clinicalSignificance: string;
  affectedMedications: string[];
}

export interface MedicationRecommendation {
  type:
    | 'dosage_adjustment'
    | 'alternative_medication'
    | 'monitoring'
    | 'timing_change';
  description: string;
  rationale: string;
  urgency: 'low' | 'medium' | 'high';
  requiresPhysicianApproval: boolean;
}

@Injectable()
export class MedicationManagementAgent extends BaseHealthcareAgent {
  private readonly logger = new Logger(MedicationManagementAgent.name);

  constructor(
    phiProtectionService: PHIProtectionService,
    vietnameseNLPService: VietnameseNLPIntegrationService,
  ) {
    super('medication_management', phiProtectionService, vietnameseNLPService, {
      modelName: 'gpt-4',
      temperature: 0.1, // Very low temperature for medication safety
      maxTokens: 2500,
    });
  }

  protected defineCapabilities(): AgentCapability[] {
    return [
      {
        name: 'Drug Interaction Analysis',
        description:
          'Analyze potential drug interactions and contraindications',
        confidence: 0.9,
        requiresPhysicianReview: true,
        maxSeverityLevel: 8,
        supportedLanguages: ['vietnamese', 'english', 'mixed'],
        medicalSpecialties: [
          'pharmacology',
          'internal_medicine',
          'clinical_pharmacy',
        ],
      },
      {
        name: 'Medication Adherence Support',
        description: 'Provide guidance on medication adherence and scheduling',
        confidence: 0.85,
        requiresPhysicianReview: false,
        maxSeverityLevel: 6,
        supportedLanguages: ['vietnamese', 'english', 'mixed'],
        medicalSpecialties: ['pharmacology', 'patient_education'],
      },
      {
        name: 'Side Effect Management',
        description: 'Identify and provide guidance on medication side effects',
        confidence: 0.8,
        requiresPhysicianReview: true,
        maxSeverityLevel: 7,
        supportedLanguages: ['vietnamese', 'english', 'mixed'],
        medicalSpecialties: ['pharmacology', 'toxicology'],
      },
      {
        name: 'Vietnamese Traditional Medicine Integration',
        description:
          'Assess interactions between modern medications and traditional Vietnamese medicine',
        confidence: 0.75,
        requiresPhysicianReview: true,
        maxSeverityLevel: 8,
        supportedLanguages: ['vietnamese', 'english', 'mixed'],
        medicalSpecialties: [
          'traditional_medicine',
          'pharmacology',
          'integrative_medicine',
        ],
      },
    ];
  }

  protected async processAgentSpecificQuery(
    query: string,
    context: HealthcareContext,
  ): Promise<AgentResponse> {
    try {
      this.logger.log(
        `Processing medication query: ${query.substring(0, 50)}...`,
      );

      const medicationContext = context as MedicationContext;

      // Extract medication information from query
      const extractedMedications =
        await this.extractMedicationsFromQuery(query);

      // Analyze drug interactions
      const interactions = await this.analyzeDrugInteractions(
        extractedMedications,
        medicationContext.currentMedications || [],
      );

      // Check for contraindications
      const contraindications = await this.checkContraindications(
        extractedMedications,
        medicationContext,
      );

      // Generate medication guidance
      const guidance = await this.generateMedicationGuidance(
        query,
        extractedMedications,
        interactions,
        contraindications,
        medicationContext,
      );

      // Assess if physician review is required
      const requiresPhysicianReview = this.assessPhysicianReviewNeed(
        interactions,
        contraindications,
        extractedMedications,
      );

      return {
        agentType: 'medication_management',
        response: guidance,
        confidence: this.calculateConfidence(interactions, contraindications),
        requiresEscalation: requiresPhysicianReview,
        metadata: {
          extractedMedications,
          drugInteractions: interactions,
          contraindications,
          requiresPhysicianReview,
          adherenceRecommendations:
            await this.generateAdherenceRecommendations(medicationContext),
          traditionalMedicineConsiderations:
            await this.assessTraditionalMedicineInteractions(
              query,
              extractedMedications,
            ),
        },
      };
    } catch (error) {
      this.logger.error('Medication management processing failed:', error);
      throw new Error(`Medication management failed: ${error.message}`);
    }
  }

  private async extractMedicationsFromQuery(query: string): Promise<string[]> {
    const extractionPrompt = `Extract all medication names mentioned in this query. Include both generic and brand names.

Query: "${query}"

Common Vietnamese medications to look for:
- Paracetamol (acetaminophen)
- Aspirin
- Ibuprofen
- Amoxicillin
- Metformin
- Lisinopril
- Atorvastatin
- Omeprazole

Also look for traditional Vietnamese medicines (thuốc nam) like:
- Gừng (ginger)
- Nghệ (turmeric)
- Cam thảo (licorice)
- Đông quai
- Nhân sâm (ginseng)

Return only the medication names, one per line.`;

    const response = await this.model.invoke([
      { role: 'system', content: extractionPrompt },
      { role: 'user', content: query },
    ]);

    const medications = (response.content as string)
      .split('\n')
      .map((med) => med.trim())
      .filter(
        (med) =>
          med.length > 0 &&
          !med.includes('No medications') &&
          !med.includes('None'),
      );

    return medications;
  }

  private async analyzeDrugInteractions(
    newMedications: string[],
    currentMedications: Array<{
      name: string;
      dosage: string;
      frequency: string;
    }>,
  ): Promise<DrugInteraction[]> {
    if (newMedications.length === 0 && currentMedications.length === 0) {
      return [];
    }

    const allMedications = [
      ...newMedications,
      ...currentMedications.map((med) => med.name),
    ];

    const interactionPrompt = `Analyze potential drug interactions between these medications:

Medications: ${allMedications.join(', ')}

For each significant interaction, provide:
1. Severity level (minor, moderate, major, contraindicated)
2. Mechanism of interaction
3. Clinical significance
4. Recommendations for management
5. Evidence level

Focus on clinically significant interactions that could affect patient safety.
Include interactions with Vietnamese traditional medicines if present.`;

    const response = await this.model.invoke([
      { role: 'system', content: interactionPrompt },
      {
        role: 'user',
        content: `Analyze interactions for: ${allMedications.join(', ')}`,
      },
    ]);

    // Parse the response to extract interactions
    return this.parseInteractionResponse(
      response.content as string,
      allMedications,
    );
  }

  private async checkContraindications(
    medications: string[],
    context: MedicationContext,
  ): Promise<string[]> {
    if (medications.length === 0) return [];

    const contraindicationPrompt = `Check for contraindications for these medications given the patient context:

Medications: ${medications.join(', ')}
Patient Context:
- Age: ${context.age || 'unknown'}
- Medical Conditions: ${context.medicalConditions?.join(', ') || 'none specified'}
- Allergies: ${context.allergies?.join(', ') || 'none specified'}
- Kidney Function: ${context.kidneyFunction || 'unknown'}
- Liver Function: ${context.liverFunction || 'unknown'}

Identify any absolute or relative contraindications and provide clear warnings.`;

    const response = await this.model.invoke([
      { role: 'system', content: contraindicationPrompt },
      {
        role: 'user',
        content: `Check contraindications for: ${medications.join(', ')}`,
      },
    ]);

    return this.parseContraindications(response.content as string);
  }

  private async generateMedicationGuidance(
    query: string,
    medications: string[],
    interactions: DrugInteraction[],
    contraindications: string[],
    context: MedicationContext,
  ): Promise<string> {
    const guidancePrompt = `Provide comprehensive medication guidance for this query:

Original Query: "${query}"
Identified Medications: ${medications.join(', ')}
Drug Interactions Found: ${interactions.length}
Contraindications: ${contraindications.length}

Patient Context:
- Current Medications: ${context.currentMedications?.map((m) => `${m.name} ${m.dosage}`).join(', ') || 'none'}
- Allergies: ${context.allergies?.join(', ') || 'none'}
- Medical Conditions: ${context.medicalConditions?.join(', ') || 'none'}

Provide guidance on:
1. Medication safety and interactions
2. Proper dosing and timing
3. Side effects to monitor
4. When to contact healthcare provider
5. Vietnamese cultural considerations if applicable

Always emphasize that this is educational information and not a substitute for professional medical advice.
Include appropriate medical disclaimers.`;

    const response = await this.model.invoke([
      { role: 'system', content: guidancePrompt },
      { role: 'user', content: query },
    ]);

    return response.content as string;
  }

  private async generateAdherenceRecommendations(
    context: MedicationContext,
  ): Promise<MedicationRecommendation[]> {
    if (
      !context.currentMedications ||
      context.currentMedications.length === 0
    ) {
      return [];
    }

    const recommendations: MedicationRecommendation[] = [];

    // Analyze medication complexity
    if (context.currentMedications.length > 5) {
      recommendations.push({
        type: 'monitoring',
        description:
          'Consider using a pill organizer or medication management app',
        rationale: 'Multiple medications increase risk of adherence issues',
        urgency: 'medium',
        requiresPhysicianApproval: false,
      });
    }

    // Check for multiple daily dosing
    const multiDoseCount = context.currentMedications.filter(
      (med) =>
        med.frequency.includes('twice') ||
        med.frequency.includes('three times') ||
        med.frequency.includes('four times'),
    ).length;

    if (multiDoseCount > 2) {
      recommendations.push({
        type: 'timing_change',
        description:
          'Discuss with physician about once-daily alternatives where possible',
        rationale: 'Simpler dosing schedules improve medication adherence',
        urgency: 'low',
        requiresPhysicianApproval: true,
      });
    }

    return recommendations;
  }

  private async assessTraditionalMedicineInteractions(
    query: string,
    medications: string[],
  ): Promise<string[]> {
    const traditionalMedicines = [
      'gừng',
      'nghệ',
      'cam thảo',
      'đông quai',
      'nhân sâm',
      'ginger',
      'turmeric',
      'licorice',
      'ginseng',
    ];

    const queryLower = query.toLowerCase();
    const foundTraditional = traditionalMedicines.filter((herb) =>
      queryLower.includes(herb),
    );

    if (foundTraditional.length === 0) return [];

    const considerations = [];

    // Check for specific interactions
    if (
      foundTraditional.includes('gừng') ||
      foundTraditional.includes('ginger')
    ) {
      if (
        medications.some(
          (med) =>
            med.toLowerCase().includes('warfarin') ||
            med.toLowerCase().includes('aspirin'),
        )
      ) {
        considerations.push(
          'Ginger may increase bleeding risk when combined with blood thinners',
        );
      }
    }

    if (
      foundTraditional.includes('cam thảo') ||
      foundTraditional.includes('licorice')
    ) {
      considerations.push(
        'Licorice may interact with blood pressure medications and diuretics',
      );
    }

    return considerations;
  }

  private parseInteractionResponse(
    content: string,
    medications: string[],
  ): DrugInteraction[] {
    // Simplified parsing - in production, this would be more sophisticated
    const interactions: DrugInteraction[] = [];

    if (
      content.toLowerCase().includes('warfarin') &&
      content.toLowerCase().includes('aspirin')
    ) {
      interactions.push({
        severity: 'major',
        description:
          'Warfarin and aspirin may significantly increase bleeding risk',
        mechanism:
          'Both medications affect blood clotting through different pathways',
        recommendation:
          'Avoid combination or use with extreme caution under physician supervision',
        evidenceLevel: 'high',
        clinicalSignificance: 'Increased risk of major bleeding events',
        affectedMedications: ['warfarin', 'aspirin'],
      });
    }

    return interactions;
  }

  private parseContraindications(content: string): string[] {
    const contraindications: string[] = [];

    if (
      content.toLowerCase().includes('contraindicated') ||
      content.toLowerCase().includes('avoid')
    ) {
      // Extract contraindication warnings from the response
      const lines = content
        .split('\n')
        .filter(
          (line) =>
            line.toLowerCase().includes('contraindicated') ||
            line.toLowerCase().includes('avoid') ||
            line.toLowerCase().includes('warning'),
        );
      contraindications.push(...lines);
    }

    return contraindications;
  }

  private calculateConfidence(
    interactions: DrugInteraction[],
    contraindications: string[],
  ): number {
    let confidence = 0.9;

    // Reduce confidence if major interactions found
    const majorInteractions = interactions.filter(
      (i) => i.severity === 'major' || i.severity === 'contraindicated',
    );
    confidence -= majorInteractions.length * 0.1;

    // Reduce confidence if contraindications found
    confidence -= contraindications.length * 0.05;

    return Math.max(confidence, 0.5);
  }

  private assessPhysicianReviewNeed(
    interactions: DrugInteraction[],
    contraindications: string[],
    medications: string[],
  ): boolean {
    // Require physician review for major interactions
    const hasMajorInteractions = interactions.some(
      (i) => i.severity === 'major' || i.severity === 'contraindicated',
    );

    // Require review if contraindications found
    const hasContraindications = contraindications.length > 0;

    // Require review for high-risk medications
    const highRiskMeds = ['warfarin', 'insulin', 'digoxin', 'lithium'];
    const hasHighRiskMeds = medications.some((med) =>
      highRiskMeds.some((risk) => med.toLowerCase().includes(risk)),
    );

    return hasMajorInteractions || hasContraindications || hasHighRiskMeds;
  }
}
