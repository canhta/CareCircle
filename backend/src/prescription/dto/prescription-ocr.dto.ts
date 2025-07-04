import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString, IsNumber, Min, Max } from 'class-validator';

export class ProcessPrescriptionImageDto {
  @ApiProperty({
    description: 'Optional metadata about the prescription image',
    required: false,
  })
  @IsOptional()
  @IsString()
  metadata?: string;
}

export class PrescriptionExtractedDataDto {
  @ApiProperty({
    description: 'Extracted drug name',
    example: 'Lisinopril',
    required: false,
  })
  @IsOptional()
  @IsString()
  drugName?: string;

  @ApiProperty({
    description: 'Extracted dosage information',
    example: '10mg',
    required: false,
  })
  @IsOptional()
  @IsString()
  dosage?: string;

  @ApiProperty({
    description: 'Extracted frequency/schedule',
    example: 'Once daily',
    required: false,
  })
  @IsOptional()
  @IsString()
  frequency?: string;

  @ApiProperty({
    description: 'Extracted quantity',
    example: '30',
    required: false,
  })
  @IsOptional()
  @IsString()
  quantity?: string;

  @ApiProperty({
    description: 'Extracted prescriber name',
    example: 'Dr. Smith',
    required: false,
  })
  @IsOptional()
  @IsString()
  prescriber?: string;

  @ApiProperty({
    description: 'Extracted usage instructions',
    example: 'Take with food',
    required: false,
  })
  @IsOptional()
  @IsString()
  instructions?: string;
}

export class PrescriptionValidationDto {
  @ApiProperty({
    description: 'Whether the prescription data appears valid',
    example: true,
  })
  isValid: boolean;

  @ApiProperty({
    description: 'Confidence level of the validation',
    example: 'high',
    enum: ['low', 'medium', 'high'],
  })
  confidence: 'low' | 'medium' | 'high';

  @ApiProperty({
    description: 'List of validation issues found',
    example: ['Low OCR confidence'],
    type: [String],
  })
  issues: string[];
}

export class PrescriptionOCRResponseDto {
  @ApiProperty({
    description: 'Raw OCR text extracted from the image',
    example: 'Lisinopril 10mg Take once daily #30',
  })
  text: string;

  @ApiProperty({
    description: 'OCR confidence score (0-100)',
    example: 85.5,
    minimum: 0,
    maximum: 100,
  })
  @IsNumber()
  @Min(0)
  @Max(100)
  confidence: number;

  @ApiProperty({
    description: 'Structured prescription data extracted from OCR text',
    type: PrescriptionExtractedDataDto,
  })
  extractedData: PrescriptionExtractedDataDto;

  @ApiProperty({
    description: 'Validation results for the extracted data',
    type: PrescriptionValidationDto,
  })
  validation: PrescriptionValidationDto;

  @ApiProperty({
    description: 'Processing timestamp',
    example: '2025-07-04T10:30:00Z',
  })
  processedAt: string;
}

export class PrescriptionOCRErrorDto {
  @ApiProperty({
    description: 'Error message',
    example: 'OCR processing failed: Invalid image format',
  })
  message: string;

  @ApiProperty({
    description: 'Error code',
    example: 'OCR_PROCESSING_ERROR',
  })
  code: string;

  @ApiProperty({
    description: 'Additional error details',
    required: false,
  })
  @IsOptional()
  details?: any;
}
