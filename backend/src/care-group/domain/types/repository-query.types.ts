/**
 * Repository Query Types
 * Centralized type definitions for repository query parameters
 * Following DDD patterns and eliminating type duplication
 */

import {
  ActivityType,
  TaskStatus,
  TaskPriority,
  TaskCategory,
  MemberRole,
} from '@prisma/client';

/**
 * Base query interface for pagination and filtering
 */
export interface BaseQuery {
  limit?: number;
  offset?: number;
}

/**
 * Date range query interface
 */
export interface DateRangeQuery {
  fromDate?: Date;
  toDate?: Date;
}

/**
 * Care Activity Query Types
 */
export interface CareActivityQuery extends BaseQuery, DateRangeQuery {
  groupId?: string;
  memberId?: string;
  activityType?: ActivityType;
}

export interface CareActivityFilters {
  activityType?: ActivityType;
  memberId?: string;
  fromDate?: Date;
  toDate?: Date;
  limit?: number;
}

/**
 * Care Task Query Types
 */
export interface CareTaskQuery extends BaseQuery {
  groupId?: string;
  assigneeId?: string;
  recipientId?: string;
  createdById?: string;
  status?: TaskStatus;
  priority?: TaskPriority;
  category?: TaskCategory;
  dueDateFrom?: Date;
  dueDateTo?: Date;
}

export interface CareTaskFilters {
  status?: TaskStatus;
  priority?: TaskPriority;
  category?: TaskCategory;
  assigneeId?: string;
  recipientId?: string;
  dueDateFrom?: Date;
  dueDateTo?: Date;
  limit?: number;
}

/**
 * Care Group Member Query Types
 */
export interface CareGroupMemberQuery extends BaseQuery {
  groupId?: string;
  userId?: string;
  role?: MemberRole;
  isActive?: boolean;
}

export interface CareGroupMemberFilters {
  role?: MemberRole;
  isActive?: boolean;
  permission?: string;
  limit?: number;
}

/**
 * Care Group Query Types
 */
export interface CareGroupQuery extends BaseQuery {
  userId?: string;
  isActive?: boolean;
}

export interface CareGroupFilters {
  isActive?: boolean;
  createdBy?: string;
  limit?: number;
}

/**
 * Care Recipient Query Types
 */
export interface CareRecipientQuery extends BaseQuery {
  groupId?: string;
  hasConditions?: boolean;
  hasAllergies?: boolean;
  isActive?: boolean;
}

export interface CareRecipientFilters {
  hasConditions?: boolean;
  hasAllergies?: boolean;
  isActive?: boolean;
  ageRange?: {
    min?: number;
    max?: number;
  };
  limit?: number;
}

/**
 * Update interfaces for entities
 */
export interface CareTaskUpdateData {
  title?: string;
  description?: string;
  category?: TaskCategory;
  priority?: TaskPriority;
  status?: TaskStatus;
  dueDate?: Date;
  completedAt?: Date | null;
  assigneeId?: string;
  recipientId?: string;
  recurrence?: Record<string, unknown>;
  metadata?: Record<string, unknown>;
}

export interface CareGroupMemberUpdateData {
  role?: MemberRole;
  customTitle?: string;
  isActive?: boolean;
  permissions?: string[];
  notificationPreferences?: Record<string, unknown>;
}

export interface CareGroupUpdateData {
  name?: string;
  description?: string;
  isActive?: boolean;
  settings?: Record<string, unknown>;
}

export interface CareRecipientUpdateData {
  name?: string;
  dateOfBirth?: Date;
  relationship?: string;
  isActive?: boolean;
  healthSummary?: Record<string, unknown>;
  carePreferences?: Record<string, unknown>;
  medicalConditions?: string[];
  allergies?: string[];
  medications?: string[];
  emergencyContacts?: Array<Record<string, unknown>>;
}

/**
 * Statistics and Analytics Types
 */
export interface ActivityStatistics {
  totalActivities: number;
  taskActivities: number;
  memberActivities: number;
  recipientActivities: number;
  systemActivities: number;
  recentActivities: number;
}

export interface TaskStatistics {
  totalTasks: number;
  pendingTasks: number;
  inProgressTasks: number;
  completedTasks: number;
  cancelledTasks: number;
  overdueTasks: number;
  highPriorityTasks: number;
  unassignedTasks: number;
  recurringTasks: number;
}

export interface MemberStatistics {
  totalMembers: number;
  activeMembers: number;
  adminCount: number;
  caregiverCount: number;
  memberCount: number;
  viewerCount: number;
  averageJoinDuration: number;
}

export interface GroupStatistics {
  totalGroups: number;
  activeGroups: number;
  inactiveGroups: number;
  totalMembers: number;
  totalTasks: number;
  completedTasks: number;
}

/**
 * Performance and Analytics Types
 */
export interface TaskCompletionRate {
  totalTasks: number;
  completedTasks: number;
  completionRate: number;
}

export interface AssigneePerformance {
  assigneeId: string;
  assignedTasks: number;
  completedTasks: number;
  overdueTasks: number;
  completionRate: number;
  averageCompletionTime: number;
}

export interface TaskTrend {
  date: Date;
  createdTasks: number;
  completedTasks: number;
  overdueTasks: number;
}

export interface ActivityTrend {
  date: Date;
  activityCount: number;
  uniqueUsers: number;
  taskActivities: number;
  memberActivities: number;
}

export interface UserActivitySummary {
  userId: string;
  activityCount: number;
  lastActivityAt: Date;
  activityTypes: Array<{
    type: ActivityType;
    count: number;
  }>;
}

export interface MostActiveUser {
  userId: string;
  activityCount: number;
  lastActivityAt: Date;
}
