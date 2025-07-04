import {
  IsString,
  IsNumber,
  IsEnum,
  IsOptional,
  IsDateString,
} from 'class-validator';

export enum PaymentStatus {
  PENDING = 'PENDING',
  COMPLETED = 'COMPLETED',
  FAILED = 'FAILED',
  REFUNDED = 'REFUNDED',
  CANCELLED = 'CANCELLED',
}

export enum PaymentProvider {
  APPLE_APP_STORE = 'APPLE_APP_STORE',
  GOOGLE_PLAY_STORE = 'GOOGLE_PLAY_STORE',
  MOMO = 'MOMO',
  ZALOPAY = 'ZALOPAY',
  STRIPE = 'STRIPE',
}

export enum PaymentMethod {
  CREDIT_CARD = 'CREDIT_CARD',
  APPLE_PAY = 'APPLE_PAY',
  GOOGLE_PAY = 'GOOGLE_PAY',
  MOMO = 'MOMO',
  ZALOPAY = 'ZALOPAY',
  BANK_TRANSFER = 'BANK_TRANSFER',
}

export class CreatePaymentDto {
  @IsString()
  userSubscriptionId: string;

  @IsNumber()
  amount: number;

  @IsString()
  currency: string;

  @IsEnum(PaymentMethod)
  paymentMethod: PaymentMethod;

  @IsEnum(PaymentProvider)
  paymentProvider: PaymentProvider;

  @IsOptional()
  @IsString()
  providerTransactionId?: string;

  @IsOptional()
  @IsString()
  providerPaymentId?: string;

  @IsOptional()
  @IsEnum(PaymentStatus)
  status?: PaymentStatus = PaymentStatus.PENDING;

  @IsOptional()
  @IsDateString()
  paidAt?: string;
}

export class UpdatePaymentDto {
  @IsOptional()
  @IsEnum(PaymentStatus)
  status?: PaymentStatus;

  @IsOptional()
  @IsString()
  providerTransactionId?: string;

  @IsOptional()
  @IsString()
  providerPaymentId?: string;

  @IsOptional()
  @IsDateString()
  paidAt?: string;
}
