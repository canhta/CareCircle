import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { OpenAIService } from './openai.service';
import { EmbeddingService } from './embedding.service';
import { PersonalizedQuestionService } from './personalized-question.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [ConfigModule, PrismaModule],
  providers: [OpenAIService, EmbeddingService, PersonalizedQuestionService],
  exports: [OpenAIService, EmbeddingService, PersonalizedQuestionService],
})
export class AIModule {}
