import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { HealthDataQueueService } from './health-data-queue.service';
import { DataQuality } from '@prisma/client';

export interface HealthInsight {
  type: 'warning' | 'improvement' | 'goal_achieved' | 'recommendation';
  title: string;
  description: string;
  severity: 'low' | 'medium' | 'high';
  confidence: number; // 0-100
  actionable: boolean;
  recommendations?: string[];
  trend?: {
    direction: 'up' | 'down' | 'stable';
    percentage: number;
    period: string;
  };
}

export interface HealthTrend {
  metric: string;
  currentValue: number;
  previousValue: number;
  change: number;
  changePercentage: number;
  direction: 'up' | 'down' | 'stable';
  period: 'daily' | 'weekly' | 'monthly';
  confidence: number;
}

export interface HealthGoal {
  type: string;
  title: string;
  current: number;
  target: number;
  timeframe: string;
  priority: string;
}

export interface AggregatedHealthData {
  userId: string;
  period: 'day' | 'week' | 'month' | 'year';
  startDate: Date;
  endDate: Date;
  metrics: {
    steps: {
      total: number;
      average: number;
      min: number;
      max: number;
      daysWithData: number;
    };
    heartRate: {
      average: number;
      resting: number;
      max: number;
      variability: number;
    };
    sleep: {
      averageDuration: number; // minutes
      averageQuality: number; // 1-10
      deepSleepPercentage: number;
      remSleepPercentage: number;
    };
    activity: {
      activeMinutes: number;
      caloriesBurned: number;
      distance: number;
    };
    vitals: {
      weight?: number;
      bloodPressure?: {
        systolic: number;
        diastolic: number;
      };
      bloodGlucose?: number;
      bodyTemperature?: number;
    };
  };
  insights: HealthInsight[];
  trends: HealthTrend[];
  goals: HealthGoal[];
  dataQuality: DataQuality;
}

interface HealthMetricRow {
  steps: number | null;
  heartRateAvg: number | null;
  heartRateResting: number | null;
  heartRateMax: number | null;
  sleepDuration: number | null;
  activeMinutes: number | null;
  caloriesBurned: number | null;
  distance: number | null;
  weight: number | null;
  bloodPressureSys: number | null;
  bloodPressureDia: number | null;
  bloodGlucose: number | null;
  bodyTemperature: number | null;
  sleepScore: number | null;
  deepSleepDuration: number | null;
  remSleepDuration: number | null;
  date: Date;
}

@Injectable()
export class HealthAnalysisService {
  private readonly logger = new Logger(HealthAnalysisService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly queueService: HealthDataQueueService,
  ) {}

  /**
   * Process and analyze health data for a user within a date range
   */
  async analyzeHealthData(
    userId: string,
    startDate: Date,
    endDate: Date,
    period: 'day' | 'week' | 'month' | 'year' = 'week',
  ): Promise<AggregatedHealthData> {
    this.logger.log(
      `Starting health data analysis for user ${userId} from ${startDate.toISOString()} to ${endDate.toISOString()}`,
    );

    // Get raw health metrics data
    const healthMetrics = await this.getHealthMetrics(
      userId,
      startDate,
      endDate,
    );
    const healthRecords = await this.getHealthRecords(
      userId,
      startDate,
      endDate,
    );

    // Calculate aggregated metrics
    const aggregatedMetrics = this.calculateAggregatedMetrics(healthMetrics);

    // Detect patterns and trends
    const trends = await this.calculateTrends(userId, period, endDate);

    // Generate insights
    const insights = this.generateInsights(aggregatedMetrics, trends);

    // Generate health goals
    const goals = this.generateHealthGoals(aggregatedMetrics);

    // Assess data quality
    const dataQuality = this.assessDataQuality(healthMetrics, healthRecords);

    const result: AggregatedHealthData = {
      userId,
      period,
      startDate,
      endDate,
      metrics: aggregatedMetrics,
      insights,
      trends,
      goals,
      dataQuality,
    };

    this.logger.log(
      `Completed health data analysis for user ${userId}. Generated ${insights.length} insights and ${trends.length} trends.`,
    );

    return result;
  }

  /**
   * Get health metrics from the database
   */
  private async getHealthMetrics(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<HealthMetricRow[]> {
    return this.prisma.healthMetrics.findMany({
      where: {
        userId,
        date: {
          gte: startDate,
          lte: endDate,
        },
      },
      orderBy: {
        date: 'asc',
      },
    });
  }

  /**
   * Get health records from the database
   */
  private async getHealthRecords(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<any[]> {
    return this.prisma.healthRecord.findMany({
      where: {
        userId,
        recordedAt: {
          gte: startDate,
          lte: endDate,
        },
      },
      orderBy: {
        recordedAt: 'asc',
      },
    });
  }

  /**
   * Calculate aggregated metrics from raw health data
   */
  private calculateAggregatedMetrics(
    healthMetrics: HealthMetricRow[],
  ): AggregatedHealthData['metrics'] {
    this.logger.debug(
      `Processing ${healthMetrics.length} health metric records`,
    );

    const validStepsData = healthMetrics.filter(
      (m) => m.steps !== null && m.steps > 0,
    );
    const validHeartRateData = healthMetrics.filter(
      (m) => m.heartRateAvg !== null,
    );
    const validSleepData = healthMetrics.filter(
      (m) => m.sleepDuration !== null,
    );
    const validActivityData = healthMetrics.filter(
      (m) => m.activeMinutes !== null || m.caloriesBurned !== null,
    );

    // Steps metrics
    const stepsMetrics = {
      total: validStepsData.reduce((sum, m) => sum + (m.steps || 0), 0),
      average:
        validStepsData.length > 0
          ? validStepsData.reduce((sum, m) => sum + (m.steps || 0), 0) /
            validStepsData.length
          : 0,
      min:
        validStepsData.length > 0
          ? Math.min(...validStepsData.map((m) => m.steps!))
          : 0,
      max:
        validStepsData.length > 0
          ? Math.max(...validStepsData.map((m) => m.steps!))
          : 0,
      daysWithData: validStepsData.length,
    };

    // Heart rate metrics
    const heartRateMetrics = {
      average:
        validHeartRateData.length > 0
          ? validHeartRateData.reduce(
              (sum, m) => sum + (m.heartRateAvg || 0),
              0,
            ) / validHeartRateData.length
          : 0,
      resting:
        validHeartRateData.length > 0
          ? validHeartRateData.reduce(
              (sum, m) => sum + (m.heartRateResting || m.heartRateAvg || 0),
              0,
            ) / validHeartRateData.length
          : 0,
      max:
        validHeartRateData.length > 0
          ? Math.max(
              ...validHeartRateData.map(
                (m) => m.heartRateMax || m.heartRateAvg || 0,
              ),
            )
          : 0,
      variability: this.calculateHeartRateVariability(validHeartRateData),
    };

    // Sleep metrics
    const sleepMetrics = {
      averageDuration:
        validSleepData.length > 0
          ? validSleepData.reduce((sum, m) => sum + (m.sleepDuration || 0), 0) /
            validSleepData.length
          : 0,
      averageQuality:
        validSleepData.length > 0
          ? validSleepData.reduce((sum, m) => sum + (m.sleepScore || 0), 0) /
            validSleepData.length /
            10
          : 0,
      deepSleepPercentage: this.calculateSleepPhasePercentage(
        validSleepData,
        'deep',
      ),
      remSleepPercentage: this.calculateSleepPhasePercentage(
        validSleepData,
        'rem',
      ),
    };

    // Activity metrics
    const activityMetrics = {
      activeMinutes: validActivityData.reduce(
        (sum, m) => sum + (m.activeMinutes || 0),
        0,
      ),
      caloriesBurned: validActivityData.reduce(
        (sum, m) => sum + (m.caloriesBurned || 0),
        0,
      ),
      distance: validActivityData.reduce(
        (sum, m) => sum + (m.distance || 0),
        0,
      ),
    };

    // Vitals metrics
    const vitalsMetrics = this.calculateVitalsMetrics(healthMetrics);

    return {
      steps: stepsMetrics,
      heartRate: heartRateMetrics,
      sleep: sleepMetrics,
      activity: activityMetrics,
      vitals: vitalsMetrics,
    };
  }

  /**
   * Calculate heart rate variability
   */
  private calculateHeartRateVariability(
    heartRateData: HealthMetricRow[],
  ): number {
    if (heartRateData.length < 2) return 0;

    const hrValues = heartRateData
      .map((m) => m.heartRateAvg)
      .filter((hr): hr is number => hr !== null);

    if (hrValues.length < 2) return 0;

    const differences: number[] = [];
    for (let i = 1; i < hrValues.length; i++) {
      differences.push(Math.abs(hrValues[i] - hrValues[i - 1]));
    }

    return (
      differences.reduce((sum, diff) => sum + diff, 0) / differences.length
    );
  }

  /**
   * Calculate sleep phase percentages
   */
  private calculateSleepPhasePercentage(
    sleepData: HealthMetricRow[],
    phase: 'deep' | 'rem',
  ): number {
    const validData = sleepData.filter(
      (m) =>
        m.sleepDuration &&
        (phase === 'deep' ? m.deepSleepDuration : m.remSleepDuration),
    );

    if (validData.length === 0) return 0;

    const totalSleep = validData.reduce(
      (sum, m) => sum + (m.sleepDuration || 0),
      0,
    );
    const totalPhase = validData.reduce(
      (sum, m) =>
        sum +
        (phase === 'deep' ? m.deepSleepDuration || 0 : m.remSleepDuration || 0),
      0,
    );

    return totalSleep > 0 ? (totalPhase / totalSleep) * 100 : 0;
  }

  /**
   * Calculate vitals metrics
   */
  private calculateVitalsMetrics(
    healthMetrics: HealthMetricRow[],
  ): AggregatedHealthData['metrics']['vitals'] {
    const latestVitals = healthMetrics
      .sort((a, b) => b.date.getTime() - a.date.getTime())
      .find(
        (m) =>
          m.weight || m.bloodPressureSys || m.bloodGlucose || m.bodyTemperature,
      );

    return {
      weight: latestVitals?.weight || undefined,
      bloodPressure:
        latestVitals?.bloodPressureSys && latestVitals?.bloodPressureDia
          ? {
              systolic: latestVitals.bloodPressureSys,
              diastolic: latestVitals.bloodPressureDia,
            }
          : undefined,
      bloodGlucose: latestVitals?.bloodGlucose || undefined,
      bodyTemperature: latestVitals?.bodyTemperature || undefined,
    };
  }

  /**
   * Calculate trends over time
   */
  private async calculateTrends(
    userId: string,
    period: 'day' | 'week' | 'month' | 'year',
    endDate: Date,
  ): Promise<HealthTrend[]> {
    const trends: HealthTrend[] = [];

    // Calculate period offset
    const periodDays = {
      day: 1,
      week: 7,
      month: 30,
      year: 365,
    }[period];

    const currentPeriodStart = new Date(endDate);
    currentPeriodStart.setDate(currentPeriodStart.getDate() - periodDays);

    const previousPeriodStart = new Date(currentPeriodStart);
    previousPeriodStart.setDate(previousPeriodStart.getDate() - periodDays);

    const previousPeriodEnd = new Date(currentPeriodStart);

    // Get data for both periods
    const currentData = await this.getHealthMetrics(
      userId,
      currentPeriodStart,
      endDate,
    );
    const previousData = await this.getHealthMetrics(
      userId,
      previousPeriodStart,
      previousPeriodEnd,
    );

    // Calculate trends for key metrics
    trends.push(
      ...this.calculateMetricTrends(currentData, previousData, period),
    );

    return trends;
  }

  /**
   * Calculate trends for specific metrics
   */
  private calculateMetricTrends(
    currentData: HealthMetricRow[],
    previousData: HealthMetricRow[],
    period: 'day' | 'week' | 'month' | 'year',
  ): HealthTrend[] {
    const trends: HealthTrend[] = [];

    // Steps trend
    const currentSteps =
      currentData.reduce((sum, m) => sum + (m.steps || 0), 0) /
      Math.max(currentData.length, 1);
    const previousSteps =
      previousData.reduce((sum, m) => sum + (m.steps || 0), 0) /
      Math.max(previousData.length, 1);

    if (currentSteps > 0 || previousSteps > 0) {
      trends.push(
        this.createTrend('steps', currentSteps, previousSteps, period),
      );
    }

    // Heart rate trend
    const currentHR =
      currentData
        .filter((m) => m.heartRateAvg)
        .reduce((sum, m) => sum + (m.heartRateAvg || 0), 0) /
      Math.max(currentData.filter((m) => m.heartRateAvg).length, 1);
    const previousHR =
      previousData
        .filter((m) => m.heartRateAvg)
        .reduce((sum, m) => sum + (m.heartRateAvg || 0), 0) /
      Math.max(previousData.filter((m) => m.heartRateAvg).length, 1);

    if (currentHR > 0 || previousHR > 0) {
      trends.push(
        this.createTrend('heart_rate', currentHR, previousHR, period),
      );
    }

    // Sleep trend
    const currentSleep =
      currentData
        .filter((m) => m.sleepDuration)
        .reduce((sum, m) => sum + (m.sleepDuration || 0), 0) /
      Math.max(currentData.filter((m) => m.sleepDuration).length, 1);
    const previousSleep =
      previousData
        .filter((m) => m.sleepDuration)
        .reduce((sum, m) => sum + (m.sleepDuration || 0), 0) /
      Math.max(previousData.filter((m) => m.sleepDuration).length, 1);

    if (currentSleep > 0 || previousSleep > 0) {
      trends.push(
        this.createTrend('sleep_duration', currentSleep, previousSleep, period),
      );
    }

    return trends;
  }

  /**
   * Create a trend object
   */
  private createTrend(
    metric: string,
    currentValue: number,
    previousValue: number,
    period: 'day' | 'week' | 'month' | 'year',
  ): HealthTrend {
    const change = currentValue - previousValue;
    const changePercentage =
      previousValue > 0 ? (change / previousValue) * 100 : 0;

    let direction: 'up' | 'down' | 'stable' = 'stable';
    if (Math.abs(changePercentage) > 5) {
      direction = change > 0 ? 'up' : 'down';
    }

    const confidence = Math.min(
      100,
      Math.max(0, 100 - Math.abs(changePercentage) * 2),
    );

    return {
      metric,
      currentValue,
      previousValue,
      change,
      changePercentage,
      direction,
      period:
        period === 'day' ? 'daily' : period === 'week' ? 'weekly' : 'monthly',
      confidence,
    };
  }

  /**
   * Generate health insights based on metrics and trends
   */
  private generateInsights(
    metrics: AggregatedHealthData['metrics'],
    trends: HealthTrend[],
  ): HealthInsight[] {
    const insights: HealthInsight[] = [];

    // Step count insights
    if (metrics.steps.average > 0) {
      if (metrics.steps.average < 8000) {
        insights.push({
          type: 'recommendation',
          title: 'Increase Daily Activity',
          description: `Your average daily steps (${Math.round(metrics.steps.average)}) is below the recommended 8,000-10,000 steps.`,
          severity: 'medium',
          confidence: 85,
          actionable: true,
          recommendations: [
            'Take the stairs instead of elevators',
            'Walk during phone calls',
            'Park further away from destinations',
            'Take short walking breaks every hour',
          ],
        });
      } else if (metrics.steps.average >= 10000) {
        insights.push({
          type: 'goal_achieved',
          title: 'Excellent Activity Level',
          description: `Great job! You're averaging ${Math.round(metrics.steps.average)} steps per day, exceeding the recommended daily target.`,
          severity: 'low',
          confidence: 90,
          actionable: false,
        });
      }
    }

    // Heart rate insights
    if (metrics.heartRate.resting > 0) {
      if (metrics.heartRate.resting > 100) {
        insights.push({
          type: 'warning',
          title: 'Elevated Resting Heart Rate',
          description: `Your resting heart rate (${Math.round(metrics.heartRate.resting)} bpm) is above the normal range. Consider consulting a healthcare provider.`,
          severity: 'high',
          confidence: 80,
          actionable: true,
          recommendations: [
            'Consult with a healthcare provider',
            'Monitor stress levels',
            'Ensure adequate hydration',
            'Check medication side effects',
          ],
        });
      } else if (
        metrics.heartRate.resting < 60 &&
        metrics.heartRate.resting > 40
      ) {
        insights.push({
          type: 'improvement',
          title: 'Excellent Cardiovascular Fitness',
          description: `Your resting heart rate (${Math.round(metrics.heartRate.resting)} bpm) indicates excellent cardiovascular fitness.`,
          severity: 'low',
          confidence: 85,
          actionable: false,
        });
      }
    }

    // Sleep insights
    if (metrics.sleep.averageDuration > 0) {
      const sleepHours = metrics.sleep.averageDuration / 60;
      if (sleepHours < 7) {
        insights.push({
          type: 'recommendation',
          title: 'Insufficient Sleep Duration',
          description: `You're averaging ${sleepHours.toFixed(1)} hours of sleep per night. Adults need 7-9 hours for optimal health.`,
          severity: 'medium',
          confidence: 90,
          actionable: true,
          recommendations: [
            'Establish a consistent bedtime routine',
            'Avoid screens 1 hour before bed',
            'Keep your bedroom cool and dark',
            'Limit caffeine after 2 PM',
          ],
        });
      } else if (sleepHours >= 7 && sleepHours <= 9) {
        insights.push({
          type: 'goal_achieved',
          title: 'Optimal Sleep Duration',
          description: `You're getting ${sleepHours.toFixed(1)} hours of sleep per night, which is within the recommended range.`,
          severity: 'low',
          confidence: 95,
          actionable: false,
        });
      }
    }

    // Trend-based insights
    const stepsTrend = trends.find((t) => t.metric === 'steps');
    if (
      stepsTrend &&
      stepsTrend.direction === 'down' &&
      stepsTrend.changePercentage < -20
    ) {
      insights.push({
        type: 'warning',
        title: 'Declining Activity Levels',
        description: `Your daily steps have decreased by ${Math.abs(stepsTrend.changePercentage).toFixed(1)}% compared to the previous period.`,
        severity: 'medium',
        confidence: stepsTrend.confidence,
        actionable: true,
        trend: {
          direction: stepsTrend.direction,
          percentage: stepsTrend.changePercentage,
          period: stepsTrend.period,
        },
        recommendations: [
          'Schedule regular walking or exercise sessions',
          'Set hourly movement reminders',
          'Find enjoyable physical activities',
        ],
      });
    }

    return insights;
  }

  /**
   * Generate personalized health goals
   */
  private generateHealthGoals(
    analysis: AggregatedHealthData['metrics'],
  ): HealthGoal[] {
    const goals: HealthGoal[] = [];

    // Steps goal
    if (analysis.steps.average > 0) {
      const currentSteps = Math.round(analysis.steps.average);
      const targetSteps = Math.min(currentSteps + 1000, 12000);

      goals.push({
        type: 'steps',
        title: 'Daily Steps Goal',
        current: currentSteps,
        target: targetSteps,
        timeframe: 'daily',
        priority: currentSteps < 7500 ? 'high' : 'medium',
      });
    }

    // Sleep goal
    if (analysis.sleep.averageDuration > 0) {
      const currentMinutes = analysis.sleep.averageDuration;
      const targetMinutes = Math.max(420, Math.min(currentMinutes + 30, 540)); // 7-9 hours

      goals.push({
        type: 'sleep',
        title: 'Sleep Duration Goal',
        current: Math.round(analysis.sleep.averageDuration),
        target: Math.round(targetMinutes),
        timeframe: 'daily',
        priority: currentMinutes < 420 ? 'high' : 'medium',
      });
    }

    // Activity goal
    if (analysis.activity.activeMinutes > 0) {
      const weeklyActiveMinutes = analysis.activity.activeMinutes;

      goals.push({
        type: 'activity',
        title: 'Weekly Active Minutes',
        current: weeklyActiveMinutes,
        target: Math.min(weeklyActiveMinutes + 30, 150),
        timeframe: 'weekly',
        priority: weeklyActiveMinutes < 150 ? 'high' : 'medium',
      });
    }

    return goals;
  }

  /**
   * Assess the quality of health data
   */
  private assessDataQuality(
    healthMetrics: HealthMetricRow[],
    healthRecords: any[],
  ): DataQuality {
    if (healthMetrics.length === 0 && healthRecords.length === 0) {
      return DataQuality.POOR;
    }

    const totalDays = healthMetrics.length;
    const daysWithData = healthMetrics.filter(
      (m) => m.steps || m.heartRateAvg || m.sleepDuration,
    ).length;

    const dataCompleteness = totalDays > 0 ? daysWithData / totalDays : 0;

    if (dataCompleteness >= 0.8) {
      return DataQuality.EXCELLENT;
    } else if (dataCompleteness >= 0.5) {
      return DataQuality.GOOD;
    } else if (dataCompleteness >= 0.2) {
      return DataQuality.FAIR;
    } else {
      return DataQuality.POOR;
    }
  }

  /**
   * Store analysis results for future reference
   */
  async storeAnalysisResults(
    userId: string,
    analysisResult: AggregatedHealthData,
  ): Promise<void> {
    try {
      // Store the analysis results in a dedicated table (if exists)
      // For now, we'll log the results
      this.logger.log(
        `Storing analysis results for user ${userId}: ${analysisResult.insights.length} insights, ${analysisResult.trends.length} trends`,
      );

      // TODO: Implement storage in database if HealthAnalysis model is added to schema
      // await this.prisma.healthAnalysis.create({
      //   data: {
      //     userId,
      //     period: analysisResult.period,
      //     startDate: analysisResult.startDate,
      //     endDate: analysisResult.endDate,
      //     results: JSON.stringify(analysisResult),
      //     createdAt: new Date(),
      //   },
      // });
    } catch (error) {
      this.logger.error(
        `Failed to store analysis results for user ${userId}:`,
        error,
      );
      throw error;
    }
  }

  /**
   * Get latest analysis results for a user
   */
  async getLatestAnalysis(
    userId: string,
  ): Promise<AggregatedHealthData | null> {
    try {
      // For now, generate fresh analysis
      const endDate = new Date();
      const startDate = new Date();
      startDate.setDate(startDate.getDate() - 7); // Last week

      return this.analyzeHealthData(userId, startDate, endDate, 'week');
    } catch (error) {
      this.logger.error(
        `Failed to get latest analysis for user ${userId}:`,
        error,
      );
      return null;
    }
  }
}
