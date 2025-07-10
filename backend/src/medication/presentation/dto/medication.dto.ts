import {
  IsString,
  IsOptional,
  IsBoolean,
  IsDateString,
  IsEnum,
  IsNumber,
  Min,
} from 'class-validator';
import { Transform, Type } from 'class-transformer';
import { MedicationForm } from '@prisma/client';

export class CreateMedicationDto {
  @IsString()
  name: string;

  @IsOptional()
  @IsString()
  genericName?: string;

  @IsString()
  strength: string;

  @IsEnum(MedicationForm)
  form: MedicationForm;

  @IsOptional()
  @IsString()
  manufacturer?: string;

  @IsOptional()
  @IsString()
  rxNormCode?: string;

  @IsOptional()
  @IsString()
  ndcCode?: string;

  @IsOptional()
  @IsString()
  classification?: string;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;

  @IsDateString()
  startDate: string;

  @IsOptional()
  @IsDateString()
  endDate?: string;

  @IsOptional()
  @IsString()
  prescriptionId?: string;

  @IsOptional()
  @IsString()
  notes?: string;
}

export class UpdateMedicationDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  genericName?: string;

  @IsOptional()
  @IsString()
  strength?: string;

  @IsOptional()
  @IsEnum(MedicationForm)
  form?: MedicationForm;

  @IsOptional()
  @IsString()
  manufacturer?: string;

  @IsOptional()
  @IsString()
  rxNormCode?: string;

  @IsOptional()
  @IsString()
  ndcCode?: string;

  @IsOptional()
  @IsString()
  classification?: string;

  @IsOptional()
  @IsDateString()
  endDate?: string;

  @IsOptional()
  @IsString()
  notes?: string;
}

export class MedicationQueryDto {
  @IsOptional()
  @Transform(({ value }) => value === 'true')
  @IsBoolean()
  isActive?: boolean;

  @IsOptional()
  @IsEnum(MedicationForm)
  form?: MedicationForm;

  @IsOptional()
  @IsString()
  prescriptionId?: string;

  @IsOptional()
  @IsDateString()
  startDate?: string;

  @IsOptional()
  @IsDateString()
  endDate?: string;

  @IsOptional()
  @IsString()
  searchTerm?: string;

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
