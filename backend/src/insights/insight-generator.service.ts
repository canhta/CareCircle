import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { OpenAIService } from '../ai/openai.service';
import { ResponseAnalysisResult } from '../analytics/response-analysis.service';
import { InteractionInsights } from '../analytics/user-interaction.service';

export interface HealthInsight {
  id: string;
  type: 'positive' | 'concern' | 'trend' | 'medication' | 'lifestyle';
  title: string;
  description: string;
  severity: 'low' | 'medium' | 'high';
  confidence: number; // 0-1
  supportingData: string[];
  relatedMetrics: string[];
  timeframe: string;
}

export interface UserHealthContext {
  age?: number;
  gender?: string;
  prescriptions: any[];
  careGroupContext: any[];
}

@Injectable()
export class InsightGeneratorService {
  private readonly logger = new Logger(InsightGeneratorService.name);

  constructor(
    private readonly configService: ConfigService,
    private readonly openaiService: OpenAIService,
  ) {}

  async generateKeyInsights(
    userId: string,
    analysisResult: ResponseAnalysisResult,
    vectorInsights: InteractionInsights,
    userContext: UserHealthContext,
  ): Promise<HealthInsight[]> {
    const insights: HealthInsight[] = [];

    // Generate insights from anomalies
    for (const anomaly of vectorInsights.anomalies) {
      insights.push({
        id: `anomaly_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        type: 'concern',
        title: `${anomaly.type.replace('_', ' ')} Anomaly Detected`,
        description: anomaly.description,
        severity: anomaly.severity,
        confidence: 0.8,
        supportingData: [anomaly.description],
        relatedMetrics: [anomaly.type],
        timeframe: 'Current',
      });
    }

    // Generate insights from trends
    if (vectorInsights.behaviorTrends.overallTrend === 'improving') {
      insights.push({
        id: `trend_positive_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        type: 'positive',
        title: 'Positive Health Trend',
        description:
          'Your overall health metrics are showing improvement over time.',
        severity: 'low',
        confidence: 0.9,
        supportingData: [
          'Overall trend analysis',
          'Multiple metric improvements',
        ],
        relatedMetrics: ['mood', 'energy', 'sleep'],
        timeframe: 'Last 30 days',
      });
    } else if (vectorInsights.behaviorTrends.overallTrend === 'declining') {
      insights.push({
        id: `trend_concern_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        type: 'concern',
        title: 'Declining Health Trend',
        description:
          'Your health metrics are showing a concerning downward trend.',
        severity: 'medium',
        confidence: 0.85,
        supportingData: ['Trend analysis', 'Multiple declining metrics'],
        relatedMetrics: ['mood', 'energy', 'sleep'],
        timeframe: 'Last 30 days',
      });
    }

    // Generate medication-related insights
    if (userContext.prescriptions.length > 0) {
      const medicationInsight = this.generateMedicationInsights(
        userContext.prescriptions,
      );
      if (medicationInsight) {
        insights.push(medicationInsight);
      }
    }

    // Generate AI-powered contextual insights
    const aiInsights = await this.generateAIContextualInsights(
      analysisResult,
      vectorInsights,
      userContext,
    );
    insights.push(...aiInsights);

    return insights;
  }

  private generateMedicationInsights(
    prescriptions: any[],
  ): HealthInsight | null {
    if (prescriptions.length === 0) return null;

    const medicationNames = prescriptions
      .map((p) => p.medicationName)
      .join(', ');

    return {
      id: `medication_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      type: 'medication',
      title: 'Medication Monitoring',
      description: `You are currently taking ${prescriptions.length} medication(s): ${medicationNames}. Monitor for any side effects or changes in effectiveness.`,
      severity: 'low',
      confidence: 0.9,
      supportingData: [`${prescriptions.length} active prescriptions`],
      relatedMetrics: ['symptoms', 'side_effects'],
      timeframe: 'Ongoing',
    };
  }

  private async generateAIContextualInsights(
    analysisResult: ResponseAnalysisResult,
    vectorInsights: InteractionInsights,
    userContext: UserHealthContext,
  ): Promise<HealthInsight[]> {
    try {
      const prompt = this.buildInsightsPrompt(
        analysisResult,
        vectorInsights,
        userContext,
      );

      const response = await this.openaiService.createCompletion(prompt, {
        model: this.configService.get<string>('OPENAI_MODEL') || 'gpt-4',
        temperature: 0.3,
        maxTokens: 1000,
      });

      const parsedInsights = this.parseAIInsights(response);
      return parsedInsights;
    } catch (error) {
      this.logger.error('Error generating AI contextual insights:', error);
      return [];
    }
  }

  private buildInsightsPrompt(
    analysisResult: ResponseAnalysisResult,
    vectorInsights: InteractionInsights,
    userContext: UserHealthContext,
  ): string {
    return `
You are a healthcare AI assistant specializing in generating personalized health insights from daily check-in data.

User Context:
- Age: ${userContext.age || 'Not specified'}
- Gender: ${userContext.gender || 'Not specified'}
- Medications: ${userContext.prescriptions.length} active prescriptions
- Care Group: ${userContext.careGroupContext.length > 0 ? 'Yes' : 'No'}

Current Analysis:
- Sentiment Score: ${analysisResult.sentimentScore} (${analysisResult.sentimentLabel})
- Risk Level: ${analysisResult.riskLevel}
- Risk Score: ${analysisResult.riskScore}/10
- Key Insights: ${analysisResult.keyInsights.join(', ')}
- Health Concerns: ${analysisResult.healthConcerns.join(', ')}

Behavior Trends:
- Overall Trend: ${vectorInsights.behaviorTrends.overallTrend}
- Mood Trend: ${vectorInsights.behaviorTrends.moodTrend}
- Energy Trend: ${vectorInsights.behaviorTrends.energyTrend}
- Sleep Trend: ${vectorInsights.behaviorTrends.sleepTrend}

Similar Patterns Found: ${vectorInsights.similarPatterns.length} similar interactions

Generate 2-3 personalized health insights in JSON format:
[
  {
    "type": "positive|concern|trend|medication|lifestyle",
    "title": "Brief insight title",
    "description": "Detailed description of the insight",
    "severity": "low|medium|high",
    "confidence": 0.8,
    "supportingData": ["data point 1", "data point 2"],
    "relatedMetrics": ["metric1", "metric2"],
    "timeframe": "Current|Last 7 days|Last 30 days"
  }
]

Focus on actionable, personalized insights that consider the user's specific context and patterns.
`;
  }

  private parseAIInsights(response: string): HealthInsight[] {
    try {
      const parsed = JSON.parse(response);
      return parsed.map((insight: any, index: number) => ({
        id: `ai_insight_${Date.now()}_${index}`,
        type: insight.type || 'trend',
        title: insight.title || 'Health Insight',
        description: insight.description || '',
        severity: insight.severity || 'low',
        confidence: insight.confidence || 0.7,
        supportingData: insight.supportingData || [],
        relatedMetrics: insight.relatedMetrics || [],
        timeframe: insight.timeframe || 'Current',
      }));
    } catch (error) {
      this.logger.error('Error parsing AI insights:', error);
      return [];
    }
  }
}
