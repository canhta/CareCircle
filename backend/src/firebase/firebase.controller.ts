import {
  Controller,
  Post,
  Delete,
  Body,
  UseGuards,
  HttpStatus,
  ValidationPipe,
  Get,
  Query,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiQuery,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { FirebaseService } from './firebase.service';
import { User } from '@prisma/client';
import {
  RegisterTokenDto,
  RemoveTokenDto,
  SendNotificationDto,
  SubscribeTopicDto,
  TestNotificationDto,
} from './dto/firebase.dto';

@ApiTags('firebase')
@ApiBearerAuth()
@Controller('firebase')
@UseGuards(JwtAuthGuard)
export class FirebaseController {
  constructor(private readonly firebaseService: FirebaseService) {}

  @Post('tokens/register')
  @ApiOperation({ summary: 'Register FCM token for push notifications' })
  @ApiResponse({
    status: 201,
    description: 'Token registered successfully',
  })
  async registerToken(
    @CurrentUser() user: User,
    @Body(ValidationPipe) dto: RegisterTokenDto,
  ) {
    const result = await this.firebaseService.storeUserToken(
      user.id,
      dto.token,
      dto.deviceType,
      dto.deviceInfo,
    );

    return {
      statusCode: HttpStatus.CREATED,
      message: 'FCM token registered successfully',
      data: result,
    };
  }

  @Delete('tokens/remove')
  @ApiOperation({ summary: 'Remove FCM token' })
  @ApiResponse({
    status: 200,
    description: 'Token removed successfully',
  })
  async removeToken(
    @CurrentUser() user: User,
    @Body(ValidationPipe) dto: RemoveTokenDto,
  ) {
    await this.firebaseService.removeUserToken(user.id, dto.token);

    return {
      statusCode: HttpStatus.OK,
      message: 'FCM token removed successfully',
    };
  }

  @Get('tokens')
  @ApiOperation({ summary: 'Get user FCM tokens' })
  @ApiResponse({
    status: 200,
    description: 'Tokens retrieved successfully',
  })
  @ApiQuery({ name: 'active', required: false, type: Boolean })
  async getUserTokens(
    @CurrentUser() user: User,
    @Query('active') activeOnly?: boolean,
  ) {
    const tokens = await this.firebaseService.getUserTokens(
      user.id,
      activeOnly,
    );

    return {
      statusCode: HttpStatus.OK,
      message: 'Tokens retrieved successfully',
      data: {
        tokens,
        count: tokens.length,
      },
    };
  }

  @Post('topics/subscribe')
  @ApiOperation({ summary: 'Subscribe to notification topic' })
  @ApiResponse({
    status: 200,
    description: 'Successfully subscribed to topic',
  })
  async subscribeToTopic(
    @CurrentUser() user: User,
    @Body(ValidationPipe) dto: SubscribeTopicDto,
  ) {
    const tokens =
      dto.tokens || (await this.firebaseService.getUserTokens(user.id));

    if (tokens.length === 0) {
      return {
        statusCode: HttpStatus.OK,
        message: 'No tokens available for subscription',
      };
    }

    await this.firebaseService.subscribeToTopic(tokens, dto.topic);

    return {
      statusCode: HttpStatus.OK,
      message: `Successfully subscribed to topic: ${dto.topic}`,
      data: {
        topic: dto.topic,
        tokenCount: tokens.length,
      },
    };
  }

  @Post('topics/unsubscribe')
  @ApiOperation({ summary: 'Unsubscribe from notification topic' })
  @ApiResponse({
    status: 200,
    description: 'Successfully unsubscribed from topic',
  })
  async unsubscribeFromTopic(
    @CurrentUser() user: User,
    @Body(ValidationPipe) dto: SubscribeTopicDto,
  ) {
    const tokens =
      dto.tokens || (await this.firebaseService.getUserTokens(user.id));

    if (tokens.length === 0) {
      return {
        statusCode: HttpStatus.OK,
        message: 'No tokens available for unsubscription',
      };
    }

    await this.firebaseService.unsubscribeFromTopic(tokens, dto.topic);

    return {
      statusCode: HttpStatus.OK,
      message: `Successfully unsubscribed from topic: ${dto.topic}`,
      data: {
        topic: dto.topic,
        tokenCount: tokens.length,
      },
    };
  }

  @Post('notifications/send')
  @ApiOperation({ summary: 'Send notification to users (admin only)' })
  @ApiResponse({
    status: 200,
    description: 'Notification sent successfully',
  })
  async sendNotification(
    @CurrentUser() user: User,
    @Body(ValidationPipe) dto: SendNotificationDto,
  ) {
    // TODO: Add admin role check
    const results = await this.firebaseService.sendNotificationToUsers(dto);

    return {
      statusCode: HttpStatus.OK,
      message: 'Notification sent successfully',
      data: results,
    };
  }

  @Post('test-notification')
  @ApiOperation({ summary: 'Send test push notification' })
  @ApiResponse({
    status: 200,
    description: 'Test notification sent',
  })
  async sendTestNotification(
    @CurrentUser() user: User,
    @Body(ValidationPipe) dto: TestNotificationDto,
  ) {
    const tokens = await this.firebaseService.getUserTokens(user.id);

    if (tokens.length === 0) {
      return {
        statusCode: HttpStatus.OK,
        message: 'No FCM tokens found for user',
      };
    }

    const testMessage =
      dto.message ||
      `Hi ${user.firstName}, this is a test notification from CareCircle!`;

    const result = await this.firebaseService.sendToDevices({
      title: '🔔 Test Notification',
      body: testMessage,
      tokens,
      data: {
        type: 'test',
        userId: user.id,
        timestamp: new Date().toISOString(),
      },
    });

    const deviceInfo = dto.includeDeviceInfo
      ? await this.firebaseService.getDeviceInfo(user.id)
      : undefined;

    return {
      statusCode: HttpStatus.OK,
      message: 'Test notification sent successfully',
      data: {
        success: result.success,
        successCount: result.successCount,
        failureCount: result.failureCount,
        responses: result.responses,
        deviceInfo,
      },
    };
  }

  @Post('tokens/cleanup')
  @ApiOperation({ summary: 'Clean up invalid tokens' })
  @ApiResponse({
    status: 200,
    description: 'Token cleanup completed',
  })
  async cleanupTokens(@CurrentUser() user: User) {
    const result = await this.firebaseService.cleanupInvalidTokens(user.id);

    return {
      statusCode: HttpStatus.OK,
      message: 'Token cleanup completed',
      data: result,
    };
  }

  @Get('health')
  @ApiOperation({ summary: 'Check Firebase service health' })
  @ApiResponse({
    status: 200,
    description: 'Service health status',
  })
  async getHealthStatus() {
    const health = await this.firebaseService.getHealthStatus();

    return {
      statusCode: HttpStatus.OK,
      message: 'Firebase service health status',
      data: health,
    };
  }
}
