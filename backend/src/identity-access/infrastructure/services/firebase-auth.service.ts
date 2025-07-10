import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as admin from 'firebase-admin';

export interface FirebaseUser {
  uid: string;
  email?: string;
  displayName?: string;
  phoneNumber?: string;
  emailVerified: boolean;
  disabled: boolean;
  customClaims?: Record<string, any>;
}

export interface CreateUserData {
  email?: string;
  password?: string;
  displayName?: string;
  phoneNumber?: string;
}

@Injectable()
export class FirebaseAuthService {
  private readonly auth: admin.auth.Auth;

  constructor(private readonly configService: ConfigService) {
    // Initialize Firebase Admin SDK
    if (!admin.apps.length) {
      const projectId = this.configService.get<string>('FIREBASE_PROJECT_ID');
      const privateKeyId = this.configService.get<string>(
        'FIREBASE_PRIVATE_KEY_ID',
      );
      const privateKey = this.configService
        .get<string>('FIREBASE_PRIVATE_KEY')
        ?.replace(/\\n/g, '\n');
      const clientEmail = this.configService.get<string>(
        'FIREBASE_CLIENT_EMAIL',
      );
      const clientId = this.configService.get<string>('FIREBASE_CLIENT_ID');

      // Check if Firebase credentials are configured
      if (
        !projectId ||
        projectId === 'your-firebase-project-id' ||
        !privateKey ||
        privateKey.includes('YOUR_PRIVATE_KEY') ||
        !clientEmail ||
        clientEmail.includes('your-service-account')
      ) {
        console.warn(
          '⚠️  Firebase credentials not configured. Please set up Firebase Admin SDK credentials in .env file.',
        );
        console.warn(
          '📖 See docs/setup/firebase-setup.md for setup instructions.',
        );

        // Initialize with minimal config for development
        admin.initializeApp({
          projectId: projectId || 'carecircle-dev',
        });
      } else {
        const serviceAccount = {
          projectId,
          privateKeyId,
          privateKey,
          clientEmail,
          clientId,
          authUri: this.configService.get<string>('FIREBASE_AUTH_URI'),
          tokenUri: this.configService.get<string>('FIREBASE_TOKEN_URI'),
        };

        admin.initializeApp({
          credential: admin.credential.cert(
            serviceAccount as admin.ServiceAccount,
          ),
          projectId: serviceAccount.projectId,
        });

        console.log('✅ Firebase Admin SDK initialized successfully');
      }
    }

    this.auth = admin.auth();
  }

  async createUser(userData: CreateUserData): Promise<FirebaseUser> {
    try {
      const userRecord = await this.auth.createUser({
        email: userData.email,
        password: userData.password,
        displayName: userData.displayName,
        phoneNumber: userData.phoneNumber,
      });

      return this.mapUserRecord(userRecord);
    } catch (error) {
      throw new UnauthorizedException(
        `Failed to create user: ${(error as Error).message}`,
      );
    }
  }

  async getUserByUid(uid: string): Promise<FirebaseUser> {
    try {
      const userRecord = await this.auth.getUser(uid);
      return this.mapUserRecord(userRecord);
    } catch (error) {
      throw new UnauthorizedException(
        `User not found: ${(error as Error).message}`,
      );
    }
  }

  async getUserByEmail(email: string): Promise<FirebaseUser> {
    try {
      const userRecord = await this.auth.getUserByEmail(email);
      return this.mapUserRecord(userRecord);
    } catch (error) {
      throw new UnauthorizedException(
        `User not found: ${(error as Error).message}`,
      );
    }
  }

  async verifyIdToken(idToken: string): Promise<admin.auth.DecodedIdToken> {
    try {
      return await this.auth.verifyIdToken(idToken);
    } catch (error) {
      throw new UnauthorizedException(
        `Invalid token: ${(error as Error).message}`,
      );
    }
  }

  async setCustomClaims(
    uid: string,
    claims: Record<string, any>,
  ): Promise<void> {
    try {
      await this.auth.setCustomUserClaims(uid, claims);
    } catch (error) {
      throw new UnauthorizedException(
        `Failed to set custom claims: ${(error as Error).message}`,
      );
    }
  }

  async revokeRefreshTokens(uid: string): Promise<void> {
    try {
      await this.auth.revokeRefreshTokens(uid);
    } catch (error) {
      throw new UnauthorizedException(
        `Failed to revoke tokens: ${(error as Error).message}`,
      );
    }
  }

  async updateUser(
    uid: string,
    updates: Partial<CreateUserData>,
  ): Promise<FirebaseUser> {
    try {
      const userRecord = await this.auth.updateUser(uid, {
        email: updates.email,
        displayName: updates.displayName,
        phoneNumber: updates.phoneNumber,
      });

      return this.mapUserRecord(userRecord);
    } catch (error) {
      throw new UnauthorizedException(
        `Failed to update user: ${(error as Error).message}`,
      );
    }
  }

  async deleteUser(uid: string): Promise<void> {
    try {
      await this.auth.deleteUser(uid);
    } catch (error) {
      throw new UnauthorizedException(
        `Failed to delete user: ${(error as Error).message}`,
      );
    }
  }

  /**
   * Creates an anonymous user for guest mode functionality.
   * This is used for server-side anonymous user creation when needed.
   */
  async signInAnonymously(): Promise<FirebaseUser> {
    try {
      if (!this.isFirebaseConfigured()) {
        throw new Error(
          'Firebase is not properly configured. Please check your environment variables.',
        );
      }

      const userRecord = await this.auth.createUser({
        // No email or password for anonymous users
      });

      return this.mapUserRecord(userRecord);
    } catch (error) {
      throw new UnauthorizedException(
        `Failed to create anonymous user: ${(error as Error).message}`,
      );
    }
  }

  async generateCustomToken(
    uid: string,
    additionalClaims?: Record<string, any>,
  ): Promise<string> {
    try {
      return await this.auth.createCustomToken(uid, additionalClaims);
    } catch (error) {
      throw new UnauthorizedException(
        `Failed to generate custom token: ${(error as Error).message}`,
      );
    }
  }

  async listUsers(maxResults: number = 1000): Promise<FirebaseUser[]> {
    try {
      const listUsersResult = await this.auth.listUsers(maxResults);
      return listUsersResult.users.map((user) => this.mapUserRecord(user));
    } catch (error) {
      throw new UnauthorizedException(
        `Failed to list users: ${(error as Error).message}`,
      );
    }
  }

  private mapUserRecord(userRecord: admin.auth.UserRecord): FirebaseUser {
    return {
      uid: userRecord.uid,
      email: userRecord.email,
      displayName: userRecord.displayName,
      phoneNumber: userRecord.phoneNumber,
      emailVerified: userRecord.emailVerified,
      disabled: userRecord.disabled,
      customClaims: userRecord.customClaims,
    };
  }

  /**
   * Checks if Firebase is properly configured with valid credentials.
   * Throws an error if configuration is missing or invalid.
   */
  private isFirebaseConfigured(): boolean {
    const projectId = this.configService.get<string>('FIREBASE_PROJECT_ID');
    const privateKey = this.configService.get<string>('FIREBASE_PRIVATE_KEY');
    const clientEmail = this.configService.get<string>('FIREBASE_CLIENT_EMAIL');

    const isConfigured = !!(
      projectId &&
      projectId !== 'your-firebase-project-id' &&
      privateKey &&
      !privateKey.includes('YOUR_PRIVATE_KEY') &&
      clientEmail &&
      !clientEmail.includes('your-service-account')
    );

    if (!isConfigured) {
      console.error('Firebase configuration is missing or invalid:', {
        hasProjectId: !!projectId,
        hasPrivateKey: !!privateKey,
        hasClientEmail: !!clientEmail,
      });
    }

    return isConfigured;
  }

  /**
   * Adds OAuth provider information to a user account.
   * This method links OAuth providers (Google, Apple) to existing Firebase users.
   */
  async linkOAuthProvider(
    uid: string,
    providerId: string,
    providerData: {
      uid: string;
      email?: string;
      displayName?: string;
      photoURL?: string;
    },
  ): Promise<void> {
    try {
      const updateRequest: admin.auth.UpdateRequest = {
        providerToLink: {
          uid: providerData.uid,
          providerId,
          email: providerData.email,
          displayName: providerData.displayName,
          photoURL: providerData.photoURL,
        },
      };

      await this.auth.updateUser(uid, updateRequest);
    } catch (error) {
      throw new UnauthorizedException(
        `Failed to link OAuth provider: ${(error as Error).message}`,
      );
    }
  }

  /**
   * Converts an anonymous user to a permanent user account.
   * This is used when a guest user decides to create a full account.
   */
  async convertAnonymousUser(
    uid: string,
    email: string,
    password: string,
    displayName?: string,
  ): Promise<FirebaseUser> {
    try {
      const updateRequest: admin.auth.UpdateRequest = {
        email,
        password,
        displayName,
        emailVerified: false, // User will need to verify email
      };

      const userRecord = await this.auth.updateUser(uid, updateRequest);
      return this.mapUserRecord(userRecord);
    } catch (error) {
      throw new UnauthorizedException(
        `Failed to convert anonymous user: ${(error as Error).message}`,
      );
    }
  }
}
