import {
  InsightType,
  InsightSeverity,
} from '../value-objects/insight.value-objects';

export class HealthInsight {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public readonly type: InsightType,
    public title: string,
    public description: string,
    public relatedMetrics: string[],
    public readonly severity: InsightSeverity,
    public recommendations: string[],
    public readonly generatedAt: Date,
    public readonly expiresAt: Date,
    public isAcknowledged: boolean,
    public readonly confidence: number,
    public readonly sourceData: any,
  ) {}

  static create(data: {
    id: string;
    userId: string;
    type: InsightType;
    title: string;
    description: string;
    relatedMetrics: string[];
    severity: InsightSeverity;
    recommendations: string[];
    expiresInDays?: number;
    confidence: number;
    sourceData: any;
  }): HealthInsight {
    const now = new Date();
    const expiresAt = new Date();
    expiresAt.setDate(now.getDate() + (data.expiresInDays || 30));

    return new HealthInsight(
      data.id,
      data.userId,
      data.type,
      data.title,
      data.description,
      data.relatedMetrics,
      data.severity,
      data.recommendations,
      now,
      expiresAt,
      false,
      data.confidence,
      data.sourceData,
    );
  }

  acknowledge(): void {
    this.isAcknowledged = true;
  }

  updateTitle(title: string): void {
    this.title = title;
  }

  updateDescription(description: string): void {
    this.description = description;
  }

  addRecommendation(recommendation: string): void {
    this.recommendations.push(recommendation);
  }

  addRelatedMetric(metric: string): void {
    if (!this.relatedMetrics.includes(metric)) {
      this.relatedMetrics.push(metric);
    }
  }

  isExpired(): boolean {
    return new Date() > this.expiresAt;
  }

  isCritical(): boolean {
    return this.severity === InsightSeverity.CRITICAL;
  }

  isHigh(): boolean {
    return this.severity === InsightSeverity.ALERT;
  }

  requiresImmediateAttention(): boolean {
    return this.isCritical() || this.isHigh();
  }

  getDaysUntilExpiry(): number {
    const now = new Date();
    const diffTime = this.expiresAt.getTime() - now.getTime();
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  }

  isHighConfidence(): boolean {
    return this.confidence >= 0.8;
  }

  shouldNotify(): boolean {
    return (
      !this.isAcknowledged &&
      !this.isExpired() &&
      this.requiresImmediateAttention()
    );
  }
}
