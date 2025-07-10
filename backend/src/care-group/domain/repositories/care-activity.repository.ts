import { CareActivityEntity } from '../entities/care-activity.entity';
import { ActivityType } from '@prisma/client';

export interface ActivityQuery {
  groupId?: string;
  userId?: string;
  type?: ActivityType;
  relatedTaskId?: string;
  relatedRecipientId?: string;
  startDate?: Date;
  endDate?: Date;
  limit?: number;
  offset?: number;
}

export abstract class CareActivityRepository {
  abstract create(activity: CareActivityEntity): Promise<CareActivityEntity>;
  abstract findById(id: string): Promise<CareActivityEntity | null>;
  abstract findMany(query: ActivityQuery): Promise<CareActivityEntity[]>;
  abstract findByGroupId(groupId: string): Promise<CareActivityEntity[]>;
  abstract findByUserId(userId: string): Promise<CareActivityEntity[]>;
  abstract delete(id: string): Promise<void>;

  // Activity type operations
  abstract findByType(
    groupId: string,
    type: ActivityType,
  ): Promise<CareActivityEntity[]>;
  abstract findTaskActivities(groupId: string): Promise<CareActivityEntity[]>;
  abstract findMemberActivities(groupId: string): Promise<CareActivityEntity[]>;
  abstract findRecipientActivities(
    groupId: string,
  ): Promise<CareActivityEntity[]>;
  abstract findSystemActivities(groupId: string): Promise<CareActivityEntity[]>;

  // Time-based operations
  abstract findRecentActivities(
    groupId: string,
    hoursThreshold: number,
  ): Promise<CareActivityEntity[]>;
  abstract findActivitiesInDateRange(
    groupId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<CareActivityEntity[]>;
  abstract findTodaysActivities(groupId: string): Promise<CareActivityEntity[]>;
  abstract findThisWeeksActivities(
    groupId: string,
  ): Promise<CareActivityEntity[]>;

  // Related entity operations
  abstract findByTaskId(taskId: string): Promise<CareActivityEntity[]>;
  abstract findByRecipientId(
    recipientId: string,
  ): Promise<CareActivityEntity[]>;
  abstract findTaskCompletionActivities(
    groupId: string,
  ): Promise<CareActivityEntity[]>;
  abstract findTaskAssignmentActivities(
    groupId: string,
  ): Promise<CareActivityEntity[]>;

  // User activity operations
  abstract findUserActivitiesInGroup(
    groupId: string,
    userId: string,
  ): Promise<CareActivityEntity[]>;
  abstract findMostActiveUsers(
    groupId: string,
    limit: number,
  ): Promise<Array<{
    userId: string;
    activityCount: number;
    lastActivityAt: Date;
  }>>;

  // Search operations
  abstract searchActivities(
    groupId: string,
    searchTerm: string,
  ): Promise<CareActivityEntity[]>;

  // Count operations
  abstract getActivityCount(groupId: string): Promise<number>;
  abstract getActivityCountByType(
    groupId: string,
    type: ActivityType,
  ): Promise<number>;
  abstract getActivityCountByUser(
    groupId: string,
    userId: string,
  ): Promise<number>;
  abstract getRecentActivityCount(
    groupId: string,
    hoursThreshold: number,
  ): Promise<number>;

  // Analytics operations
  abstract getActivityStatistics(
    groupId: string,
  ): Promise<{
    totalActivities: number;
    taskActivities: number;
    memberActivities: number;
    recipientActivities: number;
    systemActivities: number;
    recentActivities: number;
  }>;
  abstract getActivityTrends(
    groupId: string,
    days: number,
  ): Promise<Array<{
    date: Date;
    activityCount: number;
    uniqueUsers: number;
    taskActivities: number;
    memberActivities: number;
  }>>;
  abstract getUserActivitySummary(
    groupId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<Array<{
    userId: string;
    activityCount: number;
    lastActivityAt: Date;
    activityTypes: Array<{
      type: ActivityType;
      count: number;
    }>;
  }>>;

  // Cleanup operations
  abstract deleteOldActivities(
    groupId: string,
    olderThanDays: number,
  ): Promise<number>;
  abstract deleteActivitiesByType(
    groupId: string,
    type: ActivityType,
  ): Promise<number>;

  // Bulk operations
  abstract createBulkActivities(
    activities: CareActivityEntity[],
  ): Promise<CareActivityEntity[]>;
}
