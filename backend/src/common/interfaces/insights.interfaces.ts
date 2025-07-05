import { HealthInsight } from '../../insights/insight-generator.service';

/**
 * Interface for prescription data in user health context
 */
export interface PrescriptionData {
  id: string;
  medicationName: string;
  dosage: string;
  frequency: string;
  startDate?: Date;
  endDate?: Date;
  status?: 'active' | 'completed' | 'discontinued';
  instructions?: string;
}

/**
 * Interface for care group context data
 */
export interface CareGroupContextData {
  id: string;
  name: string;
  role: 'caregiver' | 'patient' | 'physician' | 'family';
  memberCount?: number;
  lastActivity?: Date;
  careNotes?: string[];
}

/**
 * Improved UserHealthContext interface replacing any types
 */
export interface UserHealthContext {
  age?: number;
  gender?: string;
  prescriptions: PrescriptionData[];
  careGroupContext: CareGroupContextData[];
} 