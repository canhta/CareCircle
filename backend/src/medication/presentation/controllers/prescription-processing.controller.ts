import {
  Controller,
  Post,
  Put,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
  HttpStatus,
  HttpException,
  UseInterceptors,
  UploadedFile,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { FirebaseAuthGuard } from '../../../identity-access/presentation/guards/firebase-auth.guard';
import { PrescriptionProcessingService } from '../../application/services/prescription-processing.service';
import { OCRProcessingOptions } from '../../infrastructure/services/ocr.service';

@Controller('prescription-processing')
@UseGuards(FirebaseAuthGuard)
export class PrescriptionProcessingController {
  constructor(
    private readonly prescriptionProcessingService: PrescriptionProcessingService,
  ) {}

  @Post('upload')
  @UseInterceptors(FileInterceptor('image'))
  async processImageUpload(
    @UploadedFile() file: Express.Multer.File,
    @Body() body: {
      prescribedBy?: string;
      prescribedDate?: string;
      imageQuality?: 'low' | 'medium' | 'high';
      extractionMethod?: 'basic' | 'enhanced' | 'medical';
      confidenceThreshold?: number;
    },
    @Request() req: any,
  ) {
    try {
      if (!file) {
        throw new HttpException(
          {
            success: false,
            message: 'No image file provided',
          },
          HttpStatus.BAD_REQUEST,
        );
      }

      // Validate file type
      if (!file.mimetype.startsWith('image/')) {
        throw new HttpException(
          {
            success: false,
            message: 'File must be an image',
          },
          HttpStatus.BAD_REQUEST,
        );
      }

      // Validate file size (10MB limit)
      if (file.size > 10 * 1024 * 1024) {
        throw new HttpException(
          {
            success: false,
            message: 'File size must be less than 10MB',
          },
          HttpStatus.BAD_REQUEST,
        );
      }

      const options: OCRProcessingOptions = {
        imageQuality: body.imageQuality,
        extractionMethod: body.extractionMethod,
        confidenceThreshold: body.confidenceThreshold ? parseFloat(body.confidenceThreshold.toString()) : undefined,
      };

      const result = await this.prescriptionProcessingService.processImagePrescription(
        req.user.uid,
        file.buffer,
        body.prescribedBy,
        body.prescribedDate ? new Date(body.prescribedDate) : undefined,
        options,
      );

      return {
        success: true,
        data: {
          prescription: result.prescription.toJSON(),
          extractedMedications: result.extractedMedications,
          createdMedications: result.createdMedications.map(med => med.toJSON()),
          ocrValidation: result.ocrValidation,
          interactionAnalysis: result.interactionAnalysis,
          processingMetadata: result.processingMetadata,
        },
        message: 'Prescription processed successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to process prescription image',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Post('url')
  async processImageUrl(
    @Body() body: {
      imageUrl: string;
      prescribedBy?: string;
      prescribedDate?: string;
      imageQuality?: 'low' | 'medium' | 'high';
      extractionMethod?: 'basic' | 'enhanced' | 'medical';
      confidenceThreshold?: number;
    },
    @Request() req: any,
  ) {
    try {
      if (!body.imageUrl) {
        throw new HttpException(
          {
            success: false,
            message: 'Image URL is required',
          },
          HttpStatus.BAD_REQUEST,
        );
      }

      const options: OCRProcessingOptions = {
        imageQuality: body.imageQuality,
        extractionMethod: body.extractionMethod,
        confidenceThreshold: body.confidenceThreshold,
      };

      const result = await this.prescriptionProcessingService.processUrlPrescription(
        req.user.uid,
        body.imageUrl,
        body.prescribedBy,
        body.prescribedDate ? new Date(body.prescribedDate) : undefined,
        options,
      );

      return {
        success: true,
        data: {
          prescription: result.prescription.toJSON(),
          extractedMedications: result.extractedMedications,
          createdMedications: result.createdMedications.map(med => med.toJSON()),
          ocrValidation: result.ocrValidation,
          interactionAnalysis: result.interactionAnalysis,
          processingMetadata: result.processingMetadata,
        },
        message: 'Prescription processed successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to process prescription from URL',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/reprocess')
  async reprocessPrescription(
    @Param('id') id: string,
    @Body() body: {
      imageQuality?: 'low' | 'medium' | 'high';
      extractionMethod?: 'basic' | 'enhanced' | 'medical';
      confidenceThreshold?: number;
    },
  ) {
    try {
      const options: OCRProcessingOptions = {
        imageQuality: body.imageQuality,
        extractionMethod: body.extractionMethod,
        confidenceThreshold: body.confidenceThreshold,
      };

      const result = await this.prescriptionProcessingService.reprocessPrescriptionOCR(id, options);

      return {
        success: true,
        data: {
          prescription: result.prescription.toJSON(),
          ocrValidation: result.ocrValidation,
          updatedMedications: result.updatedMedications,
        },
        message: 'Prescription reprocessed successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to reprocess prescription',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id/enhance-rxnorm')
  async enhanceWithRxNorm(@Param('id') id: string) {
    try {
      const result = await this.prescriptionProcessingService.enhancePrescriptionWithRxNormData(id);

      return {
        success: true,
        data: {
          prescription: result.prescription.toJSON(),
          enhancedMedications: result.enhancedMedications,
        },
        message: 'Prescription enhanced with RxNorm data successfully',
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Failed to enhance prescription with RxNorm data',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }
}
