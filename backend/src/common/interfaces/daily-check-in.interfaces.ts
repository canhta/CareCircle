/**
 * Interface for check-in insights matching the HealthInsight type
 */
export interface CheckInInsight {
  id: string;
  type: 'positive' | 'concern' | 'trend' | 'medication' | 'lifestyle';
  title: string;
  description: string;
  severity: 'low' | 'medium' | 'high';
  confidence: number; // 0-1
  supportingData: string[];
  relatedMetrics: string[];
  timeframe: string;
}

/**
 * Interface for check-in response array
 */
export interface CheckInResponse {
  questionId: string;
  questionText?: string;
  answer: string | number | boolean;
  category?: string;
  timestamp?: Date;
  notes?: string;
}

/**
 * Interface for weekly insights summary
 */
export interface WeeklyInsightsSummary {
  summary: string;
  keyInsights: CheckInInsight[];
  trends: string[];
  recommendations: string[];
}

/**
 * Interface for check-in insight entry
 */
export interface CheckInInsightEntry {
  date: string;
  insights: CheckInInsight[];
}

/**
 * Interface for notification response
 */
export interface NotificationResponseData {
  actionId: string;
  data?: Record<string, unknown>;
}
