import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { UserInteractionService } from './user-interaction.service';
import { ResponseAnalysisService } from './response-analysis.service';
import { VectorModule } from '../vector/vector.module';
import { AIModule } from '../ai/ai.module';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [ConfigModule, VectorModule, AIModule, PrismaModule],
  providers: [UserInteractionService, ResponseAnalysisService],
  exports: [UserInteractionService, ResponseAnalysisService],
})
export class AnalyticsModule {}
