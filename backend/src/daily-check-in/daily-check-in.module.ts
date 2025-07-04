import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DailyCheckInService } from './daily-check-in.service';
import { DailyCheckInController } from './daily-check-in.controller';
import { PersonalizedQuestionService } from './personalized-question.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [ConfigModule, PrismaModule],
  providers: [DailyCheckInService, PersonalizedQuestionService],
  controllers: [DailyCheckInController],
  exports: [DailyCheckInService, PersonalizedQuestionService],
})
export class DailyCheckInModule {}
