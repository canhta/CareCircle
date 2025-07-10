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
import {
  AuthenticatedRequest,
  CreateHealthProfileDto,
  UpdateHealthProfileDto,
  BaselineMetricsDto,
  HealthConditionDto,
  AllergyDto,
  RiskFactorDto,
  HealthGoalDto,
  UpdateHealthGoalDto,
} from '../../../common/types';

@Controller('health-data/profiles')
export class HealthProfileController {
  constructor(private readonly healthProfileService: HealthProfileService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async createProfile(
    @Body() createProfileDto: CreateHealthProfileDto,
    @Request() req: AuthenticatedRequest,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing

    // Convert DTO to domain entity format
    const profileData = {
      userId,
      baselineMetrics: createProfileDto.baselineMetrics,
      healthConditions: createProfileDto.healthConditions?.map((condition) => ({
        ...condition,
        diagnosisDate: condition.diagnosisDate
          ? new Date(condition.diagnosisDate)
          : undefined,
      })),
      allergies: createProfileDto.allergies,
      riskFactors: createProfileDto.riskFactors,
    };

    return this.healthProfileService.createProfile(profileData);
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
    @Body() updateProfileDto: UpdateHealthProfileDto,
  ) {
    // Convert DTO to domain entity format
    const updateData = {
      baselineMetrics: updateProfileDto.baselineMetrics,
      healthConditions: updateProfileDto.healthConditions?.map((condition) => ({
        ...condition,
        diagnosisDate: condition.diagnosisDate
          ? new Date(condition.diagnosisDate)
          : undefined,
      })),
      allergies: updateProfileDto.allergies,
      riskFactors: updateProfileDto.riskFactors,
    };

    return this.healthProfileService.updateProfile(id, updateData);
  }

  @Put('me/baseline')
  async updateMyBaseline(
    @Body() baselineDto: Partial<BaselineMetricsDto>,
    @Request() req: AuthenticatedRequest,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing
    return this.healthProfileService.updateBaselineMetrics(userId, baselineDto);
  }

  @Post('me/conditions')
  async addHealthCondition(
    @Body() conditionDto: HealthConditionDto,
    @Request() req: AuthenticatedRequest,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing

    // Convert DTO to domain entity format
    const condition = {
      ...conditionDto,
      diagnosisDate: conditionDto.diagnosisDate
        ? new Date(conditionDto.diagnosisDate)
        : undefined,
    };

    return this.healthProfileService.addHealthCondition(userId, condition);
  }

  @Post('me/allergies')
  async addAllergy(
    @Body() allergyDto: AllergyDto,
    @Request() req: AuthenticatedRequest,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing
    return this.healthProfileService.addAllergy(userId, allergyDto);
  }

  @Post('me/risk-factors')
  async addRiskFactor(
    @Body() riskFactorDto: RiskFactorDto,
    @Request() req: AuthenticatedRequest,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing
    return this.healthProfileService.addRiskFactor(userId, riskFactorDto);
  }

  @Post('me/goals')
  async addHealthGoal(
    @Body() goalDto: HealthGoalDto,
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
      recurrence: goalDto.recurrence,
    };

    return this.healthProfileService.addHealthGoal(userId, goal);
  }

  @Put('me/goals/:goalId')
  async updateHealthGoal(
    @Param('goalId') goalId: string,
    @Body() updateDto: UpdateHealthGoalDto,
    @Request() req: AuthenticatedRequest,
  ) {
    const userId = req.user?.id || 'test-user-id'; // Temporary for testing

    // Convert DTO to domain entity format
    const goalUpdates = {
      ...updateDto,
      targetDate: updateDto.targetDate
        ? new Date(updateDto.targetDate)
        : undefined,
    };

    return this.healthProfileService.updateHealthGoal(
      userId,
      goalId,
      goalUpdates,
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
