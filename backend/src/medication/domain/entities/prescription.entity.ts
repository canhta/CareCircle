export interface PrescriptionMedication {
  name: string;
  strength: string;
  form: string;
  dosage: string;
  quantity: number;
  instructions: string;
  linkedMedicationId?: string;
}

export interface OCRData {
  extractedText: string;
  confidence: number;
  fields: {
    prescribedBy?: string;
    prescribedDate?: string;
    pharmacy?: string;
    medications?: Array<{
      name?: string;
      strength?: string;
      quantity?: string;
      instructions?: string;
      confidence: number;
    }>;
  };
  processingMetadata: {
    ocrEngine: string;
    processingTime: number;
    imageQuality: number;
    extractionMethod: string;
  };
}

export class Prescription {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public prescribedBy: string,
    public prescribedDate: Date,
    public pharmacy: string | null,
    public ocrData: OCRData | null,
    public imageUrl: string | null,
    public isVerified: boolean,
    public verifiedAt: Date | null,
    public verifiedBy: string | null,
    public medications: PrescriptionMedication[],
    public readonly createdAt: Date,
    public readonly updatedAt: Date,
  ) {}

  static create(data: {
    id: string;
    userId: string;
    prescribedBy: string;
    prescribedDate: Date;
    pharmacy?: string;
    ocrData?: OCRData;
    imageUrl?: string;
    isVerified?: boolean;
    verifiedAt?: Date;
    verifiedBy?: string;
    medications?: PrescriptionMedication[];
  }): Prescription {
    return new Prescription(
      data.id,
      data.userId,
      data.prescribedBy,
      data.prescribedDate,
      data.pharmacy || null,
      data.ocrData || null,
      data.imageUrl || null,
      data.isVerified || false,
      data.verifiedAt || null,
      data.verifiedBy || null,
      data.medications || [],
      new Date(),
      new Date(),
    );
  }

  validate(): boolean {
    // Basic validation rules for prescription data
    if (!this.userId || this.userId.trim().length === 0) return false;
    if (!this.prescribedBy || this.prescribedBy.trim().length === 0) return false;
    
    // Validate prescribed date is not too far in the future
    const now = new Date();
    const maxFutureDate = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000); // 7 days
    if (this.prescribedDate > maxFutureDate) return false;
    
    // Validate prescribed date is not too far in the past (10 years)
    const minPastDate = new Date(now.getTime() - 10 * 365 * 24 * 60 * 60 * 1000);
    if (this.prescribedDate < minPastDate) return false;
    
    // Validate medications array
    if (this.medications.length === 0) return false;
    
    // Validate each medication entry
    for (const med of this.medications) {
      if (!med.name || med.name.trim().length === 0) return false;
      if (!med.strength || med.strength.trim().length === 0) return false;
      if (!med.instructions || med.instructions.trim().length === 0) return false;
      if (med.quantity <= 0) return false;
    }
    
    return true;
  }

  verify(verifiedBy: string): void {
    this.isVerified = true;
    this.verifiedAt = new Date();
    this.verifiedBy = verifiedBy;
  }

  unverify(): void {
    this.isVerified = false;
    this.verifiedAt = null;
    this.verifiedBy = null;
  }

  addMedication(medication: PrescriptionMedication): void {
    // Validate medication before adding
    if (!medication.name || medication.name.trim().length === 0) {
      throw new Error('Medication name is required');
    }
    if (!medication.strength || medication.strength.trim().length === 0) {
      throw new Error('Medication strength is required');
    }
    if (medication.quantity <= 0) {
      throw new Error('Medication quantity must be positive');
    }
    
    this.medications.push(medication);
  }

  removeMedication(medicationName: string): void {
    this.medications = this.medications.filter(med => med.name !== medicationName);
  }

  updateMedication(medicationName: string, updates: Partial<PrescriptionMedication>): void {
    const medicationIndex = this.medications.findIndex(med => med.name === medicationName);
    if (medicationIndex === -1) {
      throw new Error('Medication not found in prescription');
    }
    
    this.medications[medicationIndex] = {
      ...this.medications[medicationIndex],
      ...updates,
    };
  }

  setOCRData(ocrData: OCRData): void {
    this.ocrData = ocrData;
    
    // Auto-populate fields from OCR data if they're not already set
    if (ocrData.fields.prescribedBy && !this.prescribedBy) {
      this.prescribedBy = ocrData.fields.prescribedBy;
    }
    
    if (ocrData.fields.prescribedDate && !this.prescribedDate) {
      const parsedDate = new Date(ocrData.fields.prescribedDate);
      if (!isNaN(parsedDate.getTime())) {
        this.prescribedDate = parsedDate;
      }
    }
    
    if (ocrData.fields.pharmacy && !this.pharmacy) {
      this.pharmacy = ocrData.fields.pharmacy;
    }
    
    // Auto-populate medications from OCR if none exist
    if (this.medications.length === 0 && ocrData.fields.medications) {
      for (const ocrMed of ocrData.fields.medications) {
        if (ocrMed.name && ocrMed.confidence > 0.7) { // Only add high-confidence extractions
          this.addMedication({
            name: ocrMed.name,
            strength: ocrMed.strength || 'Unknown',
            form: 'Unknown',
            dosage: ocrMed.instructions || 'As directed',
            quantity: parseInt(ocrMed.quantity || '30', 10) || 30,
            instructions: ocrMed.instructions || 'As directed',
          });
        }
      }
    }
  }

  setImageUrl(imageUrl: string): void {
    this.imageUrl = imageUrl;
  }

  hasOCRData(): boolean {
    return this.ocrData !== null;
  }

  hasImage(): boolean {
    return this.imageUrl !== null && this.imageUrl.trim().length > 0;
  }

  getOCRConfidence(): number {
    return this.ocrData?.confidence || 0;
  }

  isHighConfidenceOCR(): boolean {
    return this.getOCRConfidence() > 0.8;
  }

  getMedicationCount(): number {
    return this.medications.length;
  }

  findMedication(medicationName: string): PrescriptionMedication | null {
    return this.medications.find(med => 
      med.name.toLowerCase().includes(medicationName.toLowerCase())
    ) || null;
  }

  isExpired(expirationMonths: number = 12): boolean {
    const expirationDate = new Date(this.prescribedDate);
    expirationDate.setMonth(expirationDate.getMonth() + expirationMonths);
    return new Date() > expirationDate;
  }

  getAge(): number {
    const now = new Date();
    const diffTime = now.getTime() - this.prescribedDate.getTime();
    return Math.floor(diffTime / (1000 * 60 * 60 * 24)); // Age in days
  }

  requiresVerification(): boolean {
    return !this.isVerified && (this.hasOCRData() || this.getMedicationCount() > 0);
  }

  toJSON(): Record<string, any> {
    return {
      id: this.id,
      userId: this.userId,
      prescribedBy: this.prescribedBy,
      prescribedDate: this.prescribedDate.toISOString(),
      pharmacy: this.pharmacy,
      ocrData: this.ocrData,
      imageUrl: this.imageUrl,
      isVerified: this.isVerified,
      verifiedAt: this.verifiedAt?.toISOString() || null,
      verifiedBy: this.verifiedBy,
      medications: this.medications,
      createdAt: this.createdAt.toISOString(),
      updatedAt: this.updatedAt.toISOString(),
    };
  }
}
