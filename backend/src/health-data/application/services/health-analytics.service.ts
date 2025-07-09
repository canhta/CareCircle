import { Injectable, Inject } from '@nestjs/common';
import { HealthMetricService } from './health-metric.service';
import { HealthProfileService } from './health-profile.service';
import { HealthMetricRepository } from '../../domain/repositories/health-metric.repository';
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
    @Inject('HealthMetricRepository')
    private readonly healthMetricRepository: HealthMetricRepository,
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
        title: `${metricType.replace('_', ' ')} Trend Analysis`,
        description: `Your ${metricType.replace('_', ' ')} shows a ${trend} trend with ${Math.abs(change).toFixed(1)}% change over the last 30 days.`,
        severity,
        metricType,
        data: { trend, change, dataPoints: trendData.length },
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
      // Use TimescaleDB anomaly detection function
      const anomalyData = await this.healthMetricRepository.detectAnomalies(
        userId,
        metricType,
        30,
        2.0, // 2 standard deviations threshold
      );

      if (anomalyData.totalAnomalies === 0) return null;

      // Determine severity based on anomaly rate
      const severity = anomalyData.anomalyRate > 0.15 ? 'warning' : 'info';

      return {
        id: this.generateId(),
        type: 'anomaly',
        title: `${metricType.replace('_', ' ')} Anomaly Detection`,
        description: `Detected ${anomalyData.totalAnomalies} unusual ${metricType.replace('_', ' ')} readings (${(anomalyData.anomalyRate * 100).toFixed(1)}% anomaly rate) in the last 30 days.`,
        severity,
        metricType,
        data: {
          totalAnomalies: anomalyData.totalAnomalies,
          anomalyRate: anomalyData.anomalyRate,
          recentAnomalies: anomalyData.anomalies.slice(0, 5), // Show only recent 5
        },
        recommendations: this.getAnomalyRecommendations(
          metricType,
          anomalyData.totalAnomalies,
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
