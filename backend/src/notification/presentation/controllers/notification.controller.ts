import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import { FirebaseAuthGuard } from '../../../identity-access/presentation/guards/firebase-auth.guard';
import {
  NotificationService,
  CreateNotificationDto,
} from '../../application/services/notification.service';
import { NotificationType, NotificationPriority } from '@prisma/client';

interface AuthenticatedRequest {
  user: {
    id: string;
    email?: string;
    isGuest: boolean;
    firebaseUid: string;
  };
}

@Controller('notifications')
@UseGuards(FirebaseAuthGuard)
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}

  @Post()
  async createNotification(
    @Body() createNotificationDto: CreateNotificationDto,
    @Request() req: AuthenticatedRequest,
  ) {
    // Ensure the notification is created for the authenticated user
    const notificationData = {
      ...createNotificationDto,
      userId: req.user.id,
    };

    const notification =
      await this.notificationService.createNotification(notificationData);

    return {
      success: true,
      data: notification,
    };
  }

  @Get()
  async getNotifications(
    @Request() req: AuthenticatedRequest,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    const notifications = await this.notificationService.findByUserId(
      req.user.id,
      limit ? parseInt(limit) : undefined,
      offset ? parseInt(offset) : undefined,
    );

    return {
      success: true,
      data: notifications,
    };
  }

  @Get('summary')
  async getNotificationSummary(@Request() req: AuthenticatedRequest) {
    const summary = await this.notificationService.getNotificationSummary(
      req.user.id,
    );

    return {
      success: true,
      data: summary,
    };
  }

  @Get('unread')
  async getUnreadNotifications(@Request() req: AuthenticatedRequest) {
    const notifications = await this.notificationService.findUnread(
      req.user.id,
    );

    return {
      success: true,
      data: notifications,
    };
  }

  @Get('type/:type')
  async getNotificationsByType(
    @Param('type') type: NotificationType,
    @Request() req: AuthenticatedRequest,
  ) {
    const notifications = await this.notificationService.findByType(
      req.user.id,
      type,
    );

    return {
      success: true,
      data: notifications,
    };
  }

  @Get('priority/:priority')
  async getNotificationsByPriority(
    @Param('priority') priority: NotificationPriority,
    @Request() req: AuthenticatedRequest,
  ) {
    const notifications = await this.notificationService.findByPriority(
      req.user.id,
      priority,
    );

    return {
      success: true,
      data: notifications,
    };
  }

  @Get(':id')
  async getNotification(@Param('id') id: string) {
    const notification = await this.notificationService.findById(id);

    return {
      success: true,
      data: notification,
    };
  }

  @Put(':id/read')
  async markAsRead(@Param('id') id: string) {
    const notification = await this.notificationService.markAsRead(id);

    return {
      success: true,
      data: notification,
    };
  }

  @Put('mark-all-read')
  async markAllAsRead(@Request() req: AuthenticatedRequest) {
    const markedCount = await this.notificationService.markAllAsRead(req.user.id);

    return {
      success: true,
      data: { markedCount },
      message: `${markedCount} notification(s) marked as read`,
    };
  }

  @Put(':id/delivered')
  async markAsDelivered(@Param('id') id: string) {
    const notification = await this.notificationService.markAsDelivered(id);

    return {
      success: true,
      data: notification,
    };
  }

  @Delete(':id')
  async deleteNotification(@Param('id') id: string) {
    await this.notificationService.deleteNotification(id);

    return {
      success: true,
      message: 'Notification deleted successfully',
    };
  }

  // Healthcare-specific endpoints
  @Post('health-alert')
  async createHealthAlert(
    @Body()
    body: {
      title: string;
      message: string;
      priority?: NotificationPriority;
      metadata?: Record<string, any>;
    },
    @Request() req: AuthenticatedRequest,
  ) {
    const notification = await this.notificationService.createHealthAlert(
      req.user.id,
      body.title,
      body.message,
      body.priority,
      body.metadata,
    );

    return {
      success: true,
      data: notification,
    };
  }

  @Post('medication-reminder')
  async createMedicationReminder(
    @Body()
    body: {
      medicationName: string;
      dosage: string;
      scheduledFor: string; // ISO date string
      metadata?: Record<string, any>;
    },
    @Request() req: AuthenticatedRequest,
  ) {
    const notification =
      await this.notificationService.createMedicationReminder(
        req.user.id,
        body.medicationName,
        body.dosage,
        new Date(body.scheduledFor),
        body.metadata,
      );

    return {
      success: true,
      data: notification,
    };
  }

  @Post('emergency-alert')
  async createEmergencyAlert(
    @Body()
    body: {
      title: string;
      message: string;
      metadata?: Record<string, any>;
    },
    @Request() req: AuthenticatedRequest,
  ) {
    const notification = await this.notificationService.createEmergencyAlert(
      req.user.id,
      body.title,
      body.message,
      body.metadata,
    );

    return {
      success: true,
      data: notification,
    };
  }
}
