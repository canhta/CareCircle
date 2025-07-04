import { Module } from '@nestjs/common';
import { PrescriptionService } from './prescription.service';
import { PrescriptionController } from './prescription.controller';
import { PrescriptionOCRService } from './services/prescription-ocr.service';

@Module({
  providers: [PrescriptionService, PrescriptionOCRService],
  controllers: [PrescriptionController],
  exports: [PrescriptionService, PrescriptionOCRService],
})
export class PrescriptionModule {}
