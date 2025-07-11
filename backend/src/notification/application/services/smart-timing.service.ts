import { Injectable, Logger } from '@nestjs/common';
import { NotificationPriority, NotificationType } from '@prisma/client';

export interface UserBehaviorData {
  userId: string;
  timezone: string;
  preferredHours: number[]; // Hours when user is most active (0-23)
  quietHours: { start: string; end: string }; // HH:MM format
  deviceUsagePatterns: DeviceUsagePattern[];
  responseRates: ResponseRateData[];
  lastActiveTime: Date;
  weeklyActivity: WeeklyActivityPattern;
}

export interface DeviceUsagePattern {
  hour: number; // 0-23
  dayOfWeek: number; // 0-6 (Sunday = 0)
  usageScore: number; // 0-1 (1 = most active)
  averageResponseTime: number; // milliseconds
}

export interface ResponseRateData {
  notificationType: NotificationType;
  hour: number;
  responseRate: number; // 0-1
  averageResponseTime: number; // milliseconds
}

export interface WeeklyActivityPattern {
  monday: number[];
  tuesday: number[];
  wednesday: number[];
  thursday: number[];
  friday: number[];
  saturday: number[];
  sunday: number[];
}

export interface OptimalTimingResult {
  recommendedTime: Date;
  confidence: number; // 0-1
  reasoning: string;
  alternativeTimes: Date[];
  shouldDefer: boolean;
  deferReason?: string;
}

export interface TimingPreferences {
  respectQuietHours: boolean;
  considerUserActivity: boolean;
  optimizeForResponseRate: boolean;
  minimumDelayMinutes: number;
  maximumDelayHours: number;
}

@Injectable()
export class SmartTimingService {
  private readonly logger = new Logger(SmartTimingService.name);

  // Default timing preferences for different notification types
  private readonly defaultTimingPreferences: Record<
    NotificationType,
    TimingPreferences
  > = {
    [NotificationType.EMERGENCY_ALERT]: {
      respectQuietHours: false,
      considerUserActivity: false,
      optimizeForResponseRate: false,
      minimumDelayMinutes: 0,
      maximumDelayHours: 0,
    },
    [NotificationType.MEDICATION_REMINDER]: {
      respectQuietHours: true,
      considerUserActivity: true,
      optimizeForResponseRate: true,
      minimumDelayMinutes: 0,
      maximumDelayHours: 2,
    },
    [NotificationType.APPOINTMENT_REMINDER]: {
      respectQuietHours: true,
      considerUserActivity: true,
      optimizeForResponseRate: true,
      minimumDelayMinutes: 15,
      maximumDelayHours: 24,
    },
    [NotificationType.HEALTH_ALERT]: {
      respectQuietHours: true,
      considerUserActivity: true,
      optimizeForResponseRate: true,
      minimumDelayMinutes: 5,
      maximumDelayHours: 4,
    },
    [NotificationType.TASK_REMINDER]: {
      respectQuietHours: true,
      considerUserActivity: true,
      optimizeForResponseRate: true,
      minimumDelayMinutes: 10,
      maximumDelayHours: 8,
    },
    [NotificationType.CARE_GROUP_UPDATE]: {
      respectQuietHours: true,
      considerUserActivity: true,
      optimizeForResponseRate: true,
      minimumDelayMinutes: 30,
      maximumDelayHours: 12,
    },
    [NotificationType.SYSTEM_NOTIFICATION]: {
      respectQuietHours: true,
      considerUserActivity: true,
      optimizeForResponseRate: false,
      minimumDelayMinutes: 60,
      maximumDelayHours: 24,
    },
  };

  /**
   * Calculate optimal timing for notification delivery
   */
  calculateOptimalTiming(
    userId: string,
    notificationType: NotificationType,
    priority: NotificationPriority,
    scheduledTime?: Date,
    userBehavior?: UserBehaviorData,
  ): OptimalTimingResult {
    this.logger.log(
      `Calculating optimal timing for user ${userId}, type ${notificationType}, priority ${priority}`,
    );

    const now = new Date();
    const preferences = this.defaultTimingPreferences[notificationType];

    // Emergency alerts are always sent immediately
    if (
      priority === NotificationPriority.URGENT ||
      notificationType === NotificationType.EMERGENCY_ALERT
    ) {
      return {
        recommendedTime: now,
        confidence: 1.0,
        reasoning: 'Emergency/urgent notifications are sent immediately',
        alternativeTimes: [],
        shouldDefer: false,
      };
    }

    // If no user behavior data, use basic timing logic
    if (!userBehavior) {
      return this.calculateBasicTiming(scheduledTime || now, preferences);
    }

    // Calculate optimal time based on user behavior
    const optimalTime = this.findOptimalTimeSlot(
      scheduledTime || now,
      userBehavior,
      preferences,
      notificationType,
    );

    // Check if we should defer the notification
    const shouldDefer = this.shouldDeferNotification(
      optimalTime,
      userBehavior,
      preferences,
      priority,
    );

    if (shouldDefer.defer) {
      const deferredTime = this.calculateDeferredTime(
        optimalTime,
        userBehavior,
        preferences,
      );

      return {
        recommendedTime: deferredTime,
        confidence: 0.8,
        reasoning: shouldDefer.reason || 'Deferred for optimal user engagement',
        alternativeTimes: this.generateAlternativeTimes(
          deferredTime,
          userBehavior,
        ),
        shouldDefer: true,
        deferReason: shouldDefer.reason,
      };
    }

    const confidence = this.calculateConfidence(
      optimalTime,
      userBehavior,
      notificationType,
    );

    return {
      recommendedTime: optimalTime,
      confidence,
      reasoning: this.generateReasoning(optimalTime, userBehavior, preferences),
      alternativeTimes: this.generateAlternativeTimes(
        optimalTime,
        userBehavior,
      ),
      shouldDefer: false,
    };
  }

  /**
   * Analyze user behavior patterns to predict optimal notification times
   */
  analyzeUserBehaviorPatterns(userId: string): UserBehaviorData | null {
    // In a real implementation, this would query user interaction data
    // For now, return mock data or null
    this.logger.log(`Analyzing behavior patterns for user ${userId}`);

    // This would typically involve:
    // 1. Querying notification interaction history
    // 2. Analyzing app usage patterns
    // 3. Identifying peak activity hours
    // 4. Calculating response rates by time and type

    return null;
  }

  /**
   * Update user behavior data based on notification interaction
   */
  updateUserBehaviorData(
    userId: string,
    notificationType: NotificationType,
    sentAt: Date,
    interactionTime?: Date,
    interactionType?: 'opened' | 'clicked' | 'dismissed' | 'ignored',
  ): void {
    this.logger.log(
      `Updating behavior data for user ${userId}: ${interactionType || 'no interaction'}`,
    );

    // In a real implementation, this would:
    // 1. Store the interaction data
    // 2. Update user behavior patterns
    // 3. Recalculate optimal timing preferences
    // 4. Update machine learning models
  }

  /**
   * Get recommended quiet hours based on user behavior
   */
  getRecommendedQuietHours(userBehavior: UserBehaviorData): {
    start: string;
    end: string;
  } {
    // Analyze when user is least active
    const hourlyActivity = new Array(24).fill(0);

    userBehavior.deviceUsagePatterns.forEach((pattern) => {
      hourlyActivity[pattern.hour] += pattern.usageScore;
    });

    // Find the longest period of low activity (for quiet hours)
    const minActivity = Math.min(...(hourlyActivity as number[]));
    let quietStart = 22; // Default 10 PM
    let quietEnd = 7; // Default 7 AM

    // Find actual quiet period
    for (let i = 0; i < 24; i++) {
      if (hourlyActivity[i] === minActivity) {
        quietStart = i;
        break;
      }
    }

    // Find end of quiet period
    for (let i = (quietStart + 1) % 24; i !== quietStart; i = (i + 1) % 24) {
      if (hourlyActivity[i] > minActivity * 1.5) {
        quietEnd = i;
        break;
      }
    }

    return {
      start: `${quietStart.toString().padStart(2, '0')}:00`,
      end: `${quietEnd.toString().padStart(2, '0')}:00`,
    };
  }

  /**
   * Calculate basic timing without user behavior data
   */
  private calculateBasicTiming(
    requestedTime: Date,
    preferences: TimingPreferences,
  ): OptimalTimingResult {
    const now = new Date();
    let recommendedTime = new Date(
      Math.max(requestedTime.getTime(), now.getTime()),
    );

    // Apply minimum delay
    if (preferences.minimumDelayMinutes > 0) {
      recommendedTime = new Date(
        now.getTime() + preferences.minimumDelayMinutes * 60000,
      );
    }

    // Avoid late night/early morning hours (basic quiet hours)
    const hour = recommendedTime.getHours();
    if (hour >= 22 || hour <= 6) {
      recommendedTime.setHours(8, 0, 0, 0); // 8 AM next day
      if (recommendedTime <= now) {
        recommendedTime.setDate(recommendedTime.getDate() + 1);
      }
    }

    return {
      recommendedTime,
      confidence: 0.5,
      reasoning: 'Basic timing calculation without user behavior data',
      alternativeTimes: [
        new Date(recommendedTime.getTime() + 30 * 60000), // +30 minutes
        new Date(recommendedTime.getTime() + 60 * 60000), // +1 hour
      ],
      shouldDefer: false,
    };
  }

  /**
   * Find optimal time slot based on user behavior
   */
  private findOptimalTimeSlot(
    requestedTime: Date,
    userBehavior: UserBehaviorData,
    preferences: TimingPreferences,
    notificationType: NotificationType,
  ): Date {
    const now = new Date();
    let candidateTime = new Date(
      Math.max(requestedTime.getTime(), now.getTime()),
    );

    // Apply minimum delay
    if (preferences.minimumDelayMinutes > 0) {
      candidateTime = new Date(
        now.getTime() + preferences.minimumDelayMinutes * 60000,
      );
    }

    // Convert to user's timezone
    const userTime = new Date(
      candidateTime.toLocaleString('en-US', {
        timeZone: userBehavior.timezone,
      }),
    );
    const dayOfWeek = userTime.getDay();

    // Find the best hour based on user activity patterns
    if (preferences.considerUserActivity) {
      const activityScores = userBehavior.deviceUsagePatterns
        .filter((p) => p.dayOfWeek === dayOfWeek)
        .sort((a, b) => b.usageScore - a.usageScore);

      if (activityScores.length > 0) {
        const bestHour = activityScores[0].hour;
        candidateTime.setHours(bestHour, 0, 0, 0);
      }
    }

    // Consider response rates for this notification type
    if (preferences.optimizeForResponseRate) {
      const responseData = userBehavior.responseRates
        .filter((r) => r.notificationType === notificationType)
        .sort((a, b) => b.responseRate - a.responseRate);

      if (responseData.length > 0) {
        const bestResponseHour = responseData[0].hour;
        candidateTime.setHours(bestResponseHour, 0, 0, 0);
      }
    }

    // Ensure we don't exceed maximum delay
    const maxDelayTime = new Date(
      now.getTime() + preferences.maximumDelayHours * 3600000,
    );
    if (candidateTime > maxDelayTime) {
      candidateTime = maxDelayTime;
    }

    return candidateTime;
  }

  /**
   * Check if notification should be deferred
   */
  private shouldDeferNotification(
    proposedTime: Date,
    userBehavior: UserBehaviorData,
    preferences: TimingPreferences,
    priority: NotificationPriority,
  ): { defer: boolean; reason?: string } {
    // High priority notifications are rarely deferred
    if (priority === NotificationPriority.HIGH) {
      return { defer: false };
    }

    // Check quiet hours
    if (preferences.respectQuietHours) {
      const userTime = new Date(
        proposedTime.toLocaleString('en-US', {
          timeZone: userBehavior.timezone,
        }),
      );
      const hour = userTime.getHours();
      const minute = userTime.getMinutes();
      const timeInMinutes = hour * 60 + minute;

      const [startHour, startMinute] = userBehavior.quietHours.start
        .split(':')
        .map(Number);
      const [endHour, endMinute] = userBehavior.quietHours.end
        .split(':')
        .map(Number);
      const quietStartMinutes = startHour * 60 + startMinute;
      const quietEndMinutes = endHour * 60 + endMinute;

      let inQuietHours = false;
      if (quietStartMinutes > quietEndMinutes) {
        // Overnight quiet hours
        inQuietHours =
          timeInMinutes >= quietStartMinutes ||
          timeInMinutes <= quietEndMinutes;
      } else {
        inQuietHours =
          timeInMinutes >= quietStartMinutes &&
          timeInMinutes <= quietEndMinutes;
      }

      if (inQuietHours) {
        return {
          defer: true,
          reason: 'Proposed time is during user quiet hours',
        };
      }
    }

    // Check if user is likely to be inactive
    const userTime = new Date(
      proposedTime.toLocaleString('en-US', { timeZone: userBehavior.timezone }),
    );
    const hour = userTime.getHours();
    const dayOfWeek = userTime.getDay();

    const activityPattern = userBehavior.deviceUsagePatterns.find(
      (p) => p.hour === hour && p.dayOfWeek === dayOfWeek,
    );

    if (activityPattern && activityPattern.usageScore < 0.2) {
      return { defer: true, reason: 'User is typically inactive at this time' };
    }

    return { defer: false };
  }

  /**
   * Calculate deferred time
   */
  private calculateDeferredTime(
    originalTime: Date,
    userBehavior: UserBehaviorData,
    preferences: TimingPreferences,
  ): Date {
    const userTime = new Date(
      originalTime.toLocaleString('en-US', { timeZone: userBehavior.timezone }),
    );

    // Find next optimal time after quiet hours
    if (preferences.respectQuietHours) {
      const [endHour, endMinute] = userBehavior.quietHours.end
        .split(':')
        .map(Number);
      const deferredTime = new Date(userTime);
      deferredTime.setHours(endHour, endMinute, 0, 0);

      // If quiet hours end time has passed today, schedule for tomorrow
      if (deferredTime <= userTime) {
        deferredTime.setDate(deferredTime.getDate() + 1);
      }

      return deferredTime;
    }

    // Default: defer by 2 hours
    return new Date(originalTime.getTime() + 2 * 3600000);
  }

  /**
   * Calculate confidence score for timing recommendation
   */
  private calculateConfidence(
    recommendedTime: Date,
    userBehavior: UserBehaviorData,
    notificationType: NotificationType,
  ): number {
    let confidence = 0.5; // Base confidence

    const userTime = new Date(
      recommendedTime.toLocaleString('en-US', {
        timeZone: userBehavior.timezone,
      }),
    );
    const hour = userTime.getHours();
    const dayOfWeek = userTime.getDay();

    // Increase confidence based on user activity patterns
    const activityPattern = userBehavior.deviceUsagePatterns.find(
      (p) => p.hour === hour && p.dayOfWeek === dayOfWeek,
    );

    if (activityPattern) {
      confidence += activityPattern.usageScore * 0.3;
    }

    // Increase confidence based on response rates
    const responseData = userBehavior.responseRates.find(
      (r) => r.notificationType === notificationType && r.hour === hour,
    );

    if (responseData) {
      confidence += responseData.responseRate * 0.2;
    }

    // Ensure confidence is between 0 and 1
    return Math.min(Math.max(confidence, 0), 1);
  }

  /**
   * Generate reasoning for timing recommendation
   */
  private generateReasoning(
    recommendedTime: Date,
    userBehavior: UserBehaviorData,
    preferences: TimingPreferences,
  ): string {
    const reasons: string[] = [];

    const userTime = new Date(
      recommendedTime.toLocaleString('en-US', {
        timeZone: userBehavior.timezone,
      }),
    );
    const hour = userTime.getHours();

    if (preferences.respectQuietHours) {
      reasons.push('respects user quiet hours');
    }

    if (preferences.considerUserActivity) {
      reasons.push('optimized for user activity patterns');
    }

    if (preferences.optimizeForResponseRate) {
      reasons.push('optimized for response rate');
    }

    if (hour >= 9 && hour <= 17) {
      reasons.push('scheduled during business hours');
    } else if (hour >= 18 && hour <= 21) {
      reasons.push('scheduled during evening hours');
    }

    return reasons.length > 0
      ? `Timing ${reasons.join(', ')}`
      : 'Basic timing optimization applied';
  }

  /**
   * Generate alternative timing options
   */
  private generateAlternativeTimes(
    recommendedTime: Date,
    userBehavior: UserBehaviorData,
  ): Date[] {
    const alternatives: Date[] = [];

    // Add times based on user's preferred hours
    for (const hour of userBehavior.preferredHours.slice(0, 3)) {
      const altTime = new Date(recommendedTime);
      altTime.setHours(hour, 0, 0, 0);

      if (
        altTime > new Date() &&
        altTime.getTime() !== recommendedTime.getTime()
      ) {
        alternatives.push(altTime);
      }
    }

    // Add some standard alternatives if we don't have enough
    if (alternatives.length < 2) {
      alternatives.push(
        new Date(recommendedTime.getTime() + 30 * 60000), // +30 minutes
        new Date(recommendedTime.getTime() + 60 * 60000), // +1 hour
      );
    }

    return alternatives.slice(0, 3); // Return max 3 alternatives
  }
}
