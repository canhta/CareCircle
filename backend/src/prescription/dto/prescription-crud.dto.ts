import {
  IsString,
  IsOptional,
  IsBoolean,
  IsNumber,
  IsDateString,
  IsNotEmpty,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreatePrescriptionDto {
  @ApiProperty({
    description: 'Name of the medication',
    example: 'Metformin',
  })
  @IsString()
  @IsNotEmpty()
  medicationName: string;

  @ApiProperty({
    description: 'Dosage information',
    example: '500mg',
  })
  @IsString()
  @IsNotEmpty()
  dosage: string;

  @ApiProperty({
    description: 'Frequency of medication',
    example: 'Twice daily',
  })
  @IsString()
  @IsNotEmpty()
  frequency: string;

  @ApiPropertyOptional({
    description: 'Additional instructions',
    example: 'Take with food',
  })
  @IsString()
  @IsOptional()
  instructions?: string;

  @ApiProperty({
    description: 'Start date of prescription',
    example: '2024-01-15T00:00:00.000Z',
  })
  @IsDateString()
  startDate: Date;

  @ApiPropertyOptional({
    description: 'End date of prescription',
    example: '2024-02-15T00:00:00.000Z',
  })
  @IsDateString()
  @IsOptional()
  endDate?: Date;

  @ApiPropertyOptional({
    description: 'URL of OCR image',
    example: 'https://example.com/prescription.jpg',
  })
  @IsString()
  @IsOptional()
  ocrImageUrl?: string;

  @ApiPropertyOptional({
    description: 'OCR confidence score',
    example: 0.95,
  })
  @IsNumber()
  @IsOptional()
  ocrConfidence?: number;

  @ApiPropertyOptional({
    description: 'Whether prescription data is verified',
    example: true,
  })
  @IsBoolean()
  @IsOptional()
  isVerified?: boolean;

  @ApiPropertyOptional({
    description: 'Number of refills remaining',
    example: 3,
  })
  @IsNumber()
  @IsOptional()
  refillsLeft?: number;

  @ApiPropertyOptional({
    description: 'Pharmacy name',
    example: 'CVS Pharmacy',
  })
  @IsString()
  @IsOptional()
  pharmacy?: string;

  @ApiPropertyOptional({
    description: 'Prescribing doctor',
    example: 'Dr. Smith',
  })
  @IsString()
  @IsOptional()
  prescribedBy?: string;
}

export class UpdatePrescriptionDto {
  @ApiPropertyOptional({
    description: 'Name of the medication',
    example: 'Metformin',
  })
  @IsString()
  @IsOptional()
  medicationName?: string;

  @ApiPropertyOptional({
    description: 'Dosage information',
    example: '500mg',
  })
  @IsString()
  @IsOptional()
  dosage?: string;

  @ApiPropertyOptional({
    description: 'Frequency of medication',
    example: 'Twice daily',
  })
  @IsString()
  @IsOptional()
  frequency?: string;

  @ApiPropertyOptional({
    description: 'Additional instructions',
    example: 'Take with food',
  })
  @IsString()
  @IsOptional()
  instructions?: string;

  @ApiPropertyOptional({
    description: 'Start date of prescription',
    example: '2024-01-15T00:00:00.000Z',
  })
  @IsDateString()
  @IsOptional()
  startDate?: Date;

  @ApiPropertyOptional({
    description: 'End date of prescription',
    example: '2024-02-15T00:00:00.000Z',
  })
  @IsDateString()
  @IsOptional()
  endDate?: Date;

  @ApiPropertyOptional({
    description: 'Whether prescription data is verified',
    example: true,
  })
  @IsBoolean()
  @IsOptional()
  isVerified?: boolean;

  @ApiPropertyOptional({
    description: 'Number of refills remaining',
    example: 3,
  })
  @IsNumber()
  @IsOptional()
  refillsLeft?: number;

  @ApiPropertyOptional({
    description: 'Pharmacy name',
    example: 'CVS Pharmacy',
  })
  @IsString()
  @IsOptional()
  pharmacy?: string;

  @ApiPropertyOptional({
    description: 'Prescribing doctor',
    example: 'Dr. Smith',
  })
  @IsString()
  @IsOptional()
  prescribedBy?: string;
}

export class PrescriptionResponseDto {
  @ApiProperty({
    description: 'Prescription ID',
    example: 'uuid-123',
  })
  id: string;

  @ApiProperty({
    description: 'User ID',
    example: 'user-uuid-123',
  })
  userId: string;

  @ApiProperty({
    description: 'Name of the medication',
    example: 'Metformin',
  })
  medicationName: string;

  @ApiProperty({
    description: 'Dosage information',
    example: '500mg',
  })
  dosage: string;

  @ApiProperty({
    description: 'Frequency of medication',
    example: 'Twice daily',
  })
  frequency: string;

  @ApiPropertyOptional({
    description: 'Additional instructions',
    example: 'Take with food',
  })
  instructions?: string | null;

  @ApiProperty({
    description: 'Start date of prescription',
  })
  startDate: Date;

  @ApiPropertyOptional({
    description: 'End date of prescription',
  })
  endDate?: Date | null;

  @ApiPropertyOptional({
    description: 'URL of OCR image',
  })
  ocrImageUrl?: string | null;

  @ApiPropertyOptional({
    description: 'OCR confidence score',
  })
  ocrConfidence?: number | null;

  @ApiProperty({
    description: 'Whether prescription data is verified',
  })
  isVerified: boolean;

  @ApiPropertyOptional({
    description: 'Number of refills remaining',
  })
  refillsLeft?: number | null;

  @ApiPropertyOptional({
    description: 'Pharmacy name',
  })
  pharmacy?: string | null;

  @ApiPropertyOptional({
    description: 'Prescribing doctor',
  })
  prescribedBy?: string | null;

  @ApiProperty({
    description: 'Whether prescription is active',
  })
  isActive: boolean;

  @ApiProperty({
    description: 'Creation timestamp',
  })
  createdAt: Date;

  @ApiProperty({
    description: 'Last update timestamp',
  })
  updatedAt: Date;
}

export class PrescriptionStatsDto {
  @ApiProperty({
    description: 'Total number of prescriptions',
    example: 10,
  })
  total: number;

  @ApiProperty({
    description: 'Number of active prescriptions',
    example: 5,
  })
  active: number;

  @ApiProperty({
    description: 'Number of verified prescriptions',
    example: 8,
  })
  verified: number;

  @ApiProperty({
    description: 'Number of prescriptions from OCR',
    example: 3,
  })
  fromOCR: number;
}
