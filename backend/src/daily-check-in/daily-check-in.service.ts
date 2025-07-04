import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { PersonalizedQuestionService } from '../ai/personalized-question.service';
import {
  ResponseAnalysisService,
  CheckInResponse,
} from '../analytics/response-analysis.service';
import {
  UserInteractionService,
  UserInteractionData,
} from '../analytics/user-interaction.service';
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
    private readonly responseAnalysisService: ResponseAnalysisService,
    private readonly userInteractionService: UserInteractionService,
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
      // Store the answer and trigger vector analysis
      this.logger.log(
        `User ${userId} answered question ${answerDto.questionId} on ${date}: ${Array.isArray(answerDto.answer) ? answerDto.answer.join(', ') : String(answerDto.answer)}`,
      );

      // Get or create the daily check-in for this date
      let checkIn = await this.getTodaysCheckIn(userId);

      if (!checkIn) {
        // Create a new check-in if none exists
        checkIn = await this.createCheckIn(userId, {
          date: date,
          completed: false,
        });
      }

      // Get the actual DailyCheckIn record for vector storage
      const dailyCheckIn = await this.prisma.dailyCheckIn.findFirst({
        where: {
          userId,
          date: new Date(date),
        },
      });

      if (!dailyCheckIn) {
        throw new Error('Failed to find or create daily check-in');
      }

      // Create interaction data for vector storage
      const interactionData: UserInteractionData = {
        userId,
        checkInId: dailyCheckIn.id,
        checkInData: dailyCheckIn,
        questionResponses: [
          {
            questionId: answerDto.questionId,
            questionText: 'Question response', // We'll need to get this from the question service
            answer: answerDto.answer,
            category: 'general',
          },
        ],
      };

      // Store in vector database for similarity analysis
      await this.userInteractionService.storeUserInteraction(interactionData);

      this.logger.log(`Stored vector interaction for user ${userId}`);
    } catch (error) {
      this.logger.error('Error processing question answer:', error);
      throw error;
    }
  }

  async analyzeCheckInResponses(
    userId: string,
    date: string,
    responses: CheckInResponse[],
  ) {
    try {
      const analysis = await this.responseAnalysisService.analyzeResponses(
        userId,
        responses,
        date,
      );

      this.logger.log(`Analysis completed for user ${userId} on ${date}`);
      return analysis;
    } catch (error) {
      this.logger.error('Error analyzing check-in responses:', error);
      throw error;
    }
  }

  async analyzeCheckInWithVectorInsights(
    userId: string,
    date: string,
    responses: CheckInResponse[],
  ) {
    try {
      // Get standard analysis
      const analysis = await this.responseAnalysisService.analyzeResponses(
        userId,
        responses,
        date,
      );

      // Get the check-in data
      const checkIn = await this.prisma.dailyCheckIn.findFirst({
        where: {
          userId,
          date: new Date(date),
        },
      });

      if (!checkIn) {
        return analysis;
      }

      // Create interaction data for vector analysis
      const interactionData: UserInteractionData = {
        userId,
        checkInId: checkIn.id,
        checkInData: checkIn,
        questionResponses: responses.map((response) => ({
          questionId: response.questionId,
          questionText: response.questionText || 'Daily check-in question',
          answer: Array.isArray(response.answer)
            ? response.answer.join(', ')
            : response.answer,
          category: response.category || 'general',
        })),
        analysisResults: {
          sentiment: analysis.sentimentScore,
          riskScore: analysis.riskScore,
          healthConcerns: analysis.healthConcerns,
          trends: analysis.trends.map((trend) => trend.metric),
        },
      };

      // Store in vector database
      await this.userInteractionService.storeUserInteraction(interactionData);

      // Get vector-based insights
      const vectorInsights =
        await this.userInteractionService.getInteractionInsights(
          userId,
          interactionData,
        );

      return {
        ...analysis,
        vectorInsights: {
          similarPatterns: vectorInsights.similarPatterns,
          behaviorTrends: vectorInsights.behaviorTrends,
          recommendations: vectorInsights.recommendations,
          riskFactors: vectorInsights.riskFactors,
          anomalies: vectorInsights.anomalies,
        },
      };
    } catch (error) {
      this.logger.error(
        'Error analyzing check-in with vector insights:',
        error,
      );
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
