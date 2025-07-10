import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { CareTaskRepository } from '../../domain/repositories/care-task.repository';
import { CareTaskEntity } from '../../domain/entities/care-task.entity';
import { TaskStatus, TaskCategory, TaskPriority, Prisma } from '@prisma/client';

@Injectable()
export class PrismaCareTaskRepository implements CareTaskRepository {
  constructor(private readonly prisma: PrismaService) {}

  async create(task: CareTaskEntity): Promise<CareTaskEntity> {
    const created = await this.prisma.careTask.create({
      data: {
        groupId: task.groupId,
        recipientId: task.recipientId,
        assigneeId: task.assigneeId,
        createdById: task.createdById,
        title: task.title,
        description: task.description,
        category: task.category,
        priority: task.priority,
        status: task.status,
        dueDate: task.dueDate,
        completedAt: task.completedAt,
        recurrence: task.recurringPattern,
        metadata: task.metadata,
      },
    });

    return CareTaskEntity.fromPrisma(created);
  }

  async findById(id: string): Promise<CareTaskEntity | null> {
    const task = await this.prisma.careTask.findUnique({
      where: { id },
    });

    return task ? CareTaskEntity.fromPrisma(task) : null;
  }

  async findByGroupId(
    groupId: string,
    filters?: {
      status?: TaskStatus;
      category?: TaskCategory;
      priority?: TaskPriority;
      assigneeId?: string;
      recipientId?: string;
      dueBefore?: Date;
      dueAfter?: Date;
    },
  ): Promise<CareTaskEntity[]> {
    const where: Prisma.CareTaskWhereInput = { groupId };

    if (filters?.status) {
      where.status = filters.status;
    }
    if (filters?.category) {
      where.category = filters.category;
    }
    if (filters?.priority) {
      where.priority = filters.priority;
    }
    if (filters?.assigneeId) {
      where.assigneeId = filters.assigneeId;
    }
    if (filters?.recipientId) {
      where.recipientId = filters.recipientId;
    }
    if (filters?.dueBefore || filters?.dueAfter) {
      where.dueDate = {};
      if (filters.dueBefore) {
        where.dueDate.lte = filters.dueBefore;
      }
      if (filters.dueAfter) {
        where.dueDate.gte = filters.dueAfter;
      }
    }

    const tasks = await this.prisma.careTask.findMany({
      where,
      orderBy: [
        { priority: 'desc' },
        { dueDate: 'asc' },
        { createdAt: 'desc' },
      ],
    });

    return tasks.map((task) => CareTaskEntity.fromPrisma(task));
  }

  async findByAssigneeId(
    assigneeId: string,
    filters?: { groupId?: string; status?: TaskStatus },
  ): Promise<CareTaskEntity[]> {
    const where: Prisma.CareTaskWhereInput = { assigneeId };

    if (filters?.groupId) {
      where.groupId = filters.groupId;
    }
    if (filters?.status) {
      where.status = filters.status;
    }

    const tasks = await this.prisma.careTask.findMany({
      where,
      orderBy: [
        { priority: 'desc' },
        { dueDate: 'asc' },
        { createdAt: 'desc' },
      ],
    });

    return tasks.map((task) => CareTaskEntity.fromPrisma(task));
  }

  async findByCreatorId(
    createdById: string,
    filters?: { groupId?: string; status?: TaskStatus },
  ): Promise<CareTaskEntity[]> {
    const where: Prisma.CareTaskWhereInput = { createdById };

    if (filters?.groupId) {
      where.groupId = filters.groupId;
    }
    if (filters?.status) {
      where.status = filters.status;
    }

    const tasks = await this.prisma.careTask.findMany({
      where,
      orderBy: [
        { priority: 'desc' },
        { dueDate: 'asc' },
        { createdAt: 'desc' },
      ],
    });

    return tasks.map((task) => CareTaskEntity.fromPrisma(task));
  }

  async findOverdueTasks(groupId: string): Promise<CareTaskEntity[]> {
    const now = new Date();

    const tasks = await this.prisma.careTask.findMany({
      where: {
        groupId,
        status: {
          in: [TaskStatus.PENDING, TaskStatus.IN_PROGRESS],
        },
        dueDate: {
          lt: now,
        },
      },
      orderBy: [{ priority: 'desc' }, { dueDate: 'asc' }],
    });

    return tasks.map((task) => CareTaskEntity.fromPrisma(task));
  }

  async update(
    id: string,
    updates: Partial<{
      title: string;
      description: string;
      category: TaskCategory;
      priority: TaskPriority;
      status: TaskStatus;
      recipientId: string;
      assigneeId: string;
      dueDate: Date;
      completedAt: Date;
      isRecurring: boolean;
      recurringPattern: Record<string, any>;
      metadata: Record<string, any>;
    }>,
  ): Promise<CareTaskEntity> {
    const updateData: Prisma.CareTaskUpdateInput = {};

    if (updates.title !== undefined) updateData.title = updates.title;
    if (updates.description !== undefined)
      updateData.description = updates.description;
    if (updates.category !== undefined) updateData.category = updates.category;
    if (updates.priority !== undefined) updateData.priority = updates.priority;
    if (updates.status !== undefined) updateData.status = updates.status;
    if (updates.recipientId !== undefined)
      updateData.recipientId = updates.recipientId;
    if (updates.assigneeId !== undefined)
      updateData.assigneeId = updates.assigneeId;
    if (updates.dueDate !== undefined) updateData.dueDate = updates.dueDate;
    if (updates.completedAt !== undefined)
      updateData.completedAt = updates.completedAt;
    if (updates.recurringPattern !== undefined)
      updateData.recurrence = updates.recurringPattern;
    if (updates.metadata !== undefined) updateData.metadata = updates.metadata;

    const updated = await this.prisma.careTask.update({
      where: { id },
      data: updateData,
    });

    return CareTaskEntity.fromPrisma(updated);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.careTask.delete({
      where: { id },
    });
  }

  async getTaskStatistics(groupId: string): Promise<{
    total: number;
    pending: number;
    inProgress: number;
    completed: number;
    overdue: number;
  }> {
    const now = new Date();

    const [total, pending, inProgress, completed, overdue] = await Promise.all([
      this.prisma.careTask.count({ where: { groupId } }),
      this.prisma.careTask.count({
        where: { groupId, status: TaskStatus.PENDING },
      }),
      this.prisma.careTask.count({
        where: { groupId, status: TaskStatus.IN_PROGRESS },
      }),
      this.prisma.careTask.count({
        where: { groupId, status: TaskStatus.COMPLETED },
      }),
      this.prisma.careTask.count({
        where: {
          groupId,
          status: { in: [TaskStatus.PENDING, TaskStatus.IN_PROGRESS] },
          dueDate: { lt: now },
        },
      }),
    ]);

    return {
      total,
      pending,
      inProgress,
      completed,
      overdue,
    };
  }
}
