import {
  Injectable,
  UnauthorizedException,
  ConflictException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
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
  accessToken: string;
  refreshToken: string;
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

interface JwtPayload {
  sub: string;
  email?: string;
  isGuest: boolean;
  iat?: number;
  exp?: number;
}

@Injectable()
export class AuthService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly authMethodRepository: AuthMethodRepository,
    private readonly permissionRepository: PermissionRepository,
    private readonly firebaseAuthService: FirebaseAuthService,
    private readonly jwtService: JwtService,
  ) {}

  async registerWithEmail(
    data: RegisterData & { password: string },
  ): Promise<LoginResult> {
    // Check if user already exists
    if (data.email) {
      const existingUser = await this.userRepository.findByEmail(data.email);
      if (existingUser) {
        throw new ConflictException('User with this email already exists');
      }
    }

    // Create Firebase user
    await this.firebaseAuthService.createUser({
      email: data.email,
      password: data.password,
      displayName: data.displayName,
    });

    // Create user account
    const userAccount = UserAccount.create({
      email: data.email,
      isGuest: data.isGuest || false,
      deviceId: data.deviceId,
    });

    const savedUser = await this.userRepository.create(userAccount);

    // Create auth method
    if (data.email) {
      const authMethod = AuthMethod.create({
        userId: savedUser.id,
        type: AuthMethodType.EMAIL,
        identifier: data.email,
        isVerified: false,
      });
      await this.authMethodRepository.create(authMethod);
    }

    // Create user profile
    const profile = UserProfile.create({
      userId: savedUser.id,
      displayName: data.displayName,
      firstName: data.firstName,
      lastName: data.lastName,
    });
    const savedProfile = await this.userRepository.createProfile(profile);

    // Create permission set
    const permissionSet = PermissionSet.create({
      userId: savedUser.id,
      roles: [Role.USER],
    });
    await this.permissionRepository.create(permissionSet);

    // Generate tokens
    const tokens = await this.generateTokens(savedUser);

    return {
      user: savedUser,
      profile: savedProfile,
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    };
  }

  async loginWithEmail(email: string, password: string): Promise<LoginResult> {
    // Verify with Firebase
    await this.firebaseAuthService.signInWithEmailAndPassword(email, password);

    // Find user in our database
    const user = await this.userRepository.findByEmail(email);
    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    // Update last login
    user.updateLastLogin();
    await this.userRepository.update(user.id, {
      lastLoginAt: user.lastLoginAt,
    });

    // Update auth method last used
    const authMethod = await this.authMethodRepository.findByUserIdAndType(
      user.id,
      AuthMethodType.EMAIL,
    );
    if (authMethod) {
      authMethod.updateLastUsed();
      await this.authMethodRepository.update(authMethod.id, {
        lastUsed: authMethod.lastUsed,
      });
    }

    // Get user profile
    const profile = await this.userRepository.findProfileByUserId(user.id);

    // Generate tokens
    const tokens = await this.generateTokens(user);

    return {
      user,
      profile,
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    };
  }

  async loginAsGuest(deviceId: string): Promise<LoginResult> {
    // Check if guest user already exists for this device
    let user = await this.userRepository.findByDeviceId(deviceId);

    if (!user) {
      // Create anonymous Firebase user
      await this.firebaseAuthService.signInAnonymously();

      // Create guest user account
      user = UserAccount.create({
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
    const tokens = await this.generateTokens(user);

    return {
      user,
      profile,
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    };
  }

  async convertGuestToRegistered(
    userId: string,
    data: {
      email?: string;
      phoneNumber?: string;
      password?: string;
      displayName?: string;
    },
  ): Promise<LoginResult> {
    const user = await this.userRepository.findById(userId);
    if (!user || !user.isGuest) {
      throw new UnauthorizedException('Invalid guest user');
    }

    // Create Firebase user if email provided
    if (data.email && data.password) {
      await this.firebaseAuthService.createUser({
        email: data.email,
        password: data.password,
        displayName: data.displayName || 'User',
      });

      // Create auth method
      const authMethod = AuthMethod.create({
        userId: user.id,
        type: AuthMethodType.EMAIL,
        identifier: data.email,
        isVerified: false,
      });
      await this.authMethodRepository.create(authMethod);
    }

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
    const tokens = await this.generateTokens(updatedUser);

    return {
      user: updatedUser,
      profile,
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    };
  }

  async refreshToken(
    refreshToken: string,
  ): Promise<{ accessToken: string; refreshToken: string }> {
    try {
      const payload = this.jwtService.verify<JwtPayload>(refreshToken, {
        secret: process.env.JWT_REFRESH_SECRET,
      });

      const user = await this.userRepository.findById(payload.sub);
      if (!user) {
        throw new UnauthorizedException('User not found');
      }

      return this.generateTokens(user);
    } catch {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }

  async logout(userId: string): Promise<void> {
    // Invalidate Firebase session
    await this.firebaseAuthService.revokeRefreshTokens(userId);

    // Additional logout logic (e.g., blacklist tokens) can be added here
  }

  async loginWithFirebaseToken(idToken: string): Promise<LoginResult> {
    try {
      // Verify the Firebase ID token
      const decodedToken =
        await this.firebaseAuthService.verifyIdToken(idToken);

      // Check if user already exists
      let user = await this.userRepository.findByEmail(decodedToken.email!);

      if (!user) {
        // Create new user account
        user = UserAccount.create({
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

      // Generate tokens
      const tokens = await this.generateTokens(user);

      return {
        user,
        profile,
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
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

      // Check if user already exists
      const existingUser = await this.userRepository.findByEmail(
        decodedToken.email!,
      );
      if (existingUser) {
        throw new ConflictException('User already exists with this email');
      }

      // Create new user account
      const user = UserAccount.create({
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

      // Generate tokens
      const tokens = await this.generateTokens(createdUser);

      return {
        user: createdUser,
        profile: userProfile,
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
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

      // Check if user already exists
      let user = await this.userRepository.findByEmail(decodedToken.email!);

      if (!user) {
        // Create new user account
        user = UserAccount.create({
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

      // Generate tokens
      const tokens = await this.generateTokens(user);

      return {
        user,
        profile,
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
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

      // Check if user already exists
      let user = await this.userRepository.findByEmail(decodedToken.email!);

      if (!user) {
        // Create new user account
        user = UserAccount.create({
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

      // Generate tokens
      const tokens = await this.generateTokens(user);

      return {
        user,
        profile,
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      };
    } catch (error) {
      throw new UnauthorizedException(
        `Apple sign-in failed: ${(error as Error).message}`,
      );
    }
  }

  private async generateTokens(
    user: UserAccount,
  ): Promise<{ accessToken: string; refreshToken: string }> {
    const payload = {
      sub: user.id,
      email: user.email,
      isGuest: user.isGuest,
    };

    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(payload),
      this.jwtService.signAsync(payload, {
        secret: process.env.JWT_REFRESH_SECRET,
        expiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '30d',
      }),
    ]);

    return { accessToken, refreshToken };
  }
}
