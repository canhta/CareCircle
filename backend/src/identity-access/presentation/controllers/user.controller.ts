import {
  Controller,
  Get,
  Put,
  Body,
  UseGuards,
  Request,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { UserService } from '../../application/services/user.service';
import { UpdateProfileDto, ProfileResponseDto } from '../dtos/auth.dto';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';

@Controller('user')
@UseGuards(JwtAuthGuard)
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get('profile')
  async getProfile(
    @Request() req: { user: { id: string } },
  ): Promise<ProfileResponseDto> {
    const profile = await this.userService.getProfile(req.user.id);

    return {
      id: profile.id,
      displayName: profile.displayName,
      firstName: profile.firstName,
      lastName: profile.lastName,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      language: profile.language,
      photoUrl: profile.photoUrl,
      useElderMode: profile.useElderMode,
      preferredUnits: profile.preferredUnits,
      emergencyContact: profile.emergencyContact,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    };
  }

  @Put('profile')
  @HttpCode(HttpStatus.OK)
  async updateProfile(
    @Request() req: { user: { id: string } },
    @Body() updateProfileDto: UpdateProfileDto,
  ): Promise<ProfileResponseDto> {
    const profile = await this.userService.updateProfile(
      req.user.id,
      updateProfileDto,
    );

    return {
      id: profile.id,
      displayName: profile.displayName,
      firstName: profile.firstName,
      lastName: profile.lastName,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      language: profile.language,
      photoUrl: profile.photoUrl,
      useElderMode: profile.useElderMode,
      preferredUnits: profile.preferredUnits,
      emergencyContact: profile.emergencyContact,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    };
  }

  @Get('me')
  async getCurrentUser(@Request() req: { user: { id: string } }): Promise<{
    user: {
      id: string;
      email?: string;
      phoneNumber?: string;
      isEmailVerified: boolean;
      isPhoneVerified: boolean;
      isGuest: boolean;
      createdAt: Date;
      lastLoginAt: Date;
    };
    profile: ProfileResponseDto | null;
  }> {
    const { user, profile } = await this.userService.getUserWithProfile(
      req.user.id,
    );

    return {
      user: {
        id: user.id,
        email: user.email,
        phoneNumber: user.phoneNumber,
        isEmailVerified: user.isEmailVerified,
        isPhoneVerified: user.isPhoneVerified,
        isGuest: user.isGuest,
        createdAt: user.createdAt,
        lastLoginAt: user.lastLoginAt,
      },
      profile: profile
        ? {
            id: profile.id,
            displayName: profile.displayName,
            firstName: profile.firstName,
            lastName: profile.lastName,
            dateOfBirth: profile.dateOfBirth,
            gender: profile.gender,
            language: profile.language,
            photoUrl: profile.photoUrl,
            useElderMode: profile.useElderMode,
            preferredUnits: profile.preferredUnits,
            emergencyContact: profile.emergencyContact,
            createdAt: profile.createdAt,
            updatedAt: profile.updatedAt,
          }
        : null,
    };
  }
}
