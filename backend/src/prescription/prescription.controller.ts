import {
  Controller,
  Post,
  Get,
  Put,
  Delete,
  Param,
  Body,
  UseInterceptors,
  UploadedFile,
  BadRequestException,
  HttpException,
  HttpStatus,
  Query,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiConsumes,
  ApiBody,
  ApiParam,
  ApiQuery,
} from '@nestjs/swagger';
import { PrescriptionService } from './prescription.service';
import {
  PrescriptionOCRResponseDto,
  PrescriptionOCRErrorDto,
} from './dto/prescription-ocr.dto';
import {
  CreatePrescriptionDto,
  UpdatePrescriptionDto,
  PrescriptionResponseDto,
  PrescriptionStatsDto,
} from './dto/prescription-crud.dto';

@ApiTags('prescriptions')
@Controller('prescriptions')
export class PrescriptionController {
  constructor(private readonly prescriptionService: PrescriptionService) {}

  @Post('scan')
  @ApiOperation({
    summary: 'Scan prescription image using OCR',
    description:
      'Upload a prescription image and extract text and structured data using OCR technology',
  })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    description: 'Prescription image file',
    type: 'multipart/form-data',
    schema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          format: 'binary',
          description: 'Prescription image (JPG, PNG, PDF supported)',
        },
      },
    },
  })
  @ApiResponse({
    status: 200,
    description: 'OCR processing completed successfully',
    type: PrescriptionOCRResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid file or processing error',
    type: PrescriptionOCRErrorDto,
  })
  @ApiResponse({
    status: 500,
    description: 'Internal server error during OCR processing',
    type: PrescriptionOCRErrorDto,
  })
  @UseInterceptors(
    FileInterceptor('file', {
      limits: {
        fileSize: 10 * 1024 * 1024, // 10MB limit
      },
      fileFilter: (req, file, callback) => {
        // Accept only image files
        const allowedMimeTypes = [
          'image/jpeg',
          'image/png',
          'image/jpg',
          'image/webp',
          'application/pdf',
        ];

        if (allowedMimeTypes.includes(file.mimetype)) {
          callback(null, true);
        } else {
          callback(
            new BadRequestException(
              'Only image files (JPG, PNG, WebP) and PDF files are allowed',
            ),
            false,
          );
        }
      },
    }),
  )
  async scanPrescriptionImage(
    @UploadedFile() file: Express.Multer.File,
  ): Promise<PrescriptionOCRResponseDto> {
    if (!file) {
      throw new BadRequestException('No file uploaded');
    }

    try {
      const result = await this.prescriptionService.processImageBuffer(
        file.buffer,
      );
      return result;
    } catch (error) {
      throw new HttpException(
        {
          message:
            error instanceof Error ? error.message : 'OCR processing failed',
          code: 'OCR_PROCESSING_ERROR',
          details: error instanceof Error ? error.stack : String(error),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Post()
  @ApiOperation({
    summary: 'Create a new prescription',
    description: 'Creates a new prescription for a user',
  })
  @ApiResponse({
    status: 201,
    description: 'Prescription created successfully',
    type: PrescriptionResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid prescription data',
  })
  async createPrescription(
    @Body() createPrescriptionDto: CreatePrescriptionDto,
    @Query('userId') userId: string,
  ): Promise<PrescriptionResponseDto> {
    if (!userId) {
      throw new BadRequestException('User ID is required');
    }

    try {
      const prescription = await this.prescriptionService.createPrescription(
        userId,
        createPrescriptionDto,
      );
      return prescription;
    } catch (error) {
      throw new HttpException(
        {
          message:
            error instanceof Error
              ? error.message
              : 'Failed to create prescription',
          code: 'PRESCRIPTION_CREATION_ERROR',
          details: error instanceof Error ? error.stack : String(error),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get()
  @ApiOperation({
    summary: 'Get all prescriptions for a user',
    description: 'Retrieves all active prescriptions for a specific user',
  })
  @ApiResponse({
    status: 200,
    description: 'Prescriptions retrieved successfully',
    type: [PrescriptionResponseDto],
  })
  @ApiQuery({
    name: 'userId',
    description: 'User ID',
    required: true,
    type: String,
  })
  async getPrescriptions(
    @Query('userId') userId: string,
  ): Promise<PrescriptionResponseDto[]> {
    if (!userId) {
      throw new BadRequestException('User ID is required');
    }

    try {
      return await this.prescriptionService.getPrescriptionsByUser(userId);
    } catch (error) {
      throw new HttpException(
        {
          message:
            error instanceof Error
              ? error.message
              : 'Failed to get prescriptions',
          code: 'PRESCRIPTION_RETRIEVAL_ERROR',
          details: error instanceof Error ? error.stack : String(error),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('stats')
  @ApiOperation({
    summary: 'Get prescription statistics',
    description: 'Retrieves prescription statistics for a user',
  })
  @ApiResponse({
    status: 200,
    description: 'Statistics retrieved successfully',
    type: PrescriptionStatsDto,
  })
  @ApiQuery({
    name: 'userId',
    description: 'User ID',
    required: true,
    type: String,
  })
  async getPrescriptionStats(
    @Query('userId') userId: string,
  ): Promise<PrescriptionStatsDto> {
    if (!userId) {
      throw new BadRequestException('User ID is required');
    }

    try {
      return await this.prescriptionService.getPrescriptionStats(userId);
    } catch (error) {
      throw new HttpException(
        {
          message:
            error instanceof Error ? error.message : 'Failed to get statistics',
          code: 'PRESCRIPTION_STATS_ERROR',
          details: error instanceof Error ? error.stack : String(error),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get(':id')
  @ApiOperation({
    summary: 'Get prescription by ID',
    description: 'Retrieves a specific prescription by its ID',
  })
  @ApiResponse({
    status: 200,
    description: 'Prescription retrieved successfully',
    type: PrescriptionResponseDto,
  })
  @ApiResponse({
    status: 404,
    description: 'Prescription not found',
  })
  @ApiParam({
    name: 'id',
    description: 'Prescription ID',
    type: String,
  })
  async getPrescriptionById(
    @Param('id') id: string,
    @Query('userId') userId: string,
  ): Promise<PrescriptionResponseDto> {
    if (!userId) {
      throw new BadRequestException('User ID is required');
    }

    try {
      return await this.prescriptionService.getPrescriptionById(id, userId);
    } catch (error) {
      if (error.message.includes('not found')) {
        throw new HttpException(
          {
            message: 'Prescription not found',
            code: 'PRESCRIPTION_NOT_FOUND',
          },
          HttpStatus.NOT_FOUND,
        );
      }
      throw new HttpException(
        {
          message:
            error instanceof Error
              ? error.message
              : 'Failed to get prescription',
          code: 'PRESCRIPTION_RETRIEVAL_ERROR',
          details: error instanceof Error ? error.stack : String(error),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Put(':id')
  @ApiOperation({
    summary: 'Update a prescription',
    description: 'Updates an existing prescription',
  })
  @ApiResponse({
    status: 200,
    description: 'Prescription updated successfully',
    type: PrescriptionResponseDto,
  })
  @ApiResponse({
    status: 404,
    description: 'Prescription not found',
  })
  @ApiParam({
    name: 'id',
    description: 'Prescription ID',
    type: String,
  })
  async updatePrescription(
    @Param('id') id: string,
    @Body() updatePrescriptionDto: UpdatePrescriptionDto,
    @Query('userId') userId: string,
  ): Promise<PrescriptionResponseDto> {
    if (!userId) {
      throw new BadRequestException('User ID is required');
    }

    try {
      return await this.prescriptionService.updatePrescription(
        id,
        userId,
        updatePrescriptionDto,
      );
    } catch (error) {
      if (error.message.includes('not found')) {
        throw new HttpException(
          {
            message: 'Prescription not found',
            code: 'PRESCRIPTION_NOT_FOUND',
          },
          HttpStatus.NOT_FOUND,
        );
      }
      throw new HttpException(
        {
          message:
            error instanceof Error
              ? error.message
              : 'Failed to update prescription',
          code: 'PRESCRIPTION_UPDATE_ERROR',
          details: error instanceof Error ? error.stack : String(error),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Delete(':id')
  @ApiOperation({
    summary: 'Delete a prescription',
    description: 'Soft deletes a prescription (marks as inactive)',
  })
  @ApiResponse({
    status: 200,
    description: 'Prescription deleted successfully',
  })
  @ApiResponse({
    status: 404,
    description: 'Prescription not found',
  })
  @ApiParam({
    name: 'id',
    description: 'Prescription ID',
    type: String,
  })
  async deletePrescription(
    @Param('id') id: string,
    @Query('userId') userId: string,
  ): Promise<{ message: string }> {
    if (!userId) {
      throw new BadRequestException('User ID is required');
    }

    try {
      await this.prescriptionService.deletePrescription(id, userId);
      return { message: 'Prescription deleted successfully' };
    } catch (error) {
      if (error.message.includes('not found')) {
        throw new HttpException(
          {
            message: 'Prescription not found',
            code: 'PRESCRIPTION_NOT_FOUND',
          },
          HttpStatus.NOT_FOUND,
        );
      }
      throw new HttpException(
        {
          message:
            error instanceof Error
              ? error.message
              : 'Failed to delete prescription',
          code: 'PRESCRIPTION_DELETE_ERROR',
          details: error instanceof Error ? error.stack : String(error),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Post('from-ocr')
  @ApiOperation({
    summary: 'Create prescription from OCR data',
    description: 'Creates a prescription from OCR scan results',
  })
  @ApiResponse({
    status: 201,
    description: 'Prescription created from OCR data successfully',
    type: PrescriptionResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid OCR data',
  })
  async createPrescriptionFromOCR(
    @Body() ocrData: PrescriptionOCRResponseDto,
    @Query('userId') userId: string,
    @Query('imageUrl') imageUrl?: string,
  ): Promise<PrescriptionResponseDto> {
    if (!userId) {
      throw new BadRequestException('User ID is required');
    }

    try {
      const prescription =
        await this.prescriptionService.createPrescriptionFromOCR(
          userId,
          ocrData,
          imageUrl,
        );
      return prescription;
    } catch (error) {
      throw new HttpException(
        {
          message:
            error instanceof Error
              ? error.message
              : 'Failed to create prescription from OCR',
          code: 'PRESCRIPTION_OCR_CREATION_ERROR',
          details: error instanceof Error ? error.stack : String(error),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
