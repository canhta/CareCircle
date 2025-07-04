import {
  Controller,
  Post,
  Delete,
  Body,
  UseGuards,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { FirebaseService } from './firebase.service';
import { User } from '@prisma/client';

export class RegisterTokenDto {
  token: string;
  deviceType: 'ios' | 'android' | 'web';
}

export class RemoveTokenDto {
  token: string;
}

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
    @Body() dto: RegisterTokenDto,
  ) {
    await this.firebaseService.storeUserToken(
      user.id,
      dto.token,
      dto.deviceType,
    );

    return {
      statusCode: HttpStatus.CREATED,
      message: 'FCM token registered successfully',
    };
  }

  @Delete('tokens/remove')
  @ApiOperation({ summary: 'Remove FCM token' })
  @ApiResponse({
    status: 200,
    description: 'Token removed successfully',
  })
  async removeToken(@CurrentUser() user: User, @Body() dto: RemoveTokenDto) {
    await this.firebaseService.removeUserToken(user.id, dto.token);

    return {
      statusCode: HttpStatus.OK,
      message: 'FCM token removed successfully',
    };
  }

  @Post('test-notification')
  @ApiOperation({ summary: 'Send test push notification (development only)' })
  @ApiResponse({
    status: 200,
    description: 'Test notification sent',
  })
  async sendTestNotification(@CurrentUser() user: User) {
    const tokens = await this.firebaseService.getUserTokens(user.id);

    if (tokens.length === 0) {
      return {
        statusCode: HttpStatus.OK,
        message: 'No FCM tokens found for user',
      };
    }

    const result = await this.firebaseService.sendToDevices({
      title: '🔔 Test Notification',
      body: `Hi ${user.firstName}, this is a test notification from CareCircle!`,
      tokens,
      data: {
        type: 'test',
        userId: user.id,
      },
    });

    return {
      statusCode: HttpStatus.OK,
      message: 'Test notification sent successfully',
      data: {
        success: result.success,
        successCount: result.successCount,
        failureCount: result.failureCount,
      },
    };
  }
}
