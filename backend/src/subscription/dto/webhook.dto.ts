import {
  IsString,
  IsObject,
  IsEnum,
  IsOptional,
  IsDateString,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { PaymentProvider, PaymentStatus } from './payment.dto';

export enum WebhookEventType {
  PAYMENT_SUCCEEDED = 'payment.succeeded',
  PAYMENT_FAILED = 'payment.failed',
  PAYMENT_REFUNDED = 'payment.refunded',
  SUBSCRIPTION_CREATED = 'subscription.created',
  SUBSCRIPTION_UPDATED = 'subscription.updated',
  SUBSCRIPTION_CANCELLED = 'subscription.cancelled',
}

export class WebhookPayloadDto {
  @IsString()
  id: string; // Webhook event ID

  @IsEnum(WebhookEventType)
  event: WebhookEventType;

  @IsString()
  @IsOptional()
  livemode?: boolean;

  @IsDateString()
  created: string;

  @IsObject()
  @ValidateNested()
  @Type(() => WebhookDataDto)
  data: WebhookDataDto;
}

export class WebhookDataDto {
  @IsObject()
  @ValidateNested()
  @Type(() => WebhookPaymentDto)
  payment?: WebhookPaymentDto;

  @IsObject()
  @ValidateNested()
  @Type(() => WebhookSubscriptionDto)
  subscription?: WebhookSubscriptionDto;
}

export class WebhookPaymentDto {
  @IsString()
  id: string; // Provider's payment ID

  @IsString()
  @IsOptional()
  transactionId?: string;

  @IsEnum(PaymentStatus)
  status: PaymentStatus;

  @IsEnum(PaymentProvider)
  provider: PaymentProvider;

  @IsString()
  @IsOptional()
  paymentReference?: string; // Reference to connect with our system

  @IsObject()
  @IsOptional()
  metadata?: Record<string, any>;
}

export class WebhookSubscriptionDto {
  @IsString()
  id: string; // Provider's subscription ID

  @IsString()
  @IsOptional()
  status?: string;

  @IsDateString()
  @IsOptional()
  currentPeriodStart?: string;

  @IsDateString()
  @IsOptional()
  currentPeriodEnd?: string;

  @IsString()
  @IsOptional()
  paymentReference?: string; // Reference to connect with our system

  @IsObject()
  @IsOptional()
  metadata?: Record<string, any>;
}

// Provider-specific webhook DTOs
export class StripeWebhookDto extends WebhookPayloadDto {}

export class MomoWebhookDto {
  @IsString()
  partnerCode: string;

  @IsString()
  orderId: string;

  @IsString()
  requestId: string;

  @IsString()
  amount: string;

  @IsString()
  orderInfo: string;

  @IsString()
  orderType: string;

  @IsString()
  transId: string;

  @IsString()
  resultCode: string;

  @IsString()
  message: string;

  @IsString()
  payType: string;

  @IsString()
  responseTime: string;

  @IsString()
  extraData: string;

  @IsString()
  signature: string;
}

export class ZaloPayWebhookDto {
  @IsString()
  app_id: string;

  @IsString()
  app_trans_id: string;

  @IsString()
  app_time: string;

  @IsString()
  app_user: string;

  @IsString()
  amount: string;

  @IsString()
  embed_data: string;

  @IsString()
  item: string;

  @IsString()
  zp_trans_id: string;

  @IsString()
  server_time: string;

  @IsString()
  channel: string;

  @IsString()
  merchant_user_id: string;

  @IsString()
  user_fee_amount: string;

  @IsString()
  discount_amount: string;

  @IsString()
  status: string;

  @IsString()
  signature: string;
}

export class GooglePlayWebhookDto {
  @IsString()
  message: string;

  @IsString()
  subscription: string;
}

export class AppleWebhookDto {
  @IsString()
  notification_type: string;

  @IsString()
  @IsOptional()
  password?: string;

  @IsObject()
  unified_receipt: any;

  @IsObject()
  @IsOptional()
  auto_renew_status?: any;

  @IsObject()
  @IsOptional()
  environment?: any;
}
