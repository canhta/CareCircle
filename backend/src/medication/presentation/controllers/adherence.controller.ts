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
import { FirebaseAuthGuard } from '../../../auth/guards/firebase-auth.guard';
import { AdherenceService } from '../../application/services/adherence.service';
import { DoseStatus } from '@prisma/client';
import { CreateAdherenceRecordDto, UpdateAdherenceRecordDto, AdherenceQueryDto, MarkDoseDto } from '../dto/adherence.dto';

@Controller('adherence')
@UseGuards(FirebaseAuthGuard)
export class AdherenceController {
  constructor(private readonly adherenceService: AdherenceService) {}

  @Post()
  async createAdherenceRecord(
    @Body() createAdherenceRecordDto: CreateAdherenceRecordDto,
    @Request() req: any,
  ) {
    try {
      const record = await this.adherenceService.createAdherenceRecord({
        ...createAdherenceRecordDto,
        userId: req.user.uid,
        scheduledTime: new Date(createAdherenceRecordDto.scheduledTime),
        takenAt: createAdherenceRecordDto.takenAt ? new Date(createAdherenceRecordDto.takenAt) : undefined,
      });

      return {
        success: true,
        data: record.toJSON(),
        message: 'Adherence record created successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to create adherence record',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Post('bulk')
  async createAdherenceRecords(
    @Body() createAdherenceRecordsDto: { records: CreateAdherenceRecordDto[] },
    @Request() req: any,
  ) {
    try {
      const records = await this.adherenceService.createAdherenceRecords(
        createAdherenceRecordsDto.records.map((record) => ({
          ...record,
          userId: req.user.uid,
          scheduledTime: new Date(record.scheduledTime),
          takenAt: record.takenAt ? new Date(record.takenAt) : undefined,
        })),
      );

      return {
        success: true,
        data: records.map((record) => record.toJSON()),
        message: `${records.length} adherence records created successfully`,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to create adherence records',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Get()
  async getUserAdherenceRecords(
    @Query() query: AdherenceQueryDto,
    @Request() req: any,
  ) {
    try {
      const records = await this.adherenceService.searchAdherenceRecords({
        userId: req.user.uid,
        ...query,
        startDate: query.startDate ? new Date(query.startDate) : undefined,
        endDate: query.endDate ? new Date(query.endDate) : undefined,
      });

      return {
        success: true,
        data: records.map((record) => record.toJSON()),
        count: records.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch adherence records',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('status/:status')
  async getAdherenceByStatus(
    @Param('status') status: DoseStatus,
    @Request() req: any,
  ) {
    try {
      const records = await this.adherenceService.getAdherenceByStatus(req.user.uid, status);

      return {
        success: true,
        data: records.map((record) => record.toJSON()),
        count: records.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch adherence records by status',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('taken')
  async getTakenDoses(
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
    @Request() req: any,
  ) {
    try {
      const records = await this.adherenceService.getTakenDoses(
        req.user.uid,
        startDate ? new Date(startDate) : undefined,
        endDate ? new Date(endDate) : undefined,
      );

      return {
        success: true,
        data: records.map((record) => record.toJSON()),
        count: records.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch taken doses',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('missed')
  async getMissedDoses(
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
    @Request() req: any,
  ) {
    try {
      const records = await this.adherenceService.getMissedDoses(
        req.user.uid,
        startDate ? new Date(startDate) : undefined,
        endDate ? new Date(endDate) : undefined,
      );

      return {
        success: true,
        data: records.map((record) => record.toJSON()),
        count: records.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch missed doses',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('skipped')
  async getSkippedDoses(
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
    @Request() req: any,
  ) {
    try {
      const records = await this.adherenceService.getSkippedDoses(
        req.user.uid,
        startDate ? new Date(startDate) : undefined,
        endDate ? new Date(endDate) : undefined,
      );

      return {
        success: true,
        data: records.map((record) => record.toJSON()),
        count: records.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch skipped doses',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('scheduled')
  async getScheduledDoses(@Request() req: any) {
    try {
      const records = await this.adherenceService.getScheduledDoses(req.user.uid);

      return {
        success: true,
        data: records.map((record) => record.toJSON()),
        count: records.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch scheduled doses',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('overdue')
  async getOverdueDoses(@Request() req: any) {
    try {
      const records = await this.adherenceService.getOverdueDoses(req.user.uid);

      return {
        success: true,
        data: records.map((record) => record.toJSON()),
        count: records.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch overdue doses',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('due-now')
  async getDueNow(@Request() req: any) {
    try {
      const records = await this.adherenceService.getDueNow(req.user.uid);

      return {
        success: true,
        data: records.map((record) => record.toJSON()),
        count: records.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch doses due now',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('upcoming')
  async getUpcomingDoses(
    @Query('hours') hours: number = 24,
    @Request() req: any,
  ) {
    try {
      const records = await this.adherenceService.getUpcomingDoses(
        req.user.uid,
        parseInt(hours.toString()),
      );

      return {
        success: true,
        data: records.map((record) => record.toJSON()),
        count: records.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch upcoming doses',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('today')
  async getTodaysDoses(@Request() req: any) {
    try {
      const records = await this.adherenceService.getTodaysDoses(req.user.uid);

      return {
        success: true,
        data: records.map((record) => record.toJSON()),
        count: records.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch today\'s doses',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('statistics')
  async getAdherenceStatistics(
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
    @Request() req: any,
  ) {
    try {
      const statistics = await this.adherenceService.getAdherenceStatistics(
        req.user.uid,
        startDate ? new Date(startDate) : undefined,
        endDate ? new Date(endDate) : undefined,
      );

      return {
        success: true,
        data: statistics,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch adherence statistics',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('rate')
  async getAdherenceRate(
    @Query('medicationId') medicationId?: string,
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
    @Request() req: any,
  ) {
    try {
      const rate = await this.adherenceService.getAdherenceRate(
        req.user.uid,
        medicationId,
        startDate ? new Date(startDate) : undefined,
        endDate ? new Date(endDate) : undefined,
      );

      return {
        success: true,
        data: { adherenceRate: rate },
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch adherence rate',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('trend')
  async getAdherenceTrend(
    @Query('days') days: number = 30,
    @Query('medicationId') medicationId?: string,
    @Request() req: any,
  ) {
    try {
      const trend = await this.adherenceService.getAdherenceTrend(
        req.user.uid,
        parseInt(days.toString()),
        medicationId,
      );

      return {
        success: true,
        data: trend,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch adherence trend',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('streak/current')
  async getCurrentAdherenceStreak(
    @Query('medicationId') medicationId?: string,
    @Request() req: any,
  ) {
    try {
      const streak = await this.adherenceService.getCurrentAdherenceStreak(req.user.uid, medicationId);

      return {
        success: true,
        data: { currentStreak: streak },
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch current adherence streak',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('streak/longest')
  async getLongestAdherenceStreak(
    @Query('medicationId') medicationId?: string,
    @Request() req: any,
  ) {
    try {
      const streak = await this.adherenceService.getLongestAdherenceStreak(req.user.uid, medicationId);

      return {
        success: true,
        data: { longestStreak: streak },
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch longest adherence streak',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('ranking')
  async getMedicationAdherenceRanking(@Request() req: any) {
    try {
      const ranking = await this.adherenceService.getMedicationAdherenceRanking(req.user.uid);

      return {
        success: true,
        data: ranking,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch medication adherence ranking',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('poor-adherence')
  async getPoorAdherenceMedications(
    @Query('threshold') threshold: number = 0.8,
    @Request() req: any,
  ) {
    try {
      const medications = await this.adherenceService.getPoorAdherenceMedications(
        req.user.uid,
        parseFloat(threshold.toString()),
      );

      return {
        success: true,
        data: medications,
        count: medications.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch poor adherence medications',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('recent')
  async getRecentAdherenceActivity(
    @Query('days') days: number = 7,
    @Query('limit') limit?: number,
    @Request() req: any,
  ) {
    try {
      const records = await this.adherenceService.getRecentAdherenceActivity(
        req.user.uid,
        parseInt(days.toString()),
        limit ? parseInt(limit.toString()) : undefined,
      );

      return {
        success: true,
        data: records.map((record) => record.toJSON()),
        count: records.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch recent adherence activity',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('medication/:medicationId')
  async getMedicationAdherence(@Param('medicationId') medicationId: string) {
    try {
      const records = await this.adherenceService.getMedicationAdherence(medicationId);

      return {
        success: true,
        data: records.map((record) => record.toJSON()),
        count: records.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch medication adherence',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('schedule/:scheduleId')
  async getScheduleAdherence(@Param('scheduleId') scheduleId: string) {
    try {
      const records = await this.adherenceService.getScheduleAdherence(scheduleId);

      return {
        success: true,
        data: records.map((record) => record.toJSON()),
        count: records.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch schedule adherence',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get(':id')
  async getAdherenceRecord(@Param('id') id: string) {
    try {
      const record = await this.adherenceService.getAdherenceRecord(id);

      if (!record) {
        throw new HttpException(
          {
            success: false,
            message: 'Adherence record not found',
          },
          HttpStatus.NOT_FOUND,
        );
      }

      return {
        success: true,
        data: record.toJSON(),
      };
    } catch (error) {
      if (error instanceof HttpException) {
        throw error;
      }

      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch adherence record',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Put(':id')
  async updateAdherenceRecord(
    @Param('id') id: string,
    @Body() updateAdherenceRecordDto: UpdateAdherenceRecordDto,
  ) {
    try {
      const record = await this.adherenceService.updateAdherenceRecord(id, {
        ...updateAdherenceRecordDto,
        takenAt: updateAdherenceRecordDto.takenAt ? new Date(updateAdherenceRecordDto.takenAt) : undefined,
      });

      return {
        success: true,
        data: record.toJSON(),
        message: 'Adherence record updated successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to update adherence record',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/mark-taken')
  async markDoseAsTaken(
    @Param('id') id: string,
    @Body() markDoseDto: MarkDoseDto,
  ) {
    try {
      const record = await this.adherenceService.markDoseAsTaken(
        id,
        markDoseDto.takenAt ? new Date(markDoseDto.takenAt) : undefined,
        markDoseDto.notes,
      );

      return {
        success: true,
        data: record.toJSON(),
        message: 'Dose marked as taken successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to mark dose as taken',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/mark-skipped')
  async markDoseAsSkipped(
    @Param('id') id: string,
    @Body() body: { reason: string; notes?: string },
  ) {
    try {
      const record = await this.adherenceService.markDoseAsSkipped(id, body.reason, body.notes);

      return {
        success: true,
        data: record.toJSON(),
        message: 'Dose marked as skipped successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to mark dose as skipped',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/mark-missed')
  async markDoseAsMissed(
    @Param('id') id: string,
    @Body() body: { notes?: string },
  ) {
    try {
      const record = await this.adherenceService.markDoseAsMissed(id, body.notes);

      return {
        success: true,
        data: record.toJSON(),
        message: 'Dose marked as missed successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to mark dose as missed',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/reschedule')
  async rescheduleDose(
    @Param('id') id: string,
    @Body() body: { newScheduledTime: string; notes?: string },
  ) {
    try {
      const record = await this.adherenceService.rescheduleDose(
        id,
        new Date(body.newScheduledTime),
        body.notes,
      );

      return {
        success: true,
        data: record.toJSON(),
        message: 'Dose rescheduled successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to reschedule dose',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Post('process-overdue')
  async processOverdueDoses(@Request() req: any) {
    try {
      const result = await this.adherenceService.processOverdueDoses(req.user.uid);

      return {
        success: true,
        data: {
          processedCount: result.processedCount,
          markedAsMissed: result.markedAsMissed.map((record) => record.toJSON()),
        },
        message: `${result.processedCount} overdue doses processed successfully`,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to process overdue doses',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Delete(':id')
  async deleteAdherenceRecord(@Param('id') id: string) {
    try {
      await this.adherenceService.deleteAdherenceRecord(id);

      return {
        success: true,
        message: 'Adherence record deleted successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to delete adherence record',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }
}
