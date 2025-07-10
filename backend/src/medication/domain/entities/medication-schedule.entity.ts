export interface Time {
  hour: number; // 0-23
  minute: number; // 0-59
}

export interface DosageSchedule {
  frequency: 'daily' | 'weekly' | 'monthly' | 'as_needed';
  times: number; // Number of times per frequency period
  daysOfWeek?: number[]; // 0-6, 0 is Sunday
  daysOfMonth?: number[]; // 1-31
  specificTimes?: Time[];
  asNeededInstructions?: string;
  mealRelation?: 'before_meal' | 'with_meal' | 'after_meal' | 'independent';
}

export interface ReminderSettings {
  advanceMinutes: number; // Minutes before scheduled time to remind
  repeatMinutes: number; // Minutes between repeat reminders
  maxReminders: number; // Maximum number of reminders
  soundEnabled: boolean;
  vibrationEnabled: boolean;
  criticalityLevel: 'low' | 'medium' | 'high';
}

export class MedicationSchedule {
  constructor(
    public readonly id: string,
    public readonly medicationId: string,
    public readonly userId: string,
    public instructions: string,
    public remindersEnabled: boolean,
    public readonly startDate: Date,
    public endDate: Date | null,
    public schedule: DosageSchedule,
    public reminderTimes: Time[],
    public reminderSettings: ReminderSettings,
    public readonly createdAt: Date,
    public readonly updatedAt: Date,
  ) {}

  static create(data: {
    id: string;
    medicationId: string;
    userId: string;
    instructions: string;
    remindersEnabled?: boolean;
    startDate: Date;
    endDate?: Date;
    schedule: DosageSchedule;
    reminderTimes?: Time[];
    reminderSettings?: Partial<ReminderSettings>;
  }): MedicationSchedule {
    const defaultReminderSettings: ReminderSettings = {
      advanceMinutes: 15,
      repeatMinutes: 15,
      maxReminders: 3,
      soundEnabled: true,
      vibrationEnabled: true,
      criticalityLevel: 'medium',
    };

    return new MedicationSchedule(
      data.id,
      data.medicationId,
      data.userId,
      data.instructions,
      data.remindersEnabled ?? true,
      data.startDate,
      data.endDate || null,
      data.schedule,
      data.reminderTimes || [],
      { ...defaultReminderSettings, ...data.reminderSettings },
      new Date(),
      new Date(),
    );
  }

  validate(): boolean {
    // Basic validation rules
    if (!this.medicationId || this.medicationId.trim().length === 0) return false;
    if (!this.userId || this.userId.trim().length === 0) return false;
    if (!this.instructions || this.instructions.trim().length === 0) return false;
    
    // Validate dates
    const now = new Date();
    if (this.startDate > new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000)) return false; // Not more than 30 days in future
    if (this.endDate && this.endDate <= this.startDate) return false;
    
    // Validate schedule
    if (!this.schedule.frequency) return false;
    if (this.schedule.times <= 0) return false;
    
    // Validate frequency-specific rules
    switch (this.schedule.frequency) {
      case 'weekly':
        if (this.schedule.daysOfWeek && this.schedule.daysOfWeek.some(day => day < 0 || day > 6)) return false;
        break;
      case 'monthly':
        if (this.schedule.daysOfMonth && this.schedule.daysOfMonth.some(day => day < 1 || day > 31)) return false;
        break;
    }
    
    // Validate specific times
    if (this.schedule.specificTimes) {
      for (const time of this.schedule.specificTimes) {
        if (time.hour < 0 || time.hour > 23) return false;
        if (time.minute < 0 || time.minute > 59) return false;
      }
    }
    
    // Validate reminder times
    for (const time of this.reminderTimes) {
      if (time.hour < 0 || time.hour > 23) return false;
      if (time.minute < 0 || time.minute > 59) return false;
    }
    
    // Validate reminder settings
    if (this.reminderSettings.advanceMinutes < 0) return false;
    if (this.reminderSettings.repeatMinutes < 0) return false;
    if (this.reminderSettings.maxReminders < 0) return false;
    
    return true;
  }

  updateInstructions(instructions: string): void {
    if (!instructions || instructions.trim().length === 0) {
      throw new Error('Instructions cannot be empty');
    }
    this.instructions = instructions;
  }

  updateSchedule(schedule: DosageSchedule): void {
    // Validate the new schedule
    const tempSchedule = new MedicationSchedule(
      this.id,
      this.medicationId,
      this.userId,
      this.instructions,
      this.remindersEnabled,
      this.startDate,
      this.endDate,
      schedule,
      this.reminderTimes,
      this.reminderSettings,
      this.createdAt,
      this.updatedAt,
    );
    
    if (!tempSchedule.validate()) {
      throw new Error('Invalid schedule configuration');
    }
    
    this.schedule = schedule;
  }

  setEndDate(endDate: Date): void {
    if (endDate <= this.startDate) {
      throw new Error('End date must be after start date');
    }
    this.endDate = endDate;
  }

  enableReminders(): void {
    this.remindersEnabled = true;
  }

  disableReminders(): void {
    this.remindersEnabled = false;
  }

  updateReminderSettings(settings: Partial<ReminderSettings>): void {
    this.reminderSettings = { ...this.reminderSettings, ...settings };
  }

  addReminderTime(time: Time): void {
    if (time.hour < 0 || time.hour > 23 || time.minute < 0 || time.minute > 59) {
      throw new Error('Invalid time format');
    }
    
    // Check if time already exists
    const exists = this.reminderTimes.some(t => t.hour === time.hour && t.minute === time.minute);
    if (!exists) {
      this.reminderTimes.push(time);
      this.reminderTimes.sort((a, b) => a.hour * 60 + a.minute - (b.hour * 60 + b.minute));
    }
  }

  removeReminderTime(time: Time): void {
    this.reminderTimes = this.reminderTimes.filter(
      t => !(t.hour === time.hour && t.minute === time.minute)
    );
  }

  isCurrentlyActive(): boolean {
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

  getNextScheduledTime(): Date | null {
    if (!this.isCurrentlyActive()) return null;
    
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    
    // For daily schedules with specific times
    if (this.schedule.frequency === 'daily' && this.schedule.specificTimes) {
      for (const time of this.schedule.specificTimes) {
        const scheduledTime = new Date(today);
        scheduledTime.setHours(time.hour, time.minute, 0, 0);
        
        if (scheduledTime > now) {
          return scheduledTime;
        }
      }
      
      // If no time today, get first time tomorrow
      if (this.schedule.specificTimes.length > 0) {
        const tomorrow = new Date(today);
        tomorrow.setDate(tomorrow.getDate() + 1);
        const firstTime = this.schedule.specificTimes[0];
        tomorrow.setHours(firstTime.hour, firstTime.minute, 0, 0);
        return tomorrow;
      }
    }
    
    // For as-needed schedules, no specific next time
    if (this.schedule.frequency === 'as_needed') {
      return null;
    }
    
    // For other frequencies, would need more complex logic
    return null;
  }

  shouldRemindNow(): boolean {
    if (!this.remindersEnabled || !this.isCurrentlyActive()) return false;
    
    const nextScheduledTime = this.getNextScheduledTime();
    if (!nextScheduledTime) return false;
    
    const now = new Date();
    const timeDiffMinutes = (nextScheduledTime.getTime() - now.getTime()) / (1000 * 60);
    
    return timeDiffMinutes <= this.reminderSettings.advanceMinutes && timeDiffMinutes > 0;
  }

  getFrequencyDescription(): string {
    switch (this.schedule.frequency) {
      case 'daily':
        return `${this.schedule.times} time${this.schedule.times > 1 ? 's' : ''} daily`;
      case 'weekly':
        return `${this.schedule.times} time${this.schedule.times > 1 ? 's' : ''} weekly`;
      case 'monthly':
        return `${this.schedule.times} time${this.schedule.times > 1 ? 's' : ''} monthly`;
      case 'as_needed':
        return 'As needed';
      default:
        return 'Unknown frequency';
    }
  }

  toJSON(): Record<string, any> {
    return {
      id: this.id,
      medicationId: this.medicationId,
      userId: this.userId,
      instructions: this.instructions,
      remindersEnabled: this.remindersEnabled,
      startDate: this.startDate.toISOString(),
      endDate: this.endDate?.toISOString() || null,
      schedule: this.schedule,
      reminderTimes: this.reminderTimes,
      reminderSettings: this.reminderSettings,
      createdAt: this.createdAt.toISOString(),
      updatedAt: this.updatedAt.toISOString(),
    };
  }
}
