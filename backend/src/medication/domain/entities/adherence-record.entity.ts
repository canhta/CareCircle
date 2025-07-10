import { DoseStatus } from '@prisma/client';

export class AdherenceRecord {
  constructor(
    public readonly id: string,
    public readonly medicationId: string,
    public readonly scheduleId: string,
    public readonly userId: string,
    public readonly scheduledTime: Date,
    public readonly dosage: number,
    public readonly unit: string,
    public status: DoseStatus,
    public takenAt: Date | null,
    public skippedReason: string | null,
    public notes: string | null,
    public reminderId: string | null,
    public readonly createdAt: Date,
  ) {}

  static create(data: {
    id: string;
    medicationId: string;
    scheduleId: string;
    userId: string;
    scheduledTime: Date;
    dosage: number;
    unit: string;
    status?: DoseStatus;
    takenAt?: Date;
    skippedReason?: string;
    notes?: string;
    reminderId?: string;
  }): AdherenceRecord {
    return new AdherenceRecord(
      data.id,
      data.medicationId,
      data.scheduleId,
      data.userId,
      data.scheduledTime,
      data.dosage,
      data.unit,
      data.status || DoseStatus.SCHEDULED,
      data.takenAt || null,
      data.skippedReason || null,
      data.notes || null,
      data.reminderId || null,
      new Date(),
    );
  }

  validate(): boolean {
    // Basic validation rules
    if (!this.medicationId || this.medicationId.trim().length === 0)
      return false;
    if (!this.scheduleId || this.scheduleId.trim().length === 0) return false;
    if (!this.userId || this.userId.trim().length === 0) return false;
    if (!this.unit || this.unit.trim().length === 0) return false;

    // Validate dosage
    if (this.dosage <= 0) return false;

    // Validate scheduled time is not too far in the future
    const now = new Date();
    const maxFutureTime = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000); // 7 days
    if (this.scheduledTime > maxFutureTime) return false;

    // Validate status-specific rules
    switch (this.status) {
      case DoseStatus.TAKEN:
        if (!this.takenAt) return false;
        // Taken time should not be before scheduled time by more than 2 hours
        const minTakenTime = new Date(
          this.scheduledTime.getTime() - 2 * 60 * 60 * 1000,
        );
        if (this.takenAt < minTakenTime) return false;
        break;
      case DoseStatus.SKIPPED:
        if (!this.skippedReason || this.skippedReason.trim().length === 0)
          return false;
        break;
      case DoseStatus.MISSED:
        // Missed doses should be past their scheduled time
        if (this.scheduledTime > now) return false;
        break;
    }

    return true;
  }

  markAsTaken(takenAt?: Date, notes?: string): void {
    this.status = DoseStatus.TAKEN;
    this.takenAt = takenAt || new Date();
    this.skippedReason = null; // Clear any previous skip reason
    if (notes) {
      this.notes = notes;
    }
  }

  markAsSkipped(reason: string, notes?: string): void {
    if (!reason || reason.trim().length === 0) {
      throw new Error('Skip reason is required');
    }

    this.status = DoseStatus.SKIPPED;
    this.skippedReason = reason;
    this.takenAt = null; // Clear any previous taken time
    if (notes) {
      this.notes = notes;
    }
  }

  markAsMissed(notes?: string): void {
    this.status = DoseStatus.MISSED;
    this.takenAt = null;
    this.skippedReason = null;
    if (notes) {
      this.notes = notes;
    }
  }

  reschedule(newScheduledTime: Date, notes?: string): void {
    if (newScheduledTime <= new Date()) {
      throw new Error('Rescheduled time must be in the future');
    }

    this.status = DoseStatus.SCHEDULED;
    // Note: In a real implementation, you might want to create a new record
    // and mark this one as rescheduled, but for simplicity we'll update this one
    if (notes) {
      this.notes = notes;
    }
  }

  updateNotes(notes: string): void {
    this.notes = notes;
  }

  setReminderId(reminderId: string): void {
    this.reminderId = reminderId;
  }

  isOverdue(): boolean {
    if (this.status !== DoseStatus.SCHEDULED) return false;

    const now = new Date();
    const overdueThreshold = new Date(
      this.scheduledTime.getTime() + 2 * 60 * 60 * 1000,
    ); // 2 hours after scheduled
    return now > overdueThreshold;
  }

  isDue(): boolean {
    if (this.status !== DoseStatus.SCHEDULED) return false;

    const now = new Date();
    const dueThreshold = new Date(
      this.scheduledTime.getTime() - 15 * 60 * 1000,
    ); // 15 minutes before scheduled
    return now >= dueThreshold && now <= this.scheduledTime;
  }

  isUpcoming(): boolean {
    if (this.status !== DoseStatus.SCHEDULED) return false;

    const now = new Date();
    const upcomingThreshold = new Date(now.getTime() + 60 * 60 * 1000); // Next 1 hour
    return this.scheduledTime > now && this.scheduledTime <= upcomingThreshold;
  }

  wasCompleted(): boolean {
    return this.status === DoseStatus.TAKEN;
  }

  wasSkipped(): boolean {
    return this.status === DoseStatus.SKIPPED;
  }

  wasMissed(): boolean {
    return this.status === DoseStatus.MISSED;
  }

  isScheduled(): boolean {
    return this.status === DoseStatus.SCHEDULED;
  }

  wasRescheduled(): boolean {
    // Since RESCHEDULED status doesn't exist in Prisma schema,
    // we'll check if notes contain rescheduling information
    return this.notes?.includes('rescheduled') || false;
  }

  getTimeSinceScheduled(): number {
    const now = new Date();
    return now.getTime() - this.scheduledTime.getTime(); // milliseconds
  }

  getTimeSinceScheduledInMinutes(): number {
    return Math.floor(this.getTimeSinceScheduled() / (1000 * 60));
  }

  getTimeSinceScheduledInHours(): number {
    return Math.floor(this.getTimeSinceScheduled() / (1000 * 60 * 60));
  }

  getAdherenceScore(): number {
    // Simple adherence scoring: 1.0 for taken, 0.5 for skipped with valid reason, 0.0 for missed
    switch (this.status) {
      case DoseStatus.TAKEN:
        // Bonus points for taking on time
        if (this.takenAt) {
          const timeDiff = Math.abs(
            this.takenAt.getTime() - this.scheduledTime.getTime(),
          );
          const hoursDiff = timeDiff / (1000 * 60 * 60);
          if (hoursDiff <= 0.5) return 1.0; // Perfect adherence
          if (hoursDiff <= 2) return 0.9; // Good adherence
          return 0.7; // Acceptable adherence
        }
        return 1.0;
      case DoseStatus.SKIPPED:
        return this.skippedReason ? 0.5 : 0.2; // Better score if reason provided
      case DoseStatus.MISSED:
        return 0.0;
      // RESCHEDULED status doesn't exist in Prisma schema, handled via notes
      case DoseStatus.SCHEDULED:
        return this.isOverdue() ? 0.0 : 1.0; // Pending doses get full credit unless overdue
      default:
        return 0.0;
    }
  }

  getStatusDescription(): string {
    switch (this.status) {
      case DoseStatus.TAKEN:
        return this.takenAt
          ? `Taken at ${this.takenAt.toLocaleTimeString()}`
          : 'Taken';
      case DoseStatus.SKIPPED:
        return this.skippedReason
          ? `Skipped: ${this.skippedReason}`
          : 'Skipped';
      case DoseStatus.MISSED:
        return 'Missed';
      // RESCHEDULED status doesn't exist in Prisma schema
      case DoseStatus.SCHEDULED:
        if (this.isOverdue()) return 'Overdue';
        if (this.isDue()) return 'Due now';
        if (this.isUpcoming()) return 'Upcoming';
        return 'Scheduled';
      default:
        return 'Unknown';
    }
  }

  getDosageDescription(): string {
    return `${this.dosage} ${this.unit}`;
  }

  toJSON(): Record<string, any> {
    return {
      id: this.id,
      medicationId: this.medicationId,
      scheduleId: this.scheduleId,
      userId: this.userId,
      scheduledTime: this.scheduledTime.toISOString(),
      dosage: this.dosage,
      unit: this.unit,
      status: this.status,
      takenAt: this.takenAt?.toISOString() || null,
      skippedReason: this.skippedReason,
      notes: this.notes,
      reminderId: this.reminderId,
      createdAt: this.createdAt.toISOString(),
    };
  }
}
