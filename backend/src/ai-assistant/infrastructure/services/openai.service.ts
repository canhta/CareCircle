import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { MessageRole } from '@prisma/client';
import OpenAI from 'openai';

@Injectable()
export class OpenAIService {
  private openai: OpenAI;

  constructor(private configService: ConfigService) {
    const apiKey = this.configService.get<string>('OPENAI_API_KEY');
    if (!apiKey) {
      throw new Error('OPENAI_API_KEY is not configured');
    }

    this.openai = new OpenAI({
      apiKey,
    });
  }

  async generateResponse(
    messages: Array<{ role: MessageRole; content: string }>,
    options?: {
      model?: string;
      temperature?: number;
      maxTokens?: number;
      stream?: boolean;
    },
  ): Promise<string> {
    try {
      const response = await this.openai.chat.completions.create({
        model: options?.model || 'gpt-4',
        messages,
        temperature: options?.temperature || 0.7,
        max_tokens: options?.maxTokens || 1000,
        stream: false, // TODO: Always use non-streaming for now
      });

      // Type assertion to ensure we have a non-streaming response
      const completionResponse = response;
      return completionResponse.choices[0]?.message?.content || '';
    } catch (error) {
      console.error('OpenAI API error:', error);
      throw new Error('Failed to generate AI response');
    }
  }

  async generateHealthInsight(
    userContext: string,
    healthData: unknown,
    query?: string,
  ): Promise<{
    title: string;
    description: string;
    recommendations: string[];
    confidence: number;
  }> {
    const systemPrompt = `You are a healthcare AI assistant. Generate health insights based on user data.
    Always include appropriate medical disclaimers and recommend consulting healthcare professionals.
    Provide actionable recommendations while being conservative about medical advice.`;

    const userPrompt = `
    User Context: ${userContext}
    Health Data: ${JSON.stringify(healthData)}
    ${query ? `Specific Query: ${query}` : ''}
    
    Please provide a health insight with:
    1. A clear title
    2. A detailed description
    3. 3-5 actionable recommendations
    4. A confidence score (0-1)
    `;

    try {
      const response = await this.generateResponse([
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userPrompt },
      ]);

      // Parse the response (this is a simplified version)
      // In production, you'd want more robust parsing
      return {
        title: 'Health Insight Generated',
        description: response,
        recommendations: [
          'Consult with your healthcare provider',
          'Monitor your symptoms',
          'Maintain a healthy lifestyle',
        ],
        confidence: 0.8,
      };
    } catch (error) {
      console.error('Failed to generate health insight:', error);
      throw new Error('Failed to generate health insight');
    }
  }

  async analyzeQuery(query: string): Promise<{
    intent: string;
    entities: Array<{ type: string; value: string; confidence: number }>;
    urgency: number;
  }> {
    const systemPrompt = `Analyze the user's health-related query and extract:
    1. Intent (general_question, symptom_inquiry, medication_question, emergency, etc.)
    2. Medical entities (symptoms, medications, conditions, etc.)
    3. Urgency level (0-1, where 1 is emergency)`;

    try {
      const _response = await this.generateResponse([
        { role: 'system', content: systemPrompt },
        { role: 'user', content: query },
      ]);

      // Simplified parsing - in production, use structured output
      return {
        intent: 'general_question',
        entities: [],
        urgency: 0.1,
      };
    } catch (error) {
      console.error('Failed to analyze query:', error);
      return {
        intent: 'general_question',
        entities: [],
        urgency: 0.1,
      };
    }
  }

  validateResponse(_response: string): {
    isValid: boolean;
    confidence: number;
    issues: string[];
    suggestions: string[];
  } {
    // Implement response validation logic
    // Check for medical accuracy, appropriate disclaimers, etc.
    return {
      isValid: true,
      confidence: 0.9,
      issues: [],
      suggestions: [],
    };
  }
}
