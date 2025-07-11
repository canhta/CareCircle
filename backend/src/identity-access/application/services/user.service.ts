import { Injectable, NotFoundException } from '@nestjs/common';
import { UserRepository } from '../../domain/repositories/user.repository';
import {
  UserAccount,
  UserProfile,
  UnitPreferences,
  EmergencyContact,
} from '../../domain/entities/user.entity';
import { Gender, Language } from '@prisma/client';

export interface UpdateProfileData {
  displayName?: string;
  firstName?: string;
  lastName?: string;
  dateOfBirth?: Date;
  gender?: Gender;
  language?: Language;
  photoUrl?: string;
  useElderMode?: boolean;
  preferredUnits?: UnitPreferences;
  emergencyContact?: EmergencyContact;
}

@Injectable()
export class UserService {
  constructor(private readonly userRepository: UserRepository) {}

  async findById(id: string): Promise<UserAccount | null> {
    return this.userRepository.findById(id);
  }

  async findByEmail(email: string): Promise<UserAccount | null> {
    return this.userRepository.findByEmail(email);
  }

  async findByPhoneNumber(phoneNumber: string): Promise<UserAccount | null> {
    return this.userRepository.findByPhoneNumber(phoneNumber);
  }

  async createFromFirebaseToken(decodedToken: any): Promise<UserAccount> {
    // Create user account with Firebase UID as ID
    const user = UserAccount.create({
      id: decodedToken.uid,
      email: decodedToken.email,
      isGuest: !decodedToken.email, // If no email, it's likely an anonymous user
    });

    // Set email verification status if email exists
    if (decodedToken.email && decodedToken.email_verified) {
      user.verifyEmail();
    }

    const createdUser = await this.userRepository.create(user);

    // Create basic profile
    const profile = UserProfile.create({
      userId: createdUser.id,
      displayName: decodedToken.name ||
                   (decodedToken.email ? decodedToken.email.split('@')[0] : 'Guest User'),
      firstName: decodedToken.given_name,
      lastName: decodedToken.family_name,
    });
    await this.userRepository.createProfile(profile);

    return createdUser;
  }

  async getProfile(userId: string): Promise<UserProfile> {
    const profile = await this.userRepository.findProfileByUserId(userId);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }
    return profile;
  }

  async updateProfile(
    userId: string,
    updates: UpdateProfileData,
  ): Promise<UserProfile> {
    const existingProfile =
      await this.userRepository.findProfileByUserId(userId);
    if (!existingProfile) {
      throw new NotFoundException('User profile not found');
    }

    return this.userRepository.updateProfile(userId, updates);
  }

  async updateProfilePicture(
    userId: string,
    photoUrl: string,
  ): Promise<UserProfile> {
    return this.updateProfile(userId, { photoUrl });
  }

  async deleteProfilePicture(userId: string): Promise<UserProfile> {
    return this.updateProfile(userId, { photoUrl: undefined });
  }

  async updateEmergencyContact(
    userId: string,
    contact: EmergencyContact,
  ): Promise<UserProfile> {
    return this.updateProfile(userId, { emergencyContact: contact });
  }

  async updateUnitPreferences(
    userId: string,
    preferences: UnitPreferences,
  ): Promise<UserProfile> {
    return this.updateProfile(userId, { preferredUnits: preferences });
  }

  async enableElderMode(userId: string): Promise<UserProfile> {
    return this.updateProfile(userId, { useElderMode: true });
  }

  async disableElderMode(userId: string): Promise<UserProfile> {
    return this.updateProfile(userId, { useElderMode: false });
  }

  async updateLanguage(
    userId: string,
    language: Language,
  ): Promise<UserProfile> {
    return this.updateProfile(userId, { language });
  }

  async verifyEmail(userId: string): Promise<UserAccount> {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    user.verifyEmail();
    return this.userRepository.update(userId, { isEmailVerified: true });
  }

  async verifyPhone(userId: string): Promise<UserAccount> {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    user.verifyPhone();
    return this.userRepository.update(userId, { isPhoneVerified: true });
  }

  async deleteUser(userId: string): Promise<void> {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Delete profile first
    await this.userRepository.deleteProfile(userId);

    // Delete user account
    await this.userRepository.delete(userId);
  }

  async getUserWithProfile(
    userId: string,
  ): Promise<{ user: UserAccount; profile: UserProfile | null }> {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    const profile = await this.userRepository.findProfileByUserId(userId);

    return { user, profile };
  }
}
