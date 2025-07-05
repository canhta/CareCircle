import {
  Controller,
  Get,
  Post,
  Put,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { DailyCheckInService } from './daily-check-in.service';
import { InteractiveNotificationService } from '../notification/interactive-notification.service';
import {
  CreateDailyCheckInDto,
  UpdateDailyCheckInDto,
  GenerateQuestionsDto,
  PersonalizedQuestionDto,
  AnswerQuestionDto,
  CheckInResponseDto,
} from './dto/daily-check-in.dto';
import {
  RequestWithUser,
  CheckInResponse,
  CheckInInsight,
  WeeklyInsightsSummary,
  CheckInInsightEntry,
  NotificationResponseData,
} from '../common/interfaces';

@ApiTags('Daily Check-ins')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('daily-check-in')
export class DailyCheckInController {
  constructor(
    private readonly dailyCheckInService: DailyCheckInService,
    private readonly interactiveNotificationService: InteractiveNotificationService,
  ) {}

  @Post()
  @ApiOperation({ summary: 'Create a new daily check-in' })
  @ApiResponse({
    status: 201,
    description: 'Check-in created successfully',
    type: CheckInResponseDto,
  })
  async createCheckIn(
    @Request() req: RequestWithUser,
    @Body() createCheckInDto: CreateDailyCheckInDto,
  ): Promise<CheckInResponseDto> {
    return this.dailyCheckInService.createCheckIn(
      req.user.id,
      createCheckInDto,
    );
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update a daily check-in' })
  @ApiResponse({
    status: 200,
    description: 'Check-in updated successfully',
    type: CheckInResponseDto,
  })
  async updateCheckIn(
    @Request() req: RequestWithUser,
    @Param('id') checkInId: string,
    @Body() updateCheckInDto: UpdateDailyCheckInDto,
  ): Promise<CheckInResponseDto> {
    return this.dailyCheckInService.updateCheckIn(
      req.user.id,
      checkInId,
      updateCheckInDto,
    );
  }

  @Get('today')
  @ApiOperation({ summary: "Get today's check-in" })
  @ApiResponse({
    status: 200,
    description: "Today's check-in retrieved successfully",
    type: CheckInResponseDto,
  })
  async getTodaysCheckIn(
    @Request() req: RequestWithUser,
  ): Promise<CheckInResponseDto | null> {
    return this.dailyCheckInService.getTodaysCheckIn(req.user.id);
  }

  @Post('today')
  @ApiOperation({ summary: "Create or update today's check-in" })
  @ApiResponse({
    status: 200,
    description: "Today's check-in created or updated successfully",
    type: CheckInResponseDto,
  })
  async createOrUpdateTodaysCheckIn(
    @Request() req: RequestWithUser,
    @Body() updateData: Partial<CreateDailyCheckInDto>,
  ): Promise<CheckInResponseDto> {
    return this.dailyCheckInService.createOrUpdateTodaysCheckIn(
      req.user.id,
      updateData,
    );
  }

  @Get('date/:date')
  @ApiOperation({ summary: 'Get check-in by date' })
  @ApiResponse({
    status: 200,
    description: 'Check-in retrieved successfully',
    type: CheckInResponseDto,
  })
  async getCheckInByDate(
    @Request() req: RequestWithUser,
    @Param('date') date: string,
  ): Promise<CheckInResponseDto | null> {
    return this.dailyCheckInService.getCheckInByDate(req.user.id, date);
  }

  @Get('recent')
  @ApiOperation({ summary: 'Get recent check-ins' })
  @ApiResponse({
    status: 200,
    description: 'Recent check-ins retrieved successfully',
    type: [CheckInResponseDto],
  })
  async getRecentCheckIns(
    @Request() req: RequestWithUser,
    @Query('limit') limit?: number,
  ): Promise<CheckInResponseDto[]> {
    return this.dailyCheckInService.getRecentCheckIns(req.user.id, limit);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get check-in by ID' })
  @ApiResponse({
    status: 200,
    description: 'Check-in retrieved successfully',
    type: CheckInResponseDto,
  })
  async getCheckInById(
    @Request() req: RequestWithUser,
    @Param('id') checkInId: string,
  ): Promise<CheckInResponseDto> {
    return this.dailyCheckInService.getCheckInById(req.user.id, checkInId);
  }

  @Post('questions/generate')
  @ApiOperation({ summary: 'Generate personalized daily check-in questions' })
  @ApiResponse({
    status: 200,
    description: 'Personalized questions generated successfully',
    type: [PersonalizedQuestionDto],
  })
  async generatePersonalizedQuestions(
    @Request() req: RequestWithUser,
    @Body() generateQuestionsDto: GenerateQuestionsDto,
  ): Promise<PersonalizedQuestionDto[]> {
    return this.dailyCheckInService.generatePersonalizedQuestions(
      req.user.id,
      generateQuestionsDto,
    );
  }

  @Post('questions/:date/answer')
  @ApiOperation({ summary: 'Submit answer to a personalized question' })
  @ApiResponse({
    status: 200,
    description: 'Answer submitted successfully',
  })
  async answerQuestion(
    @Request() req: RequestWithUser,
    @Param('date') date: string,
    @Body() answerDto: AnswerQuestionDto,
  ): Promise<void> {
    return this.dailyCheckInService.processQuestionAnswer(
      req.user.id,
      date,
      answerDto,
    );
  }

  @Post('insights/:date/generate')
  @ApiOperation({ summary: 'Generate comprehensive insights for a check-in' })
  @ApiResponse({
    status: 200,
    description: 'Insights generated successfully',
  })
  async generateInsights(
    @Request() req: RequestWithUser,
    @Param('date') date: string,
    @Body() responses: CheckInResponse[],
  ): Promise<CheckInInsight[]> {
    return this.dailyCheckInService.generateComprehensiveInsights(
      req.user.id,
      date,
      responses,
    );
  }

  @Get('insights/recent')
  @ApiOperation({ summary: 'Get recent insights' })
  @ApiResponse({
    status: 200,
    description: 'Recent insights retrieved successfully',
  })
  async getRecentInsights(
    @Request() req: RequestWithUser,
    @Query('limit') limit?: number,
  ): Promise<CheckInInsightEntry[]> {
    return this.dailyCheckInService.getRecentInsights(req.user.id, limit);
  }

  @Get('insights/weekly-summary')
  @ApiOperation({ summary: 'Get weekly insights summary' })
  @ApiResponse({
    status: 200,
    description: 'Weekly insights summary retrieved successfully',
  })
  async getWeeklyInsightsSummary(
    @Request() req: RequestWithUser,
  ): Promise<WeeklyInsightsSummary> {
    return this.dailyCheckInService.generateWeeklyInsightsSummary(req.user.id);
  }

  @Get(':checkInId/insights')
  @ApiOperation({ summary: 'Get stored insights for a specific check-in' })
  @ApiResponse({
    status: 200,
    description: 'Stored insights retrieved successfully',
  })
  async getStoredInsights(
    @Request() req: RequestWithUser,
    @Param('checkInId') checkInId: string,
  ): Promise<CheckInInsight[]> {
    return this.dailyCheckInService.getStoredInsights(req.user.id, checkInId);
  }

  @Post('engagement-notifications')
  @ApiOperation({ summary: 'Process engagement notifications for user' })
  @ApiResponse({
    status: 200,
    description: 'Engagement notifications processed successfully',
  })
  async processEngagementNotifications(
    @Request() req: RequestWithUser,
  ): Promise<void> {
    return this.dailyCheckInService.processEngagementNotifications(req.user.id);
  }

  @Post('notification/:notificationId/respond')
  @ApiOperation({ summary: 'Handle response to an interactive notification' })
  @ApiResponse({
    status: 200,
    description: 'Notification response handled successfully',
  })
  async handleNotificationResponse(
    @Request() req: RequestWithUser,
    @Param('notificationId') notificationId: string,
    @Body() responseData: NotificationResponseData,
  ): Promise<void> {
    return this.interactiveNotificationService.handleInteractiveResponse(
      req.user.id,
      notificationId,
      responseData.actionId,
      responseData.data,
    );
  }

  @Get('test-notifications/:userId')
  @ApiOperation({ summary: 'Test notification system' })
  @ApiResponse({
    status: 200,
    description: 'Test notifications sent successfully',
  })
  async testNotifications(@Param('userId') userId: string): Promise<void> {
    const testInsights = [
      {
        id: 'test-1',
        type: 'concern' as const,
        title: 'Declining Mood Pattern',
        description:
          'Your mood scores have been declining over the past few days.',
        severity: 'high' as const,
        confidence: 0.85,
        supportingData: [
          'Average mood: 3.2/10',
          'Trend: declining',
          'Days analyzed: 7',
        ],
        relatedMetrics: ['mood', 'energy'],
        timeframe: '7 days',
      },
    ];

    await this.dailyCheckInService.sendInsightNotifications(
      userId,
      testInsights,
    );
    await this.dailyCheckInService.processEngagementNotifications(userId);

    return;
  }
}
