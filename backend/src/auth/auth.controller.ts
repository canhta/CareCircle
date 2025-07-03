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

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  async register(@Body() registerDto: RegisterDto) {
    return await this.authService.register(registerDto);
  }

  @UseGuards(LocalAuthGuard)
  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Request() req: AuthenticatedRequest) {
    return await this.authService.login(req.user);
  }

  @Get('google')
  @UseGuards(GoogleAuthGuard)
  async googleAuth() {
    // Initiates the Google OAuth flow
  }

  @Get('google/callback')
  @UseGuards(GoogleAuthGuard)
  async googleAuthRedirect(@Request() req: GoogleOAuthRequest) {
    // Handle the Google OAuth callback
    const user = await this.authService.googleLogin(req.user);
    return await this.authService.login(user);
  }

  // Direct Google OAuth endpoint (for mobile/SPA)
  @Post('google')
  @HttpCode(HttpStatus.OK)
  async googleLogin(@Body() googleOAuthDto: GoogleOAuthDto) {
    const user = await this.authService.googleLogin(googleOAuthDto);
    return await this.authService.login(user);
  }

  @Post('apple')
  @HttpCode(HttpStatus.OK)
  async appleAuth(@Body() appleOAuthDto: AppleOAuthDto) {
    // Handle Apple Sign-In token from client
    const user = await this.authService.appleLogin(appleOAuthDto);
    return await this.authService.login(user);
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  async refreshToken(@Body() refreshTokenDto: RefreshTokenDto) {
    return await this.authService.refreshToken(refreshTokenDto.refreshToken);
  }

  @Post('password-reset-request')
  @HttpCode(HttpStatus.OK)
  async requestPasswordReset(
    @Body() passwordResetRequestDto: PasswordResetRequestDto,
  ) {
    return await this.authService.requestPasswordReset(
      passwordResetRequestDto.email,
    );
  }

  @Post('password-reset')
  @HttpCode(HttpStatus.OK)
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
  async getConsent(@Request() req: AuthenticatedRequest) {
    return await this.authService.getUserConsent(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Patch('consent')
  @HttpCode(HttpStatus.OK)
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
