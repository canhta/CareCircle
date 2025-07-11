import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { CareTaskRepository } from '../../domain/repositories/care-task.repository';
import { CareTaskEntity } from '../../domain/entities/care-task.entity';
import { TaskStatus, TaskCategory, TaskPriority, Prisma } from '@prisma/client';
import {
  CareTaskQuery,
  CareTaskUpdateData,
  TaskCompletionRate,
  AssigneePerformance,
  TaskTrend,
} from '../../domain/types/repository-query.types';

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
        recurrence: task.recurrence as any,
        metadata: task.metadata as any,
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

  async update(
    id: string,
    updates: CareTaskUpdateData,
  ): Promise<CareTaskEntity> {
    const updateData: Prisma.CareTaskUpdateInput = {};

    if (updates.title !== undefined) updateData.title = updates.title;
    if (updates.description !== undefined)
      updateData.description = updates.description;
    if (updates.category !== undefined) updateData.category = updates.category;
    if (updates.priority !== undefined) updateData.priority = updates.priority;
    if (updates.status !== undefined) updateData.status = updates.status;
    if (updates.recipientId !== undefined) {
      updateData.recipient = updates.recipientId
        ? { connect: { id: updates.recipientId } }
        : { disconnect: true };
    }
    if (updates.assigneeId !== undefined) {
      updateData.assignee = updates.assigneeId
        ? { connect: { id: updates.assigneeId } }
        : { disconnect: true };
    }
    if (updates.dueDate !== undefined) updateData.dueDate = updates.dueDate;
    if (updates.completedAt !== undefined)
      updateData.completedAt = updates.completedAt;
    if (updates.recurrence !== undefined)
      updateData.recurrence = updates.recurrence as any;
    if (updates.metadata !== undefined)
      updateData.metadata = updates.metadata as any;

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
    totalTasks: number;
    pendingTasks: number;
    inProgressTasks: number;
    completedTasks: number;
    cancelledTasks: number;
    overdueTasks: number;
    highPriorityTasks: number;
    unassignedTasks: number;
    recurringTasks: number;
  }> {
    const now = new Date();

    const [
      totalTasks,
      pendingTasks,
      inProgressTasks,
      completedTasks,
      cancelledTasks,
      overdueTasks,
      highPriorityTasks,
      unassignedTasks,
      recurringTasks,
    ] = await Promise.all([
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
        where: { groupId, status: TaskStatus.CANCELLED },
      }),
      this.prisma.careTask.count({
        where: {
          groupId,
          status: { in: [TaskStatus.PENDING, TaskStatus.IN_PROGRESS] },
          dueDate: { lt: now },
        },
      }),
      this.prisma.careTask.count({
        where: { groupId, priority: TaskPriority.HIGH },
      }),
      this.prisma.careTask.count({
        where: { groupId, assigneeId: null },
      }),
      this.prisma.careTask.count({
        where: { groupId, recurrence: { not: Prisma.JsonNull } },
      }),
    ]);

    return {
      totalTasks,
      pendingTasks,
      inProgressTasks,
      completedTasks,
      cancelledTasks,
      overdueTasks,
      highPriorityTasks,
      unassignedTasks,
      recurringTasks,
    };
  }

  // Implement missing abstract methods
  async findMany(query: CareTaskQuery): Promise<CareTaskEntity[]> {
    const where: Prisma.CareTaskWhereInput = {};

    if (query.groupId) where.groupId = query.groupId;
    if (query.assigneeId) where.assigneeId = query.assigneeId;
    if (query.recipientId) where.recipientId = query.recipientId;
    if (query.status) where.status = query.status;
    if (query.priority) where.priority = query.priority;
    if (query.category) where.category = query.category;
    if (query.dueDateFrom || query.dueDateTo) {
      where.dueDate = {};
      if (query.dueDateFrom) where.dueDate.gte = query.dueDateFrom;
      if (query.dueDateTo) where.dueDate.lte = query.dueDateTo;
    }

    const data = await this.prisma.careTask.findMany({
      where,
      orderBy: { createdAt: 'desc' },
      take: query.limit || 50,
      skip: query.offset || 0,
    });

    return data.map((item) => CareTaskEntity.fromPrisma(item));
  }

  async findByRecipientId(recipientId: string): Promise<CareTaskEntity[]> {
    const data = await this.prisma.careTask.findMany({
      where: { recipientId },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => CareTaskEntity.fromPrisma(item));
  }

  async findByStatus(
    groupId: string,
    status: TaskStatus,
  ): Promise<CareTaskEntity[]> {
    const data = await this.prisma.careTask.findMany({
      where: { groupId, status },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => CareTaskEntity.fromPrisma(item));
  }

  async findPendingTasks(groupId: string): Promise<CareTaskEntity[]> {
    return this.findByStatus(groupId, TaskStatus.PENDING);
  }

  async findInProgressTasks(groupId: string): Promise<CareTaskEntity[]> {
    return this.findByStatus(groupId, TaskStatus.IN_PROGRESS);
  }

  async findCompletedTasks(groupId: string): Promise<CareTaskEntity[]> {
    return this.findByStatus(groupId, TaskStatus.COMPLETED);
  }

  async findCancelledTasks(groupId: string): Promise<CareTaskEntity[]> {
    return this.findByStatus(groupId, TaskStatus.CANCELLED);
  }

  async findByPriority(
    groupId: string,
    priority: TaskPriority,
  ): Promise<CareTaskEntity[]> {
    const data = await this.prisma.careTask.findMany({
      where: { groupId, priority },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => CareTaskEntity.fromPrisma(item));
  }

  async findHighPriorityTasks(groupId: string): Promise<CareTaskEntity[]> {
    return this.findByPriority(groupId, TaskPriority.HIGH);
  }

  async findUrgentTasks(groupId: string): Promise<CareTaskEntity[]> {
    const data = await this.prisma.careTask.findMany({
      where: {
        groupId,
        priority: { in: [TaskPriority.HIGH, TaskPriority.URGENT] },
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => CareTaskEntity.fromPrisma(item));
  }

  // Task category operations
  async findByCategory(
    groupId: string,
    category: TaskCategory,
  ): Promise<CareTaskEntity[]> {
    const data = await this.prisma.careTask.findMany({
      where: { groupId, category },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => CareTaskEntity.fromPrisma(item));
  }

  async findMedicationTasks(groupId: string): Promise<CareTaskEntity[]> {
    return this.findByCategory(groupId, TaskCategory.MEDICATION);
  }

  async findAppointmentTasks(groupId: string): Promise<CareTaskEntity[]> {
    return this.findByCategory(groupId, TaskCategory.APPOINTMENT);
  }

  async findExerciseTasks(groupId: string): Promise<CareTaskEntity[]> {
    return this.findByCategory(groupId, TaskCategory.EXERCISE);
  }

  // Due date operations
  async findOverdueTasks(groupId: string): Promise<CareTaskEntity[]> {
    const now = new Date();
    const data = await this.prisma.careTask.findMany({
      where: {
        groupId,
        status: { in: [TaskStatus.PENDING, TaskStatus.IN_PROGRESS] },
        dueDate: { lt: now },
      },
      orderBy: { dueDate: 'asc' },
    });

    return data.map((item) => CareTaskEntity.fromPrisma(item));
  }

  async findTasksDueSoon(
    groupId: string,
    hoursThreshold: number,
  ): Promise<CareTaskEntity[]> {
    const now = new Date();
    const threshold = new Date(now.getTime() + hoursThreshold * 60 * 60 * 1000);

    const data = await this.prisma.careTask.findMany({
      where: {
        groupId,
        status: { in: [TaskStatus.PENDING, TaskStatus.IN_PROGRESS] },
        dueDate: {
          gte: now,
          lte: threshold,
        },
      },
      orderBy: { dueDate: 'asc' },
    });

    return data.map((item) => CareTaskEntity.fromPrisma(item));
  }

  async findTasksDueToday(groupId: string): Promise<CareTaskEntity[]> {
    const today = new Date();
    const startOfDay = new Date(
      today.getFullYear(),
      today.getMonth(),
      today.getDate(),
    );
    const endOfDay = new Date(
      today.getFullYear(),
      today.getMonth(),
      today.getDate(),
      23,
      59,
      59,
    );

    return this.findTasksByDateRange(groupId, startOfDay, endOfDay);
  }

  async findTasksDueThisWeek(groupId: string): Promise<CareTaskEntity[]> {
    const today = new Date();
    const startOfWeek = new Date(
      today.getFullYear(),
      today.getMonth(),
      today.getDate() - today.getDay(),
    );
    const endOfWeek = new Date(
      today.getFullYear(),
      today.getMonth(),
      today.getDate() + (6 - today.getDay()),
      23,
      59,
      59,
    );

    return this.findTasksByDateRange(groupId, startOfWeek, endOfWeek);
  }

  async findTasksByDateRange(
    groupId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<CareTaskEntity[]> {
    const data = await this.prisma.careTask.findMany({
      where: {
        groupId,
        dueDate: {
          gte: startDate,
          lte: endDate,
        },
      },
      orderBy: { dueDate: 'asc' },
    });

    return data.map((item) => CareTaskEntity.fromPrisma(item));
  }

  // Assignment operations
  async findUnassignedTasks(groupId: string): Promise<CareTaskEntity[]> {
    const data = await this.prisma.careTask.findMany({
      where: { groupId, assigneeId: null },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => CareTaskEntity.fromPrisma(item));
  }

  async findAssignedTasks(groupId: string): Promise<CareTaskEntity[]> {
    const data = await this.prisma.careTask.findMany({
      where: {
        groupId,
        assigneeId: { not: null },
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => CareTaskEntity.fromPrisma(item));
  }

  async assignTask(
    taskId: string,
    assigneeId: string,
  ): Promise<CareTaskEntity> {
    const data = await this.prisma.careTask.update({
      where: { id: taskId },
      data: { assigneeId },
    });

    return CareTaskEntity.fromPrisma(data);
  }

  async unassignTask(taskId: string): Promise<CareTaskEntity> {
    const data = await this.prisma.careTask.update({
      where: { id: taskId },
      data: { assigneeId: null },
    });

    return CareTaskEntity.fromPrisma(data);
  }

  // Task completion operations
  async completeTask(taskId: string): Promise<CareTaskEntity> {
    const data = await this.prisma.careTask.update({
      where: { id: taskId },
      data: {
        status: TaskStatus.COMPLETED,
        completedAt: new Date(),
      },
    });

    return CareTaskEntity.fromPrisma(data);
  }

  async reopenTask(taskId: string): Promise<CareTaskEntity> {
    const data = await this.prisma.careTask.update({
      where: { id: taskId },
      data: {
        status: TaskStatus.PENDING,
        completedAt: null,
      },
    });

    return CareTaskEntity.fromPrisma(data);
  }

  async cancelTask(taskId: string): Promise<CareTaskEntity> {
    const data = await this.prisma.careTask.update({
      where: { id: taskId },
      data: { status: TaskStatus.CANCELLED },
    });

    return CareTaskEntity.fromPrisma(data);
  }

  // Recurring task operations
  async findRecurringTasks(groupId: string): Promise<CareTaskEntity[]> {
    const data = await this.prisma.careTask.findMany({
      where: {
        groupId,
        recurrence: { not: Prisma.JsonNull },
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => CareTaskEntity.fromPrisma(item));
  }

  async findTasksNeedingRecurrence(
    _groupId: string,
  ): Promise<CareTaskEntity[]> {
    // This would require complex logic to determine which recurring tasks need new instances
    // For now, return empty array as placeholder
    return Promise.resolve([]);
  }

  async createRecurringInstance(
    originalTaskId: string,
    newDueDate: Date,
  ): Promise<CareTaskEntity> {
    const originalTask = await this.prisma.careTask.findUnique({
      where: { id: originalTaskId },
    });

    if (!originalTask) {
      throw new Error('Original task not found');
    }

    const data = await this.prisma.careTask.create({
      data: {
        groupId: originalTask.groupId,
        recipientId: originalTask.recipientId,
        assigneeId: originalTask.assigneeId,
        createdById: originalTask.createdById,
        title: originalTask.title,
        description: originalTask.description,
        category: originalTask.category,
        priority: originalTask.priority,
        status: TaskStatus.PENDING,
        dueDate: newDueDate,
        recurrence: originalTask.recurrence as any,
        metadata: originalTask.metadata as any,
      },
    });

    return CareTaskEntity.fromPrisma(data);
  }

  // Search operations
  async searchTasks(
    groupId: string,
    searchTerm: string,
  ): Promise<CareTaskEntity[]> {
    const data = await this.prisma.careTask.findMany({
      where: {
        groupId,
        OR: [
          { title: { contains: searchTerm, mode: 'insensitive' } },
          { description: { contains: searchTerm, mode: 'insensitive' } },
        ],
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => CareTaskEntity.fromPrisma(item));
  }

  async findTasksWithNotes(groupId: string): Promise<CareTaskEntity[]> {
    const data = await this.prisma.careTask.findMany({
      where: {
        groupId,
        description: { not: null },
      },
      orderBy: { createdAt: 'desc' },
    });

    return data.map((item) => CareTaskEntity.fromPrisma(item));
  }

  // Count operations
  async getTaskCount(groupId: string): Promise<number> {
    return this.prisma.careTask.count({ where: { groupId } });
  }

  async getTaskCountByStatus(
    groupId: string,
    status: TaskStatus,
  ): Promise<number> {
    return this.prisma.careTask.count({ where: { groupId, status } });
  }

  async getTaskCountByAssignee(
    groupId: string,
    assigneeId: string,
  ): Promise<number> {
    return this.prisma.careTask.count({ where: { groupId, assigneeId } });
  }

  async getOverdueTaskCount(groupId: string): Promise<number> {
    const now = new Date();
    return this.prisma.careTask.count({
      where: {
        groupId,
        status: { in: [TaskStatus.PENDING, TaskStatus.IN_PROGRESS] },
        dueDate: { lt: now },
      },
    });
  }

  async getCompletedTaskCount(groupId: string): Promise<number> {
    return this.getTaskCountByStatus(groupId, TaskStatus.COMPLETED);
  }

  // Analytics operations
  async getTaskCompletionRate(
    groupId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<TaskCompletionRate> {
    const [totalTasks, completedTasks] = await Promise.all([
      this.prisma.careTask.count({
        where: {
          groupId,
          createdAt: {
            gte: startDate,
            lte: endDate,
          },
        },
      }),
      this.prisma.careTask.count({
        where: {
          groupId,
          status: TaskStatus.COMPLETED,
          completedAt: {
            gte: startDate,
            lte: endDate,
          },
        },
      }),
    ]);

    const completionRate =
      totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;

    return {
      totalTasks,
      completedTasks,
      completionRate,
    };
  }

  async getAssigneePerformance(
    groupId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<AssigneePerformance[]> {
    const assignees = await this.prisma.careTask.groupBy({
      by: ['assigneeId'],
      where: {
        groupId,
        assigneeId: { not: null },
        createdAt: {
          gte: startDate,
          lte: endDate,
        },
      },
      _count: { assigneeId: true },
    });

    const performance = await Promise.all(
      assignees.map(async (assignee) => {
        const assigneeId = assignee.assigneeId!;

        const [assignedTasks, completedTasks, overdueTasks] = await Promise.all(
          [
            this.prisma.careTask.count({
              where: {
                groupId,
                assigneeId,
                createdAt: {
                  gte: startDate,
                  lte: endDate,
                },
              },
            }),
            this.prisma.careTask.count({
              where: {
                groupId,
                assigneeId,
                status: TaskStatus.COMPLETED,
                completedAt: {
                  gte: startDate,
                  lte: endDate,
                },
              },
            }),
            this.prisma.careTask.count({
              where: {
                groupId,
                assigneeId,
                status: { in: [TaskStatus.PENDING, TaskStatus.IN_PROGRESS] },
                dueDate: { lt: new Date() },
              },
            }),
          ],
        );

        const completionRate =
          assignedTasks > 0 ? (completedTasks / assignedTasks) * 100 : 0;

        // Calculate average completion time (simplified)
        const completedTasksWithTimes = await this.prisma.careTask.findMany({
          where: {
            groupId,
            assigneeId,
            status: TaskStatus.COMPLETED,
            completedAt: {
              gte: startDate,
              lte: endDate,
            },
          },
          select: {
            createdAt: true,
            completedAt: true,
          },
        });

        const averageCompletionTime =
          completedTasksWithTimes.length > 0
            ? completedTasksWithTimes.reduce((sum, task) => {
                const completionTime =
                  task.completedAt!.getTime() - task.createdAt.getTime();
                return sum + completionTime;
              }, 0) /
              completedTasksWithTimes.length /
              (1000 * 60 * 60) // Convert to hours
            : 0;

        return {
          assigneeId,
          assignedTasks,
          completedTasks,
          overdueTasks,
          completionRate,
          averageCompletionTime,
        };
      }),
    );

    return performance;
  }

  async getTaskTrends(groupId: string, days: number): Promise<TaskTrend[]> {
    const endDate = new Date();
    const startDate = new Date(endDate.getTime() - days * 24 * 60 * 60 * 1000);

    // This is a simplified implementation
    // In a real system, you'd want to group by date more efficiently
    const trends: Array<{
      date: Date;
      createdTasks: number;
      completedTasks: number;
      overdueTasks: number;
    }> = [];

    for (let i = 0; i < days; i++) {
      const currentDate = new Date(
        startDate.getTime() + i * 24 * 60 * 60 * 1000,
      );
      const nextDate = new Date(currentDate.getTime() + 24 * 60 * 60 * 1000);

      const [createdTasks, completedTasks, overdueTasks] = await Promise.all([
        this.prisma.careTask.count({
          where: {
            groupId,
            createdAt: {
              gte: currentDate,
              lt: nextDate,
            },
          },
        }),
        this.prisma.careTask.count({
          where: {
            groupId,
            status: TaskStatus.COMPLETED,
            completedAt: {
              gte: currentDate,
              lt: nextDate,
            },
          },
        }),
        this.prisma.careTask.count({
          where: {
            groupId,
            status: { in: [TaskStatus.PENDING, TaskStatus.IN_PROGRESS] },
            dueDate: {
              gte: currentDate,
              lt: nextDate,
            },
          },
        }),
      ]);

      trends.push({
        date: currentDate,
        createdTasks,
        completedTasks,
        overdueTasks,
      });
    }

    return trends;
  }
}
