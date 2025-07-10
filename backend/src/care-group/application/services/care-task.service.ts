import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { CareTaskRepository } from '../../domain/repositories/care-task.repository';
import { CareGroupMemberRepository } from '../../domain/repositories/care-group-member.repository';
import { CareTaskEntity } from '../../domain/entities/care-task.entity';
import { TaskCategory, TaskPriority, TaskStatus } from '@prisma/client';

export interface CreateTaskDto {
  title: string;
  description?: string;
  category: TaskCategory;
  priority?: TaskPriority;
  recipientId?: string;
  assigneeId?: string;
  dueDate?: Date;
  isRecurring?: boolean;
  recurringPattern?: Record<string, any>;
  metadata?: Record<string, any>;
}

export interface UpdateTaskDto {
  title?: string;
  description?: string;
  category?: TaskCategory;
  priority?: TaskPriority;
  status?: TaskStatus;
  recipientId?: string;
  assigneeId?: string;
  dueDate?: Date;
  isRecurring?: boolean;
  recurringPattern?: Record<string, any>;
  metadata?: Record<string, any>;
}

export interface TaskFilters {
  status?: TaskStatus;
  category?: TaskCategory;
  priority?: TaskPriority;
  assigneeId?: string;
  recipientId?: string;
  dueBefore?: Date;
  dueAfter?: Date;
}

@Injectable()
export class CareTaskService {
  constructor(
    private readonly taskRepository: CareTaskRepository,
    private readonly memberRepository: CareGroupMemberRepository,
  ) {}

  /**
   * Create a new task in a care group
   */
  async createTask(
    groupId: string,
    userId: string,
    createDto: CreateTaskDto,
  ): Promise<CareTaskEntity> {
    // Verify user has permission to create tasks in this group
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (!member) {
      throw new ForbiddenException('User is not a member of this care group');
    }

    if (!member.canManageTasks) {
      throw new ForbiddenException(
        'User does not have permission to create tasks',
      );
    }

    // Validate assignee if provided
    if (createDto.assigneeId) {
      const assignee = await this.memberRepository.findById(
        createDto.assigneeId,
      );
      if (!assignee || assignee.groupId !== groupId) {
        throw new BadRequestException('Invalid assignee for this care group');
      }
    }

    // Create task entity
    const taskData = CareTaskEntity.create({
      groupId,
      recipientId: createDto.recipientId,
      assigneeId: createDto.assigneeId,
      createdById: member.id,
      title: createDto.title,
      description: createDto.description,
      category: createDto.category,
      priority: createDto.priority || TaskPriority.MEDIUM,
      dueDate: createDto.dueDate,
      recurrence: createDto.recurringPattern,
      metadata: createDto.metadata || {},
    });

    // Create entity instance for repository
    const taskEntity = new CareTaskEntity(
      '', // ID will be generated
      taskData.groupId,
      taskData.recipientId,
      taskData.assigneeId,
      taskData.createdById,
      taskData.title,
      taskData.description,
      taskData.category,
      taskData.status,
      taskData.priority,
      taskData.dueDate,
      taskData.completedAt,
      taskData.recurrence,
      taskData.metadata,
      new Date(),
      new Date(),
    );

    return this.taskRepository.create(taskEntity);
  }

  /**
   * Get tasks for a care group
   */
  async getGroupTasks(
    groupId: string,
    userId: string,
    filters?: TaskFilters,
  ): Promise<CareTaskEntity[]> {
    // Verify user has access to this group
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (!member) {
      throw new ForbiddenException('User is not a member of this care group');
    }

    return this.taskRepository.findByGroupId(groupId);
  }

  /**
   * Get a specific task
   */
  async getTask(
    taskId: string,
    groupId: string,
    userId: string,
  ): Promise<CareTaskEntity> {
    // Verify user has access to this group
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (!member) {
      throw new ForbiddenException('User is not a member of this care group');
    }

    const task = await this.taskRepository.findById(taskId);
    if (!task || task.groupId !== groupId) {
      throw new NotFoundException('Task not found in this care group');
    }

    return task;
  }

  /**
   * Update a task
   */
  async updateTask(
    taskId: string,
    groupId: string,
    userId: string,
    updateDto: UpdateTaskDto,
  ): Promise<CareTaskEntity> {
    const task = await this.getTask(taskId, groupId, userId);

    // Verify user has permission to update tasks
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (
      !member?.canManageTasks &&
      task.createdById !== member?.id &&
      task.assigneeId !== member?.id
    ) {
      throw new ForbiddenException(
        'User does not have permission to update this task',
      );
    }

    // Validate assignee if being updated
    if (updateDto.assigneeId) {
      const assignee = await this.memberRepository.findById(
        updateDto.assigneeId,
      );
      if (!assignee || assignee.groupId !== groupId) {
        throw new BadRequestException('Invalid assignee for this care group');
      }
    }

    // Handle task completion - completion timestamp will be handled by entity update method

    return this.taskRepository.update(taskId, updateDto);
  }

  /**
   * Delete a task
   */
  async deleteTask(
    taskId: string,
    groupId: string,
    userId: string,
  ): Promise<void> {
    const task = await this.getTask(taskId, groupId, userId);

    // Verify user has permission to delete tasks
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (!member?.canManageTasks && task.createdById !== member?.id) {
      throw new ForbiddenException(
        'User does not have permission to delete this task',
      );
    }

    await this.taskRepository.delete(taskId);
  }

  /**
   * Get tasks assigned to a specific user
   */
  async getUserAssignedTasks(
    userId: string,
    groupId?: string,
    status?: TaskStatus,
  ): Promise<CareTaskEntity[]> {
    return this.taskRepository.findByAssigneeId(userId);
  }

  /**
   * Get tasks created by a specific user
   */
  async getUserCreatedTasks(
    userId: string,
    groupId?: string,
    status?: TaskStatus,
  ): Promise<CareTaskEntity[]> {
    // TODO: Implement findByCreatorId in repository
    return [];
  }

  /**
   * Get overdue tasks for a group
   */
  async getOverdueTasks(
    groupId: string,
    userId: string,
  ): Promise<CareTaskEntity[]> {
    // Verify user has access to this group
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (!member) {
      throw new ForbiddenException('User is not a member of this care group');
    }

    return this.taskRepository.findOverdueTasks(groupId);
  }

  /**
   * Mark task as completed
   */
  async completeTask(
    taskId: string,
    groupId: string,
    userId: string,
    notes?: string,
  ): Promise<CareTaskEntity> {
    return this.updateTask(taskId, groupId, userId, {
      status: TaskStatus.COMPLETED,
      metadata: notes ? { completionNotes: notes } : undefined,
    });
  }

  /**
   * Get task statistics for a group
   */
  async getTaskStatistics(
    groupId: string,
    userId: string,
  ): Promise<{
    total: number;
    pending: number;
    inProgress: number;
    completed: number;
    overdue: number;
  }> {
    // Verify user has access to this group
    const member = await this.memberRepository.findByGroupAndUser(
      groupId,
      userId,
    );
    if (!member) {
      throw new ForbiddenException('User is not a member of this care group');
    }

    const stats = await this.taskRepository.getTaskStatistics(groupId);
    return {
      total: stats.totalTasks,
      pending: stats.pendingTasks,
      inProgress: stats.inProgressTasks,
      completed: stats.completedTasks,
      overdue: stats.overdueTasks,
    };
  }
}
