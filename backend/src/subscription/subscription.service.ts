import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  CreateSubscriptionPlanDto,
  UpdateSubscriptionPlanDto,
} from './dto/create-subscription-plan.dto';
import {
  CreateUserSubscriptionDto,
  UpdateUserSubscriptionDto,
} from './dto/subscription.dto';
import { CreatePaymentDto, UpdatePaymentDto } from './dto/payment.dto';
import {
  CreateReferralCodeDto,
  UpdateReferralCodeDto,
  CreateReferralDto,
  UpdateReferralDto,
  ReferralStatus,
} from './dto/referral.dto';

@Injectable()
export class SubscriptionService {
  constructor(private readonly prisma: PrismaService) {}

  // Subscription Plans
  async createSubscriptionPlan(
    createSubscriptionPlanDto: CreateSubscriptionPlanDto,
  ) {
    return this.prisma.subscriptionPlan.create({
      data: {
        ...createSubscriptionPlanDto,
        features: createSubscriptionPlanDto.features,
      },
    });
  }

  async findAllSubscriptionPlans() {
    return this.prisma.subscriptionPlan.findMany({
      where: { isActive: true },
      orderBy: { price: 'asc' },
    });
  }

  async findSubscriptionPlanById(id: string) {
    const plan = await this.prisma.subscriptionPlan.findUnique({
      where: { id },
    });
    if (!plan) {
      throw new NotFoundException('Subscription plan not found');
    }
    return plan;
  }

  async updateSubscriptionPlan(
    id: string,
    updateSubscriptionPlanDto: UpdateSubscriptionPlanDto,
  ) {
    const existingPlan = await this.findSubscriptionPlanById(id);
    return this.prisma.subscriptionPlan.update({
      where: { id },
      data: updateSubscriptionPlanDto,
    });
  }

  async deleteSubscriptionPlan(id: string) {
    const existingPlan = await this.findSubscriptionPlanById(id);
    return this.prisma.subscriptionPlan.update({
      where: { id },
      data: { isActive: false },
    });
  }

  // User Subscriptions
  async createUserSubscription(
    userId: string,
    createUserSubscriptionDto: CreateUserSubscriptionDto,
  ) {
    // Check if user already has an active subscription
    const existingSubscription = await this.prisma.userSubscription.findFirst({
      where: {
        userId,
        status: 'ACTIVE',
      },
    });

    if (existingSubscription) {
      throw new BadRequestException('User already has an active subscription');
    }

    // Verify subscription plan exists
    await this.findSubscriptionPlanById(
      createUserSubscriptionDto.subscriptionPlanId,
    );

    return this.prisma.userSubscription.create({
      data: {
        userId,
        ...createUserSubscriptionDto,
        startDate: new Date(createUserSubscriptionDto.startDate),
        endDate: new Date(createUserSubscriptionDto.endDate),
      },
      include: {
        subscriptionPlan: true,
      },
    });
  }

  async findUserSubscriptions(userId: string) {
    return this.prisma.userSubscription.findMany({
      where: { userId },
      include: {
        subscriptionPlan: true,
        payments: true,
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async findActiveUserSubscription(userId: string) {
    return this.prisma.userSubscription.findFirst({
      where: {
        userId,
        status: 'ACTIVE',
        endDate: { gte: new Date() },
      },
      include: {
        subscriptionPlan: true,
      },
    });
  }

  async updateUserSubscription(
    id: string,
    updateUserSubscriptionDto: UpdateUserSubscriptionDto,
  ) {
    const existingSubscription = await this.prisma.userSubscription.findUnique({
      where: { id },
    });
    if (!existingSubscription) {
      throw new NotFoundException('User subscription not found');
    }

    const updateData: any = { ...updateUserSubscriptionDto };
    if (updateUserSubscriptionDto.endDate) {
      updateData.endDate = new Date(updateUserSubscriptionDto.endDate);
    }

    return this.prisma.userSubscription.update({
      where: { id },
      data: updateData,
      include: {
        subscriptionPlan: true,
      },
    });
  }

  async cancelUserSubscription(id: string) {
    return this.updateUserSubscription(id, {
      status: 'CANCELLED' as any,
      autoRenew: false,
    });
  }

  // Check if user has access to premium features
  async hasFeatureAccess(userId: string, feature: string): Promise<boolean> {
    const activeSubscription = await this.findActiveUserSubscription(userId);
    if (!activeSubscription) return false;

    const features = activeSubscription.subscriptionPlan.features as string[];
    return features.includes(feature);
  }

  // Payments
  async createPayment(createPaymentDto: CreatePaymentDto) {
    // Verify subscription exists
    const subscription = await this.prisma.userSubscription.findUnique({
      where: { id: createPaymentDto.userSubscriptionId },
    });
    if (!subscription) {
      throw new NotFoundException('User subscription not found');
    }

    const paymentData: any = { ...createPaymentDto };
    if (createPaymentDto.paidAt) {
      paymentData.paidAt = new Date(createPaymentDto.paidAt);
    }

    return this.prisma.payment.create({
      data: paymentData,
    });
  }

  async findPaymentsBySubscription(userSubscriptionId: string) {
    return this.prisma.payment.findMany({
      where: { userSubscriptionId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async updatePayment(id: string, updatePaymentDto: UpdatePaymentDto) {
    const existingPayment = await this.prisma.payment.findUnique({
      where: { id },
    });
    if (!existingPayment) {
      throw new NotFoundException('Payment not found');
    }

    const updateData: any = { ...updatePaymentDto };
    if (updatePaymentDto.paidAt) {
      updateData.paidAt = new Date(updatePaymentDto.paidAt);
    }

    return this.prisma.payment.update({
      where: { id },
      data: updateData,
    });
  }

  // Referral Codes
  async createReferralCode(
    userId: string,
    createReferralCodeDto: CreateReferralCodeDto,
  ) {
    // Check if code already exists
    const existingCode = await this.prisma.referralCode.findUnique({
      where: { code: createReferralCodeDto.code },
    });
    if (existingCode) {
      throw new BadRequestException('Referral code already exists');
    }

    const codeData: any = { ...createReferralCodeDto, userId };
    if (createReferralCodeDto.expiresAt) {
      codeData.expiresAt = new Date(createReferralCodeDto.expiresAt);
    }

    return this.prisma.referralCode.create({
      data: codeData,
    });
  }

  async findReferralCodesByUser(userId: string) {
    return this.prisma.referralCode.findMany({
      where: { userId },
      include: {
        referrals: {
          include: {
            referredUser: {
              select: {
                id: true,
                firstName: true,
                lastName: true,
                email: true,
              },
            },
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async findReferralCodeByCode(code: string) {
    const referralCode = await this.prisma.referralCode.findUnique({
      where: { code },
      include: {
        user: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    });
    if (!referralCode) {
      throw new NotFoundException('Referral code not found');
    }
    return referralCode;
  }

  async updateReferralCode(
    id: string,
    updateReferralCodeDto: UpdateReferralCodeDto,
  ) {
    const existingCode = await this.prisma.referralCode.findUnique({
      where: { id },
    });
    if (!existingCode) {
      throw new NotFoundException('Referral code not found');
    }

    const updateData: any = { ...updateReferralCodeDto };
    if (updateReferralCodeDto.expiresAt) {
      updateData.expiresAt = new Date(updateReferralCodeDto.expiresAt);
    }

    return this.prisma.referralCode.update({
      where: { id },
      data: updateData,
    });
  }

  // Referrals
  async createReferral(createReferralDto: CreateReferralDto) {
    // Check if referral already exists
    const existingReferral = await this.prisma.referral.findUnique({
      where: {
        referralCodeId_referredUserId: {
          referralCodeId: createReferralDto.referralCodeId,
          referredUserId: createReferralDto.referredUserId,
        },
      },
    });
    if (existingReferral) {
      throw new BadRequestException('Referral already exists');
    }

    // Get referral code and check if it's valid
    const referralCode = await this.prisma.referralCode.findUnique({
      where: { id: createReferralDto.referralCodeId },
    });
    if (!referralCode) {
      throw new NotFoundException('Referral code not found');
    }
    if (!referralCode.isActive) {
      throw new BadRequestException('Referral code is not active');
    }
    if (referralCode.expiresAt && referralCode.expiresAt < new Date()) {
      throw new BadRequestException('Referral code has expired');
    }
    if (referralCode.usedCount >= referralCode.maxUses) {
      throw new BadRequestException('Referral code has reached maximum uses');
    }

    // Create referral and update code usage
    const referral = await this.prisma.referral.create({
      data: {
        ...createReferralDto,
        status: createReferralDto.status || ReferralStatus.PENDING,
      },
    });

    await this.prisma.referralCode.update({
      where: { id: createReferralDto.referralCodeId },
      data: { usedCount: { increment: 1 } },
    });

    return referral;
  }

  async findReferralsByUser(userId: string) {
    return this.prisma.referral.findMany({
      where: {
        referredUserId: userId,
      },
      include: {
        referralCode: {
          include: {
            user: {
              select: {
                id: true,
                firstName: true,
                lastName: true,
              },
            },
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async updateReferral(id: string, updateReferralDto: UpdateReferralDto) {
    const existingReferral = await this.prisma.referral.findUnique({
      where: { id },
    });
    if (!existingReferral) {
      throw new NotFoundException('Referral not found');
    }

    const updateData: any = { ...updateReferralDto };
    if (updateReferralDto.rewardClaimedAt) {
      updateData.rewardClaimedAt = new Date(updateReferralDto.rewardClaimedAt);
    }

    return this.prisma.referral.update({
      where: { id },
      data: updateData,
    });
  }

  // Utility methods
  async checkSubscriptionExpiry() {
    const expiredSubscriptions = await this.prisma.userSubscription.findMany({
      where: {
        status: 'ACTIVE',
        endDate: { lt: new Date() },
      },
    });

    for (const subscription of expiredSubscriptions) {
      await this.prisma.userSubscription.update({
        where: { id: subscription.id },
        data: { status: 'EXPIRED' },
      });
    }

    return expiredSubscriptions.length;
  }
}
