import { Injectable, Inject } from '@nestjs/common';
import { MedicationSchedule, DosageSchedule, Time, ReminderSettings } from '../../domain/entities/medication-schedule.entity';
import {
  MedicationScheduleRepository,
  ScheduleQuery,
  ScheduleStatistics,
} from '../../domain/repositories/medication-schedule.repository';

@Injectable()
export class MedicationScheduleService {
  constructor(
    @Inject('MedicationScheduleRepository')
    private readonly scheduleRepository: MedicationScheduleRepository,
  ) {}

  async createSchedule(data: {
    medicationId: string;
    userId: string;
    instructions: string;
    remindersEnabled?: boolean;
    startDate: Date;
    endDate?: Date;
    schedule: DosageSchedule;
    reminderTimes?: Time[];
    reminderSettings?: Partial<ReminderSettings>;
  }): Promise<MedicationSchedule> {
    const schedule = MedicationSchedule.create({
      id: this.generateId(),
      ...data,
    });

    // Validate the schedule
    if (!schedule.validate()) {
      throw new Error('Invalid medication schedule data');
    }

    return this.scheduleRepository.create(schedule);
  }

  async createSchedules(
    schedules: Array<{
      medicationId: string;
      userId: string;
      instructions: string;
      remindersEnabled?: boolean;
      startDate: Date;
      endDate?: Date;
      schedule: DosageSchedule;
      reminderTimes?: Time[];
      reminderSettings?: Partial<ReminderSettings>;
    }>,
  ): Promise<MedicationSchedule[]> {
    const scheduleEntities = schedules.map((data) => {
      const schedule = MedicationSchedule.create({
        id: this.generateId(),
        ...data,
      });

      if (!schedule.validate()) {
        throw new Error(`Invalid schedule data for medication ${data.medicationId}`);
      }

      return schedule;
    });

    return this.scheduleRepository.createMany(scheduleEntities);
  }

  async getSchedule(id: string): Promise<MedicationSchedule | null> {
    return this.scheduleRepository.findById(id);
  }

  async updateSchedule(
    id: string,
    updates: {
      instructions?: string;
      remindersEnabled?: boolean;
      endDate?: Date;
      schedule?: DosageSchedule;
      reminderTimes?: Time[];
      reminderSettings?: Partial<ReminderSettings>;
    },
  ): Promise<MedicationSchedule> {
    const existingSchedule = await this.scheduleRepository.findById(id);
    if (!existingSchedule) {
      throw new Error('Medication schedule not found');
    }

    // Update reminder settings if provided
    if (updates.reminderSettings) {
      existingSchedule.updateReminderSettings(updates.reminderSettings);
      updates.reminderSettings = existingSchedule.reminderSettings;
    }

    // Update schedule if provided
    if (updates.schedule) {
      existingSchedule.updateSchedule(updates.schedule);
    }

    // Update instructions if provided
    if (updates.instructions) {
      existingSchedule.updateInstructions(updates.instructions);
    }

    return this.scheduleRepository.update(id, updates);
  }

  async deleteSchedule(id: string): Promise<void> {
    const schedule = await this.scheduleRepository.findById(id);
    if (!schedule) {
      throw new Error('Medication schedule not found');
    }

    await this.scheduleRepository.delete(id);
  }

  async endSchedule(id: string, endDate: Date): Promise<MedicationSchedule> {
    const schedule = await this.scheduleRepository.findById(id);
    if (!schedule) {
      throw new Error('Medication schedule not found');
    }

    schedule.setEndDate(endDate);
    return this.scheduleRepository.update(id, {
      endDate: schedule.endDate,
    });
  }

  async enableReminders(id: string): Promise<MedicationSchedule> {
    const schedule = await this.scheduleRepository.findById(id);
    if (!schedule) {
      throw new Error('Medication schedule not found');
    }

    schedule.enableReminders();
    return this.scheduleRepository.update(id, {
      remindersEnabled: schedule.remindersEnabled,
    });
  }

  async disableReminders(id: string): Promise<MedicationSchedule> {
    const schedule = await this.scheduleRepository.findById(id);
    if (!schedule) {
      throw new Error('Medication schedule not found');
    }

    schedule.disableReminders();
    return this.scheduleRepository.update(id, {
      remindersEnabled: schedule.remindersEnabled,
    });
  }

  async addReminderTime(id: string, time: Time): Promise<MedicationSchedule> {
    const schedule = await this.scheduleRepository.findById(id);
    if (!schedule) {
      throw new Error('Medication schedule not found');
    }

    schedule.addReminderTime(time);
    return this.scheduleRepository.update(id, {
      reminderTimes: schedule.reminderTimes,
    });
  }

  async removeReminderTime(id: string, time: Time): Promise<MedicationSchedule> {
    const schedule = await this.scheduleRepository.findById(id);
    if (!schedule) {
      throw new Error('Medication schedule not found');
    }

    schedule.removeReminderTime(time);
    return this.scheduleRepository.update(id, {
      reminderTimes: schedule.reminderTimes,
    });
  }

  async getUserSchedules(
    userId: string,
    includeInactive?: boolean,
  ): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findByUserId(userId, includeInactive);
  }

  async getActiveSchedules(userId: string): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findActiveByUserId(userId);
  }

  async getInactiveSchedules(userId: string): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findInactiveByUserId(userId);
  }

  async getMedicationSchedules(medicationId: string): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findByMedicationId(medicationId);
  }

  async getActiveMedicationSchedules(medicationId: string): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findActiveMedicationSchedules(medicationId);
  }

  async searchSchedules(query: ScheduleQuery): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findMany(query);
  }

  async getSchedulesWithReminders(userId: string): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findWithRemindersEnabled(userId);
  }

  async getSchedulesWithoutReminders(userId: string): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findWithRemindersDisabled(userId);
  }

  async getSchedulesNeedingReminders(
    userId: string,
    withinMinutes: number,
  ): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findSchedulesNeedingReminders(userId, withinMinutes);
  }

  async getSchedulesForDate(
    userId: string,
    date: Date,
  ): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findSchedulesForDate(userId, date);
  }

  async getSchedulesForDateRange(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findSchedulesForDateRange(userId, startDate, endDate);
  }

  async getUpcomingSchedules(
    userId: string,
    withinHours: number,
  ): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findUpcomingSchedules(userId, withinHours);
  }

  async getSchedulesByFrequency(
    userId: string,
    frequency: 'daily' | 'weekly' | 'monthly' | 'as_needed',
  ): Promise<MedicationSchedule[]> {
    switch (frequency) {
      case 'daily':
        return this.scheduleRepository.findDailySchedules(userId);
      case 'weekly':
        return this.scheduleRepository.findWeeklySchedules(userId);
      case 'monthly':
        return this.scheduleRepository.findMonthlySchedules(userId);
      case 'as_needed':
        return this.scheduleRepository.findAsNeededSchedules(userId);
      default:
        throw new Error('Invalid frequency type');
    }
  }

  async getExpiredSchedules(userId: string): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findExpiredSchedules(userId);
  }

  async getExpiringSchedules(
    userId: string,
    withinDays: number,
  ): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findExpiringSchedules(userId, withinDays);
  }

  async getScheduleStatistics(userId: string): Promise<ScheduleStatistics> {
    return this.scheduleRepository.getScheduleStatistics(userId);
  }

  async getScheduleCount(
    userId: string,
    isActive?: boolean,
  ): Promise<number> {
    return this.scheduleRepository.getScheduleCount(userId, isActive);
  }

  async findConflictingSchedules(
    userId: string,
    newSchedule: MedicationSchedule,
  ): Promise<MedicationSchedule[]> {
    return this.scheduleRepository.findConflictingSchedules(userId, newSchedule);
  }

  async validateScheduleData(schedule: MedicationSchedule): Promise<{
    isValid: boolean;
    errors: string[];
    warnings: string[];
  }> {
    const errors: string[] = [];
    const warnings: string[] = [];

    // Basic validation
    if (!schedule.validate()) {
      errors.push('Basic schedule validation failed');
    }

    // Check if schedule is expired
    if (schedule.isExpired()) {
      warnings.push('Schedule is expired');
    }

    // Check for conflicting schedules
    const conflicts = await this.findConflictingSchedules(schedule.userId, schedule);
    if (conflicts.length > 0) {
      warnings.push(`Found ${conflicts.length} potentially conflicting schedule(s)`);
    }

    // Check reminder configuration
    if (schedule.remindersEnabled && schedule.reminderTimes.length === 0) {
      warnings.push('Reminders enabled but no reminder times configured');
    }

    return {
      isValid: errors.length === 0,
      errors,
      warnings,
    };
  }

  private generateId(): string {
    return `sched_${Date.now()}_${Math.random().toString(36).substring(2, 11)}`;
  }
}
