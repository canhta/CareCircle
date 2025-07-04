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
  InsightGeneratorService,
  HealthInsight,
  UserHealthContext,
} from '../insights/insight-generator.service';
import { InteractiveNotificationService } from '../notification/interactive-notification.service';
import { NotificationRuleEngine } from '../notification/notification-rule-engine.service';
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
    private readonly insightGeneratorService: InsightGeneratorService,
    private readonly interactiveNotificationService: InteractiveNotificationService,
    private readonly notificationRuleEngine: NotificationRuleEngine,
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

  async generateComprehensiveInsights(
    userId: string,
    date: string,
    responses: CheckInResponse[],
  ): Promise<HealthInsight[]> {
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
        throw new NotFoundException('Check-in not found for the given date');
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

      // Get vector-based insights
      const vectorInsights =
        await this.userInteractionService.getInteractionInsights(
          userId,
          interactionData,
        );

      // Get user health context
      const userHealthContext = await this.getUserHealthContext(userId);

      // Generate comprehensive insights
      const insights = await this.insightGeneratorService.generateKeyInsights(
        userId,
        analysis,
        vectorInsights,
        userHealthContext,
      );

      // Store insights in the database
      await this.storeInsights(userId, checkIn.id, insights);

      // Send notifications for high-priority insights
      await this.sendInsightNotifications(userId, insights);

      return insights;
    } catch (error) {
      this.logger.error(
        `Error generating comprehensive insights for user ${userId} on ${date}:`,
        error,
      );
      throw error;
    }
  }

  async getUserHealthContext(userId: string): Promise<UserHealthContext> {
    try {
      // Get user basic information
      const user = await this.prisma.user.findUnique({
        where: { id: userId },
        include: {
          prescriptions: {
            where: { isActive: true },
            select: {
              id: true,
              medicationName: true,
              dosage: true,
              frequency: true,
              startDate: true,
              endDate: true,
            },
          },
          careGroupMembers: {
            include: {
              careGroup: {
                select: {
                  id: true,
                  name: true,
                  description: true,
                },
              },
            },
          },
        },
      });

      if (!user) {
        throw new NotFoundException('User not found');
      }

      return {
        age: user.dateOfBirth
          ? new Date().getFullYear() - user.dateOfBirth.getFullYear()
          : undefined,
        gender: user.gender || undefined,
        prescriptions: user.prescriptions,
        careGroupContext: user.careGroupMembers.map((membership) => ({
          groupId: membership.careGroup.id,
          groupName: membership.careGroup.name,
          role: membership.role,
        })),
      };
    } catch (error) {
      this.logger.error(
        `Error getting user health context for user ${userId}:`,
        error,
      );
      throw error;
    }
  }

  async storeInsights(
    userId: string,
    checkInId: string,
    insights: HealthInsight[],
  ): Promise<void> {
    try {
      await this.prisma.dailyCheckIn.update({
        where: { id: checkInId },
        data: {
          aiInsights: JSON.stringify(insights),
          updatedAt: new Date(),
        },
      });

      this.logger.log(
        `Successfully stored ${insights.length} insights for user ${userId}`,
      );
    } catch (error) {
      this.logger.error(`Error storing insights for user ${userId}:`, error);
      throw error;
    }
  }

  async getStoredInsights(
    userId: string,
    checkInId: string,
  ): Promise<HealthInsight[]> {
    try {
      const checkIn = await this.prisma.dailyCheckIn.findFirst({
        where: {
          id: checkInId,
          userId,
        },
        select: {
          aiInsights: true,
        },
      });

      if (!checkIn || !checkIn.aiInsights) {
        return [];
      }

      return JSON.parse(checkIn.aiInsights) as HealthInsight[];
    } catch (error) {
      this.logger.error(
        `Error retrieving stored insights for user ${userId}:`,
        error,
      );
      return [];
    }
  }

  async getRecentInsights(
    userId: string,
    limit = 10,
  ): Promise<{ date: string; insights: HealthInsight[] }[]> {
    try {
      const checkIns = await this.prisma.dailyCheckIn.findMany({
        where: {
          userId,
          aiInsights: {
            not: null,
          },
        },
        orderBy: {
          date: 'desc',
        },
        take: limit,
        select: {
          date: true,
          aiInsights: true,
        },
      });

      return checkIns.map((checkIn) => ({
        date: checkIn.date.toISOString().split('T')[0],
        insights: checkIn.aiInsights
          ? (JSON.parse(checkIn.aiInsights) as HealthInsight[])
          : [],
      }));
    } catch (error) {
      this.logger.error(
        `Error retrieving recent insights for user ${userId}:`,
        error,
      );
      return [];
    }
  }

  async generateWeeklyInsightsSummary(userId: string): Promise<{
    summary: string;
    keyInsights: HealthInsight[];
    trends: string[];
    recommendations: string[];
  }> {
    try {
      // Get the last 7 days of insights
      const sevenDaysAgo = new Date();
      sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

      const checkIns = await this.prisma.dailyCheckIn.findMany({
        where: {
          userId,
          date: {
            gte: sevenDaysAgo,
          },
          aiInsights: {
            not: null,
          },
        },
        orderBy: {
          date: 'desc',
        },
        select: {
          date: true,
          aiInsights: true,
          moodScore: true,
          energyLevel: true,
          sleepQuality: true,
          riskScore: true,
        },
      });

      if (checkIns.length === 0) {
        return {
          summary: 'No check-in data available for the past week.',
          keyInsights: [],
          trends: [],
          recommendations: [],
        };
      }

      // Aggregate all insights
      const allInsights: HealthInsight[] = [];
      checkIns.forEach((checkIn) => {
        if (checkIn.aiInsights) {
          const insights = JSON.parse(checkIn.aiInsights) as HealthInsight[];
          allInsights.push(...insights);
        }
      });

      // Calculate basic metrics
      const avgMood = this.calculateAverage(
        checkIns
          .map((c) => c.moodScore)
          .filter((score): score is number => score !== null),
      );
      const avgEnergy = this.calculateAverage(
        checkIns
          .map((c) => c.energyLevel)
          .filter((level): level is number => level !== null),
      );
      const avgSleep = this.calculateAverage(
        checkIns
          .map((c) => c.sleepQuality)
          .filter((quality): quality is number => quality !== null),
      );
      const avgRisk = this.calculateAverage(
        checkIns
          .map((c) => c.riskScore)
          .filter((score): score is number => score !== null),
      );

      // Get unique recommendations
      const uniqueRecommendations = [
        ...new Set(
          allInsights
            .filter((insight) => insight.type === 'lifestyle')
            .map((insight) => insight.description),
        ),
      ];

      // Identify trends
      const trends = this.identifyWeeklyTrends(allInsights);

      // Generate summary
      const summary = this.generateWeeklySummaryText(
        checkIns.length,
        avgMood,
        avgEnergy,
        avgSleep,
        avgRisk,
        trends,
      );

      return {
        summary,
        keyInsights: allInsights.slice(0, 5), // Top 5 insights
        trends,
        recommendations: uniqueRecommendations.slice(0, 3), // Top 3 recommendations
      };
    } catch (error) {
      this.logger.error(
        `Error generating weekly insights summary for user ${userId}:`,
        error,
      );
      throw error;
    }
  }

  private calculateAverage(values: number[]): number {
    if (values.length === 0) return 0;
    return values.reduce((sum, val) => sum + val, 0) / values.length;
  }

  private identifyWeeklyTrends(insights: HealthInsight[]): string[] {
    const trendInsights = insights.filter(
      (insight) => insight.type === 'trend',
    );
    return trendInsights.map((insight) => insight.title);
  }

  private generateWeeklySummaryText(
    checkInCount: number,
    avgMood: number,
    avgEnergy: number,
    avgSleep: number,
    avgRisk: number,
    trends: string[],
  ): string {
    const parts = [`This week you completed ${checkInCount} health check-ins.`];

    if (avgMood > 0) {
      parts.push(`Your average mood score was ${avgMood.toFixed(1)}/10.`);
    }

    if (avgEnergy > 0) {
      parts.push(`Your average energy level was ${avgEnergy.toFixed(1)}/10.`);
    }

    if (avgSleep > 0) {
      parts.push(`Your average sleep quality was ${avgSleep.toFixed(1)}/10.`);
    }

    if (avgRisk > 0) {
      const riskLevel = avgRisk < 3 ? 'low' : avgRisk < 7 ? 'moderate' : 'high';
      parts.push(`Your average risk level was ${riskLevel}.`);
    }

    if (trends.length > 0) {
      parts.push(`Key trends identified: ${trends.join(', ')}.`);
    }

    return parts.join(' ');
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

  async sendInsightNotifications(
    userId: string,
    insights: HealthInsight[],
  ): Promise<void> {
    try {
      // Use the interactive notification service to process insights
      await this.interactiveNotificationService.processInsightNotifications(
        userId,
        insights,
      );

      this.logger.log(
        `Processed ${insights.length} insights for interactive notifications for user ${userId}`,
      );
    } catch (error) {
      this.logger.error(
        `Error sending insight notifications for user ${userId}:`,
        error,
      );
    }
  }

  /**
   * Process engagement notifications for users who haven't checked in recently
   */
  async processEngagementNotifications(userId: string): Promise<void> {
    try {
      // Get recent check-in history directly from Prisma
      const recentCheckIns = await this.prisma.dailyCheckIn.findMany({
        where: {
          userId,
          date: {
            gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), // Last 7 days
          },
        },
        orderBy: { date: 'desc' },
        take: 7,
      });

      // Calculate missed days
      const today = new Date();
      const sevenDaysAgo = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
      const missedDays = this.calculateMissedDays(recentCheckIns, sevenDaysAgo);

      // Use rule engine to evaluate engagement patterns
      const evaluationData =
        this.notificationRuleEngine.createEngagementEvaluationData(
          missedDays,
          recentCheckIns.length,
          recentCheckIns[0]?.date,
        );

      const matchingRules =
        this.notificationRuleEngine.evaluateRules(evaluationData);

      // Send notifications for matching rules
      for (const rule of matchingRules) {
        await this.interactiveNotificationService.sendInteractiveNotification({
          userId,
          triggerType: rule.triggerType,
          triggerData: evaluationData,
          priority: rule.priority,
          actions: [], // Actions would be generated based on rule type
        });
      }

      this.logger.log(`Processed engagement notifications for user ${userId}`);
    } catch (error) {
      this.logger.error(
        `Error processing engagement notifications for user ${userId}:`,
        error,
      );
    }
  }

  private calculateMissedDays(checkIns: any[], startDate: Date): number {
    const checkInDates = new Set(
      checkIns.map((checkIn) =>
        typeof checkIn.date === 'string'
          ? checkIn.date.split('T')[0]
          : checkIn.date.toISOString().split('T')[0],
      ),
    );

    let missedDays = 0;
    const currentDate = new Date(startDate);
    const today = new Date();

    while (currentDate <= today) {
      const dateString = currentDate.toISOString().split('T')[0];
      if (!checkInDates.has(dateString)) {
        missedDays++;
      }
      currentDate.setDate(currentDate.getDate() + 1);
    }

    return missedDays;
  }

  // ...existing code...
}
