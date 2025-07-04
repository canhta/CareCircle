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
import {
  CreateDailyCheckInDto,
  UpdateDailyCheckInDto,
  GenerateQuestionsDto,
  PersonalizedQuestionDto,
  AnswerQuestionDto,
  CheckInResponseDto,
} from './dto/daily-check-in.dto';

@ApiTags('Daily Check-ins')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('daily-check-in')
export class DailyCheckInController {
  constructor(private readonly dailyCheckInService: DailyCheckInService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new daily check-in' })
  @ApiResponse({
    status: 201,
    description: 'Check-in created successfully',
    type: CheckInResponseDto,
  })
  async createCheckIn(
    @Request() req: any,
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
    @Request() req: any,
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
    @Request() req: any,
  ): Promise<CheckInResponseDto | null> {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
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
    @Request() req: any,
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
    @Request() req: any,
    @Param('date') date: string,
  ): Promise<CheckInResponseDto | null> {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
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
    @Request() req: any,
    @Query('limit') limit?: number,
  ): Promise<CheckInResponseDto[]> {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
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
    @Request() req: any,
    @Param('id') checkInId: string,
  ): Promise<CheckInResponseDto> {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
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
    @Request() req: any,
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
    @Request() req: any,
    @Param('date') date: string,
    @Body() answerDto: AnswerQuestionDto,
  ): Promise<void> {
    return this.dailyCheckInService.processQuestionAnswer(
      req.user.id,
      date,
      answerDto,
    );
  }
}
