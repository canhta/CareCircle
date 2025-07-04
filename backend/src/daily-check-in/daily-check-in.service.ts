import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { PersonalizedQuestionService } from './personalized-question.service';
import {
  CreateDailyCheckInDto,
  UpdateDailyCheckInDto,
  GenerateQuestionsDto,
  PersonalizedQuestionDto,
  AnswerQuestionDto,
  CheckInResponseDto,
} from './dto/daily-check-in.dto';

@Injectable()
export class DailyCheckInService {
  private readonly logger = new Logger(DailyCheckInService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly personalizedQuestionService: PersonalizedQuestionService,
  ) {}

  async createCheckIn(
    userId: string,
    createCheckInDto: CreateDailyCheckInDto,
  ): Promise<CheckInResponseDto> {
    try {
      const checkIn = await this.prisma.dailyCheckIn.create({
        data: {
          userId,
          date: new Date(createCheckInDto.date),
          moodScore: createCheckInDto.moodScore,
          energyLevel: createCheckInDto.energyLevel,
          sleepQuality: createCheckInDto.sleepQuality,
          painLevel: createCheckInDto.painLevel,
          stressLevel: createCheckInDto.stressLevel,
          symptoms: createCheckInDto.symptoms || [],
          notes: createCheckInDto.notes,
          completed: createCheckInDto.completed || false,
          completedAt: createCheckInDto.completed ? new Date() : null,
        },
      });

      return this.formatCheckInResponse(checkIn);
    } catch (error) {
      this.logger.error('Error creating check-in:', error);
      throw error;
    }
  }

  async updateCheckIn(
    userId: string,
    checkInId: string,
    updateCheckInDto: UpdateDailyCheckInDto,
  ): Promise<CheckInResponseDto> {
    try {
      const existingCheckIn = await this.prisma.dailyCheckIn.findFirst({
        where: {
          id: checkInId,
          userId,
        },
      });

      if (!existingCheckIn) {
        throw new NotFoundException('Check-in not found');
      }

      const updatedCheckIn = await this.prisma.dailyCheckIn.update({
        where: { id: checkInId },
        data: {
          moodScore: updateCheckInDto.moodScore,
          energyLevel: updateCheckInDto.energyLevel,
          sleepQuality: updateCheckInDto.sleepQuality,
          painLevel: updateCheckInDto.painLevel,
          stressLevel: updateCheckInDto.stressLevel,
          symptoms: updateCheckInDto.symptoms,
          notes: updateCheckInDto.notes,
          completed: updateCheckInDto.completed,
          completedAt: updateCheckInDto.completed
            ? new Date()
            : existingCheckIn.completedAt,
        },
      });

      return this.formatCheckInResponse(updatedCheckIn);
    } catch (error) {
      this.logger.error('Error updating check-in:', error);
      throw error;
    }
  }

  async getCheckInById(
    userId: string,
    checkInId: string,
  ): Promise<CheckInResponseDto> {
    try {
      const checkIn = await this.prisma.dailyCheckIn.findFirst({
        where: {
          id: checkInId,
          userId,
        },
      });

      if (!checkIn) {
        throw new NotFoundException('Check-in not found');
      }

      return this.formatCheckInResponse(checkIn);
    } catch (error) {
      this.logger.error('Error fetching check-in:', error);
      throw error;
    }
  }

  async getCheckInByDate(
    userId: string,
    date: string,
  ): Promise<CheckInResponseDto | null> {
    try {
      const checkIn = await this.prisma.dailyCheckIn.findFirst({
        where: {
          userId,
          date: new Date(date),
        },
      });

      if (!checkIn) {
        return null;
      }

      return this.formatCheckInResponse(checkIn);
    } catch (error) {
      this.logger.error('Error fetching check-in by date:', error);
      throw error;
    }
  }

  async getRecentCheckIns(
    userId: string,
    limit = 30,
  ): Promise<CheckInResponseDto[]> {
    try {
      const checkIns = await this.prisma.dailyCheckIn.findMany({
        where: { userId },
        orderBy: { date: 'desc' },
        take: limit,
      });

      return checkIns.map((checkIn) => this.formatCheckInResponse(checkIn));
    } catch (error) {
      this.logger.error('Error fetching recent check-ins:', error);
      throw error;
    }
  }

  async generatePersonalizedQuestions(
    userId: string,
    generateQuestionsDto: GenerateQuestionsDto,
  ): Promise<PersonalizedQuestionDto[]> {
    try {
      return await this.personalizedQuestionService.generatePersonalizedQuestions(
        {
          ...generateQuestionsDto,
          userId,
        },
      );
    } catch (error) {
      this.logger.error('Error generating personalized questions:', error);
      throw error;
    }
  }

  async processQuestionAnswer(
    userId: string,
    date: string,
    answerDto: AnswerQuestionDto,
  ): Promise<void> {
    try {
      // This could be expanded to store individual question answers
      // For now, we'll just log the answer
      this.logger.log(
        `User ${userId} answered question ${answerDto.questionId} on ${date}: ${answerDto.answer}`,
      );

      // You could store this in a separate table for question-answer tracking
      // await this.prisma.questionAnswer.create({
      //   data: {
      //     userId,
      //     questionId: answerDto.questionId,
      //     answer: answerDto.answer,
      //     notes: answerDto.notes,
      //     date: new Date(date),
      //   },
      // });
    } catch (error) {
      this.logger.error('Error processing question answer:', error);
      throw error;
    }
  }

  async getTodaysCheckIn(userId: string): Promise<CheckInResponseDto | null> {
    const today = new Date().toISOString().split('T')[0];
    return this.getCheckInByDate(userId, today);
  }

  async createOrUpdateTodaysCheckIn(
    userId: string,
    updateData: Partial<CreateDailyCheckInDto>,
  ): Promise<CheckInResponseDto> {
    const today = new Date().toISOString().split('T')[0];

    const existingCheckIn = await this.getCheckInByDate(userId, today);

    if (existingCheckIn) {
      return this.updateCheckIn(userId, existingCheckIn.id, updateData);
    } else {
      return this.createCheckIn(userId, {
        date: today,
        ...updateData,
      });
    }
  }

  private formatCheckInResponse(checkIn: any): CheckInResponseDto {
    return {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      id: checkIn.id,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      userId: checkIn.userId,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-call
      date: checkIn.date.toISOString().split('T')[0],
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      moodScore: checkIn.moodScore,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      energyLevel: checkIn.energyLevel,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      sleepQuality: checkIn.sleepQuality,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      painLevel: checkIn.painLevel,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      stressLevel: checkIn.stressLevel,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      symptoms: checkIn.symptoms,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      notes: checkIn.notes,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      aiInsights: checkIn.aiInsights,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      riskScore: checkIn.riskScore,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      completed: checkIn.completed,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-call
      completedAt: checkIn.completedAt?.toISOString(),
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-call
      createdAt: checkIn.createdAt.toISOString(),
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-call
      updatedAt: checkIn.updatedAt.toISOString(),
    };
  }
}
