export enum AgentType {
  SUPERVISOR = 'supervisor',
  MEDICATION = 'medication',
  EMERGENCY = 'emergency',
  CLINICAL = 'clinical',
  VIETNAMESE_MEDICAL = 'vietnamese_medical',
  HEALTH_ANALYTICS = 'health_analytics',
}

export enum AgentInteractionType {
  QUERY = 'query',
  HANDOFF = 'handoff',
  ESCALATION = 'escalation',
  ANALYSIS = 'analysis',
  RECOMMENDATION = 'recommendation',
}

export enum UrgencyLevel {
  ROUTINE = 'routine',
  URGENT = 'urgent',
  EMERGENCY = 'emergency',
}

export interface InteractionMetadata {
  processingTimeMs: number;
  modelUsed: string;
  tokensConsumed: number;
  costUsd: number;
  confidence: number;
  phiDetected: boolean;
  phiMaskedFields: string[];
  complianceScore: number;
  medicalEntities: Array<{
    type: string;
    value: string;
    confidence: number;
  }>;
  clinicalFlags: string[];
  medicationMentioned: boolean;
  symptomsMentioned: boolean;
  emergencyKeywords: string[];
  vietnameseTermsDetected: string[];
  traditionalMedicineReferences: string[];
}

export interface AgentCapability {
  name: string;
  confidence: number;
  requiresPhysicianReview: boolean;
  maxSeverityLevel: number;
  supportedLanguages: string[];
  culturalContexts: string[];
}

export class AgentInteraction {
  constructor(
    public readonly id: string,
    public readonly sessionId: string,
    public readonly agentType: AgentType,
    public readonly interactionType: AgentInteractionType,
    public readonly userQuery: string,
    public readonly agentResponse: string,
    public readonly urgencyLevel: UrgencyLevel,
    public readonly createdAt: Date,
    public readonly metadata: InteractionMetadata,
    public readonly queryHash: string,
    public readonly responseHash: string,
  ) {}

  static create(data: {
    id: string;
    sessionId: string;
    agentType: AgentType;
    interactionType: AgentInteractionType;
    userQuery: string;
    agentResponse: string;
    urgencyLevel?: UrgencyLevel;
    metadata?: Partial<InteractionMetadata>;
  }): AgentInteraction {
    const now = new Date();

    const defaultMetadata: InteractionMetadata = {
      processingTimeMs: 0,
      modelUsed: 'gpt-4',
      tokensConsumed: 0,
      costUsd: 0,
      confidence: 0.9,
      phiDetected: false,
      phiMaskedFields: [],
      complianceScore: 1.0,
      medicalEntities: [],
      clinicalFlags: [],
      medicationMentioned: false,
      symptomsMentioned: false,
      emergencyKeywords: [],
      vietnameseTermsDetected: [],
      traditionalMedicineReferences: [],
    };

    // Generate hashes for deduplication
    const queryHash = AgentInteraction.generateHash(data.userQuery);
    const responseHash = AgentInteraction.generateHash(data.agentResponse);

    return new AgentInteraction(
      data.id,
      data.sessionId,
      data.agentType,
      data.interactionType,
      data.userQuery,
      data.agentResponse,
      data.urgencyLevel || UrgencyLevel.ROUTINE,
      now,
      { ...defaultMetadata, ...data.metadata },
      queryHash,
      responseHash,
    );
  }

  private static generateHash(content: string): string {
    // Simple hash function for deduplication
    let hash = 0;
    for (let i = 0; i < content.length; i++) {
      const char = content.charCodeAt(i);
      hash = (hash << 5) - hash + char;
      hash = hash & hash; // Convert to 32-bit integer
    }
    return Math.abs(hash).toString(16);
  }

  // Analysis methods
  isHighUrgency(): boolean {
    return (
      this.urgencyLevel === UrgencyLevel.EMERGENCY ||
      this.metadata.emergencyKeywords.length > 0
    );
  }

  hasComplianceIssues(): boolean {
    return (
      this.metadata.phiDetected ||
      this.metadata.complianceScore < 0.8 ||
      this.metadata.phiMaskedFields.length > 0
    );
  }

  requiresPhysicianReview(): boolean {
    return (
      this.isHighUrgency() ||
      this.metadata.confidence < 0.7 ||
      this.hasComplianceIssues() ||
      this.metadata.clinicalFlags.length > 0
    );
  }

  isVietnameseHealthcare(): boolean {
    return (
      this.agentType === AgentType.VIETNAMESE_MEDICAL ||
      this.metadata.vietnameseTermsDetected.length > 0 ||
      this.metadata.traditionalMedicineReferences.length > 0
    );
  }

  isMedicationRelated(): boolean {
    return (
      this.agentType === AgentType.MEDICATION ||
      this.metadata.medicationMentioned
    );
  }

  isEmergencyRelated(): boolean {
    return (
      this.agentType === AgentType.EMERGENCY ||
      this.urgencyLevel === UrgencyLevel.EMERGENCY ||
      this.metadata.emergencyKeywords.length > 0
    );
  }

  // Cost and performance metrics
  getCostPerToken(): number {
    if (this.metadata.tokensConsumed === 0) return 0;
    return this.metadata.costUsd / this.metadata.tokensConsumed;
  }

  getProcessingSpeed(): number {
    if (this.metadata.processingTimeMs === 0) return 0;
    return (
      this.metadata.tokensConsumed / (this.metadata.processingTimeMs / 1000)
    ); // tokens per second
  }

  getQualityScore(): number {
    // Composite quality score based on confidence, compliance, and processing time
    const confidenceWeight = 0.4;
    const complianceWeight = 0.4;
    const speedWeight = 0.2;

    const speedScore = Math.min(1.0, 1000 / this.metadata.processingTimeMs); // Normalize to 1 second baseline

    return (
      this.metadata.confidence * confidenceWeight +
      this.metadata.complianceScore * complianceWeight +
      speedScore * speedWeight
    );
  }

  // Healthcare-specific analysis
  extractMedicalConcepts(): string[] {
    const concepts: string[] = [];

    // Extract from medical entities
    this.metadata.medicalEntities.forEach((entity) => {
      if (entity.confidence > 0.7) {
        concepts.push(`${entity.type}: ${entity.value}`);
      }
    });

    // Add clinical flags
    concepts.push(...this.metadata.clinicalFlags);

    // Add Vietnamese medical terms
    if (this.metadata.vietnameseTermsDetected.length > 0) {
      concepts.push(
        ...this.metadata.vietnameseTermsDetected.map(
          (term) => `Vietnamese: ${term}`,
        ),
      );
    }

    // Add traditional medicine references
    if (this.metadata.traditionalMedicineReferences.length > 0) {
      concepts.push(
        ...this.metadata.traditionalMedicineReferences.map(
          (ref) => `Traditional: ${ref}`,
        ),
      );
    }

    return concepts;
  }

  getRiskAssessment(): {
    level: 'low' | 'medium' | 'high' | 'critical';
    factors: string[];
    recommendations: string[];
  } {
    const factors: string[] = [];
    const recommendations: string[] = [];
    let level: 'low' | 'medium' | 'high' | 'critical' = 'low';

    // Emergency assessment
    if (this.isEmergencyRelated()) {
      level = 'critical';
      factors.push('Emergency-related query');
      recommendations.push('Immediate medical attention required');
    }

    // Medication safety
    if (this.isMedicationRelated() && this.metadata.clinicalFlags.length > 0) {
      level = level === 'critical' ? 'critical' : 'high';
      factors.push('Medication safety concerns');
      recommendations.push('Consult healthcare provider about medications');
    }

    // Compliance issues
    if (this.hasComplianceIssues()) {
      level = level === 'critical' ? 'critical' : 'medium';
      factors.push('Healthcare compliance concerns');
      recommendations.push('Review privacy and compliance protocols');
    }

    // Low confidence
    if (this.metadata.confidence < 0.7) {
      level = level === 'low' ? 'medium' : level;
      factors.push('Low confidence in response');
      recommendations.push('Seek professional medical opinion');
    }

    // Vietnamese healthcare context
    if (
      this.isVietnameseHealthcare() &&
      this.metadata.traditionalMedicineReferences.length > 0
    ) {
      factors.push('Traditional medicine integration needed');
      recommendations.push(
        'Consider consultation with traditional medicine practitioner',
      );
    }

    return { level, factors, recommendations };
  }

  // Audit and compliance methods
  getAuditSummary(): {
    interactionId: string;
    timestamp: Date;
    agentType: string;
    urgencyLevel: string;
    phiDetected: boolean;
    complianceScore: number;
    requiresReview: boolean;
    costUsd: number;
  } {
    return {
      interactionId: this.id,
      timestamp: this.createdAt,
      agentType: this.agentType,
      urgencyLevel: this.urgencyLevel,
      phiDetected: this.metadata.phiDetected,
      complianceScore: this.metadata.complianceScore,
      requiresReview: this.requiresPhysicianReview(),
      costUsd: this.metadata.costUsd,
    };
  }

  // Performance analytics
  getPerformanceMetrics(): {
    processingTime: number;
    tokensPerSecond: number;
    costEfficiency: number;
    qualityScore: number;
    confidence: number;
  } {
    return {
      processingTime: this.metadata.processingTimeMs,
      tokensPerSecond: this.getProcessingSpeed(),
      costEfficiency: this.getCostPerToken(),
      qualityScore: this.getQualityScore(),
      confidence: this.metadata.confidence,
    };
  }

  // Update methods
  updateMetadata(updates: Partial<InteractionMetadata>): AgentInteraction {
    const updatedMetadata = { ...this.metadata, ...updates };

    return new AgentInteraction(
      this.id,
      this.sessionId,
      this.agentType,
      this.interactionType,
      this.userQuery,
      this.agentResponse,
      this.urgencyLevel,
      this.createdAt,
      updatedMetadata,
      this.queryHash,
      this.responseHash,
    );
  }
}
