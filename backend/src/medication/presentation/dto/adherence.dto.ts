import { IsString, IsOptional, IsDateString, IsNumber, IsEnum, Min } from 'class-validator';
import { Transform, Type } from 'class-transformer';
import { DoseStatus } from '@prisma/client';

export class CreateAdherenceRecordDto {
  @IsString()
  medicationId: string;

  @IsString()
  scheduleId: string;

  @IsDateString()
  scheduledTime: string;

  @IsNumber()
  @Min(0)
  dosage: number;

  @IsString()
  unit: string;

  @IsOptional()
  @IsEnum(DoseStatus)
  status?: DoseStatus;

  @IsOptional()
  @IsDateString()
  takenAt?: string;

  @IsOptional()
  @IsString()
  skippedReason?: string;

  @IsOptional()
  @IsString()
  notes?: string;

  @IsOptional()
  @IsString()
  reminderId?: string;
}

export class UpdateAdherenceRecordDto {
  @IsOptional()
  @IsEnum(DoseStatus)
  status?: DoseStatus;

  @IsOptional()
  @IsDateString()
  takenAt?: string;

  @IsOptional()
  @IsString()
  skippedReason?: string;

  @IsOptional()
  @IsString()
  notes?: string;

  @IsOptional()
  @IsString()
  reminderId?: string;
}

export class AdherenceQueryDto {
  @IsOptional()
  @IsString()
  medicationId?: string;

  @IsOptional()
  @IsString()
  scheduleId?: string;

  @IsOptional()
  @IsEnum(DoseStatus)
  status?: DoseStatus;

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

export class MarkDoseDto {
  @IsOptional()
  @IsDateString()
  takenAt?: string;

  @IsOptional()
  @IsString()
  notes?: string;
}
