import { Injectable, Logger } from '@nestjs/common';
import { ResponseAnalysisResult } from '../analytics/response-analysis.service';
import { InteractionInsights } from '../analytics/user-interaction.service';

@Injectable()
export class HealthScoreCalculatorService {
  private readonly logger = new Logger(HealthScoreCalculatorService.name);

  calculateOverallHealthScore(
    analysisResult: ResponseAnalysisResult,
    vectorInsights: InteractionInsights,
    historicalPatterns: any,
  ): number {
    // Base score from sentiment and risk
    let score = 50; // Start with neutral

    // Sentiment contribution (40% of score)
    const sentimentContribution =
      ((analysisResult.sentimentScore + 1) / 2) * 40;
    score += sentimentContribution;

    // Risk score contribution (30% of score, inverted)
    const riskContribution = (10 - analysisResult.riskScore) * 3;
    score += riskContribution;

    // Trend contribution (20% of score)
    const trendContribution = this.calculateTrendContribution(
      vectorInsights.behaviorTrends,
    );
    score += trendContribution;

    // Consistency contribution (10% of score)
    const consistencyContribution =
      this.calculateConsistencyContribution(historicalPatterns);
    score += consistencyContribution;

    return Math.max(0, Math.min(100, Math.round(score)));
  }

  private calculateTrendContribution(
    trends: InteractionInsights['behaviorTrends'],
  ): number {
    const trendValues = {
      improving: 20,
      stable: 10,
      declining: -10,
    };

    const overallTrendValue = trendValues[trends.overallTrend] || 0;
    return overallTrendValue * 0.2; // 20% of total possible contribution
  }

  private calculateConsistencyContribution(historicalPatterns: any): number {
    const checkIns = historicalPatterns.checkIns || [];
    const daysWithData = checkIns.length;
    const expectedDays = 30;

    // More consistent data = higher score
    const consistencyRatio = Math.min(daysWithData / expectedDays, 1);
    return consistencyRatio * 10; // 10% of total possible contribution
  }

  calculatePredictionConfidence(checkIns: any[]): number {
    const dataPoints = checkIns.length;
    if (dataPoints < 7) return 0.5;
    if (dataPoints < 14) return 0.7;
    if (dataPoints < 21) return 0.8;
    return 0.9;
  }

  calculateTrendMagnitude(
    values: number[],
  ): 'slight' | 'moderate' | 'significant' {
    if (values.length < 3) return 'slight';

    const range = Math.max(...values) - Math.min(...values);
    if (range <= 1) return 'slight';
    if (range <= 2) return 'moderate';
    return 'significant';
  }

  calculateAverageMetrics(checkIns: any[]): any {
    if (checkIns.length === 0) return {};

    const totals = checkIns.reduce(
      (acc, checkIn) => ({
        moodScore: acc.moodScore + (checkIn.moodScore || 0),
        energyLevel: acc.energyLevel + (checkIn.energyLevel || 0),
        sleepQuality: acc.sleepQuality + (checkIn.sleepQuality || 0),
        painLevel: acc.painLevel + (checkIn.painLevel || 0),
        stressLevel: acc.stressLevel + (checkIn.stressLevel || 0),
        count: acc.count + 1,
      }),
      {
        moodScore: 0,
        energyLevel: 0,
        sleepQuality: 0,
        painLevel: 0,
        stressLevel: 0,
        count: 0,
      },
    );

    return {
      avgMoodScore: totals.moodScore / totals.count,
      avgEnergyLevel: totals.energyLevel / totals.count,
      avgSleepQuality: totals.sleepQuality / totals.count,
      avgPainLevel: totals.painLevel / totals.count,
      avgStressLevel: totals.stressLevel / totals.count,
    };
  }

  calculateAge(dateOfBirth: Date): number {
    const today = new Date();
    const birthDate = new Date(dateOfBirth);
    let age = today.getFullYear() - birthDate.getFullYear();
    const monthDiff = today.getMonth() - birthDate.getMonth();

    if (
      monthDiff < 0 ||
      (monthDiff === 0 && today.getDate() < birthDate.getDate())
    ) {
      age--;
    }

    return age;
  }
}
