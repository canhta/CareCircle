import { MedicationForm } from '@prisma/client';

export class Medication {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public readonly name: string,
    public readonly genericName: string | null,
    public readonly strength: string,
    public readonly form: MedicationForm,
    public readonly manufacturer: string | null,
    public readonly rxNormCode: string | null,
    public readonly ndcCode: string | null,
    public readonly classification: string | null,
    public isActive: boolean,
    public readonly startDate: Date,
    public endDate: Date | null,
    public readonly prescriptionId: string | null,
    public notes: string | null,
    public readonly createdAt: Date,
    public readonly updatedAt: Date,
  ) {}

  static create(data: {
    id: string;
    userId: string;
    name: string;
    genericName?: string;
    strength: string;
    form: MedicationForm;
    manufacturer?: string;
    rxNormCode?: string;
    ndcCode?: string;
    classification?: string;
    isActive?: boolean;
    startDate: Date;
    endDate?: Date;
    prescriptionId?: string;
    notes?: string;
  }): Medication {
    return new Medication(
      data.id,
      data.userId,
      data.name,
      data.genericName || null,
      data.strength,
      data.form,
      data.manufacturer || null,
      data.rxNormCode || null,
      data.ndcCode || null,
      data.classification || null,
      data.isActive ?? true,
      data.startDate,
      data.endDate || null,
      data.prescriptionId || null,
      data.notes || null,
      new Date(),
      new Date(),
    );
  }

  validate(): boolean {
    // Basic validation rules for medication data
    if (!this.name || this.name.trim().length === 0) return false;
    if (!this.strength || this.strength.trim().length === 0) return false;
    if (!this.userId || this.userId.trim().length === 0) return false;

    // Validate start date is not in the future beyond reasonable limits
    const now = new Date();
    const maxFutureDate = new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000); // 30 days
    if (this.startDate > maxFutureDate) return false;

    // Validate end date is after start date if provided
    if (this.endDate && this.endDate <= this.startDate) return false;

    // Validate medication form
    if (!Object.values(MedicationForm).includes(this.form)) return false;

    return true;
  }

  deactivate(reason?: string): void {
    this.isActive = false;
    this.endDate = new Date();
    if (reason) {
      this.notes = this.notes
        ? `${this.notes}\nDeactivated: ${reason}`
        : `Deactivated: ${reason}`;
    }
  }

  reactivate(): void {
    this.isActive = true;
    this.endDate = null;
  }

  updateNotes(notes: string): void {
    this.notes = notes;
  }

  setEndDate(endDate: Date): void {
    if (endDate <= this.startDate) {
      throw new Error('End date must be after start date');
    }
    this.endDate = endDate;
  }

  isCurrentlyActive(): boolean {
    if (!this.isActive) return false;

    const now = new Date();
    if (this.startDate > now) return false;
    if (this.endDate && this.endDate < now) return false;

    return true;
  }

  isExpired(): boolean {
    if (!this.endDate) return false;
    return this.endDate < new Date();
  }

  getDurationInDays(): number | null {
    if (!this.endDate) return null;
    const diffTime = this.endDate.getTime() - this.startDate.getTime();
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  }

  hasRxNormCode(): boolean {
    return this.rxNormCode !== null && this.rxNormCode.trim().length > 0;
  }

  hasNdcCode(): boolean {
    return this.ndcCode !== null && this.ndcCode.trim().length > 0;
  }

  isPrescriptionBased(): boolean {
    return this.prescriptionId !== null;
  }

  getDisplayName(): string {
    if (this.genericName && this.genericName !== this.name) {
      return `${this.name} (${this.genericName})`;
    }
    return this.name;
  }

  getFullDescription(): string {
    const parts = [
      this.getDisplayName(),
      this.strength,
      this.form.toLowerCase(),
    ];
    if (this.manufacturer) {
      parts.push(`by ${this.manufacturer}`);
    }
    return parts.join(' ');
  }

  toJSON(): Record<string, any> {
    return {
      id: this.id,
      userId: this.userId,
      name: this.name,
      genericName: this.genericName,
      strength: this.strength,
      form: this.form,
      manufacturer: this.manufacturer,
      rxNormCode: this.rxNormCode,
      ndcCode: this.ndcCode,
      classification: this.classification,
      isActive: this.isActive,
      startDate: this.startDate.toISOString(),
      endDate: this.endDate?.toISOString() || null,
      prescriptionId: this.prescriptionId,
      notes: this.notes,
      createdAt: this.createdAt.toISOString(),
      updatedAt: this.updatedAt.toISOString(),
    };
  }
}
