import {
  Controller,
  Post,
  UseInterceptors,
  UploadedFile,
  BadRequestException,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiConsumes,
  ApiBody,
} from '@nestjs/swagger';
import { PrescriptionService } from './prescription.service';
import {
  PrescriptionOCRResponseDto,
  PrescriptionOCRErrorDto,
} from './dto/prescription-ocr.dto';

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
}
