# Referral System Design

## Overview

The CareCircle referral system is designed to drive organic user acquisition through word-of-mouth marketing while maintaining healthcare industry standards and compliance requirements. The system rewards both referrers and referees to create a win-win growth mechanism.

## Business Objectives

### Primary Goals

1. **User Acquisition**: Reduce customer acquisition cost (CAC) through organic referrals
2. **User Engagement**: Increase existing user engagement through referral activities
3. **Network Effects**: Build health communities and care circles
4. **Revenue Growth**: Convert referred users to paid subscriptions

### Success Metrics

- Referral conversion rate: Target 15-20%
- Referred user retention: Target 80% at 30 days
- Referral program participation: Target 25% of active users
- Cost per acquisition via referrals: Target 50% lower than paid channels

## Referral Program Mechanics

### Referrer Rewards (Person Making Referral)

#### Reward Structure

1. **Free Premium Month**: 30 days of Premium subscription
2. **Subscription Credits**: $10 credit toward next subscription payment
3. **Feature Unlocks**: Temporary access to Professional features
4. **Family Slots**: Additional family member slots for Premium users

#### Reward Conditions

- Referee must complete email verification
- Referee must use the app for at least 3 days
- Referee must complete their first paid subscription
- Maximum 5 successful referrals per month per user

### Referee Rewards (Person Being Referred)

#### Welcome Benefits

1. **Extended Free Trial**: 30 days instead of standard 7 days
2. **Bonus AI Consultations**: 10 additional free consultations
3. **Priority Onboarding**: Faster response times during trial
4. **Welcome Health Assessment**: Free comprehensive health analysis

#### Conversion Incentives

- 20% discount on first subscription payment
- Free health goal setting session
- Priority customer support for first month

## Referral Code System

### Code Generation

```typescript
interface ReferralCode {
  code: string; // e.g., "HEALTH2024ABC"
  referrerId: string; // User who created the referral
  createdAt: Date;
  expiresAt: Date; // 90 days from creation
  maxUses: number; // Default: 10
  currentUses: number;
  isActive: boolean;
}
```

### Code Format

- **Pattern**: `HEALTH{YEAR}{3-RANDOM-CHARS}`
- **Example**: `HEALTH2024XYZ`
- **Benefits**: Memorable, branded, unique

### Deep Link Structure

```
https://carecircle.app/ref/{REFERRAL_CODE}
?utm_source=referral
&utm_medium=social
&utm_campaign=user_referral
```

## Implementation Architecture

### Frontend Components

#### Referral Dashboard

```dart
class ReferralDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReferralStatsCard(),
        ReferralCodeGenerator(),
        ShareButtons(),
        ReferralHistoryList(),
        RewardClaimSection(),
      ],
    );
  }
}
```

#### Share Integration

```dart
class ReferralShareService {
  static Future<void> shareReferralCode(String code, String link) async {
    const String message = '''
🏥 Join me on CareCircle - Your AI Health Assistant!

Get personalized health insights, medication reminders, and 24/7 AI health consultations.

Use my referral code: $code
Download: $link

You'll get 30 days free premium access!
    ''';

    await Share.share(
      message,
      subject: 'Join CareCircle - AI Health Assistant',
    );
  }
}
```

### Backend Services

#### Referral Service

```typescript
@Injectable()
export class ReferralService {
  async createReferralCode(userId: string): Promise<ReferralCode> {
    const code = this.generateUniqueCode();
    const referral = await this.referralRepository.create({
      code,
      referrerId: userId,
      expiresAt: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000), // 90 days
      maxUses: 10,
      currentUses: 0,
      isActive: true,
    });

    return referral;
  }

  async processReferralSignup(code: string, newUserId: string): Promise<void> {
    const referral = await this.findActiveReferralByCode(code);
    if (!referral) throw new Error("Invalid referral code");

    // Create referral relationship
    await this.createReferralRelationship(referral.referrerId, newUserId, code);

    // Apply referee benefits
    await this.applyRefereeBenefits(newUserId);

    // Update referral usage
    await this.incrementReferralUsage(referral.id);
  }

  async completeReferral(referralId: string): Promise<void> {
    const referral = await this.findReferralById(referralId);

    // Mark referral as completed
    await this.updateReferralStatus(referralId, "COMPLETED");

    // Apply referrer rewards
    await this.applyReferrerRewards(referral.referrerId);

    // Send notifications
    await this.notifyReferralCompletion(referral);
  }
}
```

#### Deep Link Handler

```typescript
@Controller("ref")
export class ReferralController {
  @Get(":code")
  async handleReferralLink(
    @Param("code") code: string,
    @Res() response: Response,
  ) {
    const referral = await this.referralService.validateReferralCode(code);

    if (!referral) {
      return response.redirect("https://carecircle.app/download");
    }

    // Store referral code in session/cookie for later attribution
    response.cookie("referral_code", code, {
      maxAge: 30 * 24 * 60 * 60 * 1000, // 30 days
      httpOnly: true,
      secure: true,
    });

    // Redirect to app store or web app
    const userAgent = request.headers["user-agent"];
    if (userAgent.includes("iPhone") || userAgent.includes("iPad")) {
      return response.redirect("https://apps.apple.com/app/carecircle");
    } else if (userAgent.includes("Android")) {
      return response.redirect(
        "https://play.google.com/store/apps/details?id=com.carecircle.app",
      );
    } else {
      return response.redirect("https://carecircle.app/download");
    }
  }
}
```

## Fraud Prevention

### Detection Mechanisms

1. **Device Fingerprinting**: Prevent same-device referrals
2. **Email Domain Analysis**: Flag suspicious email patterns
3. **Behavioral Analysis**: Monitor user interaction patterns
4. **Payment Verification**: Require actual payment for reward completion
5. **Rate Limiting**: Limit referral creation and usage rates

### Prevention Rules

```typescript
class ReferralFraudDetection {
  async validateReferral(
    referrerId: string,
    refereeId: string,
  ): Promise<boolean> {
    // Check if users share same device fingerprint
    if (await this.sharesSameDevice(referrerId, refereeId)) {
      return false;
    }

    // Check if referee email is suspicious
    if (await this.isSuspiciousEmail(refereeId)) {
      return false;
    }

    // Check referrer's recent referral activity
    if (await this.hasExcessiveReferralActivity(referrerId)) {
      return false;
    }

    // Check if users are in same household (IP-based)
    if (await this.sharesSameHousehold(referrerId, refereeId)) {
      return false;
    }

    return true;
  }
}
```

## Healthcare-Specific Considerations

### Privacy Protection

- No sharing of health data in referral process
- Anonymous referral tracking
- HIPAA-compliant referral communications
- Clear consent for referral program participation

### Ethical Guidelines

- No incentives for sharing health information
- Clear disclosure of referral relationships
- Professional boundaries for healthcare provider referrals
- Compliance with medical marketing regulations

### Professional Referrals

```typescript
interface HealthcareProviderReferral {
  providerId: string;
  providerType: "DOCTOR" | "NURSE" | "THERAPIST" | "CLINIC";
  licenseNumber: string;
  specialRewards: {
    patientOnboardingBonus: number;
    professionalTierDiscount: number;
    continuingEducationCredits: number;
  };
}
```

## Viral Growth Strategies

### Social Sharing Optimization

1. **Pre-filled Messages**: Healthcare-appropriate sharing templates
2. **Visual Assets**: Shareable health infographics
3. **Success Stories**: Anonymous user testimonials
4. **Educational Content**: Health tips with referral integration

### Community Building

1. **Family Health Circles**: Encourage family member invitations
2. **Health Challenges**: Group activities with referral bonuses
3. **Support Groups**: Condition-specific communities
4. **Provider Networks**: Healthcare professional referral programs

### Timing Strategies

1. **Post-Consultation**: Share after positive AI interaction
2. **Health Milestones**: Celebrate health goal achievements
3. **Medication Reminders**: Include referral in reminder notifications
4. **Health Reports**: Add referral option to health summaries

## User Experience Flows

### Referral Creation Flow

1. User accesses referral section in app
2. System generates unique referral code
3. User customizes sharing message
4. User shares via preferred channel
5. System tracks sharing activity

### Referral Signup Flow

1. New user clicks referral link
2. System captures referral attribution
3. User downloads and installs app
4. User creates account with extended trial
5. System applies referee benefits
6. User receives welcome notification

### Reward Claiming Flow

1. System detects referral conversion
2. Referrer receives notification
3. User navigates to rewards section
4. User claims available rewards
5. System applies rewards to account
6. User receives confirmation

## Analytics and Reporting

### Key Performance Indicators

```typescript
interface ReferralAnalytics {
  totalReferrals: number;
  successfulReferrals: number;
  conversionRate: number;
  averageTimeToConversion: number;
  topReferrers: User[];
  referralsByChannel: ChannelStats[];
  rewardsClaimed: RewardStats[];
  fraudAttempts: number;
}
```

### Reporting Dashboard

- Real-time referral activity
- Conversion funnel analysis
- Reward distribution tracking
- Fraud detection alerts
- ROI analysis by referral source

## A/B Testing Framework

### Test Scenarios

1. **Reward Amounts**: Test different reward values
2. **Reward Types**: Compare credits vs. free time
3. **Messaging**: Test different sharing templates
4. **Timing**: Optimize referral prompt timing
5. **UI Placement**: Test referral button locations

### Success Metrics

- Referral creation rate
- Share completion rate
- Click-through rate on referral links
- Signup conversion rate
- Long-term user retention

## Implementation Roadmap

### Phase 1: Core System (Month 1-2)

- Basic referral code generation
- Deep link handling
- Referral tracking
- Simple reward system

### Phase 2: Enhanced Features (Month 3-4)

- Advanced fraud detection
- Multiple reward types
- Analytics dashboard
- A/B testing framework

### Phase 3: Optimization (Month 5-6)

- Machine learning fraud detection
- Personalized referral strategies
- Advanced analytics
- Healthcare provider program

## Compliance and Legal

### Terms and Conditions

- Clear referral program rules
- Reward eligibility requirements
- Fraud prevention policies
- Privacy protection measures

### Healthcare Regulations

- HIPAA compliance verification
- Medical marketing law compliance
- Professional referral guidelines
- International healthcare regulations

### Data Protection

- GDPR compliance for referral data
- User consent management
- Data retention policies
- Right to deletion implementation
