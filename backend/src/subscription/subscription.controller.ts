import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Request,
} from '@nestjs/common';
import { SubscriptionService } from './subscription.service';
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
} from './dto/referral.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RequestWithUser } from '../common/interfaces/request.interfaces';
import {
  SubscriptionPlan,
  UserSubscription,
  Payment,
  ReferralCode,
  Referral,
} from '@prisma/client';

@Controller('subscription')
@UseGuards(JwtAuthGuard)
export class SubscriptionController {
  constructor(private readonly subscriptionService: SubscriptionService) {}

  // Subscription Plans
  @Post('plans')
  async createSubscriptionPlan(
    @Body() createSubscriptionPlanDto: CreateSubscriptionPlanDto,
  ): Promise<SubscriptionPlan> {
    return this.subscriptionService.createSubscriptionPlan(
      createSubscriptionPlanDto,
    );
  }

  @Get('plans')
  async findAllSubscriptionPlans(): Promise<SubscriptionPlan[]> {
    return this.subscriptionService.findAllSubscriptionPlans();
  }

  @Get('plans/:id')
  async findSubscriptionPlan(
    @Param('id') id: string,
  ): Promise<SubscriptionPlan> {
    return this.subscriptionService.findSubscriptionPlanById(id);
  }

  @Patch('plans/:id')
  async updateSubscriptionPlan(
    @Param('id') id: string,
    @Body() updateSubscriptionPlanDto: UpdateSubscriptionPlanDto,
  ): Promise<SubscriptionPlan> {
    return this.subscriptionService.updateSubscriptionPlan(
      id,
      updateSubscriptionPlanDto,
    );
  }

  @Delete('plans/:id')
  async deleteSubscriptionPlan(
    @Param('id') id: string,
  ): Promise<SubscriptionPlan> {
    return this.subscriptionService.deleteSubscriptionPlan(id);
  }

  // User Subscriptions
  @Post('user-subscriptions')
  async createUserSubscription(
    @Request() req: RequestWithUser,
    @Body() createUserSubscriptionDto: CreateUserSubscriptionDto,
  ): Promise<UserSubscription & { subscriptionPlan: SubscriptionPlan }> {
    return this.subscriptionService.createUserSubscription(
      req.user.id,
      createUserSubscriptionDto,
    );
  }

  @Get('user-subscriptions')
  async findUserSubscriptions(
    @Request() req: RequestWithUser,
  ): Promise<
    (UserSubscription & {
      subscriptionPlan: SubscriptionPlan;
      payments: Payment[];
    })[]
  > {
    return this.subscriptionService.findUserSubscriptions(req.user.id);
  }

  @Get('user-subscriptions/active')
  async findActiveUserSubscription(
    @Request() req: RequestWithUser,
  ): Promise<
    (UserSubscription & { subscriptionPlan: SubscriptionPlan }) | null
  > {
    return this.subscriptionService.findActiveUserSubscription(req.user.id);
  }

  @Patch('user-subscriptions/:id')
  async updateUserSubscription(
    @Param('id') id: string,
    @Body() updateUserSubscriptionDto: UpdateUserSubscriptionDto,
  ): Promise<UserSubscription & { subscriptionPlan: SubscriptionPlan }> {
    return this.subscriptionService.updateUserSubscription(
      id,
      updateUserSubscriptionDto,
    );
  }

  @Post('user-subscriptions/:id/cancel')
  async cancelUserSubscription(
    @Param('id') id: string,
  ): Promise<UserSubscription & { subscriptionPlan: SubscriptionPlan }> {
    return this.subscriptionService.cancelUserSubscription(id);
  }

  @Get('feature-access/:feature')
  async checkFeatureAccess(
    @Request() req: RequestWithUser,
    @Param('feature') feature: string,
  ): Promise<{ hasAccess: boolean }> {
    const hasAccess = await this.subscriptionService.hasFeatureAccess(
      req.user.id,
      feature,
    );
    return { hasAccess };
  }

  // Payments
  @Post('payments')
  async createPayment(
    @Body() createPaymentDto: CreatePaymentDto,
  ): Promise<Payment> {
    return this.subscriptionService.createPayment(createPaymentDto);
  }

  @Get('payments/subscription/:subscriptionId')
  async findPaymentsBySubscription(
    @Param('subscriptionId') subscriptionId: string,
  ): Promise<Payment[]> {
    return this.subscriptionService.findPaymentsBySubscription(subscriptionId);
  }

  @Patch('payments/:id')
  async updatePayment(
    @Param('id') id: string,
    @Body() updatePaymentDto: UpdatePaymentDto,
  ): Promise<Payment> {
    return this.subscriptionService.updatePayment(id, updatePaymentDto);
  }

  // Referral Codes
  @Post('referral-codes')
  async createReferralCode(
    @Request() req: RequestWithUser,
    @Body() createReferralCodeDto: CreateReferralCodeDto,
  ): Promise<ReferralCode> {
    return this.subscriptionService.createReferralCode(
      req.user.id,
      createReferralCodeDto,
    );
  }

  @Get('referral-codes')
  async findReferralCodesByUser(
    @Request() req: RequestWithUser,
  ): Promise<ReferralCode[]> {
    return this.subscriptionService.findReferralCodesByUser(req.user.id);
  }

  @Get('referral-codes/:code')
  async findReferralCodeByCode(
    @Param('code') code: string,
  ): Promise<ReferralCode | null> {
    return this.subscriptionService.findReferralCodeByCode(code);
  }

  @Patch('referral-codes/:id')
  async updateReferralCode(
    @Param('id') id: string,
    @Body() updateReferralCodeDto: UpdateReferralCodeDto,
  ): Promise<ReferralCode> {
    return this.subscriptionService.updateReferralCode(
      id,
      updateReferralCodeDto,
    );
  }

  // Referrals
  @Post('referrals')
  async createReferral(
    @Body() createReferralDto: CreateReferralDto,
  ): Promise<Referral> {
    return this.subscriptionService.createReferral(createReferralDto);
  }

  @Get('referrals')
  async findReferralsByUser(
    @Request() req: RequestWithUser,
  ): Promise<Referral[]> {
    return this.subscriptionService.findReferralsByUser(req.user.id);
  }

  @Patch('referrals/:id')
  async updateReferral(
    @Param('id') id: string,
    @Body() updateReferralDto: UpdateReferralDto,
  ): Promise<Referral> {
    return this.subscriptionService.updateReferral(id, updateReferralDto);
  }

  // Utility endpoints
  @Post('check-expiry')
  async checkSubscriptionExpiry(): Promise<{ expiredCount: number }> {
    const expiredCount =
      await this.subscriptionService.checkSubscriptionExpiry();
    return { expiredCount };
  }
}
