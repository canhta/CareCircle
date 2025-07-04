import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import OpenAI from 'openai';

@Injectable()
export class OpenAIService {
  private readonly logger = new Logger(OpenAIService.name);
  private readonly openai: OpenAI;

  constructor(private readonly configService: ConfigService) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('OPENAI_API_KEY'),
    });
  }

  async createCompletion(
    prompt: string,
    options?: {
      model?: string;
      temperature?: number;
      maxTokens?: number;
    },
  ): Promise<string> {
    try {
      const response = await this.openai.chat.completions.create({
        model: options?.model || 'gpt-3.5-turbo',
        messages: [{ role: 'user', content: prompt }],
        temperature: options?.temperature || 0.7,
        max_tokens: options?.maxTokens || 1000,
      });

      return response.choices[0]?.message?.content || '';
    } catch (error) {
      this.logger.error('Failed to create completion', error);
      throw error;
    }
  }

  async createEmbedding(
    text: string,
    model: string = 'text-embedding-3-small',
  ): Promise<number[]> {
    try {
      const response = await this.openai.embeddings.create({
        model,
        input: text,
        encoding_format: 'float',
      });

      if (!response.data[0]?.embedding) {
        throw new Error('Failed to generate embedding');
      }

      return response.data[0].embedding;
    } catch (error) {
      this.logger.error('Failed to create embedding', error);
      throw error;
    }
  }

  async createBatchEmbeddings(
    texts: string[],
    model: string = 'text-embedding-3-small',
  ): Promise<number[][]> {
    try {
      const response = await this.openai.embeddings.create({
        model,
        input: texts,
        encoding_format: 'float',
      });

      if (!response.data || response.data.length !== texts.length) {
        throw new Error('Failed to generate batch embeddings');
      }

      return response.data.map((item) => item.embedding);
    } catch (error) {
      this.logger.error('Failed to create batch embeddings', error);
      throw error;
    }
  }

  async analyzeHealthResponse(
    response: string,
    context?: {
      previousResponses?: string[];
      healthMetrics?: Record<string, number>;
      symptoms?: string[];
    },
  ): Promise<{
    sentiment: number;
    concerns: string[];
    recommendations: string[];
    riskLevel: 'low' | 'medium' | 'high';
  }> {
    try {
      const contextInfo = context
        ? `
        Previous responses: ${context.previousResponses?.join(', ') || 'None'}
        Health metrics: ${JSON.stringify(context.healthMetrics || {})}
        Current symptoms: ${context.symptoms?.join(', ') || 'None'}
      `
        : '';

      const prompt = `
        You are a health AI assistant. Analyze the following user health response and provide insights:
        
        User response: "${response}"
        ${contextInfo}
        
        Please provide a JSON response with:
        1. sentiment: A number between -1 (very negative) and 1 (very positive)
        2. concerns: Array of specific health concerns identified
        3. recommendations: Array of actionable recommendations
        4. riskLevel: 'low', 'medium', or 'high'
        
        Focus on identifying patterns, potential health issues, and providing constructive advice.
      `;

      const result = await this.createCompletion(prompt, {
        model: 'gpt-4',
        temperature: 0.3,
      });

      try {
        return JSON.parse(result);
      } catch (parseError) {
        // Fallback analysis if JSON parsing fails
        return {
          sentiment: 0,
          concerns: [],
          recommendations: [
            'Please provide more specific details about your health status',
          ],
          riskLevel: 'low' as const,
        };
      }
    } catch (error) {
      this.logger.error('Failed to analyze health response', error);
      throw error;
    }
  }

  async generatePersonalizedQuestions(profile: {
    age?: number;
    gender?: string;
    healthHistory?: string[];
    recentSymptoms?: string[];
    medications?: string[];
    previousResponses?: string[];
  }): Promise<{
    questions: {
      id: string;
      question: string;
      type: 'scale' | 'multiple_choice' | 'text' | 'boolean';
      options?: string[];
      category: string;
    }[];
  }> {
    try {
      const prompt = `
        Generate 5 personalized daily health check-in questions for a user with the following profile:
        
        Age: ${profile.age || 'Not specified'}
        Gender: ${profile.gender || 'Not specified'}
        Health History: ${profile.healthHistory?.join(', ') || 'None'}
        Recent Symptoms: ${profile.recentSymptoms?.join(', ') || 'None'}
        Medications: ${profile.medications?.join(', ') || 'None'}
        Previous Responses: ${profile.previousResponses?.join(', ') || 'None'}
        
        Please provide a JSON response with an array of questions, each having:
        - id: unique identifier
        - question: the question text
        - type: 'scale', 'multiple_choice', 'text', or 'boolean'
        - options: array of options (for multiple_choice only)
        - category: 'mood', 'energy', 'sleep', 'pain', 'stress', 'symptoms', 'medication', or 'general'
        
        Make questions relevant to the user's profile and health concerns.
      `;

      const result = await this.createCompletion(prompt, {
        model: 'gpt-4',
        temperature: 0.5,
      });

      try {
        return JSON.parse(result);
      } catch (parseError) {
        // Fallback questions if JSON parsing fails
        return {
          questions: [
            {
              id: 'mood-1',
              question: 'How would you rate your overall mood today?',
              type: 'scale' as const,
              category: 'mood',
            },
            {
              id: 'energy-1',
              question: 'How energetic do you feel right now?',
              type: 'scale' as const,
              category: 'energy',
            },
          ],
        };
      }
    } catch (error) {
      this.logger.error('Failed to generate personalized questions', error);
      throw error;
    }
  }
}
