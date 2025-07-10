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
import { MedicationService } from '../../application/services/medication.service';
import { MedicationForm } from '@prisma/client';
import {
  CreateMedicationDto,
  UpdateMedicationDto,
  MedicationQueryDto,
} from '../dto/medication.dto';

@Controller('medications')
@UseGuards(FirebaseAuthGuard)
export class MedicationController {
  constructor(private readonly medicationService: MedicationService) {}

  @Post()
  async createMedication(
    @Body() createMedicationDto: CreateMedicationDto,
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const medication = await this.medicationService.createMedication({
        ...createMedicationDto,
        startDate: new Date(createMedicationDto.startDate),
        endDate: createMedicationDto.endDate
          ? new Date(createMedicationDto.endDate)
          : undefined,
        userId: req.user.id,
      });

      return {
        success: true,
        data: medication.toJSON(),
        message: 'Medication created successfully',
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error ? error.message : 'Failed to create medication';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Post('bulk')
  async createMedications(
    @Body() createMedicationsDto: { medications: CreateMedicationDto[] },
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const medications = await this.medicationService.createMedications(
        createMedicationsDto.medications.map((med) => ({
          ...med,
          startDate: new Date(med.startDate),
          endDate: med.endDate ? new Date(med.endDate) : undefined,
          userId: req.user.id,
        })),
      );

      return {
        success: true,
        data: medications.map((med) => med.toJSON()),
        message: `${medications.length} medications created successfully`,
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error ? error.message : 'Failed to create medications';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Get()
  async getUserMedications(
    @Query() query: MedicationQueryDto,
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const medications = await this.medicationService.searchMedications({
        userId: req.user.id,
        ...query,
        startDate: query.startDate ? new Date(query.startDate) : undefined,
        endDate: query.endDate ? new Date(query.endDate) : undefined,
      });

      return {
        success: true,
        data: medications.map((med) => med.toJSON()),
        count: medications.length,
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error ? error.message : 'Failed to fetch medications';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('active')
  async getActiveMedications(@Request() req: { user: FirebaseUserPayload }) {
    try {
      const medications = await this.medicationService.getActiveMedications(
        req.user.id,
      );

      return {
        success: true,
        data: medications.map((med) => med.toJSON()),
        count: medications.length,
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error
          ? error.message
          : 'Failed to fetch active medications';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('inactive')
  async getInactiveMedications(@Request() req: { user: FirebaseUserPayload }) {
    try {
      const medications = await this.medicationService.getInactiveMedications(
        req.user.id,
      );

      return {
        success: true,
        data: medications.map((med) => med.toJSON()),
        count: medications.length,
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error
          ? error.message
          : 'Failed to fetch inactive medications';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('search')
  async searchMedications(
    @Request() req: { user: FirebaseUserPayload },
    @Query('term') searchTerm: string,
    @Query('limit') limit?: number,
  ) {
    try {
      const medications = await this.medicationService.searchMedicationsByName(
        req.user.id,
        searchTerm,
        limit ? parseInt(limit.toString()) : undefined,
      );

      return {
        success: true,
        data: medications.map((med) => med.toJSON()),
        count: medications.length,
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error ? error.message : 'Failed to search medications';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('form/:form')
  async getMedicationsByForm(
    @Param('form') form: MedicationForm,
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const medications = await this.medicationService.getMedicationsByForm(
        req.user.id,
        form,
      );

      return {
        success: true,
        data: medications.map((med) => med.toJSON()),
        count: medications.length,
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error
          ? error.message
          : 'Failed to fetch medications by form';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('expired')
  async getExpiredMedications(@Request() req: { user: FirebaseUserPayload }) {
    try {
      const medications = await this.medicationService.getExpiredMedications(
        req.user.id,
      );

      return {
        success: true,
        data: medications.map((med) => med.toJSON()),
        count: medications.length,
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error
          ? error.message
          : 'Failed to fetch expired medications';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('expiring')
  async getExpiringMedications(
    @Query('days') days: number = 30,
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const medications = await this.medicationService.getExpiringMedications(
        req.user.id,
        parseInt(days.toString()),
      );

      return {
        success: true,
        data: medications.map((med) => med.toJSON()),
        count: medications.length,
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error
          ? error.message
          : 'Failed to fetch expiring medications';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('statistics')
  async getMedicationStatistics(@Request() req: { user: FirebaseUserPayload }) {
    try {
      const statistics = await this.medicationService.getMedicationStatistics(
        req.user.id,
      );

      return {
        success: true,
        data: statistics,
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error
          ? error.message
          : 'Failed to fetch medication statistics';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('duplicates')
  async getDuplicateMedications(@Request() req: { user: FirebaseUserPayload }) {
    try {
      const duplicates = await this.medicationService.findDuplicateMedications(
        req.user.id,
      );

      return {
        success: true,
        data: duplicates.map((group) => group.map((med) => med.toJSON())),
        count: duplicates.length,
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error
          ? error.message
          : 'Failed to fetch duplicate medications';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('recent')
  async getRecentMedications(
    @Request() req: { user: FirebaseUserPayload },
    @Query('days') days: number = 7,
    @Query('limit') limit?: number,
  ) {
    try {
      const recentMedications =
        await this.medicationService.getRecentMedications(
          req.user.id,
          parseInt(days.toString()),
          limit ? parseInt(limit.toString()) : undefined,
        );

      return {
        success: true,
        data: recentMedications,
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error
          ? error.message
          : 'Failed to fetch recent medications';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get(':id')
  async getMedication(@Param('id') id: string) {
    try {
      const medication = await this.medicationService.getMedication(id);

      if (!medication) {
        throw new HttpException(
          {
            success: false,
            message: 'Medication not found',
          },
          HttpStatus.NOT_FOUND,
        );
      }

      return {
        success: true,
        data: medication.toJSON(),
      };
    } catch (error: unknown) {
      if (error instanceof HttpException) {
        throw error;
      }

      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch medication',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Put(':id')
  async updateMedication(
    @Param('id') id: string,
    @Body() updateMedicationDto: UpdateMedicationDto,
  ) {
    try {
      const medication = await this.medicationService.updateMedication(id, {
        ...updateMedicationDto,
        endDate: updateMedicationDto.endDate
          ? new Date(updateMedicationDto.endDate)
          : undefined,
      });

      return {
        success: true,
        data: medication.toJSON(),
        message: 'Medication updated successfully',
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error ? error.message : 'Failed to update medication';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/deactivate')
  async deactivateMedication(
    @Param('id') id: string,
    @Body() body: { reason?: string },
  ) {
    try {
      const medication = await this.medicationService.deactivateMedication(
        id,
        body.reason,
      );

      return {
        success: true,
        data: medication.toJSON(),
        message: 'Medication deactivated successfully',
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error
          ? error.message
          : 'Failed to deactivate medication';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/reactivate')
  async reactivateMedication(@Param('id') id: string) {
    try {
      const medication = await this.medicationService.reactivateMedication(id);

      return {
        success: true,
        data: medication.toJSON(),
        message: 'Medication reactivated successfully',
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error
          ? error.message
          : 'Failed to reactivate medication';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Delete(':id')
  async deleteMedication(@Param('id') id: string) {
    try {
      await this.medicationService.deleteMedication(id);

      return {
        success: true,
        message: 'Medication deleted successfully',
      };
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error ? error.message : 'Failed to delete medication';
      throw new HttpException(
        {
          success: false,
          message: errorMessage,
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }
}
