import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Query,
  UseGuards,
  HttpStatus,
  ParseIntPipe,
  DefaultValuePipe,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { NotificationService } from './notification.service';
import { NotificationTemplateService } from './notification-template.service';
import { NotificationAuditLoggingService } from './audit-logging.service';
import {
  SendNotificationDto,
  ScheduleNotificationDto,
  NotificationResponseDto,
  NotificationPreferencesDto,
} from './dto/notification.dto';
import { User } from '@prisma/client';
import {
  NotificationContextData,
  NotificationTemplateContext,
  NotificationTrackingData,
  NotificationTrackingMetadata,
} from '../common/interfaces/notification-tracking.interfaces';

@ApiTags('notifications')
@ApiBearerAuth()
@Controller('notifications')
@UseGuards(JwtAuthGuard)
export class NotificationController {
  constructor(
    private readonly notificationService: NotificationService,
    private readonly templateService: NotificationTemplateService,
    private readonly auditLoggingService: NotificationAuditLoggingService,
  ) {}

  @Post('send')
  @ApiOperation({ summary: 'Send immediate notification' })
  @ApiResponse({
    status: 201,
    description: 'Notification sent successfully',
    type: NotificationResponseDto,
  })
  async sendNotification(
    @CurrentUser() user: User,
    @Body() dto: SendNotificationDto,
  ) {
    const notification = await this.notificationService.sendNotification({
      ...dto,
      userId: user.id,
    });

    return {
      statusCode: HttpStatus.CREATED,
      message: 'Notification sent successfully',
      data: notification,
    };
  }

  @Post('schedule')
  @ApiOperation({ summary: 'Schedule notification for later delivery' })
  @ApiResponse({
    status: 201,
    description: 'Notification scheduled successfully',
    type: NotificationResponseDto,
  })
  async scheduleNotification(
    @CurrentUser() user: User,
    @Body() dto: ScheduleNotificationDto,
  ) {
    const notification = await this.notificationService.scheduleNotification({
      ...dto,
      userId: user.id,
      scheduledFor: new Date(dto.scheduledFor),
    });

    return {
      statusCode: HttpStatus.CREATED,
      message: 'Notification scheduled successfully',
      data: notification,
    };
  }

  @Get()
  @ApiOperation({ summary: 'Get user notifications with pagination' })
  @ApiResponse({
    status: 200,
    description: 'Notifications retrieved successfully',
  })
  async getUserNotifications(
    @CurrentUser() user: User,
    @Query('page', new DefaultValuePipe(1), ParseIntPipe) page: number,
    @Query('limit', new DefaultValuePipe(20), ParseIntPipe) limit: number,
    @Query('unreadOnly', new DefaultValuePipe('false')) unreadOnly: string,
  ) {
    const unreadOnlyBool = unreadOnly === 'true';
    const result = await this.notificationService.getUserNotifications(
      user.id,
      page,
      limit,
      unreadOnlyBool,
    );

    return {
      statusCode: HttpStatus.OK,
      message: 'Notifications retrieved successfully',
      data: result,
    };
  }

  @Post(':id/mark-read')
  @ApiOperation({ summary: 'Mark notification as read' })
  @ApiResponse({ status: 200, description: 'Notification marked as read' })
  async markAsRead(
    @CurrentUser() user: User,
    @Param('id') notificationId: string,
  ) {
    await this.notificationService.markAsRead(notificationId, user.id);

    return {
      statusCode: HttpStatus.OK,
      message: 'Notification marked as read',
    };
  }

  @Get('preferences')
  @ApiOperation({ summary: 'Get user notification preferences' })
  @ApiResponse({
    status: 200,
    description: 'Preferences retrieved successfully',
  })
  async getNotificationPreferences(@CurrentUser() user: User) {
    const preferences =
      await this.notificationService.getNotificationPreferences(user.id);

    return {
      statusCode: HttpStatus.OK,
      message: 'Preferences retrieved successfully',
      data: preferences,
    };
  }

  @Post('test/medication-reminder')
  @ApiOperation({ summary: 'Test medication reminder (development only)' })
  @ApiResponse({ status: 200, description: 'Test reminder sent' })
  async testMedicationReminder(@CurrentUser() user: User) {
    // This is for testing purposes - in production, this would be removed
    const testReminderData = {
      id: 'test-reminder-id',
      prescriptionId: 'test-prescription-id',
      userId: user.id,
      medicationName: 'Test Medication',
      dosage: '10mg',
      scheduledAt: new Date(),
      frequency: 'daily',
    };

    await this.notificationService.sendMedicationReminder(testReminderData);

    return {
      statusCode: HttpStatus.OK,
      message: 'Test medication reminder sent',
    };
  }

  @Post('test/check-in-reminder')
  @ApiOperation({ summary: 'Test check-in reminder (development only)' })
  @ApiResponse({ status: 200, description: 'Test check-in reminder sent' })
  async testCheckInReminder(@CurrentUser() user: User) {
    await this.notificationService.sendCheckInReminder(user.id);

    return {
      statusCode: HttpStatus.OK,
      message: 'Test check-in reminder sent',
    };
  }

  @Post('test/health-insight')
  @ApiOperation({
    summary: 'Test health insight notification (development only)',
  })
  @ApiResponse({ status: 200, description: 'Test health insight sent' })
  async testHealthInsight(@CurrentUser() user: User) {
    await this.notificationService.sendHealthInsight(
      user.id,
      'Your step count has increased by 25% this week! Keep up the great work.',
      'medium',
    );

    return {
      statusCode: HttpStatus.OK,
      message: 'Test health insight sent',
    };
  }

  @Get('templates')
  @ApiOperation({ summary: 'Get all notification templates' })
  @ApiResponse({ status: 200, description: 'List of notification templates' })
  async getTemplates() {
    const templates = await this.templateService.listTemplates();
    return {
      statusCode: HttpStatus.OK,
      data: templates,
    };
  }

  @Get('templates/:id/preview')
  @ApiOperation({ summary: 'Preview a template with sample data' })
  @ApiResponse({ status: 200, description: 'Template preview' })
  async previewTemplate(
    @Param('id') templateId: string,
    @CurrentUser() user: User,
  ) {
    const sampleContext: NotificationTemplateContext = {
      userName: user.firstName,
      medicationName: 'Sample Medication',
      dosage: '10mg',
      timeOfDay: 'morning',
      careGroupName: 'Family Care Circle',
      inviterName: 'Dr. Smith',
    };

    const rendered = await this.templateService.renderTemplate(
      templateId,
      sampleContext,
    );
    return {
      statusCode: HttpStatus.OK,
      data: rendered,
    };
  }

  @Post('send-templated')
  @ApiOperation({ summary: 'Send notification using a template' })
  @ApiResponse({ status: 201, description: 'Templated notification sent' })
  async sendTemplatedNotification(
    @CurrentUser() user: User,
    @Body() dto: NotificationContextData,
  ) {
    const notification =
      await this.notificationService.sendTemplatedNotification(
        user.id,
        dto.templateName,
        dto.context,
        { scheduledFor: dto.scheduledFor },
      );

    return {
      statusCode: HttpStatus.CREATED,
      data: notification,
    };
  }

  @Post('test/templated-medication-reminder')
  @ApiOperation({ summary: 'Test templated medication reminder' })
  @ApiResponse({
    status: 200,
    description: 'Test templated medication reminder sent',
  })
  async testTemplatedMedicationReminder(@CurrentUser() user: User) {
    const mockReminderData = {
      id: 'test-reminder-id',
      prescriptionId: 'test-prescription-id',
      userId: user.id,
      medicationName: 'Test Medication',
      dosage: '10mg',
      scheduledAt: new Date(),
      frequency: 'twice daily',
    };

    await this.notificationService.sendTemplatedMedicationReminder(
      mockReminderData,
    );

    return {
      statusCode: HttpStatus.OK,
      message: 'Test templated medication reminder sent',
    };
  }

  // Audit Logging Endpoints
  @Get(':id/audit-logs')
  @ApiOperation({ summary: 'Get audit logs for a notification' })
  @ApiResponse({
    status: 200,
    description: 'Audit logs retrieved successfully',
  })
  async getAuditLogs(@Param('id') notificationId: string) {
    const auditLogs =
      await this.auditLoggingService.getAuditLogs(notificationId);
    return {
      statusCode: HttpStatus.OK,
      data: auditLogs,
    };
  }

  @Get(':id/delivery-logs')
  @ApiOperation({ summary: 'Get delivery logs for a notification' })
  @ApiResponse({
    status: 200,
    description: 'Delivery logs retrieved successfully',
  })
  async getDeliveryLogs(@Param('id') notificationId: string) {
    const deliveryLogs =
      await this.auditLoggingService.getDeliveryLogs(notificationId);
    return {
      statusCode: HttpStatus.OK,
      data: deliveryLogs,
    };
  }

  @Get('users/:userId/delivery-stats')
  @ApiOperation({ summary: 'Get delivery statistics for a user' })
  @ApiResponse({
    status: 200,
    description: 'Delivery statistics retrieved successfully',
  })
  async getDeliveryStats(
    @Param('userId') userId: string,
    @Query('days', new DefaultValuePipe(30), ParseIntPipe) days: number,
  ) {
    const stats = await this.auditLoggingService.getDeliveryStats(userId, days);
    return {
      statusCode: HttpStatus.OK,
      data: stats,
    };
  }

  @Get('my-delivery-stats')
  @ApiOperation({ summary: 'Get delivery statistics for current user' })
  @ApiResponse({
    status: 200,
    description: 'Delivery statistics retrieved successfully',
  })
  async getMyDeliveryStats(
    @CurrentUser() user: User,
    @Query('days', new DefaultValuePipe(30), ParseIntPipe) days: number,
  ) {
    const stats = await this.auditLoggingService.getDeliveryStats(
      user.id,
      days,
    );
    return {
      statusCode: HttpStatus.OK,
      data: stats,
    };
  }

  @Post(':id/track-opened')
  @ApiOperation({ summary: 'Track notification opened' })
  @ApiResponse({
    status: 200,
    description: 'Notification tracking updated successfully',
  })
  async trackNotificationOpened(
    @Param('id') notificationId: string,
    @Body() trackingData: NotificationTrackingData,
  ) {
    await this.auditLoggingService.logNotificationOpened(
      notificationId,
      trackingData.channel,
      trackingData.metadata,
    );
    return {
      statusCode: HttpStatus.OK,
      message: 'Notification opened tracked successfully',
    };
  }

  @Post(':id/track-clicked')
  @ApiOperation({ summary: 'Track notification clicked' })
  @ApiResponse({
    status: 200,
    description: 'Notification tracking updated successfully',
  })
  async trackNotificationClicked(
    @Param('id') notificationId: string,
    @Body() trackingData: NotificationTrackingData,
  ) {
    await this.auditLoggingService.logNotificationClicked(
      notificationId,
      trackingData.channel,
      trackingData.metadata,
    );
    return {
      statusCode: HttpStatus.OK,
      message: 'Notification clicked tracked successfully',
    };
  }
}
