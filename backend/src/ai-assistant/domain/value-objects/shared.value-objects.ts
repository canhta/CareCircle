export interface Reference {
  type: 'medical_literature' | 'user_data' | 'health_guideline';
  title: string;
  description: string;
  url?: string;
  confidence: number;
  [key: string]: any; // Add index signature for JSON compatibility
}

export interface Attachment {
  type: 'image' | 'document' | 'audio' | 'chart';
  url: string;
  contentType: string;
  size: number;
  metadata: any;
  [key: string]: any; // Add index signature for JSON compatibility
}

export interface Source {
  name: string;
  url?: string;
  publicationDate?: Date;
  authorityLevel: 'peer_reviewed' | 'medical_authority' | 'general';
}

export enum VerificationLevel {
  UNVERIFIED = 'unverified',
  ALGORITHM_VERIFIED = 'algorithm_verified',
  EXPERT_REVIEWED = 'expert_reviewed',
  CLINICALLY_VALIDATED = 'clinically_validated',
}

export interface ValidationResult {
  isValid: boolean;
  confidence: number;
  issues: string[];
  suggestions: string[];
}
