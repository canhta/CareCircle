import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { SubscriptionStatus } from '../dto/subscription.dto';
import { PaymentStatus } from '../dto/payment.dto';

export interface SubscriptionMetrics {
  activeSubscriptions: number;
  totalRevenue: number;
  conversionRate: number;
  churnRate: number;
  avgSubscriptionLength: number;
  renewalRate: number;
}

export interface PaymentMetrics {
  successfulPayments: number;
  failedPayments: number;
  refundRate: number;
  avgTransactionValue: number;
  totalRevenue: number;
}

@Injectable()
export class SubscriptionAnalyticsService {
  private readonly logger = new Logger(SubscriptionAnalyticsService.name);

  constructor(private readonly prisma: PrismaService) {}

  async getSubscriptionMetrics(
    startDate: Date,
    endDate: Date,
  ): Promise<SubscriptionMetrics> {
    try {
      // Count active subscriptions
      const activeSubscriptions = await this.prisma.userSubscription.count({
        where: {
          status: SubscriptionStatus.ACTIVE,
          startDate: { lte: endDate },
          endDate: { gte: startDate },
        },
      });

      // Count total subscriptions (for conversion rate)
      const totalSubscriptions = await this.prisma.userSubscription.count({
        where: {
          startDate: { lte: endDate },
          endDate: { gte: startDate },
        },
      });

      // Count cancelled/expired subscriptions in the period
      const cancelledSubscriptions = await this.prisma.userSubscription.count({
        where: {
          status: {
            in: [SubscriptionStatus.CANCELLED, SubscriptionStatus.EXPIRED],
          },
          updatedAt: { gte: startDate, lte: endDate },
        },
      });

      // Calculate total revenue in the period
      const payments = await this.prisma.payment.findMany({
        where: {
          status: PaymentStatus.COMPLETED,
          createdAt: { gte: startDate, lte: endDate },
        },
        select: {
          amount: true,
          userSubscription: {
            select: {
              startDate: true,
              endDate: true,
            },
          },
        },
      });

      const totalRevenue = payments.reduce(
        (sum, payment) => sum + payment.amount,
        0,
      );

      // Calculate average subscription length
      let totalDays = 0;
      let renewedSubscriptions = 0;
      const subscriptionsInPeriod = await this.prisma.userSubscription.findMany(
        {
          where: {
            OR: [
              { startDate: { gte: startDate, lte: endDate } },
              { endDate: { gte: startDate, lte: endDate } },
            ],
          },
          select: {
            id: true,
            startDate: true,
            endDate: true,
            autoRenew: true,
            status: true,
          },
        },
      );

      subscriptionsInPeriod.forEach((sub) => {
        const start = sub.startDate < startDate ? startDate : sub.startDate;
        const end = sub.endDate > endDate ? endDate : sub.endDate;
        const days = Math.max(
          0,
          (end.getTime() - start.getTime()) / (1000 * 60 * 60 * 24),
        );
        totalDays += days;

        // Count renewals for renewal rate
        if (sub.autoRenew && sub.status === SubscriptionStatus.ACTIVE) {
          renewedSubscriptions++;
        }
      });

      const avgSubscriptionLength =
        subscriptionsInPeriod.length > 0
          ? totalDays / subscriptionsInPeriod.length
          : 0;

      // Calculate metrics
      const conversionRate =
        totalSubscriptions > 0 ? activeSubscriptions / totalSubscriptions : 0;
      const churnRate =
        activeSubscriptions > 0
          ? cancelledSubscriptions / activeSubscriptions
          : 0;
      const renewalRate =
        activeSubscriptions > 0
          ? renewedSubscriptions / activeSubscriptions
          : 0;

      return {
        activeSubscriptions,
        totalRevenue,
        conversionRate,
        churnRate,
        avgSubscriptionLength,
        renewalRate,
      };
    } catch (error) {
      this.logger.error(
        `Error fetching subscription metrics: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  async getPaymentMetrics(
    startDate: Date,
    endDate: Date,
  ): Promise<PaymentMetrics> {
    try {
      // Count successful payments
      const successfulPayments = await this.prisma.payment.count({
        where: {
          status: PaymentStatus.COMPLETED,
          createdAt: { gte: startDate, lte: endDate },
        },
      });

      // Count failed payments
      const failedPayments = await this.prisma.payment.count({
        where: {
          status: PaymentStatus.FAILED,
          createdAt: { gte: startDate, lte: endDate },
        },
      });

      // Count refunded payments
      const refundedPayments = await this.prisma.payment.count({
        where: {
          status: PaymentStatus.REFUNDED,
          createdAt: { gte: startDate, lte: endDate },
        },
      });

      // Get all payments for calculating total revenue and average transaction value
      const payments = await this.prisma.payment.findMany({
        where: {
          status: PaymentStatus.COMPLETED,
          createdAt: { gte: startDate, lte: endDate },
        },
        select: {
          amount: true,
        },
      });

      const totalRevenue = payments.reduce(
        (sum, payment) => sum + payment.amount,
        0,
      );
      const avgTransactionValue =
        payments.length > 0 ? totalRevenue / payments.length : 0;
      const totalPayments =
        successfulPayments + failedPayments + refundedPayments;
      const refundRate =
        successfulPayments > 0 ? refundedPayments / successfulPayments : 0;

      return {
        successfulPayments,
        failedPayments,
        refundRate,
        avgTransactionValue,
        totalRevenue,
      };
    } catch (error) {
      this.logger.error(
        `Error fetching payment metrics: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  async getSubscriptionsByPlan(startDate: Date, endDate: Date) {
    try {
      // Get all subscription plans
      const plans = await this.prisma.subscriptionPlan.findMany({
        where: { isActive: true },
        select: { id: true, name: true },
      });

      // For each plan, count the number of subscriptions
      const results = await Promise.all(
        plans.map(async (plan) => {
          const count = await this.prisma.userSubscription.count({
            where: {
              subscriptionPlanId: plan.id,
              startDate: { lte: endDate },
              endDate: { gte: startDate },
            },
          });

          return {
            planId: plan.id,
            planName: plan.name,
            subscriptionCount: count,
          };
        }),
      );

      return results;
    } catch (error) {
      this.logger.error(
        `Error fetching subscriptions by plan: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  async getUserRetentionMetrics(startDate: Date, endDate: Date) {
    try {
      // Count users who had an active subscription before the start date and still have one after the end date
      const retainedUsers = await this.prisma.user.count({
        where: {
          subscriptions: {
            some: {
              status: SubscriptionStatus.ACTIVE,
              startDate: { lt: startDate },
              endDate: { gt: endDate },
            },
          },
        },
      });

      // Count users who had an active subscription before start date
      const previousUsers = await this.prisma.user.count({
        where: {
          subscriptions: {
            some: {
              status: {
                in: [
                  SubscriptionStatus.ACTIVE,
                  SubscriptionStatus.EXPIRED,
                  SubscriptionStatus.CANCELLED,
                ],
              },
              startDate: { lt: startDate },
            },
          },
        },
      });

      const retentionRate =
        previousUsers > 0 ? retainedUsers / previousUsers : 0;

      return {
        retainedUsers,
        previousUsers,
        retentionRate,
      };
    } catch (error) {
      this.logger.error(
        `Error fetching user retention metrics: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  async getRevenueTrend(
    startDate: Date,
    endDate: Date,
    interval: 'day' | 'week' | 'month' = 'day',
  ) {
    try {
      // Get all successful payments in the period
      const payments = await this.prisma.payment.findMany({
        where: {
          status: PaymentStatus.COMPLETED,
          createdAt: { gte: startDate, lte: endDate },
        },
        select: {
          amount: true,
          createdAt: true,
        },
        orderBy: {
          createdAt: 'asc',
        },
      });

      // Group by interval
      const trend: Record<string, number> = {};

      payments.forEach((payment) => {
        let key = '';

        if (interval === 'day') {
          key = payment.createdAt.toISOString().split('T')[0]; // YYYY-MM-DD
        } else if (interval === 'week') {
          const date = new Date(payment.createdAt);
          const firstDayOfYear = new Date(date.getFullYear(), 0, 1);
          const pastDaysOfYear =
            (date.getTime() - firstDayOfYear.getTime()) / 86400000;
          const weekNumber = Math.ceil(
            (pastDaysOfYear + firstDayOfYear.getDay() + 1) / 7,
          );
          key = `${date.getFullYear()}-W${weekNumber}`;
        } else if (interval === 'month') {
          key = `${payment.createdAt.getFullYear()}-${payment.createdAt.getMonth() + 1}`;
        }

        if (!trend[key]) {
          trend[key] = 0;
        }

        trend[key] += payment.amount;
      });

      // Convert to array format
      const result = Object.entries(trend).map(([date, amount]) => ({
        date,
        revenue: amount,
      }));

      return result.sort((a, b) => a.date.localeCompare(b.date));
    } catch (error) {
      this.logger.error(
        `Error fetching revenue trend: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }
}
