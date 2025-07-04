import {
  Controller,
  Post,
  Body,
  HttpCode,
  HttpStatus,
  UseGuards,
  Request,
  Get,
  Patch,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiOkResponse,
  ApiCreatedResponse,
  ApiBadRequestResponse,
  ApiUnauthorizedResponse,
  ApiNotFoundResponse,
  ApiBearerAuth,
  ApiExcludeEndpoint,
} from '@nestjs/swagger';
import { AuthService } from './auth.service';
import {
  RegisterDto,
  PasswordResetRequestDto,
  PasswordResetDto,
  RefreshTokenDto,
  GoogleOAuthDto,
  AppleOAuthDto,
} from './dto';
import { UpdateConsentDto } from './dto/consent.dto';
import { LocalAuthGuard } from './guards/local-auth.guard';
import { GoogleAuthGuard } from './guards/google-auth.guard';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import {
  AuthenticatedRequest,
  GoogleOAuthRequest,
} from './interfaces/auth-request.interface';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Register a new user account' })
  @ApiCreatedResponse({
    description: 'User registered successfully',
    schema: {
      type: 'object',
      properties: {
        user: {
          type: 'object',
          properties: {
            id: { type: 'string', example: 'user_123' },
            email: { type: 'string', example: 'user@example.com' },
            firstName: { type: 'string', example: 'John' },
            lastName: { type: 'string', example: 'Doe' },
            isEmailVerified: { type: 'boolean', example: false },
            createdAt: { type: 'string', format: 'date-time' },
          },
        },
        accessToken: { type: 'string' },
        refreshToken: { type: 'string' },
        expiresIn: { type: 'number', example: 3600 },
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Invalid input data or email already exists',
  })
  async register(@Body() registerDto: RegisterDto) {
    return await this.authService.register(registerDto);
  }

  @UseGuards(LocalAuthGuard)
  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login with email and password' })
  @ApiOkResponse({
    description: 'Login successful',
    schema: {
      type: 'object',
      properties: {
        user: {
          type: 'object',
          properties: {
            id: { type: 'string', example: 'user_123' },
            email: { type: 'string', example: 'user@example.com' },
            firstName: { type: 'string', example: 'John' },
            lastName: { type: 'string', example: 'Doe' },
            isEmailVerified: { type: 'boolean', example: true },
            lastLoginAt: { type: 'string', format: 'date-time' },
          },
        },
        accessToken: { type: 'string' },
        refreshToken: { type: 'string' },
        expiresIn: { type: 'number', example: 3600 },
      },
    },
  })
  @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
  async login(@Request() req: AuthenticatedRequest) {
    return await this.authService.login(req.user);
  }

  @Get('google')
  @UseGuards(GoogleAuthGuard)
  @ApiOperation({ summary: 'Initiate Google OAuth flow' })
  @ApiExcludeEndpoint()
  async googleAuth() {
    // Initiates the Google OAuth flow
  }

  @Get('google/callback')
  @UseGuards(GoogleAuthGuard)
  @ApiOperation({ summary: 'Handle Google OAuth callback' })
  @ApiExcludeEndpoint()
  async googleAuthRedirect(@Request() req: GoogleOAuthRequest) {
    // Handle the Google OAuth callback
    const user = await this.authService.googleLogin(req.user);
    return await this.authService.login(user);
  }

  // Direct Google OAuth endpoint (for mobile/SPA)
  @Post('google')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login with Google OAuth token' })
  @ApiOkResponse({
    description: 'Google OAuth login successful',
    schema: {
      type: 'object',
      properties: {
        user: {
          type: 'object',
          properties: {
            id: { type: 'string', example: 'user_123' },
            email: { type: 'string', example: 'user@example.com' },
            firstName: { type: 'string', example: 'John' },
            lastName: { type: 'string', example: 'Doe' },
            googleId: { type: 'string', example: 'google_123' },
            avatar: {
              type: 'string',
              example: 'https://lh3.googleusercontent.com/...',
            },
            isEmailVerified: { type: 'boolean', example: true },
            lastLoginAt: { type: 'string', format: 'date-time' },
          },
        },
        accessToken: { type: 'string' },
        refreshToken: { type: 'string' },
        expiresIn: { type: 'number', example: 3600 },
      },
    },
  })
  @ApiUnauthorizedResponse({ description: 'Invalid Google OAuth token' })
  async googleLogin(@Body() googleOAuthDto: GoogleOAuthDto) {
    const user = await this.authService.googleLogin(googleOAuthDto);
    return await this.authService.login(user);
  }

  @Post('apple')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login with Apple Sign-In token' })
  @ApiOkResponse({
    description: 'Apple Sign-In login successful',
    schema: {
      type: 'object',
      properties: {
        user: {
          type: 'object',
          properties: {
            id: { type: 'string', example: 'user_123' },
            email: { type: 'string', example: 'user@example.com' },
            firstName: { type: 'string', example: 'John' },
            lastName: { type: 'string', example: 'Doe' },
            appleId: { type: 'string', example: 'apple_123' },
            isEmailVerified: { type: 'boolean', example: true },
            lastLoginAt: { type: 'string', format: 'date-time' },
          },
        },
        accessToken: { type: 'string' },
        refreshToken: { type: 'string' },
        expiresIn: { type: 'number', example: 3600 },
      },
    },
  })
  @ApiUnauthorizedResponse({ description: 'Invalid Apple Sign-In token' })
  async appleAuth(@Body() appleOAuthDto: AppleOAuthDto) {
    // Handle Apple Sign-In token from client
    const user = await this.authService.appleLogin(appleOAuthDto);
    return await this.authService.login(user);
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Refresh access token' })
  @ApiOkResponse({
    description: 'Token refreshed successfully',
    schema: {
      type: 'object',
      properties: {
        accessToken: { type: 'string' },
        refreshToken: { type: 'string' },
        expiresIn: { type: 'number', example: 3600 },
      },
    },
  })
  @ApiUnauthorizedResponse({ description: 'Invalid refresh token' })
  async refreshToken(@Body() refreshTokenDto: RefreshTokenDto) {
    return await this.authService.refreshToken(refreshTokenDto.refreshToken);
  }

  @Post('password-reset-request')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Request password reset' })
  @ApiOkResponse({
    description: 'Password reset email sent successfully',
    schema: {
      type: 'object',
      properties: {
        message: { type: 'string', example: 'Password reset email sent' },
        email: { type: 'string', example: 'user@example.com' },
      },
    },
  })
  @ApiNotFoundResponse({ description: 'Email not found' })
  async requestPasswordReset(
    @Body() passwordResetRequestDto: PasswordResetRequestDto,
  ) {
    return await this.authService.requestPasswordReset(
      passwordResetRequestDto.email,
    );
  }

  @Post('password-reset')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Reset password with token' })
  @ApiOkResponse({
    description: 'Password reset successfully',
    schema: {
      type: 'object',
      properties: {
        message: { type: 'string', example: 'Password reset successfully' },
        userId: { type: 'string', example: 'user_123' },
      },
    },
  })
  @ApiBadRequestResponse({ description: 'Invalid or expired reset token' })
  async resetPassword(@Body() passwordResetDto: PasswordResetDto) {
    return await this.authService.resetPassword(
      passwordResetDto.token,
      passwordResetDto.newPassword,
    );
  }

  // Consent management endpoints
  @UseGuards(JwtAuthGuard)
  @Get('consent')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get user consent preferences' })
  @ApiBearerAuth('JWT-auth')
  @ApiOkResponse({
    description: 'User consent preferences retrieved successfully',
    schema: {
      type: 'object',
      properties: {
        userId: { type: 'string', example: 'user_123' },
        dataProcessingConsent: { type: 'boolean', example: true },
        marketingConsent: { type: 'boolean', example: false },
        analyticsConsent: { type: 'boolean', example: true },
        thirdPartyConsent: { type: 'boolean', example: false },
        consentGivenAt: { type: 'string', format: 'date-time' },
        consentVersion: { type: 'string', example: '1.0' },
      },
    },
  })
  @ApiUnauthorizedResponse({ description: 'Unauthorized' })
  async getConsent(@Request() req: AuthenticatedRequest) {
    return await this.authService.getUserConsent(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Patch('consent')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Update user consent preferences' })
  @ApiBearerAuth('JWT-auth')
  @ApiOkResponse({
    description: 'User consent preferences updated successfully',
    schema: {
      type: 'object',
      properties: {
        userId: { type: 'string', example: 'user_123' },
        dataProcessingConsent: { type: 'boolean', example: true },
        marketingConsent: { type: 'boolean', example: false },
        analyticsConsent: { type: 'boolean', example: true },
        thirdPartyConsent: { type: 'boolean', example: false },
        consentGivenAt: { type: 'string', format: 'date-time' },
        consentVersion: { type: 'string', example: '1.0' },
        updatedAt: { type: 'string', format: 'date-time' },
      },
    },
  })
  @ApiUnauthorizedResponse({ description: 'Unauthorized' })
  async updateConsent(
    @Request() req: AuthenticatedRequest,
    @Body() updateConsentDto: UpdateConsentDto,
  ) {
    return await this.authService.updateUserConsent(
      req.user.id,
      updateConsentDto,
    );
  }
}
