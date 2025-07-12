# Payment Integration Guide

## Overview

CareCircle supports multiple payment providers to maximize accessibility and reduce transaction costs:

1. **RevenueCat** - Unified mobile app store payments (iOS/Android)
2. **MoMo** - African mobile money payments
3. **Stripe** - Direct web payments and backup option

## RevenueCat Integration (Primary Mobile)

### Why RevenueCat?

- Unified API for both Apple App Store and Google Play
- Handles subscription lifecycle automatically
- Built-in receipt validation and fraud protection
- Excellent Flutter SDK support
- Comprehensive analytics and webhooks

### Implementation

#### Flutter SDK Setup

```yaml
# pubspec.yaml
dependencies:
  purchases_flutter: ^6.15.0
```

#### Configuration

```dart
// lib/services/subscription_service.dart
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionService {
  static const String _revenueCatApiKey = 'YOUR_REVENUECAT_API_KEY';

  static Future<void> initialize() async {
    PurchasesConfiguration configuration = PurchasesConfiguration(_revenueCatApiKey);
    configuration.storeKitVersion = StoreKitVersion.storeKit2;
    configuration.shouldShowInAppMessagesAutomatically = false;

    await Purchases.configure(configuration);

    // Set up listener for subscription changes
    Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdate);
  }

  static void _onCustomerInfoUpdate(CustomerInfo customerInfo) {
    // Update local subscription state
    _updateLocalSubscriptionState(customerInfo);
  }
}
```

#### Product Configuration

```dart
// Define subscription products
class SubscriptionProducts {
  static const String premiumMonthly = 'premium_monthly';
  static const String premiumYearly = 'premium_yearly';
  static const String professionalMonthly = 'professional_monthly';
  static const String professionalYearly = 'professional_yearly';

  static const Map<String, String> productTiers = {
    premiumMonthly: 'PREMIUM',
    premiumYearly: 'PREMIUM',
    professionalMonthly: 'PROFESSIONAL',
    professionalYearly: 'PROFESSIONAL',
  };
}
```

#### Purchase Flow

```dart
Future<PurchaseResult> purchaseSubscription(String productId) async {
  try {
    final offerings = await Purchases.getOfferings();
    final product = offerings.current?.availablePackages
        .firstWhere((package) => package.storeProduct.identifier == productId);

    if (product == null) {
      throw Exception('Product not found: $productId');
    }

    final purchaseResult = await Purchases.purchasePackage(product);

    // Update backend subscription state
    await _updateBackendSubscription(purchaseResult.customerInfo);

    return purchaseResult;
  } on PlatformException catch (e) {
    throw SubscriptionException('Purchase failed: ${e.message}');
  }
}
```

#### Webhook Handling (Backend)

```typescript
// backend/src/subscription/revenuecat-webhook.controller.ts
@Controller("webhooks/revenuecat")
export class RevenueCatWebhookController {
  @Post()
  async handleWebhook(@Body() payload: any, @Headers() headers: any) {
    // Verify webhook signature
    const isValid = this.verifyWebhookSignature(payload, headers);
    if (!isValid) {
      throw new UnauthorizedException("Invalid webhook signature");
    }

    const event = payload.event;
    const customerInfo = event.product_id;

    switch (event.type) {
      case "INITIAL_PURCHASE":
        await this.handleInitialPurchase(event);
        break;
      case "RENEWAL":
        await this.handleRenewal(event);
        break;
      case "CANCELLATION":
        await this.handleCancellation(event);
        break;
      case "EXPIRATION":
        await this.handleExpiration(event);
        break;
    }
  }
}
```

### Pricing Strategy

- **Premium Monthly**: $9.99 (after 30% App Store fee: $6.99 revenue)
- **Premium Yearly**: $99.99 (after 30% App Store fee: $69.99 revenue)
- **Professional Monthly**: $29.99 (after 30% App Store fee: $20.99 revenue)
- **Professional Yearly**: $299.99 (after 30% App Store fee: $209.99 revenue)

## MoMo Payment Integration

### Why MoMo?

- Popular in African markets (Uganda, Ghana, Zambia, etc.)
- Lower transaction fees (2-5% vs 30% app stores)
- Direct mobile money integration
- No app store restrictions

### API Integration

#### Authentication

```typescript
// backend/src/payment/momo.service.ts
export class MoMoService {
  private readonly apiKey = process.env.MOMO_API_KEY;
  private readonly apiSecret = process.env.MOMO_API_SECRET;
  private readonly baseUrl = "https://sandbox.momodeveloper.mtn.com"; // Use production URL in prod

  async getAccessToken(): Promise<string> {
    const credentials = Buffer.from(
      `${this.apiKey}:${this.apiSecret}`,
    ).toString("base64");

    const response = await fetch(`${this.baseUrl}/collection/token/`, {
      method: "POST",
      headers: {
        Authorization: `Basic ${credentials}`,
        "Content-Type": "application/json",
        "Ocp-Apim-Subscription-Key": this.apiKey,
      },
    });

    const data = await response.json();
    return data.access_token;
  }
}
```

#### Payment Request

```typescript
async requestPayment(paymentData: MoMoPaymentRequest): Promise<MoMoPaymentResponse> {
  const token = await this.getAccessToken();
  const transactionId = uuidv4();

  const payload = {
    amount: paymentData.amount,
    currency: 'EUR', // or local currency
    externalId: transactionId,
    payer: {
      partyIdType: 'MSISDN',
      partyId: paymentData.phoneNumber
    },
    payerMessage: `CareCircle ${paymentData.subscriptionTier} subscription`,
    payeeNote: `Subscription payment for user ${paymentData.userId}`
  };

  const response = await fetch(`${this.baseUrl}/collection/v1_0/requesttopay`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json',
      'X-Reference-Id': transactionId,
      'X-Target-Environment': 'sandbox', // 'production' in prod
      'Ocp-Apim-Subscription-Key': this.apiKey
    },
    body: JSON.stringify(payload)
  });

  return {
    transactionId,
    status: response.status === 202 ? 'PENDING' : 'FAILED'
  };
}
```

#### Payment Status Check

```typescript
async checkPaymentStatus(transactionId: string): Promise<PaymentStatus> {
  const token = await this.getAccessToken();

  const response = await fetch(`${this.baseUrl}/collection/v1_0/requesttopay/${transactionId}`, {
    method: 'GET',
    headers: {
      'Authorization': `Bearer ${token}`,
      'X-Target-Environment': 'sandbox',
      'Ocp-Apim-Subscription-Key': this.apiKey
    }
  });

  const data = await response.json();
  return {
    transactionId,
    status: data.status, // PENDING, SUCCESSFUL, FAILED
    amount: data.amount,
    currency: data.currency
  };
}
```

### Frontend Integration

```dart
// lib/services/momo_payment_service.dart
class MoMoPaymentService {
  static const String baseUrl = 'https://api.carecircle.app';

  Future<PaymentResult> initiatePayment({
    required String phoneNumber,
    required double amount,
    required String subscriptionTier,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/payment/momo/initiate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phoneNumber': phoneNumber,
        'amount': amount,
        'subscriptionTier': subscriptionTier,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaymentResult(
        transactionId: data['transactionId'],
        status: data['status'],
      );
    } else {
      throw PaymentException('Payment initiation failed');
    }
  }

  Future<PaymentStatus> checkPaymentStatus(String transactionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/payment/momo/status/$transactionId'),
    );

    final data = jsonDecode(response.body);
    return PaymentStatus.fromJson(data);
  }
}
```

### Pricing Strategy (MoMo)

- **Premium Monthly**: $8.99 (lower due to reduced fees)
- **Premium Yearly**: $89.99
- **Professional Monthly**: $24.99
- **Professional Yearly**: $249.99

## Stripe Integration (Backup/Web)

### Use Cases

- Web-based subscriptions
- Backup payment method
- Markets where app stores are restricted
- Corporate/enterprise customers

### Implementation

```typescript
// backend/src/payment/stripe.service.ts
import Stripe from "stripe";

export class StripeService {
  private stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

  async createSubscription(
    customerId: string,
    priceId: string,
  ): Promise<Stripe.Subscription> {
    return await this.stripe.subscriptions.create({
      customer: customerId,
      items: [{ price: priceId }],
      payment_behavior: "default_incomplete",
      expand: ["latest_invoice.payment_intent"],
    });
  }

  async handleWebhook(payload: string, signature: string): Promise<void> {
    const event = this.stripe.webhooks.constructEvent(
      payload,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET,
    );

    switch (event.type) {
      case "customer.subscription.created":
        await this.handleSubscriptionCreated(event.data.object);
        break;
      case "customer.subscription.updated":
        await this.handleSubscriptionUpdated(event.data.object);
        break;
      case "customer.subscription.deleted":
        await this.handleSubscriptionCancelled(event.data.object);
        break;
      case "invoice.payment_succeeded":
        await this.handlePaymentSucceeded(event.data.object);
        break;
      case "invoice.payment_failed":
        await this.handlePaymentFailed(event.data.object);
        break;
    }
  }
}
```

## Payment Provider Comparison

| Feature                | RevenueCat      | MoMo   | Stripe     |
| ---------------------- | --------------- | ------ | ---------- |
| **Transaction Fee**    | 30% (App Store) | 2-5%   | 2.9% + 30¢ |
| **Setup Complexity**   | Medium          | High   | Medium     |
| **Mobile Integration** | Excellent       | Good   | Good       |
| **Global Reach**       | Worldwide       | Africa | Worldwide  |
| **Fraud Protection**   | Excellent       | Good   | Excellent  |
| **Recurring Billing**  | Automatic       | Manual | Automatic  |
| **Analytics**          | Excellent       | Basic  | Good       |
| **Compliance**         | App Store       | Local  | PCI DSS    |

## Implementation Strategy

### Phase 1: RevenueCat (Mobile Primary)

1. Implement RevenueCat for iOS and Android
2. Set up webhook handling
3. Create subscription management UI
4. Test with sandbox environment

### Phase 2: MoMo Integration

1. Integrate MoMo API for African markets
2. Create mobile payment flow
3. Implement payment status polling
4. Add regional pricing

### Phase 3: Stripe Backup

1. Add Stripe for web payments
2. Create fallback payment flow
3. Implement webhook handling
4. Add enterprise features

## Security Considerations

### Webhook Security

- Verify all webhook signatures
- Use HTTPS endpoints only
- Implement idempotency for webhook processing
- Log all payment events for audit

### Data Protection

- Never store payment card data
- Use tokenization for recurring payments
- Encrypt sensitive payment information
- Comply with PCI DSS requirements

### Fraud Prevention

- Implement rate limiting on payment endpoints
- Monitor for suspicious payment patterns
- Use device fingerprinting
- Require email verification for new accounts

## Testing Strategy

### Test Environments

- **RevenueCat**: Sandbox mode with test products
- **MoMo**: Sandbox environment with test phone numbers
- **Stripe**: Test mode with test cards

### Test Scenarios

1. Successful subscription purchase
2. Failed payment handling
3. Subscription cancellation
4. Webhook delivery failures
5. Refund processing
6. Subscription upgrades/downgrades

## Monitoring and Analytics

### Key Metrics

- Payment success rates by provider
- Average revenue per user (ARPU)
- Subscription churn rates
- Payment method preferences by region
- Transaction failure reasons

### Alerting

- Payment webhook failures
- High payment failure rates
- Subscription cancellation spikes
- Unusual payment patterns

## Compliance Requirements

### Healthcare Specific

- HIPAA compliance for payment data
- Separate payment and health data storage
- Business Associate Agreements with processors
- Audit trails for all transactions

### Regional Compliance

- GDPR for European users
- PCI DSS for card payments
- Local payment regulations
- Tax compliance by jurisdiction
