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
import { PrescriptionService } from '../../application/services/prescription.service';
import {
  CreatePrescriptionDto,
  UpdatePrescriptionDto,
  PrescriptionQueryDto,
  AddMedicationDto,
  UpdateMedicationDto,
  SetOCRDataDto,
} from '../dto/prescription.dto';

@Controller('prescriptions')
@UseGuards(FirebaseAuthGuard)
export class PrescriptionController {
  constructor(private readonly prescriptionService: PrescriptionService) {}

  @Post()
  async createPrescription(
    @Body() createPrescriptionDto: CreatePrescriptionDto,
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const prescription = await this.prescriptionService.createPrescription({
        ...createPrescriptionDto,
        userId: req.user.id,
        prescribedDate: new Date(createPrescriptionDto.prescribedDate),
        verifiedAt: createPrescriptionDto.verifiedAt
          ? new Date(createPrescriptionDto.verifiedAt)
          : undefined,
      });

      return {
        success: true,
        data: prescription.toJSON(),
        message: 'Prescription created successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to create prescription',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Post('bulk')
  async createPrescriptions(
    @Body() createPrescriptionsDto: { prescriptions: CreatePrescriptionDto[] },
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const prescriptions = await this.prescriptionService.createPrescriptions(
        createPrescriptionsDto.prescriptions.map((presc) => ({
          ...presc,
          userId: req.user.id,
          prescribedDate: new Date(presc.prescribedDate),
          verifiedAt: presc.verifiedAt ? new Date(presc.verifiedAt) : undefined,
        })),
      );

      return {
        success: true,
        data: prescriptions.map((presc) => presc.toJSON()),
        message: `${prescriptions.length} prescriptions created successfully`,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to create prescriptions',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Get()
  async getUserPrescriptions(
    @Query() query: PrescriptionQueryDto,
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const prescriptions = await this.prescriptionService.searchPrescriptions({
        userId: req.user.id,
        ...query,
        startDate: query.startDate ? new Date(query.startDate) : undefined,
        endDate: query.endDate ? new Date(query.endDate) : undefined,
      });

      return {
        success: true,
        data: prescriptions.map((presc) => presc.toJSON()),
        count: prescriptions.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch prescriptions',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('recent')
  async getRecentPrescriptions(
    @Request() req: { user: FirebaseUserPayload },
    @Query('limit') limit?: number,
  ) {
    try {
      const prescriptions =
        await this.prescriptionService.getRecentPrescriptions(
          req.user.id,
          limit ? parseInt(limit.toString()) : undefined,
        );

      return {
        success: true,
        data: prescriptions.map((presc) => presc.toJSON()),
        count: prescriptions.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch recent prescriptions',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('unverified')
  async getUnverifiedPrescriptions(
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const prescriptions =
        await this.prescriptionService.getUnverifiedPrescriptions(req.user.id);

      return {
        success: true,
        data: prescriptions.map((presc) => presc.toJSON()),
        count: prescriptions.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch unverified prescriptions',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('verified')
  async getVerifiedPrescriptions(
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const prescriptions =
        await this.prescriptionService.getVerifiedPrescriptions(req.user.id);

      return {
        success: true,
        data: prescriptions.map((presc) => presc.toJSON()),
        count: prescriptions.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch verified prescriptions',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('pending-verification')
  async getPendingVerificationPrescriptions(
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const prescriptions =
        await this.prescriptionService.getPendingVerificationPrescriptions(
          req.user.id,
        );

      return {
        success: true,
        data: prescriptions.map((presc) => presc.toJSON()),
        count: prescriptions.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch pending verification prescriptions',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('with-ocr')
  async getPrescriptionsWithOCR(@Request() req: { user: FirebaseUserPayload }) {
    try {
      const prescriptions =
        await this.prescriptionService.getPrescriptionsWithOCR(req.user.id);

      return {
        success: true,
        data: prescriptions.map((presc) => presc.toJSON()),
        count: prescriptions.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch prescriptions with OCR',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('without-ocr')
  async getPrescriptionsWithoutOCR(
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const prescriptions =
        await this.prescriptionService.getPrescriptionsWithoutOCR(req.user.id);

      return {
        success: true,
        data: prescriptions.map((presc) => presc.toJSON()),
        count: prescriptions.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch prescriptions without OCR',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('prescribers')
  async getUniquePrescribers(@Request() req: { user: FirebaseUserPayload }) {
    try {
      const prescribers = await this.prescriptionService.getUniquePrescribers(
        req.user.id,
      );

      return {
        success: true,
        data: prescribers,
        count: prescribers.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch prescribers',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('pharmacies')
  async getUniquePharmacies(@Request() req: { user: FirebaseUserPayload }) {
    try {
      const pharmacies = await this.prescriptionService.getUniquePharmacies(
        req.user.id,
      );

      return {
        success: true,
        data: pharmacies,
        count: pharmacies.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to fetch pharmacies',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('statistics')
  async getPrescriptionStatistics(
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const statistics =
        await this.prescriptionService.getPrescriptionStatistics(req.user.id);

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
              : 'Failed to fetch prescription statistics',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('search')
  async searchPrescriptions(
    @Request() req: { user: FirebaseUserPayload },
    @Query('term') searchTerm: string,
    @Query('limit') limit?: number,
  ) {
    try {
      const prescriptions =
        await this.prescriptionService.searchPrescriptionsByTerm(
          req.user.id,
          searchTerm,
          limit ? parseInt(limit.toString()) : undefined,
        );

      return {
        success: true,
        data: prescriptions.map((presc) => presc.toJSON()),
        count: prescriptions.length,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to search prescriptions',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get(':id')
  async getPrescription(@Param('id') id: string) {
    try {
      const prescription = await this.prescriptionService.getPrescription(id);

      if (!prescription) {
        throw new HttpException(
          {
            success: false,
            message: 'Prescription not found',
          },
          HttpStatus.NOT_FOUND,
        );
      }

      return {
        success: true,
        data: prescription.toJSON(),
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
              : 'Failed to fetch prescription',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Put(':id')
  async updatePrescription(
    @Param('id') id: string,
    @Body() updatePrescriptionDto: UpdatePrescriptionDto,
  ) {
    try {
      const prescription = await this.prescriptionService.updatePrescription(
        id,
        {
          ...updatePrescriptionDto,
          prescribedDate: updatePrescriptionDto.prescribedDate
            ? new Date(updatePrescriptionDto.prescribedDate)
            : undefined,
          verifiedAt: updatePrescriptionDto.verifiedAt
            ? new Date(updatePrescriptionDto.verifiedAt)
            : undefined,
        },
      );

      return {
        success: true,
        data: prescription.toJSON(),
        message: 'Prescription updated successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to update prescription',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/verify')
  async verifyPrescription(
    @Param('id') id: string,
    @Body() body: { verifiedBy: string },
  ) {
    try {
      const prescription = await this.prescriptionService.verifyPrescription(
        id,
        body.verifiedBy,
      );

      return {
        success: true,
        data: prescription.toJSON(),
        message: 'Prescription verified successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to verify prescription',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/unverify')
  async unverifyPrescription(@Param('id') id: string) {
    try {
      const prescription =
        await this.prescriptionService.unverifyPrescription(id);

      return {
        success: true,
        data: prescription.toJSON(),
        message: 'Prescription unverified successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to unverify prescription',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Post(':id/medications')
  async addMedicationToPrescription(
    @Param('id') id: string,
    @Body() addMedicationDto: AddMedicationDto,
  ) {
    try {
      const prescription =
        await this.prescriptionService.addMedicationToPrescription(
          id,
          addMedicationDto,
        );

      return {
        success: true,
        data: prescription.toJSON(),
        message: 'Medication added to prescription successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to add medication to prescription',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/medications/:medicationName')
  async updateMedicationInPrescription(
    @Param('id') id: string,
    @Param('medicationName') medicationName: string,
    @Body() updateMedicationDto: UpdateMedicationDto,
  ) {
    try {
      const prescription =
        await this.prescriptionService.updateMedicationInPrescription(
          id,
          medicationName,
          updateMedicationDto,
        );

      return {
        success: true,
        data: prescription.toJSON(),
        message: 'Medication updated in prescription successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to update medication in prescription',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Delete(':id/medications/:medicationName')
  async removeMedicationFromPrescription(
    @Param('id') id: string,
    @Param('medicationName') medicationName: string,
  ) {
    try {
      const prescription =
        await this.prescriptionService.removeMedicationFromPrescription(
          id,
          medicationName,
        );

      return {
        success: true,
        data: prescription.toJSON(),
        message: 'Medication removed from prescription successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to remove medication from prescription',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/ocr')
  async setOCRData(
    @Param('id') id: string,
    @Body() setOCRDataDto: SetOCRDataDto,
  ) {
    try {
      const prescription = await this.prescriptionService.setOCRData(
        id,
        setOCRDataDto,
      );

      return {
        success: true,
        data: prescription.toJSON(),
        message: 'OCR data set successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error ? error.message : 'Failed to set OCR data',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/image')
  async setImageUrl(
    @Param('id') id: string,
    @Body() body: { imageUrl: string },
  ) {
    try {
      const prescription = await this.prescriptionService.setImageUrl(
        id,
        body.imageUrl,
      );

      return {
        success: true,
        data: prescription.toJSON(),
        message: 'Image URL set successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error ? error.message : 'Failed to set image URL',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Delete(':id')
  async deletePrescription(@Param('id') id: string) {
    try {
      await this.prescriptionService.deletePrescription(id);

      return {
        success: true,
        message: 'Prescription deleted successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to delete prescription',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }
}
