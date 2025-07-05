import { Processor, WorkerHost } from '@nestjs/bullmq';
import { Logger } from '@nestjs/common';
import { Job } from 'bullmq';
import { PrismaService } from '../../prisma/prisma.service';
import { NotificationService } from '../notification.service';
import { ReminderData } from '../../common/interfaces/notification.interfaces';
import { Reminder, Prescription, User } from '@prisma/client';

interface ReminderWithPrescription extends Reminder {
  prescription: Prescription & {
    user: User;
  };
}

@Processor('reminder')
export class ReminderProcessor extends WorkerHost {
  private readonly logger = new Logger(ReminderProcessor.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly notificationService: NotificationService,
  ) {
    super();
  }

  async process(job: Job<ReminderData>): Promise<void> {
    const reminderData = job.data;

    try {
      this.logger.debug(`Processing reminder job: ${reminderData.id}`);

      // Check if reminder is still valid and not already processed
      const reminder = await this.prisma.reminder.findUnique({
        where: { id: reminderData.id },
        include: {
          prescription: {
            include: {
              user: true,
            },
          },
        },
      });

      if (!reminder) {
        this.logger.warn(`Reminder not found: ${reminderData.id}`);
        return;
      }

      if (reminder.status !== 'PENDING') {
        this.logger.warn(`Reminder already processed: ${reminderData.id}`);
        return;
      }

      // Send the medication reminder
      await this.notificationService.sendMedicationReminder(reminderData);

      // Schedule next reminder if recurring
      if (reminder.isRecurring) {
        await this.scheduleNextReminder(reminder as ReminderWithPrescription);
      }

      this.logger.log(`Reminder processed successfully: ${reminderData.id}`);
    } catch (error) {
      this.logger.error(
        `Failed to process reminder ${reminderData.id}:`,
        error,
      );
      throw error; // Re-throw to trigger job retry
    }
  }

  private async scheduleNextReminder(
    reminder: ReminderWithPrescription,
  ): Promise<void> {
    try {
      // Calculate next reminder time based on frequency
      const nextReminderTime = this.calculateNextReminderTime(
        reminder.scheduledAt,
        reminder.frequency || 'daily',
      );

      // Create new reminder record
      const newReminder = await this.prisma.reminder.create({
        data: {
          prescriptionId: reminder.prescriptionId,
          scheduledAt: nextReminderTime,
          isRecurring: true,
          frequency: reminder.frequency,
          status: 'PENDING',
          retryCount: 0,
          maxRetries: reminder.maxRetries,
        },
      });

      this.logger.debug(
        `Next reminder scheduled: ${newReminder.id} at ${nextReminderTime.toISOString()}`,
      );
    } catch (error) {
      this.logger.error(`Failed to schedule next reminder:`, error);
    }
  }

  private calculateNextReminderTime(
    currentTime: Date,
    frequency: string,
  ): Date {
    const nextTime = new Date(currentTime);

    switch (frequency?.toLowerCase()) {
      case 'daily':
        nextTime.setDate(nextTime.getDate() + 1);
        break;
      case 'twice_daily':
        nextTime.setHours(nextTime.getHours() + 12);
        break;
      case 'weekly':
        nextTime.setDate(nextTime.getDate() + 7);
        break;
      case 'monthly':
        nextTime.setMonth(nextTime.getMonth() + 1);
        break;
      default:
        // Default to daily if frequency is not recognized
        nextTime.setDate(nextTime.getDate() + 1);
        break;
    }

    return nextTime;
  }
}
