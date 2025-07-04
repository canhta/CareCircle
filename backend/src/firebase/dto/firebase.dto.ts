import { ApiProperty, ApiSchema } from '@nestjs/swagger';
import {
  IsString,
  IsEnum,
  IsOptional,
  IsNotEmpty,
  IsObject,
  IsArray,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';

export enum DeviceType {
  IOS = 'ios',
  ANDROID = 'android',
  WEB = 'web',
}

export enum NotificationPriority {
  HIGH = 'high',
  NORMAL = 'normal',
}

export class RegisterTokenDto {
  @ApiProperty({
    description: 'FCM token for the device',
    example: 'fGxqZ8ZqSrE:APA91bGZ...',
  })
  @IsString()
  @IsNotEmpty()
  token: string;

  @ApiProperty({
    description: 'Type of device',
    enum: DeviceType,
    example: DeviceType.IOS,
  })
  @IsEnum(DeviceType)
  deviceType: DeviceType;

  @ApiProperty({
    description: 'Optional device info',
    required: false,
  })
  @IsOptional()
  @IsObject()
  deviceInfo?: {
    model?: string;
    osVersion?: string;
    appVersion?: string;
  };
}

export class RemoveTokenDto {
  @ApiProperty({
    description: 'FCM token to remove',
    example: 'fGxqZ8ZqSrE:APA91bGZ...',
  })
  @IsString()
  @IsNotEmpty()
  token: string;
}

@ApiSchema({
  name: 'SendPushNotificationDto',
  description: 'DTO for sending Firebase push notifications',
})
export class SendPushNotificationDto {
  @ApiProperty({
    description: 'Notification title',
    example: 'Medication Reminder',
  })
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiProperty({
    description: 'Notification body',
    example: 'Time to take your medication',
  })
  @IsString()
  @IsNotEmpty()
  body: string;

  @ApiProperty({
    description: 'Target user IDs',
    type: [String],
    example: ['user1', 'user2'],
  })
  @IsArray()
  @IsString({ each: true })
  userIds: string[];

  @ApiProperty({
    description: 'Notification data payload',
    required: false,
  })
  @IsOptional()
  @IsObject()
  data?: { [key: string]: string };

  @ApiProperty({
    description: 'Image URL for rich notification',
    required: false,
  })
  @IsOptional()
  @IsString()
  imageUrl?: string;

  @ApiProperty({
    description: 'Action URL for notification tap',
    required: false,
  })
  @IsOptional()
  @IsString()
  actionUrl?: string;

  @ApiProperty({
    description: 'Notification priority',
    enum: NotificationPriority,
    required: false,
    default: NotificationPriority.NORMAL,
  })
  @IsOptional()
  @IsEnum(NotificationPriority)
  priority?: NotificationPriority;

  @ApiProperty({
    description: 'Notification actions',
    required: false,
  })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => NotificationActionDto)
  actions?: NotificationActionDto[];
}

export class NotificationActionDto {
  @ApiProperty({
    description: 'Action ID',
    example: 'mark_taken',
  })
  @IsString()
  @IsNotEmpty()
  id: string;

  @ApiProperty({
    description: 'Action title',
    example: 'Mark as Taken',
  })
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiProperty({
    description: 'Action icon',
    required: false,
  })
  @IsOptional()
  @IsString()
  icon?: string;
}

export class SubscribeTopicDto {
  @ApiProperty({
    description: 'Topic name',
    example: 'medication_reminders',
  })
  @IsString()
  @IsNotEmpty()
  topic: string;

  @ApiProperty({
    description: 'FCM tokens to subscribe',
    type: [String],
    required: false,
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  tokens?: string[];
}

export class TestNotificationDto {
  @ApiProperty({
    description: 'Test notification message',
    required: false,
    default: 'This is a test notification',
  })
  @IsOptional()
  @IsString()
  message?: string;

  @ApiProperty({
    description: 'Include device info in response',
    required: false,
    default: false,
  })
  @IsOptional()
  includeDeviceInfo?: boolean;
}
