import {
  Injectable,
  ConflictException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { UserService } from '../user/user.service';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';
import { User } from '@prisma/client';
import { JwtPayload } from './strategies/jwt.strategy';
import {
  RefreshTokenPayload,
  PasswordResetTokenPayload,
} from './interfaces/token-payloads.interface';
import {
  AuthenticatedUser,
  GoogleAuthData,
  AppleAuthData,
  UserConsentData,
} from '../common/interfaces/user.interfaces';

export interface LoginResponse {
  access_token: string;
  refresh_token: string;
  user: Omit<User, 'password'>;
}

export interface RegisterDto {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  phone?: string;
}

export interface LoginDto {
  email: string;
  password: string;
}

export interface PasswordResetPayload {
  sub: string;
  type: 'password_reset';
  iat?: number;
  exp?: number;
}

@Injectable()
export class AuthService {
  constructor(
    private userService: UserService,
    private prisma: PrismaService,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async register(registerDto: RegisterDto): Promise<User> {
    const { email, password, ...userData } = registerDto;

    // Check if user already exists
    const existingUser = await this.userService.findUserByEmail(email);
    if (existingUser) {
      throw new ConflictException('User with this email already exists');
    }

    // Hash password
    const saltRounds = 12;

    const hashedPassword = await bcrypt.hash(password, saltRounds);

    // Create user
    const user = await this.userService.createUser({
      email,

      password: hashedPassword,
      ...userData,
    });

    return user;
  }

  async validateUser(email: string, password: string): Promise<User | null> {
    const user = await this.userService.findUserByEmail(email);
    if (!user || !user.password) {
      return null;
    }

    // Check if user is active
    if (!user.isActive) {
      return null;
    }

    // Verify password

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return null;
    }

    return user;
  }

  async login(user: User | Omit<User, 'password'>): Promise<LoginResponse> {
    // Update last login
    await this.userService.updateLastLogin(user.id);

    // Generate tokens
    const payload: JwtPayload = {
      sub: user.id,
      email: user.email,
    };

    const accessToken = this.jwtService.sign(payload);
    const refreshToken = this.jwtService.sign(payload, {
      expiresIn: '7d',
      secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
    });

    // Remove password from response if it exists
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { password, ...userWithoutPassword } = user as User;

    return {
      access_token: accessToken,
      refresh_token: refreshToken,
      user: userWithoutPassword,
    };
  }

  async googleLogin(googleUser: GoogleAuthData): Promise<User> {
    const { email, firstName, lastName, picture, googleId } = googleUser;

    let user = await this.userService.findUserByEmail(email);

    if (!user) {
      // Create new user from Google profile
      user = await this.userService.createUser({
        email,
        firstName,
        lastName,
        avatar: picture,
        googleId,
        emailVerified: true, // Google emails are pre-verified
      });
    } else if (!user.googleId) {
      // Link existing user to Google
      user = await this.userService.updateUser(user.id, {
        googleId,
        avatar: picture || user.avatar,
      });
    }

    // Update last login
    await this.userService.updateLastLogin(user.id);

    return user;
  }

  async appleLogin(appleUser: AppleAuthData): Promise<User> {
    const { email, firstName, lastName, appleId } = appleUser;

    let user = await this.userService.findUserByEmail(email);

    if (!user) {
      // Create new user from Apple profile
      user = await this.userService.createUser({
        email,
        firstName: firstName || 'Apple',
        lastName: lastName || 'User',
        appleId,
        emailVerified: true, // Apple emails are pre-verified
      });
    } else if (!user.appleId) {
      // Link existing user to Apple
      user = await this.userService.updateUser(user.id, {
        appleId,
      });
    }

    // Update last login
    await this.userService.updateLastLogin(user.id);

    return user;
  }

  async refreshToken(refreshToken: string): Promise<{ access_token: string }> {
    try {
      const payload = this.jwtService.verify<RefreshTokenPayload>(
        refreshToken,
        {
          secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
        },
      );

      const user = await this.userService.findUserById(payload.sub);
      if (!user || !user.isActive) {
        throw new UnauthorizedException('Invalid refresh token');
      }

      const newPayload: JwtPayload = {
        sub: user.id,
        email: user.email,
      };

      const accessToken = this.jwtService.sign(newPayload);

      return { access_token: accessToken };
    } catch {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }

  async requestPasswordReset(email: string): Promise<{ message: string }> {
    const user = await this.userService.findUserByEmail(email);
    if (!user) {
      // Don't reveal whether user exists
      return { message: 'If the email exists, a reset link has been sent' };
    }

    // Generate reset token
    const resetPayload = {
      sub: user.id,
      type: 'password_reset',
    };

    const resetToken = this.jwtService.sign(resetPayload, {
      expiresIn: '1h',
      secret: this.configService.get<string>('JWT_PASSWORD_RESET_SECRET'),
    });

    // TODO: Send email with reset token
    // For now, we'll just return the token (remove this in production)
    console.log(`Password reset token for ${email}: ${resetToken}`);

    return { message: 'If the email exists, a reset link has been sent' };
  }

  async resetPassword(
    token: string,
    newPassword: string,
  ): Promise<{ message: string }> {
    try {
      const payload = this.jwtService.verify<PasswordResetTokenPayload>(token, {
        secret: this.configService.get<string>('JWT_PASSWORD_RESET_SECRET'),
      });

      if (payload.type !== 'password_reset') {
        throw new UnauthorizedException('Invalid reset token');
      }

      const user = await this.userService.findUserById(payload.sub);
      if (!user) {
        throw new UnauthorizedException('Invalid reset token');
      }

      // Hash new password
      const saltRounds = 12;
      const hashedPassword = await bcrypt.hash(newPassword, saltRounds);

      // Update password
      await this.userService.updateUser(user.id, {
        password: hashedPassword,
      });

      return { message: 'Password has been reset successfully' };
    } catch {
      throw new UnauthorizedException('Invalid or expired reset token');
    }
  }

  async updateUserConsent(
    userId: string,
    consentData: UserConsentData,
  ): Promise<{ message: string }> {
    await this.userService.updateUser(userId, {
      ...consentData,
      consentDate: new Date(),
    });

    return { message: 'Consent preferences updated successfully' };
  }

  async getUserConsent(userId: string): Promise<UserConsentData> {
    const user = await this.userService.findUserById(userId);
    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    return {
      dataProcessingConsent: user.dataProcessingConsent,
      marketingConsent: user.marketingConsent,
      analyticsConsent: user.analyticsConsent,
      healthDataSharingConsent: user.healthDataSharingConsent,
      consentVersion: user.consentVersion || undefined,
      consentDate: user.consentDate || undefined,
    };
  }
}
