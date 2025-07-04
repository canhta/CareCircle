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

@Controller('subscription')
@UseGuards(JwtAuthGuard)
export class SubscriptionController {
  constructor(private readonly subscriptionService: SubscriptionService) {}

  // Subscription Plans
  @Post('plans')
  async createSubscriptionPlan(
    @Body() createSubscriptionPlanDto: CreateSubscriptionPlanDto,
  ) {
    return this.subscriptionService.createSubscriptionPlan(
      createSubscriptionPlanDto,
    );
  }

  @Get('plans')
  async findAllSubscriptionPlans() {
    return this.subscriptionService.findAllSubscriptionPlans();
  }

  @Get('plans/:id')
  async findSubscriptionPlan(@Param('id') id: string) {
    return this.subscriptionService.findSubscriptionPlanById(id);
  }

  @Patch('plans/:id')
  async updateSubscriptionPlan(
    @Param('id') id: string,
    @Body() updateSubscriptionPlanDto: UpdateSubscriptionPlanDto,
  ) {
    return this.subscriptionService.updateSubscriptionPlan(
      id,
      updateSubscriptionPlanDto,
    );
  }

  @Delete('plans/:id')
  async deleteSubscriptionPlan(@Param('id') id: string) {
    return this.subscriptionService.deleteSubscriptionPlan(id);
  }

  // User Subscriptions
  @Post('user-subscriptions')
  async createUserSubscription(
    @Request() req: any,
    @Body() createUserSubscriptionDto: CreateUserSubscriptionDto,
  ) {
    return this.subscriptionService.createUserSubscription(
      req.user.id,
      createUserSubscriptionDto,
    );
  }

  @Get('user-subscriptions')
  async findUserSubscriptions(@Request() req: any) {
    return this.subscriptionService.findUserSubscriptions(req.user.id);
  }

  @Get('user-subscriptions/active')
  async findActiveUserSubscription(@Request() req: any) {
    return this.subscriptionService.findActiveUserSubscription(req.user.id);
  }

  @Patch('user-subscriptions/:id')
  async updateUserSubscription(
    @Param('id') id: string,
    @Body() updateUserSubscriptionDto: UpdateUserSubscriptionDto,
  ) {
    return this.subscriptionService.updateUserSubscription(
      id,
      updateUserSubscriptionDto,
    );
  }

  @Post('user-subscriptions/:id/cancel')
  async cancelUserSubscription(@Param('id') id: string) {
    return this.subscriptionService.cancelUserSubscription(id);
  }

  @Get('feature-access/:feature')
  async checkFeatureAccess(
    @Request() req: any,
    @Param('feature') feature: string,
  ) {
    const hasAccess = await this.subscriptionService.hasFeatureAccess(
      req.user.id,
      feature,
    );
    return { hasAccess };
  }

  // Payments
  @Post('payments')
  async createPayment(@Body() createPaymentDto: CreatePaymentDto) {
    return this.subscriptionService.createPayment(createPaymentDto);
  }

  @Get('payments/subscription/:subscriptionId')
  async findPaymentsBySubscription(
    @Param('subscriptionId') subscriptionId: string,
  ) {
    return this.subscriptionService.findPaymentsBySubscription(subscriptionId);
  }

  @Patch('payments/:id')
  async updatePayment(
    @Param('id') id: string,
    @Body() updatePaymentDto: UpdatePaymentDto,
  ) {
    return this.subscriptionService.updatePayment(id, updatePaymentDto);
  }

  // Referral Codes
  @Post('referral-codes')
  async createReferralCode(
    @Request() req: any,
    @Body() createReferralCodeDto: CreateReferralCodeDto,
  ) {
    return this.subscriptionService.createReferralCode(
      req.user.id,
      createReferralCodeDto,
    );
  }

  @Get('referral-codes')
  async findReferralCodesByUser(@Request() req: any) {
    return this.subscriptionService.findReferralCodesByUser(req.user.id);
  }

  @Get('referral-codes/:code')
  async findReferralCodeByCode(@Param('code') code: string) {
    return this.subscriptionService.findReferralCodeByCode(code);
  }

  @Patch('referral-codes/:id')
  async updateReferralCode(
    @Param('id') id: string,
    @Body() updateReferralCodeDto: UpdateReferralCodeDto,
  ) {
    return this.subscriptionService.updateReferralCode(
      id,
      updateReferralCodeDto,
    );
  }

  // Referrals
  @Post('referrals')
  async createReferral(@Body() createReferralDto: CreateReferralDto) {
    return this.subscriptionService.createReferral(createReferralDto);
  }

  @Get('referrals')
  async findReferralsByUser(@Request() req: any) {
    return this.subscriptionService.findReferralsByUser(req.user.id);
  }

  @Patch('referrals/:id')
  async updateReferral(
    @Param('id') id: string,
    @Body() updateReferralDto: UpdateReferralDto,
  ) {
    return this.subscriptionService.updateReferral(id, updateReferralDto);
  }

  // Utility endpoints
  @Post('check-expiry')
  async checkSubscriptionExpiry() {
    const expiredCount =
      await this.subscriptionService.checkSubscriptionExpiry();
    return { expiredCount };
  }
}
