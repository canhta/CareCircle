import { Module } from '@nestjs/common';
import { PrismaModule } from '../common/database/prisma.module';
import { IdentityAccessModule } from '../identity-access/identity-access.module';

// Domain Repositories (imported as string tokens in providers)

// Infrastructure Repositories
import { PrismaMedicationRepository } from './infrastructure/repositories/prisma-medication.repository';
import { PrismaPrescriptionRepository } from './infrastructure/repositories/prisma-prescription.repository';
import { PrismaMedicationScheduleRepository } from './infrastructure/repositories/prisma-medication-schedule.repository';
import { PrismaAdherenceRecordRepository } from './infrastructure/repositories/prisma-adherence-record.repository';

// Application Services
import { MedicationService } from './application/services/medication.service';
import { PrescriptionService } from './application/services/prescription.service';
import { MedicationScheduleService } from './application/services/medication-schedule.service';
import { AdherenceService } from './application/services/adherence.service';
import { PrescriptionProcessingService } from './application/services/prescription-processing.service';

// Infrastructure Services
import { OCRService } from './infrastructure/services/ocr.service';
import { RxNormService } from './infrastructure/services/rxnorm.service';
import { DrugInteractionService } from './infrastructure/services/drug-interaction.service';

// Presentation Controllers
import { MedicationController } from './presentation/controllers/medication.controller';
import { PrescriptionController } from './presentation/controllers/prescription.controller';
import { MedicationScheduleController } from './presentation/controllers/medication-schedule.controller';
import { AdherenceController } from './presentation/controllers/adherence.controller';
import { PrescriptionProcessingController } from './presentation/controllers/prescription-processing.controller';
import { DrugInteractionController } from './presentation/controllers/drug-interaction.controller';

@Module({
  imports: [PrismaModule, IdentityAccessModule],
  controllers: [
    MedicationController,
    PrescriptionController,
    MedicationScheduleController,
    AdherenceController,
    PrescriptionProcessingController,
    DrugInteractionController,
  ],
  providers: [
    // Repository Implementations
    {
      provide: 'MedicationRepository',
      useClass: PrismaMedicationRepository,
    },
    {
      provide: 'PrescriptionRepository',
      useClass: PrismaPrescriptionRepository,
    },
    {
      provide: 'MedicationScheduleRepository',
      useClass: PrismaMedicationScheduleRepository,
    },
    {
      provide: 'AdherenceRecordRepository',
      useClass: PrismaAdherenceRecordRepository,
    },

    // Infrastructure Services
    OCRService,
    RxNormService,
    DrugInteractionService,

    // Application Services
    MedicationService,
    PrescriptionService,
    MedicationScheduleService,
    AdherenceService,
    PrescriptionProcessingService,
  ],
  exports: [
    // Infrastructure Services
    OCRService,
    RxNormService,
    DrugInteractionService,

    // Application Services
    MedicationService,
    PrescriptionService,
    MedicationScheduleService,
    AdherenceService,
    PrescriptionProcessingService,
  ],
})
export class MedicationModule {}
