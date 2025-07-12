import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { HealthcareSupervisorAgent } from './healthcare-supervisor.agent';
import { VietnameseMedicalAgent } from './vietnamese-medical.agent';
import { MedicationManagementAgent } from './medication-management.agent';
import { EmergencyTriageAgent } from './emergency-triage.agent';
import { ClinicalDecisionSupportAgent } from './clinical-decision-support.agent';
import { PHIProtectionService } from '../../../common/compliance/phi-protection.service';
import { VietnameseNLPIntegrationService } from '../../infrastructure/services/vietnamese-nlp-integration.service';

@Module({
  imports: [ConfigModule],
  providers: [
    PHIProtectionService,
    VietnameseNLPIntegrationService,
    HealthcareSupervisorAgent,
    VietnameseMedicalAgent,
    MedicationManagementAgent,
    EmergencyTriageAgent,
    ClinicalDecisionSupportAgent,
  ],
  exports: [
    VietnameseNLPIntegrationService,
    HealthcareSupervisorAgent,
    VietnameseMedicalAgent,
    MedicationManagementAgent,
    EmergencyTriageAgent,
    ClinicalDecisionSupportAgent,
  ],
})
export class AgentsModule {}
