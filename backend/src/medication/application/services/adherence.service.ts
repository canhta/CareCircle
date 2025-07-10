import { Injectable, Inject } from '@nestjs/common';
import { AdherenceRecord } from '../../domain/entities/adherence-record.entity';
import { DoseStatus } from '@prisma/client';
import {
  AdherenceRecordRepository,
  AdherenceQuery,
  AdherenceStatistics,
  AdherenceTrend,
} from '../../domain/repositories/adherence-record.repository';

@Injectable()
export class AdherenceService {
  constructor(
    @Inject('AdherenceRecordRepository')
    private readonly adherenceRepository: AdherenceRecordRepository,
  ) {}

  async createAdherenceRecord(data: {
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
  }): Promise<AdherenceRecord> {
    const record = AdherenceRecord.create({
      id: this.generateId(),
      ...data,
    });

    // Validate the record
    if (!record.validate()) {
      throw new Error('Invalid adherence record data');
    }

    return this.adherenceRepository.create(record);
  }

  async createAdherenceRecords(
    records: Array<{
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
    }>,
  ): Promise<AdherenceRecord[]> {
    const recordEntities = records.map((data) => {
      const record = AdherenceRecord.create({
        id: this.generateId(),
        ...data,
      });

      if (!record.validate()) {
        throw new Error(
          `Invalid adherence record data for medication ${data.medicationId}`,
        );
      }

      return record;
    });

    return this.adherenceRepository.createMany(recordEntities);
  }

  async getAdherenceRecord(id: string): Promise<AdherenceRecord | null> {
    return this.adherenceRepository.findById(id);
  }

  async updateAdherenceRecord(
    id: string,
    updates: {
      status?: DoseStatus;
      takenAt?: Date;
      skippedReason?: string;
      notes?: string;
      reminderId?: string;
    },
  ): Promise<AdherenceRecord> {
    const existingRecord = await this.adherenceRepository.findById(id);
    if (!existingRecord) {
      throw new Error('Adherence record not found');
    }

    return this.adherenceRepository.update(id, updates);
  }

  async deleteAdherenceRecord(id: string): Promise<void> {
    const record = await this.adherenceRepository.findById(id);
    if (!record) {
      throw new Error('Adherence record not found');
    }

    await this.adherenceRepository.delete(id);
  }

  async markDoseAsTaken(
    id: string,
    takenAt?: Date,
    notes?: string,
  ): Promise<AdherenceRecord> {
    const record = await this.adherenceRepository.findById(id);
    if (!record) {
      throw new Error('Adherence record not found');
    }

    record.markAsTaken(takenAt, notes);
    return this.adherenceRepository.update(id, {
      status: record.status,
      takenAt: record.takenAt,
      skippedReason: record.skippedReason,
      notes: record.notes,
    });
  }

  async markDoseAsSkipped(
    id: string,
    reason: string,
    notes?: string,
  ): Promise<AdherenceRecord> {
    const record = await this.adherenceRepository.findById(id);
    if (!record) {
      throw new Error('Adherence record not found');
    }

    record.markAsSkipped(reason, notes);
    return this.adherenceRepository.update(id, {
      status: record.status,
      takenAt: record.takenAt,
      skippedReason: record.skippedReason,
      notes: record.notes,
    });
  }

  async markDoseAsMissed(id: string, notes?: string): Promise<AdherenceRecord> {
    const record = await this.adherenceRepository.findById(id);
    if (!record) {
      throw new Error('Adherence record not found');
    }

    record.markAsMissed(notes);
    return this.adherenceRepository.update(id, {
      status: record.status,
      takenAt: record.takenAt,
      skippedReason: record.skippedReason,
      notes: record.notes,
    });
  }

  async rescheduleDose(
    id: string,
    newScheduledTime: Date,
    notes?: string,
  ): Promise<AdherenceRecord> {
    const record = await this.adherenceRepository.findById(id);
    if (!record) {
      throw new Error('Adherence record not found');
    }

    record.reschedule(newScheduledTime, notes);
    return this.adherenceRepository.update(id, {
      status: record.status,
      notes: record.notes,
    });
  }

  async getUserAdherenceRecords(userId: string): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findByUserId(userId);
  }

  async getUserAdherenceByDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findByUserIdAndDateRange(
      userId,
      startDate,
      endDate,
    );
  }

  async getMedicationAdherence(
    medicationId: string,
  ): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findByMedicationId(medicationId);
  }

  async getScheduleAdherence(scheduleId: string): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findByScheduleId(scheduleId);
  }

  async searchAdherenceRecords(
    query: AdherenceQuery,
  ): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findMany(query);
  }

  async getAdherenceByStatus(
    userId: string,
    status: DoseStatus,
  ): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findByStatus(userId, status);
  }

  async getTakenDoses(
    userId: string,
    startDate?: Date,
    endDate?: Date,
  ): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findTakenDoses(userId, startDate, endDate);
  }

  async getMissedDoses(
    userId: string,
    startDate?: Date,
    endDate?: Date,
  ): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findMissedDoses(userId, startDate, endDate);
  }

  async getSkippedDoses(
    userId: string,
    startDate?: Date,
    endDate?: Date,
  ): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findSkippedDoses(
      userId,
      startDate,
      endDate,
    );
  }

  async getScheduledDoses(userId: string): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findScheduledDoses(userId);
  }

  async getOverdueDoses(userId: string): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findOverdueDoses(userId);
  }

  async getDosesForDate(
    userId: string,
    date: Date,
  ): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findDosesForDate(userId, date);
  }

  async getUpcomingDoses(
    userId: string,
    withinHours: number,
  ): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findUpcomingDoses(userId, withinHours);
  }

  async getDueNow(userId: string): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findDueNow(userId);
  }

  async getTodaysDoses(userId: string): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findTodaysDoses(userId);
  }

  async getAdherenceStatistics(
    userId: string,
    startDate?: Date,
    endDate?: Date,
  ): Promise<AdherenceStatistics> {
    return this.adherenceRepository.getAdherenceStatistics(
      userId,
      startDate,
      endDate,
    );
  }

  async getAdherenceRate(
    userId: string,
    medicationId?: string,
    startDate?: Date,
    endDate?: Date,
  ): Promise<number> {
    return this.adherenceRepository.getAdherenceRate(
      userId,
      medicationId,
      startDate,
      endDate,
    );
  }

  async getAdherenceTrend(
    userId: string,
    days: number,
    medicationId?: string,
  ): Promise<AdherenceTrend[]> {
    return this.adherenceRepository.getAdherenceTrend(
      userId,
      days,
      medicationId,
    );
  }

  async getCurrentAdherenceStreak(
    userId: string,
    medicationId?: string,
  ): Promise<number> {
    return this.adherenceRepository.getCurrentAdherenceStreak(
      userId,
      medicationId,
    );
  }

  async getLongestAdherenceStreak(
    userId: string,
    medicationId?: string,
  ): Promise<number> {
    return this.adherenceRepository.getLongestAdherenceStreak(
      userId,
      medicationId,
    );
  }

  async getMedicationAdherenceRanking(userId: string): Promise<
    Array<{
      medicationId: string;
      adherenceRate: number;
      totalDoses: number;
      takenDoses: number;
    }>
  > {
    return this.adherenceRepository.getMedicationAdherenceRanking(userId);
  }

  async getPoorAdherenceMedications(
    userId: string,
    adherenceThreshold: number = 0.8,
  ): Promise<string[]> {
    return this.adherenceRepository.findPoorAdherenceMedications(
      userId,
      adherenceThreshold,
    );
  }

  async getRecentAdherenceActivity(
    userId: string,
    days: number,
    limit?: number,
  ): Promise<AdherenceRecord[]> {
    return this.adherenceRepository.findRecentActivity(userId, days, limit);
  }

  async processOverdueDoses(userId: string): Promise<{
    processedCount: number;
    markedAsMissed: AdherenceRecord[];
  }> {
    const overdueDoses = await this.getOverdueDoses(userId);
    const markedAsMissed: AdherenceRecord[] = [];

    for (const dose of overdueDoses) {
      if (dose.isOverdue()) {
        const updatedDose = await this.markDoseAsMissed(
          dose.id,
          'Automatically marked as missed due to being overdue',
        );
        markedAsMissed.push(updatedDose);
      }
    }

    return {
      processedCount: markedAsMissed.length,
      markedAsMissed,
    };
  }

  validateAdherenceRecord(record: AdherenceRecord): {
    isValid: boolean;
    errors: string[];
    warnings: string[];
  } {
    const errors: string[] = [];
    const warnings: string[] = [];

    // Basic validation
    if (!record.validate()) {
      errors.push('Basic adherence record validation failed');
    }

    // Check if dose is overdue
    if (record.isOverdue()) {
      warnings.push('Dose is overdue');
    }

    // Check for inconsistent status
    if (record.status === DoseStatus.TAKEN && !record.takenAt) {
      errors.push('Dose marked as taken but no taken time recorded');
    }

    if (record.status === DoseStatus.SKIPPED && !record.skippedReason) {
      errors.push('Dose marked as skipped but no reason provided');
    }

    return {
      isValid: errors.length === 0,
      errors,
      warnings,
    };
  }

  private generateId(): string {
    return `adh_${Date.now()}_${Math.random().toString(36).substring(2, 11)}`;
  }
}
