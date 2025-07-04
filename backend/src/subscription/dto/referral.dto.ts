import {
  IsString,
  IsNumber,
  IsEnum,
  IsOptional,
  IsBoolean,
  IsDateString,
  IsInt,
} from 'class-validator';

export enum ReferralRewardType {
  DISCOUNT_PERCENTAGE = 'DISCOUNT_PERCENTAGE',
  DISCOUNT_FIXED = 'DISCOUNT_FIXED',
  FREE_DAYS = 'FREE_DAYS',
  CREDITS = 'CREDITS',
}

export enum ReferralStatus {
  PENDING = 'PENDING',
  COMPLETED = 'COMPLETED',
  EXPIRED = 'EXPIRED',
  CANCELLED = 'CANCELLED',
}

export class CreateReferralCodeDto {
  @IsString()
  code: string;

  @IsEnum(ReferralRewardType)
  rewardType: ReferralRewardType;

  @IsNumber()
  rewardValue: number;

  @IsOptional()
  @IsInt()
  maxUses?: number = 1;

  @IsOptional()
  @IsDateString()
  expiresAt?: string;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean = true;
}

export class UpdateReferralCodeDto {
  @IsOptional()
  @IsEnum(ReferralRewardType)
  rewardType?: ReferralRewardType;

  @IsOptional()
  @IsNumber()
  rewardValue?: number;

  @IsOptional()
  @IsInt()
  maxUses?: number;

  @IsOptional()
  @IsDateString()
  expiresAt?: string;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}

export class CreateReferralDto {
  @IsString()
  referralCodeId: string;

  @IsString()
  referredUserId: string;

  @IsEnum(ReferralStatus)
  status: ReferralStatus = ReferralStatus.PENDING;
}

export class UpdateReferralDto {
  @IsOptional()
  @IsEnum(ReferralStatus)
  status?: ReferralStatus;

  @IsOptional()
  @IsBoolean()
  rewardClaimed?: boolean;

  @IsOptional()
  @IsDateString()
  rewardClaimedAt?: string;
}
