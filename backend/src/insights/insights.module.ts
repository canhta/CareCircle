import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { AIModule } from '../ai/ai.module';
import { InsightGeneratorService } from './insight-generator.service';

@Module({
  imports: [PrismaModule, AIModule],
  providers: [InsightGeneratorService],
  exports: [InsightGeneratorService],
})
export class InsightsModule {}
