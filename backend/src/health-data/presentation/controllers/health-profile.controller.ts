import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Request,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { HealthProfileService } from '../../application/services/health-profile.service';
import { AuthenticatedRequest } from '../../../common/types/api.types';

@Controller('health-data/profiles')
export class HealthProfileController {
  constructor(private readonly healthProfileService: HealthProfileService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async createProfile(
    @Body()
    createProfileDto: {
      baselineMetrics?: any;
      healthConditions?: any[];
      allergies?: any[];
      riskFactors?: any[];
    },
    @Request() req: AuthenticatedRequest,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing

    return this.healthProfileService.createProfile({
      userId,
      ...createProfileDto,
    });
  }

  @Get('me')
  async getMyProfile(@Request() req: AuthenticatedRequest) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing
    return this.healthProfileService.getProfileByUserId(userId);
  }

  @Get(':id')
  async getProfile(@Param('id') id: string) {
    return this.healthProfileService.getProfileById(id);
  }

  @Put(':id')
  async updateProfile(
    @Param('id') id: string,
    @Body()
    updateProfileDto: {
      baselineMetrics?: any;
      healthConditions?: any[];
      allergies?: any[];
      riskFactors?: any[];
    },
  ) {
    return this.healthProfileService.updateProfile(id, updateProfileDto);
  }

  @Put('me/baseline')
  async updateMyBaseline(
    @Body() baselineDto: any,
    @Request() req: AuthenticatedRequest,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing
    return this.healthProfileService.updateBaselineMetrics(userId, baselineDto);
  }

  @Post('me/conditions')
  async addHealthCondition(
    @Body() conditionDto: any,
    @Request() req: AuthenticatedRequest,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing
    return this.healthProfileService.addHealthCondition(userId, conditionDto);
  }

  @Post('me/allergies')
  async addAllergy(
    @Body() allergyDto: any,
    @Request() req: AuthenticatedRequest,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing
    return this.healthProfileService.addAllergy(userId, allergyDto);
  }

  @Post('me/risk-factors')
  async addRiskFactor(
    @Body() riskFactorDto: any,
    @Request() req: AuthenticatedRequest,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing
    return this.healthProfileService.addRiskFactor(userId, riskFactorDto);
  }

  @Post('me/goals')
  async addHealthGoal(
    @Body()
    goalDto: {
      metricType: string;
      targetValue: number;
      unit: string;
      startDate: string;
      targetDate: string;
      recurrence: string;
    },
    @Request() req: AuthenticatedRequest,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing

    const goal = {
      ...goalDto,
      startDate: new Date(goalDto.startDate),
      targetDate: new Date(goalDto.targetDate),
      currentValue: 0,
      progress: 0,
      status: 'active' as const,
      recurrence: goalDto.recurrence as 'once' | 'daily' | 'weekly' | 'monthly',
    };

    return this.healthProfileService.addHealthGoal(userId, goal);
  }

  @Put('me/goals/:goalId')
  async updateHealthGoal(
    @Param('goalId') goalId: string,
    @Body() updateDto: any,
    @Request() req: AuthenticatedRequest,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing
    return this.healthProfileService.updateHealthGoal(
      userId,
      goalId,
      updateDto,
    );
  }

  @Delete('me/goals/:goalId')
  async removeHealthGoal(
    @Param('goalId') goalId: string,
    @Request() req: AuthenticatedRequest,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing
    return this.healthProfileService.removeHealthGoal(userId, goalId);
  }

  @Get('me/health-score')
  async getHealthScore(@Request() req: AuthenticatedRequest) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing
    return this.healthProfileService.calculateHealthScore(userId);
  }

  @Delete(':id')
  async deleteProfile(@Param('id') id: string) {
    return this.healthProfileService.deleteProfile(id);
  }
}
