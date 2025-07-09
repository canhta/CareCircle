export interface MessageMetadata {
  processingTime: number;
  confidence: number;
  tokensUsed: number;
  modelVersion: string;
  flagged: boolean;
  flagReason?: string;
  [key: string]: any; // Add index signature for JSON compatibility
}

export enum QueryIntent {
  GENERAL_QUESTION = 'general_question',
  SYMPTOM_INQUIRY = 'symptom_inquiry',
  MEDICATION_QUESTION = 'medication_question',
  DATA_REQUEST = 'data_request',
  ACTION_REQUEST = 'action_request',
  CLARIFICATION = 'clarification',
  EMERGENCY = 'emergency',
  SMALL_TALK = 'small_talk',
}

export interface Entity {
  type: 'medication' | 'symptom' | 'condition' | 'metric' | 'time' | 'person';
  value: string;
  startPosition: number;
  endPosition: number;
  confidence: number;
}
