import { Injectable, Logger } from '@nestjs/common';
import * as crypto from 'crypto-js';

export interface PHIIdentifier {
  type: PHIType;
  value: string;
  startIndex: number;
  endIndex: number;
  confidence: number;
  maskedValue: string;
}

export enum PHIType {
  // 18 HIPAA Safe Harbor identifiers
  NAME = 'name',
  GEOGRAPHIC_SUBDIVISION = 'geographic_subdivision',
  DATE = 'date',
  PHONE_NUMBER = 'phone_number',
  FAX_NUMBER = 'fax_number',
  EMAIL = 'email',
  SSN = 'ssn',
  MEDICAL_RECORD_NUMBER = 'medical_record_number',
  HEALTH_PLAN_NUMBER = 'health_plan_number',
  ACCOUNT_NUMBER = 'account_number',
  CERTIFICATE_NUMBER = 'certificate_number',
  VEHICLE_IDENTIFIER = 'vehicle_identifier',
  DEVICE_IDENTIFIER = 'device_identifier',
  WEB_URL = 'web_url',
  IP_ADDRESS = 'ip_address',
  BIOMETRIC_IDENTIFIER = 'biometric_identifier',
  PHOTO = 'photo',
  OTHER_UNIQUE_IDENTIFIER = 'other_unique_identifier',
  // Vietnamese specific identifiers
  VIETNAMESE_ID_CARD = 'vietnamese_id_card',
  VIETNAMESE_PASSPORT = 'vietnamese_passport',
  VIETNAMESE_INSURANCE_CARD = 'vietnamese_insurance_card',
}

export interface PHIDetectionResult {
  originalText: string;
  maskedText: string;
  detectedPHI: PHIIdentifier[];
  confidenceScore: number;
  riskLevel: 'low' | 'medium' | 'high' | 'critical';
  processingTime: number;
}

@Injectable()
export class PHIProtectionService {
  private readonly logger = new Logger(PHIProtectionService.name);

  // HIPAA Safe Harbor patterns
  private readonly phiPatterns = new Map<PHIType, RegExp[]>([
    [
      PHIType.SSN,
      [/\b\d{3}-\d{2}-\d{4}\b/g, /\b\d{3}\s\d{2}\s\d{4}\b/g, /\b\d{9}\b/g],
    ],
    [
      PHIType.PHONE_NUMBER,
      [
        /\b\d{3}-\d{3}-\d{4}\b/g,
        /\b\(\d{3}\)\s?\d{3}-\d{4}\b/g,
        /\b\d{3}\.\d{3}\.\d{4}\b/g,
        /\b\+1\s?\d{3}\s?\d{3}\s?\d{4}\b/g,
        // Vietnamese phone patterns
        /\b0\d{9,10}\b/g,
        /\b\+84\s?\d{8,9}\b/g,
      ],
    ],
    [PHIType.EMAIL, [/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/g]],
    [
      PHIType.DATE,
      [
        /\b\d{1,2}\/\d{1,2}\/\d{4}\b/g,
        /\b\d{1,2}-\d{1,2}-\d{4}\b/g,
        /\b\d{4}-\d{1,2}-\d{1,2}\b/g,
        /\b(January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},?\s+\d{4}\b/gi,
        // Vietnamese date patterns
        /\b\d{1,2}\/\d{1,2}\/\d{4}\b/g,
        /\b\d{1,2}-\d{1,2}-\d{4}\b/g,
      ],
    ],
    [
      PHIType.MEDICAL_RECORD_NUMBER,
      [
        /\bMRN\s*:?\s*\d+\b/gi,
        /\bMedical\s+Record\s+Number\s*:?\s*\d+\b/gi,
        /\bPatient\s+ID\s*:?\s*\d+\b/gi,
      ],
    ],
    [PHIType.IP_ADDRESS, [/\b(?:\d{1,3}\.){3}\d{1,3}\b/g]],
    [PHIType.WEB_URL, [/https?:\/\/[^\s]+/g, /www\.[^\s]+/g]],
    [
      PHIType.VIETNAMESE_ID_CARD,
      [
        /\b\d{9}\b/g, // Old format
        /\b\d{12}\b/g, // New format
        /\bCMND\s*:?\s*\d{9,12}\b/gi,
        /\bCCCD\s*:?\s*\d{12}\b/gi,
      ],
    ],
    [
      PHIType.VIETNAMESE_PASSPORT,
      [/\b[A-Z]\d{7,8}\b/g, /\bHộ\s+chiếu\s*:?\s*[A-Z]\d{7,8}\b/gi],
    ],
    [
      PHIType.VIETNAMESE_INSURANCE_CARD,
      [/\b[A-Z]{2}\d{13}\b/g, /\bBHYT\s*:?\s*[A-Z]{2}\d{13}\b/gi],
    ],
  ]);

  // Vietnamese name patterns (common Vietnamese surnames and given names)
  private readonly vietnameseNamePatterns = [
    /\b(Nguyễn|Trần|Lê|Phạm|Hoàng|Huỳnh|Phan|Vũ|Võ|Đặng|Bùi|Đỗ|Hồ|Ngô|Dương|Lý)\s+[A-ZÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ][a-zàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]+(\s+[A-ZÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ][a-zàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]+)*\b/g,
  ];

  async detectAndMaskPHI(text: string): Promise<PHIDetectionResult> {
    const startTime = Date.now();

    try {
      this.logger.log('Starting PHI detection and masking');

      const detectedPHI: PHIIdentifier[] = [];
      let maskedText = text;

      // Detect each type of PHI
      for (const [phiType, patterns] of this.phiPatterns) {
        for (const pattern of patterns) {
          const matches = Array.from(text.matchAll(pattern));

          for (const match of matches) {
            if (match.index !== undefined) {
              const identifier: PHIIdentifier = {
                type: phiType,
                value: match[0],
                startIndex: match.index,
                endIndex: match.index + match[0].length,
                confidence: this.calculateConfidence(phiType, match[0]),
                maskedValue: this.generateMask(phiType, match[0]),
              };

              detectedPHI.push(identifier);
            }
          }
        }
      }

      // Detect Vietnamese names
      for (const namePattern of this.vietnameseNamePatterns) {
        const matches = Array.from(text.matchAll(namePattern));

        for (const match of matches) {
          if (match.index !== undefined) {
            const identifier: PHIIdentifier = {
              type: PHIType.NAME,
              value: match[0],
              startIndex: match.index,
              endIndex: match.index + match[0].length,
              confidence: 0.8,
              maskedValue: this.generateMask(PHIType.NAME, match[0]),
            };

            detectedPHI.push(identifier);
          }
        }
      }

      // Sort by start index (descending) to avoid index shifting during replacement
      detectedPHI.sort((a, b) => b.startIndex - a.startIndex);

      // Apply masking
      for (const phi of detectedPHI) {
        maskedText =
          maskedText.substring(0, phi.startIndex) +
          phi.maskedValue +
          maskedText.substring(phi.endIndex);
      }

      const processingTime = Date.now() - startTime;
      const confidenceScore = this.calculateOverallConfidence(detectedPHI);
      const riskLevel = this.assessRiskLevel(detectedPHI);

      this.logger.log(
        `PHI detection completed: ${detectedPHI.length} identifiers found in ${processingTime}ms`,
      );

      return {
        originalText: text,
        maskedText,
        detectedPHI,
        confidenceScore,
        riskLevel,
        processingTime,
      };
    } catch (error) {
      this.logger.error('Error in PHI detection:', error);
      throw new Error('PHI detection failed');
    }
  }

  private calculateConfidence(phiType: PHIType, value: string): number {
    // Base confidence scores by PHI type
    const baseConfidence = new Map<PHIType, number>([
      [PHIType.SSN, 0.95],
      [PHIType.EMAIL, 0.9],
      [PHIType.PHONE_NUMBER, 0.85],
      [PHIType.IP_ADDRESS, 0.8],
      [PHIType.VIETNAMESE_ID_CARD, 0.9],
      [PHIType.VIETNAMESE_PASSPORT, 0.85],
      [PHIType.VIETNAMESE_INSURANCE_CARD, 0.9],
      [PHIType.DATE, 0.7],
      [PHIType.NAME, 0.75],
    ]);

    let confidence = baseConfidence.get(phiType) || 0.6;

    // Adjust confidence based on context and format
    if (phiType === PHIType.PHONE_NUMBER) {
      if (value.includes('+84') || value.startsWith('0')) {
        confidence += 0.1; // Vietnamese phone number
      }
    }

    if (phiType === PHIType.NAME) {
      if (this.isVietnameseName(value)) {
        confidence += 0.15;
      }
    }

    return Math.min(confidence, 1.0);
  }

  private isVietnameseName(name: string): boolean {
    const vietnameseSurnames = [
      'Nguyễn',
      'Trần',
      'Lê',
      'Phạm',
      'Hoàng',
      'Huỳnh',
      'Phan',
      'Vũ',
      'Võ',
      'Đặng',
      'Bùi',
      'Đỗ',
      'Hồ',
      'Ngô',
      'Dương',
      'Lý',
    ];

    return vietnameseSurnames.some((surname) => name.startsWith(surname));
  }

  private generateMask(phiType: PHIType, originalValue: string): string {
    const maskChar = '*';

    switch (phiType) {
      case PHIType.SSN:
        return 'XXX-XX-XXXX';
      case PHIType.PHONE_NUMBER:
        return originalValue.startsWith('+84')
          ? '+84-XXX-XXX-XXX'
          : 'XXX-XXX-XXXX';
      case PHIType.EMAIL:
        const [localPart, domain] = originalValue.split('@');
        return `${localPart.charAt(0)}${'*'.repeat(localPart.length - 1)}@${domain}`;
      case PHIType.VIETNAMESE_ID_CARD:
        return originalValue.length === 9 ? 'XXXXXXXXX' : 'XXXXXXXXXXXX';
      case PHIType.VIETNAMESE_PASSPORT:
        return 'XXXXXXXX';
      case PHIType.VIETNAMESE_INSURANCE_CARD:
        return 'XXXXXXXXXXXXXXX';
      case PHIType.NAME:
        const nameParts = originalValue.split(' ');
        return nameParts
          .map((part) => part.charAt(0) + '*'.repeat(part.length - 1))
          .join(' ');
      case PHIType.DATE:
        return 'XX/XX/XXXX';
      case PHIType.IP_ADDRESS:
        return 'XXX.XXX.XXX.XXX';
      default:
        return '*'.repeat(originalValue.length);
    }
  }

  private calculateOverallConfidence(detectedPHI: PHIIdentifier[]): number {
    if (detectedPHI.length === 0) return 1.0;

    const totalConfidence = detectedPHI.reduce(
      (sum, phi) => sum + phi.confidence,
      0,
    );
    return totalConfidence / detectedPHI.length;
  }

  private assessRiskLevel(
    detectedPHI: PHIIdentifier[],
  ): 'low' | 'medium' | 'high' | 'critical' {
    if (detectedPHI.length === 0) return 'low';

    const highRiskTypes = [
      PHIType.SSN,
      PHIType.MEDICAL_RECORD_NUMBER,
      PHIType.VIETNAMESE_ID_CARD,
      PHIType.VIETNAMESE_INSURANCE_CARD,
    ];

    const hasHighRiskPHI = detectedPHI.some((phi) =>
      highRiskTypes.includes(phi.type),
    );
    const phiCount = detectedPHI.length;

    if (hasHighRiskPHI && phiCount >= 3) return 'critical';
    if (hasHighRiskPHI || phiCount >= 5) return 'high';
    if (phiCount >= 2) return 'medium';
    return 'low';
  }

  async encryptSensitiveData(data: string, key?: string): Promise<string> {
    try {
      const encryptionKey =
        key || process.env.PHI_ENCRYPTION_KEY || 'default-key';
      return crypto.AES.encrypt(data, encryptionKey).toString();
    } catch (error) {
      this.logger.error('Error encrypting sensitive data:', error);
      throw error;
    }
  }

  async decryptSensitiveData(
    encryptedData: string,
    key?: string,
  ): Promise<string> {
    try {
      const encryptionKey =
        key || process.env.PHI_ENCRYPTION_KEY || 'default-key';
      const bytes = crypto.AES.decrypt(encryptedData, encryptionKey);
      return bytes.toString(crypto.enc.Utf8);
    } catch (error) {
      this.logger.error('Error decrypting sensitive data:', error);
      throw error;
    }
  }
}
