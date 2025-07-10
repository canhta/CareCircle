import { Injectable } from '@nestjs/common';
import { PrescriptionService } from './prescription.service';
import { MedicationService } from './medication.service';
import {
  OCRService,
  OCRProcessingOptions,
} from '../../infrastructure/services/ocr.service';
import {
  DrugInteractionService,
  InteractionAnalysis,
} from '../../infrastructure/services/drug-interaction.service';
import {
  Prescription,
  PrescriptionMedication,
} from '../../domain/entities/prescription.entity';
import { Medication } from '../../domain/entities/medication.entity';
import { MedicationForm } from '@prisma/client';

export interface PrescriptionProcessingResult {
  prescription: Prescription;
  extractedMedications: PrescriptionMedication[];
  createdMedications: Medication[];
  ocrValidation: {
    isValid: boolean;
    confidence: number;
    issues: string[];
    suggestions: string[];
  };
  interactionAnalysis?: {
    hasInteractions: boolean;
    alerts: any[];
    recommendations: string[];
  };
  processingMetadata: {
    totalProcessingTime: number;
    ocrProcessingTime: number;
    medicationCreationTime: number;
    interactionCheckTime: number;
  };
}

@Injectable()
export class PrescriptionProcessingService {
  constructor(
    private readonly prescriptionService: PrescriptionService,
    private readonly medicationService: MedicationService,
    private readonly ocrService: OCRService,
    private readonly drugInteractionService: DrugInteractionService,
  ) {}

  async processImagePrescription(
    userId: string,
    imageBuffer: Buffer,
    prescribedBy?: string,
    prescribedDate?: Date,
    options: OCRProcessingOptions = {},
  ): Promise<PrescriptionProcessingResult> {
    const startTime = Date.now();

    try {
      // Step 1: Process image with OCR
      const ocrStartTime = Date.now();
      const ocrData = await this.ocrService.processImage(imageBuffer, options);
      const ocrProcessingTime = Date.now() - ocrStartTime;

      // Step 2: Validate OCR results
      const ocrValidation = this.ocrService.validateOCRResult(ocrData);

      // Step 3: Create prescription with OCR data
      const prescription = await this.prescriptionService.createPrescription({
        userId,
        prescribedBy: prescribedBy || ocrData.fields.prescribedBy || 'Unknown',
        prescribedDate:
          prescribedDate ||
          (ocrData.fields.prescribedDate
            ? new Date(ocrData.fields.prescribedDate)
            : new Date()),
        pharmacy: ocrData.fields.pharmacy,
        ocrData,
        medications: (ocrData.fields.medications || []).map((med) => ({
          name: med.name || 'Unknown',
          strength: med.strength || 'Unknown',
          form: 'Unknown', // OCR doesn't extract form, will be set later
          dosage: med.instructions || 'As directed',
          quantity: parseInt(med.quantity || '30', 10) || 30,
          instructions: med.instructions || 'As directed',
          confidence: med.confidence,
        })),
      });

      // Step 4: Create medications from prescription
      const medicationStartTime = Date.now();
      const createdMedications = await this.createMedicationsFromPrescription(
        userId,
        prescription,
        ocrData.fields.medications || [],
      );
      const medicationCreationTime = Date.now() - medicationStartTime;

      // Step 5: Check drug interactions
      const interactionStartTime = Date.now();
      const interactionAnalysis: InteractionAnalysis | null =
        await this.checkInteractionsForNewMedications(
          userId,
          createdMedications,
        );
      const interactionCheckTime = Date.now() - interactionStartTime;

      const totalProcessingTime = Date.now() - startTime;

      return {
        prescription,
        extractedMedications: (ocrData.fields.medications || []).map((med) => ({
          name: med.name || 'Unknown',
          strength: med.strength || 'Unknown',
          form: 'Unknown', // OCR doesn't extract form, will be set later
          dosage: med.instructions || 'As directed',
          quantity: parseInt(med.quantity || '30', 10) || 30,
          instructions: med.instructions || 'As directed',
          confidence: med.confidence,
        })),
        createdMedications,
        ocrValidation,
        interactionAnalysis: interactionAnalysis
          ? {
              hasInteractions: interactionAnalysis.hasInteractions,
              alerts: interactionAnalysis.alerts,
              recommendations: interactionAnalysis.recommendations,
            }
          : undefined,
        processingMetadata: {
          totalProcessingTime,
          ocrProcessingTime,
          medicationCreationTime,
          interactionCheckTime,
        },
      };
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      throw new Error(`Failed to process image prescription: ${errorMessage}`);
    }
  }

  async processUrlPrescription(
    userId: string,
    imageUrl: string,
    prescribedBy?: string,
    prescribedDate?: Date,
    options: OCRProcessingOptions = {},
  ): Promise<PrescriptionProcessingResult> {
    const startTime = Date.now();

    try {
      // Step 1: Process image from URL with OCR
      const ocrStartTime = Date.now();
      const ocrData = await this.ocrService.processImageFromUrl(
        imageUrl,
        options,
      );
      const ocrProcessingTime = Date.now() - ocrStartTime;

      // Step 2: Validate OCR results
      const ocrValidation = this.ocrService.validateOCRResult(ocrData);

      // Step 3: Create prescription with OCR data
      const prescription = await this.prescriptionService.createPrescription({
        userId,
        prescribedBy: prescribedBy || ocrData.fields.prescribedBy || 'Unknown',
        prescribedDate:
          prescribedDate ||
          (ocrData.fields.prescribedDate
            ? new Date(ocrData.fields.prescribedDate)
            : new Date()),
        pharmacy: ocrData.fields.pharmacy,
        ocrData,
        imageUrl,
        medications: (ocrData.fields.medications || []).map((med) => ({
          name: med.name || 'Unknown',
          strength: med.strength || 'Unknown',
          form: 'Unknown', // OCR doesn't extract form, will be set later
          dosage: med.instructions || 'As directed',
          quantity: parseInt(med.quantity || '30', 10) || 30,
          instructions: med.instructions || 'As directed',
          confidence: med.confidence,
        })),
      });

      // Step 4: Create medications from prescription
      const medicationStartTime = Date.now();
      const createdMedications = await this.createMedicationsFromPrescription(
        userId,
        prescription,
        (ocrData.fields.medications || []).map((med) => ({
          name: med.name || 'Unknown',
          strength: med.strength || 'Unknown',
          form: 'Unknown', // OCR doesn't extract form, will be set later
          dosage: med.instructions || 'As directed',
          quantity: parseInt(med.quantity || '30', 10) || 30,
          instructions: med.instructions || 'As directed',
          confidence: med.confidence,
        })),
      );
      const medicationCreationTime = Date.now() - medicationStartTime;

      // Step 5: Check drug interactions
      const interactionStartTime = Date.now();
      const interactionAnalysis = await this.checkInteractionsForNewMedications(
        userId,
        createdMedications,
      );
      const interactionCheckTime = Date.now() - interactionStartTime;

      const totalProcessingTime = Date.now() - startTime;

      return {
        prescription,
        extractedMedications: (ocrData.fields.medications || []).map((med) => ({
          name: med.name || '',
          strength: med.strength || '',
          form: 'Unknown',
          dosage: med.instructions || '',
          quantity: parseInt(med.quantity || '1', 10) || 1,
          instructions: med.instructions || '',
          confidence: med.confidence,
        })),
        createdMedications,
        ocrValidation,
        interactionAnalysis: interactionAnalysis
          ? {
              hasInteractions: interactionAnalysis.hasInteractions,
              alerts: interactionAnalysis.alerts,
              recommendations: interactionAnalysis.recommendations,
            }
          : undefined,
        processingMetadata: {
          totalProcessingTime,
          ocrProcessingTime,
          medicationCreationTime,
          interactionCheckTime,
        },
      };
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      throw new Error(`Failed to process URL prescription: ${errorMessage}`);
    }
  }

  async reprocessPrescriptionOCR(
    prescriptionId: string,
    options: OCRProcessingOptions = {},
  ): Promise<{
    prescription: Prescription;
    ocrValidation: any;
    updatedMedications: PrescriptionMedication[];
  }> {
    try {
      const prescription =
        await this.prescriptionService.getPrescription(prescriptionId);
      if (!prescription) {
        throw new Error('Prescription not found');
      }

      if (!prescription.imageUrl) {
        throw new Error('No image URL available for reprocessing');
      }

      // Reprocess OCR
      const ocrData = await this.ocrService.processImageFromUrl(
        prescription.imageUrl,
        options,
      );
      const ocrValidation = this.ocrService.validateOCRResult(ocrData);

      // Update prescription with new OCR data
      const updatedPrescription = await this.prescriptionService.setOCRData(
        prescriptionId,
        ocrData,
      );

      return {
        prescription: updatedPrescription,
        ocrValidation,
        updatedMedications: (ocrData.fields.medications || []).map((med) => ({
          name: med.name || 'Unknown',
          strength: med.strength || 'Unknown',
          form: 'Unknown', // OCR doesn't extract form, will be set later
          dosage: med.instructions || 'As directed',
          quantity: parseInt(med.quantity || '30', 10) || 30,
          instructions: med.instructions || 'As directed',
          confidence: med.confidence,
        })),
      };
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      throw new Error(`Failed to reprocess prescription OCR: ${errorMessage}`);
    }
  }

  private async createMedicationsFromPrescription(
    userId: string,
    prescription: Prescription,
    extractedMedications: Array<{
      name?: string;
      strength?: string;
      form?: string;
      instructions?: string;
      confidence: number;
    }>,
  ): Promise<Medication[]> {
    const createdMedications: Medication[] = [];

    for (const extractedMed of extractedMedications) {
      try {
        // Only create medications with reasonable confidence
        if (extractedMed.confidence < 0.6) {
          continue;
        }

        // Determine medication form
        const form = this.determineMedicationForm(
          extractedMed.form || extractedMed.instructions || 'Unknown',
        );

        const medication = await this.medicationService.createMedication({
          userId,
          name: extractedMed.name || 'Unknown Medication',
          strength: extractedMed.strength || 'Unknown',
          form,
          startDate: prescription.prescribedDate,
          prescriptionId: prescription.id,
          notes: `Created from prescription OCR. Instructions: ${extractedMed.instructions}`,
        });

        createdMedications.push(medication);

        // Link medication to prescription
        await this.prescriptionService.updateMedicationInPrescription(
          prescription.id,
          extractedMed.name || 'Unknown Medication',
          {
            ...extractedMed,
            linkedMedicationId: medication.id,
          },
        );
      } catch (error) {
        // Log error but continue with other medications
        const errorMessage =
          error instanceof Error ? error.message : 'Unknown error';
        console.error(
          `Failed to create medication ${extractedMed.name}:`,
          errorMessage,
        );
      }
    }

    return createdMedications;
  }

  private determineMedicationForm(formOrInstructions: string): MedicationForm {
    const text = formOrInstructions?.toLowerCase() || '';

    if (text.includes('tablet') || text.includes('tab'))
      return MedicationForm.TABLET;
    if (text.includes('capsule') || text.includes('cap'))
      return MedicationForm.CAPSULE;
    if (
      text.includes('liquid') ||
      text.includes('syrup') ||
      text.includes('solution')
    )
      return MedicationForm.LIQUID;
    if (text.includes('injection') || text.includes('inject'))
      return MedicationForm.INJECTION;
    if (text.includes('cream')) return MedicationForm.CREAM;
    if (text.includes('ointment')) return MedicationForm.OINTMENT;
    if (text.includes('inhaler') || text.includes('inhale'))
      return MedicationForm.INHALER;
    if (text.includes('patch')) return MedicationForm.PATCH;
    if (text.includes('drop') || text.includes('eye') || text.includes('ear'))
      return MedicationForm.DROPS;

    return MedicationForm.OTHER;
  }

  private async checkInteractionsForNewMedications(
    userId: string,
    newMedications: Medication[],
  ): Promise<InteractionAnalysis | null> {
    try {
      if (newMedications.length === 0) {
        return null;
      }

      // Check interactions between new medications and existing ones
      const medicationNames = newMedications.map((med) => med.name);
      return await this.drugInteractionService.checkNewMedicationAgainstExisting(
        userId,
        medicationNames[0], // For now, check first medication against existing
      );
    } catch (error) {
      // Don't fail the entire process if interaction checking fails
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      console.error('Failed to check drug interactions:', errorMessage);
      return null;
    }
  }

  async enhancePrescriptionWithRxNormData(prescriptionId: string): Promise<{
    prescription: Prescription;
    enhancedMedications: Array<{
      originalName: string;
      rxcui?: string;
      standardizedName?: string;
      genericName?: string;
      success: boolean;
      error?: string;
    }>;
  }> {
    try {
      const prescription =
        await this.prescriptionService.getPrescription(prescriptionId);
      if (!prescription) {
        throw new Error('Prescription not found');
      }

      const enhancedMedications: Array<{
        originalName: string;
        rxcui?: string;
        standardizedName?: string;
        genericName?: string;
        success: boolean;
        error?: string;
      }> = [];

      // Enhance each medication in the prescription
      for (const medication of prescription.medications) {
        try {
          const enrichedData =
            await this.drugInteractionService.enrichMedicationWithRxNormData(
              medication.name,
              medication.strength,
            );

          if (enrichedData.isValid) {
            // Update the medication in the prescription
            await this.prescriptionService.updateMedicationInPrescription(
              prescriptionId,
              medication.name,
              {
                ...medication,
                name: enrichedData.standardizedName || medication.name,
              },
            );

            enhancedMedications.push({
              originalName: medication.name,
              rxcui: enrichedData.rxcui,
              standardizedName: enrichedData.standardizedName,
              genericName: enrichedData.genericName,
              success: true,
            });
          } else {
            enhancedMedications.push({
              originalName: medication.name,
              success: false,
              error: 'No valid RxNorm match found',
            });
          }
        } catch (error) {
          const errorMessage =
            error instanceof Error ? error.message : 'Unknown error';
          enhancedMedications.push({
            originalName: medication.name,
            success: false,
            error: errorMessage,
          });
        }
      }

      // Get updated prescription
      const updatedPrescription =
        await this.prescriptionService.getPrescription(prescriptionId);

      return {
        prescription: updatedPrescription!,
        enhancedMedications,
      };
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      throw new Error(
        `Failed to enhance prescription with RxNorm data: ${errorMessage}`,
      );
    }
  }
}
