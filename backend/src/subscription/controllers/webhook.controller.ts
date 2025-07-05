import {
  Controller,
  Post,
  Body,
  Headers,
  Logger,
  HttpCode,
  RawBodyRequest,
  Req,
  BadRequestException,
} from '@nestjs/common';
import { Request } from 'express';
import { WebhookService } from '../services/webhook.service';
import {
  WebhookPayloadDto,
  StripeWebhookDto,
  MomoWebhookDto,
  ZaloPayWebhookDto,
  GooglePlayWebhookDto,
  AppleWebhookDto,
} from '../dto/webhook.dto';
import { ConfigService } from '@nestjs/config';
import * as crypto from 'crypto';

@Controller('webhooks')
export class WebhookController {
  private readonly logger = new Logger(WebhookController.name);

  constructor(
    private readonly webhookService: WebhookService,
    private readonly configService: ConfigService,
  ) {}

  @Post('stripe')
  @HttpCode(200)
  async handleStripeWebhook(
    @Body() payload: StripeWebhookDto,
    @Headers('stripe-signature') signature: string,
    @Req() request: RawBodyRequest<Request>,
  ) {
    this.logger.log('Received Stripe webhook');

    // Verify Stripe signature
    const rawBody = request.rawBody?.toString('utf8');
    if (!rawBody) {
      this.logger.warn(
        'No raw body available for Stripe signature verification',
      );
      throw new BadRequestException('Invalid payload');
    }

    const webhookSecret = this.configService.get<string>(
      'STRIPE_WEBHOOK_SECRET',
    );
    if (webhookSecret && signature) {
      try {
        const expectedSignature = crypto
          .createHmac('sha256', webhookSecret)
          .update(rawBody)
          .digest('hex');

        if (signature !== `t=${Date.now()},v1=${expectedSignature}`) {
          this.logger.warn('Invalid Stripe signature');
          throw new BadRequestException('Invalid signature');
        }
      } catch (error) {
        this.logger.error(`Error verifying Stripe signature: ${error.message}`);
        throw new BadRequestException('Invalid signature');
      }
    }

    return this.webhookService.handleStripeWebhook(payload);
  }

  @Post('momo')
  @HttpCode(200)
  async handleMomoWebhook(@Body() payload: MomoWebhookDto) {
    this.logger.log('Received MoMo webhook');
    return this.webhookService.handleMomoWebhook(payload);
  }

  @Post('zalopay')
  @HttpCode(200)
  async handleZaloPayWebhook(@Body() payload: ZaloPayWebhookDto) {
    this.logger.log('Received ZaloPay webhook');
    return this.webhookService.handleZaloPayWebhook(payload);
  }

  @Post('google-play')
  @HttpCode(200)
  async handleGooglePlayWebhook(@Body() payload: GooglePlayWebhookDto) {
    this.logger.log('Received Google Play webhook');
    return this.webhookService.handleGooglePlayWebhook(payload);
  }

  @Post('apple')
  @HttpCode(200)
  async handleAppleWebhook(@Body() payload: AppleWebhookDto) {
    this.logger.log('Received Apple webhook');
    return this.webhookService.handleAppleWebhook(payload);
  }
}
