import { IsString, IsOptional, IsBoolean, IsDateString, IsArray, IsNumber, IsObject, Min } from 'class-validator';
import { Transform, Type } from 'class-transformer';

export class PrescriptionMedicationDto {
  @IsString()
  name: string;

  @IsString()
  strength: string;

  @IsString()
  form: string;

  @IsString()
  dosage: string;

  @IsNumber()
  @Min(1)
  quantity: number;

  @IsString()
  instructions: string;

  @IsOptional()
  @IsString()
  linkedMedicationId?: string;
}

export class OCRFieldsDto {
  @IsOptional()
  @IsString()
  prescribedBy?: string;

  @IsOptional()
  @IsString()
  prescribedDate?: string;

  @IsOptional()
  @IsString()
  pharmacy?: string;

  @IsOptional()
  @IsArray()
  medications?: Array<{
    name?: string;
    strength?: string;
    quantity?: string;
    instructions?: string;
    confidence: number;
  }>;
}

export class OCRProcessingMetadataDto {
  @IsString()
  ocrEngine: string;

  @IsNumber()
  processingTime: number;

  @IsNumber()
  imageQuality: number;

  @IsString()
  extractionMethod: string;
}

export class OCRDataDto {
  @IsString()
  extractedText: string;

  @IsNumber()
  @Min(0)
  confidence: number;

  @IsObject()
  fields: OCRFieldsDto;

  @IsObject()
  processingMetadata: OCRProcessingMetadataDto;
}

export class CreatePrescriptionDto {
  @IsString()
  prescribedBy: string;

  @IsDateString()
  prescribedDate: string;

  @IsOptional()
  @IsString()
  pharmacy?: string;

  @IsOptional()
  @IsObject()
  ocrData?: OCRDataDto;

  @IsOptional()
  @IsString()
  imageUrl?: string;

  @IsOptional()
  @IsBoolean()
  isVerified?: boolean;

  @IsOptional()
  @IsDateString()
  verifiedAt?: string;

  @IsOptional()
  @IsString()
  verifiedBy?: string;

  @IsOptional()
  @IsArray()
  @Type(() => PrescriptionMedicationDto)
  medications?: PrescriptionMedicationDto[];
}

export class UpdatePrescriptionDto {
  @IsOptional()
  @IsString()
  prescribedBy?: string;

  @IsOptional()
  @IsDateString()
  prescribedDate?: string;

  @IsOptional()
  @IsString()
  pharmacy?: string;

  @IsOptional()
  @IsObject()
  ocrData?: OCRDataDto;

  @IsOptional()
  @IsString()
  imageUrl?: string;

  @IsOptional()
  @IsBoolean()
  isVerified?: boolean;

  @IsOptional()
  @IsDateString()
  verifiedAt?: string;

  @IsOptional()
  @IsString()
  verifiedBy?: string;

  @IsOptional()
  @IsArray()
  @Type(() => PrescriptionMedicationDto)
  medications?: PrescriptionMedicationDto[];
}

export class PrescriptionQueryDto {
  @IsOptional()
  @IsString()
  prescribedBy?: string;

  @IsOptional()
  @IsString()
  pharmacy?: string;

  @IsOptional()
  @Transform(({ value }) => value === 'true')
  @IsBoolean()
  isVerified?: boolean;

  @IsOptional()
  @Transform(({ value }) => value === 'true')
  @IsBoolean()
  hasOCRData?: boolean;

  @IsOptional()
  @Transform(({ value }) => value === 'true')
  @IsBoolean()
  hasImage?: boolean;

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

export class AddMedicationDto extends PrescriptionMedicationDto {}

export class UpdateMedicationDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  strength?: string;

  @IsOptional()
  @IsString()
  form?: string;

  @IsOptional()
  @IsString()
  dosage?: string;

  @IsOptional()
  @IsNumber()
  @Min(1)
  quantity?: number;

  @IsOptional()
  @IsString()
  instructions?: string;

  @IsOptional()
  @IsString()
  linkedMedicationId?: string;
}

export class SetOCRDataDto extends OCRDataDto {}
