# Care Group Context (CGC)

## Module Overview

The Care Group Context is responsible for managing family care coordination, shared caregiving responsibilities, and group-based health management. This context enables multiple users to collaborate on the care of family members, with appropriate permissions and role-based access to health information.

### Responsibilities

- Care group creation and management
- Member roles and permission management
- Care task assignment and tracking
- Shared health data access controls
- Care activity logging
- Collaborative decision making
- Caregiver coordination
- Family calendar management
- Care insights and recommendations

### Role in Overall Architecture

The Care Group Context serves as the social and collaborative layer of the CareCircle platform, connecting the Identity & Access Context with the Health Data Context and Medication Context. It enables families and care networks to work together effectively in managing health needs, especially for elder care and chronic condition management. This context ensures that the right people have the right level of access and responsibility in providing care.

## Technical Specification

### Key Data Models and Interfaces

#### Domain Entities

1. **CareGroup**

   ```typescript
   interface CareGroup {
     id: string;
     name: string;
     description?: string;
     createdBy: string;
     createdAt: Date;
     updatedAt: Date;
     members: CareGroupMember[];
     careRecipients: CareRecipient[];
     isActive: boolean;
     settings: CareGroupSettings;
     inviteCode?: string;
     inviteExpiration?: Date;
   }
   ```

2. **CareGroupMember**

   ```typescript
   interface CareGroupMember {
     id: string;
     groupId: string;
     userId: string;
     role: MemberRole;
     permissions: Permission[];
     joinedAt: Date;
     invitedBy?: string;
     isActive: boolean;
     customTitle?: string;
     notificationPreferences: MemberNotificationPreferences;
     lastActive?: Date;
   }
   ```

3. **CareRecipient**

   ```typescript
   interface CareRecipient {
     id: string;
     groupId: string;
     userId: string;
     displayName: string;
     relationship?: string;
     primaryCaregiverId?: string;
     healthDataSharingLevel: SharingLevel;
     medicationSharingLevel: SharingLevel;
     emergencyContactIds: string[];
     notes?: string;
     createdAt: Date;
     updatedAt: Date;
   }
   ```

4. **CareTask**

   ```typescript
   interface CareTask {
     id: string;
     groupId: string;
     title: string;
     description?: string;
     category: TaskCategory;
     priority: TaskPriority;
     status: TaskStatus;
     assigneeId?: string;
     assignerId: string;
     recipientId: string;
     dueDate?: Date;
     completedAt?: Date;
     completedBy?: string;
     recurrence?: TaskRecurrence;
     reminderSettings?: TaskReminderSettings;
     notes?: string;
     attachments?: TaskAttachment[];
     createdAt: Date;
     updatedAt: Date;
   }
   ```

5. **CareActivity**
   ```typescript
   interface CareActivity {
     id: string;
     groupId: string;
     actorId: string;
     recipientId: string;
     activityType: ActivityType;
     description: string;
     timestamp: Date;
     relatedTaskId?: string;
     relatedMedicationId?: string;
     relatedHealthDataId?: string;
     metadata?: Record<string, any>;
     isPrivate: boolean;
   }
   ```

#### Value Objects

```typescript
enum MemberRole {
  ADMIN = "admin",
  CAREGIVER = "caregiver",
  OBSERVER = "observer",
  CARE_RECIPIENT = "care_recipient",
  MEDICAL_PROFESSIONAL = "medical_professional",
}

enum Permission {
  VIEW_HEALTH_DATA = "view_health_data",
  MANAGE_HEALTH_DATA = "manage_health_data",
  VIEW_MEDICATIONS = "view_medications",
  MANAGE_MEDICATIONS = "manage_medications",
  VIEW_TASKS = "view_tasks",
  MANAGE_TASKS = "manage_tasks",
  INVITE_MEMBERS = "invite_members",
  REMOVE_MEMBERS = "remove_members",
  MANAGE_GROUP = "manage_group",
  VIEW_CALENDAR = "view_calendar",
  MANAGE_CALENDAR = "manage_calendar",
  EMERGENCY_ACCESS = "emergency_access",
}

enum SharingLevel {
  NONE = "none",
  LIMITED = "limited",
  STANDARD = "standard",
  FULL = "full",
  EMERGENCY_ONLY = "emergency_only",
}

enum TaskCategory {
  MEDICATION = "medication",
  HEALTH_CHECK = "health_check",
  APPOINTMENT = "appointment",
  GENERAL = "general",
  EXERCISE = "exercise",
  NUTRITION = "nutrition",
  HYGIENE = "hygiene",
  SOCIAL = "social",
}

enum TaskPriority {
  LOW = "low",
  MEDIUM = "medium",
  HIGH = "high",
  URGENT = "urgent",
}

enum TaskStatus {
  PENDING = "pending",
  IN_PROGRESS = "in_progress",
  COMPLETED = "completed",
  MISSED = "missed",
  CANCELLED = "cancelled",
  RESCHEDULED = "rescheduled",
}

enum ActivityType {
  TASK_ASSIGNED = "task_assigned",
  TASK_COMPLETED = "task_completed",
  TASK_MISSED = "task_missed",
  MEDICATION_TAKEN = "medication_taken",
  MEDICATION_MISSED = "medication_missed",
  HEALTH_DATA_RECORDED = "health_data_recorded",
  HEALTH_ANOMALY = "health_anomaly",
  MEMBER_JOINED = "member_joined",
  MEMBER_LEFT = "member_left",
  ROLE_CHANGED = "role_changed",
  GROUP_UPDATED = "group_updated",
  EMERGENCY_TRIGGERED = "emergency_triggered",
}

interface CareGroupSettings {
  allowMemberInvites: boolean;
  requireAdminApproval: boolean;
  showMemberActivity: boolean;
  enableGroupChat: boolean;
  defaultTaskReminderTime: number; // minutes before due
  defaultSharingLevel: SharingLevel;
  defaultTaskAssignee?: string;
  timezone: string;
}

interface MemberNotificationPreferences {
  taskAssigned: boolean;
  taskCompleted: boolean;
  taskOverdue: boolean;
  medicationMissed: boolean;
  healthAnomalies: boolean;
  membershipChanges: boolean;
  dailyDigest: boolean;
  emergencyAlerts: boolean;
}

interface TaskRecurrence {
  frequency: "daily" | "weekly" | "monthly";
  interval: number;
  daysOfWeek?: number[]; // 0-6, 0 is Sunday
  daysOfMonth?: number[]; // 1-31
  endAfterOccurrences?: number;
  endDate?: Date;
}

interface TaskReminderSettings {
  reminderTimes: number[]; // minutes before due
  assigneeReminder: boolean;
  recipientReminder: boolean;
  escalateAfter?: number; // minutes after due
  escalateTo?: string; // userId
}

interface TaskAttachment {
  id: string;
  fileName: string;
  fileType: string;
  fileUrl: string;
  uploadedBy: string;
  uploadedAt: Date;
  size: number;
}
```

### Key APIs

#### Care Group Management API

```typescript
interface CareGroupService {
  // Group management
  createCareGroup(
    creatorId: string,
    group: Omit<
      CareGroup,
      | "id"
      | "createdBy"
      | "createdAt"
      | "updatedAt"
      | "members"
      | "careRecipients"
    >
  ): Promise<CareGroup>;
  getCareGroup(groupId: string): Promise<CareGroup>;
  updateCareGroup(
    groupId: string,
    updates: Partial<CareGroup>
  ): Promise<CareGroup>;
  deleteCareGroup(groupId: string): Promise<void>;
  getUserCareGroups(userId: string): Promise<CareGroup[]>;

  // Member management
  addMember(
    groupId: string,
    userId: string,
    role: MemberRole,
    addedById: string
  ): Promise<CareGroupMember>;
  updateMemberRole(
    groupId: string,
    memberId: string,
    newRole: MemberRole,
    updatedById: string
  ): Promise<CareGroupMember>;
  updateMemberPermissions(
    groupId: string,
    memberId: string,
    permissions: Permission[],
    updatedById: string
  ): Promise<CareGroupMember>;
  removeMember(
    groupId: string,
    memberId: string,
    removedById: string
  ): Promise<void>;

  // Invitation management
  generateInviteCode(
    groupId: string,
    expirationHours?: number
  ): Promise<string>;
  invalidateInviteCode(groupId: string): Promise<void>;
  joinWithInviteCode(
    userId: string,
    inviteCode: string
  ): Promise<CareGroupMember>;
  inviteByEmail(
    groupId: string,
    email: string,
    role: MemberRole,
    inviterId: string
  ): Promise<void>;
}
```

#### Care Recipient API

```typescript
interface CareRecipientService {
  // Recipient management
  addCareRecipient(
    groupId: string,
    recipient: Omit<CareRecipient, "id" | "groupId" | "createdAt" | "updatedAt">
  ): Promise<CareRecipient>;
  getCareRecipient(recipientId: string): Promise<CareRecipient>;
  updateCareRecipient(
    recipientId: string,
    updates: Partial<CareRecipient>
  ): Promise<CareRecipient>;
  removeCareRecipient(recipientId: string): Promise<void>;
  getGroupRecipients(groupId: string): Promise<CareRecipient[]>;

  // Access management
  updateHealthDataSharingLevel(
    recipientId: string,
    sharingLevel: SharingLevel
  ): Promise<CareRecipient>;
  updateMedicationSharingLevel(
    recipientId: string,
    sharingLevel: SharingLevel
  ): Promise<CareRecipient>;
  assignPrimaryCaregiver(
    recipientId: string,
    caregiverId: string
  ): Promise<CareRecipient>;
  updateEmergencyContacts(
    recipientId: string,
    contactIds: string[]
  ): Promise<CareRecipient>;

  // Data access
  getSharedHealthData(
    recipientId: string,
    requesterId: string
  ): Promise<SharedHealthData>;
  getSharedMedications(
    recipientId: string,
    requesterId: string
  ): Promise<SharedMedication[]>;
}
```

#### Task Management API

```typescript
interface TaskService {
  // Task management
  createTask(
    task: Omit<CareTask, "id" | "createdAt" | "updatedAt">
  ): Promise<CareTask>;
  getTask(taskId: string): Promise<CareTask>;
  updateTask(taskId: string, updates: Partial<CareTask>): Promise<CareTask>;
  deleteTask(taskId: string): Promise<void>;

  // Task queries
  getGroupTasks(groupId: string, filters?: TaskFilters): Promise<CareTask[]>;
  getUserAssignedTasks(
    userId: string,
    status?: TaskStatus
  ): Promise<CareTask[]>;
  getRecipientTasks(
    recipientId: string,
    status?: TaskStatus
  ): Promise<CareTask[]>;

  // Task actions
  assignTask(
    taskId: string,
    assigneeId: string,
    assignerId: string
  ): Promise<CareTask>;
  completeTask(
    taskId: string,
    completedById: string,
    notes?: string
  ): Promise<CareTask>;
  cancelTask(
    taskId: string,
    cancelledById: string,
    reason?: string
  ): Promise<CareTask>;
  rescheduleTask(
    taskId: string,
    newDueDate: Date,
    rescheduledById: string
  ): Promise<CareTask>;

  // Recurrence handling
  createRecurringTask(
    task: Omit<CareTask, "id" | "createdAt" | "updatedAt">,
    recurrence: TaskRecurrence
  ): Promise<CareTask>;
  generateRecurringInstances(
    parentTaskId: string,
    startDate: Date,
    endDate: Date
  ): Promise<CareTask[]>;
}
```

#### Care Activity API

```typescript
interface CareActivityService {
  // Activity logging
  logActivity(
    activity: Omit<CareActivity, "id" | "timestamp">
  ): Promise<CareActivity>;
  getGroupActivities(
    groupId: string,
    startDate: Date,
    endDate: Date
  ): Promise<CareActivity[]>;
  getRecipientActivities(
    recipientId: string,
    startDate: Date,
    endDate: Date
  ): Promise<CareActivity[]>;
  getUserActivities(
    userId: string,
    startDate: Date,
    endDate: Date
  ): Promise<CareActivity[]>;

  // Activity analysis
  getActivitySummary(
    groupId: string,
    period: "day" | "week" | "month"
  ): Promise<ActivitySummary>;
  getCaregiversPerformance(
    groupId: string,
    startDate: Date,
    endDate: Date
  ): Promise<CaregiverPerformance[]>;
  detectActivityPatterns(recipientId: string): Promise<ActivityPattern[]>;

  // Calendar integration
  getGroupCalendar(
    groupId: string,
    startDate: Date,
    endDate: Date
  ): Promise<CalendarEvent[]>;
  exportCalendarEvents(
    groupId: string,
    format: "ical" | "google"
  ): Promise<string>;
}
```

#### Care Insights API

```typescript
interface CareInsightService {
  // Insights generation
  generateCareInsights(groupId: string): Promise<CareInsight[]>;
  getGroupInsights(groupId: string): Promise<CareInsight[]>;
  getRecipientInsights(recipientId: string): Promise<CareInsight[]>;

  // Care recommendations
  generateCareRecommendations(
    recipientId: string
  ): Promise<CareRecommendation[]>;
  getTaskRecommendations(recipientId: string): Promise<TaskRecommendation[]>;
  getWorkloadDistributionSuggestions(
    groupId: string
  ): Promise<WorkloadSuggestion[]>;

  // Group analytics
  analyzeGroupEffectiveness(groupId: string): Promise<GroupEffectivenessReport>;
  identifyCareGaps(recipientId: string): Promise<CareGap[]>;
  predictCareNeeds(
    recipientId: string,
    timeframe: "week" | "month"
  ): Promise<CarePrediction[]>;
}
```

### Dependencies and Interactions

- **Identity & Access Context**: For user authentication and base permission management
- **Health Data Context**: For access to and sharing of health metrics
- **Medication Context**: For medication task coordination and adherence tracking
- **Notification Context**: For task reminders and group activity updates
- **AI Assistant Context**: For care insights and recommendations
- **Emergency Context**: For critical alerts and emergency contact notification
- **Firebase Firestore**: For real-time group activity updates
- **Google Calendar API**: For calendar integration and event synchronization

### Backend Implementation Notes

1. **Permission Management System**

   - Implement a role-based access control system with custom permissions
   - Create permission inheritance hierarchies for cascading access
   - Develop fine-grained sharing controls for health data
   - Build an audit system for permission changes

2. **Task Management Engine**

   - Create a flexible task scheduling system with recurrence support
   - Implement assignment algorithms for task distribution
   - Develop escalation rules for missed or overdue tasks
   - Build dependencies between tasks for sequential workflows

3. **Activity Tracking**

   - Implement a comprehensive activity logging system
   - Create real-time activity feed with filtering
   - Develop privacy controls for sensitive activities
   - Build analytics capabilities for activity patterns

4. **Group Calendar Management**

   - Create a shared calendar system with task integration
   - Implement calendar synchronization with external calendars
   - Develop conflict detection for overlapping responsibilities
   - Build reminder generation based on calendar events

5. **Care Insights System**
   - Implement algorithms for identifying care patterns
   - Create workload analysis for balanced distribution
   - Develop predictive models for care needs
   - Build recommendation engine for task optimization

### Mobile Implementation Notes

1. **Group Management UI**

   - Design intuitive group creation and management flows
   - Create member invitation and management screens
   - Implement role and permission management interfaces
   - Develop care recipient profiles with sharing controls

2. **Task Coordination UI**

   - Create task lists with filtering and sorting
   - Implement task assignment interface with member selection
   - Develop recurring task creation with visual scheduling
   - Build task completion flow with optional notes and photos

3. **Activity Feed**

   - Design a chronological activity feed with categorization
   - Implement real-time updates using Firebase
   - Create activity detail views with related information
   - Develop filtering and search capabilities

4. **Shared Calendar**
   - Build an interactive calendar view with color-coded events
   - Implement day, week, and month views
   - Create event creation and editing interfaces
   - Develop synchronization with device calendars

## Implementation Tasks

### Backend Implementation Requirements

1. Design care group domain model and database schema
2. Implement role-based access control system for groups
3. Create invitation system with secure tokens
4. Build task management service with recurrence
5. Develop activity logging system with privacy controls
6. Implement shared calendar functionality
7. Create notification rules for group events
8. Build health data sharing with consent management
9. Develop real-time updates for group activities
10. Implement care insights generation algorithms
11. Create task assignment and tracking service
12. Build workload analysis and optimization
13. Develop task escalation protocols
14. Implement calendar synchronization with external services
15. Create API endpoints for all group functionality

### Mobile Implementation Requirements

1. Design and implement group management screens
2. Create member invitation workflow
3. Implement role and permission management interface
4. Build care recipient profile screens
5. Create task creation and assignment UI
6. Implement task list views with filters
7. Develop recurring task setup interface
8. Create shared calendar view
9. Build activity feed with real-time updates
10. Implement task completion workflow
11. Create caregiver switching interface
12. Develop workload visualization
13. Build care insight displays
14. Implement task notification responses
15. Create data sharing permission controls

## References

### Libraries and Services

- **Firebase Firestore**: Real-time database for group activities

  - Documentation: [Firebase Firestore](https://firebase.google.com/docs/firestore)
  - Features: Real-time updates, offline support, security rules

- **NestJS CASL**: Authorization library for NestJS

  - Package: [@casl/ability](https://www.npmjs.com/package/@casl/ability)
  - Features: Fine-grained permissions, role-based access control

- **Google Calendar API**: Calendar integration for task scheduling

  - Documentation: [Google Calendar API](https://developers.google.com/calendar)
  - Features: Event creation, calendar sharing, reminders

- **flutter_calendar_view**: Calendar widgets for Flutter

  - Package: [flutter_calendar_view](https://pub.dev/packages/flutter_calendar_view)
  - Features: Day, week, month views, event handling

- **Rrule.js**: Library for recurring date calculation

  - Package: [rrule](https://www.npmjs.com/package/rrule)
  - Features: iCalendar RFC-compliant recurrence rules

- **Firestore Pagination**: Efficient data loading for activity feeds
  - Package: [firebase_pagination](https://pub.dev/packages/firebase_pagination)
  - Features: Infinite scrolling, cursor-based pagination

### Standards and Best Practices

- **Role-Based Access Control (RBAC)**

  - Documentation: [RBAC Design Patterns](https://auth0.com/docs/authorization/rbac)
  - Features: Permission hierarchies, role inheritance

- **iCalendar Standard (RFC 5545)**

  - Standard for calendar data exchange
  - Support for recurring events and reminders

- **HL7 FHIR Care Plan Resource**
  - Standard for healthcare care plan representation
  - Documentation: [FHIR Care Plan](https://www.hl7.org/fhir/careplan.html)
