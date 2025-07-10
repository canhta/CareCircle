import { CareTaskEntity } from '../entities/care-task.entity';
import { TaskStatus, TaskPriority, TaskType } from '@prisma/client';

export interface TaskQuery {
  groupId?: string;
  assigneeId?: string;
  recipientId?: string;
  createdById?: string;
  status?: TaskStatus;
  priority?: TaskPriority;
  type?: TaskType;
  isRecurring?: boolean;
  dueDateFrom?: Date;
  dueDateTo?: Date;
  limit?: number;
  offset?: number;
}

export abstract class CareTaskRepository {
  abstract create(task: CareTaskEntity): Promise<CareTaskEntity>;
  abstract findById(id: string): Promise<CareTaskEntity | null>;
  abstract findMany(query: TaskQuery): Promise<CareTaskEntity[]>;
  abstract findByGroupId(groupId: string): Promise<CareTaskEntity[]>;
  abstract findByAssigneeId(assigneeId: string): Promise<CareTaskEntity[]>;
  abstract findByRecipientId(recipientId: string): Promise<CareTaskEntity[]>;
  abstract update(
    id: string,
    updates: Partial<CareTaskEntity>,
  ): Promise<CareTaskEntity>;
  abstract delete(id: string): Promise<void>;

  // Task status operations
  abstract findByStatus(
    groupId: string,
    status: TaskStatus,
  ): Promise<CareTaskEntity[]>;
  abstract findPendingTasks(groupId: string): Promise<CareTaskEntity[]>;
  abstract findInProgressTasks(groupId: string): Promise<CareTaskEntity[]>;
  abstract findCompletedTasks(groupId: string): Promise<CareTaskEntity[]>;
  abstract findCancelledTasks(groupId: string): Promise<CareTaskEntity[]>;

  // Task priority operations
  abstract findByPriority(
    groupId: string,
    priority: TaskPriority,
  ): Promise<CareTaskEntity[]>;
  abstract findHighPriorityTasks(groupId: string): Promise<CareTaskEntity[]>;
  abstract findUrgentTasks(groupId: string): Promise<CareTaskEntity[]>;

  // Task type operations
  abstract findByType(
    groupId: string,
    type: TaskType,
  ): Promise<CareTaskEntity[]>;
  abstract findMedicationTasks(groupId: string): Promise<CareTaskEntity[]>;
  abstract findAppointmentTasks(groupId: string): Promise<CareTaskEntity[]>;
  abstract findExerciseTasks(groupId: string): Promise<CareTaskEntity[]>;

  // Due date operations
  abstract findOverdueTasks(groupId: string): Promise<CareTaskEntity[]>;
  abstract findTasksDueSoon(
    groupId: string,
    hoursThreshold: number,
  ): Promise<CareTaskEntity[]>;
  abstract findTasksDueToday(groupId: string): Promise<CareTaskEntity[]>;
  abstract findTasksDueThisWeek(groupId: string): Promise<CareTaskEntity[]>;
  abstract findTasksByDateRange(
    groupId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<CareTaskEntity[]>;

  // Assignment operations
  abstract findUnassignedTasks(groupId: string): Promise<CareTaskEntity[]>;
  abstract findAssignedTasks(groupId: string): Promise<CareTaskEntity[]>;
  abstract assignTask(
    taskId: string,
    assigneeId: string,
  ): Promise<CareTaskEntity>;
  abstract unassignTask(taskId: string): Promise<CareTaskEntity>;

  // Task completion operations
  abstract completeTask(taskId: string): Promise<CareTaskEntity>;
  abstract reopenTask(taskId: string): Promise<CareTaskEntity>;
  abstract cancelTask(taskId: string): Promise<CareTaskEntity>;

  // Recurring task operations
  abstract findRecurringTasks(groupId: string): Promise<CareTaskEntity[]>;
  abstract findTasksNeedingRecurrence(
    groupId: string,
  ): Promise<CareTaskEntity[]>;
  abstract createRecurringInstance(
    originalTaskId: string,
    newDueDate: Date,
  ): Promise<CareTaskEntity>;

  // Search operations
  abstract searchTasks(
    groupId: string,
    searchTerm: string,
  ): Promise<CareTaskEntity[]>;
  abstract findTasksWithNotes(groupId: string): Promise<CareTaskEntity[]>;

  // Count operations
  abstract getTaskCount(groupId: string): Promise<number>;
  abstract getTaskCountByStatus(
    groupId: string,
    status: TaskStatus,
  ): Promise<number>;
  abstract getTaskCountByAssignee(
    groupId: string,
    assigneeId: string,
  ): Promise<number>;
  abstract getOverdueTaskCount(groupId: string): Promise<number>;
  abstract getCompletedTaskCount(groupId: string): Promise<number>;

  // Analytics operations
  abstract getTaskStatistics(
    groupId: string,
  ): Promise<{
    totalTasks: number;
    pendingTasks: number;
    inProgressTasks: number;
    completedTasks: number;
    cancelledTasks: number;
    overdueTasks: number;
    highPriorityTasks: number;
    unassignedTasks: number;
    recurringTasks: number;
  }>;
  abstract getTaskCompletionRate(
    groupId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<{
    totalTasks: number;
    completedTasks: number;
    completionRate: number;
  }>;
  abstract getAssigneePerformance(
    groupId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<Array<{
    assigneeId: string;
    assignedTasks: number;
    completedTasks: number;
    overdueTasks: number;
    completionRate: number;
    averageCompletionTime: number;
  }>>;
  abstract getTaskTrends(
    groupId: string,
    days: number,
  ): Promise<Array<{
    date: Date;
    createdTasks: number;
    completedTasks: number;
    overdueTasks: number;
  }>>;
}
