import {
  Controller,
  Post,
  Get,
  Put,
  Body,
  UseGuards,
  Request,
  HttpCode,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import {
  AuthService,
  LoginResult,
} from '../../application/services/auth.service';
import { UserService } from '../../application/services/user.service';
import {
  GuestLoginDto,
  ConvertGuestDto,
  AuthResponseDto,
  OAuthLoginDto,
  LinkOAuthProviderDto,
  FirebaseLoginDto,
  FirebaseRegisterDto,
  UpdateProfileDto,
  ProfileResponseDto,
} from '../dtos/auth.dto';
import {
  FirebaseAuthGuard,
  FirebaseUserPayload,
} from '../guards/firebase-auth.guard';

@Controller('auth')
export class AuthController {
  private readonly logger = new Logger(AuthController.name);

  constructor(
    private readonly authService: AuthService,
    private readonly userService: UserService,
  ) {}

  @Post('firebase-login')
  @HttpCode(HttpStatus.OK)
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
        error instanceof Error ? error.message : 'Firebase login failed';
      this.logger.error(`Firebase login failed: ${errorMessage}`);
      throw new Error(errorMessage);
    }
  }

  @Post('firebase-register')
  @HttpCode(HttpStatus.CREATED)
  async firebaseRegister(
    @Body() firebaseRegisterDto: FirebaseRegisterDto,
  ): Promise<AuthResponseDto> {
    try {
      this.logger.log('Firebase registration attempt');
      const result = await this.authService.registerWithFirebaseToken(
        firebaseRegisterDto.idToken,
        {
          displayName: firebaseRegisterDto.displayName || '',
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
        error instanceof Error ? error.message : 'Firebase registration failed';
      this.logger.error(`Firebase registration failed: ${errorMessage}`);
      throw new Error(errorMessage);
    }
  }

  @Post('guest')
  @UseGuards(FirebaseAuthGuard)
  @HttpCode(HttpStatus.OK)
  async guestLogin(
    @Body() guestLoginDto: GuestLoginDto,
  ): Promise<AuthResponseDto> {
    try {
      this.logger.log(
        `Guest login attempt for device: ${guestLoginDto.deviceId}`,
      );
      const result = await this.authService.loginAsGuest(
        guestLoginDto.idToken,
        guestLoginDto.deviceId,
      );
      this.logger.log(`Guest login successful for user: ${result.user.id}`);
      return this.formatAuthResponse(result);
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Guest login failed';
      this.logger.error(`Guest login failed: ${errorMessage}`);
      throw new Error(errorMessage);
    }
  }

  @Post('convert-guest')
  @UseGuards(FirebaseAuthGuard)
  @HttpCode(HttpStatus.OK)
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
        error instanceof Error ? error.message : 'Guest conversion failed';
      this.logger.error(`Guest conversion failed: ${errorMessage}`);
      throw new Error(errorMessage);
    }
  }

  @Post('oauth/google')
  @HttpCode(HttpStatus.OK)
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
        error instanceof Error ? error.message : 'Google sign-in failed';
      this.logger.error(`Google sign-in failed: ${errorMessage}`);
      throw new Error(errorMessage);
    }
  }

  @Post('oauth/apple')
  @HttpCode(HttpStatus.OK)
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
        error instanceof Error ? error.message : 'Apple sign-in failed';
      this.logger.error(`Apple sign-in failed: ${errorMessage}`);
      throw new Error(errorMessage);
    }
  }

  @Post('oauth/link')
  @UseGuards(FirebaseAuthGuard)
  @HttpCode(HttpStatus.OK)
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
        error instanceof Error ? error.message : 'OAuth linking failed';
      this.logger.error(`OAuth linking failed: ${errorMessage}`);
      throw new Error(errorMessage);
    }
  }

  @Get('profile')
  @UseGuards(FirebaseAuthGuard)
  async getProfile(
    @Request() req: { user: FirebaseUserPayload },
  ): Promise<ProfileResponseDto> {
    try {
      const profile = await this.userService.getProfile(req.user.id);
      return profile as ProfileResponseDto;
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Failed to get profile';
      this.logger.error(`Get profile failed: ${errorMessage}`);
      throw new Error(errorMessage);
    }
  }

  @Put('profile')
  @UseGuards(FirebaseAuthGuard)
  async updateProfile(
    @Request() req: { user: FirebaseUserPayload },
    @Body() updateProfileDto: UpdateProfileDto,
  ): Promise<ProfileResponseDto> {
    try {
      const profile = await this.userService.updateProfile(
        req.user.id,
        updateProfileDto,
      );
      this.logger.log(`Profile updated for user: ${req.user.id}`);
      return profile as ProfileResponseDto;
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Failed to update profile';
      this.logger.error(`Update profile failed: ${errorMessage}`);
      throw new Error(errorMessage);
    }
  }

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
