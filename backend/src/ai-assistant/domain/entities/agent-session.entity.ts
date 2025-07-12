export enum AgentSessionType {
  CONSULTATION = 'consultation',
  MEDICATION = 'medication',
  EMERGENCY = 'emergency',
  WELLNESS = 'wellness',
  VIETNAMESE_HEALTHCARE = 'vietnamese_healthcare',
}

export enum AgentSessionStatus {
  ACTIVE = 'active',
  COMPLETED = 'completed',
  ESCALATED = 'escalated',
  CANCELLED = 'cancelled',
}

export interface AgentSessionMetadata {
  healthContextIncluded: boolean;
  medicationContextIncluded: boolean;
  vietnameseContextIncluded: boolean;
  phiDetected: boolean;
  complianceFlags: string[];
  agentsInvolved: string[];
  totalProcessingTime: number;
  totalTokensUsed: number;
  averageConfidence: number;
  escalationTriggered: boolean;
  culturalContext: 'traditional' | 'modern' | 'mixed';
  languagePreference: 'vietnamese' | 'english' | 'mixed';
}

export interface HealthcareContext {
  patientId?: string;
  age?: number;
  gender?: 'male' | 'female' | 'other';
  medicalHistory?: string[];
  currentMedications?: string[];
  allergies?: string[];
  vitalSigns?: {
    bloodPressure?: string;
    heartRate?: number;
    temperature?: number;
    weight?: number;
    height?: number;
  };
  emergencyContacts?: Array<{
    name: string;
    relationship: string;
    phone: string;
  }>;
  preferredLanguage?: string;
  culturalPreferences?: {
    traditionalMedicine: boolean;
    familyInvolvement: boolean;
    religiousConsiderations?: string;
  };
}

export class AgentSession {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public readonly patientId: string | null,
    public readonly sessionType: AgentSessionType,
    public readonly createdAt: Date,
    public updatedAt: Date,
    public status: AgentSessionStatus,
    public metadata: AgentSessionMetadata,
    public healthcareContext: HealthcareContext,
    public readonly expiresAt: Date,
  ) {}

  static create(data: {
    id: string;
    userId: string;
    patientId?: string;
    sessionType: AgentSessionType;
    healthcareContext?: HealthcareContext;
    metadata?: Partial<AgentSessionMetadata>;
    expiresInHours?: number;
  }): AgentSession {
    const now = new Date();
    const expiresAt = new Date();
    expiresAt.setHours(now.getHours() + (data.expiresInHours || 24));

    const defaultMetadata: AgentSessionMetadata = {
      healthContextIncluded: false,
      medicationContextIncluded: false,
      vietnameseContextIncluded: false,
      phiDetected: false,
      complianceFlags: [],
      agentsInvolved: [],
      totalProcessingTime: 0,
      totalTokensUsed: 0,
      averageConfidence: 0,
      escalationTriggered: false,
      culturalContext: 'modern',
      languagePreference: 'english',
    };

    const defaultHealthcareContext: HealthcareContext = {
      preferredLanguage: 'en',
      culturalPreferences: {
        traditionalMedicine: false,
        familyInvolvement: false,
      },
    };

    return new AgentSession(
      data.id,
      data.userId,
      data.patientId || null,
      data.sessionType,
      now,
      now,
      AgentSessionStatus.ACTIVE,
      { ...defaultMetadata, ...data.metadata },
      { ...defaultHealthcareContext, ...data.healthcareContext },
      expiresAt,
    );
  }

  updateMetadata(updates: Partial<AgentSessionMetadata>): void {
    this.metadata = { ...this.metadata, ...updates };
    this.updatedAt = new Date();
  }

  updateHealthcareContext(updates: Partial<HealthcareContext>): void {
    this.healthcareContext = { ...this.healthcareContext, ...updates };
    this.updatedAt = new Date();
  }

  addAgent(agentName: string): void {
    if (!this.metadata.agentsInvolved.includes(agentName)) {
      this.metadata.agentsInvolved.push(agentName);
      this.updatedAt = new Date();
    }
  }

  addProcessingTime(timeMs: number): void {
    this.metadata.totalProcessingTime += timeMs;
    this.updatedAt = new Date();
  }

  addTokensUsed(tokens: number): void {
    this.metadata.totalTokensUsed += tokens;
    this.updatedAt = new Date();
  }

  updateConfidence(confidence: number): void {
    // Simple moving average for confidence
    const currentCount = this.metadata.agentsInvolved.length || 1;
    this.metadata.averageConfidence =
      (this.metadata.averageConfidence * (currentCount - 1) + confidence) /
      currentCount;
    this.updatedAt = new Date();
  }

  triggerEscalation(): void {
    this.metadata.escalationTriggered = true;
    this.status = AgentSessionStatus.ESCALATED;
    this.updatedAt = new Date();
  }

  addComplianceFlag(flag: string): void {
    if (!this.metadata.complianceFlags.includes(flag)) {
      this.metadata.complianceFlags.push(flag);
      this.metadata.phiDetected = true;
      this.updatedAt = new Date();
    }
  }

  complete(): void {
    this.status = AgentSessionStatus.COMPLETED;
    this.updatedAt = new Date();
  }

  cancel(): void {
    this.status = AgentSessionStatus.CANCELLED;
    this.updatedAt = new Date();
  }

  isExpired(): boolean {
    return new Date() > this.expiresAt;
  }

  isActive(): boolean {
    return this.status === AgentSessionStatus.ACTIVE && !this.isExpired();
  }

  getSessionSummary(): {
    duration: number;
    agentCount: number;
    totalTokens: number;
    averageConfidence: number;
    hasCompliance: boolean;
    wasEscalated: boolean;
  } {
    const duration = this.updatedAt.getTime() - this.createdAt.getTime();

    return {
      duration,
      agentCount: this.metadata.agentsInvolved.length,
      totalTokens: this.metadata.totalTokensUsed,
      averageConfidence: this.metadata.averageConfidence,
      hasCompliance: this.metadata.complianceFlags.length > 0,
      wasEscalated: this.metadata.escalationTriggered,
    };
  }

  // Healthcare-specific methods
  hasEmergencyContext(): boolean {
    return (
      this.sessionType === AgentSessionType.EMERGENCY ||
      this.metadata.escalationTriggered
    );
  }

  hasVietnameseContext(): boolean {
    return (
      this.metadata.vietnameseContextIncluded ||
      this.metadata.languagePreference === 'vietnamese' ||
      this.metadata.culturalContext === 'traditional'
    );
  }

  hasMedicationContext(): boolean {
    return !!(
      this.metadata.medicationContextIncluded ||
      (this.healthcareContext.currentMedications &&
        this.healthcareContext.currentMedications.length > 0)
    );
  }

  getHealthRiskLevel(): 'low' | 'medium' | 'high' | 'critical' {
    if (this.hasEmergencyContext()) return 'critical';
    if (this.metadata.escalationTriggered) return 'high';
    if (this.hasMedicationContext() && this.metadata.complianceFlags.length > 0)
      return 'medium';
    return 'low';
  }

  shouldNotifyEmergencyContacts(): boolean {
    return !!(
      this.hasEmergencyContext() &&
      this.healthcareContext.emergencyContacts &&
      this.healthcareContext.emergencyContacts.length > 0
    );
  }

  getRecommendedFollowUp(): string[] {
    const recommendations: string[] = [];

    if (this.hasEmergencyContext()) {
      recommendations.push('Immediate medical attention required');
    }

    if (this.hasMedicationContext()) {
      recommendations.push('Review medication list with healthcare provider');
    }

    if (
      this.hasVietnameseContext() &&
      this.metadata.culturalContext === 'traditional'
    ) {
      recommendations.push('Consider traditional medicine consultation');
    }

    if (this.metadata.averageConfidence < 0.7) {
      recommendations.push('Seek professional medical opinion');
    }

    return recommendations;
  }
}
