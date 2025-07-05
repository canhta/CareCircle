import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import OpenAI from 'openai';
import {
  ResponseAnalysisResult,
  AnomalyDetection,
  HealthTrend,
  CheckInResponse,
  HistoricalContext,
  BaselineMetrics,
  MetricAccumulator,
} from '../common/interfaces/analytics.interfaces';

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
  ): Promise<HistoricalContext> {
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
      return {
        recentCheckIns: [],
        userProfile: null,
        baseline: null,
      };
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

  private calculateBaseline(
    checkIns: Array<{ [key: string]: unknown }>,
  ): BaselineMetrics | null {
    if (checkIns.length === 0) return null;

    const totals = checkIns.reduce(
      (acc: MetricAccumulator, checkIn) => ({
        moodScore: acc.moodScore + ((checkIn.moodScore as number) || 0),
        energyLevel: acc.energyLevel + ((checkIn.energyLevel as number) || 0),
        sleepQuality:
          acc.sleepQuality + ((checkIn.sleepQuality as number) || 0),
        painLevel: acc.painLevel + ((checkIn.painLevel as number) || 0),
        stressLevel: acc.stressLevel + ((checkIn.stressLevel as number) || 0),
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
      avgMoodScore: totals.moodScore / totals.count,
      avgEnergyLevel: totals.energyLevel / totals.count,
      avgSleepQuality: totals.sleepQuality / totals.count,
      avgPainLevel: totals.painLevel / totals.count,
      avgStressLevel: totals.stressLevel / totals.count,
    };
  }

  private async performAIAnalysis(
    responses: CheckInResponse[],
    historicalData: HistoricalContext,
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
    historicalData: HistoricalContext,
  ): string {
    let prompt = `Please analyze the following daily health check-in responses:\n\n`;

    // Add response data
    responses.forEach((response) => {
      prompt += `Question: ${response.questionText}\n`;
      prompt += `Answer: ${
        Array.isArray(response.answer)
          ? response.answer.join(', ')
          : response.answer
      }\n`;
      prompt += `Category: ${response.category}\n\n`;
    });

    // Add historical context if available
    if (historicalData.baseline) {
      prompt += `Historical context:\n`;
      prompt += `Average mood score: ${historicalData.baseline.avgMoodScore.toFixed(
        2,
      )}\n`;
      prompt += `Average energy level: ${historicalData.baseline.avgEnergyLevel.toFixed(
        2,
      )}\n`;
      prompt += `Average sleep quality: ${historicalData.baseline.avgSleepQuality.toFixed(
        2,
      )}\n`;
      prompt += `Average pain level: ${historicalData.baseline.avgPainLevel.toFixed(
        2,
      )}\n`;
      prompt += `Average stress level: ${historicalData.baseline.avgStressLevel.toFixed(
        2,
      )}\n\n`;
    }

    // Add user profile context if available
    if (historicalData.userProfile) {
      prompt += `User profile:\n`;
      if (historicalData.userProfile.age) {
        prompt += `Age: ${historicalData.userProfile.age}\n`;
      }
      if (historicalData.userProfile.gender) {
        prompt += `Gender: ${historicalData.userProfile.gender}\n`;
      }
      if (
        historicalData.userProfile.prescriptions &&
        historicalData.userProfile.prescriptions.length > 0
      ) {
        prompt += `Current medications: ${historicalData.userProfile.prescriptions
          .map((p) => `${p.medicationName} ${p.dosage} ${p.frequency}`)
          .join(', ')}\n`;
      }
      prompt += `\n`;
    }

    prompt += `Based on the above information, please provide an analysis in the following format:
    1. Sentiment Score (-1 to 1, where -1 is very negative and 1 is very positive)
    2. Sentiment Label (positive, neutral, or negative)
    3. Health Concerns (list)
    4. Emotional Indicators (list)
    5. Risk Level (low, medium, or high)
    6. Risk Score (0-10)
    7. Key Insights (list)
    8. Recommended Actions (list)
    9. Anomalies (list with type, description, severity, and suggested action)
    10. Trends (list with metric, direction, significance, and description)
    
    Please format your response as JSON.`;

    return prompt;
  }

  private parseAIAnalysisResponse(
    response: string,
  ): Partial<ResponseAnalysisResult> {
    try {
      // Try to extract JSON object from the response
      const jsonMatch = response.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        const jsonStr = jsonMatch[0];
        return JSON.parse(jsonStr) as Partial<ResponseAnalysisResult>;
      }

      // If no valid JSON found, parse the text manually
      return this.parseTextResponse(response);
    } catch (error) {
      this.logger.error('Error parsing AI analysis response:', error);
      return {
        sentimentScore: 0,
        sentimentLabel: 'neutral',
        healthConcerns: [],
        emotionalIndicators: [],
        riskLevel: 'low',
        riskScore: 0,
        keyInsights: ['Analysis unavailable'],
        recommendedActions: ['Check back later'],
        anomalies: [],
        trends: [],
      };
    }
  }

  private parseTextResponse(text: string): Partial<ResponseAnalysisResult> {
    const result: Partial<ResponseAnalysisResult> = {
      healthConcerns: [],
      emotionalIndicators: [],
      keyInsights: [],
      recommendedActions: [],
      anomalies: [],
      trends: [],
    };

    const lines = text.split('\n');
    for (const line of lines) {
      if (line.includes('Sentiment Score:')) {
        result.sentimentScore = parseFloat(line.split(':')[1].trim());
      } else if (line.includes('Sentiment Label:')) {
        const label = line.split(':')[1].trim().toLowerCase();
        if (
          label === 'positive' ||
          label === 'neutral' ||
          label === 'negative'
        ) {
          result.sentimentLabel = label;
        }
      } else if (line.includes('Risk Level:')) {
        const level = line.split(':')[1].trim().toLowerCase();
        if (level === 'low' || level === 'medium' || level === 'high') {
          result.riskLevel = level;
        }
      } else if (line.includes('Risk Score:')) {
        result.riskScore = parseFloat(line.split(':')[1].trim());
      }
      // Additional parsing for lists could be implemented here
    }

    return result;
  }

  private async performQuantitativeAnalysis(
    responses: CheckInResponse[],
    historicalData: HistoricalContext,
  ): Promise<Partial<ResponseAnalysisResult>> {
    try {
      const result: Partial<ResponseAnalysisResult> = {
        anomalies: [],
        trends: [],
      };

      // Process numeric responses and look for anomalies
      for (const response of responses) {
        if (
          typeof response.answer === 'number' &&
          historicalData.baseline &&
          ['mood', 'energy', 'sleep', 'pain', 'stress'].includes(
            response.category,
          )
        ) {
          const anomaly = this.detectNumericAnomaly(
            response,
            historicalData.baseline,
          );
          if (anomaly) {
            result.anomalies?.push(anomaly);
          }
        }
      }

      // Calculate risk score
      result.riskScore = this.calculateRiskScore(responses, historicalData);
      result.riskLevel = this.getRiskLevel(result.riskScore);

      return result;
    } catch (error) {
      this.logger.error('Error in quantitative analysis:', error);
      return {};
    }
  }

  private detectNumericAnomaly(
    response: CheckInResponse,
    baseline: BaselineMetrics,
  ): AnomalyDetection | null {
    if (typeof response.answer !== 'number') return null;

    let baselineValue = 0;
    let thresholdPercent = 0.25; // Default threshold 25%
    const thresholdAbsolute = 2; // Default absolute threshold
    let isAnomaly = false;
    let direction = '';

    // Get appropriate baseline value
    switch (response.category) {
      case 'mood':
        baselineValue = baseline.avgMoodScore;
        break;
      case 'energy':
        baselineValue = baseline.avgEnergyLevel;
        break;
      case 'sleep':
        baselineValue = baseline.avgSleepQuality;
        break;
      case 'pain':
        baselineValue = baseline.avgPainLevel;
        thresholdPercent = 0.3; // Higher threshold for pain
        break;
      case 'stress':
        baselineValue = baseline.avgStressLevel;
        thresholdPercent = 0.3; // Higher threshold for stress
        break;
      default:
        return null;
    }

    // Calculate difference and check if it's an anomaly
    const diff = response.answer - baselineValue;
    const percentDiff = Math.abs(diff) / (baselineValue || 1);

    // Determine if this is an anomaly
    if (
      Math.abs(diff) >= thresholdAbsolute &&
      percentDiff >= thresholdPercent
    ) {
      isAnomaly = true;
      direction = diff > 0 ? 'higher' : 'lower';
    }

    if (!isAnomaly) return null;

    // For metrics where higher is better (mood, energy, sleep)
    const isBetterWhenHigher = ['mood', 'energy', 'sleep'].includes(
      response.category,
    );
    // For metrics where lower is better (pain, stress)
    const isBetterWhenLower = ['pain', 'stress'].includes(response.category);

    // Determine severity based on direction and metric type
    let severity: 'low' | 'medium' | 'high' = 'low';
    if ((isBetterWhenHigher && diff < 0) || (isBetterWhenLower && diff > 0)) {
      // Worse than baseline
      if (percentDiff > 0.5) severity = 'high';
      else if (percentDiff > 0.3) severity = 'medium';
    } else {
      // Better than baseline
      severity = 'low'; // Good anomalies are low severity
    }

    // Create the anomaly description
    const description = `${response.category.charAt(0).toUpperCase() + response.category.slice(1)} is ${Math.abs(
      diff,
    ).toFixed(
      1,
    )} points ${direction} than usual (${percentDiff.toFixed(2) * 100}% change)`;

    return {
      type: response.category as
        | 'mood'
        | 'energy'
        | 'sleep'
        | 'pain'
        | 'stress'
        | 'symptoms',
      description,
      severity,
      confidence: Math.min(0.5 + percentDiff, 0.95),
      suggestedAction: this.getSuggestedAction(
        response.category,
        direction,
        severity,
      ),
    };
  }

  private getSuggestedAction(
    category: string,
    direction: string,
    severity: string,
  ): string {
    // Template suggestions based on category, direction, and severity
    const suggestions = {
      mood: {
        lower: {
          low: 'Monitor mood over the next few days',
          medium:
            'Consider stress reduction techniques or activities that boost mood',
          high: 'Consider consulting a healthcare provider about mood changes',
        },
        higher: {
          low: 'Great job! Keep up the positive activities',
          medium: 'Continue with current positive lifestyle habits',
          high: 'Share what helped improve your mood with your care circle',
        },
      },
      energy: {
        lower: {
          low: 'Ensure adequate rest and hydration',
          medium: 'Review sleep habits and consider stress reduction',
          high: 'Consult healthcare provider about persistent fatigue',
        },
        higher: {
          low: 'Continue current activity levels',
          medium: 'Keep up with your healthy energy-supporting habits',
          high: 'Share your energy-boosting techniques with your care circle',
        },
      },
      sleep: {
        lower: {
          low: 'Monitor sleep over the next few nights',
          medium: 'Review sleep hygiene practices',
          high: 'Consider consulting a healthcare provider about sleep issues',
        },
        higher: {
          low: 'Continue current sleep routine',
          medium: 'Maintain consistent sleep schedule',
          high: 'Share successful sleep habits with your care circle',
        },
      },
      pain: {
        lower: {
          low: 'Continue pain management techniques',
          medium: 'Keep track of what may be helping reduce pain',
          high: 'Share pain reduction strategies with healthcare provider',
        },
        higher: {
          low: 'Monitor pain levels over the next few days',
          medium: 'Consider rest and appropriate pain management',
          high: 'Consult healthcare provider about increased pain',
        },
      },
      stress: {
        lower: {
          low: 'Continue stress management techniques',
          medium: 'Keep up with relaxation practices',
          high: 'Share stress reduction strategies with your care circle',
        },
        higher: {
          low: 'Practice brief relaxation techniques',
          medium: 'Increase stress management activities',
          high: 'Consider discussing stress levels with healthcare provider',
        },
      },
      symptoms: {
        lower: {
          low: 'Continue monitoring symptoms',
          medium: 'Note what may be helping reduce symptoms',
          high: 'Discuss symptom improvement with healthcare provider',
        },
        higher: {
          low: 'Keep tracking these symptoms over the next few days',
          medium: 'Consider rest and symptom management techniques',
          high: 'Consult healthcare provider about increased symptoms',
        },
      },
    };

    // Get the appropriate suggestion or provide a default
    try {
      return suggestions[category][direction][severity];
    } catch (error) {
      return 'Monitor and consult healthcare provider if needed';
    }
  }

  private calculateRiskScore(
    responses: CheckInResponse[],
    historicalData: HistoricalContext,
  ): number {
    let riskScore = 0;
    const baseRisk = 3; // Starting risk score

    // Get relevant responses
    const moodResponse = responses.find((r) => r.category === 'mood');
    const painResponse = responses.find((r) => r.category === 'pain');
    const stressResponse = responses.find((r) => r.category === 'stress');
    const sleepResponse = responses.find((r) => r.category === 'sleep');
    const symptomsResponses = responses.filter(
      (r) => r.category === 'symptoms',
    );

    // Add risk based on mood (1-10 scale, lower is worse)
    if (moodResponse && typeof moodResponse.answer === 'number') {
      if (moodResponse.answer <= 3) riskScore += 2;
      else if (moodResponse.answer <= 5) riskScore += 1;
    }

    // Add risk based on pain (1-10 scale, higher is worse)
    if (painResponse && typeof painResponse.answer === 'number') {
      if (painResponse.answer >= 7) riskScore += 2;
      else if (painResponse.answer >= 5) riskScore += 1;
    }

    // Add risk based on stress (1-10 scale, higher is worse)
    if (stressResponse && typeof stressResponse.answer === 'number') {
      if (stressResponse.answer >= 8) riskScore += 2;
      else if (stressResponse.answer >= 6) riskScore += 1;
    }

    // Add risk based on sleep (1-10 scale, lower is worse)
    if (sleepResponse && typeof sleepResponse.answer === 'number') {
      if (sleepResponse.answer <= 3) riskScore += 1.5;
      else if (sleepResponse.answer <= 5) riskScore += 0.75;
    }

    // Add risk based on reported symptoms
    if (symptomsResponses.length > 0) {
      const symptomCount = symptomsResponses.length;
      if (symptomCount >= 3) riskScore += 2;
      else if (symptomCount > 0) riskScore += symptomCount * 0.5;
    }

    // Check for anomalies against historical data
    if (historicalData.baseline) {
      let significantChanges = 0;

      // Check mood change
      if (
        moodResponse &&
        typeof moodResponse.answer === 'number' &&
        Math.abs(moodResponse.answer - historicalData.baseline.avgMoodScore) >=
          3
      ) {
        significantChanges++;
      }

      // Check pain change
      if (
        painResponse &&
        typeof painResponse.answer === 'number' &&
        Math.abs(painResponse.answer - historicalData.baseline.avgPainLevel) >=
          3
      ) {
        significantChanges++;
      }

      // Add risk based on number of significant changes
      riskScore += significantChanges * 0.75;
    }

    // Ensure score is between 0-10
    return Math.min(10, Math.max(0, baseRisk + riskScore));
  }

  private getRiskLevel(riskScore: number): 'low' | 'medium' | 'high' {
    if (riskScore >= 6.5) return 'high';
    if (riskScore >= 4) return 'medium';
    return 'low';
  }

  private combineAnalyses(
    aiAnalysis: Partial<ResponseAnalysisResult>,
    quantitativeAnalysis: Partial<ResponseAnalysisResult>,
  ): ResponseAnalysisResult {
    // Start with AI analysis values or defaults
    const result: ResponseAnalysisResult = {
      sentimentScore: aiAnalysis.sentimentScore ?? 0,
      sentimentLabel: aiAnalysis.sentimentLabel ?? 'neutral',
      healthConcerns: aiAnalysis.healthConcerns ?? [],
      emotionalIndicators: aiAnalysis.emotionalIndicators ?? [],
      riskLevel: aiAnalysis.riskLevel ?? 'low',
      riskScore: aiAnalysis.riskScore ?? 0,
      keyInsights: aiAnalysis.keyInsights ?? [],
      recommendedActions: aiAnalysis.recommendedActions ?? [],
      anomalies: aiAnalysis.anomalies ?? [],
      trends: aiAnalysis.trends ?? [],
    };

    // Prefer quantitative analysis for some fields
    if (quantitativeAnalysis.riskScore !== undefined) {
      result.riskScore = quantitativeAnalysis.riskScore;
    }

    if (quantitativeAnalysis.riskLevel) {
      result.riskLevel = quantitativeAnalysis.riskLevel;
    }

    // Merge anomalies from both analyses, removing duplicates
    if (
      quantitativeAnalysis.anomalies &&
      quantitativeAnalysis.anomalies.length > 0
    ) {
      result.anomalies = [
        ...result.anomalies,
        ...quantitativeAnalysis.anomalies.filter(
          (qa) => !result.anomalies.some((a) => a.type === qa.type),
        ),
      ];
    }

    // Merge trends from both analyses
    if (quantitativeAnalysis.trends && quantitativeAnalysis.trends.length > 0) {
      result.trends = [...result.trends, ...quantitativeAnalysis.trends];
    }

    return result;
  }

  private getFallbackAnalysis(
    responses: CheckInResponse[],
  ): Partial<ResponseAnalysisResult> {
    const moodResponse = responses.find((r) => r.category === 'mood');
    const stressResponse = responses.find((r) => r.category === 'stress');

    let sentimentScore = 0;
    let sentimentLabel: 'positive' | 'neutral' | 'negative' = 'neutral';
    let riskLevel: 'low' | 'medium' | 'high' = 'low';
    let riskScore = 3; // Default risk score

    // Basic sentiment from mood response
    if (moodResponse && typeof moodResponse.answer === 'number') {
      sentimentScore = (moodResponse.answer - 5.5) / 5.5; // Convert 1-10 to -1 to 1
      if (moodResponse.answer >= 7) sentimentLabel = 'positive';
      else if (moodResponse.answer <= 4) sentimentLabel = 'negative';

      // Adjust risk based on mood
      if (moodResponse.answer <= 3) riskScore += 2;
    }

    // Adjust risk based on stress
    if (stressResponse && typeof stressResponse.answer === 'number') {
      if (stressResponse.answer >= 7) {
        riskScore += 2;
      }
    }

    // Set risk level
    if (riskScore >= 6) riskLevel = 'high';
    else if (riskScore >= 4) riskLevel = 'medium';

    return {
      sentimentScore,
      sentimentLabel,
      healthConcerns: [],
      emotionalIndicators: [],
      riskLevel,
      riskScore,
      keyInsights: ['Limited analysis available'],
      recommendedActions: ['Continue monitoring your health'],
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
      // Store results in the database
      await this.prisma.checkInAnalysis.create({
        data: {
          userId,
          date: new Date(date),
          sentimentScore: analysis.sentimentScore,
          sentimentLabel: analysis.sentimentLabel,
          healthConcerns: analysis.healthConcerns,
          emotionalIndicators: analysis.emotionalIndicators,
          riskLevel: analysis.riskLevel,
          riskScore: analysis.riskScore,
          keyInsights: analysis.keyInsights,
          recommendedActions: analysis.recommendedActions,
          anomalies: analysis.anomalies as unknown as object[],
          trends: analysis.trends as unknown as object[],
        },
      });
    } catch (error) {
      this.logger.error('Error storing analysis results:', error);
      // Don't throw, just log - this shouldn't fail the overall analysis
    }
  }
}
