# Subscription Management Bounded Context

## Overview

The Subscription Management bounded context handles all aspects of user subscriptions, payment processing, feature gating, and referral programs for the CareCircle AI agent service. This system implements a freemium model with healthcare-specific compliance requirements.

## Business Context

### Value Proposition
- **Free Tier**: Basic AI health consultations to attract users
- **Premium Tier**: Unlimited access with advanced features for individual users
- **Professional Tier**: Enhanced tools for healthcare providers

### Key Business Rules
1. Healthcare data must remain separate from subscription data (HIPAA compliance)
2. Feature access is determined by subscription tier and usage quotas
3. Referral rewards require actual subscription conversion to prevent fraud
4. All payment processing must be secure and compliant with healthcare regulations

## Domain Model

### Core Entities

#### Subscription
- **SubscriptionId**: Unique identifier
- **UserId**: Reference to user
- **Tier**: FREE, PREMIUM, PROFESSIONAL
- **Status**: ACTIVE, CANCELLED, EXPIRED, SUSPENDED
- **PaymentProvider**: APP_STORE, GOOGLE_PLAY, MOMO, STRIPE
- **StartDate**: Subscription start date
- **EndDate**: Subscription end date
- **AutoRenew**: Boolean flag for auto-renewal

#### Feature
- **FeatureId**: Unique identifier
- **Name**: Feature name (e.g., "ai_consultations", "health_analytics")
- **Type**: CONSUMABLE, NON_CONSUMABLE, QUOTA
- **Description**: Human-readable description
- **Tier**: Minimum tier required for access

#### UserFeatureUsage
- **UserId**: Reference to user
- **FeatureId**: Reference to feature
- **UsageCount**: Current usage count
- **QuotaLimit**: Maximum allowed usage
- **ResetPeriod**: DAILY, WEEKLY, MONTHLY
- **LastReset**: Last quota reset timestamp

#### Referral
- **ReferralId**: Unique identifier
- **ReferrerId**: User who made the referral
- **RefereeId**: User who was referred
- **ReferralCode**: Unique referral code
- **Status**: PENDING, COMPLETED, EXPIRED
- **RewardClaimed**: Boolean flag
- **CreatedAt**: Referral creation timestamp

## Subscription Tiers

### Free Tier
**Features:**
- 5 AI consultations per month
- Basic health tracking
- Standard response time (up to 30 seconds)
- Community support only
- Basic health insights

**Limitations:**
- No data export
- No family sharing
- No priority support
- Limited health analytics

### Premium Tier ($9.99/month)
**Features:**
- Unlimited AI consultations
- Advanced health analytics
- Priority response time (under 10 seconds)
- Personalized health insights
- Data export capabilities
- Family sharing (up to 4 members)
- Email support
- Medication reminders
- Health goal tracking

**Target Audience:** Individual users and families

### Professional Tier ($29.99/month)
**Features:**
- All Premium features
- Patient management tools
- Clinical decision support
- EMR system integration
- Compliance reporting
- White-label options
- Priority phone support
- Advanced analytics dashboard
- Bulk user management

**Target Audience:** Healthcare providers, clinics, small practices

## Feature Gating System

### Implementation Strategy
1. **Middleware-based checking**: All API endpoints check feature access
2. **Quota tracking**: Real-time usage monitoring with automatic resets
3. **Graceful degradation**: Clear messaging when limits are reached
4. **Upgrade prompts**: Contextual suggestions to upgrade subscription

### Feature Categories

#### Consumable Features (with quotas)
- AI consultations
- Health report generations
- Medication interaction checks
- Symptom assessments

#### Non-Consumable Features (tier-based)
- Advanced analytics
- Data export
- Family sharing
- Priority support
- EMR integration

#### Quota Features (storage-based)
- Health data storage
- Document uploads
- Image storage for prescriptions

## Rate Limiting Strategy

### Free Tier Limits
- AI consultations: 5 per month
- Health reports: 2 per month
- API requests: 100 per hour
- Data storage: 100MB

### Premium Tier Limits
- AI consultations: Unlimited
- Health reports: Unlimited
- API requests: 1000 per hour
- Data storage: 5GB

### Professional Tier Limits
- AI consultations: Unlimited
- Health reports: Unlimited
- API requests: 10000 per hour
- Data storage: 50GB
- Patient records: 1000 active patients

## Integration Points

### Internal Systems
- **Identity & Access**: User authentication and authorization
- **AI Assistant**: Feature access validation
- **Health Data**: Storage quota management
- **Notification**: Subscription status updates

### External Systems
- **RevenueCat**: Mobile app store payment processing
- **Stripe**: Direct payment processing
- **MoMo**: African market payment processing
- **Firebase**: User authentication and analytics

## Events

### Domain Events
- `SubscriptionCreated`
- `SubscriptionUpgraded`
- `SubscriptionDowngraded`
- `SubscriptionCancelled`
- `SubscriptionExpired`
- `FeatureUsageExceeded`
- `QuotaReset`
- `ReferralCompleted`
- `PaymentFailed`
- `PaymentSucceeded`

### Event Handlers
- Update feature access permissions
- Send notification to users
- Update analytics and reporting
- Trigger referral rewards
- Handle payment failures

## Security Considerations

### Data Protection
- Subscription data encrypted at rest
- PCI DSS compliance for payment processing
- Separate encryption keys for payment data
- Regular security audits

### Access Control
- Role-based access to subscription management
- API rate limiting per subscription tier
- Secure webhook endpoints with signature verification
- Audit logging for all subscription changes

## Compliance Requirements

### HIPAA Compliance
- Subscription data kept separate from PHI
- Business Associate Agreements with payment processors
- Audit trails for all subscription activities
- User consent for data processing

### International Compliance
- GDPR compliance for European users
- Right to data deletion
- Clear privacy policies
- Local payment regulations compliance

## Next Steps

1. **Technical Implementation**: Detailed API specifications and database schema
2. **Payment Integration**: Implementation guides for each payment provider
3. **Referral System**: Complete referral program mechanics
4. **User Experience**: Mobile app flow documentation
5. **Testing Strategy**: Comprehensive testing approach for subscription flows

## Related Documentation

- [Payment Integration Guide](./payment-integration.md)
- [Referral System Design](./referral-system.md)
- [Technical Specifications](./technical-specifications.md)
- [Compliance and Security](./compliance-security.md)
- [User Experience Flows](./user-experience-flows.md)
