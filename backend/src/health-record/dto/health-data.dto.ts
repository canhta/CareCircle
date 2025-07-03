import {
  IsEnum,
  IsDate,
  IsNumber,
  IsOptional,
  IsString,
  IsArray,
  ValidateNested,
  IsBoolean,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty } from '@nestjs/swagger';

export enum HealthDataTypeDto {
  STEPS = 'STEPS',
  HEART_RATE = 'HEART_RATE',
  BLOOD_PRESSURE = 'BLOOD_PRESSURE',
  WEIGHT = 'WEIGHT',
  HEIGHT = 'HEIGHT',
  SLEEP_ANALYSIS = 'SLEEP_ANALYSIS',
  BLOOD_GLUCOSE = 'BLOOD_GLUCOSE',
  BODY_TEMPERATURE = 'BODY_TEMPERATURE',
  OXYGEN_SATURATION = 'OXYGEN_SATURATION',
  ACTIVE_ENERGY_BURNED = 'ACTIVE_ENERGY_BURNED',
  DISTANCE_WALKING_RUNNING = 'DISTANCE_WALKING_RUNNING',
}

export enum DataSourceDto {
  APPLE_HEALTH = 'APPLE_HEALTH',
  GOOGLE_FIT = 'GOOGLE_FIT',
  HEALTH_CONNECT = 'HEALTH_CONNECT',
  MANUAL = 'MANUAL',
  DEVICE = 'DEVICE',
}

export class HealthDataPointDto {
  @ApiProperty({ enum: HealthDataTypeDto })
  @IsEnum(HealthDataTypeDto)
  type: HealthDataTypeDto;

  @ApiProperty()
  @IsNumber()
  value: number;

  @ApiProperty()
  @IsString()
  unit: string;

  @ApiProperty()
  @IsDate()
  @Type(() => Date)
  timestamp: Date;

  @ApiProperty({ enum: DataSourceDto })
  @IsEnum(DataSourceDto)
  source: DataSourceDto;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  deviceId?: string;

  @ApiProperty({ required: false })
  @IsOptional()
  metadata?: Record<string, any>;
}

export class HealthDataSyncDto {
  @ApiProperty({ type: [HealthDataPointDto] })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => HealthDataPointDto)
  data: HealthDataPointDto[];

  @ApiProperty({ enum: DataSourceDto })
  @IsEnum(DataSourceDto)
  source: DataSourceDto;

  @ApiProperty()
  @IsDate()
  @Type(() => Date)
  syncStartDate: Date;

  @ApiProperty()
  @IsDate()
  @Type(() => Date)
  syncEndDate: Date;
}

export class HealthDataConsentDto {
  @ApiProperty({ type: [String] })
  @IsArray()
  @IsString({ each: true })
  dataTypes: string[];

  @ApiProperty()
  @IsString()
  purpose: string;

  @ApiProperty()
  @IsBoolean()
  consentGranted: boolean;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  legalBasis?: string;
}

export class HealthMetricsQueryDto {
  @ApiProperty({ required: false })
  @IsOptional()
  @IsDate()
  @Type(() => Date)
  startDate?: Date;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsDate()
  @Type(() => Date)
  endDate?: Date;

  @ApiProperty({ enum: HealthDataTypeDto, isArray: true, required: false })
  @IsOptional()
  @IsArray()
  @IsEnum(HealthDataTypeDto, { each: true })
  types?: HealthDataTypeDto[];

  @ApiProperty({ required: false, default: 100 })
  @IsOptional()
  @IsNumber()
  limit?: number;

  @ApiProperty({ required: false, default: 0 })
  @IsOptional()
  @IsNumber()
  offset?: number;
}

export class HealthSyncStatusDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ enum: DataSourceDto })
  source: DataSourceDto;

  @ApiProperty()
  lastSyncAt: Date;

  @ApiProperty()
  syncStatus: string;

  @ApiProperty()
  recordsCount: number;

  @ApiProperty({ required: false })
  errorMessage?: string;

  @ApiProperty()
  syncFromDate: Date;

  @ApiProperty()
  syncToDate: Date;
}
