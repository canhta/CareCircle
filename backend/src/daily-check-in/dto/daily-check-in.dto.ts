import {
  IsString,
  IsInt,
  IsOptional,
  IsArray,
  IsBoolean,
  IsDateString,
  Min,
  Max,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateDailyCheckInDto {
  @ApiProperty({ description: 'Date of the check-in' })
  @IsDateString()
  date: string;

  @ApiPropertyOptional({
    description: 'Mood score (1-10)',
    minimum: 1,
    maximum: 10,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(10)
  moodScore?: number;

  @ApiPropertyOptional({
    description: 'Energy level (1-10)',
    minimum: 1,
    maximum: 10,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(10)
  energyLevel?: number;

  @ApiPropertyOptional({
    description: 'Sleep quality (1-10)',
    minimum: 1,
    maximum: 10,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(10)
  sleepQuality?: number;

  @ApiPropertyOptional({
    description: 'Pain level (0-10)',
    minimum: 0,
    maximum: 10,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(10)
  painLevel?: number;

  @ApiPropertyOptional({
    description: 'Stress level (1-10)',
    minimum: 1,
    maximum: 10,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(10)
  stressLevel?: number;

  @ApiPropertyOptional({ description: 'Array of symptoms' })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  symptoms?: string[];

  @ApiPropertyOptional({ description: 'Additional notes' })
  @IsOptional()
  @IsString()
  notes?: string;

  @ApiPropertyOptional({ description: 'Whether the check-in is completed' })
  @IsOptional()
  @IsBoolean()
  completed?: boolean;
}

export class UpdateDailyCheckInDto {
  @ApiPropertyOptional({
    description: 'Mood score (1-10)',
    minimum: 1,
    maximum: 10,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(10)
  moodScore?: number;

  @ApiPropertyOptional({
    description: 'Energy level (1-10)',
    minimum: 1,
    maximum: 10,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(10)
  energyLevel?: number;

  @ApiPropertyOptional({
    description: 'Sleep quality (1-10)',
    minimum: 1,
    maximum: 10,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(10)
  sleepQuality?: number;

  @ApiPropertyOptional({
    description: 'Pain level (0-10)',
    minimum: 0,
    maximum: 10,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(10)
  painLevel?: number;

  @ApiPropertyOptional({
    description: 'Stress level (1-10)',
    minimum: 1,
    maximum: 10,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(10)
  stressLevel?: number;

  @ApiPropertyOptional({ description: 'Array of symptoms' })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  symptoms?: string[];

  @ApiPropertyOptional({ description: 'Additional notes' })
  @IsOptional()
  @IsString()
  notes?: string;

  @ApiPropertyOptional({ description: 'Whether the check-in is completed' })
  @IsOptional()
  @IsBoolean()
  completed?: boolean;
}

export class PersonalizedQuestionDto {
  @ApiProperty({ description: 'Question ID' })
  id: string;

  @ApiProperty({ description: 'Question text' })
  question: string;

  @ApiProperty({ description: 'Question type' })
  type: 'scale' | 'multiple_choice' | 'text' | 'boolean';

  @ApiPropertyOptional({ description: 'Question options for multiple choice' })
  options?: string[];

  @ApiPropertyOptional({ description: 'Minimum value for scale questions' })
  minValue?: number;

  @ApiPropertyOptional({ description: 'Maximum value for scale questions' })
  maxValue?: number;

  @ApiPropertyOptional({ description: 'Question category' })
  category?: string;

  @ApiPropertyOptional({ description: 'Question priority' })
  priority?: number;

  @ApiPropertyOptional({ description: 'Follow-up question IDs' })
  followUpQuestions?: string[];
}

export class GenerateQuestionsDto {
  @ApiProperty({ description: 'User ID' })
  @IsString()
  userId: string;

  @ApiPropertyOptional({ description: 'Date for the questions' })
  @IsOptional()
  @IsDateString()
  date?: string;

  @ApiPropertyOptional({ description: 'Number of questions to generate' })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(20)
  questionCount?: number;

  @ApiPropertyOptional({ description: 'Question categories to focus on' })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  categories?: string[];
}

export class AnswerQuestionDto {
  @ApiProperty({ description: 'Question ID' })
  @IsString()
  questionId: string;

  @ApiProperty({ description: 'User answer' })
  answer: string | number | boolean;

  @ApiPropertyOptional({ description: 'Additional context or notes' })
  @IsOptional()
  @IsString()
  notes?: string;
}

export class CheckInResponseDto {
  @ApiProperty({ description: 'Check-in ID' })
  id: string;

  @ApiProperty({ description: 'User ID' })
  userId: string;

  @ApiProperty({ description: 'Date of the check-in' })
  date: string;

  @ApiProperty({ description: 'Mood score (1-10)' })
  moodScore?: number;

  @ApiProperty({ description: 'Energy level (1-10)' })
  energyLevel?: number;

  @ApiProperty({ description: 'Sleep quality (1-10)' })
  sleepQuality?: number;

  @ApiProperty({ description: 'Pain level (0-10)' })
  painLevel?: number;

  @ApiProperty({ description: 'Stress level (1-10)' })
  stressLevel?: number;

  @ApiProperty({ description: 'Array of symptoms' })
  symptoms?: string[];

  @ApiProperty({ description: 'Additional notes' })
  notes?: string;

  @ApiProperty({ description: 'AI generated insights' })
  aiInsights?: string;

  @ApiProperty({ description: 'Risk score' })
  riskScore?: number;

  @ApiProperty({ description: 'Whether the check-in is completed' })
  completed: boolean;

  @ApiProperty({ description: 'Completion timestamp' })
  completedAt?: string;

  @ApiProperty({ description: 'Creation timestamp' })
  createdAt: string;

  @ApiProperty({ description: 'Last updated timestamp' })
  updatedAt: string;
}
