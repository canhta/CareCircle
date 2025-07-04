import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import OpenAI from 'openai';

export interface ResponseAnalysisResult {
  sentimentScore: number; // -1 (very negative) to 1 (very positive)
  sentimentLabel: 'positive' | 'neutral' | 'negative';
  healthConcerns: string[];
  emotionalIndicators: string[];
  riskLevel: 'low' | 'medium' | 'high';
  riskScore: number; // 0-10 scale
  keyInsights: string[];
  recommendedActions: string[];
  anomalies: AnomalyDetection[];
  trends: HealthTrend[];
}

export interface AnomalyDetection {
  type: 'mood' | 'energy' | 'sleep' | 'pain' | 'stress' | 'symptoms';
  description: string;
  severity: 'low' | 'medium' | 'high';
  confidence: number; // 0-1
  suggestedAction: string;
}

export interface HealthTrend {
  metric: string;
  direction: 'improving' | 'declining' | 'stable';
  significance: 'low' | 'medium' | 'high';
  timeframe: string;
  description: string;
}

export interface CheckInResponse {
  questionId: string;
  questionText: string;
  answer: string | number | boolean | string[];
  category: string;
  timestamp: Date;
}

@Injectable()
export class ResponseAnalysisService {
  private readonly logger = new Logger(ResponseAnalysisService.name);
  private readonly openai: OpenAI;

  constructor(
    private readonly prisma: PrismaService,
    private readonly configService: ConfigService,
  ) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('OPENAI_API_KEY'),
    });
  }

  async analyzeResponses(
    userId: string,
    responses: CheckInResponse[],
    date: string,
  ): Promise<ResponseAnalysisResult> {
    try {
      // Get historical context for comparison
      const historicalData = await this.getHistoricalContext(userId, date);

      // Perform AI-powered analysis
      const aiAnalysis = await this.performAIAnalysis(
        responses,
        historicalData,
      );

      // Perform quantitative analysis
      const quantitativeAnalysis = await this.performQuantitativeAnalysis(
        responses,
        historicalData,
      );

      // Combine analyses
      const combinedResult = this.combineAnalyses(
        aiAnalysis,
        quantitativeAnalysis,
      );

      // Store analysis results
      await this.storeAnalysisResults(userId, date, combinedResult);

      return combinedResult;
    } catch (error) {
      this.logger.error('Error analyzing responses:', error);
      throw error;
    }
  }

  private async getHistoricalContext(
    userId: string,
    currentDate: string,
  ): Promise<any> {
    try {
      // Get recent check-ins for trend analysis
      const thirtyDaysAgo = new Date(currentDate);
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

      const recentCheckIns = await this.prisma.dailyCheckIn.findMany({
        where: {
          userId,
          date: {
            gte: thirtyDaysAgo,
            lt: new Date(currentDate),
          },
        },
        orderBy: {
          date: 'desc',
        },
      });

      // Get user profile for context
      const userProfile = await this.prisma.user.findUnique({
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
        },
      });

      // Calculate baseline metrics
      const baseline = this.calculateBaseline(recentCheckIns);

      // Calculate age from dateOfBirth
      const age = userProfile?.dateOfBirth
        ? this.calculateAge(userProfile.dateOfBirth)
        : undefined;

      return {
        recentCheckIns,
        userProfile: userProfile ? { ...userProfile, age } : null,
        baseline,
        historicalAverage: baseline,
      };
    } catch (error) {
      this.logger.error('Error getting historical context:', error);
      return { recentCheckIns: [], userProfile: null, baseline: null };
    }
  }

  private calculateAge(dateOfBirth: Date): number {
    const today = new Date();
    const birthDate = new Date(dateOfBirth);
    let age = today.getFullYear() - birthDate.getFullYear();
    const monthDiff = today.getMonth() - birthDate.getMonth();

    if (
      monthDiff < 0 ||
      (monthDiff === 0 && today.getDate() < birthDate.getDate())
    ) {
      age--;
    }

    return age;
  }

  private calculateBaseline(checkIns: any[]): any {
    if (checkIns.length === 0) return null;

    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
    const totals = checkIns.reduce(
      (acc, checkIn: any) => ({
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        moodScore: acc.moodScore + (checkIn.moodScore || 0),
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        energyLevel: acc.energyLevel + (checkIn.energyLevel || 0),
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        sleepQuality: acc.sleepQuality + (checkIn.sleepQuality || 0),
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        painLevel: acc.painLevel + (checkIn.painLevel || 0),
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        stressLevel: acc.stressLevel + (checkIn.stressLevel || 0),
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
        count: acc.count + 1,
      }),
      {
        moodScore: 0,
        energyLevel: 0,
        sleepQuality: 0,
        painLevel: 0,
        stressLevel: 0,
        count: 0,
      },
    );

    return {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      avgMoodScore: totals.moodScore / totals.count,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      avgEnergyLevel: totals.energyLevel / totals.count,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      avgSleepQuality: totals.sleepQuality / totals.count,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      avgPainLevel: totals.painLevel / totals.count,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      avgStressLevel: totals.stressLevel / totals.count,
    };
  }

  private async performAIAnalysis(
    responses: CheckInResponse[],
    historicalData: any,
  ): Promise<Partial<ResponseAnalysisResult>> {
    try {
      const prompt = this.buildAnalysisPrompt(responses, historicalData);

      const completion = await this.openai.chat.completions.create({
        model: this.configService.get<string>('OPENAI_MODEL') || 'gpt-4',
        messages: [
          {
            role: 'system',
            content: `You are a healthcare AI assistant specializing in daily health check-in analysis. 
                     Analyze user responses to identify sentiment, health concerns, trends, and risk factors. 
                     Provide actionable insights and recommendations.`,
          },
          {
            role: 'user',
            content: prompt,
          },
        ],
        temperature: 0.3,
        max_tokens: 2000,
      });

      const response = completion.choices[0]?.message?.content;
      if (!response) {
        throw new Error('No response from OpenAI');
      }

      return this.parseAIAnalysisResponse(response);
    } catch (error) {
      this.logger.error('Error in AI analysis:', error);
      return this.getFallbackAnalysis(responses);
    }
  }

  private buildAnalysisPrompt(
    responses: CheckInResponse[],
    historicalData: any,
  ): string {
    let prompt = `Analyze the following daily health check-in responses:\n\n`;

    // Add current responses
    prompt += `Today's Responses:\n`;
    responses.forEach((response, index) => {
      prompt += `${index + 1}. ${response.questionText}\n`;
      prompt += `   Answer: ${Array.isArray(response.answer) ? response.answer.join(', ') : String(response.answer)}\n`;
      prompt += `   Category: ${response.category}\n\n`;
    });

    // Add historical context
    if (historicalData.baseline) {
      prompt += `Historical Baseline (last 30 days):\n`;
      prompt += `- Average Mood: ${historicalData.baseline.avgMoodScore?.toFixed(1) || 'N/A'}\n`;
      prompt += `- Average Energy: ${historicalData.baseline.avgEnergyLevel?.toFixed(1) || 'N/A'}\n`;
      prompt += `- Average Sleep Quality: ${historicalData.baseline.avgSleepQuality?.toFixed(1) || 'N/A'}\n`;
      prompt += `- Average Pain Level: ${historicalData.baseline.avgPainLevel?.toFixed(1) || 'N/A'}\n`;
      prompt += `- Average Stress Level: ${historicalData.baseline.avgStressLevel?.toFixed(1) || 'N/A'}\n\n`;
    }

    // Add user context
    if (historicalData.userProfile) {
      prompt += `User Context:\n`;
      if (historicalData.userProfile.age) {
        prompt += `- Age: ${historicalData.userProfile.age}\n`;
      }
      if (historicalData.userProfile.gender) {
        prompt += `- Gender: ${historicalData.userProfile.gender}\n`;
      }
      if (historicalData.userProfile.prescriptions?.length > 0) {
        prompt += `- Current Medications:\n`;
        historicalData.userProfile.prescriptions.forEach((med: any) => {
          prompt += `  * ${med.medicationName} (${med.dosage}, ${med.frequency})\n`;
        });
      }
      prompt += `\n`;
    }

    prompt += `Please provide analysis in the following JSON format:
{
  "sentimentScore": 0.5,
  "sentimentLabel": "positive",
  "healthConcerns": ["concern1", "concern2"],
  "emotionalIndicators": ["indicator1", "indicator2"],
  "riskLevel": "low",
  "riskScore": 3,
  "keyInsights": ["insight1", "insight2"],
  "recommendedActions": ["action1", "action2"],
  "anomalies": [
    {
      "type": "mood",
      "description": "Significant mood decline",
      "severity": "medium",
      "confidence": 0.8,
      "suggestedAction": "Consider follow-up"
    }
  ],
  "trends": [
    {
      "metric": "sleep_quality",
      "direction": "declining",
      "significance": "medium",
      "timeframe": "last 7 days",
      "description": "Sleep quality showing downward trend"
    }
  ]
}

Guidelines:
- sentimentScore: -1 (very negative) to 1 (very positive)
- sentimentLabel: "positive", "neutral", or "negative"
- riskScore: 0-10 scale (0 = no risk, 10 = high risk)
- riskLevel: "low" (0-3), "medium" (4-6), "high" (7-10)
- Focus on actionable insights and recommendations
- Consider medication side effects if applicable
- Compare to historical baseline when available
- Identify any concerning patterns or anomalies`;

    return prompt;
  }

  private parseAIAnalysisResponse(
    response: string,
  ): Partial<ResponseAnalysisResult> {
    try {
      // Extract JSON from response
      const jsonMatch = response.match(/\{[\s\S]*\}/);
      if (!jsonMatch) {
        throw new Error('No JSON found in AI response');
      }

      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
      const parsed: any = JSON.parse(jsonMatch[0]);

      return {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        sentimentScore: parsed.sentimentScore || 0,
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        sentimentLabel: parsed.sentimentLabel || 'neutral',
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        healthConcerns: parsed.healthConcerns || [],
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        emotionalIndicators: parsed.emotionalIndicators || [],
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        riskLevel: parsed.riskLevel || 'low',
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        riskScore: parsed.riskScore || 0,
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        keyInsights: parsed.keyInsights || [],
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        recommendedActions: parsed.recommendedActions || [],
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        anomalies: parsed.anomalies || [],
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        trends: parsed.trends || [],
      };
    } catch (error) {
      this.logger.error('Error parsing AI analysis response:', error);
      return this.getFallbackAnalysis([]);
    }
  }

  private async performQuantitativeAnalysis(
    responses: CheckInResponse[],
    historicalData: any,
  ): Promise<Partial<ResponseAnalysisResult>> {
    try {
      const analysis: Partial<ResponseAnalysisResult> = {
        anomalies: [],
        trends: [],
      };

      // Analyze numeric responses for anomalies
      responses.forEach((response) => {
        if (typeof response.answer === 'number') {
          const anomaly = this.detectNumericAnomaly(
            response,
            historicalData.baseline,
          );
          if (anomaly) {
            analysis.anomalies?.push(anomaly);
          }
        }
      });

      // Calculate overall risk score based on quantitative metrics
      const riskScore = this.calculateRiskScore(responses, historicalData);
      analysis.riskScore = riskScore;
      analysis.riskLevel = this.getRiskLevel(riskScore);

      return analysis;
    } catch (error) {
      this.logger.error('Error in quantitative analysis:', error);
      return { anomalies: [], trends: [] };
    }
  }

  private detectNumericAnomaly(
    response: CheckInResponse,
    baseline: any,
  ): AnomalyDetection | null {
    if (!baseline || typeof response.answer !== 'number') return null;

    const value = response.answer;
    let baselineValue: number;
    let threshold: number;

    // Map response categories to baseline values
    switch (response.category) {
      case 'mood':
        baselineValue = baseline.avgMoodScore;
        threshold = 2; // 2-point difference is significant
        break;
      case 'energy':
        baselineValue = baseline.avgEnergyLevel;
        threshold = 2;
        break;
      case 'sleep':
        baselineValue = baseline.avgSleepQuality;
        threshold = 2;
        break;
      case 'pain':
        baselineValue = baseline.avgPainLevel;
        threshold = 2;
        break;
      case 'stress':
        baselineValue = baseline.avgStressLevel;
        threshold = 2;
        break;
      default:
        return null;
    }

    if (!baselineValue) return null;

    const difference = Math.abs(value - baselineValue);
    if (difference >= threshold) {
      const severity = difference >= threshold * 2 ? 'high' : 'medium';
      const direction = value > baselineValue ? 'increase' : 'decrease';

      return {
        type: response.category as AnomalyDetection['type'],
        description: `Significant ${direction} in ${response.category} (${value} vs baseline ${baselineValue.toFixed(1)})`,
        severity,
        confidence: Math.min(difference / (threshold * 2), 1),
        suggestedAction: this.getSuggestedAction(
          response.category,
          direction,
          severity,
        ),
      };
    }

    return null;
  }

  private getSuggestedAction(
    category: string,
    direction: string,
    severity: string,
  ): string {
    const actions: Record<string, Record<string, string>> = {
      mood: {
        decrease:
          severity === 'high'
            ? 'Consider contacting healthcare provider for mood assessment'
            : 'Monitor mood changes and consider stress management techniques',
        increase: 'Great improvement! Continue current positive habits',
      },
      energy: {
        decrease: 'Review sleep patterns and consider gentle exercise',
        increase: 'Excellent energy levels! Maintain current routine',
      },
      sleep: {
        decrease: 'Evaluate sleep hygiene and consider relaxation techniques',
        increase: 'Good sleep improvement! Continue sleep routine',
      },
      pain: {
        increase:
          severity === 'high'
            ? 'Contact healthcare provider for pain management review'
            : 'Monitor pain levels and consider gentle movement',
        decrease: 'Pain improvement noted! Continue current management',
      },
      stress: {
        increase: 'Consider stress reduction techniques and relaxation methods',
        decrease:
          'Stress levels improving! Continue stress management practices',
      },
    };

    return (
      actions[category]?.[direction] ||
      'Monitor changes and consult healthcare provider if concerned'
    );
  }

  private calculateRiskScore(
    responses: CheckInResponse[],
    historicalData: any,
  ): number {
    let riskScore = 0;
    let factorCount = 0;

    responses.forEach((response) => {
      if (typeof response.answer === 'number') {
        const value = response.answer;

        // Add risk based on concerning values
        switch (response.category) {
          case 'mood':
            if (value <= 3) riskScore += 3;
            else if (value <= 5) riskScore += 1;
            factorCount++;
            break;
          case 'energy':
            if (value <= 3) riskScore += 2;
            else if (value <= 5) riskScore += 1;
            factorCount++;
            break;
          case 'sleep':
            if (value <= 4) riskScore += 2;
            else if (value <= 6) riskScore += 1;
            factorCount++;
            break;
          case 'pain':
            if (value >= 7) riskScore += 3;
            else if (value >= 5) riskScore += 2;
            factorCount++;
            break;
          case 'stress':
            if (value >= 7) riskScore += 2;
            else if (value >= 5) riskScore += 1;
            factorCount++;
            break;
        }
      }
    });

    // Normalize risk score to 0-10 scale
    return factorCount > 0 ? Math.min((riskScore / factorCount) * 2, 10) : 0;
  }

  private getRiskLevel(riskScore: number): 'low' | 'medium' | 'high' {
    if (riskScore <= 3) return 'low';
    if (riskScore <= 6) return 'medium';
    return 'high';
  }

  private combineAnalyses(
    aiAnalysis: Partial<ResponseAnalysisResult>,
    quantitativeAnalysis: Partial<ResponseAnalysisResult>,
  ): ResponseAnalysisResult {
    return {
      sentimentScore: aiAnalysis.sentimentScore || 0,
      sentimentLabel: aiAnalysis.sentimentLabel || 'neutral',
      healthConcerns: aiAnalysis.healthConcerns || [],
      emotionalIndicators: aiAnalysis.emotionalIndicators || [],
      riskLevel:
        quantitativeAnalysis.riskLevel || aiAnalysis.riskLevel || 'low',
      riskScore: quantitativeAnalysis.riskScore || aiAnalysis.riskScore || 0,
      keyInsights: aiAnalysis.keyInsights || [],
      recommendedActions: aiAnalysis.recommendedActions || [],
      anomalies: [
        ...(aiAnalysis.anomalies || []),
        ...(quantitativeAnalysis.anomalies || []),
      ],
      trends: [
        ...(aiAnalysis.trends || []),
        ...(quantitativeAnalysis.trends || []),
      ],
    };
  }

  private getFallbackAnalysis(
    responses: CheckInResponse[],
  ): Partial<ResponseAnalysisResult> {
    // Basic fallback analysis without AI
    const moodResponse = responses.find((r) => r.category === 'mood');
    const energyResponse = responses.find((r) => r.category === 'energy');

    let sentimentScore = 0;
    let sentimentLabel: 'positive' | 'neutral' | 'negative' = 'neutral';

    if (moodResponse && typeof moodResponse.answer === 'number') {
      const moodValue = moodResponse.answer;
      sentimentScore = (moodValue - 5.5) / 4.5; // Convert 1-10 scale to -1 to 1

      if (moodValue >= 7) sentimentLabel = 'positive';
      else if (moodValue <= 4) sentimentLabel = 'negative';
    }

    return {
      sentimentScore,
      sentimentLabel,
      healthConcerns: [],
      emotionalIndicators: [],
      riskLevel: 'low',
      riskScore: 0,
      keyInsights: ['Basic analysis performed - AI analysis unavailable'],
      recommendedActions: ['Continue monitoring daily check-ins'],
      anomalies: [],
      trends: [],
    };
  }

  private async storeAnalysisResults(
    userId: string,
    date: string,
    analysis: ResponseAnalysisResult,
  ): Promise<void> {
    try {
      // Update the daily check-in with AI insights and risk score
      await this.prisma.dailyCheckIn.updateMany({
        where: {
          userId,
          date: new Date(date),
        },
        data: {
          aiInsights: JSON.stringify({
            sentimentScore: analysis.sentimentScore,
            sentimentLabel: analysis.sentimentLabel,
            healthConcerns: analysis.healthConcerns,
            emotionalIndicators: analysis.emotionalIndicators,
            keyInsights: analysis.keyInsights,
            recommendedActions: analysis.recommendedActions,
            anomalies: analysis.anomalies,
            trends: analysis.trends,
          }),
          riskScore: analysis.riskScore,
        },
      });

      this.logger.log(`Analysis results stored for user ${userId} on ${date}`);
    } catch (error) {
      this.logger.error('Error storing analysis results:', error);
    }
  }
}
