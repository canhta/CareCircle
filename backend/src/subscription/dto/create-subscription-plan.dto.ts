import {
  IsString,
  IsNumber,
  IsOptional,
  IsBoolean,
  IsArray,
} from 'class-validator';

export class CreateSubscriptionPlanDto {
  @IsString()
  name: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsNumber()
  price: number;

  @IsOptional()
  @IsString()
  currency?: string = 'USD';

  @IsNumber()
  duration: number; // in days

  @IsArray()
  features: string[];

  @IsOptional()
  @IsNumber()
  maxCareGroupSize?: number;

  @IsOptional()
  @IsNumber()
  maxHealthDataSync?: number;

  @IsOptional()
  @IsNumber()
  maxDocumentStorage?: number; // in MB

  @IsOptional()
  @IsNumber()
  maxNotifications?: number; // per month

  @IsOptional()
  @IsNumber()
  maxAIInsights?: number; // per month

  @IsOptional()
  @IsBoolean()
  isActive?: boolean = true;

  @IsOptional()
  @IsBoolean()
  isDefault?: boolean = false;
}

export class UpdateSubscriptionPlanDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsNumber()
  price?: number;

  @IsOptional()
  @IsString()
  currency?: string;

  @IsOptional()
  @IsNumber()
  duration?: number; // in days

  @IsOptional()
  @IsArray()
  features?: string[];

  @IsOptional()
  @IsNumber()
  maxCareGroupSize?: number;

  @IsOptional()
  @IsNumber()
  maxHealthDataSync?: number;

  @IsOptional()
  @IsNumber()
  maxDocumentStorage?: number; // in MB

  @IsOptional()
  @IsNumber()
  maxNotifications?: number; // per month

  @IsOptional()
  @IsNumber()
  maxAIInsights?: number; // per month

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;

  @IsOptional()
  @IsBoolean()
  isDefault?: boolean;
}
