/**
 * Healthcare Data Type Definitions
 *
 * Defines TypeScript interfaces for JSON fields in healthcare data models.
 * These types ensure type safety while maintaining flexibility for healthcare data.
 */

/**
 * Health Summary structure for CareRecipient
 * Stores medical conditions, allergies, medications, and health notes
 * Compatible with Prisma JsonValue type
 */
export interface HealthSummary {
  /** List of medical conditions/diagnoses */
  medicalConditions: string[];

  /** List of known allergies */
  allergies: string[];

  /** List of current medications */
  medications: string[];

  /** Additional health notes */
  notes?: string;

  /** Last updated timestamp */
  lastUpdated?: string;

  /** Healthcare provider information */
  primaryProvider?: {
    name: string;
    contact: string;
    specialty?: string;
  };

  /** Index signature for Prisma JsonValue compatibility */
  [key: string]: any;
}

/**
 * Care Preferences structure for CareRecipient
 * Stores emergency contacts, care preferences, and communication settings
 * Compatible with Prisma JsonValue type
 */
export interface CarePreferences {
  /** Emergency contact information */
  emergencyContacts: Array<{
    id?: string;
    name: string;
    phone: string;
    email?: string;
    relationship: string;
    isPrimary?: boolean;
    notes?: string;
  }>;

  /** Care-related preferences */
  careSettings: {
    /** Preferred communication method */
    communicationMethod?: 'phone' | 'email' | 'text' | 'app';

    /** Medication reminder preferences */
    medicationReminders?: boolean;

    /** Appointment reminder preferences */
    appointmentReminders?: boolean;

    /** Emergency notification preferences */
    emergencyNotifications?: boolean;
  };

  /** Index signature for Prisma JsonValue compatibility */
  [key: string]: any;

  /** Accessibility requirements */
  accessibility?: {
    /** Visual impairments */
    visualAid?: boolean;

    /** Hearing impairments */
    hearingAid?: boolean;

    /** Mobility assistance */
    mobilityAid?: boolean;

    /** Language preferences */
    preferredLanguage?: string;

    /** Other accessibility notes */
    notes?: string;
  };

  /** Dietary restrictions and preferences */
  dietary?: {
    restrictions: string[];
    preferences: string[];
    notes?: string;
  };

  /** Additional care preferences */
  other?: Record<string, any>;
}

/**
 * Activity metadata structure for CareActivity
 * Stores additional context and data for care activities
 */
export interface ActivityMetadata {
  /** Activity-specific data */
  data?: Record<string, any>;

  /** Related entities */
  relatedEntities?: {
    taskId?: string;
    recipientId?: string;
    memberId?: string;
  };

  /** System information */
  system?: {
    source: string;
    version?: string;
    automated?: boolean;
  };

  /** User interaction data */
  interaction?: {
    duration?: number;
    location?: string;
    device?: string;
  };
}

/**
 * Task metadata structure for CareTask
 * Stores task-specific configuration and tracking data
 */
export interface TaskMetadata {
  /** Recurrence configuration */
  recurrence?: {
    pattern: 'daily' | 'weekly' | 'monthly' | 'custom';
    interval?: number;
    daysOfWeek?: number[];
    endDate?: string;
    maxOccurrences?: number;
  };

  /** Reminder settings */
  reminders?: Array<{
    type: 'email' | 'push' | 'sms';
    minutesBefore: number;
    enabled: boolean;
  }>;

  /** Completion tracking */
  completion?: {
    requiresPhoto?: boolean;
    requiresNotes?: boolean;
    requiresLocation?: boolean;
    customFields?: Array<{
      name: string;
      type: 'text' | 'number' | 'boolean' | 'select';
      required: boolean;
      options?: string[];
    }>;
  };

  /** Integration data */
  integrations?: {
    calendarEventId?: string;
    externalTaskId?: string;
    syncedSystems?: string[];
  };

  /** Additional task data */
  custom?: Record<string, any>;
}

/**
 * Care Group settings structure
 * Stores group-level configuration and preferences
 */
export interface CareGroupSettings {
  /** Notification settings */
  notifications: {
    /** Task notifications */
    taskReminders: boolean;
    taskCompletions: boolean;
    taskOverdue: boolean;

    /** Member notifications */
    memberJoined: boolean;
    memberLeft: boolean;

    /** Activity notifications */
    activityUpdates: boolean;
    emergencyAlerts: boolean;
  };

  /** Privacy settings */
  privacy: {
    /** Who can view health data */
    healthDataVisibility: 'admin' | 'caregivers' | 'all';

    /** Who can invite members */
    invitePermissions: 'admin' | 'caregivers' | 'all';

    /** Activity visibility */
    activityVisibility: 'admin' | 'caregivers' | 'all';
  };

  /** Integration settings */
  integrations?: {
    calendar?: {
      enabled: boolean;
      provider?: 'google' | 'outlook' | 'apple';
      syncTasks?: boolean;
    };

    healthApps?: {
      enabled: boolean;
      connectedApps?: string[];
    };
  };

  /** Custom group settings */
  custom?: Record<string, any>;
}

/**
 * Type guards for runtime type checking
 */
export const isHealthSummary = (obj: any): obj is HealthSummary => {
  return (
    obj &&
    Array.isArray(obj.medicalConditions) &&
    Array.isArray(obj.allergies) &&
    Array.isArray(obj.medications)
  );
};

export const isCarePreferences = (obj: any): obj is CarePreferences => {
  return (
    obj &&
    Array.isArray(obj.emergencyContacts) &&
    typeof obj.careSettings === 'object'
  );
};

/**
 * Default values for healthcare data structures
 */
export const defaultHealthSummary = (): HealthSummary => ({
  medicalConditions: [],
  allergies: [],
  medications: [],
  lastUpdated: new Date().toISOString(),
});

export const defaultCarePreferences = (): CarePreferences => ({
  emergencyContacts: [],
  careSettings: {
    communicationMethod: 'app',
    medicationReminders: true,
    appointmentReminders: true,
    emergencyNotifications: true,
  },
});

export const defaultCareGroupSettings = (): CareGroupSettings => ({
  notifications: {
    taskReminders: true,
    taskCompletions: true,
    taskOverdue: true,
    memberJoined: true,
    memberLeft: true,
    activityUpdates: true,
    emergencyAlerts: true,
  },
  privacy: {
    healthDataVisibility: 'caregivers',
    invitePermissions: 'caregivers',
    activityVisibility: 'all',
  },
});
