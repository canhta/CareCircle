import { HealthInsight } from '../entities/health-insight.entity';
import {
  InsightType,
  InsightSeverity,
} from '../value-objects/insight.value-objects';

export abstract class HealthInsightRepository {
  abstract create(insight: HealthInsight): Promise<HealthInsight>;
  abstract findById(id: string): Promise<HealthInsight | null>;
  abstract findByUserId(
    userId: string,
    type?: InsightType,
  ): Promise<HealthInsight[]>;
  abstract update(
    id: string,
    updates: Partial<HealthInsight>,
  ): Promise<HealthInsight>;
  abstract delete(id: string): Promise<void>;

  // Insight queries
  abstract findUnacknowledged(userId: string): Promise<HealthInsight[]>;
  abstract findBySeverity(
    userId: string,
    severity: InsightSeverity,
  ): Promise<HealthInsight[]>;
  abstract findExpiring(
    userId: string,
    daysUntilExpiry: number,
  ): Promise<HealthInsight[]>;
  abstract findByMetric(
    userId: string,
    metric: string,
  ): Promise<HealthInsight[]>;

  // Insight statistics
  abstract getInsightCount(userId: string): Promise<number>;
  abstract getAcknowledgedCount(userId: string): Promise<number>;
  abstract getCriticalInsightCount(userId: string): Promise<number>;
}
