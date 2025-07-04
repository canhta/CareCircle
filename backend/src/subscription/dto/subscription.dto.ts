import {
  IsString,
  IsDateString,
  IsBoolean,
  IsEnum,
  IsOptional,
} from 'class-validator';

export enum SubscriptionStatus {
  ACTIVE = 'ACTIVE',
  EXPIRED = 'EXPIRED',
  CANCELLED = 'CANCELLED',
  PENDING = 'PENDING',
  SUSPENDED = 'SUSPENDED',
}

export enum PaymentMethod {
  CREDIT_CARD = 'CREDIT_CARD',
  APPLE_PAY = 'APPLE_PAY',
  GOOGLE_PAY = 'GOOGLE_PAY',
  MOMO = 'MOMO',
  ZALOPAY = 'ZALOPAY',
  BANK_TRANSFER = 'BANK_TRANSFER',
}

export class CreateUserSubscriptionDto {
  @IsString()
  subscriptionPlanId: string;

  @IsDateString()
  startDate: string;

  @IsDateString()
  endDate: string;

  @IsEnum(SubscriptionStatus)
  status: SubscriptionStatus;

  @IsEnum(PaymentMethod)
  paymentMethod: PaymentMethod;

  @IsOptional()
  @IsString()
  paymentReference?: string;

  @IsOptional()
  @IsBoolean()
  autoRenew?: boolean = true;
}

export class UpdateUserSubscriptionDto {
  @IsOptional()
  @IsEnum(SubscriptionStatus)
  status?: SubscriptionStatus;

  @IsOptional()
  @IsBoolean()
  autoRenew?: boolean;

  @IsOptional()
  @IsDateString()
  endDate?: string;
}
