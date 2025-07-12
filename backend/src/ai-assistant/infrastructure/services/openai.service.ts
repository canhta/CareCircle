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
        stream: false, // Non-streaming for backward compatibility
      });

      // Type assertion to ensure we have a non-streaming response
      const completionResponse = response;
      return completionResponse.choices[0]?.message?.content || '';
    } catch (error) {
      console.error('OpenAI API error:', error);
      throw new Error('Failed to generate AI response');
    }
  }

  async *generateStreamingResponse(
    messages: Array<{ role: MessageRole; content: string }>,
    options?: {
      model?: string;
      temperature?: number;
      maxTokens?: number;
    },
  ): AsyncGenerator<{
    content: string;
    isComplete: boolean;
    metadata?: {
      tokensUsed?: number;
      processingTime?: number;
      confidence?: number;
    };
  }> {
    try {
      const startTime = Date.now();
      let tokensUsed = 0;

      const stream = await this.openai.chat.completions.create({
        model: options?.model || 'gpt-4',
        messages,
        temperature: options?.temperature || 0.7,
        max_tokens: options?.maxTokens || 1000,
        stream: true, // Enable streaming
      });

      for await (const chunk of stream) {
        const delta = chunk.choices[0]?.delta;

        if (delta?.content) {
          tokensUsed++;

          yield {
            content: delta.content,
            isComplete: false,
            metadata: {
              tokensUsed,
              processingTime: Date.now() - startTime,
              confidence: 0.9, // TODO: Implement dynamic confidence scoring
            },
          };
        }

        // Check if the stream is complete
        if (chunk.choices[0]?.finish_reason) {
          yield {
            content: '',
            isComplete: true,
            metadata: {
              tokensUsed,
              processingTime: Date.now() - startTime,
              confidence: 0.9,
            },
          };
          break;
        }
      }
    } catch (error) {
      console.error('OpenAI streaming API error:', error);
      throw new Error('Failed to generate streaming AI response');
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
    const systemPrompt = `You are CareCircle's AI Health Assistant, a specialized healthcare AI designed to provide personalized health insights and recommendations.

IMPORTANT GUIDELINES:
- Always prioritize user safety and recommend consulting healthcare professionals for medical decisions
- Provide evidence-based insights when possible
- Be conservative with medical advice and clearly distinguish between general wellness tips and medical recommendations
- Include appropriate medical disclaimers
- Focus on actionable, practical recommendations
- Consider the user's specific health context and data patterns

RESPONSE FORMAT:
Provide your response as a JSON object with the following structure:
{
  "title": "Clear, specific title for the insight",
  "description": "Detailed explanation of the insight based on the data",
  "recommendations": ["actionable recommendation 1", "actionable recommendation 2", "actionable recommendation 3"],
  "confidence": 0.85,
  "disclaimer": "Important medical disclaimer"
}`;

    const userPrompt = `
USER CONTEXT: ${userContext}

HEALTH DATA: ${JSON.stringify(healthData, null, 2)}

${query ? `SPECIFIC QUERY: ${query}` : 'GENERAL INSIGHT REQUEST: Please analyze the health data and provide relevant insights.'}

Please analyze this health data and provide a personalized health insight following the specified JSON format.`;

    try {
      const response = await this.generateResponse(
        [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userPrompt },
        ],
        {
          temperature: 0.3, // Lower temperature for more consistent medical advice
          maxTokens: 1500,
        },
      );

      // Try to parse JSON response
      try {
        const parsedResponse = JSON.parse(response) as {
          title?: string;
          description?: string;
          recommendations?: string[];
          confidence?: number;
        };
        return {
          title: parsedResponse.title || 'Health Insight',
          description: parsedResponse.description || response,
          recommendations: Array.isArray(parsedResponse.recommendations)
            ? parsedResponse.recommendations
            : [
                'Consult with your healthcare provider for personalized advice',
                'Continue monitoring your health metrics regularly',
                'Maintain a balanced diet and regular exercise routine',
              ],
          confidence:
            typeof parsedResponse.confidence === 'number'
              ? Math.min(Math.max(parsedResponse.confidence, 0), 1)
              : 0.7,
        };
      } catch (_parseError) {
        // Fallback if JSON parsing fails
        console.warn(
          'Failed to parse OpenAI JSON response, using fallback format',
        );
        return {
          title: 'Health Analysis',
          description: response,
          recommendations: [
            'Consult with your healthcare provider for personalized advice',
            'Continue monitoring your health metrics regularly',
            'Maintain a balanced diet and regular exercise routine',
          ],
          confidence: 0.6,
        };
      }
    } catch (error) {
      console.error('Failed to generate health insight:', error);
      throw new Error(
        `Failed to generate health insight: ${(error as Error).message}`,
      );
    }
  }

  async analyzeQuery(query: string): Promise<{
    intent: string;
    entities: Array<{ type: string; value: string; confidence: number }>;
    urgency: number;
  }> {
    const systemPrompt = `You are a medical query analyzer. Analyze the user's health-related query and provide a JSON response with:

RESPONSE FORMAT:
{
  "intent": "one of: general_question, symptom_inquiry, medication_question, emergency, data_interpretation, lifestyle_advice",
  "entities": [
    {"type": "symptom|medication|condition|body_part|metric", "value": "extracted entity", "confidence": 0.9}
  ],
  "urgency": 0.8,
  "requires_immediate_attention": false
}

URGENCY LEVELS:
- 0.0-0.3: General wellness questions
- 0.4-0.6: Health concerns that should be monitored
- 0.7-0.8: Symptoms that warrant medical consultation
- 0.9-1.0: Emergency situations requiring immediate medical attention

EMERGENCY INDICATORS: chest pain, difficulty breathing, severe bleeding, loss of consciousness, severe allergic reactions, stroke symptoms, heart attack symptoms`;

    try {
      const response = await this.generateResponse(
        [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: `Analyze this health query: "${query}"` },
        ],
        {
          temperature: 0.1, // Very low temperature for consistent analysis
          maxTokens: 500,
        },
      );

      try {
        const parsedResponse = JSON.parse(response) as {
          intent?: string;
          entities?: Array<{ type: string; value: string; confidence: number }>;
          urgency?: number;
        };
        return {
          intent: parsedResponse.intent || 'general_question',
          entities: Array.isArray(parsedResponse.entities)
            ? parsedResponse.entities
            : [],
          urgency:
            typeof parsedResponse.urgency === 'number'
              ? Math.min(Math.max(parsedResponse.urgency, 0), 1)
              : 0.1,
        };
      } catch (_parseError) {
        console.warn('Failed to parse query analysis response, using fallback');
        // Simple keyword-based fallback analysis
        const urgency = this.calculateUrgencyFallback(query);
        return {
          intent: this.detectIntentFallback(query),
          entities: this.extractEntitiesFallback(query),
          urgency,
        };
      }
    } catch (error) {
      console.error('Failed to analyze query:', error);
      return {
        intent: 'general_question',
        entities: [],
        urgency: 0.1,
      };
    }
  }

  private calculateUrgencyFallback(query: string): number {
    const emergencyKeywords = [
      'chest pain',
      "can't breathe",
      'bleeding',
      'unconscious',
      'emergency',
      'severe pain',
    ];
    const highUrgencyKeywords = [
      'pain',
      'fever',
      'dizzy',
      'nausea',
      'vomiting',
    ];

    const lowerQuery = query.toLowerCase();

    if (emergencyKeywords.some((keyword) => lowerQuery.includes(keyword))) {
      return 0.9;
    }
    if (highUrgencyKeywords.some((keyword) => lowerQuery.includes(keyword))) {
      return 0.6;
    }
    return 0.2;
  }

  private detectIntentFallback(query: string): string {
    const lowerQuery = query.toLowerCase();

    if (
      lowerQuery.includes('medication') ||
      lowerQuery.includes('drug') ||
      lowerQuery.includes('pill')
    ) {
      return 'medication_question';
    }
    if (
      lowerQuery.includes('symptom') ||
      lowerQuery.includes('feel') ||
      lowerQuery.includes('pain')
    ) {
      return 'symptom_inquiry';
    }
    if (
      lowerQuery.includes('data') ||
      lowerQuery.includes('reading') ||
      lowerQuery.includes('measurement')
    ) {
      return 'data_interpretation';
    }
    return 'general_question';
  }

  private extractEntitiesFallback(
    query: string,
  ): Array<{ type: string; value: string; confidence: number }> {
    const entities: Array<{ type: string; value: string; confidence: number }> =
      [];
    const lowerQuery = query.toLowerCase();

    // Simple entity extraction based on common medical terms
    const symptoms = [
      'headache',
      'fever',
      'cough',
      'pain',
      'nausea',
      'dizziness',
    ];
    const bodyParts = [
      'head',
      'chest',
      'stomach',
      'back',
      'arm',
      'leg',
      'heart',
    ];

    symptoms.forEach((symptom) => {
      if (lowerQuery.includes(symptom)) {
        entities.push({ type: 'symptom', value: symptom, confidence: 0.7 });
      }
    });

    bodyParts.forEach((part) => {
      if (lowerQuery.includes(part)) {
        entities.push({ type: 'body_part', value: part, confidence: 0.6 });
      }
    });

    return entities;
  }

  async generateEmbedding(text: string): Promise<number[]> {
    try {
      const response = await this.openai.embeddings.create({
        model: 'text-embedding-ada-002',
        input: text,
      });

      return response.data[0].embedding;
    } catch (error) {
      console.error('OpenAI embedding API error:', error);
      throw new Error('Failed to generate embedding');
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
