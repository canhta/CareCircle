import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { InteractionInsights } from '../analytics/user-interaction.service';

export interface TrendAnalysis {
  overallTrend: 'improving' | 'stable' | 'declining';
  specificTrends: {
    mood: TrendDetail;
    energy: TrendDetail;
    sleep: TrendDetail;
    pain: TrendDetail;
    stress: TrendDetail;
    symptoms: TrendDetail;
  };
  predictionConfidence: number;
  forecastInsights: string[];
}

export interface TrendDetail {
  direction: 'improving' | 'stable' | 'declining';
  magnitude: 'slight' | 'moderate' | 'significant';
  timeframe: string;
  dataPoints: number;
  confidence: number;
}

@Injectable()
export class TrendAnalysisService {
  private readonly logger = new Logger(TrendAnalysisService.name);

  constructor(private readonly prisma: PrismaService) {}

  async generateTrendAnalysis(
    userId: string,
    vectorInsights: InteractionInsights,
    historicalPatterns: any,
  ): Promise<TrendAnalysis> {
    const checkIns = historicalPatterns.checkIns || [];

    return {
      overallTrend: vectorInsights.behaviorTrends.overallTrend,
      specificTrends: {
        mood: this.analyzeTrendDetail(
          checkIns,
          'moodScore',
          vectorInsights.behaviorTrends.moodTrend,
        ),
        energy: this.analyzeTrendDetail(
          checkIns,
          'energyLevel',
          vectorInsights.behaviorTrends.energyTrend,
        ),
        sleep: this.analyzeTrendDetail(
          checkIns,
          'sleepQuality',
          vectorInsights.behaviorTrends.sleepTrend,
        ),
        pain: this.analyzeTrendDetail(checkIns, 'painLevel', 'stable'),
        stress: this.analyzeTrendDetail(checkIns, 'stressLevel', 'stable'),
        symptoms: this.analyzeSymptomsTrend(checkIns),
      },
      predictionConfidence: this.calculatePredictionConfidence(checkIns),
      forecastInsights: await this.generateForecastInsights(
        userId,
        vectorInsights,
        historicalPatterns,
      ),
    };
  }

  private analyzeTrendDetail(
    checkIns: any[],
    metric: string,
    trend: string,
  ): TrendDetail {
    const values = checkIns
      .map((c) => c[metric])
      .filter((v) => v !== null && v !== undefined);

    return {
      direction: trend as 'improving' | 'stable' | 'declining',
      magnitude: this.calculateTrendMagnitude(values),
      timeframe: `${checkIns.length} days`,
      dataPoints: values.length,
      confidence: values.length > 7 ? 0.8 : 0.6,
    };
  }

  private analyzeSymptomsTrend(checkIns: any[]): TrendDetail {
    const symptomCounts = checkIns.map((c) => (c.symptoms || []).length);
    const avgSymptoms =
      symptomCounts.reduce((a, b) => a + b, 0) / symptomCounts.length;

    return {
      direction: avgSymptoms > 2 ? 'declining' : 'stable',
      magnitude: avgSymptoms > 3 ? 'significant' : 'slight',
      timeframe: `${checkIns.length} days`,
      dataPoints: symptomCounts.length,
      confidence: 0.7,
    };
  }

  private calculateTrendMagnitude(
    values: number[],
  ): 'slight' | 'moderate' | 'significant' {
    if (values.length < 3) return 'slight';

    const range = Math.max(...values) - Math.min(...values);
    if (range <= 1) return 'slight';
    if (range <= 2) return 'moderate';
    return 'significant';
  }

  private calculatePredictionConfidence(checkIns: any[]): number {
    const dataPoints = checkIns.length;
    if (dataPoints < 7) return 0.5;
    if (dataPoints < 14) return 0.7;
    if (dataPoints < 21) return 0.8;
    return 0.9;
  }

  private async generateForecastInsights(
    userId: string,
    vectorInsights: InteractionInsights,
    historicalPatterns: any,
  ): Promise<string[]> {
    const insights: string[] = [];

    if (vectorInsights.behaviorTrends.overallTrend === 'improving') {
      insights.push(
        'If current trends continue, you may see sustained improvement in overall well-being',
      );
    } else if (vectorInsights.behaviorTrends.overallTrend === 'declining') {
      insights.push(
        'Early intervention may help prevent further decline in health metrics',
      );
    }

    if (historicalPatterns.checkIns.length > 14) {
      insights.push(
        'Your consistent data collection provides reliable trend predictions',
      );
    }

    return insights;
  }
}
