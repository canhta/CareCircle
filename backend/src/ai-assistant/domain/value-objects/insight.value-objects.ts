export enum InsightType {
  HEALTH_TREND = 'HEALTH_TREND',
  MEDICATION_ADHERENCE = 'MEDICATION_ADHERENCE',
  RISK_ASSESSMENT = 'RISK_ASSESSMENT',
  ANOMALY_DETECTION = 'ANOMALY_DETECTION',
  RECOMMENDATION = 'RECOMMENDATION',
  CORRELATION = 'CORRELATION',
  PREDICTION = 'PREDICTION',
}

export enum InsightSeverity {
  INFO = 'INFO',
  WARNING = 'WARNING',
  ALERT = 'ALERT',
  CRITICAL = 'CRITICAL',
}

export interface InsightPreferences {
  enabledTypes: InsightType[];
  minimumSeverity: InsightSeverity;
  frequency: 'daily' | 'weekly' | 'monthly';
  deliveryMethod: 'push' | 'email' | 'both';
  quietHours: {
    enabled: boolean;
    startTime: string; // HH:mm format
    endTime: string; // HH:mm format
  };
}
