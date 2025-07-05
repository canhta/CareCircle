import {
  SimilarInteraction,
  UserInteractionVector,
} from '../../vector/milvus.service';
import { DailyCheckIn } from '@prisma/client';

/**
 * Interface for user interaction data
 */
export interface UserInteractionData {
  userId: string;
  checkInId: string;
  checkInData: DailyCheckIn;
  questionResponses: {
    questionId: string;
    questionText: string;
    answer: string | number | boolean;
    category: string;
  }[];
  analysisResults?: {
    sentiment?: number;
    riskScore?: number;
    healthConcerns?: string[];
    trends?: string[];
  };
}

/**
 * Interface for interaction insights
 */
export interface InteractionInsights {
  similarPatterns: SimilarInteraction[];
  behaviorTrends: {
    moodTrend: 'improving' | 'declining' | 'stable';
    energyTrend: 'improving' | 'declining' | 'stable';
    sleepTrend: 'improving' | 'declining' | 'stable';
    overallTrend: 'improving' | 'declining' | 'stable';
  };
  recommendations: string[];
  riskFactors: string[];
  anomalies: {
    type: string;
    description: string;
    severity: 'low' | 'medium' | 'high';
  }[];
}

/**
 * Interface for embedding input
 */
export interface EmbeddingInput {
  userId: string;
  checkInId: string;
  responses: {
    questionId: string;
    questionText: string;
    answer: string | number | boolean;
    category: string;
  }[];
  metadata: {
    moodScore?: number;
    energyLevel?: number;
    sleepQuality?: number;
    painLevel?: number;
    stressLevel?: number;
    symptoms?: string[];
    timestamp: Date;
  };
}
