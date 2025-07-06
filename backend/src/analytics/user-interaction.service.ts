import { Injectable, Logger } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import {
  MilvusService,
  UserInteractionVector,
  SimilarInteraction,
} from '../vector/milvus.service';
import { EmbeddingService } from '../ai/embedding.service';
import { DailyCheckIn } from '@prisma/client';
import {
  UserInteractionData,
  InteractionInsights,
  EmbeddingInput,
} from '../common/interfaces/user-interaction.interfaces';

// Re-export interfaces for use in other modules
export {
  UserInteractionData,
  InteractionInsights,
} from '../common/interfaces/user-interaction.interfaces';

@Injectable()
export class UserInteractionService {
  private readonly logger = new Logger(UserInteractionService.name);

  constructor(
    private readonly milvusService: MilvusService,
    private readonly embeddingService: EmbeddingService,
  ) {}

  async storeUserInteraction(
    interactionData: UserInteractionData,
  ): Promise<void> {
    try {
      // Create embedding input
      const embeddingInput: EmbeddingInput = {
        userId: interactionData.userId,
        checkInId: interactionData.checkInId,
        responses: interactionData.questionResponses,
        metadata: {
          moodScore: interactionData.checkInData.moodScore ?? undefined,
          energyLevel: interactionData.checkInData.energyLevel ?? undefined,
          sleepQuality: interactionData.checkInData.sleepQuality ?? undefined,
          painLevel: interactionData.checkInData.painLevel ?? undefined,
          stressLevel: interactionData.checkInData.stressLevel ?? undefined,
          symptoms: interactionData.checkInData.symptoms ?? undefined,
          timestamp: interactionData.checkInData.date,
        },
      };

      // Generate embedding
      const embedding =
        await this.embeddingService.createEmbedding(embeddingInput);

      // Create interaction vector
      const interactionVector: UserInteractionVector = {
        id: uuidv4(),
        userId: interactionData.userId,
        checkInId: interactionData.checkInId,
        interactionType: 'daily_check_in',
        timestamp: interactionData.checkInData.date,
        vector: embedding,
        metadata: {
          questionId: interactionData.questionResponses[0]?.questionId,
          responseText: interactionData.questionResponses
            .map(
              (r) =>
                `${r.questionText}: ${Array.isArray(r.answer) ? r.answer.join(', ') : String(r.answer)}`,
            )
            .join('; '),
          sentiment: interactionData.analysisResults?.sentiment,
          moodScore: interactionData.checkInData.moodScore ?? undefined,
          energyLevel: interactionData.checkInData.energyLevel ?? undefined,
          sleepQuality: interactionData.checkInData.sleepQuality ?? undefined,
          painLevel: interactionData.checkInData.painLevel ?? undefined,
          stressLevel: interactionData.checkInData.stressLevel ?? undefined,
          symptoms: interactionData.checkInData.symptoms ?? undefined,
          riskScore: interactionData.analysisResults?.riskScore,
          category: interactionData.questionResponses[0]?.category || 'general',
        },
      };

      // Store in vector database
      await this.milvusService.storeUserInteraction(interactionVector);

      this.logger.log(`Stored interaction for user ${interactionData.userId}`);
    } catch (error) {
      this.logger.error('Failed to store user interaction', error);
      throw error;
    }
  }

  async getInteractionInsights(
    userId: string,
    currentInteraction?: UserInteractionData,
  ): Promise<InteractionInsights> {
    try {
      let queryVector: number[] | undefined;

      // If current interaction is provided, use it to find similar patterns
      if (currentInteraction) {
        const embeddingInput: EmbeddingInput = {
          userId: currentInteraction.userId,
          checkInId: currentInteraction.checkInId,
          responses: currentInteraction.questionResponses,
          metadata: {
            moodScore: currentInteraction.checkInData.moodScore ?? undefined,
            energyLevel:
              currentInteraction.checkInData.energyLevel ?? undefined,
            sleepQuality:
              currentInteraction.checkInData.sleepQuality ?? undefined,
            painLevel: currentInteraction.checkInData.painLevel ?? undefined,
            stressLevel:
              currentInteraction.checkInData.stressLevel ?? undefined,
            symptoms: currentInteraction.checkInData.symptoms ?? undefined,
            timestamp: currentInteraction.checkInData.date,
          },
        };

        queryVector =
          await this.embeddingService.createEmbedding(embeddingInput);
      }

      // Get similar interactions
      const similarPatterns = queryVector
        ? await this.milvusService.findSimilarInteractions(
            userId,
            queryVector,
            10,
          )
        : [];

      // Get user interaction history for trend analysis
      const interactionHistory =
        await this.milvusService.getUserInteractionHistory(userId, 30);

      // Analyze trends
      const behaviorTrends = this.analyzeBehaviorTrends(interactionHistory);

      // Generate recommendations
      const recommendations = this.generateRecommendations(
        similarPatterns,
        behaviorTrends,
        currentInteraction,
      );

      // Identify risk factors
      const riskFactors = this.identifyRiskFactors(
        similarPatterns,
        interactionHistory,
        currentInteraction,
      );

      // Detect anomalies
      const anomalies = this.detectAnomalies(
        interactionHistory,
        currentInteraction,
      );

      return {
        similarPatterns,
        behaviorTrends,
        recommendations,
        riskFactors,
        anomalies,
      };
    } catch (error) {
      this.logger.error('Failed to get interaction insights', error);
      throw error;
    }
  }

  private analyzeBehaviorTrends(
    history: UserInteractionVector[],
  ): InteractionInsights['behaviorTrends'] {
    if (history.length < 3) {
      return {
        moodTrend: 'stable',
        energyTrend: 'stable',
        sleepTrend: 'stable',
        overallTrend: 'stable',
      };
    }

    // Sort by timestamp (most recent first)
    const sortedHistory = history.sort(
      (a, b) => b.timestamp.getTime() - a.timestamp.getTime(),
    );

    // Analyze trends for each metric
    const moodTrend = this.calculateTrend(
      sortedHistory
        .map((h) => h.metadata.moodScore)
        .filter((m) => m !== undefined),
    );

    const energyTrend = this.calculateTrend(
      sortedHistory
        .map((h) => h.metadata.energyLevel)
        .filter((e) => e !== undefined),
    );

    const sleepTrend = this.calculateTrend(
      sortedHistory
        .map((h) => h.metadata.sleepQuality)
        .filter((s) => s !== undefined),
    );

    // Calculate overall trend
    const trends = [moodTrend, energyTrend, sleepTrend];
    const improvingCount = trends.filter((t) => t === 'improving').length;
    const decliningCount = trends.filter((t) => t === 'declining').length;

    let overallTrend: 'improving' | 'declining' | 'stable' = 'stable';
    if (improvingCount > decliningCount) {
      overallTrend = 'improving';
    } else if (decliningCount > improvingCount) {
      overallTrend = 'declining';
    }

    return {
      moodTrend,
      energyTrend,
      sleepTrend,
      overallTrend,
    };
  }

  private calculateTrend(
    values: number[],
  ): 'improving' | 'declining' | 'stable' {
    if (values.length < 3) return 'stable';

    // Calculate linear regression slope
    const n = values.length;
    const xSum = (n * (n - 1)) / 2; // Sum of indices (0, 1, 2, ...)
    const ySum = values.reduce((sum, val) => sum + val, 0);
    const xySum = values.reduce((sum, val, index) => sum + val * index, 0);
    const x2Sum = values.reduce((sum, _, index) => sum + index * index, 0);

    const slope = (n * xySum - xSum * ySum) / (n * x2Sum - xSum * xSum);

    // Determine trend based on slope
    if (slope > 0.1) return 'improving';
    if (slope < -0.1) return 'declining';
    return 'stable';
  }

  private generateRecommendations(
    similarPatterns: SimilarInteraction[],
    trends: InteractionInsights['behaviorTrends'],
    currentInteraction?: UserInteractionData,
  ): string[] {
    const recommendations: string[] = [];

    // Trend-based recommendations
    if (trends.moodTrend === 'declining') {
      recommendations.push(
        'Consider incorporating mood-boosting activities like exercise or meditation',
      );
    }

    if (trends.energyTrend === 'declining') {
      recommendations.push(
        'Focus on improving sleep quality and consider adjusting daily routines',
      );
    }

    if (trends.sleepTrend === 'declining') {
      recommendations.push(
        'Establish a consistent bedtime routine and limit screen time before bed',
      );
    }

    // Pattern-based recommendations
    if (similarPatterns.length > 0) {
      const commonSymptoms = this.findCommonSymptoms(similarPatterns);
      if (commonSymptoms.length > 0) {
        recommendations.push(
          `Monitor recurring symptoms: ${commonSymptoms.join(', ')}`,
        );
      }
    }

    // Current state recommendations
    if (currentInteraction) {
      const riskScore = currentInteraction.analysisResults?.riskScore || 0;
      if (riskScore > 7) {
        recommendations.push(
          'Consider reaching out to your healthcare provider',
        );
      }
    }

    return recommendations;
  }

  private identifyRiskFactors(
    similarPatterns: SimilarInteraction[],
    history: UserInteractionVector[],
    currentInteraction?: UserInteractionData,
  ): string[] {
    const riskFactors: string[] = [];

    // High risk scores
    const highRiskInteractions = history.filter(
      (h) => h.metadata.riskScore && h.metadata.riskScore > 7,
    );

    if (highRiskInteractions.length > 0) {
      riskFactors.push('Recent high-risk health indicators detected');
    }

    // Recurring symptoms
    const allSymptoms = history.flatMap((h) => h.metadata.symptoms || []);
    const symptomCounts = allSymptoms.reduce(
      (counts, symptom) => {
        counts[symptom] = (counts[symptom] || 0) + 1;
        return counts;
      },
      {} as Record<string, number>,
    );

    const recurringSymptoms = Object.entries(symptomCounts)
      .filter(([, count]) => count >= 3)
      .map(([symptom]) => symptom);

    if (recurringSymptoms.length > 0) {
      riskFactors.push(`Recurring symptoms: ${recurringSymptoms.join(', ')}`);
    }

    // Current interaction risk
    if (
      currentInteraction?.analysisResults?.riskScore &&
      currentInteraction.analysisResults.riskScore > 6
    ) {
      riskFactors.push('Current interaction shows elevated risk levels');
    }

    return riskFactors;
  }

  private detectAnomalies(
    history: UserInteractionVector[],
    currentInteraction?: UserInteractionData,
  ): InteractionInsights['anomalies'] {
    const anomalies: InteractionInsights['anomalies'] = [];

    if (!currentInteraction || history.length < 5) {
      return anomalies;
    }

    // Calculate baselines
    const moodBaseline = this.calculateBaseline(
      history.map((h) => h.metadata.moodScore).filter((m) => m !== undefined),
    );

    const energyBaseline = this.calculateBaseline(
      history.map((h) => h.metadata.energyLevel).filter((e) => e !== undefined),
    );

    // Check for anomalies
    const currentMood = currentInteraction.checkInData.moodScore;
    const currentEnergy = currentInteraction.checkInData.energyLevel;

    if (
      currentMood &&
      Math.abs(currentMood - moodBaseline.mean) > 2 * moodBaseline.std
    ) {
      anomalies.push({
        type: 'mood_anomaly',
        description: `Mood score significantly ${
          currentMood > moodBaseline.mean ? 'higher' : 'lower'
        } than usual`,
        severity:
          Math.abs(currentMood - moodBaseline.mean) > 3 * moodBaseline.std
            ? 'high'
            : 'medium',
      });
    }

    if (
      currentEnergy &&
      Math.abs(currentEnergy - energyBaseline.mean) > 2 * energyBaseline.std
    ) {
      anomalies.push({
        type: 'energy_anomaly',
        description: `Energy level significantly ${
          currentEnergy > energyBaseline.mean ? 'higher' : 'lower'
        } than usual`,
        severity:
          Math.abs(currentEnergy - energyBaseline.mean) > 3 * energyBaseline.std
            ? 'high'
            : 'medium',
      });
    }

    return anomalies;
  }

  private calculateBaseline(values: number[]): { mean: number; std: number } {
    if (values.length === 0) return { mean: 0, std: 0 };

    const mean = values.reduce((sum, val) => sum + val, 0) / values.length;
    const variance =
      values.reduce((sum, val) => sum + Math.pow(val - mean, 2), 0) /
      values.length;
    const std = Math.sqrt(variance);

    return { mean, std };
  }

  private findCommonSymptoms(patterns: SimilarInteraction[]): string[] {
    const allSymptoms = patterns.flatMap((p) => p.metadata.symptoms || []);
    const symptomCounts = allSymptoms.reduce(
      (counts, symptom) => {
        counts[symptom] = (counts[symptom] || 0) + 1;
        return counts;
      },
      {} as Record<string, number>,
    );

    return Object.entries(symptomCounts)
      .filter(([, count]) => count >= 2)
      .map(([symptom]) => symptom);
  }

  async deleteUserData(userId: string): Promise<void> {
    try {
      await this.milvusService.deleteUserInteractions(userId);
      this.logger.log(`Deleted all interaction data for user ${userId}`);
    } catch (error) {
      this.logger.error('Failed to delete user data', error);
      throw error;
    }
  }
}
