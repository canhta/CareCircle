import { MetricType, DataSource, ValidationStatus } from '@prisma/client';

export class HealthMetric {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public readonly metricType: MetricType,
    public readonly value: number,
    public readonly unit: string,
    public readonly timestamp: Date,
    public readonly source: DataSource,
    public readonly deviceId: string | null,
    public readonly notes: string | null,
    public readonly isManualEntry: boolean,
    public validationStatus: ValidationStatus,
    public readonly metadata: Record<string, any>,
    public readonly createdAt: Date,
  ) {}

  static create(data: {
    id: string;
    userId: string;
    metricType: MetricType;
    value: number;
    unit: string;
    timestamp?: Date;
    source: DataSource;
    deviceId?: string;
    notes?: string;
    isManualEntry?: boolean;
    validationStatus?: ValidationStatus;
    metadata?: Record<string, any>;
  }): HealthMetric {
    return new HealthMetric(
      data.id,
      data.userId,
      data.metricType,
      data.value,
      data.unit,
      data.timestamp || new Date(),
      data.source,
      data.deviceId || null,
      data.notes || null,
      data.isManualEntry || false,
      data.validationStatus || ValidationStatus.PENDING,
      data.metadata || {},
      new Date(),
    );
  }

  validate(): boolean {
    // Basic validation rules
    if (this.value < 0) return false;

    switch (this.metricType) {
      case MetricType.HEART_RATE:
        return this.value >= 30 && this.value <= 250;
      case MetricType.BLOOD_PRESSURE:
        // Assuming systolic pressure stored in value
        return this.value >= 70 && this.value <= 250;
      case MetricType.BLOOD_GLUCOSE:
        return this.value >= 20 && this.value <= 600; // mg/dL
      case MetricType.TEMPERATURE:
        return this.value >= 35 && this.value <= 42; // Celsius
      case MetricType.OXYGEN_SATURATION:
        return this.value >= 70 && this.value <= 100; // Percentage
      case MetricType.WEIGHT:
        return this.value >= 1 && this.value <= 500; // kg
      case MetricType.STEPS:
        return this.value >= 0 && this.value <= 100000;
      case MetricType.SLEEP_DURATION:
        return this.value >= 0 && this.value <= 24; // hours
      default:
        return true;
    }
  }

  markAsValid(): void {
    this.validationStatus = ValidationStatus.VALIDATED;
  }

  markAsSuspicious(): void {
    this.validationStatus = ValidationStatus.FLAGGED;
  }

  markAsInvalid(): void {
    this.validationStatus = ValidationStatus.REJECTED;
  }

  isFromDevice(): boolean {
    return this.deviceId !== null;
  }

  isFromExternalAPI(): boolean {
    const externalSources: DataSource[] = [
      DataSource.HEALTH_KIT,
      DataSource.GOOGLE_FIT,
      DataSource.DEVICE_SYNC,
    ];
    return externalSources.includes(this.source);
  }

  getDisplayValue(): string {
    switch (this.metricType) {
      case MetricType.BLOOD_PRESSURE: {
        // Assuming diastolic is stored in metadata
        const diastolic = (this.metadata.diastolic as number) || 0;
        return `${this.value}/${diastolic} ${this.unit}`;
      }
      default:
        return `${this.value} ${this.unit}`;
    }
  }

  isRecent(hoursThreshold: number = 24): boolean {
    const now = new Date();
    const diffInHours =
      (now.getTime() - this.timestamp.getTime()) / (1000 * 60 * 60);
    return diffInHours <= hoursThreshold;
  }

  isSameDay(date: Date): boolean {
    return (
      this.timestamp.getFullYear() === date.getFullYear() &&
      this.timestamp.getMonth() === date.getMonth() &&
      this.timestamp.getDate() === date.getDate()
    );
  }
}
