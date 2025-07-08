import { UserAccount, UserProfile } from '../entities/user.entity';

export abstract class UserRepository {
  abstract findById(id: string): Promise<UserAccount | null>;
  abstract findByEmail(email: string): Promise<UserAccount | null>;
  abstract findByPhoneNumber(phoneNumber: string): Promise<UserAccount | null>;
  abstract findByDeviceId(deviceId: string): Promise<UserAccount | null>;
  abstract create(user: UserAccount): Promise<UserAccount>;
  abstract update(
    id: string,
    updates: Partial<UserAccount>,
  ): Promise<UserAccount>;
  abstract delete(id: string): Promise<void>;

  // Profile methods
  abstract findProfileByUserId(userId: string): Promise<UserProfile | null>;
  abstract createProfile(profile: UserProfile): Promise<UserProfile>;
  abstract updateProfile(
    userId: string,
    updates: Partial<UserProfile>,
  ): Promise<UserProfile>;
  abstract deleteProfile(userId: string): Promise<void>;
}
