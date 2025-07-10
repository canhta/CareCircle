import { CareGroupEntity } from '../entities/care-group.entity';
import { CareGroupType } from '@prisma/client';

export interface CareGroupQuery {
  userId: string;
  type?: CareGroupType;
  isActive?: boolean;
  limit?: number;
  offset?: number;
}

export abstract class CareGroupRepository {
  abstract create(careGroup: CareGroupEntity): Promise<CareGroupEntity>;
  abstract findById(id: string): Promise<CareGroupEntity | null>;
  abstract findMany(query: CareGroupQuery): Promise<CareGroupEntity[]>;
  abstract findByUserId(userId: string): Promise<CareGroupEntity[]>;
  abstract findByCreatedBy(createdBy: string): Promise<CareGroupEntity[]>;
  abstract update(
    id: string,
    updates: Partial<CareGroupEntity>,
  ): Promise<CareGroupEntity>;
  abstract delete(id: string): Promise<void>;

  // Care group specific operations
  abstract findByMemberId(memberId: string): Promise<CareGroupEntity[]>;
  abstract findActiveGroups(userId: string): Promise<CareGroupEntity[]>;
  abstract findInactiveGroups(userId: string): Promise<CareGroupEntity[]>;
  abstract findByType(
    userId: string,
    type: CareGroupType,
  ): Promise<CareGroupEntity[]>;

  // Group management operations
  abstract activateGroup(id: string): Promise<CareGroupEntity>;
  abstract deactivateGroup(id: string): Promise<CareGroupEntity>;
  abstract updateSettings(
    id: string,
    settings: Record<string, any>,
  ): Promise<CareGroupEntity>;
  abstract updateEmergencyContact(
    id: string,
    emergencyContact: Record<string, any>,
  ): Promise<CareGroupEntity>;

  // Search operations
  abstract searchByName(
    userId: string,
    searchTerm: string,
  ): Promise<CareGroupEntity[]>;
  abstract findGroupsWithRecentActivity(
    userId: string,
    hoursThreshold: number,
  ): Promise<CareGroupEntity[]>;

  // Count operations
  abstract getGroupCount(userId: string): Promise<number>;
  abstract getActiveGroupCount(userId: string): Promise<number>;
  abstract getGroupCountByType(
    userId: string,
    type: CareGroupType,
  ): Promise<number>;

  // Validation operations
  abstract checkGroupExists(id: string): Promise<boolean>;
  abstract checkUserHasAccess(groupId: string, userId: string): Promise<boolean>;
  abstract checkGroupCapacity(
    groupId: string,
    maxMembers: number,
  ): Promise<boolean>;

  // Analytics operations
  abstract getGroupStatistics(
    groupId: string,
  ): Promise<{
    memberCount: number;
    taskCount: number;
    completedTaskCount: number;
    activityCount: number;
    recipientCount: number;
  }>;
  abstract getGroupsCreatedInPeriod(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<CareGroupEntity[]>;
}
