import {
  Controller,
  Post,
  Body,
  HttpCode,
  HttpStatus,
  UseGuards,
  Request,
} from '@nestjs/common';
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
} from '../dtos/auth.dto';
import { FirebaseAuthGuard } from '../guards/firebase-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('firebase-login')
  @HttpCode(HttpStatus.OK)
  async firebaseLogin(
    @Body() body: { idToken: string },
  ): Promise<AuthResponseDto> {
    const result = await this.authService.loginWithFirebaseToken(body.idToken);

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

  @Post('firebase-register')
  @HttpCode(HttpStatus.CREATED)
  async firebaseRegister(
    @Body()
    body: {
      idToken: string;
      displayName?: string;
      firstName?: string;
      lastName?: string;
    },
  ): Promise<AuthResponseDto> {
    const result = await this.authService.registerWithFirebaseToken(
      body.idToken,
      {
        displayName: body.displayName || 'User',
        firstName: body.firstName,
        lastName: body.lastName,
      },
    );

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

  @Post('guest')
  @HttpCode(HttpStatus.OK)
  async loginAsGuest(
    @Body() guestLoginDto: GuestLoginDto,
  ): Promise<AuthResponseDto> {
    const result = await this.authService.loginAsGuest(guestLoginDto.deviceId);

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

  @Post('convert-guest')
  @UseGuards(FirebaseAuthGuard)
  @HttpCode(HttpStatus.OK)
  async convertGuest(
    @Request() req: { user: { id: string } },
    @Body() convertGuestDto: ConvertGuestDto,
  ): Promise<AuthResponseDto> {
    const result = await this.authService.convertGuestToRegistered(
      req.user.id,
      convertGuestDto,
    );

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

  @Post('oauth/google')
  @HttpCode(HttpStatus.OK)
  async googleSignIn(
    @Body() oauthLoginDto: OAuthLoginDto,
  ): Promise<AuthResponseDto> {
    const result = await this.authService.signInWithGoogle(
      oauthLoginDto.idToken,
    );

    return this.formatAuthResponse(result);
  }

  @Post('oauth/apple')
  @HttpCode(HttpStatus.OK)
  async appleSignIn(
    @Body() oauthLoginDto: OAuthLoginDto,
  ): Promise<AuthResponseDto> {
    const result = await this.authService.signInWithApple(
      oauthLoginDto.idToken,
    );

    return this.formatAuthResponse(result);
  }

  @Post('oauth/link')
  @UseGuards(FirebaseAuthGuard)
  @HttpCode(HttpStatus.OK)
  async linkOAuthProvider(
    @Request() req: { user: { id: string } },
    @Body() linkOAuthDto: LinkOAuthProviderDto,
  ): Promise<{ success: boolean; message: string }> {
    await this.authService.linkOAuthProvider(
      req.user.id,
      linkOAuthDto.providerId,
      linkOAuthDto.providerData,
    );

    return {
      success: true,
      message: `Successfully linked ${linkOAuthDto.providerId} account`,
    };
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
