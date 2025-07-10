import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ImageAnnotatorClient } from '@google-cloud/vision';
import {
  GoogleVisionResponse as _GoogleVisionResponse,
  GoogleVisionAnnotateResponse as _GoogleVisionAnnotateResponse,
  OCRProcessingResult as _OCRProcessingResult,
  OCRStructuredData as _OCRStructuredData,
  OCRMedicationData as _OCRMedicationData,
  isGoogleVisionResponse as _isGoogleVisionResponse,
  hasTextAnnotations as _hasTextAnnotations,
  hasFullTextAnnotation as _hasFullTextAnnotation,
} from '../types/google-vision.types';
import { OCRData } from '../../domain/entities/prescription.entity';

export interface OCRProcessingOptions {
  imageQuality?: 'low' | 'medium' | 'high';
  extractionMethod?: 'basic' | 'enhanced' | 'medical';
  confidenceThreshold?: number;
}

@Injectable()
export class OCRService {
  private visionClient: ImageAnnotatorClient;

  constructor(private readonly configService: ConfigService) {
    // Initialize Google Vision API client
    const credentials = this.configService.get<string>(
      'GOOGLE_CLOUD_CREDENTIALS',
    );
    const projectId = this.configService.get<string>('GOOGLE_CLOUD_PROJECT_ID');

    if (credentials) {
      this.visionClient = new ImageAnnotatorClient({
        projectId: projectId || undefined,
        keyFilename: credentials, // Path to service account key file
      });
    } else {
      // Use default credentials (for production with service account)
      this.visionClient = new ImageAnnotatorClient({
        projectId: projectId || undefined,
      });
    }
  }

  async processImage(
    imageBuffer: Buffer,
    options: OCRProcessingOptions = {},
  ): Promise<OCRData> {
    const startTime = Date.now();

    try {
      // Perform text detection
      const [result] = await this.visionClient.textDetection({
        image: { content: imageBuffer },
      });

      const detections = result.textAnnotations || [];
      const fullText = detections[0]?.description || '';

      // Calculate overall confidence
      const confidence = this.calculateConfidence(detections);

      // Extract structured fields from the text
      const fields = this.extractMedicalFields(fullText, detections);

      // Calculate processing metrics
      const processingTime = Date.now() - startTime;
      const imageQuality = this.assessImageQuality(result);

      return {
        extractedText: fullText,
        confidence,
        fields,
        processingMetadata: {
          ocrEngine: 'Google Vision API',
          processingTime,
          imageQuality,
          extractionMethod: options.extractionMethod || 'enhanced',
        },
      };
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      throw new HttpException(
        `OCR processing failed: ${errorMessage}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async processImageFromUrl(
    imageUrl: string,
    options: OCRProcessingOptions = {},
  ): Promise<OCRData> {
    const startTime = Date.now();

    try {
      // Perform text detection from URL
      const [result] = await this.visionClient.textDetection({
        image: { source: { imageUri: imageUrl } },
      });

      const detections = result.textAnnotations || [];
      const fullText = detections[0]?.description || '';

      // Calculate overall confidence
      const confidence = this.calculateConfidence(detections);

      // Extract structured fields from the text
      const fields = this.extractMedicalFields(fullText, detections);

      // Calculate processing metrics
      const processingTime = Date.now() - startTime;
      const imageQuality = this.assessImageQuality(result);

      return {
        extractedText: fullText,
        confidence,
        fields,
        processingMetadata: {
          ocrEngine: 'Google Vision API',
          processingTime,
          imageQuality,
          extractionMethod: options.extractionMethod || 'enhanced',
        },
      };
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      throw new HttpException(
        `OCR processing from URL failed: ${errorMessage}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  private calculateConfidence(detections: unknown[]): number {
    if (detections.length === 0) return 0;

    // Skip the first detection (full text) and calculate average confidence
    const wordDetections = detections.slice(1);
    if (wordDetections.length === 0) return 0.5; // Default confidence for full text only

    const totalConfidence = wordDetections.reduce((sum: number, detection) => {
      const confidence =
        (detection as { confidence?: number }).confidence || 0.5;
      return sum + confidence;
    }, 0);

    return Math.min(1, (totalConfidence as number) / wordDetections.length);
  }

  private extractMedicalFields(
    fullText: string,
    _detections: unknown[],
  ): Record<string, unknown> {
    const fields: Record<string, unknown> = {
      medications: [],
    };

    // Extract prescriber information
    const prescriberMatch = this.extractPrescriber(fullText);
    if (prescriberMatch) {
      fields.prescribedBy = prescriberMatch;
    }

    // Extract date information
    const dateMatch = this.extractDate(fullText);
    if (dateMatch) {
      fields.prescribedDate = dateMatch;
    }

    // Extract pharmacy information
    const pharmacyMatch = this.extractPharmacy(fullText);
    if (pharmacyMatch) {
      fields.pharmacy = pharmacyMatch;
    }

    // Extract medication information
    const medications = this.extractMedications(fullText, _detections);
    if (medications.length > 0) {
      fields.medications = medications;
    }

    return fields;
  }

  private extractPrescriber(text: string): string | null {
    // Common patterns for prescriber names
    const patterns = [
      /(?:Dr\.?\s+|Doctor\s+|Physician\s+)([A-Z][a-z]+\s+[A-Z][a-z]+)/i,
      /Prescriber:\s*([A-Z][a-z]+\s+[A-Z][a-z]+)/i,
      /Prescribed\s+by:\s*([A-Z][a-z]+\s+[A-Z][a-z]+)/i,
    ];

    for (const pattern of patterns) {
      const match = text.match(pattern);
      if (match) {
        return match[1].trim();
      }
    }

    return null;
  }

  private extractDate(text: string): string | null {
    // Common date patterns
    const patterns = [
      /(\d{1,2}\/\d{1,2}\/\d{4})/,
      /(\d{1,2}-\d{1,2}-\d{4})/,
      /(\d{4}-\d{1,2}-\d{1,2})/,
      /Date:\s*(\d{1,2}\/\d{1,2}\/\d{4})/i,
      /Prescribed:\s*(\d{1,2}\/\d{1,2}\/\d{4})/i,
    ];

    for (const pattern of patterns) {
      const match = text.match(pattern);
      if (match) {
        return match[1];
      }
    }

    return null;
  }

  private extractPharmacy(text: string): string | null {
    // Common pharmacy patterns
    const patterns = [
      /Pharmacy:\s*([A-Z][a-zA-Z\s]+)/i,
      /(CVS|Walgreens|Rite Aid|Walmart|Target|Kroger)\s*Pharmacy/i,
      /Dispensed\s+by:\s*([A-Z][a-zA-Z\s]+)/i,
    ];

    for (const pattern of patterns) {
      const match = text.match(pattern);
      if (match) {
        return match[1].trim();
      }
    }

    return null;
  }

  private extractMedications(
    text: string,
    _detections: unknown[],
  ): Record<string, unknown>[] {
    const medications: Record<string, unknown>[] = [];

    // Split text into lines for better parsing
    const lines = text.split('\n').filter((line) => line.trim().length > 0);

    for (const line of lines) {
      const medication = this.parseMedicationLine(line);
      if (medication) {
        medications.push(medication);
      }
    }

    return medications;
  }

  private parseMedicationLine(line: string): Record<string, unknown> | null {
    // Common medication line patterns
    const patterns = [
      // Pattern: "Medication Name 10mg - Take 1 tablet daily - Qty: 30"
      /^([A-Za-z\s]+)\s+(\d+(?:\.\d+)?(?:mg|mcg|g|ml|units?))\s*-?\s*(.+?)\s*-?\s*(?:Qty|Quantity):\s*(\d+)/i,
      // Pattern: "Medication Name 10mg, Take 1 tablet daily, #30"
      /^([A-Za-z\s]+)\s+(\d+(?:\.\d+)?(?:mg|mcg|g|ml|units?))\s*,\s*(.+?)\s*,\s*#(\d+)/i,
      // Pattern: "Medication Name - 10mg - Take 1 tablet daily"
      /^([A-Za-z\s]+)\s*-\s*(\d+(?:\.\d+)?(?:mg|mcg|g|ml|units?))\s*-\s*(.+)/i,
    ];

    for (const pattern of patterns) {
      const match = line.match(pattern);
      if (match) {
        return {
          name: match[1].trim(),
          strength: match[2],
          instructions: match[3].trim(),
          quantity: match[4] || '30',
          confidence: 0.8, // High confidence for structured matches
        };
      }
    }

    // Fallback: Look for medication-like words
    const medicationWords = line.match(
      /[A-Z][a-z]+(?:in|ol|ex|ide|ine|ate)\b/g,
    );
    if (medicationWords && medicationWords.length > 0) {
      return {
        name: medicationWords[0],
        strength: 'Unknown',
        instructions: line.trim(),
        quantity: '30',
        confidence: 0.5, // Lower confidence for fallback matches
      };
    }

    return null;
  }

  private assessImageQuality(result: unknown): number {
    // Assess image quality based on detection confidence and text clarity
    const detections =
      (result as { textAnnotations?: unknown[] }).textAnnotations || [];

    if (detections.length === 0) return 0.1;

    const avgConfidence = this.calculateConfidence(detections);
    const textLength =
      (detections[0] as { description?: string })?.description?.length || 0;

    // Quality score based on confidence and text amount
    let quality = avgConfidence;

    if (textLength > 100) quality += 0.1;
    if (textLength > 500) quality += 0.1;

    return Math.min(1, quality);
  }

  validateOCRResult(ocrData: OCRData): {
    isValid: boolean;
    confidence: number;
    issues: string[];
    suggestions: string[];
  } {
    const issues: string[] = [];
    const suggestions: string[] = [];

    // Validate overall confidence
    if (ocrData.confidence < 0.7) {
      issues.push('Low OCR confidence detected');
      suggestions.push('Consider retaking the image with better lighting');
    }

    // Validate extracted fields
    if (!ocrData.fields.prescribedBy) {
      issues.push('Prescriber information not detected');
      suggestions.push('Ensure prescriber name is clearly visible');
    }

    if (!ocrData.fields.prescribedDate) {
      issues.push('Prescription date not detected');
      suggestions.push('Ensure date is clearly visible and not obscured');
    }

    if (
      !ocrData.fields.medications ||
      ocrData.fields.medications.length === 0
    ) {
      issues.push('No medications detected');
      suggestions.push(
        'Ensure medication names and dosages are clearly visible',
      );
    }

    // Validate image quality
    if (ocrData.processingMetadata.imageQuality < 0.6) {
      issues.push('Poor image quality detected');
      suggestions.push('Retake image with better focus and lighting');
    }

    return {
      isValid: issues.length === 0,
      confidence: ocrData.confidence,
      issues,
      suggestions,
    };
  }
}
