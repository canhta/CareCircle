import { Injectable, Inject } from '@nestjs/common';
import {
  RxNormService,
  DrugInteraction,
  MedicationInfo as _MedicationInfo,
} from './rxnorm.service';
import { MedicationRepository } from '../../domain/repositories/medication.repository';

export interface InteractionAlert {
  severity: 'high' | 'moderate' | 'low' | 'unknown';
  medicationA: string;
  medicationB: string;
  description: string;
  recommendation: string;
  source: string;
}

export interface InteractionAnalysis {
  hasInteractions: boolean;
  totalInteractions: number;
  alerts: InteractionAlert[];
  severityBreakdown: {
    high: number;
    moderate: number;
    low: number;
    unknown: number;
  };
  recommendations: string[];
  lastChecked: Date;
}

@Injectable()
export class DrugInteractionService {
  constructor(
    private readonly rxNormService: RxNormService,
    @Inject('MedicationRepository')
    private readonly medicationRepository: MedicationRepository,
  ) {}

  async checkUserMedicationInteractions(
    userId: string,
  ): Promise<InteractionAnalysis> {
    try {
      // Get all active medications for the user
      const activeMedications =
        await this.medicationRepository.findActiveByUserId(userId);

      if (activeMedications.length < 2) {
        return this.createEmptyAnalysis(
          'Need at least 2 active medications to check interactions',
        );
      }

      // Prepare medications for interaction checking
      const medicationsForCheck = activeMedications.map((med) => ({
        id: med.id,
        name: med.name,
        rxcui: med.rxNormCode || undefined,
      }));

      return this.analyzeMedicationInteractions(medicationsForCheck);
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      throw new Error(
        `Failed to check user medication interactions: ${errorMessage}`,
      );
    }
  }

  async checkSpecificMedicationInteractions(
    medicationNames: string[],
  ): Promise<InteractionAnalysis> {
    if (medicationNames.length < 2) {
      return this.createEmptyAnalysis(
        'Need at least 2 medications to check interactions',
      );
    }

    const medicationsForCheck = medicationNames.map((name) => ({
      id: `temp_${Date.now()}_${Math.random()}`,
      name,
      rxcui: undefined,
    }));

    return this.analyzeMedicationInteractions(medicationsForCheck);
  }

  async checkNewMedicationAgainstExisting(
    userId: string,
    newMedicationName: string,
  ): Promise<InteractionAnalysis> {
    try {
      // Get all active medications for the user
      const activeMedications =
        await this.medicationRepository.findActiveByUserId(userId);

      // Add the new medication to the list
      const allMedications = [
        ...activeMedications.map((med) => ({
          id: med.id,
          name: med.name,
          rxcui: med.rxNormCode || undefined,
        })),
        {
          id: 'new_medication',
          name: newMedicationName,
          rxcui: undefined,
        },
      ];

      return this.analyzeMedicationInteractions(allMedications);
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      throw new Error(
        `Failed to check new medication interactions: ${errorMessage}`,
      );
    }
  }

  private async analyzeMedicationInteractions(
    medications: Array<{ id: string; name: string; rxcui?: string }>,
  ): Promise<InteractionAnalysis> {
    try {
      // Get RxNorm analysis
      const rxNormAnalysis =
        await this.rxNormService.analyzeDrugInteractions(medications);

      // Convert to our alert format
      const alerts = this.convertToInteractionAlerts(
        rxNormAnalysis.interactions,
      );

      // Generate comprehensive recommendations
      const recommendations = this.generateRecommendations(
        alerts,
        rxNormAnalysis.severityAnalysis,
      );

      return {
        hasInteractions: alerts.length > 0,
        totalInteractions: alerts.length,
        alerts,
        severityBreakdown: rxNormAnalysis.severityAnalysis,
        recommendations,
        lastChecked: new Date(),
      };
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      throw new Error(
        `Failed to analyze medication interactions: ${errorMessage}`,
      );
    }
  }

  private convertToInteractionAlerts(
    interactions: DrugInteraction[],
  ): InteractionAlert[] {
    const alerts: InteractionAlert[] = [];

    for (const interaction of interactions) {
      for (const typeGroup of interaction.interactionTypeGroup) {
        for (const type of typeGroup.interactionType) {
          for (const pair of type.interactionPair) {
            const severity = this.normalizeSeverity(pair.severity);

            alerts.push({
              severity,
              medicationA: interaction.minConceptItem.name,
              medicationB: type.minConceptItem.name,
              description: pair.description || 'Interaction detected',
              recommendation: this.generateRecommendationForSeverity(severity),
              source: typeGroup.sourceName || 'RxNorm',
            });
          }
        }
      }
    }

    return alerts;
  }

  private normalizeSeverity(
    severity: string,
  ): 'high' | 'moderate' | 'low' | 'unknown' {
    const normalizedSeverity = severity?.toLowerCase() || '';

    if (
      normalizedSeverity.includes('high') ||
      normalizedSeverity.includes('major')
    ) {
      return 'high';
    } else if (
      normalizedSeverity.includes('moderate') ||
      normalizedSeverity.includes('medium')
    ) {
      return 'moderate';
    } else if (
      normalizedSeverity.includes('low') ||
      normalizedSeverity.includes('minor')
    ) {
      return 'low';
    }

    return 'unknown';
  }

  private generateRecommendationForSeverity(
    severity: 'high' | 'moderate' | 'low' | 'unknown',
  ): string {
    switch (severity) {
      case 'high':
        return 'Consult healthcare provider immediately before taking these medications together';
      case 'moderate':
        return 'Monitor closely and consult healthcare provider about potential adjustments';
      case 'low':
        return 'Be aware of potential interaction and monitor for any unusual effects';
      default:
        return 'Consult healthcare provider for guidance on this medication combination';
    }
  }

  private generateRecommendations(
    alerts: InteractionAlert[],
    severityBreakdown: {
      high: number;
      moderate: number;
      low: number;
      unknown: number;
    },
  ): string[] {
    const recommendations: string[] = [];

    if (severityBreakdown.high > 0) {
      recommendations.push(
        '🚨 URGENT: High-severity interactions detected. Contact your healthcare provider immediately.',
      );
      recommendations.push(
        'Do not start, stop, or change dosages without medical supervision.',
      );
    }

    if (severityBreakdown.moderate > 0) {
      recommendations.push(
        '⚠️ Moderate interactions detected. Schedule a consultation with your healthcare provider.',
      );
      recommendations.push(
        'Monitor for unusual symptoms and report any concerns promptly.',
      );
    }

    if (severityBreakdown.low > 0) {
      recommendations.push(
        'ℹ️ Minor interactions detected. Be aware and monitor for any changes.',
      );
    }

    if (alerts.length > 0) {
      recommendations.push(
        'Keep an updated list of all medications and share with all healthcare providers.',
      );
      recommendations.push(
        'Consider using a single pharmacy to help monitor for interactions.',
      );
    }

    if (recommendations.length === 0) {
      recommendations.push(
        '✅ No significant interactions detected with current analysis.',
      );
      recommendations.push(
        'Continue regular medication reviews with your healthcare provider.',
      );
    }

    return recommendations;
  }

  private createEmptyAnalysis(message: string): InteractionAnalysis {
    return {
      hasInteractions: false,
      totalInteractions: 0,
      alerts: [],
      severityBreakdown: { high: 0, moderate: 0, low: 0, unknown: 0 },
      recommendations: [message],
      lastChecked: new Date(),
    };
  }

  async enrichMedicationWithRxNormData(
    medicationName: string,
    _strength?: string,
  ): Promise<{
    rxcui?: string;
    standardizedName?: string;
    genericName?: string;
    brandNames: string[];
    classification?: string;
    ingredients: string[];
    isValid: boolean;
    suggestions: string[];
  }> {
    try {
      // Validate and get RxCUI
      const validation =
        await this.rxNormService.validateMedicationName(medicationName);

      if (validation.isValid && validation.rxcui) {
        // Get detailed medication information
        const medicationInfo = await this.rxNormService.getMedicationInfo(
          validation.rxcui,
        );

        if (medicationInfo) {
          return {
            rxcui: medicationInfo.rxcui,
            standardizedName: medicationInfo.name,
            genericName: medicationInfo.genericName,
            brandNames: medicationInfo.brandNames,
            classification: medicationInfo.classification,
            ingredients: medicationInfo.ingredients,
            isValid: true,
            suggestions: [],
          };
        }
      }

      // Return validation results with suggestions
      return {
        isValid: false,
        brandNames: [],
        ingredients: [],
        suggestions: validation.suggestions,
      };
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      throw new Error(`Failed to enrich medication data: ${errorMessage}`);
    }
  }

  async updateMedicationRxNormCodes(userId: string): Promise<{
    updated: number;
    failed: number;
    results: Array<{
      medicationId: string;
      medicationName: string;
      success: boolean;
      rxcui?: string;
      error?: string;
    }>;
  }> {
    try {
      const medications = await this.medicationRepository.findByUserId(userId);
      const results: Array<{
        medicationId: string;
        medicationName: string;
        success: boolean;
        rxcui?: string;
        error?: string;
      }> = [];

      let updated = 0;
      let failed = 0;

      for (const medication of medications) {
        // Skip if already has RxNorm code
        if (medication.rxNormCode) {
          continue;
        }

        try {
          const enrichedData = await this.enrichMedicationWithRxNormData(
            medication.name,
          );

          if (enrichedData.isValid && enrichedData.rxcui) {
            // Update medication with RxNorm data
            await this.medicationRepository.update(medication.id, {
              rxNormCode: enrichedData.rxcui,
              genericName: enrichedData.genericName || medication.genericName,
              classification:
                enrichedData.classification || medication.classification,
            });

            results.push({
              medicationId: medication.id,
              medicationName: medication.name,
              success: true,
              rxcui: enrichedData.rxcui,
            });

            updated++;
          } else {
            results.push({
              medicationId: medication.id,
              medicationName: medication.name,
              success: false,
              error: 'No valid RxNorm match found',
            });

            failed++;
          }
        } catch (error) {
          results.push({
            medicationId: medication.id,
            medicationName: medication.name,
            success: false,
            error: error instanceof Error ? error.message : 'Unknown error',
          });

          failed++;
        }
      }

      return { updated, failed, results };
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      throw new Error(`Failed to update RxNorm codes: ${errorMessage}`);
    }
  }
}
