import {
  CareActivity as PrismaCareActivity,
  ActivityType,
} from '@prisma/client';

/**
 * Care Activity Domain Entity
 *
 * Represents an activity or event within a care group for tracking member actions,
 * task updates, and other important events in the care coordination process.
 */
export class CareActivityEntity {
  constructor(
    public readonly id: string,
    public readonly groupId: string,
    public readonly memberId: string,
    public readonly activityType: ActivityType,
    public readonly description: string,
    public readonly data: Record<string, any>,
    public readonly timestamp: Date,
  ) {}

  /**
   * Create a new Care Activity entity data for database insertion
   */
  static create(data: {
    groupId: string;
    memberId: string;
    activityType: ActivityType;
    description: string;
    data?: Record<string, any>;
  }): {
    groupId: string;
    memberId: string;
    activityType: ActivityType;
    description: string;
    data: Record<string, any>;
  } {
    // Validate business rules
    this.validateDescription(data.description);
    this.validateActivityType(data.activityType);

    return {
      groupId: data.groupId,
      memberId: data.memberId,
      activityType: data.activityType,
      description: data.description.trim(),
      data: data.data || {},
    };
  }

  /**
   * Create entity from Prisma model
   */
  static fromPrisma(prisma: PrismaCareActivity): CareActivityEntity {
    return new CareActivityEntity(
      prisma.id,
      prisma.groupId,
      prisma.memberId,
      prisma.activityType,
      prisma.description,
      prisma.data as Record<string, any>,
      prisma.timestamp,
    );
  }

  /**
   * Convert to Prisma format for database operations
   */
  toPrisma(): Omit<PrismaCareActivity, 'id' | 'timestamp'> {
    return {
      groupId: this.groupId,
      memberId: this.memberId,
      activityType: this.activityType,
      description: this.description,
      data: this.data,
    };
  }

  /**
   * Check if activity is task-related
   */
  isTaskRelated(): boolean {
    return (
      this.activityType === ActivityType.TASK_CREATED ||
      this.activityType === ActivityType.TASK_COMPLETED
    );
  }

  /**
   * Get activity age in hours
   */
  getAgeInHours(): number {
    return (Date.now() - this.timestamp.getTime()) / (1000 * 60 * 60);
  }

  /**
   * Check if activity is recent (within last 24 hours)
   */
  isRecent(): boolean {
    return this.getAgeInHours() <= 24;
  }

  /**
   * Create activity for task completion
   */
  static createTaskCompletedActivity(data: {
    groupId: string;
    memberId: string;
    taskId: string;
    taskTitle: string;
  }) {
    return this.create({
      groupId: data.groupId,
      memberId: data.memberId,
      activityType: ActivityType.TASK_COMPLETED,
      description: `Task "${data.taskTitle}" has been marked as completed`,
      data: { taskId: data.taskId, taskTitle: data.taskTitle },
    });
  }

  /**
   * Create activity for task creation
   */
  static createTaskCreatedActivity(data: {
    groupId: string;
    memberId: string;
    taskId: string;
    taskTitle: string;
  }) {
    return this.create({
      groupId: data.groupId,
      memberId: data.memberId,
      activityType: ActivityType.TASK_CREATED,
      description: `Task "${data.taskTitle}" has been created`,
      data: {
        taskId: data.taskId,
        taskTitle: data.taskTitle,
      },
    });
  }

  /**
   * Create activity for member joining
   */
  static createMemberJoinedActivity(data: {
    groupId: string;
    memberId: string;
    newMemberId: string;
    memberName: string;
  }) {
    return this.create({
      groupId: data.groupId,
      memberId: data.memberId,
      activityType: ActivityType.MEMBER_JOINED,
      description: `New member ${data.memberName} has joined the care group`,
      data: { newMemberId: data.newMemberId, memberName: data.memberName },
    });
  }

  /**
   * Create activity for health update
   */
  static createHealthUpdateActivity(data: {
    groupId: string;
    memberId: string;
    recipientId: string;
    recipientName: string;
    updateType: string;
  }) {
    return this.create({
      groupId: data.groupId,
      memberId: data.memberId,
      activityType: ActivityType.HEALTH_UPDATE,
      description: `Health update for ${data.recipientName}: ${data.updateType}`,
      data: {
        recipientId: data.recipientId,
        recipientName: data.recipientName,
        updateType: data.updateType,
      },
    });
  }

  /**
   * Validate activity description
   */
  private static validateDescription(description: string): void {
    if (!description || description.trim().length === 0) {
      throw new Error('Activity description is required');
    }
    if (description.trim().length > 500) {
      throw new Error('Activity description must be less than 500 characters');
    }
  }

  /**
   * Validate activity type
   */
  private static validateActivityType(activityType: ActivityType): void {
    const validTypes = Object.values(ActivityType);
    if (!validTypes.includes(activityType)) {
      throw new Error(`Invalid activity type: ${activityType}`);
    }
  }

  /**
   * Convert to JSON representation for API responses
   */
  toJSON(): Record<string, any> {
    return {
      id: this.id,
      groupId: this.groupId,
      memberId: this.memberId,
      activityType: this.activityType,
      description: this.description,
      data: this.data,
      isRecent: this.isRecent(),
      ageInHours: Math.round(this.getAgeInHours()),
      timestamp: this.timestamp.toISOString(),
    };
  }
}
