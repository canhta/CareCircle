import { Injectable } from '@nestjs/common';
import { HealthMetricService } from './health-metric.service';
import { HealthProfileService } from './health-profile.service';
import { MetricType } from '@prisma/client';

export interface HealthInsight {
  id: string;
  type: 'trend' | 'anomaly' | 'goal' | 'recommendation';
  title: string;
  description: string;
  severity: 'info' | 'warning' | 'critical';
  metricType?: MetricType;
  data: unknown;
  recommendations: string[];
  createdAt: Date;
}

export interface HealthReport {
  userId: string;
  period: {
    startDate: Date;
    endDate: Date;
  };
  summary: {
    totalMetrics: number;
    activeGoals: number;
    achievedGoals: number;
    healthScore: number;
  };
  insights: HealthInsight[];
  trends: {
    metricType: MetricType;
    trend: 'increasing' | 'decreasing' | 'stable';
    change: number;
  }[];
  anomalies: {
    metricType: MetricType;
    count: number;
    severity: 'low' | 'medium' | 'high';
  }[];
}

@Injectable()
export class HealthAnalyticsService {
  constructor(
    private readonly healthMetricService: HealthMetricService,
    private readonly healthProfileService: HealthProfileService,
  ) {}

  async generateHealthInsights(userId: string): Promise<HealthInsight[]> {
    const insights: HealthInsight[] = [];

    // Get user's health profile
    const profile = await this.healthProfileService.getProfileByUserId(userId);
    if (!profile) {
      return insights;
    }

    // Analyze trends for key metrics
    const keyMetrics = [
      MetricType.HEART_RATE,
      MetricType.BLOOD_PRESSURE,
      MetricType.WEIGHT,
      MetricType.STEPS,
    ];

    for (const metricType of keyMetrics) {
      try {
        const trendInsight = await this.analyzeTrend(userId, metricType);
        if (trendInsight) {
          insights.push(trendInsight);
        }

        const anomalyInsight = await this.analyzeAnomalies(userId, metricType);
        if (anomalyInsight) {
          insights.push(anomalyInsight);
        }
      } catch (_error) {
        console.error(
          `Error analyzing ${metricType} for user ${userId}:`,
          _error,
        );
      }
    }

    // Analyze goal progress
    const goalInsights = await this.analyzeGoalProgress(userId);
    insights.push(...goalInsights);

    return insights.sort((a, b) => {
      const severityOrder = { critical: 3, warning: 2, info: 1 };
      return severityOrder[b.severity] - severityOrder[a.severity];
    });
  }

  async generateHealthReport(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<HealthReport> {
    const profile = await this.healthProfileService.getProfileByUserId(userId);
    if (!profile) {
      throw new Error('Health profile not found');
    }

    const healthScore =
      await this.healthProfileService.calculateHealthScore(userId);
    const insights = await this.generateHealthInsights(userId);

    // Calculate total metrics in period
    const totalMetrics = await this.healthMetricService.getMetricCount(userId);

    // Analyze trends
    const trends = this.analyzeTrends(userId, startDate, endDate);

    // Analyze anomalies
    const anomalies = this.analyzeAnomaliesForPeriod(
      userId,
      startDate,
      endDate,
    );

    return {
      userId,
      period: { startDate, endDate },
      summary: {
        totalMetrics,
        activeGoals: profile.getActiveGoals().length,
        achievedGoals: profile.getAchievedGoals().length,
        healthScore: healthScore.score,
      },
      insights,
      trends,
      anomalies,
    };
  }

  private async analyzeTrend(
    userId: string,
    metricType: MetricType,
  ): Promise<HealthInsight | null> {
    try {
      const trendData = await this.healthMetricService.getMetricTrend(
        userId,
        metricType,
        30,
      );
      if (trendData.length < 5) return null;

      // Simple trend analysis
      const firstHalf = trendData.slice(0, Math.floor(trendData.length / 2));
      const secondHalf = trendData.slice(Math.floor(trendData.length / 2));

      const firstAvg =
        firstHalf.reduce((sum, d) => sum + d.value, 0) / firstHalf.length;
      const secondAvg =
        secondHalf.reduce((sum, d) => sum + d.value, 0) / secondHalf.length;

      const change = ((secondAvg - firstAvg) / firstAvg) * 100;
      const trend =
        change > 5 ? 'increasing' : change < -5 ? 'decreasing' : 'stable';

      if (trend === 'stable') return null;

      const severity = Math.abs(change) > 20 ? 'warning' : 'info';

      return {
        id: this.generateId(),
        type: 'trend',
        title: `${metricType.replace('_', ' ')} Trend`,
        description: `Your ${metricType.replace('_', ' ')} has been ${trend} by ${Math.abs(change).toFixed(1)}% over the last 30 days.`,
        severity,
        metricType,
        data: { trend, change, trendData },
        recommendations: this.getTrendRecommendations(
          metricType,
          trend,
          change,
        ),
        createdAt: new Date(),
      };
    } catch (_error) {
      return null;
    }
  }

  private async analyzeAnomalies(
    userId: string,
    metricType: MetricType,
  ): Promise<HealthInsight | null> {
    try {
      const anomalyData = await this.healthMetricService.detectAnomalies(
        userId,
        metricType,
        30,
      );
      if (anomalyData.anomalies.length === 0) return null;

      const severity = anomalyData.anomalies.length > 5 ? 'warning' : 'info';

      return {
        id: this.generateId(),
        type: 'anomaly',
        title: `${metricType.replace('_', ' ')} Anomalies`,
        description: `Found ${anomalyData.anomalies.length} unusual ${metricType.replace('_', ' ')} readings in the last 30 days.`,
        severity,
        metricType,
        data: anomalyData,
        recommendations: this.getAnomalyRecommendations(
          metricType,
          anomalyData.anomalies.length,
        ),
        createdAt: new Date(),
      };
    } catch (_error) {
      return null;
    }
  }

  private async analyzeGoalProgress(userId: string): Promise<HealthInsight[]> {
    const profile = await this.healthProfileService.getProfileByUserId(userId);
    if (!profile) return [];

    const insights: HealthInsight[] = [];
    const activeGoals = profile.getActiveGoals();

    for (const goal of activeGoals) {
      const daysRemaining = Math.ceil(
        (goal.targetDate.getTime() - new Date().getTime()) /
          (1000 * 60 * 60 * 24),
      );

      let severity: 'info' | 'warning' | 'critical' = 'info';
      if (goal.progress < 25 && daysRemaining < 7) severity = 'critical';
      else if (goal.progress < 50 && daysRemaining < 14) severity = 'warning';

      insights.push({
        id: this.generateId(),
        type: 'goal',
        title: `Goal Progress: ${goal.metricType}`,
        description: `You're ${goal.progress}% towards your ${goal.metricType} goal with ${daysRemaining} days remaining.`,
        severity,
        data: { goal, daysRemaining },
        recommendations: this.getGoalRecommendations(goal, daysRemaining),
        createdAt: new Date(),
      });
    }

    return insights;
  }

  private analyzeTrends(
    _userId: string,
    _startDate: Date,
    _endDate: Date,
  ): HealthReport['trends'] {
    // Placeholder implementation
    return [];
  }

  private analyzeAnomaliesForPeriod(
    _userId: string,
    _startDate: Date,
    _endDate: Date,
  ): HealthReport['anomalies'] {
    // Placeholder implementation
    return [];
  }

  private getTrendRecommendations(
    _metricType: MetricType,
    _trend: string,
    _change: number,
  ): string[] {
    // Placeholder recommendations
    return [
      `Monitor your ${_metricType.replace('_', ' ')} closely`,
      'Consult with your healthcare provider',
    ];
  }

  private getAnomalyRecommendations(
    _metricType: MetricType,
    _count: number,
  ): string[] {
    // Placeholder recommendations
    return [
      `Review your ${_metricType.replace('_', ' ')} readings`,
      'Consider device calibration',
    ];
  }

  private getGoalRecommendations(_goal: any, _daysRemaining: number): string[] {
    // Placeholder recommendations
    return ['Stay consistent with your routine', 'Track progress daily'];
  }

  private generateId(): string {
    return `hi_${Date.now()}_${Math.random().toString(36).substring(2, 11)}`;
  }
}
