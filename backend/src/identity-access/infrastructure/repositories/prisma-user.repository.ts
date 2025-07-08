/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/database/prisma.service';
import { UserRepository } from '../../domain/repositories/user.repository';
import {
  UserAccount,
  UserProfile,
  UnitPreferences,
  EmergencyContact,
} from '../../domain/entities/user.entity';

@Injectable()
export class PrismaUserRepository implements UserRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: string): Promise<UserAccount | null> {
    const user = await this.prisma.userAccount.findUnique({
      where: { id },
    });

    if (!user) return null;

    return new UserAccount(
      user.id,
      user.email || undefined,
      user.phoneNumber || undefined,
      user.isEmailVerified,
      user.isPhoneVerified,
      user.isGuest,
      user.deviceId || undefined,
      user.createdAt,
      user.lastLoginAt,
      user.updatedAt,
    );
  }

  async findByEmail(email: string): Promise<UserAccount | null> {
    const user = await this.prisma.userAccount.findUnique({
      where: { email },
    });

    if (!user) return null;

    return new UserAccount(
      user.id,
      user.email || undefined,
      user.phoneNumber || undefined,
      user.isEmailVerified,
      user.isPhoneVerified,
      user.isGuest,
      user.deviceId || undefined,
      user.createdAt,
      user.lastLoginAt,
      user.updatedAt,
    );
  }

  async findByPhoneNumber(phoneNumber: string): Promise<UserAccount | null> {
    const user = await this.prisma.userAccount.findUnique({
      where: { phoneNumber },
    });

    if (!user) return null;

    return new UserAccount(
      user.id,
      user.email || undefined,
      user.phoneNumber || undefined,
      user.isEmailVerified,
      user.isPhoneVerified,
      user.isGuest,
      user.deviceId || undefined,
      user.createdAt,
      user.lastLoginAt,
      user.updatedAt,
    );
  }

  async findByDeviceId(deviceId: string): Promise<UserAccount | null> {
    const user = await this.prisma.userAccount.findFirst({
      where: { deviceId },
    });

    if (!user) return null;

    return new UserAccount(
      user.id,
      user.email || undefined,
      user.phoneNumber || undefined,
      user.isEmailVerified,
      user.isPhoneVerified,
      user.isGuest,
      user.deviceId || undefined,
      user.createdAt,
      user.lastLoginAt,
      user.updatedAt,
    );
  }

  async create(user: UserAccount): Promise<UserAccount> {
    const created = await this.prisma.userAccount.create({
      data: {
        id: user.id,
        email: user.email,
        phoneNumber: user.phoneNumber,
        isEmailVerified: user.isEmailVerified,
        isPhoneVerified: user.isPhoneVerified,
        isGuest: user.isGuest,
        deviceId: user.deviceId,
        lastLoginAt: user.lastLoginAt,
      },
    });

    return new UserAccount(
      created.id,
      created.email || undefined,
      created.phoneNumber || undefined,
      created.isEmailVerified,
      created.isPhoneVerified,
      created.isGuest,
      created.deviceId || undefined,
      created.createdAt,
      created.lastLoginAt,
      created.updatedAt,
    );
  }

  async update(
    id: string,
    updates: Partial<UserAccount>,
  ): Promise<UserAccount> {
    const updated = await this.prisma.userAccount.update({
      where: { id },
      data: {
        email: updates.email,
        phoneNumber: updates.phoneNumber,
        isEmailVerified: updates.isEmailVerified,
        isPhoneVerified: updates.isPhoneVerified,
        isGuest: updates.isGuest,
        deviceId: updates.deviceId,
        lastLoginAt: updates.lastLoginAt,
      },
    });

    return new UserAccount(
      updated.id,
      updated.email || undefined,
      updated.phoneNumber || undefined,
      updated.isEmailVerified,
      updated.isPhoneVerified,
      updated.isGuest,
      updated.deviceId || undefined,
      updated.createdAt,
      updated.lastLoginAt,
      updated.updatedAt,
    );
  }

  async delete(id: string): Promise<void> {
    await this.prisma.userAccount.delete({
      where: { id },
    });
  }

  async findProfileByUserId(userId: string): Promise<UserProfile | null> {
    const profile = await this.prisma.userProfile.findUnique({
      where: { userId },
    });

    if (!profile) return null;

    return new UserProfile(
      profile.id,
      profile.userId,
      profile.displayName,
      profile.firstName || undefined,
      profile.lastName || undefined,
      profile.dateOfBirth || undefined,
      profile.gender || undefined,
      profile.language,
      profile.photoUrl || undefined,
      profile.useElderMode,
      profile.preferredUnits as unknown as UnitPreferences,
      profile.emergencyContact as unknown as EmergencyContact | undefined,
      profile.createdAt,
      profile.updatedAt,
    );
  }

  async createProfile(profile: UserProfile): Promise<UserProfile> {
    const created = await this.prisma.userProfile.create({
      data: {
        id: profile.id,
        userId: profile.userId,
        displayName: profile.displayName,
        firstName: profile.firstName,
        lastName: profile.lastName,
        dateOfBirth: profile.dateOfBirth,
        gender: profile.gender,
        language: profile.language,
        photoUrl: profile.photoUrl,
        useElderMode: profile.useElderMode,
        preferredUnits: profile.preferredUnits as unknown as any,
        emergencyContact: profile.emergencyContact as unknown as any,
      },
    });

    return new UserProfile(
      created.id,
      created.userId,
      created.displayName,
      created.firstName || undefined,
      created.lastName || undefined,
      created.dateOfBirth || undefined,
      created.gender || undefined,
      created.language,
      created.photoUrl || undefined,
      created.useElderMode,
      created.preferredUnits as unknown as UnitPreferences,
      created.emergencyContact as unknown as EmergencyContact | undefined,
      created.createdAt,
      created.updatedAt,
    );
  }

  async updateProfile(
    userId: string,
    updates: Partial<UserProfile>,
  ): Promise<UserProfile> {
    const updated = await this.prisma.userProfile.update({
      where: { userId },
      data: {
        displayName: updates.displayName,
        firstName: updates.firstName,
        lastName: updates.lastName,
        dateOfBirth: updates.dateOfBirth,
        gender: updates.gender,
        language: updates.language,
        photoUrl: updates.photoUrl,
        useElderMode: updates.useElderMode,
        preferredUnits: updates.preferredUnits as unknown as any,
        emergencyContact: updates.emergencyContact as unknown as any,
      },
    });

    return new UserProfile(
      updated.id,
      updated.userId,
      updated.displayName,
      updated.firstName || undefined,
      updated.lastName || undefined,
      updated.dateOfBirth || undefined,
      updated.gender || undefined,
      updated.language,
      updated.photoUrl || undefined,
      updated.useElderMode,
      updated.preferredUnits as unknown as UnitPreferences,
      updated.emergencyContact as unknown as EmergencyContact | undefined,
      updated.createdAt,
      updated.updatedAt,
    );
  }

  async deleteProfile(userId: string): Promise<void> {
    await this.prisma.userProfile.delete({
      where: { userId },
    });
  }
}
