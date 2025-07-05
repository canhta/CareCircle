import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import {
  WebhookPayloadDto,
  WebhookEventType,
  MomoWebhookDto,
  ZaloPayWebhookDto,
  GooglePlayWebhookDto,
  AppleWebhookDto,
} from '../dto/webhook.dto';
import { PaymentProvider, PaymentStatus } from '../dto/payment.dto';
import { SubscriptionStatus } from '../dto/subscription.dto';
import * as crypto from 'crypto';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class WebhookService {
  private readonly logger = new Logger(WebhookService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly configService: ConfigService,
  ) {}

  async handleStripeWebhook(payload: WebhookPayloadDto) {
    this.logger.log(`Processing Stripe webhook: ${payload.event}`);

    try {
      // Verify Stripe webhook signature
      // In a real application, you'd use the Stripe SDK to verify the signature
      // const signature = req.headers['stripe-signature'];
      // const event = stripe.webhooks.constructEvent(req.body, signature, endpointSecret);

      switch (payload.event) {
        case 'payment_intent.succeeded':
          return this.processPaymentSuccess(
            payload.data.payment_intent.id,
            payload.data.payment_intent.metadata.paymentId || '',
            PaymentProvider.STRIPE,
          );

        case 'payment_intent.payment_failed':
          return this.processPaymentFailure(
            payload.data.payment_intent.id,
            payload.data.payment_intent.metadata.paymentId || '',
            PaymentProvider.STRIPE,
          );

        case 'charge.refunded':
          return this.processPaymentRefund(
            payload.data.charge.id,
            payload.data.charge.metadata.paymentId || '',
            PaymentProvider.STRIPE,
          );

        case 'customer.subscription.updated':
          // Handle subscription updates (like plan changes, etc.)
          return this.processSubscriptionUpdate(
            payload.data.subscription.id,
            payload.data.subscription.paymentReference || '',
            payload.data.subscription.current_period_end,
            PaymentProvider.STRIPE,
          );

        case 'customer.subscription.deleted':
          return this.processSubscriptionCancellation(
            payload.data.subscription.id,
            payload.data.subscription.paymentReference || '',
            PaymentProvider.STRIPE,
          );

        default:
          this.logger.warn(
            `Unhandled Stripe event type: ${String(payload.event)}`,
          );
          return { received: true, handled: false };
      }
    } catch (error) {
      this.logger.error(
        `Error processing Stripe webhook: ${(error as Error).message}`,
        (error as Error).stack,
      );
      throw new BadRequestException(
        `Error processing webhook: ${(error as Error).message}`,
      );
    }
  }

  async handleMomoWebhook(payload: MomoWebhookDto) {
    this.logger.log(`Processing MoMo webhook: ${payload.orderId}`);

    try {
      // Verify MoMo webhook signature
      const isValid = this.verifyMomoSignature(payload);
      if (!isValid) {
        this.logger.warn(
          `Invalid MoMo signature for order: ${payload.orderId}`,
        );
        throw new BadRequestException('Invalid signature');
      }

      // Extract subscription ID from orderInfo or extraData
      const paymentReference = this.extractPaymentReference(
        payload.orderInfo,
        payload.extraData,
      );

      if (payload.resultCode === '0') {
        // Success
        return this.processPaymentSuccess(
          payload.transId,
          paymentReference,
          PaymentProvider.MOMO,
        );
      } else {
        // Failure
        return this.processPaymentFailure(
          payload.transId,
          paymentReference,
          PaymentProvider.MOMO,
        );
      }
    } catch (error) {
      this.logger.error(
        `Error processing MoMo webhook: ${error.message}`,
        error.stack,
      );
      throw new BadRequestException(
        `Error processing webhook: ${error.message}`,
      );
    }
  }

  async handleZaloPayWebhook(payload: ZaloPayWebhookDto) {
    this.logger.log(`Processing ZaloPay webhook: ${payload.app_trans_id}`);

    try {
      // Verify ZaloPay webhook signature
      const isValid = this.verifyZaloPaySignature(payload);
      if (!isValid) {
        this.logger.warn(
          `Invalid ZaloPay signature for transaction: ${payload.app_trans_id}`,
        );
        throw new BadRequestException('Invalid signature');
      }

      // Extract subscription ID from embed_data
      const paymentReference = this.extractPaymentReference(
        payload.embed_data,
        undefined,
      );

      if (payload.status === '1') {
        // Success
        return this.processPaymentSuccess(
          payload.zp_trans_id,
          paymentReference,
          PaymentProvider.ZALOPAY,
        );
      } else {
        // Failure
        return this.processPaymentFailure(
          payload.zp_trans_id,
          paymentReference,
          PaymentProvider.ZALOPAY,
        );
      }
    } catch (error) {
      this.logger.error(
        `Error processing ZaloPay webhook: ${error.message}`,
        error.stack,
      );
      throw new BadRequestException(
        `Error processing webhook: ${error.message}`,
      );
    }
  }

  async handleGooglePlayWebhook(payload: GooglePlayWebhookDto) {
    this.logger.log(`Processing Google Play webhook`);

    try {
      // Google Play webhook handling is more complex and requires parsing the message
      // This is a simplified version
      const messageData = JSON.parse(
        Buffer.from(payload.message, 'base64').toString(),
      );
      const subscriptionNotification = messageData.subscriptionNotification;

      if (!subscriptionNotification) {
        this.logger.warn(
          'Invalid Google Play webhook: No subscription notification',
        );
        return { received: true, handled: false };
      }

      const purchaseToken = subscriptionNotification.purchaseToken;

      // Find the payment by metadata containing the purchaseToken
      const payment = await this.prisma.payment.findFirst({
        where: {
          paymentProvider: PaymentProvider.GOOGLE_PLAY_STORE,
          providerPaymentId: purchaseToken,
        },
      });

      if (!payment) {
        this.logger.warn(
          `Payment not found for Google Play token: ${purchaseToken}`,
        );
        return { received: true, handled: false };
      }

      switch (subscriptionNotification.notificationType) {
        case 1: // SUBSCRIPTION_RECOVERED
        case 2: // SUBSCRIPTION_RENEWED
        case 8: // SUBSCRIPTION_PURCHASED
          return this.processPaymentSuccess(
            purchaseToken,
            payment.id,
            PaymentProvider.GOOGLE_PLAY_STORE,
          );
        case 3: // SUBSCRIPTION_CANCELED
          return this.processSubscriptionCancellation(
            purchaseToken,
            payment.id,
            PaymentProvider.GOOGLE_PLAY_STORE,
          );
        case 4: // SUBSCRIPTION_ON_HOLD
        case 5: // SUBSCRIPTION_IN_GRACE_PERIOD
        case 6: // SUBSCRIPTION_RESTARTED
        case 7: // SUBSCRIPTION_PRICE_CHANGE_CONFIRMED
        case 9: // SUBSCRIPTION_DEFERRED
        case 10: // SUBSCRIPTION_PAUSED
        case 11: // SUBSCRIPTION_PAUSE_SCHEDULE_CHANGED
        case 12: // SUBSCRIPTION_REVOKED
        case 13: // SUBSCRIPTION_EXPIRED
          // Handle these cases as needed
          return { received: true, handled: false };
        default:
          this.logger.warn(
            `Unhandled Google Play notification type: ${subscriptionNotification.notificationType}`,
          );
          return { received: true, handled: false };
      }
    } catch (error) {
      this.logger.error(
        `Error processing Google Play webhook: ${error.message}`,
        error.stack,
      );
      throw new BadRequestException(
        `Error processing webhook: ${error.message}`,
      );
    }
  }

  async handleAppleWebhook(payload: AppleWebhookDto) {
    this.logger.log(`Processing Apple webhook: ${payload.notification_type}`);

    try {
      // Verify shared secret if provided
      if (payload.password) {
        const sharedSecret = this.configService.get<string>(
          'APPLE_SHARED_SECRET',
        );
        if (payload.password !== sharedSecret) {
          this.logger.warn('Invalid Apple shared secret');
          throw new BadRequestException('Invalid shared secret');
        }
      }

      // Process unified receipt
      const latestReceipt = payload.unified_receipt?.latest_receipt_info?.[0];

      if (!latestReceipt) {
        this.logger.warn('No receipt info in Apple webhook');
        return { received: true, handled: false };
      }

      const transactionId = latestReceipt.transaction_id;
      const originalTransactionId = latestReceipt.original_transaction_id;

      // Find payment by transaction ID
      const payment = await this.prisma.payment.findFirst({
        where: {
          paymentProvider: PaymentProvider.APPLE_APP_STORE,
          providerTransactionId: transactionId,
        },
      });

      if (!payment) {
        this.logger.warn(
          `Payment not found for Apple transaction: ${transactionId}`,
        );
        return { received: true, handled: false };
      }

      switch (payload.notification_type) {
        case 'INITIAL_BUY':
        case 'INTERACTIVE_RENEWAL':
        case 'DID_RECOVER':
        case 'DID_RENEW':
          return this.processPaymentSuccess(
            transactionId,
            payment.id,
            PaymentProvider.APPLE_APP_STORE,
          );
        case 'CANCEL':
        case 'DID_CHANGE_RENEWAL_PREF': // User downgraded
          return this.processSubscriptionCancellation(
            originalTransactionId || transactionId,
            payment.id,
            PaymentProvider.APPLE_APP_STORE,
          );
        case 'DID_FAIL_TO_RENEW':
          return this.processPaymentFailure(
            transactionId,
            payment.id,
            PaymentProvider.APPLE_APP_STORE,
          );
        case 'REFUND':
          return this.processPaymentRefund(
            transactionId,
            payment.id,
            PaymentProvider.APPLE_APP_STORE,
          );
        default:
          this.logger.warn(
            `Unhandled Apple notification type: ${payload.notification_type}`,
          );
          return { received: true, handled: false };
      }
    } catch (error) {
      this.logger.error(
        `Error processing Apple webhook: ${error.message}`,
        error.stack,
      );
      throw new BadRequestException(
        `Error processing webhook: ${error.message}`,
      );
    }
  }

  // Helper methods for processing webhooks
  private async processPaymentSuccess(
    providerTransactionId: string,
    paymentIdOrReference: string,
    provider: PaymentProvider,
  ) {
    try {
      // Find payment by ID or reference
      const payment = await this.findPayment(paymentIdOrReference, provider);

      if (!payment) {
        this.logger.warn(
          `Payment not found: ${paymentIdOrReference} for provider ${provider}`,
        );
        return { received: true, handled: false };
      }

      // Update payment status to COMPLETED
      await this.prisma.payment.update({
        where: { id: payment.id },
        data: {
          status: PaymentStatus.COMPLETED,
          providerTransactionId:
            providerTransactionId || payment.providerTransactionId,
          paidAt: new Date(),
        },
      });

      // If this is for a subscription, update subscription status
      if (payment.userSubscriptionId) {
        await this.prisma.userSubscription.update({
          where: { id: payment.userSubscriptionId },
          data: { status: SubscriptionStatus.ACTIVE },
        });
      }

      this.logger.log(
        `Successfully processed payment success for ${payment.id}`,
      );
      return { received: true, handled: true, paymentId: payment.id };
    } catch (error) {
      this.logger.error(
        `Error processing payment success: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  private async processPaymentFailure(
    providerTransactionId: string,
    paymentIdOrReference: string,
    provider: PaymentProvider,
  ) {
    try {
      const payment = await this.findPayment(paymentIdOrReference, provider);

      if (!payment) {
        this.logger.warn(
          `Payment not found: ${paymentIdOrReference} for provider ${provider}`,
        );
        return { received: true, handled: false };
      }

      // Update payment status to FAILED
      await this.prisma.payment.update({
        where: { id: payment.id },
        data: {
          status: PaymentStatus.FAILED,
          providerTransactionId:
            providerTransactionId || payment.providerTransactionId,
        },
      });

      this.logger.log(
        `Successfully processed payment failure for ${payment.id}`,
      );
      return { received: true, handled: true, paymentId: payment.id };
    } catch (error) {
      this.logger.error(
        `Error processing payment failure: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  private async processPaymentRefund(
    providerTransactionId: string,
    paymentIdOrReference: string,
    provider: PaymentProvider,
  ) {
    try {
      const payment = await this.findPayment(paymentIdOrReference, provider);

      if (!payment) {
        this.logger.warn(
          `Payment not found: ${paymentIdOrReference} for provider ${provider}`,
        );
        return { received: true, handled: false };
      }

      // Update payment status to REFUNDED
      await this.prisma.payment.update({
        where: { id: payment.id },
        data: {
          status: PaymentStatus.REFUNDED,
          providerTransactionId:
            providerTransactionId || payment.providerTransactionId,
        },
      });

      // If this is for a subscription, update subscription status
      if (payment.userSubscriptionId) {
        await this.prisma.userSubscription.update({
          where: { id: payment.userSubscriptionId },
          data: { status: SubscriptionStatus.CANCELLED },
        });
      }

      this.logger.log(
        `Successfully processed payment refund for ${payment.id}`,
      );
      return { received: true, handled: true, paymentId: payment.id };
    } catch (error) {
      this.logger.error(
        `Error processing payment refund: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  private async processSubscriptionUpdate(
    providerSubscriptionId: string,
    paymentIdOrReference: string,
    expiryDate: string,
    provider: PaymentProvider,
  ) {
    try {
      const payment = await this.findPayment(paymentIdOrReference, provider);

      if (!payment || !payment.userSubscriptionId) {
        this.logger.warn(
          `Subscription not found for payment: ${paymentIdOrReference}`,
        );
        return { received: true, handled: false };
      }

      // Update subscription end date if provided
      if (expiryDate) {
        await this.prisma.userSubscription.update({
          where: { id: payment.userSubscriptionId },
          data: {
            status: SubscriptionStatus.ACTIVE,
            endDate: new Date(expiryDate),
          },
        });
      }

      this.logger.log(
        `Successfully processed subscription update for ${payment.userSubscriptionId}`,
      );
      return {
        received: true,
        handled: true,
        subscriptionId: payment.userSubscriptionId,
      };
    } catch (error) {
      this.logger.error(
        `Error processing subscription update: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  private async processSubscriptionCancellation(
    providerSubscriptionId: string,
    paymentIdOrReference: string,
    provider: PaymentProvider,
  ) {
    try {
      const payment = await this.findPayment(paymentIdOrReference, provider);

      if (!payment || !payment.userSubscriptionId) {
        this.logger.warn(
          `Subscription not found for payment: ${paymentIdOrReference}`,
        );
        return { received: true, handled: false };
      }

      // Update subscription status to CANCELLED
      await this.prisma.userSubscription.update({
        where: { id: payment.userSubscriptionId },
        data: {
          status: SubscriptionStatus.CANCELLED,
          autoRenew: false,
        },
      });

      this.logger.log(
        `Successfully processed subscription cancellation for ${payment.userSubscriptionId}`,
      );
      return {
        received: true,
        handled: true,
        subscriptionId: payment.userSubscriptionId,
      };
    } catch (error) {
      this.logger.error(
        `Error processing subscription cancellation: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  // Helper methods
  private async findPayment(
    paymentIdOrReference: string,
    provider: PaymentProvider,
  ) {
    // First try to find by ID
    let payment = await this.prisma.payment.findFirst({
      where: { id: paymentIdOrReference },
    });

    if (!payment) {
      // Then try to find by provider-specific IDs
      payment = await this.prisma.payment.findFirst({
        where: {
          paymentProvider: provider,
          OR: [
            { providerTransactionId: paymentIdOrReference },
            { providerPaymentId: paymentIdOrReference },
          ],
        },
      });
    }

    return payment;
  }

  private extractPaymentReference(
    orderInfo: string,
    extraData?: string,
  ): string {
    try {
      // Try to parse as JSON first
      try {
        const orderData = JSON.parse(orderInfo);
        if (orderData.paymentId) return orderData.paymentId;
      } catch {}

      // Try to extract from extraData if available
      if (extraData) {
        try {
          const extraDataObj = JSON.parse(
            Buffer.from(extraData, 'base64').toString(),
          );
          if (extraDataObj.paymentId) return extraDataObj.paymentId;
        } catch {}
      }

      // Default fallback - use orderInfo directly if no better option
      return orderInfo;
    } catch (error) {
      this.logger.error(`Error extracting payment reference: ${error.message}`);
      return orderInfo;
    }
  }

  private verifyMomoSignature(payload: MomoWebhookDto): boolean {
    try {
      const accessKey = this.configService.get<string>('MOMO_ACCESS_KEY');
      const secretKey = this.configService.get<string>('MOMO_SECRET_KEY');

      if (!accessKey || !secretKey) {
        this.logger.warn('MOMO_ACCESS_KEY or MOMO_SECRET_KEY not configured');
        return false;
      }

      // Construct raw signature string according to MoMo docs
      const rawSignature = `partnerCode=${payload.partnerCode}&accessKey=${accessKey}&requestId=${payload.requestId}&amount=${payload.amount}&orderId=${payload.orderId}&orderInfo=${payload.orderInfo}&orderType=${payload.orderType}&transId=${payload.transId}&message=${payload.message}&responseTime=${payload.responseTime}&resultCode=${payload.resultCode}&extraData=${payload.extraData}`;

      // Create HMAC-SHA256 signature
      const signature = crypto
        .createHmac('sha256', secretKey)
        .update(rawSignature)
        .digest('hex');

      return signature === payload.signature;
    } catch (error) {
      this.logger.error(`Error verifying MoMo signature: ${error.message}`);
      return false;
    }
  }

  private verifyZaloPaySignature(payload: ZaloPayWebhookDto): boolean {
    try {
      const key1 = this.configService.get<string>('ZALOPAY_KEY1');

      if (!key1) {
        this.logger.warn('ZALOPAY_KEY1 not configured');
        return false;
      }

      // Construct data string according to ZaloPay docs
      const data = `${payload.app_id}|${payload.app_trans_id}|${payload.app_user}|${payload.amount}|${payload.app_time}|${payload.embed_data}|${payload.item}`;

      // Create HMAC-SHA256 signature
      const mac = crypto.createHmac('sha256', key1).update(data).digest('hex');

      return mac === payload.signature;
    } catch (error) {
      this.logger.error(`Error verifying ZaloPay signature: ${error.message}`);
      return false;
    }
  }
}
