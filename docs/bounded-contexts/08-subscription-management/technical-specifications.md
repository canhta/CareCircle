# Subscription Management Technical Specifications

## Architecture Overview

The subscription management system follows a microservices architecture with clear separation of concerns:

- **Subscription Service**: Core subscription logic and state management
- **Payment Service**: Payment processing and webhook handling
- **Feature Gate Service**: Feature access validation and quota management
- **Referral Service**: Referral program mechanics and reward processing

## Database Schema

### Subscriptions Table
```sql
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    tier VARCHAR(20) NOT NULL CHECK (tier IN ('FREE', 'PREMIUM', 'PROFESSIONAL')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('ACTIVE', 'CANCELLED', 'EXPIRED', 'SUSPENDED')),
    payment_provider VARCHAR(20) CHECK (payment_provider IN ('APP_STORE', 'GOOGLE_PLAY', 'MOMO', 'STRIPE')),
    external_subscription_id VARCHAR(255),
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE,
    auto_renew BOOLEAN DEFAULT true,
    trial_end_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_external_id ON subscriptions(external_subscription_id);
```

### Features Table
```sql
CREATE TABLE features (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    display_name VARCHAR(200) NOT NULL,
    description TEXT,
    feature_type VARCHAR(20) NOT NULL CHECK (feature_type IN ('CONSUMABLE', 'NON_CONSUMABLE', 'QUOTA')),
    minimum_tier VARCHAR(20) NOT NULL CHECK (minimum_tier IN ('FREE', 'PREMIUM', 'PROFESSIONAL')),
    quota_limit INTEGER,
    quota_period VARCHAR(20) CHECK (quota_period IN ('DAILY', 'WEEKLY', 'MONTHLY')),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_features_name ON features(name);
CREATE INDEX idx_features_tier ON features(minimum_tier);
```

### User Feature Usage Table
```sql
CREATE TABLE user_feature_usage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    feature_id UUID NOT NULL REFERENCES features(id),
    usage_count INTEGER DEFAULT 0,
    last_used_at TIMESTAMP WITH TIME ZONE,
    quota_reset_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, feature_id)
);

CREATE INDEX idx_user_feature_usage_user_id ON user_feature_usage(user_id);
CREATE INDEX idx_user_feature_usage_feature_id ON user_feature_usage(feature_id);
```

### Referrals Table
```sql
CREATE TABLE referrals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    referrer_id UUID NOT NULL REFERENCES users(id),
    referee_id UUID REFERENCES users(id),
    referral_code VARCHAR(50) NOT NULL UNIQUE,
    status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'COMPLETED', 'EXPIRED')),
    reward_type VARCHAR(50),
    reward_value INTEGER,
    reward_claimed BOOLEAN DEFAULT false,
    reward_claimed_at TIMESTAMP WITH TIME ZONE,
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_referrals_referrer_id ON referrals(referrer_id);
CREATE INDEX idx_referrals_referee_id ON referrals(referee_id);
CREATE INDEX idx_referrals_code ON referrals(referral_code);
```

### Payment Transactions Table
```sql
CREATE TABLE payment_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subscription_id UUID NOT NULL REFERENCES subscriptions(id),
    transaction_id VARCHAR(255) NOT NULL,
    payment_provider VARCHAR(20) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED')),
    provider_response JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_payment_transactions_subscription_id ON payment_transactions(subscription_id);
CREATE INDEX idx_payment_transactions_transaction_id ON payment_transactions(transaction_id);
```

## API Endpoints

### Subscription Management

#### Get User Subscription Status
```typescript
GET /api/v1/subscription/status
Authorization: Bearer <token>

Response:
{
  "subscription": {
    "id": "uuid",
    "tier": "PREMIUM",
    "status": "ACTIVE",
    "startDate": "2024-01-01T00:00:00Z",
    "endDate": "2024-02-01T00:00:00Z",
    "autoRenew": true,
    "trialEndDate": null
  },
  "features": [
    {
      "name": "ai_consultations",
      "available": true,
      "usageCount": 15,
      "quotaLimit": null
    }
  ]
}
```

#### Upgrade Subscription
```typescript
POST /api/v1/subscription/upgrade
Authorization: Bearer <token>
Content-Type: application/json

{
  "targetTier": "PREMIUM",
  "paymentProvider": "APP_STORE",
  "paymentToken": "payment_token_from_client"
}

Response:
{
  "success": true,
  "subscription": {
    "id": "uuid",
    "tier": "PREMIUM",
    "status": "ACTIVE"
  }
}
```

### Feature Management

#### Check Feature Access
```typescript
GET /api/v1/features/{featureName}/access
Authorization: Bearer <token>

Response:
{
  "hasAccess": true,
  "usageCount": 5,
  "quotaLimit": 100,
  "quotaResetAt": "2024-01-01T00:00:00Z"
}
```

#### Consume Feature
```typescript
POST /api/v1/features/{featureName}/consume
Authorization: Bearer <token>
Content-Type: application/json

{
  "amount": 1,
  "metadata": {
    "sessionId": "session_123"
  }
}

Response:
{
  "success": true,
  "remainingUsage": 99,
  "quotaResetAt": "2024-01-01T00:00:00Z"
}
```

### Referral System

#### Create Referral Code
```typescript
POST /api/v1/referrals/create
Authorization: Bearer <token>

Response:
{
  "referralCode": "HEALTH2024ABC",
  "referralLink": "https://carecircle.app/ref/HEALTH2024ABC",
  "expiresAt": "2024-12-31T23:59:59Z"
}
```

#### Claim Referral Reward
```typescript
POST /api/v1/referrals/claim
Authorization: Bearer <token>
Content-Type: application/json

{
  "referralId": "uuid"
}

Response:
{
  "success": true,
  "reward": {
    "type": "SUBSCRIPTION_EXTENSION",
    "value": 30,
    "description": "30 days free premium"
  }
}
```

## Service Interfaces

### SubscriptionService
```typescript
interface SubscriptionService {
  getUserSubscription(userId: string): Promise<Subscription>;
  createSubscription(userId: string, tier: SubscriptionTier, paymentData: PaymentData): Promise<Subscription>;
  upgradeSubscription(subscriptionId: string, targetTier: SubscriptionTier): Promise<Subscription>;
  cancelSubscription(subscriptionId: string): Promise<void>;
  renewSubscription(subscriptionId: string): Promise<Subscription>;
  handlePaymentWebhook(provider: PaymentProvider, payload: any): Promise<void>;
}
```

### FeatureGateService
```typescript
interface FeatureGateService {
  checkFeatureAccess(userId: string, featureName: string): Promise<FeatureAccess>;
  consumeFeature(userId: string, featureName: string, amount: number): Promise<FeatureUsage>;
  getFeatureUsage(userId: string, featureName: string): Promise<FeatureUsage>;
  resetQuotas(period: QuotaPeriod): Promise<void>;
}
```

### ReferralService
```typescript
interface ReferralService {
  createReferralCode(userId: string): Promise<Referral>;
  processReferralSignup(referralCode: string, newUserId: string): Promise<void>;
  completeReferral(referralId: string): Promise<void>;
  claimReferralReward(userId: string, referralId: string): Promise<ReferralReward>;
  getReferralStats(userId: string): Promise<ReferralStats>;
}
```

## Event System

### Event Types
```typescript
enum SubscriptionEventType {
  SUBSCRIPTION_CREATED = 'subscription.created',
  SUBSCRIPTION_UPGRADED = 'subscription.upgraded',
  SUBSCRIPTION_CANCELLED = 'subscription.cancelled',
  SUBSCRIPTION_EXPIRED = 'subscription.expired',
  PAYMENT_SUCCEEDED = 'payment.succeeded',
  PAYMENT_FAILED = 'payment.failed',
  FEATURE_QUOTA_EXCEEDED = 'feature.quota_exceeded',
  REFERRAL_COMPLETED = 'referral.completed'
}
```

### Event Handlers
```typescript
@EventHandler(SubscriptionEventType.SUBSCRIPTION_CREATED)
async handleSubscriptionCreated(event: SubscriptionCreatedEvent) {
  // Initialize feature usage records
  // Send welcome notification
  // Update analytics
}

@EventHandler(SubscriptionEventType.FEATURE_QUOTA_EXCEEDED)
async handleQuotaExceeded(event: QuotaExceededEvent) {
  // Send upgrade suggestion notification
  // Log usage analytics
}
```

## Integration Patterns

### Payment Provider Integration
```typescript
interface PaymentProvider {
  createSubscription(subscriptionData: SubscriptionData): Promise<PaymentResult>;
  cancelSubscription(externalSubscriptionId: string): Promise<void>;
  handleWebhook(payload: any, signature: string): Promise<WebhookEvent>;
  validateReceipt(receipt: string): Promise<ReceiptValidation>;
}
```

### Webhook Security
```typescript
class WebhookValidator {
  validateSignature(payload: string, signature: string, secret: string): boolean {
    const expectedSignature = crypto
      .createHmac('sha256', secret)
      .update(payload)
      .digest('hex');
    return crypto.timingSafeEqual(
      Buffer.from(signature),
      Buffer.from(expectedSignature)
    );
  }
}
```

## Error Handling

### Custom Exceptions
```typescript
class SubscriptionError extends Error {
  constructor(message: string, public code: string) {
    super(message);
  }
}

class InsufficientQuotaError extends SubscriptionError {
  constructor(featureName: string, currentUsage: number, limit: number) {
    super(`Quota exceeded for ${featureName}: ${currentUsage}/${limit}`, 'QUOTA_EXCEEDED');
  }
}

class InvalidSubscriptionTierError extends SubscriptionError {
  constructor(requiredTier: string, currentTier: string) {
    super(`Feature requires ${requiredTier} tier, current: ${currentTier}`, 'INSUFFICIENT_TIER');
  }
}
```

## Performance Considerations

### Caching Strategy
- User subscription status: Redis cache with 5-minute TTL
- Feature access permissions: In-memory cache with event-based invalidation
- Usage quotas: Redis with atomic increment operations

### Database Optimization
- Partitioning payment_transactions by month
- Indexing on frequently queried fields
- Read replicas for analytics queries

## Monitoring and Observability

### Key Metrics
- Subscription conversion rates by tier
- Feature usage patterns
- Payment failure rates
- Referral completion rates
- API response times

### Alerting
- Payment webhook failures
- High quota usage patterns
- Subscription cancellation spikes
- API error rate thresholds

## Security Measures

### API Security
- JWT token validation
- Rate limiting per subscription tier
- Input validation and sanitization
- SQL injection prevention

### Data Protection
- Encryption at rest for sensitive data
- PCI DSS compliance for payment data
- Regular security audits
- Secure key management
