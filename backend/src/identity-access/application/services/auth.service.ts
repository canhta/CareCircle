import {
  Injectable,
  UnauthorizedException,
  ConflictException,
} from '@nestjs/common';

import { UserRepository } from '../../domain/repositories/user.repository';
import { AuthMethodRepository } from '../../domain/repositories/auth-method.repository';
import { PermissionRepository } from '../../domain/repositories/permission.repository';
import { FirebaseAuthService } from '../../infrastructure/services/firebase-auth.service';
import {
  UserAccount,
  UserProfile,
  AuthMethod,
  PermissionSet,
} from '../../domain/entities/user.entity';
import { AuthMethodType, Role } from '@prisma/client';

export interface LoginResult {
  user: UserAccount;
  profile: UserProfile | null;
}

export interface RegisterData {
  email?: string;
  phoneNumber?: string;
  displayName: string;
  firstName?: string;
  lastName?: string;
  isGuest?: boolean;
  deviceId?: string;
}

@Injectable()
export class AuthService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly authMethodRepository: AuthMethodRepository,
    private readonly permissionRepository: PermissionRepository,
    private readonly firebaseAuthService: FirebaseAuthService,
  ) {}

  async loginAsGuest(firebaseUid: string, deviceId: string): Promise<LoginResult> {
    // Check if guest user already exists by Firebase UID (using ID as Firebase UID)
    let user = await this.userRepository.findById(firebaseUid);

    if (!user) {
      // Create guest user account (Firebase anonymous user already created on client)
      user = UserAccount.create({
        id: firebaseUid,
        isGuest: true,
        deviceId,
      });
      user = await this.userRepository.create(user);

      // Create basic profile
      const profile = UserProfile.create({
        userId: user.id,
        displayName: 'Guest User',
      });
      await this.userRepository.createProfile(profile);

      // Create permission set with limited access
      const permissionSet = PermissionSet.create({
        userId: user.id,
        roles: [Role.USER],
      });
      await this.permissionRepository.create(permissionSet);
    } else {
      // Update last login for existing guest
      user.updateLastLogin();
      await this.userRepository.update(user.id, {
        lastLoginAt: user.lastLoginAt,
      });
    }

    const profile = await this.userRepository.findProfileByUserId(user.id);

    return {
      user,
      profile,
    };
  }

  async convertGuestToRegistered(
    userId: string,
    data: {
      email?: string;
      phoneNumber?: string;
      displayName?: string;
    },
  ): Promise<LoginResult> {
    const user = await this.userRepository.findById(userId);
    if (!user || !user.isGuest) {
      throw new UnauthorizedException('Invalid guest user');
    }

    // Note: Guest conversion now relies on Firebase authentication linking
    // which should be handled on the client side before calling this method

    // Convert user account
    user.convertFromGuest(data.email, data.phoneNumber);
    const updatedUser = await this.userRepository.update(user.id, {
      email: user.email,
      phoneNumber: user.phoneNumber,
      isGuest: false,
    });

    // Update profile if display name provided
    if (data.displayName) {
      await this.userRepository.updateProfile(user.id, {
        displayName: data.displayName,
      });
    }

    const profile = await this.userRepository.findProfileByUserId(user.id);

    return {
      user: updatedUser,
      profile,
    };
  }

  async loginWithFirebaseToken(idToken: string): Promise<LoginResult> {
    try {
      // Verify the Firebase ID token
      const decodedToken =
        await this.firebaseAuthService.verifyIdToken(idToken);

      // Check if user already exists by Firebase UID
      let user = await this.userRepository.findById(decodedToken.uid);

      if (!user) {
        // Create new user account with Firebase UID as ID
        user = UserAccount.create({
          id: decodedToken.uid,
          email: decodedToken.email,
        });
        // Set email verification status after creation
        if (decodedToken.email_verified) {
          user.verifyEmail();
        }
        user = await this.userRepository.create(user);

        // Create user profile
        const profile = UserProfile.create({
          userId: user.id,
          displayName:
            (decodedToken.name as string) || decodedToken.email!.split('@')[0],
          firstName: decodedToken.given_name as string | undefined,
          lastName: decodedToken.family_name as string | undefined,
        });
        // Set photo URL after creation
        if (decodedToken.picture) {
          profile.updateProfile({ photoUrl: decodedToken.picture });
        }
        await this.userRepository.createProfile(profile);

        // Create permission set
        const permissionSet = PermissionSet.create({
          userId: user.id,
          roles: [Role.USER],
        });
        await this.permissionRepository.create(permissionSet);

        // Create auth method record
        const authMethod = AuthMethod.create({
          userId: user.id,
          type: AuthMethodType.EMAIL,
          identifier: decodedToken.email!,
          isVerified: true,
        });
        await this.authMethodRepository.create(authMethod);
      } else {
        // Update last login
        user.updateLastLogin();
        await this.userRepository.update(user.id, {
          lastLoginAt: user.lastLoginAt,
        });
      }

      // Get user profile
      const profile = await this.userRepository.findProfileByUserId(user.id);

      return {
        user,
        profile,
      };
    } catch (error) {
      throw new UnauthorizedException(
        `Firebase login failed: ${(error as Error).message}`,
      );
    }
  }

  async registerWithFirebaseToken(
    idToken: string,
    profileData: {
      displayName: string;
      firstName?: string;
      lastName?: string;
    },
  ): Promise<LoginResult> {
    try {
      // Verify the Firebase ID token
      const decodedToken =
        await this.firebaseAuthService.verifyIdToken(idToken);

      // Check if user already exists by Firebase UID
      const existingUser = await this.userRepository.findById(decodedToken.uid);
      if (existingUser) {
        throw new ConflictException('User already exists with this Firebase UID');
      }

      // Create new user account with Firebase UID as ID
      const user = UserAccount.create({
        id: decodedToken.uid,
        email: decodedToken.email,
      });
      // Set email verification status after creation
      if (decodedToken.email_verified) {
        user.verifyEmail();
      }
      const createdUser = await this.userRepository.create(user);

      // Create user profile
      const profile = UserProfile.create({
        userId: createdUser.id,
        displayName: profileData.displayName,
        firstName: profileData.firstName,
        lastName: profileData.lastName,
      });
      // Set photo URL after creation
      if (decodedToken.picture) {
        profile.updateProfile({ photoUrl: decodedToken.picture });
      }
      await this.userRepository.createProfile(profile);

      // Create permission set
      const permissionSet = PermissionSet.create({
        userId: createdUser.id,
        roles: [Role.USER],
      });
      await this.permissionRepository.create(permissionSet);

      // Create auth method record
      const authMethod = AuthMethod.create({
        userId: createdUser.id,
        type: AuthMethodType.EMAIL,
        identifier: decodedToken.email!,
        isVerified: true,
      });
      await this.authMethodRepository.create(authMethod);

      // Get user profile
      const userProfile = await this.userRepository.findProfileByUserId(
        createdUser.id,
      );

      return {
        user: createdUser,
        profile: userProfile,
      };
    } catch (error) {
      if (error instanceof ConflictException) {
        throw error;
      }
      throw new UnauthorizedException(
        `Firebase registration failed: ${(error as Error).message}`,
      );
    }
  }

  async signInWithGoogle(idToken: string): Promise<LoginResult> {
    try {
      // Verify the Google ID token with Firebase
      const decodedToken =
        await this.firebaseAuthService.verifyIdToken(idToken);

      // Check if user already exists by Firebase UID
      let user = await this.userRepository.findById(decodedToken.uid);

      if (!user) {
        // Create new user account with Firebase UID as ID
        user = UserAccount.create({
          id: decodedToken.uid,
          email: decodedToken.email,
        });
        // Set email verification status after creation
        if (decodedToken.email_verified) {
          user.verifyEmail();
        }
        user = await this.userRepository.create(user);

        // Create user profile
        const profile = UserProfile.create({
          userId: user.id,
          displayName:
            (decodedToken.name as string) || decodedToken.email!.split('@')[0],
          firstName: decodedToken.given_name as string,
          lastName: decodedToken.family_name as string,
        });
        // Set photo URL after creation
        if (decodedToken.picture) {
          profile.updateProfile({ photoUrl: decodedToken.picture });
        }
        await this.userRepository.createProfile(profile);

        // Create permission set
        const permissionSet = PermissionSet.create({
          userId: user.id,
          roles: [Role.USER],
        });
        await this.permissionRepository.create(permissionSet);

        // Create auth method record
        const authMethod = AuthMethod.create({
          userId: user.id,
          type: AuthMethodType.GOOGLE,
          identifier: decodedToken.email!,
          isVerified: true,
        });
        await this.authMethodRepository.create(authMethod);
      } else {
        // Update last login
        user.updateLastLogin();
        await this.userRepository.update(user.id, {
          lastLoginAt: user.lastLoginAt,
        });

        // Update or create Google auth method
        const existingAuthMethod =
          await this.authMethodRepository.findByUserIdAndType(
            user.id,
            AuthMethodType.GOOGLE,
          );

        if (!existingAuthMethod) {
          const authMethod = AuthMethod.create({
            userId: user.id,
            type: AuthMethodType.GOOGLE,
            identifier: decodedToken.email!,
            isVerified: true,
          });
          await this.authMethodRepository.create(authMethod);
        }
      }

      // Get user profile
      const profile = await this.userRepository.findProfileByUserId(user.id);

      return {
        user,
        profile,
      };
    } catch (error) {
      throw new UnauthorizedException(
        `Google sign-in failed: ${(error as Error).message}`,
      );
    }
  }

  async signInWithApple(idToken: string): Promise<LoginResult> {
    try {
      // Verify the Apple ID token with Firebase
      const decodedToken =
        await this.firebaseAuthService.verifyIdToken(idToken);

      // Check if user already exists by Firebase UID
      let user = await this.userRepository.findById(decodedToken.uid);

      if (!user) {
        // Create new user account with Firebase UID as ID
        user = UserAccount.create({
          id: decodedToken.uid,
          email: decodedToken.email,
        });
        // Set email verification status after creation
        if (decodedToken.email_verified) {
          user.verifyEmail();
        }
        user = await this.userRepository.create(user);

        // Create user profile
        const profile = UserProfile.create({
          userId: user.id,
          displayName:
            (decodedToken.name as string) || decodedToken.email!.split('@')[0],
          firstName: decodedToken.given_name as string,
          lastName: decodedToken.family_name as string,
        });
        await this.userRepository.createProfile(profile);

        // Create permission set
        const permissionSet = PermissionSet.create({
          userId: user.id,
          roles: [Role.USER],
        });
        await this.permissionRepository.create(permissionSet);

        // Create auth method record
        const authMethod = AuthMethod.create({
          userId: user.id,
          type: AuthMethodType.APPLE,
          identifier: decodedToken.email!,
          isVerified: true,
        });
        await this.authMethodRepository.create(authMethod);
      } else {
        // Update last login
        user.updateLastLogin();
        await this.userRepository.update(user.id, {
          lastLoginAt: user.lastLoginAt,
        });

        // Update or create Apple auth method
        const existingAuthMethod =
          await this.authMethodRepository.findByUserIdAndType(
            user.id,
            AuthMethodType.APPLE,
          );

        if (!existingAuthMethod) {
          const authMethod = AuthMethod.create({
            userId: user.id,
            type: AuthMethodType.APPLE,
            identifier: decodedToken.email!,
            isVerified: true,
          });
          await this.authMethodRepository.create(authMethod);
        }
      }

      // Get user profile
      const profile = await this.userRepository.findProfileByUserId(user.id);

      return {
        user,
        profile,
      };
    } catch (error) {
      throw new UnauthorizedException(
        `Apple sign-in failed: ${(error as Error).message}`,
      );
    }
  }

  /**
   * Links an OAuth provider to an existing user account
   */
  async linkOAuthProvider(
    userId: string,
    providerId: string,
    providerData: {
      uid: string;
      email?: string;
      displayName?: string;
      photoURL?: string;
    },
  ): Promise<void> {
    try {
      // Get the user's existing Firebase auth method to get the Firebase UID
      const user = await this.userRepository.findById(userId);
      if (!user) {
        throw new UnauthorizedException('User not found');
      }

      // Find the user's Firebase auth method to get their Firebase UID
      const existingAuthMethods =
        await this.authMethodRepository.findByUserId(userId);
      const firebaseAuthMethod = existingAuthMethods.find(
        (method) =>
          method.type === AuthMethodType.EMAIL ||
          method.type === AuthMethodType.GOOGLE ||
          method.type === AuthMethodType.APPLE,
      );

      if (!firebaseAuthMethod) {
        throw new UnauthorizedException(
          'User does not have a Firebase authentication method',
        );
      }

      // Link the OAuth provider to the Firebase user using the Firebase UID from auth method
      await this.firebaseAuthService.linkOAuthProvider(
        firebaseAuthMethod.identifier, // This should be the Firebase UID
        providerId,
        providerData,
      );

      // Create auth method record in database
      const authMethod = new AuthMethod(
        '', // ID will be generated
        userId,
        providerId === 'google.com'
          ? AuthMethodType.GOOGLE
          : AuthMethodType.APPLE,
        providerData.uid,
        true, // isVerified
        new Date(),
        new Date(),
      );

      await this.authMethodRepository.create(authMethod);
    } catch (error) {
      throw new UnauthorizedException(
        `Failed to link OAuth provider: ${(error as Error).message}`,
      );
    }
  }
}
