import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { AIModule } from '../ai/ai.module';
import { RecommendationGeneratorService } from './recommendation-generator.service';

@Module({
  imports: [PrismaModule, AIModule],
  providers: [RecommendationGeneratorService],
  exports: [RecommendationGeneratorService],
})
export class RecommendationsModule {}
