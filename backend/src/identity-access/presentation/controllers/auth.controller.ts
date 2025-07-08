import {
  Controller,
  Post,
  Body,
  HttpCode,
  HttpStatus,
  UseGuards,
  Request,
} from '@nestjs/common';
import { AuthService } from '../../application/services/auth.service';
import {
  RegisterDto,
  LoginDto,
  GuestLoginDto,
  ConvertGuestDto,
  RefreshTokenDto,
  AuthResponseDto,
} from '../dtos/auth.dto';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  async register(@Body() registerDto: RegisterDto): Promise<AuthResponseDto> {
    const result = await this.authService.registerWithEmail(registerDto);

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
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    };
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Body() loginDto: LoginDto): Promise<AuthResponseDto> {
    const result = await this.authService.loginWithEmail(
      loginDto.email,
      loginDto.password,
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
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    };
  }

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
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
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
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
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
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    };
  }

  @Post('convert-guest')
  @UseGuards(JwtAuthGuard)
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
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    };
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  async refreshToken(
    @Body() refreshTokenDto: RefreshTokenDto,
  ): Promise<{ accessToken: string; refreshToken: string }> {
    return this.authService.refreshToken(refreshTokenDto.refreshToken);
  }

  @Post('logout')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  async logout(@Request() req: { user: { id: string } }): Promise<void> {
    await this.authService.logout(req.user.id);
  }

  @Post('social/google')
  @HttpCode(HttpStatus.OK)
  async googleSignIn(
    @Body() body: { idToken: string },
  ): Promise<AuthResponseDto> {
    const result = await this.authService.signInWithGoogle(body.idToken);

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
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    };
  }

  @Post('social/apple')
  @HttpCode(HttpStatus.OK)
  async appleSignIn(
    @Body() body: { idToken: string },
  ): Promise<AuthResponseDto> {
    const result = await this.authService.signInWithApple(body.idToken);

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
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    };
  }
}
