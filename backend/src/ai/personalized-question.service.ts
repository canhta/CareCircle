import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import OpenAI from 'openai';
import {
  PersonalizedQuestionDto,
  GenerateQuestionsDto,
} from '../daily-check-in/dto/daily-check-in.dto';
import {
  AIGeneratedQuestion,
  AIMetricAccumulator,
  CheckInDataWithMetadata,
  HealthMetricsAverages,
  HealthMetricsData,
  ParsedAIResponse,
  UserHealthProfile,
} from '../common/interfaces/ai.interfaces';

@Injectable()
export class PersonalizedQuestionService {
  private readonly logger = new Logger(PersonalizedQuestionService.name);
  private readonly openai: OpenAI;

  constructor(
    private readonly prisma: PrismaService,
    private readonly configService: ConfigService,
  ) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('OPENAI_API_KEY'),
    });
  }

  async generatePersonalizedQuestions(
    params: GenerateQuestionsDto,
  ): Promise<PersonalizedQuestionDto[]> {
    try {
      const { userId, date, questionCount = 5, categories = [] } = params;

      // Get user health profile
      const userProfile = await this.getUserHealthProfile(userId);

      // Generate questions using OpenAI
      const questions = await this.generateQuestionsWithAI(
        userProfile,
        questionCount,
        categories,
        date,
      );

      return questions;
    } catch (error) {
      this.logger.error('Error generating personalized questions:', error);
      // Fall back to default questions if AI fails
      return this.getDefaultQuestions(params.questionCount || 5);
    }
  }

  private async getUserHealthProfile(
    userId: string,
  ): Promise<UserHealthProfile> {
    try {
      // Get user basic info
      const user = await this.prisma.user.findUnique({
        where: { id: userId },
        select: {
          dateOfBirth: true,
          gender: true,
          prescriptions: {
            where: { isActive: true },
            select: {
              medicationName: true,
              dosage: true,
              frequency: true,
            },
          },
          careGroupMembers: {
            select: {
              role: true,
              careGroup: {
                select: {
                  name: true,
                },
              },
            },
          },
        },
      });

      if (!user) {
        throw new Error('User not found');
      }

      // Calculate age if dateOfBirth is available
      const age = user.dateOfBirth
        ? new Date().getFullYear() - new Date(user.dateOfBirth).getFullYear()
        : undefined;

      // Get recent check-ins (last 30 days)
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

      const recentCheckIns = await this.prisma.dailyCheckIn.findMany({
        where: {
          userId,
          date: {
            gte: thirtyDaysAgo,
          },
        },
        orderBy: {
          date: 'desc',
        },
        take: 10,
      });

      // Get recent health metrics (last 30 days)
      const recentHealthMetrics = await this.prisma.healthMetrics.findMany({
        where: {
          userId,
          date: {
            gte: thirtyDaysAgo,
          },
        },
        orderBy: {
          date: 'desc',
        },
        take: 10,
      });

      // Calculate averages and trends
      const recentHealthMetricsData = this.calculateHealthMetricsAverages(
        recentCheckIns,
        recentHealthMetrics,
      );

      return {
        age,
        gender: user.gender || undefined,
        prescriptions: user.prescriptions,
        recentCheckIns: recentCheckIns.map((checkIn) => ({
          date: checkIn.date.toISOString().split('T')[0],
          moodScore: checkIn.moodScore || undefined,
          energyLevel: checkIn.energyLevel || undefined,
          sleepQuality: checkIn.sleepQuality || undefined,
          painLevel: checkIn.painLevel || undefined,
          stressLevel: checkIn.stressLevel || undefined,
          symptoms: checkIn.symptoms || undefined,
          notes: checkIn.notes || undefined,
        })),
        recentHealthMetrics: recentHealthMetricsData,
        careGroupContext: {
          hasCaregivers: user.careGroupMembers.length > 0,
          caregiverConcerns: [],
        },
      };
    } catch (error) {
      this.logger.error('Error fetching user health profile:', error);
      return {};
    }
  }

  private calculateHealthMetricsAverages(
    checkIns: CheckInDataWithMetadata[],
    _healthMetrics: unknown[],
  ): HealthMetricsAverages {
    if (checkIns.length === 0) return {};

    const totals = checkIns.reduce(
      (acc: AIMetricAccumulator, checkIn: CheckInDataWithMetadata) => ({
        moodScore: acc.moodScore + (checkIn.moodScore || 0),
        energyLevel: acc.energyLevel + (checkIn.energyLevel || 0),
        sleepQuality: acc.sleepQuality + (checkIn.sleepQuality || 0),
        painLevel: acc.painLevel + (checkIn.painLevel || 0),
        stressLevel: acc.stressLevel + (checkIn.stressLevel || 0),
        symptomCount: acc.symptomCount + (checkIn.symptoms?.length || 0),
        count: acc.count + 1,
      }),
      {
        moodScore: 0,
        energyLevel: 0,
        sleepQuality: 0,
        painLevel: 0,
        stressLevel: 0,
        symptomCount: 0,
        count: 0,
      },
    );

    const averages = {
      averageMoodScore: totals.moodScore / totals.count,
      averageEnergyLevel: totals.energyLevel / totals.count,
      averageSleepQuality: totals.sleepQuality / totals.count,
      averagePainLevel: totals.painLevel / totals.count,
      averageStressLevel: totals.stressLevel / totals.count,
      commonSymptoms: this.getCommonSymptoms(checkIns),
    };

    return averages;
  }

  private getCommonSymptoms(checkIns: CheckInDataWithMetadata[]): string[] {
    const symptomCounts = new Map<string, number>();

    checkIns.forEach((checkIn: CheckInDataWithMetadata) => {
      if (checkIn.symptoms) {
        checkIn.symptoms.forEach((symptom: string) => {
          symptomCounts.set(symptom, (symptomCounts.get(symptom) || 0) + 1);
        });
      }
    });

    // Return symptoms that appear in at least 20% of check-ins
    const threshold = Math.ceil(checkIns.length * 0.2);
    return Array.from(symptomCounts.entries())
      .filter(([_, count]) => count >= threshold)
      .map(([symptom, _]) => symptom);
  }

  private async generateQuestionsWithAI(
    userProfile: UserHealthProfile,
    questionCount: number,
    categories: string[],
    date?: string,
  ): Promise<PersonalizedQuestionDto[]> {
    const prompt = this.buildPrompt(
      userProfile,
      questionCount,
      categories,
      date,
    );

    try {
      const completion = await this.openai.chat.completions.create({
        model: this.configService.get<string>('OPENAI_MODEL') || 'gpt-4',
        messages: [
          {
            role: 'system',
            content:
              "You are a healthcare assistant specializing in personalized daily health check-ins. Generate thoughtful, relevant questions based on the user's health profile and history.",
          },
          {
            role: 'user',
            content: prompt,
          },
        ],
        temperature: 0.7,
        max_tokens: 1500,
      });

      const response = completion.choices[0]?.message?.content;
      if (!response) {
        throw new Error('No response from OpenAI');
      }

      return this.parseAIResponse(response);
    } catch (error) {
      this.logger.error('Error calling OpenAI API:', error);
      throw error;
    }
  }

  private buildPrompt(
    userProfile: UserHealthProfile,
    questionCount: number,
    categories: string[],
    date?: string,
  ): string {
    const today = date || new Date().toISOString().split('T')[0];
    const dayOfWeek = new Date(today).toLocaleDateString('en-US', {
      weekday: 'long',
    });

    let prompt = `Generate ${questionCount} personalized daily check-in questions for ${dayOfWeek}, ${today}.\n\n`;

    // Add user profile context
    if (userProfile.age) {
      prompt += `User Age: ${userProfile.age}\n`;
    }
    if (userProfile.gender) {
      prompt += `User Gender: ${userProfile.gender}\n`;
    }

    // Add recent health metrics
    if (userProfile.recentHealthMetrics) {
      const metrics = userProfile.recentHealthMetrics;
      prompt += `\nRecent Health Trends (last 30 days):\n`;
      if (metrics.averageMoodScore) {
        prompt += `- Average Mood Score: ${metrics.averageMoodScore.toFixed(1)}/10\n`;
      }
      if (metrics.averageEnergyLevel) {
        prompt += `- Average Energy Level: ${metrics.averageEnergyLevel.toFixed(1)}/10\n`;
      }
      if (metrics.averageSleepQuality) {
        prompt += `- Average Sleep Quality: ${metrics.averageSleepQuality.toFixed(1)}/10\n`;
      }
      if (metrics.averagePainLevel) {
        prompt += `- Average Pain Level: ${metrics.averagePainLevel.toFixed(1)}/10\n`;
      }
      if (metrics.averageStressLevel) {
        prompt += `- Average Stress Level: ${metrics.averageStressLevel.toFixed(1)}/10\n`;
      }
      if (metrics.commonSymptoms && metrics.commonSymptoms.length > 0) {
        prompt += `- Common Symptoms: ${metrics.commonSymptoms.join(', ')}\n`;
      }
    }

    // Add prescription context
    if (userProfile.prescriptions && userProfile.prescriptions.length > 0) {
      prompt += `\nCurrent Medications:\n`;
      userProfile.prescriptions.forEach((prescription) => {
        prompt += `- ${prescription.medicationName} (${prescription.dosage}, ${prescription.frequency})\n`;
      });
    }

    // Add recent check-in context
    if (userProfile.recentCheckIns && userProfile.recentCheckIns.length > 0) {
      prompt += `\nRecent Check-in Notes:\n`;
      userProfile.recentCheckIns.slice(0, 3).forEach((checkIn) => {
        if (checkIn.notes) {
          prompt += `- ${checkIn.date}: ${checkIn.notes}\n`;
        }
      });
    }

    // Add categories if specified
    if (categories.length > 0) {
      prompt += `\nFocus on these categories: ${categories.join(', ')}\n`;
    }

    // Add care group context
    if (userProfile.careGroupContext?.hasCaregivers) {
      prompt += `\nNote: User has caregivers who may be monitoring their health.\n`;
    }

    prompt += `\nPlease return the questions in this exact JSON format:
{
  "questions": [
    {
      "id": "unique_question_id",
      "question": "Question text",
      "type": "scale|multiple_choice|text|boolean",
      "options": ["option1", "option2"] // only for multiple_choice
      "minValue": 1, // only for scale
      "maxValue": 10, // only for scale
      "category": "mood|energy|sleep|pain|stress|symptoms|general",
      "priority": 1-5 // 1 = highest priority
    }
  ]
}

Guidelines:
- Make questions conversational and empathetic
- Consider the user's health trends and patterns
- Include follow-up potential for concerning responses
- Balance different health aspects (mood, physical, symptoms)
- Adapt language to be age-appropriate
- Consider medication-related questions if relevant
- Make questions actionable and specific to today`;

    return prompt;
  }

  private parseAIResponse(response: string): PersonalizedQuestionDto[] {
    try {
      // Clean up the response to extract JSON
      const jsonMatch = response.match(/\{[\s\S]*\}/);
      if (!jsonMatch) {
        throw new Error('No JSON found in response');
      }

      const parsed = JSON.parse(jsonMatch[0]) as ParsedAIResponse;

      if (!parsed.questions || !Array.isArray(parsed.questions)) {
        throw new Error('Invalid response format');
      }

      return parsed.questions.map((q: AIGeneratedQuestion) => ({
        id: q.id || `question_${Date.now()}_${Math.random()}`,
        question: q.question,
        type: q.type || 'text',
        options: q.options,
        minValue: q.minValue,
        maxValue: q.maxValue,
        category: q.category || 'general',
        priority: q.priority || 3,
        followUpQuestions: q.followUpQuestions || [],
      }));
    } catch (error) {
      this.logger.error('Error parsing AI response:', error);
      throw error;
    }
  }

  private getDefaultQuestions(count: number): PersonalizedQuestionDto[] {
    const defaultQuestions = [
      {
        id: 'mood_today',
        question: 'How would you rate your mood today?',
        type: 'scale' as const,
        minValue: 1,
        maxValue: 10,
        category: 'mood',
        priority: 1,
      },
      {
        id: 'energy_level',
        question: 'How is your energy level today?',
        type: 'scale' as const,
        minValue: 1,
        maxValue: 10,
        category: 'energy',
        priority: 2,
      },
      {
        id: 'sleep_quality',
        question: 'How well did you sleep last night?',
        type: 'scale' as const,
        minValue: 1,
        maxValue: 10,
        category: 'sleep',
        priority: 2,
      },
      {
        id: 'pain_level',
        question: 'Are you experiencing any pain today?',
        type: 'scale' as const,
        minValue: 0,
        maxValue: 10,
        category: 'pain',
        priority: 3,
      },
      {
        id: 'stress_level',
        question: 'How stressed do you feel today?',
        type: 'scale' as const,
        minValue: 1,
        maxValue: 10,
        category: 'stress',
        priority: 3,
      },
      {
        id: 'symptoms',
        question: 'Are you experiencing any symptoms today?',
        type: 'text' as const,
        category: 'symptoms',
        priority: 4,
      },
      {
        id: 'medication_taken',
        question: 'Have you taken all your medications today?',
        type: 'boolean' as const,
        category: 'medication',
        priority: 2,
      },
      {
        id: 'general_wellbeing',
        question: 'How would you describe your overall wellbeing today?',
        type: 'multiple_choice' as const,
        options: ['Excellent', 'Good', 'Fair', 'Poor'],
        category: 'general',
        priority: 3,
      },
    ];

    return defaultQuestions.slice(0, count);
  }
}
