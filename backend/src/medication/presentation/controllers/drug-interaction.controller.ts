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
  HttpStatus,
  HttpException,
} from '@nestjs/common';
import {
  FirebaseAuthGuard,
  FirebaseUserPayload,
} from '../../../identity-access/presentation/guards/firebase-auth.guard';
import { DrugInteractionService } from '../../infrastructure/services/drug-interaction.service';
import { RxNormService } from '../../infrastructure/services/rxnorm.service';

@Controller('drug-interactions')
@UseGuards(FirebaseAuthGuard)
export class DrugInteractionController {
  constructor(
    private readonly drugInteractionService: DrugInteractionService,
    private readonly rxNormService: RxNormService,
  ) {}

  @Get('check-user-medications')
  async checkUserMedicationInteractions(
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const analysis =
        await this.drugInteractionService.checkUserMedicationInteractions(
          req.user.id,
        );

      return {
        success: true,
        data: analysis,
        message: analysis.hasInteractions
          ? `Found ${analysis.totalInteractions} potential interaction(s)`
          : 'No interactions detected',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to check medication interactions',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Post('check-specific')
  async checkSpecificMedications(@Body() body: { medications: string[] }) {
    try {
      if (!body.medications || body.medications.length < 2) {
        throw new HttpException(
          {
            success: false,
            message:
              'At least 2 medications are required for interaction checking',
          },
          HttpStatus.BAD_REQUEST,
        );
      }

      const analysis =
        await this.drugInteractionService.checkSpecificMedicationInteractions(
          body.medications,
        );

      return {
        success: true,
        data: analysis,
        message: analysis.hasInteractions
          ? `Found ${analysis.totalInteractions} potential interaction(s)`
          : 'No interactions detected',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to check specific medication interactions',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Post('check-new-medication')
  async checkNewMedicationAgainstExisting(
    @Body() body: { medicationName: string },
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      if (!body.medicationName) {
        throw new HttpException(
          {
            success: false,
            message: 'Medication name is required',
          },
          HttpStatus.BAD_REQUEST,
        );
      }

      const analysis =
        await this.drugInteractionService.checkNewMedicationAgainstExisting(
          req.user.id,
          body.medicationName,
        );

      return {
        success: true,
        data: analysis,
        message: analysis.hasInteractions
          ? `Found ${analysis.totalInteractions} potential interaction(s) with existing medications`
          : 'No interactions detected with existing medications',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to check new medication interactions',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Get('rxnorm/search')
  async searchMedication(@Query('name') medicationName: string) {
    try {
      if (!medicationName) {
        throw new HttpException(
          {
            success: false,
            message: 'Medication name is required',
          },
          HttpStatus.BAD_REQUEST,
        );
      }

      const concepts =
        await this.rxNormService.searchMedication(medicationName);

      return {
        success: true,
        data: concepts,
        count: concepts.length,
        message: `Found ${concepts.length} matching concept(s)`,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to search medication',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('rxnorm/info/:rxcui')
  async getMedicationInfo(@Param('rxcui') rxcui: string) {
    try {
      const medicationInfo = await this.rxNormService.getMedicationInfo(rxcui);

      if (!medicationInfo) {
        throw new HttpException(
          {
            success: false,
            message: 'Medication information not found',
          },
          HttpStatus.NOT_FOUND,
        );
      }

      return {
        success: true,
        data: medicationInfo,
        message: 'Medication information retrieved successfully',
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
              : 'Failed to get medication information',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('rxnorm/validate')
  async validateMedicationName(@Query('name') medicationName: string) {
    try {
      if (!medicationName) {
        throw new HttpException(
          {
            success: false,
            message: 'Medication name is required',
          },
          HttpStatus.BAD_REQUEST,
        );
      }

      const validation =
        await this.rxNormService.validateMedicationName(medicationName);

      return {
        success: true,
        data: validation,
        message: validation.isValid
          ? 'Medication name is valid'
          : 'Medication name validation failed',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to validate medication name',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('rxnorm/suggestions')
  async getSpellingCorrections(@Query('name') medicationName: string) {
    try {
      if (!medicationName) {
        throw new HttpException(
          {
            success: false,
            message: 'Medication name is required',
          },
          HttpStatus.BAD_REQUEST,
        );
      }

      const suggestions =
        await this.rxNormService.getSpellingCorrections(medicationName);

      return {
        success: true,
        data: suggestions,
        count: suggestions.length,
        message: `Found ${suggestions.length} spelling suggestion(s)`,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to get spelling suggestions',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('rxnorm/approximate')
  async getApproximateMatches(
    @Query('name') medicationName: string,
    @Query('maxEntries') maxEntries: number = 10,
  ) {
    try {
      if (!medicationName) {
        throw new HttpException(
          {
            success: false,
            message: 'Medication name is required',
          },
          HttpStatus.BAD_REQUEST,
        );
      }

      const matches = await this.rxNormService.getApproximateMatch(
        medicationName,
        parseInt(maxEntries.toString()),
      );

      return {
        success: true,
        data: matches,
        count: matches.length,
        message: `Found ${matches.length} approximate match(es)`,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to get approximate matches',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Post('enrich-medication')
  async enrichMedicationData(
    @Body() body: { medicationName: string; strength?: string },
  ) {
    try {
      if (!body.medicationName) {
        throw new HttpException(
          {
            success: false,
            message: 'Medication name is required',
          },
          HttpStatus.BAD_REQUEST,
        );
      }

      const enrichedData =
        await this.drugInteractionService.enrichMedicationWithRxNormData(
          body.medicationName,
          body.strength,
        );

      return {
        success: true,
        data: enrichedData,
        message: enrichedData.isValid
          ? 'Medication data enriched successfully'
          : 'Medication data enrichment failed',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to enrich medication data',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put('update-rxnorm-codes')
  async updateUserMedicationRxNormCodes(
    @Request() req: { user: FirebaseUserPayload },
  ) {
    try {
      const result =
        await this.drugInteractionService.updateMedicationRxNormCodes(
          req.user.id,
        );

      return {
        success: true,
        data: result,
        message: `Updated ${result.updated} medication(s), ${result.failed} failed`,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message:
            error instanceof Error
              ? error.message
              : 'Failed to update RxNorm codes',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
