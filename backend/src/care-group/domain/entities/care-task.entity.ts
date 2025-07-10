import { CareTask as PrismaCareTask, TaskStatus, TaskPriority, TaskType } from '@prisma/client';

/**
 * Care Task Domain Entity
 * 
 * Represents a task within a care group with assignment, scheduling, and tracking capabilities.
 * Handles task-specific business logic and validation.
 */
export class CareTaskEntity {
  constructor(
    public readonly id: string,
    public readonly groupId: string,
    public readonly recipientId: string | null,
    public readonly assigneeId: string | null,
    public readonly createdById: string,
    public readonly title: string,
    public readonly description: string | null,
    public readonly type: TaskType,
    public readonly status: TaskStatus,
    public readonly priority: TaskPriority,
    public readonly dueDate: Date | null,
    public readonly completedAt: Date | null,
    public readonly isRecurring: boolean,
    public readonly recurringPattern: Record<string, any> | null,
    public readonly metadata: Record<string, any>,
    public readonly createdAt: Date,
    public readonly updatedAt: Date,
  ) {}

  /**
   * Create a new Care Task entity
   */
  static create(data: {
    groupId: string;
    createdById: string;
    title: string;
    description?: string;
    type: TaskType;
    priority?: TaskPriority;
    dueDate?: Date;
    recipientId?: string;
    assigneeId?: string;
    isRecurring?: boolean;
    recurringPattern?: Record<string, any>;
    metadata?: Record<string, any>;
  }): Omit<CareTaskEntity, 'id' | 'createdAt' | 'updatedAt'> {
    // Validate business rules
    this.validateTitle(data.title);
    this.validateType(data.type);
    this.validatePriority(data.priority || TaskPriority.MEDIUM);
    this.validateDueDate(data.dueDate);

    return {
      groupId: data.groupId,
      recipientId: data.recipientId || null,
      assigneeId: data.assigneeId || null,
      createdById: data.createdById,
      title: data.title.trim(),
      description: data.description?.trim() || null,
      type: data.type,
      status: TaskStatus.PENDING,
      priority: data.priority || TaskPriority.MEDIUM,
      dueDate: data.dueDate || null,
      completedAt: null,
      isRecurring: data.isRecurring || false,
      recurringPattern: data.recurringPattern || null,
      metadata: data.metadata || {},
    };
  }

  /**
   * Create entity from Prisma model
   */
  static fromPrisma(prisma: PrismaCareTask): CareTaskEntity {
    return new CareTaskEntity(
      prisma.id,
      prisma.groupId,
      prisma.recipientId,
      prisma.assigneeId,
      prisma.createdById,
      prisma.title,
      prisma.description,
      prisma.type,
      prisma.status,
      prisma.priority,
      prisma.dueDate,
      prisma.completedAt,
      prisma.isRecurring,
      prisma.recurringPattern as Record<string, any> | null,
      prisma.metadata as Record<string, any>,
      prisma.createdAt,
      prisma.updatedAt,
    );
  }

  /**
   * Convert to Prisma format for database operations
   */
  toPrisma(): Omit<PrismaCareTask, 'id' | 'createdAt' | 'updatedAt'> {
    return {
      groupId: this.groupId,
      recipientId: this.recipientId,
      assigneeId: this.assigneeId,
      createdById: this.createdById,
      title: this.title,
      description: this.description,
      type: this.type,
      status: this.status,
      priority: this.priority,
      dueDate: this.dueDate,
      completedAt: this.completedAt,
      isRecurring: this.isRecurring,
      recurringPattern: this.recurringPattern,
      metadata: this.metadata,
    };
  }

  /**
   * Update task information
   */
  update(data: {
    title?: string;
    description?: string;
    type?: TaskType;
    status?: TaskStatus;
    priority?: TaskPriority;
    dueDate?: Date;
    assigneeId?: string;
    recipientId?: string;
    isRecurring?: boolean;
    recurringPattern?: Record<string, any>;
    metadata?: Record<string, any>;
  }): CareTaskEntity {
    if (data.title !== undefined) {
      CareTaskEntity.validateTitle(data.title);
    }
    if (data.type !== undefined) {
      CareTaskEntity.validateType(data.type);
    }
    if (data.priority !== undefined) {
      CareTaskEntity.validatePriority(data.priority);
    }
    if (data.dueDate !== undefined) {
      CareTaskEntity.validateDueDate(data.dueDate);
    }

    const completedAt = data.status === TaskStatus.COMPLETED && this.status !== TaskStatus.COMPLETED
      ? new Date()
      : this.completedAt;

    return new CareTaskEntity(
      this.id,
      this.groupId,
      data.recipientId ?? this.recipientId,
      data.assigneeId ?? this.assigneeId,
      this.createdById,
      data.title?.trim() ?? this.title,
      data.description?.trim() ?? this.description,
      data.type ?? this.type,
      data.status ?? this.status,
      data.priority ?? this.priority,
      data.dueDate ?? this.dueDate,
      completedAt,
      data.isRecurring ?? this.isRecurring,
      data.recurringPattern ?? this.recurringPattern,
      data.metadata ?? this.metadata,
      this.createdAt,
      new Date(), // updatedAt
    );
  }

  /**
   * Mark task as completed
   */
  complete(): CareTaskEntity {
    if (this.status === TaskStatus.COMPLETED) {
      throw new Error('Task is already completed');
    }

    return this.update({
      status: TaskStatus.COMPLETED,
    });
  }

  /**
   * Assign task to a member
   */
  assignTo(assigneeId: string): CareTaskEntity {
    return this.update({ assigneeId });
  }

  /**
   * Check if task is overdue
   */
  isOverdue(): boolean {
    if (!this.dueDate || this.status === TaskStatus.COMPLETED) {
      return false;
    }
    return new Date() > this.dueDate;
  }

  /**
   * Check if task is due soon (within 24 hours)
   */
  isDueSoon(): boolean {
    if (!this.dueDate || this.status === TaskStatus.COMPLETED) {
      return false;
    }
    const twentyFourHours = 24 * 60 * 60 * 1000;
    return (this.dueDate.getTime() - Date.now()) <= twentyFourHours;
  }

  /**
   * Check if task is assigned
   */
  isAssigned(): boolean {
    return this.assigneeId !== null;
  }

  /**
   * Check if task is completed
   */
  isCompleted(): boolean {
    return this.status === TaskStatus.COMPLETED;
  }

  /**
   * Check if task is high priority
   */
  isHighPriority(): boolean {
    return this.priority === TaskPriority.HIGH || this.priority === TaskPriority.URGENT;
  }

  /**
   * Get time until due date in milliseconds
   */
  getTimeUntilDue(): number | null {
    if (!this.dueDate) return null;
    return this.dueDate.getTime() - Date.now();
  }

  /**
   * Validate task title
   */
  private static validateTitle(title: string): void {
    if (!title || title.trim().length === 0) {
      throw new Error('Task title is required');
    }
    if (title.trim().length < 3) {
      throw new Error('Task title must be at least 3 characters long');
    }
    if (title.trim().length > 200) {
      throw new Error('Task title must be less than 200 characters');
    }
  }

  /**
   * Validate task type
   */
  private static validateType(type: TaskType): void {
    const validTypes = Object.values(TaskType);
    if (!validTypes.includes(type)) {
      throw new Error(`Invalid task type: ${type}`);
    }
  }

  /**
   * Validate task priority
   */
  private static validatePriority(priority: TaskPriority): void {
    const validPriorities = Object.values(TaskPriority);
    if (!validPriorities.includes(priority)) {
      throw new Error(`Invalid task priority: ${priority}`);
    }
  }

  /**
   * Validate due date
   */
  private static validateDueDate(dueDate?: Date): void {
    if (dueDate && dueDate < new Date()) {
      throw new Error('Due date cannot be in the past');
    }
  }

  /**
   * Convert to JSON representation for API responses
   */
  toJSON(): Record<string, any> {
    return {
      id: this.id,
      groupId: this.groupId,
      recipientId: this.recipientId,
      assigneeId: this.assigneeId,
      createdById: this.createdById,
      title: this.title,
      description: this.description,
      type: this.type,
      status: this.status,
      priority: this.priority,
      dueDate: this.dueDate?.toISOString() || null,
      completedAt: this.completedAt?.toISOString() || null,
      isRecurring: this.isRecurring,
      recurringPattern: this.recurringPattern,
      metadata: this.metadata,
      isOverdue: this.isOverdue(),
      isDueSoon: this.isDueSoon(),
      createdAt: this.createdAt.toISOString(),
      updatedAt: this.updatedAt.toISOString(),
    };
  }
}
