import { CareActivity as PrismaCareActivity, ActivityType } from '@prisma/client';

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
    public readonly userId: string,
    public readonly type: ActivityType,
    public readonly title: string,
    public readonly description: string | null,
    public readonly metadata: Record<string, any>,
    public readonly relatedTaskId: string | null,
    public readonly relatedRecipientId: string | null,
    public readonly createdAt: Date,
  ) {}

  /**
   * Create a new Care Activity entity
   */
  static create(data: {
    groupId: string;
    userId: string;
    type: ActivityType;
    title: string;
    description?: string;
    metadata?: Record<string, any>;
    relatedTaskId?: string;
    relatedRecipientId?: string;
  }): Omit<CareActivityEntity, 'id' | 'createdAt'> {
    // Validate business rules
    this.validateTitle(data.title);
    this.validateType(data.type);

    return {
      groupId: data.groupId,
      userId: data.userId,
      type: data.type,
      title: data.title.trim(),
      description: data.description?.trim() || null,
      metadata: data.metadata || {},
      relatedTaskId: data.relatedTaskId || null,
      relatedRecipientId: data.relatedRecipientId || null,
    };
  }

  /**
   * Create entity from Prisma model
   */
  static fromPrisma(prisma: PrismaCareActivity): CareActivityEntity {
    return new CareActivityEntity(
      prisma.id,
      prisma.groupId,
      prisma.userId,
      prisma.type,
      prisma.title,
      prisma.description,
      prisma.metadata as Record<string, any>,
      prisma.relatedTaskId,
      prisma.relatedRecipientId,
      prisma.createdAt,
    );
  }

  /**
   * Convert to Prisma format for database operations
   */
  toPrisma(): Omit<PrismaCareActivity, 'id' | 'createdAt'> {
    return {
      groupId: this.groupId,
      userId: this.userId,
      type: this.type,
      title: this.title,
      description: this.description,
      metadata: this.metadata,
      relatedTaskId: this.relatedTaskId,
      relatedRecipientId: this.relatedRecipientId,
    };
  }

  /**
   * Check if activity is related to a task
   */
  isTaskRelated(): boolean {
    return this.relatedTaskId !== null;
  }

  /**
   * Check if activity is related to a care recipient
   */
  isRecipientRelated(): boolean {
    return this.relatedRecipientId !== null;
  }

  /**
   * Get activity age in hours
   */
  getAgeInHours(): number {
    return (Date.now() - this.createdAt.getTime()) / (1000 * 60 * 60);
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
    userId: string;
    taskId: string;
    taskTitle: string;
  }): Omit<CareActivityEntity, 'id' | 'createdAt'> {
    return this.create({
      groupId: data.groupId,
      userId: data.userId,
      type: ActivityType.TASK_COMPLETED,
      title: `Completed task: ${data.taskTitle}`,
      description: `Task "${data.taskTitle}" has been marked as completed`,
      metadata: { taskId: data.taskId, taskTitle: data.taskTitle },
      relatedTaskId: data.taskId,
    });
  }

  /**
   * Create activity for task assignment
   */
  static createTaskAssignedActivity(data: {
    groupId: string;
    userId: string;
    assigneeId: string;
    taskId: string;
    taskTitle: string;
  }): Omit<CareActivityEntity, 'id' | 'createdAt'> {
    return this.create({
      groupId: data.groupId,
      userId: data.userId,
      type: ActivityType.TASK_ASSIGNED,
      title: `Assigned task: ${data.taskTitle}`,
      description: `Task "${data.taskTitle}" has been assigned`,
      metadata: { 
        taskId: data.taskId, 
        taskTitle: data.taskTitle,
        assigneeId: data.assigneeId 
      },
      relatedTaskId: data.taskId,
    });
  }

  /**
   * Create activity for member joining
   */
  static createMemberJoinedActivity(data: {
    groupId: string;
    userId: string;
    newMemberId: string;
    memberName: string;
  }): Omit<CareActivityEntity, 'id' | 'createdAt'> {
    return this.create({
      groupId: data.groupId,
      userId: data.userId,
      type: ActivityType.MEMBER_JOINED,
      title: `${data.memberName} joined the care group`,
      description: `New member ${data.memberName} has joined the care group`,
      metadata: { newMemberId: data.newMemberId, memberName: data.memberName },
    });
  }

  /**
   * Create activity for care recipient added
   */
  static createRecipientAddedActivity(data: {
    groupId: string;
    userId: string;
    recipientId: string;
    recipientName: string;
  }): Omit<CareActivityEntity, 'id' | 'createdAt'> {
    return this.create({
      groupId: data.groupId,
      userId: data.userId,
      type: ActivityType.RECIPIENT_ADDED,
      title: `Added care recipient: ${data.recipientName}`,
      description: `Care recipient ${data.recipientName} has been added to the group`,
      metadata: { recipientId: data.recipientId, recipientName: data.recipientName },
      relatedRecipientId: data.recipientId,
    });
  }

  /**
   * Validate activity title
   */
  private static validateTitle(title: string): void {
    if (!title || title.trim().length === 0) {
      throw new Error('Activity title is required');
    }
    if (title.trim().length > 200) {
      throw new Error('Activity title must be less than 200 characters');
    }
  }

  /**
   * Validate activity type
   */
  private static validateType(type: ActivityType): void {
    const validTypes = Object.values(ActivityType);
    if (!validTypes.includes(type)) {
      throw new Error(`Invalid activity type: ${type}`);
    }
  }

  /**
   * Convert to JSON representation for API responses
   */
  toJSON(): Record<string, any> {
    return {
      id: this.id,
      groupId: this.groupId,
      userId: this.userId,
      type: this.type,
      title: this.title,
      description: this.description,
      metadata: this.metadata,
      relatedTaskId: this.relatedTaskId,
      relatedRecipientId: this.relatedRecipientId,
      isRecent: this.isRecent(),
      ageInHours: Math.round(this.getAgeInHours()),
      createdAt: this.createdAt.toISOString(),
    };
  }
}
