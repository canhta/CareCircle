import { Injectable } from '@nestjs/common';
import { PrescriptionOCRService } from './services/prescription-ocr.service';
import {
  PrescriptionOCRResponseDto,
  PrescriptionExtractedDataDto,
  PrescriptionValidationDto,
} from './dto/prescription-ocr.dto';

@Injectable()
export class PrescriptionService {
  constructor(private readonly ocrService: PrescriptionOCRService) {}

  /**
   * Processes an image buffer using OCR and returns structured prescription data
   */
  async processImageBuffer(
    imageBuffer: Buffer,
  ): Promise<PrescriptionOCRResponseDto> {
    // Process the image with OCR
    const ocrResult = await this.ocrService.processImageBuffer(imageBuffer);

    // Validate the extracted data
    const validation = this.ocrService.validatePrescriptionData(ocrResult);

    // Map the results to the response DTO
    const extractedData: PrescriptionExtractedDataDto = {
      drugName: ocrResult.extractedData.drugName,
      dosage: ocrResult.extractedData.dosage,
      frequency: ocrResult.extractedData.frequency,
      quantity: ocrResult.extractedData.quantity,
      prescriber: ocrResult.extractedData.prescriber,
      instructions: ocrResult.extractedData.instructions,
    };

    const validationResult: PrescriptionValidationDto = {
      isValid: validation.isValid,
      confidence: validation.confidence,
      issues: validation.issues,
    };

    return {
      text: ocrResult.text,
      confidence: ocrResult.confidence,
      extractedData,
      validation: validationResult,
      processedAt: new Date().toISOString(),
    };
  }
}
