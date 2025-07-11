import {
  Controller,
  Post,
  Body,
  HttpCode,
  HttpStatus,
  UseGuards,
  Request,
  BadRequestException,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import {
  AuthService,
  LoginResult,
} from '../../application/services/auth.service';
import {
  GuestLoginDto,
  ConvertGuestDto,
  AuthResponseDto,
  OAuthLoginDto,
  LinkOAuthProviderDto,
  FirebaseLoginDto,
  FirebaseRegisterDto,
} from '../dtos/auth.dto';
import {
  FirebaseAuthGuard,
  FirebaseUserPayload,
} from '../guards/firebase-auth.guard';

@ApiTags('Authentication')
@Controller('auth')
export class AuthController {
  private readonly logger = new Logger(AuthController.name);

  constructor(private readonly authService: AuthService) {}

  @Post('firebase-login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Login with Firebase ID token',
    description:
      'Authenticate user using Firebase ID token from email/password authentication',
  })
  @ApiResponse({
    status: 200,
    description: 'User successfully authenticated',
    type: AuthResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid Firebase ID token',
  })
  @ApiResponse({
    status: 500,
    description: 'Internal server error',
  })
  async firebaseLogin(
    @Body() firebaseLoginDto: FirebaseLoginDto,
  ): Promise<AuthResponseDto> {
    try {
      this.logger.log('Firebase login attempt');
      const result = await this.authService.loginWithFirebaseToken(
        firebaseLoginDto.idToken,
      );
      this.logger.log(`Firebase login successful for user: ${result.user.id}`);
      return this.formatAuthResponse(result);
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      const errorStack = error instanceof Error ? error.stack : undefined;
      this.logger.error('Firebase login failed', errorStack);
      if (errorMessage.includes('Firebase')) {
        throw new BadRequestException('Invalid Firebase ID token');
      }
      throw new InternalServerErrorException('Authentication failed');
    }
  }

  @Post('firebase-register')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Register new user with Firebase ID token',
    description:
      'Create new user account using Firebase ID token with profile information',
  })
  @ApiResponse({
    status: 201,
    description: 'User successfully registered',
    type: AuthResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid Firebase ID token or user already exists',
  })
  @ApiResponse({
    status: 500,
    description: 'Internal server error',
  })
  async firebaseRegister(
    @Body() firebaseRegisterDto: FirebaseRegisterDto,
  ): Promise<AuthResponseDto> {
    try {
      this.logger.log('Firebase registration attempt');
      const result = await this.authService.registerWithFirebaseToken(
        firebaseRegisterDto.idToken,
        {
          displayName: firebaseRegisterDto.displayName || 'User',
          firstName: firebaseRegisterDto.firstName,
          lastName: firebaseRegisterDto.lastName,
        },
      );
      this.logger.log(
        `Firebase registration successful for user: ${result.user.id}`,
      );
      return this.formatAuthResponse(result);
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      const errorStack = error instanceof Error ? error.stack : undefined;
      this.logger.error('Firebase registration failed', errorStack);
      if (errorMessage.includes('already exists')) {
        throw new BadRequestException(
          'User already exists with this Firebase UID',
        );
      }
      if (errorMessage.includes('Firebase')) {
        throw new BadRequestException('Invalid Firebase ID token');
      }
      throw new InternalServerErrorException('Registration failed');
    }
  }

  @Post('guest')
  @UseGuards(FirebaseAuthGuard)
  @ApiBearerAuth()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Login as guest user',
    description:
      'Create or login guest user using Firebase anonymous authentication',
  })
  @ApiResponse({
    status: 200,
    description: 'Guest user successfully authenticated',
    type: AuthResponseDto,
  })
  @ApiResponse({
    status: 401,
    description: 'Invalid Firebase anonymous token',
  })
  @ApiResponse({
    status: 500,
    description: 'Internal server error',
  })
  async loginAsGuest(
    @Request() req: { user: FirebaseUserPayload },
    @Body() guestLoginDto: GuestLoginDto,
  ): Promise<AuthResponseDto> {
    try {
      this.logger.log(
        `Guest login attempt for Firebase UID: ${req.user.firebaseUid}`,
      );
      const result = await this.authService.loginAsGuest(
        req.user.firebaseUid,
        guestLoginDto.deviceId,
      );
      this.logger.log(`Guest login successful for user: ${result.user.id}`);
      return this.formatAuthResponse(result);
    } catch (error) {
      const errorStack = error instanceof Error ? error.stack : undefined;
      this.logger.error('Guest login failed', errorStack);
      throw new InternalServerErrorException('Guest authentication failed');
    }
  }

  @Post('convert-guest')
  @UseGuards(FirebaseAuthGuard)
  @ApiBearerAuth()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Convert guest account to registered user',
    description:
      'Convert existing guest account to permanent registered user account',
  })
  @ApiResponse({
    status: 200,
    description: 'Guest account successfully converted',
    type: AuthResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid conversion data or user is not a guest',
  })
  @ApiResponse({
    status: 401,
    description: 'Unauthorized - invalid token',
  })
  @ApiResponse({
    status: 500,
    description: 'Internal server error',
  })
  async convertGuest(
    @Request() req: { user: FirebaseUserPayload },
    @Body() convertGuestDto: ConvertGuestDto,
  ): Promise<AuthResponseDto> {
    try {
      this.logger.log(`Guest conversion attempt for user: ${req.user.id}`);
      const result = await this.authService.convertGuestToRegistered(
        req.user.id,
        convertGuestDto,
      );
      this.logger.log(
        `Guest conversion successful for user: ${result.user.id}`,
      );
      return this.formatAuthResponse(result);
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      const errorStack = error instanceof Error ? error.stack : undefined;
      this.logger.error('Guest conversion failed', errorStack);
      if (errorMessage.includes('not a guest')) {
        throw new BadRequestException('User is not a guest account');
      }
      if (errorMessage.includes('already exists')) {
        throw new BadRequestException('Email or phone number already in use');
      }
      throw new InternalServerErrorException('Guest conversion failed');
    }
  }

  @Post('oauth/google')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Sign in with Google',
    description: 'Authenticate user using Google OAuth via Firebase',
  })
  @ApiResponse({
    status: 200,
    description: 'Google sign-in successful',
    type: AuthResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid Google ID token',
  })
  @ApiResponse({
    status: 500,
    description: 'Internal server error',
  })
  async googleSignIn(
    @Body() oauthLoginDto: OAuthLoginDto,
  ): Promise<AuthResponseDto> {
    try {
      this.logger.log('Google sign-in attempt');
      const result = await this.authService.signInWithGoogle(
        oauthLoginDto.idToken,
      );
      this.logger.log(`Google sign-in successful for user: ${result.user.id}`);
      return this.formatAuthResponse(result);
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      const errorStack = error instanceof Error ? error.stack : undefined;
      this.logger.error('Google sign-in failed', errorStack);
      if (
        errorMessage.includes('Google') ||
        errorMessage.includes('Firebase')
      ) {
        throw new BadRequestException('Invalid Google ID token');
      }
      throw new InternalServerErrorException('Google authentication failed');
    }
  }

  @Post('oauth/apple')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Sign in with Apple',
    description: 'Authenticate user using Apple OAuth via Firebase',
  })
  @ApiResponse({
    status: 200,
    description: 'Apple sign-in successful',
    type: AuthResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid Apple ID token',
  })
  @ApiResponse({
    status: 500,
    description: 'Internal server error',
  })
  async appleSignIn(
    @Body() oauthLoginDto: OAuthLoginDto,
  ): Promise<AuthResponseDto> {
    try {
      this.logger.log('Apple sign-in attempt');
      const result = await this.authService.signInWithApple(
        oauthLoginDto.idToken,
      );
      this.logger.log(`Apple sign-in successful for user: ${result.user.id}`);
      return this.formatAuthResponse(result);
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      const errorStack = error instanceof Error ? error.stack : undefined;
      this.logger.error('Apple sign-in failed', errorStack);
      if (errorMessage.includes('Apple') || errorMessage.includes('Firebase')) {
        throw new BadRequestException('Invalid Apple ID token');
      }
      throw new InternalServerErrorException('Apple authentication failed');
    }
  }

  @Post('oauth/link')
  @UseGuards(FirebaseAuthGuard)
  @ApiBearerAuth()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Link OAuth provider to existing account',
    description: 'Link Google or Apple OAuth provider to existing user account',
  })
  @ApiResponse({
    status: 200,
    description: 'OAuth provider successfully linked',
    schema: {
      type: 'object',
      properties: {
        success: { type: 'boolean' },
        message: { type: 'string' },
      },
    },
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid provider data or provider already linked',
  })
  @ApiResponse({
    status: 401,
    description: 'Unauthorized - invalid token',
  })
  @ApiResponse({
    status: 500,
    description: 'Internal server error',
  })
  async linkOAuthProvider(
    @Request() req: { user: FirebaseUserPayload },
    @Body() linkOAuthDto: LinkOAuthProviderDto,
  ): Promise<{ success: boolean; message: string }> {
    try {
      this.logger.log(
        `OAuth link attempt for user: ${req.user.id}, provider: ${linkOAuthDto.providerId}`,
      );
      await this.authService.linkOAuthProvider(
        req.user.id,
        linkOAuthDto.providerId,
        linkOAuthDto.providerData,
      );
      this.logger.log(
        `OAuth provider ${linkOAuthDto.providerId} successfully linked for user: ${req.user.id}`,
      );
      return {
        success: true,
        message: `Successfully linked ${linkOAuthDto.providerId} account`,
      };
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      const errorStack = error instanceof Error ? error.stack : undefined;
      this.logger.error('OAuth provider linking failed', errorStack);
      if (errorMessage.includes('already linked')) {
        throw new BadRequestException(
          'OAuth provider already linked to this account',
        );
      }
      throw new InternalServerErrorException('Failed to link OAuth provider');
    }
  }

  /**
   * Helper method to format authentication responses consistently
   */
  private formatAuthResponse(result: LoginResult): AuthResponseDto {
    return {
      user: {
        id: result.user.id,
        email: result.user.email,
        phoneNumber: result.user.phoneNumber,
        isEmailVerified: result.user.isEmailVerified,
        isPhoneVerified: result.user.isPhoneVerified,
        isGuest: result.user.isGuest,
        createdAt: result.user.createdAt,
        lastLoginAt: result.user.lastLoginAt,
      },
      profile: result.profile
        ? {
            id: result.profile.id,
            displayName: result.profile.displayName,
            firstName: result.profile.firstName,
            lastName: result.profile.lastName,
            dateOfBirth: result.profile.dateOfBirth,
            gender: result.profile.gender,
            language: result.profile.language,
            photoUrl: result.profile.photoUrl,
            useElderMode: result.profile.useElderMode,
            preferredUnits: result.profile.preferredUnits,
            emergencyContact: result.profile.emergencyContact,
          }
        : undefined,
    };
  }
}
