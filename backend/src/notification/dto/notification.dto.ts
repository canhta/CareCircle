import {
  IsString,
  IsEnum,
  IsOptional,
  IsArray,
  IsDateString,
  IsObject,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional, ApiSchema } from '@nestjs/swagger';
import {
  NotificationType,
  NotificationChannel,
  NotificationPriority,
} from '@prisma/client';

@ApiSchema({
  name: 'SendNotificationDto',
  description: 'DTO for sending general notifications through various channels',
})
export class SendNotificationDto {
  @ApiProperty({ description: 'Notification title' })
  @IsString()
  title: string;

  @ApiProperty({ description: 'Notification message' })
  @IsString()
  message: string;

  @ApiProperty({
    description: 'Notification type',
    enum: NotificationType,
  })
  @IsEnum(NotificationType)
  type: NotificationType;

  @ApiProperty({
    description: 'Delivery channels',
    enum: NotificationChannel,
    isArray: true,
  })
  @IsArray()
  @IsEnum(NotificationChannel, { each: true })
  channels: NotificationChannel[];

  @ApiPropertyOptional({
    description: 'Notification priority',
    enum: NotificationPriority,
    default: NotificationPriority.NORMAL,
  })
  @IsOptional()
  @IsEnum(NotificationPriority)
  priority?: NotificationPriority;

  @ApiPropertyOptional({ description: 'Action URL for the notification' })
  @IsOptional()
  @IsString()
  actionUrl?: string;

  @ApiPropertyOptional({ description: 'Template data for personalization' })
  @IsOptional()
  @IsObject()
  templateData?: Record<string, any>;
}

export class ScheduleNotificationDto extends SendNotificationDto {
  @ApiProperty({ description: 'Scheduled delivery time (ISO string)' })
  @IsDateString()
  scheduledFor: string;
}

export class NotificationResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  title: string;

  @ApiProperty()
  message: string;

  @ApiProperty({ enum: NotificationType })
  type: NotificationType;

  @ApiProperty({ enum: NotificationChannel, isArray: true })
  channel: NotificationChannel[];

  @ApiProperty({ enum: NotificationPriority })
  priority: NotificationPriority;

  @ApiPropertyOptional()
  actionUrl?: string;

  @ApiPropertyOptional()
  sentAt?: Date;

  @ApiPropertyOptional()
  readAt?: Date;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}

export class NotificationPreferencesDto {
  @ApiProperty()
  medicationReminders: boolean;

  @ApiProperty()
  checkInReminders: boolean;

  @ApiProperty()
  aiInsights: boolean;

  @ApiProperty()
  careGroupUpdates: boolean;

  @ApiProperty()
  channels: {
    push: boolean;
    email: boolean;
    sms: boolean;
    inApp: boolean;
  };

  @ApiProperty()
  quietHours: {
    enabled: boolean;
    start: string;
    end: string;
  };
}
