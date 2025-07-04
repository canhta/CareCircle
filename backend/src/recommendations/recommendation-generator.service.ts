import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { OpenAIService } from '../ai/openai.service';
import { ResponseAnalysisResult } from '../analytics/response-analysis.service';
import { InteractionInsights } from '../analytics/user-interaction.service';
import {
  HealthInsight,
  UserHealthContext,
} from '../insights/insight-generator.service';

export interface PersonalizedRecommendation {
  id: string;
  category:
    | 'health'
    | 'medication'
    | 'lifestyle'
    | 'exercise'
    | 'nutrition'
    | 'sleep'
    | 'stress';
  title: string;
  description: string;
  priority: 'low' | 'medium' | 'high';
  difficulty: 'easy' | 'moderate' | 'challenging';
  estimatedImpact: 'low' | 'medium' | 'high';
  actionSteps: string[];
  expectedOutcome: string;
  timeframe: string;
  personalizationFactors: string[];
}

@Injectable()
export class RecommendationGeneratorService {
  private readonly logger = new Logger(RecommendationGeneratorService.name);

  constructor(
    private readonly configService: ConfigService,
    private readonly openaiService: OpenAIService,
  ) {}

  async generatePersonalizedRecommendations(
    userId: string,
    analysisResult: ResponseAnalysisResult,
    vectorInsights: InteractionInsights,
    userContext: UserHealthContext,
    keyInsights: HealthInsight[],
  ): Promise<PersonalizedRecommendation[]> {
    const recommendations: PersonalizedRecommendation[] = [];

    // Generate recommendations based on trends
    if (vectorInsights.behaviorTrends.moodTrend === 'declining') {
      recommendations.push({
        id: `mood_rec_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        category: 'health',
        title: 'Improve Mood Management',
        description:
          'Your mood scores have been declining. Consider incorporating mood-boosting activities.',
        priority: 'medium',
        difficulty: 'moderate',
        estimatedImpact: 'high',
        actionSteps: [
          'Practice daily meditation for 10 minutes',
          'Engage in physical exercise 3 times per week',
          'Maintain regular sleep schedule',
          'Connect with friends and family',
        ],
        expectedOutcome: 'Improved mood stability and overall well-being',
        timeframe: '2-4 weeks',
        personalizationFactors: [
          'mood trend',
          'user age',
          'current medications',
        ],
      });
    }

    if (vectorInsights.behaviorTrends.sleepTrend === 'declining') {
      recommendations.push({
        id: `sleep_rec_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        category: 'sleep',
        title: 'Optimize Sleep Quality',
        description:
          'Your sleep quality has been declining. Focus on improving sleep hygiene.',
        priority: 'high',
        difficulty: 'easy',
        estimatedImpact: 'high',
        actionSteps: [
          'Establish a consistent bedtime routine',
          'Avoid screens 1 hour before bed',
          'Keep bedroom cool and dark',
          'Limit caffeine after 2 PM',
        ],
        expectedOutcome: 'Better sleep quality and daytime energy',
        timeframe: '1-2 weeks',
        personalizationFactors: ['sleep trend', 'energy levels', 'age'],
      });
    }

    if (vectorInsights.behaviorTrends.energyTrend === 'declining') {
      recommendations.push({
        id: `energy_rec_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        category: 'exercise',
        title: 'Boost Energy Levels',
        description:
          'Your energy levels have been declining. Consider gentle exercise and nutrition improvements.',
        priority: 'medium',
        difficulty: 'easy',
        estimatedImpact: 'medium',
        actionSteps: [
          'Take a 10-minute walk daily',
          'Stay hydrated throughout the day',
          'Eat nutrient-rich breakfast',
          'Take short breaks every hour',
        ],
        expectedOutcome: 'Increased energy and vitality',
        timeframe: '1-3 weeks',
        personalizationFactors: ['energy trend', 'activity level', 'diet'],
      });
    }

    // Generate AI-powered personalized recommendations
    const aiRecommendations = await this.generateAIPersonalizedRecommendations(
      analysisResult,
      vectorInsights,
      userContext,
      keyInsights,
    );
    recommendations.push(...aiRecommendations);

    return recommendations;
  }

  private async generateAIPersonalizedRecommendations(
    analysisResult: ResponseAnalysisResult,
    vectorInsights: InteractionInsights,
    userContext: UserHealthContext,
    keyInsights: HealthInsight[],
  ): Promise<PersonalizedRecommendation[]> {
    try {
      const prompt = this.buildRecommendationsPrompt(
        analysisResult,
        vectorInsights,
        userContext,
        keyInsights,
      );

      const response = await this.openaiService.createCompletion(prompt, {
        model: this.configService.get<string>('OPENAI_MODEL') || 'gpt-4',
        temperature: 0.3,
        maxTokens: 1200,
      });

      const parsedRecommendations = this.parseAIRecommendations(response);
      return parsedRecommendations;
    } catch (error) {
      this.logger.error(
        'Error generating AI personalized recommendations:',
        error,
      );
      return [];
    }
  }

  private buildRecommendationsPrompt(
    analysisResult: ResponseAnalysisResult,
    vectorInsights: InteractionInsights,
    userContext: UserHealthContext,
    keyInsights: HealthInsight[],
  ): string {
    return `
You are a healthcare AI assistant specializing in generating personalized health recommendations.

User Context:
- Age: ${userContext.age || 'Not specified'}
- Gender: ${userContext.gender || 'Not specified'}
- Medications: ${userContext.prescriptions.length} active prescriptions
- Care Group Support: ${userContext.careGroupContext.length > 0 ? 'Yes' : 'No'}

Current Health Status:
- Risk Level: ${analysisResult.riskLevel}
- Risk Score: ${analysisResult.riskScore}/10
- Sentiment: ${analysisResult.sentimentLabel}
- Recommended Actions: ${analysisResult.recommendedActions.join(', ')}

Behavior Trends:
- Overall: ${vectorInsights.behaviorTrends.overallTrend}
- Mood: ${vectorInsights.behaviorTrends.moodTrend}
- Energy: ${vectorInsights.behaviorTrends.energyTrend}
- Sleep: ${vectorInsights.behaviorTrends.sleepTrend}

Key Insights:
${keyInsights.map((insight) => `- ${insight.title}: ${insight.description}`).join('\n')}

Generate 2-3 personalized health recommendations in JSON format:
[
  {
    "category": "health|medication|lifestyle|exercise|nutrition|sleep|stress",
    "title": "Brief recommendation title",
    "description": "Detailed description of the recommendation",
    "priority": "low|medium|high",
    "difficulty": "easy|moderate|challenging",
    "estimatedImpact": "low|medium|high",
    "actionSteps": ["specific step 1", "specific step 2", "specific step 3"],
    "expectedOutcome": "What the user can expect to achieve",
    "timeframe": "Expected timeframe for results",
    "personalizationFactors": ["factor1", "factor2", "factor3"]
  }
]

Focus on actionable, personalized recommendations that consider the user's specific context, trends, and current health status.
`;
  }

  private parseAIRecommendations(
    response: string,
  ): PersonalizedRecommendation[] {
    try {
      const parsed = JSON.parse(response);
      return parsed.map((rec: any, index: number) => ({
        id: `ai_rec_${Date.now()}_${index}`,
        category: rec.category || 'health',
        title: rec.title || 'Health Recommendation',
        description: rec.description || '',
        priority: rec.priority || 'medium',
        difficulty: rec.difficulty || 'moderate',
        estimatedImpact: rec.estimatedImpact || 'medium',
        actionSteps: rec.actionSteps || [],
        expectedOutcome: rec.expectedOutcome || '',
        timeframe: rec.timeframe || '2-4 weeks',
        personalizationFactors: rec.personalizationFactors || [],
      }));
    } catch (error) {
      this.logger.error('Error parsing AI recommendations:', error);
      return [];
    }
  }
}
