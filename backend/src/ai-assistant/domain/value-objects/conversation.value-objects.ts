export interface ConversationMetadata {
  healthContextIncluded: boolean;
  medicationContextIncluded: boolean;
  userPreferences: {
    language: string;
    responseLength: 'concise' | 'detailed';
    technicalLevel: 'simple' | 'moderate' | 'technical';
  };
  aiModelUsed: string;
  tokensUsed: number;
  [key: string]: any; // Add index signature for JSON compatibility
}

export interface UserPreferences {
  language: string;
  responseLength: 'concise' | 'detailed';
  technicalLevel: 'simple' | 'moderate' | 'technical';
  [key: string]: any; // Add index signature for JSON compatibility
}
