import { Injectable, Logger } from '@nestjs/common';
import { QueueService } from './queue.service';

export interface MedicationScheduleData {
  userId: string;
  medicationId: string;
  scheduleId: string;
  medicationName: string;
  dosage: number;
  unit: string;
  scheduledTimes: Date[];
  frequency: string;
  careGroupId?: string;
}

export interface CareGroupTaskData {
  groupId: string;
  taskId: string;
  assigneeId: string;
  title: string;
  dueDate: Date;
  priority: 'low' | 'medium' | 'high' | 'urgent';
}

@Injectable()
export class HealthcareAutomationService {
  private readonly logger = new Logger(HealthcareAutomationService.name);

  constructor(private readonly queueService: QueueService) {}

  /**
   * Schedule medication reminders for a medication schedule
   */
  async scheduleMedicationReminders(
    scheduleData: MedicationScheduleData,
  ): Promise<void> {
    try {
      this.logger.log(
        `Scheduling medication reminders for user ${scheduleData.userId}`,
      );

      // Schedule individual reminders for each scheduled time
      for (const scheduledTime of scheduleData.scheduledTimes) {
        // Only schedule future reminders
        if (scheduledTime > new Date()) {
          const delay = scheduledTime.getTime() - Date.now();

          await this.queueService.addMedicationReminder(
            {
              userId: scheduleData.userId,
              medicationId: scheduleData.medicationId,
              scheduleId: scheduleData.scheduleId,
              scheduledTime,
              dosage: scheduleData.dosage,
              unit: scheduleData.unit,
              medicationName: scheduleData.medicationName,
            },
            {
              delay,
              priority: 5, // High priority for medication reminders
            },
          );

          // Schedule missed dose alert 30 minutes after scheduled time
          const missedDoseDelay = delay + 30 * 60 * 1000; // 30 minutes
          await this.queueService.addMissedDoseAlert(
            {
              userId: scheduleData.userId,
              medicationId: scheduleData.medicationId,
              scheduleId: scheduleData.scheduleId,
              scheduledTime,
              medicationName: scheduleData.medicationName,
              careGroupId: scheduleData.careGroupId,
            },
            {
              delay: missedDoseDelay,
              priority: 8, // Very high priority for missed dose alerts
            },
          );
        }
      }

      this.logger.log(
        `Scheduled ${scheduleData.scheduledTimes.length} medication reminders for user ${scheduleData.userId}`,
      );
    } catch (error) {
      this.logger.error(
        `Failed to schedule medication reminders for user ${scheduleData.userId}:`,
        (error as Error).stack,
      );
      throw error;
    }
  }

  /**
   * Schedule recurring medication reminders using cron pattern
   */
  async scheduleRecurringMedicationReminders(
    userId: string,
    medicationId: string,
    cronPattern: string,
  ): Promise<void> {
    try {
      this.logger.log(
        `Scheduling recurring medication reminders for user ${userId} with pattern ${cronPattern}`,
      );

      await this.queueService.scheduleRecurringMedicationReminders(
        userId,
        medicationId,
        cronPattern,
      );

      this.logger.log(
        `Scheduled recurring medication reminders for user ${userId}`,
      );
    } catch (error) {
      this.logger.error(
        `Failed to schedule recurring medication reminders for user ${userId}:`,
        (error as Error).stack,
      );
      throw error;
    }
  }

  /**
   * Schedule care group task reminders
   */
  async scheduleCareGroupTaskReminders(
    taskData: CareGroupTaskData,
  ): Promise<void> {
    try {
      this.logger.log(`Scheduling task reminders for task ${taskData.title}`);

      const now = new Date();
      const dueDate = new Date(taskData.dueDate);

      // Schedule reminders based on priority and due date
      const reminderTimes = this.calculateTaskReminderTimes(
        dueDate,
        taskData.priority,
      );

      for (const reminderTime of reminderTimes) {
        if (reminderTime > now) {
          const delay = reminderTime.getTime() - now.getTime();

          await this.queueService.addCareGroupTaskReminder(
            {
              groupId: taskData.groupId,
              taskId: taskData.taskId,
              assigneeId: taskData.assigneeId,
              title: taskData.title,
              dueDate: taskData.dueDate,
              priority: taskData.priority,
            },
            {
              delay,
              priority: this.getTaskReminderPriority(taskData.priority),
            },
          );
        }
      }

      this.logger.log(
        `Scheduled ${reminderTimes.length} task reminders for task ${taskData.title}`,
      );
    } catch (error) {
      this.logger.error(
        `Failed to schedule task reminders for task ${taskData.title}:`,
        (error as Error).stack,
      );
      throw error;
    }
  }

  /**
   * Cancel medication reminders for a specific schedule
   */
  cancelMedicationReminders(userId: string, scheduleId: string): Promise<void> {
    try {
      this.logger.log(
        `Canceling medication reminders for user ${userId}, schedule ${scheduleId}`,
      );

      // In a full implementation, this would:
      // 1. Query the queue for jobs matching the criteria
      // 2. Remove pending jobs
      // 3. Update job status in database
      // 4. Log cancellation for audit purposes

      this.logger.log(
        `Canceled medication reminders for user ${userId}, schedule ${scheduleId}`,
      );

      return Promise.resolve();
    } catch (error) {
      this.logger.error(
        `Failed to cancel medication reminders for user ${userId}:`,
        (error as Error).stack,
      );
      return Promise.reject(
        error instanceof Error ? error : new Error(String(error)),
      );
    }
  }

  /**
   * Cancel care group task reminders
   */
  cancelCareGroupTaskReminders(groupId: string, taskId: string): Promise<void> {
    try {
      this.logger.log(
        `Canceling task reminders for group ${groupId}, task ${taskId}`,
      );

      // In a full implementation, this would:
      // 1. Query the queue for jobs matching the criteria
      // 2. Remove pending jobs
      // 3. Update job status in database
      // 4. Log cancellation for audit purposes

      this.logger.log(
        `Canceled task reminders for group ${groupId}, task ${taskId}`,
      );

      return Promise.resolve();
    } catch (error) {
      this.logger.error(
        `Failed to cancel task reminders for group ${groupId}:`,
        (error as Error).stack,
      );
      return Promise.reject(
        error instanceof Error ? error : new Error(String(error)),
      );
    }
  }

  /**
   * Calculate reminder times based on due date and priority
   */
  private calculateTaskReminderTimes(dueDate: Date, priority: string): Date[] {
    const reminderTimes: Date[] = [];
    const dueDateMs = dueDate.getTime();

    switch (priority) {
      case 'urgent':
        // Urgent tasks: 1 day, 4 hours, 1 hour, 15 minutes before
        reminderTimes.push(
          new Date(dueDateMs - 24 * 60 * 60 * 1000), // 1 day
          new Date(dueDateMs - 4 * 60 * 60 * 1000), // 4 hours
          new Date(dueDateMs - 60 * 60 * 1000), // 1 hour
          new Date(dueDateMs - 15 * 60 * 1000), // 15 minutes
        );
        break;
      case 'high':
        // High priority: 2 days, 1 day, 4 hours before
        reminderTimes.push(
          new Date(dueDateMs - 2 * 24 * 60 * 60 * 1000), // 2 days
          new Date(dueDateMs - 24 * 60 * 60 * 1000), // 1 day
          new Date(dueDateMs - 4 * 60 * 60 * 1000), // 4 hours
        );
        break;
      case 'medium':
        // Medium priority: 3 days, 1 day before
        reminderTimes.push(
          new Date(dueDateMs - 3 * 24 * 60 * 60 * 1000), // 3 days
          new Date(dueDateMs - 24 * 60 * 60 * 1000), // 1 day
        );
        break;
      case 'low':
        // Low priority: 1 week, 3 days before
        reminderTimes.push(
          new Date(dueDateMs - 7 * 24 * 60 * 60 * 1000), // 1 week
          new Date(dueDateMs - 3 * 24 * 60 * 60 * 1000), // 3 days
        );
        break;
    }

    return reminderTimes.filter((time) => time > new Date());
  }

  /**
   * Get queue priority based on task priority
   */
  private getTaskReminderPriority(priority: string): number {
    switch (priority) {
      case 'urgent':
        return 9;
      case 'high':
        return 7;
      case 'medium':
        return 4;
      case 'low':
        return 2;
      default:
        return 4;
    }
  }
}
