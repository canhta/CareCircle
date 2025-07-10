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
        userId: req.user.id,
      });

      return {
        success: true,
        data: medication.toJSON(),
        message: 'Medication created successfully',
      };
    } catch (error) {
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
          userId: req.user.id,
        })),
      );

      return {
        success: true,
        data: medications.map((med) => med.toJSON()),
        message: `${medications.length} medications created successfully`,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to create medications',
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
      });

      return {
        success: true,
        data: medications.map((med) => med.toJSON()),
        count: medications.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch medications',
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
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch active medications',
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
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch inactive medications',
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
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to search medications',
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
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch medications by form',
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
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch expired medications',
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
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch expiring medications',
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
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch medication statistics',
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
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch duplicate medications',
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
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch recent medications',
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
    } catch (error) {
      if (error instanceof HttpException) {
        throw error;
      }

      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to fetch medication',
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
      const medication = await this.medicationService.updateMedication(
        id,
        updateMedicationDto,
      );

      return {
        success: true,
        data: medication.toJSON(),
        message: 'Medication updated successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to update medication',
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
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to deactivate medication',
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
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to reactivate medication',
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
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to delete medication',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }
}
