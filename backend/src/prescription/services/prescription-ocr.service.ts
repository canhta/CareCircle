import { Injectable, Logger } from '@nestjs/common';
import * as Tesseract from 'tesseract.js';
import * as sharp from 'sharp';

export interface PrescriptionOCRResult {
  text: string;
  confidence: number;
  extractedData: {
    drugName?: string;
    dosage?: string;
    frequency?: string;
    quantity?: string;
    prescriber?: string;
    instructions?: string;
  };
  rawOCRResult: any;
}

@Injectable()
export class PrescriptionOCRService {
  private readonly logger = new Logger(PrescriptionOCRService.name);

  /**
   * Processes an image buffer and extracts prescription text using OCR
   */
  async processImageBuffer(
    imageBuffer: Buffer,
  ): Promise<PrescriptionOCRResult> {
    try {
      this.logger.log('Starting OCR processing for prescription image');

      // Preprocess the image for better OCR accuracy
      const preprocessedImage = await this.preprocessImage(imageBuffer);

      // Initialize Tesseract with optimized configuration for prescription text
      const { data } = await Tesseract.recognize(preprocessedImage, 'eng', {
        logger: (m) => {
          if (m.status === 'recognizing text') {
            this.logger.debug(
              `OCR Progress: ${(m.progress * 100).toFixed(1)}%`,
            );
          }
        },
      });

      this.logger.log(`OCR completed with confidence: ${data.confidence}%`);

      // Extract prescription-specific data from the OCR text
      const extractedData = this.extractPrescriptionData(data.text);

      return {
        text: data.text,
        confidence: data.confidence,
        extractedData,
        rawOCRResult: data,
      };
    } catch (error) {
      this.logger.error('Error during OCR processing:', error);
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      throw new Error(`OCR processing failed: ${errorMessage}`);
    }
  }

  /**
   * Preprocesses the image to improve OCR accuracy
   */
  private async preprocessImage(imageBuffer: Buffer): Promise<Buffer> {
    try {
      this.logger.debug('Preprocessing image for OCR');

      return await sharp(imageBuffer)
        .grayscale() // Convert to grayscale
        .normalize() // Normalize the image histogram
        .sharpen() // Apply sharpening
        .resize(null, 1200, {
          withoutEnlargement: true,
          fit: 'inside',
        }) // Resize while maintaining aspect ratio
        .png() // Convert to PNG for better OCR processing
        .toBuffer();
    } catch (error) {
      this.logger.error('Error preprocessing image:', error);
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      throw new Error(`Image preprocessing failed: ${errorMessage}`);
    }
  }

  /**
   * Extracts structured prescription data from OCR text using pattern matching
   */
  private extractPrescriptionData(
    text: string,
  ): PrescriptionOCRResult['extractedData'] {
    const lines = text
      .split('\n')
      .map((line) => line.trim())
      .filter((line) => line.length > 0);

    const extractedData: PrescriptionOCRResult['extractedData'] = {};

    // Drug name patterns - typically appear early in prescription
    const drugNamePatterns = [
      /^([A-Za-z]+(?:\s+[A-Za-z]+)*)\s*(?:\d+(?:\.\d+)?\s*(?:mg|mcg|g|ml|tablets?|caps?|capsules?))/i,
      /^([A-Za-z]+(?:\s+[A-Za-z]+){0,2})\s+\d+/i,
    ];

    // Dosage patterns
    const dosagePatterns = [
      /(\d+(?:\.\d+)?\s*(?:mg|mcg|g|ml|tablets?|caps?|capsules?))/gi,
      /(\d+(?:\.\d+)?\/\d+(?:\.\d+)?\s*(?:mg|mcg|g|ml))/gi,
    ];

    // Frequency patterns
    const frequencyPatterns = [
      /(once|twice|three times?|four times?|1x|2x|3x|4x)\s*(?:daily|per day|a day)/gi,
      /(every\s+\d+\s+hours?)/gi,
      /(morning|evening|night|bedtime|before meals?|after meals?|with meals?)/gi,
      /(bid|tid|qid|qd|q\d+h)/gi, // Medical abbreviations
    ];

    // Quantity patterns
    const quantityPatterns = [
      /(?:qty|quantity|dispense|disp)?\s*:?\s*(\d+)\s*(?:tablets?|caps?|capsules?|pills?|ml|bottles?)/gi,
      /#(\d+)/g, // Common prescription notation
    ];

    // Instructions patterns
    const instructionPatterns = [
      /(take\s+.*(?:daily|per day|times?))/gi,
      /(apply\s+.*)/gi,
      /(use\s+.*)/gi,
      /(inject\s+.*)/gi,
    ];

    // Extract drug name (usually in first few lines)
    for (let i = 0; i < Math.min(3, lines.length); i++) {
      for (const pattern of drugNamePatterns) {
        const match = lines[i].match(pattern);
        if (match && match[1] && match[1].length > 2) {
          extractedData.drugName = match[1].trim();
          break;
        }
      }
      if (extractedData.drugName) break;
    }

    // Extract dosage - find first match from any pattern
    for (const pattern of dosagePatterns) {
      const match = text.match(pattern);
      if (match && match.length > 0) {
        extractedData.dosage = match[0];
        break;
      }
    }

    // Extract frequency - find first match from any pattern
    for (const pattern of frequencyPatterns) {
      const match = text.match(pattern);
      if (match && match.length > 0) {
        extractedData.frequency = match[0];
        break;
      }
    }

    // Extract quantity - find first match from any pattern
    for (const pattern of quantityPatterns) {
      const match = text.match(pattern);
      if (match && match.length > 0) {
        const numMatch = match[0].match(/\d+/);
        if (numMatch) {
          extractedData.quantity = numMatch[0];
          break;
        }
      }
    }

    // Extract instructions - combine all matches
    const allInstructions: string[] = [];
    for (const pattern of instructionPatterns) {
      const matches = text.match(pattern);
      if (matches) {
        allInstructions.push(...matches);
      }
    }
    if (allInstructions.length > 0) {
      extractedData.instructions = allInstructions.join('; ');
    }

    // Try to extract prescriber name (often at bottom of prescription)
    const prescriberPatterns = [
      /(?:dr\.?|doctor|md|physician)\s+([A-Za-z]+(?:\s+[A-Za-z]+)*)/gi,
      /prescribed by\s+([A-Za-z]+(?:\s+[A-Za-z]+)*)/gi,
    ];

    for (const pattern of prescriberPatterns) {
      const match = text.match(pattern);
      if (match && match[1]) {
        extractedData.prescriber = match[1].trim();
        break;
      }
    }

    this.logger.debug('Extracted prescription data:', extractedData);
    return extractedData;
  }

  /**
   * Validates if the extracted data appears to be from a valid prescription
   */
  validatePrescriptionData(result: PrescriptionOCRResult): {
    isValid: boolean;
    confidence: 'low' | 'medium' | 'high';
    issues: string[];
  } {
    const issues: string[] = [];
    let score = 0;

    // Check OCR confidence
    if (result.confidence < 60) {
      issues.push('Low OCR confidence - image quality may be poor');
    } else if (result.confidence >= 80) {
      score += 2;
    } else {
      score += 1;
    }

    // Check for drug name
    if (result.extractedData.drugName) {
      score += 3;
    } else {
      issues.push('No drug name detected');
    }

    // Check for dosage
    if (result.extractedData.dosage) {
      score += 2;
    } else {
      issues.push('No dosage information detected');
    }

    // Check for frequency or instructions
    if (result.extractedData.frequency || result.extractedData.instructions) {
      score += 2;
    } else {
      issues.push('No usage instructions detected');
    }

    // Check text length (prescriptions should have substantial text)
    if (result.text.length < 20) {
      issues.push('Detected text too short for a prescription');
    } else if (result.text.length > 50) {
      score += 1;
    }

    const isValid = score >= 3 && issues.length <= 2;
    let confidence: 'low' | 'medium' | 'high';

    if (score >= 6) {
      confidence = 'high';
    } else if (score >= 4) {
      confidence = 'medium';
    } else {
      confidence = 'low';
    }

    return { isValid, confidence, issues };
  }
}
