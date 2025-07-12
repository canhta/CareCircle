import { Injectable, Logger } from '@nestjs/common';
import { ChatOpenAI } from '@langchain/openai';
import { z } from 'zod';

export interface ClinicalContext {
  chiefComplaint: string;
  symptoms: Array<{
    name: string;
    duration: string;
    severity: 'mild' | 'moderate' | 'severe';
    quality?: string;
    location?: string;
    radiation?: string;
    timing?: string;
    exacerbatingFactors?: string[];
    relievingFactors?: string[];
  }>;
  vitalSigns?: {
    bloodPressure?: { systolic: number; diastolic: number };
    heartRate?: number;
    temperature?: number;
    respiratoryRate?: number;
    oxygenSaturation?: number;
    weight?: number;
    height?: number;
  };
  physicalExam?: {
    general?: string;
    cardiovascular?: string;
    respiratory?: string;
    abdominal?: string;
    neurological?: string;
    musculoskeletal?: string;
    skin?: string;
  };
  medicalHistory: string[];
  familyHistory?: string[];
  socialHistory?: {
    smoking?: 'never' | 'former' | 'current';
    alcohol?: 'none' | 'occasional' | 'moderate' | 'heavy';
    exercise?: 'sedentary' | 'light' | 'moderate' | 'vigorous';
    occupation?: string;
  };
  currentMedications: string[];
  allergies: string[];
  recentLabResults?: Record<string, any>;
  recentImaging?: Record<string, any>;
}

export interface DifferentialDiagnosis {
  condition: string;
  probability: number;
  supportingEvidence: string[];
  contradictingEvidence: string[];
  nextSteps: string[];
  urgency: 'low' | 'medium' | 'high' | 'critical';
}

export interface ClinicalRecommendation {
  category:
    | 'diagnostic'
    | 'therapeutic'
    | 'monitoring'
    | 'referral'
    | 'lifestyle';
  priority: 'low' | 'medium' | 'high' | 'urgent';
  recommendation: string;
  rationale: string;
  evidenceLevel: 'A' | 'B' | 'C' | 'D'; // Evidence-based medicine levels
  timeframe: string;
  contraindications?: string[];
  alternatives?: string[];
}

export interface ClinicalResponse {
  response: string;
  differentialDiagnoses: DifferentialDiagnosis[];
  recommendations: ClinicalRecommendation[];
  redFlags: string[];
  followUpInstructions: string[];
  patientEducation: string[];
  preventiveCare: string[];
  riskAssessment: {
    cardiovascular: number;
    diabetes: number;
    cancer: number;
    overall: 'low' | 'medium' | 'high';
  };
  confidence: number;
  requiresPhysicianReview: boolean;
  suggestedSpecialty?: string;
}

@Injectable()
export class ClinicalDecisionSupportAgentService {
  private readonly logger = new Logger(
    ClinicalDecisionSupportAgentService.name,
  );
  private model: ChatOpenAI;

  // Common Vietnamese health conditions and their risk factors
  private readonly vietnameseHealthConditions = new Map([
    [
      'diabetes',
      {
        prevalence: 0.058,
        riskFactors: ['obesity', 'family_history', 'age_over_40'],
      },
    ],
    [
      'hypertension',
      { prevalence: 0.25, riskFactors: ['salt_intake', 'stress', 'obesity'] },
    ],
    [
      'respiratory_disease',
      {
        prevalence: 0.12,
        riskFactors: ['smoking', 'air_pollution', 'occupational'],
      },
    ],
    [
      'hepatitis_b',
      {
        prevalence: 0.08,
        riskFactors: ['endemic_area', 'unprotected_contact'],
      },
    ],
    [
      'tuberculosis',
      {
        prevalence: 0.003,
        riskFactors: ['crowded_living', 'immunocompromised'],
      },
    ],
  ]);

  // Clinical decision rules and scoring systems
  private readonly clinicalRules = new Map([
    ['chest_pain', 'HEART Score, TIMI Risk Score'],
    ['stroke', 'NIHSS, CHADS2-VASc'],
    ['pulmonary_embolism', 'Wells Score, Geneva Score'],
    ['heart_failure', 'Framingham Criteria, BNP levels'],
    ['sepsis', 'qSOFA, SIRS criteria'],
  ]);

  // Evidence-based guidelines
  private readonly guidelines = new Map([
    ['hypertension', 'JNC 8, ESC/ESH Guidelines'],
    ['diabetes', 'ADA Standards, IDF Guidelines'],
    ['cardiovascular', 'ACC/AHA Guidelines'],
    ['respiratory', 'GOLD Guidelines, ATS/ERS'],
  ]);

  constructor() {
    this.model = new ChatOpenAI({
      modelName: 'gpt-4',
      temperature: 0.15, // Low temperature for clinical accuracy
    });
  }

  async processClinicalQuery(
    query: string,
    clinicalContext: ClinicalContext,
  ): Promise<ClinicalResponse> {
    try {
      this.logger.log(
        `Processing clinical query: ${query.substring(0, 50)}...`,
      );

      // Generate differential diagnoses
      const differentialDiagnoses = await this.generateDifferentialDiagnoses(
        query,
        clinicalContext,
      );

      // Generate clinical recommendations
      const recommendations = await this.generateClinicalRecommendations(
        clinicalContext,
        differentialDiagnoses,
      );

      // Assess risks
      const riskAssessment = this.assessHealthRisks(clinicalContext);

      // Generate comprehensive clinical response
      const response = await this.generateClinicalResponse(
        query,
        clinicalContext,
        {
          differentialDiagnoses,
          recommendations,
          riskAssessment,
        },
      );

      return response;
    } catch (error) {
      this.logger.error('Error processing clinical query:', error);
      throw new Error('Failed to process clinical query');
    }
  }

  private async generateDifferentialDiagnoses(
    query: string,
    context: ClinicalContext,
  ): Promise<DifferentialDiagnosis[]> {
    const diagnoses: DifferentialDiagnosis[] = [];

    // Analyze chief complaint and symptoms
    const primarySymptoms = context.symptoms.map((s) => s.name.toLowerCase());
    const chiefComplaint = context.chiefComplaint.toLowerCase();

    // Common differential diagnoses based on presenting symptoms
    if (
      chiefComplaint.includes('chest pain') ||
      primarySymptoms.some((s) => s.includes('chest'))
    ) {
      diagnoses.push({
        condition: 'Acute Coronary Syndrome',
        probability: this.calculateProbability(context, 'acs'),
        supportingEvidence: this.getSupportingEvidence(context, 'acs'),
        contradictingEvidence: this.getContradictingEvidence(context, 'acs'),
        nextSteps: ['ECG', 'Cardiac enzymes', 'Chest X-ray'],
        urgency: 'critical',
      });

      diagnoses.push({
        condition: 'Gastroesophageal Reflux Disease',
        probability: this.calculateProbability(context, 'gerd'),
        supportingEvidence: this.getSupportingEvidence(context, 'gerd'),
        contradictingEvidence: this.getContradictingEvidence(context, 'gerd'),
        nextSteps: ['Trial of PPI therapy', 'Dietary modification'],
        urgency: 'low',
      });
    }

    if (
      chiefComplaint.includes('shortness of breath') ||
      primarySymptoms.some((s) => s.includes('breath'))
    ) {
      diagnoses.push({
        condition: 'Asthma Exacerbation',
        probability: this.calculateProbability(context, 'asthma'),
        supportingEvidence: this.getSupportingEvidence(context, 'asthma'),
        contradictingEvidence: this.getContradictingEvidence(context, 'asthma'),
        nextSteps: ['Peak flow measurement', 'Chest X-ray', 'ABG if severe'],
        urgency: 'medium',
      });

      diagnoses.push({
        condition: 'Heart Failure',
        probability: this.calculateProbability(context, 'heart_failure'),
        supportingEvidence: this.getSupportingEvidence(
          context,
          'heart_failure',
        ),
        contradictingEvidence: this.getContradictingEvidence(
          context,
          'heart_failure',
        ),
        nextSteps: ['BNP/NT-proBNP', 'Echocardiogram', 'Chest X-ray'],
        urgency: 'high',
      });
    }

    // Sort by probability
    return diagnoses.sort((a, b) => b.probability - a.probability);
  }

  private calculateProbability(
    context: ClinicalContext,
    condition: string,
  ): number {
    let probability = 0.1; // Base probability

    // Age and gender factors
    const age = this.estimateAge(context);
    if (condition === 'acs' && age > 50) probability += 0.2;
    if (condition === 'heart_failure' && age > 65) probability += 0.3;

    // Risk factors
    const riskFactors = this.identifyRiskFactors(context, condition);
    probability += riskFactors.length * 0.1;

    // Vital signs
    if (context.vitalSigns) {
      if (
        condition === 'acs' &&
        context.vitalSigns.heartRate &&
        context.vitalSigns.heartRate > 100
      ) {
        probability += 0.1;
      }
    }

    // Medical history
    if (
      condition === 'acs' &&
      context.medicalHistory.some((h) => h.includes('coronary'))
    ) {
      probability += 0.3;
    }

    return Math.min(0.9, probability);
  }

  private getSupportingEvidence(
    context: ClinicalContext,
    condition: string,
  ): string[] {
    const evidence: string[] = [];

    if (condition === 'acs') {
      if (
        context.symptoms.some(
          (s) => s.name.includes('chest') && s.severity === 'severe',
        )
      ) {
        evidence.push('Severe chest pain');
      }
      if (context.medicalHistory.includes('diabetes')) {
        evidence.push('History of diabetes (CAD risk factor)');
      }
    }

    return evidence;
  }

  private getContradictingEvidence(
    context: ClinicalContext,
    condition: string,
  ): string[] {
    const evidence: string[] = [];

    if (condition === 'acs') {
      const age = this.estimateAge(context);
      if (age < 30) {
        evidence.push('Young age (low ACS risk)');
      }
    }

    return evidence;
  }

  private async generateClinicalRecommendations(
    context: ClinicalContext,
    diagnoses: DifferentialDiagnosis[],
  ): Promise<ClinicalRecommendation[]> {
    const recommendations: ClinicalRecommendation[] = [];

    // Diagnostic recommendations
    const highProbabilityDx = diagnoses.filter((d) => d.probability > 0.5);
    for (const dx of highProbabilityDx) {
      recommendations.push({
        category: 'diagnostic',
        priority: dx.urgency === 'critical' ? 'urgent' : 'high',
        recommendation: `Evaluate for ${dx.condition}`,
        rationale: `High probability (${(dx.probability * 100).toFixed(0)}%) based on clinical presentation`,
        evidenceLevel: 'B',
        timeframe: dx.urgency === 'critical' ? 'Immediate' : 'Within 24 hours',
        contraindications: [],
        alternatives: dx.nextSteps,
      });
    }

    // Therapeutic recommendations
    if (context.vitalSigns?.bloodPressure) {
      const { systolic, diastolic } = context.vitalSigns.bloodPressure;
      if (systolic >= 140 || diastolic >= 90) {
        recommendations.push({
          category: 'therapeutic',
          priority: systolic >= 180 ? 'urgent' : 'medium',
          recommendation: 'Initiate antihypertensive therapy',
          rationale:
            'Elevated blood pressure requires treatment per guidelines',
          evidenceLevel: 'A',
          timeframe: 'Within 1 week',
          contraindications: ['Hypotension', 'Severe heart failure'],
          alternatives: ['Lifestyle modifications first if stage 1 HTN'],
        });
      }
    }

    // Preventive care recommendations
    const age = this.estimateAge(context);
    if (age >= 50) {
      recommendations.push({
        category: 'monitoring',
        priority: 'medium',
        recommendation: 'Colorectal cancer screening',
        rationale: 'Age-appropriate screening per guidelines',
        evidenceLevel: 'A',
        timeframe: 'Annual',
        contraindications: ['Life expectancy < 10 years'],
        alternatives: ['Colonoscopy', 'FIT test', 'Cologuard'],
      });
    }

    return recommendations;
  }

  private assessHealthRisks(context: ClinicalContext): {
    cardiovascular: number;
    diabetes: number;
    cancer: number;
    overall: 'low' | 'medium' | 'high';
  } {
    let cardiovascularRisk = 0.1;
    let diabetesRisk = 0.05;
    let cancerRisk = 0.1;

    const age = this.estimateAge(context);

    // Age-based risk
    if (age > 50) {
      cardiovascularRisk += 0.2;
      diabetesRisk += 0.1;
      cancerRisk += 0.2;
    }

    // Medical history risk factors
    if (context.medicalHistory.includes('hypertension'))
      cardiovascularRisk += 0.3;
    if (context.medicalHistory.includes('diabetes')) cardiovascularRisk += 0.4;
    if (context.medicalHistory.includes('family history of diabetes'))
      diabetesRisk += 0.2;

    // Lifestyle risk factors
    if (context.socialHistory?.smoking === 'current') {
      cardiovascularRisk += 0.3;
      cancerRisk += 0.4;
    }

    // Vietnamese population-specific risks
    const vietnameseRiskMultiplier = 1.2; // Higher prevalence of certain conditions
    diabetesRisk *= vietnameseRiskMultiplier;

    const overallRisk = Math.max(cardiovascularRisk, diabetesRisk, cancerRisk);
    let overallCategory: 'low' | 'medium' | 'high' = 'low';
    if (overallRisk > 0.6) overallCategory = 'high';
    else if (overallRisk > 0.3) overallCategory = 'medium';

    return {
      cardiovascular: Math.min(0.9, cardiovascularRisk),
      diabetes: Math.min(0.9, diabetesRisk),
      cancer: Math.min(0.9, cancerRisk),
      overall: overallCategory,
    };
  }

  private async generateClinicalResponse(
    query: string,
    context: ClinicalContext,
    analysis: any,
  ): Promise<ClinicalResponse> {
    const systemPrompt = `You are a clinical decision support AI assistant specializing in Vietnamese healthcare.

Clinical Context:
- Chief Complaint: ${context.chiefComplaint}
- Symptoms: ${context.symptoms.map((s) => `${s.name} (${s.severity}, ${s.duration})`).join(', ')}
- Medical History: ${context.medicalHistory.join(', ')}
- Current Medications: ${context.currentMedications.join(', ')}

Top Differential Diagnoses:
${analysis.differentialDiagnoses
  .slice(0, 3)
  .map(
    (d) =>
      `- ${d.condition} (${(d.probability * 100).toFixed(0)}% probability)`,
  )
  .join('\n')}

Risk Assessment:
- Cardiovascular: ${(analysis.riskAssessment.cardiovascular * 100).toFixed(0)}%
- Diabetes: ${(analysis.riskAssessment.diabetes * 100).toFixed(0)}%
- Overall Risk: ${analysis.riskAssessment.overall}

Provide comprehensive clinical guidance including:
1. Clinical assessment and reasoning
2. Recommended diagnostic approach
3. Treatment considerations
4. Patient education points
5. Follow-up recommendations
6. Vietnamese healthcare system considerations

Always emphasize evidence-based medicine and the need for physician evaluation.
Include cultural considerations for Vietnamese patients when relevant.`;

    const response = await this.model.invoke([
      { role: 'system', content: systemPrompt },
      { role: 'user', content: query },
    ]);

    return {
      response: response.content as string,
      differentialDiagnoses: analysis.differentialDiagnoses,
      recommendations: analysis.recommendations,
      redFlags: this.generateRedFlags(context),
      followUpInstructions: this.generateFollowUpInstructions(
        analysis.riskAssessment,
      ),
      patientEducation: this.generatePatientEducation(
        context,
        analysis.differentialDiagnoses,
      ),
      preventiveCare: this.generatePreventiveCare(context),
      riskAssessment: analysis.riskAssessment,
      confidence: 0.8,
      requiresPhysicianReview: analysis.differentialDiagnoses.some(
        (d: DifferentialDiagnosis) =>
          d.urgency === 'critical' || d.urgency === 'high',
      ),
      suggestedSpecialty: this.suggestSpecialty(analysis.differentialDiagnoses),
    };
  }

  private estimateAge(context: ClinicalContext): number {
    // Estimate age from context clues or return default
    return 45; // Default middle age
  }

  private identifyRiskFactors(
    context: ClinicalContext,
    condition: string,
  ): string[] {
    const riskFactors: string[] = [];

    if (condition === 'acs') {
      if (context.medicalHistory.includes('diabetes'))
        riskFactors.push('diabetes');
      if (context.medicalHistory.includes('hypertension'))
        riskFactors.push('hypertension');
      if (context.socialHistory?.smoking === 'current')
        riskFactors.push('smoking');
    }

    return riskFactors;
  }

  private generateRedFlags(context: ClinicalContext): string[] {
    return [
      'Severe chest pain with radiation',
      'Difficulty breathing at rest',
      'Loss of consciousness',
      'Severe abdominal pain',
      'Signs of stroke (FAST)',
      'Severe allergic reaction',
    ];
  }

  private generateFollowUpInstructions(riskAssessment: any): string[] {
    const instructions: string[] = [];

    if (riskAssessment.overall === 'high') {
      instructions.push('Follow up within 1-2 weeks');
      instructions.push('Monitor symptoms daily');
    } else {
      instructions.push('Follow up in 2-4 weeks');
      instructions.push('Return if symptoms worsen');
    }

    return instructions;
  }

  private generatePatientEducation(
    context: ClinicalContext,
    diagnoses: DifferentialDiagnosis[],
  ): string[] {
    const education: string[] = [
      'Understand your condition and treatment plan',
      'Take medications as prescribed',
      'Monitor for warning signs',
      'Maintain healthy lifestyle habits',
    ];

    // Add Vietnamese cultural considerations
    education.push('Discuss treatment with family members if desired');
    education.push(
      'Consider both modern and traditional medicine approaches safely',
    );

    return education;
  }

  private generatePreventiveCare(context: ClinicalContext): string[] {
    const preventive: string[] = [
      'Regular health screenings',
      'Vaccination updates',
      'Healthy diet and exercise',
      'Stress management',
      'Regular sleep schedule',
    ];

    // Vietnamese-specific preventive care
    preventive.push('Hepatitis B screening if not vaccinated');
    preventive.push('Tuberculosis screening if high risk');

    return preventive;
  }

  private suggestSpecialty(
    diagnoses: DifferentialDiagnosis[],
  ): string | undefined {
    const topDiagnosis = diagnoses[0];
    if (!topDiagnosis) return undefined;

    const specialtyMap: Record<string, string> = {
      'Acute Coronary Syndrome': 'Cardiology',
      'Heart Failure': 'Cardiology',
      'Asthma Exacerbation': 'Pulmonology',
      Diabetes: 'Endocrinology',
    };

    return specialtyMap[topDiagnosis.condition];
  }
}
