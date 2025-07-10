import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
  HttpStatus,
  HttpException,
} from '@nestjs/common';
import {
  FirebaseAuthGuard,
  FirebaseUserPayload,
} from '../../../identity-access/presentation/guards/firebase-auth.guard';
import { MedicationScheduleService } from '../../application/services/medication-schedule.service';
import {
  CreateScheduleDto,
  UpdateScheduleDto,
  ScheduleQueryDto,
  AddReminderTimeDto,
} from '../dto/medication-schedule.dto';

@Controller('medication-schedules')
@UseGuards(FirebaseAuthGuard)
export class MedicationScheduleController {
  constructor(private readonly scheduleService: MedicationScheduleService) {}

  @Post()
  async createSchedule(
    @Body() createScheduleDto: CreateScheduleDto,
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const schedule = await this.scheduleService.createSchedule({
        ...createScheduleDto,
        userId: req.user.id,
        startDate: new Date(createScheduleDto.startDate),
        endDate: createScheduleDto.endDate
          ? new Date(createScheduleDto.endDate)
          : undefined,
      });

      return {
        success: true,
        data: schedule.toJSON(),
        message: 'Medication schedule created successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to create medication schedule',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Post('bulk')
  async createSchedules(
    @Body() createSchedulesDto: { schedules: CreateScheduleDto[] },
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const schedules = await this.scheduleService.createSchedules(
        createSchedulesDto.schedules.map((sched) => ({
          ...sched,
          userId: req.user.id,
          startDate: new Date(sched.startDate),
          endDate: sched.endDate ? new Date(sched.endDate) : undefined,
        })),
      );

      return {
        success: true,
        data: schedules.map((sched) => sched.toJSON()),
        message: `${schedules.length} medication schedules created successfully`,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to create medication schedules',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Get()
  async getUserSchedules(
    @Query() query: ScheduleQueryDto,
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const schedules = await this.scheduleService.searchSchedules({
        userId: req.user.id,
        ...query,
        startDate: query.startDate ? new Date(query.startDate) : undefined,
        endDate: query.endDate ? new Date(query.endDate) : undefined,
      });

      return {
        success: true,
        data: schedules.map((sched) => sched.toJSON()),
        count: schedules.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch medication schedules',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('active')
  async getActiveSchedules(@Request() req: { user: FirebaseUserPayload }) {
    try {
      const schedules = await this.scheduleService.getActiveSchedules(
        req.user.id,
      );

      return {
        success: true,
        data: schedules.map((sched) => sched.toJSON()),
        count: schedules.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch active schedules',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('inactive')
  async getInactiveSchedules(@Request() req: { user: FirebaseUserPayload }) {
    try {
      const schedules = await this.scheduleService.getInactiveSchedules(
        req.user.id,
      );

      return {
        success: true,
        data: schedules.map((sched) => sched.toJSON()),
        count: schedules.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch inactive schedules',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('with-reminders')
  async getSchedulesWithReminders(
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const schedules = await this.scheduleService.getSchedulesWithReminders(
        req.user.id,
      );

      return {
        success: true,
        data: schedules.map((sched) => sched.toJSON()),
        count: schedules.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch schedules with reminders',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('without-reminders')
  async getSchedulesWithoutReminders(
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const schedules = await this.scheduleService.getSchedulesWithoutReminders(
        req.user.id,
      );

      return {
        success: true,
        data: schedules.map((sched) => sched.toJSON()),
        count: schedules.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch schedules without reminders',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('frequency/:frequency')
  async getSchedulesByFrequency(
    @Param('frequency') frequency: 'daily' | 'weekly' | 'monthly' | 'as_needed',
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const schedules = await this.scheduleService.getSchedulesByFrequency(
        req.user.id,
        frequency,
      );

      return {
        success: true,
        data: schedules.map((sched) => sched.toJSON()),
        count: schedules.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch schedules by frequency',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('upcoming')
  async getUpcomingSchedules(
    @Query('hours') hours: number = 24,
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const schedules = await this.scheduleService.getUpcomingSchedules(
        req.user.id,
        parseInt(hours.toString()),
      );

      return {
        success: true,
        data: schedules.map((sched) => sched.toJSON()),
        count: schedules.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch upcoming schedules',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('expired')
  async getExpiredSchedules(@Request() req: { user: FirebaseUserPayload }) {
    try {
      const schedules = await this.scheduleService.getExpiredSchedules(
        req.user.id,
      );

      return {
        success: true,
        data: schedules.map((sched) => sched.toJSON()),
        count: schedules.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch expired schedules',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('expiring')
  async getExpiringSchedules(
    @Query('days') days: number = 7,
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const schedules = await this.scheduleService.getExpiringSchedules(
        req.user.id,
        parseInt(days.toString()),
      );

      return {
        success: true,
        data: schedules.map((sched) => sched.toJSON()),
        count: schedules.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch expiring schedules',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('statistics')
  async getScheduleStatistics(@Request() req: { user: FirebaseUserPayload }) {
    try {
      const statistics = await this.scheduleService.getScheduleStatistics(
        req.user.id,
      );

      return {
        success: true,
        data: statistics,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch schedule statistics',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('medication/:medicationId')
  async getMedicationSchedules(@Param('medicationId') medicationId: string) {
    try {
      const schedules =
        await this.scheduleService.getMedicationSchedules(medicationId);

      return {
        success: true,
        data: schedules.map((sched) => sched.toJSON()),
        count: schedules.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch medication schedules',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('medication/:medicationId/active')
  async getActiveMedicationSchedules(
    @Param('medicationId') medicationId: string,
  ) {
    try {
      const schedules =
        await this.scheduleService.getActiveMedicationSchedules(medicationId);

      return {
        success: true,
        data: schedules.map((sched) => sched.toJSON()),
        count: schedules.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch active medication schedules',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get(':id')
  async getSchedule(@Param('id') id: string) {
    try {
      const schedule = await this.scheduleService.getSchedule(id);

      if (!schedule) {
        throw new HttpException(
          {
            success: false,
            message: 'Medication schedule not found',
          },
          HttpStatus.NOT_FOUND,
        );
      }

      return {
        success: true,
        data: schedule.toJSON(),
      };
    } catch (error) {
      if (error instanceof HttpException) {
        throw error;
      }

      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch medication schedule',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Put(':id')
  async updateSchedule(
    @Param('id') id: string,
    @Body() updateScheduleDto: UpdateScheduleDto,
  ) {
    try {
      const schedule = await this.scheduleService.updateSchedule(id, {
        ...updateScheduleDto,
        endDate: updateScheduleDto.endDate
          ? new Date(updateScheduleDto.endDate)
          : undefined,
      });

      return {
        success: true,
        data: schedule.toJSON(),
        message: 'Medication schedule updated successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to update medication schedule',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/end')
  async endSchedule(
    @Param('id') id: string,
    @Body() body: { endDate: string },
  ) {
    try {
      const schedule = await this.scheduleService.endSchedule(
        id,
        new Date(body.endDate),
      );

      return {
        success: true,
        data: schedule.toJSON(),
        message: 'Medication schedule ended successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to end medication schedule',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/enable-reminders')
  async enableReminders(@Param('id') id: string) {
    try {
      const schedule = await this.scheduleService.enableReminders(id);

      return {
        success: true,
        data: schedule.toJSON(),
        message: 'Reminders enabled successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to enable reminders',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/disable-reminders')
  async disableReminders(@Param('id') id: string) {
    try {
      const schedule = await this.scheduleService.disableReminders(id);

      return {
        success: true,
        data: schedule.toJSON(),
        message: 'Reminders disabled successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to disable reminders',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Post(':id/reminder-times')
  async addReminderTime(
    @Param('id') id: string,
    @Body() addReminderTimeDto: AddReminderTimeDto,
  ) {
    try {
      const schedule = await this.scheduleService.addReminderTime(
        id,
        addReminderTimeDto,
      );

      return {
        success: true,
        data: schedule.toJSON(),
        message: 'Reminder time added successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to add reminder time',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Delete(':id/reminder-times')
  async removeReminderTime(
    @Param('id') id: string,
    @Body() removeReminderTimeDto: AddReminderTimeDto,
  ) {
    try {
      const schedule = await this.scheduleService.removeReminderTime(
        id,
        removeReminderTimeDto,
      );

      return {
        success: true,
        data: schedule.toJSON(),
        message: 'Reminder time removed successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to remove reminder time',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Delete(':id')
  async deleteSchedule(@Param('id') id: string) {
    try {
      await this.scheduleService.deleteSchedule(id);

      return {
        success: true,
        message: 'Medication schedule deleted successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to delete medication schedule',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }
}
