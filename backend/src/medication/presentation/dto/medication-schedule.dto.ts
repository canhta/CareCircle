import {
  IsString,
  IsOptional,
  IsBoolean,
  IsDateString,
  IsArray,
  IsNumber,
  IsObject,
  IsEnum,
  Min,
  Max,
} from 'class-validator';
import { Transform, Type } from 'class-transformer';

export class TimeDto {
  @IsNumber()
  @Min(0)
  @Max(23)
  hour: number;

  @IsNumber()
  @Min(0)
  @Max(59)
  minute: number;
}

export class DosageScheduleDto {
  @IsEnum(['daily', 'weekly', 'monthly', 'as_needed'])
  frequency: 'daily' | 'weekly' | 'monthly' | 'as_needed';

  @IsNumber()
  @Min(1)
  times: number;

  @IsOptional()
  @IsArray()
  @IsNumber({}, { each: true })
  @Min(0, { each: true })
  @Max(6, { each: true })
  daysOfWeek?: number[];

  @IsOptional()
  @IsArray()
  @IsNumber({}, { each: true })
  @Min(1, { each: true })
  @Max(31, { each: true })
  daysOfMonth?: number[];

  @IsOptional()
  @IsArray()
  @Type(() => TimeDto)
  specificTimes?: TimeDto[];

  @IsOptional()
  @IsString()
  asNeededInstructions?: string;

  @IsOptional()
  @IsEnum(['before_meal', 'with_meal', 'after_meal', 'independent'])
  mealRelation?: 'before_meal' | 'with_meal' | 'after_meal' | 'independent';
}

export class ReminderSettingsDto {
  @IsNumber()
  @Min(0)
  advanceMinutes: number;

  @IsNumber()
  @Min(0)
  repeatMinutes: number;

  @IsNumber()
  @Min(1)
  maxReminders: number;

  @IsBoolean()
  soundEnabled: boolean;

  @IsBoolean()
  vibrationEnabled: boolean;

  @IsEnum(['low', 'medium', 'high'])
  criticalityLevel: 'low' | 'medium' | 'high';
}

export class CreateScheduleDto {
  @IsString()
  medicationId: string;

  @IsString()
  instructions: string;

  @IsOptional()
  @IsBoolean()
  remindersEnabled?: boolean;

  @IsDateString()
  startDate: string;

  @IsOptional()
  @IsDateString()
  endDate?: string;

  @IsObject()
  @Type(() => DosageScheduleDto)
  schedule: DosageScheduleDto;

  @IsOptional()
  @IsArray()
  @Type(() => TimeDto)
  reminderTimes?: TimeDto[];

  @IsOptional()
  @IsObject()
  @Type(() => ReminderSettingsDto)
  reminderSettings?: ReminderSettingsDto;
}

export class UpdateScheduleDto {
  @IsOptional()
  @IsString()
  instructions?: string;

  @IsOptional()
  @IsBoolean()
  remindersEnabled?: boolean;

  @IsOptional()
  @IsDateString()
  endDate?: string;

  @IsOptional()
  @IsObject()
  @Type(() => DosageScheduleDto)
  schedule?: DosageScheduleDto;

  @IsOptional()
  @IsArray()
  @Type(() => TimeDto)
  reminderTimes?: TimeDto[];

  @IsOptional()
  @IsObject()
  @Type(() => ReminderSettingsDto)
  reminderSettings?: ReminderSettingsDto;
}

export class ScheduleQueryDto {
  @IsOptional()
  @IsString()
  medicationId?: string;

  @IsOptional()
  @Transform(({ value }) => value === 'true')
  @IsBoolean()
  isActive?: boolean;

  @IsOptional()
  @Transform(({ value }) => value === 'true')
  @IsBoolean()
  remindersEnabled?: boolean;

  @IsOptional()
  @IsEnum(['daily', 'weekly', 'monthly', 'as_needed'])
  frequency?: 'daily' | 'weekly' | 'monthly' | 'as_needed';

  @IsOptional()
  @IsDateString()
  startDate?: string;

  @IsOptional()
  @IsDateString()
  endDate?: string;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  limit?: number;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  offset?: number;
}

export class AddReminderTimeDto extends TimeDto {}
