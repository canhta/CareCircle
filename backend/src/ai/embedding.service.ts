import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import OpenAI from 'openai';

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

@Injectable()
export class EmbeddingService {
  private readonly logger = new Logger(EmbeddingService.name);
  private readonly openai: OpenAI;

  constructor(private configService: ConfigService) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('OPENAI_API_KEY'),
    });
  }

  async createEmbedding(input: EmbeddingInput): Promise<number[]> {
    try {
      // Create a text representation of the user interaction
      const textToEmbed = this.createTextRepresentation(input);

      const response = await this.openai.embeddings.create({
        model: 'text-embedding-3-small',
        input: textToEmbed,
        encoding_format: 'float',
      });

      if (!response.data[0]?.embedding) {
        throw new Error('Failed to generate embedding');
      }

      this.logger.log(`Generated embedding for user ${input.userId}`);
      return response.data[0].embedding;
    } catch (error) {
      this.logger.error('Failed to create embedding', error);
      throw error;
    }
  }

  private createTextRepresentation(input: EmbeddingInput): string {
    const parts: string[] = [];

    // Add user context
    parts.push(`User: ${input.userId}`);

    // Add timestamp context
    parts.push(`Date: ${input.metadata.timestamp.toISOString()}`);

    // Add numeric health metrics
    if (input.metadata.moodScore !== undefined) {
      parts.push(`Mood: ${input.metadata.moodScore}/10`);
    }

    if (input.metadata.energyLevel !== undefined) {
      parts.push(`Energy: ${input.metadata.energyLevel}/10`);
    }

    if (input.metadata.sleepQuality !== undefined) {
      parts.push(`Sleep: ${input.metadata.sleepQuality}/10`);
    }

    if (input.metadata.painLevel !== undefined) {
      parts.push(`Pain: ${input.metadata.painLevel}/10`);
    }

    if (input.metadata.stressLevel !== undefined) {
      parts.push(`Stress: ${input.metadata.stressLevel}/10`);
    }

    // Add symptoms
    if (input.metadata.symptoms && input.metadata.symptoms.length > 0) {
      parts.push(`Symptoms: ${input.metadata.symptoms.join(', ')}`);
    }

    // Add question-answer pairs
    input.responses.forEach((response) => {
      parts.push(`Q: ${response.questionText}`);
      parts.push(
        `A: ${Array.isArray(response.answer) ? response.answer.join(', ') : String(response.answer)}`,
      );
      parts.push(`Category: ${response.category}`);
    });

    return parts.join('\n');
  }

  async createBatchEmbeddings(inputs: EmbeddingInput[]): Promise<number[][]> {
    try {
      const texts = inputs.map((input) => this.createTextRepresentation(input));

      const response = await this.openai.embeddings.create({
        model: 'text-embedding-3-small',
        input: texts,
        encoding_format: 'float',
      });

      if (!response.data || response.data.length !== inputs.length) {
        throw new Error('Failed to generate batch embeddings');
      }

      this.logger.log(`Generated ${inputs.length} embeddings`);
      return response.data.map((item) => item.embedding);
    } catch (error) {
      this.logger.error('Failed to create batch embeddings', error);
      throw error;
    }
  }

  async findSimilarText(
    queryText: string,
    candidateTexts: string[],
  ): Promise<{ text: string; similarity: number }[]> {
    try {
      const allTexts = [queryText, ...candidateTexts];
      const embeddings = await this.createBatchEmbeddings(
        allTexts.map((text, index) => ({
          userId: 'query',
          checkInId: `temp-${index}`,
          responses: [
            {
              questionId: 'temp',
              questionText: 'Text analysis',
              answer: text,
              category: 'general',
            },
          ],
          metadata: {
            timestamp: new Date(),
          },
        })),
      );

      const queryEmbedding = embeddings[0];
      const candidateEmbeddings = embeddings.slice(1);

      const similarities = candidateEmbeddings.map((embedding, index) => ({
        text: candidateTexts[index],
        similarity: this.cosineSimilarity(queryEmbedding, embedding),
      }));

      return similarities.sort((a, b) => b.similarity - a.similarity);
    } catch (error) {
      this.logger.error('Failed to find similar text', error);
      throw error;
    }
  }

  private cosineSimilarity(a: number[], b: number[]): number {
    if (a.length !== b.length) {
      throw new Error('Vectors must have the same length');
    }

    let dotProduct = 0;
    let normA = 0;
    let normB = 0;

    for (let i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }

    return dotProduct / (Math.sqrt(normA) * Math.sqrt(normB));
  }
}
