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

  signInWithEmailAndPassword(
    email: string,
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    _password: string,
  ): Promise<FirebaseUser> {
    // Note: Firebase Admin SDK doesn't have signInWithEmailAndPassword
    // This would typically be handled on the client side
    // For server-side validation, we would verify the ID token sent from client
    console.warn('signInWithEmailAndPassword should be handled on client side');

    // For development without proper Firebase setup, return a mock user
    if (!this.isFirebaseConfigured()) {
      console.warn('Using mock Firebase user for development');
      return Promise.resolve(this.createMockUser(email));
    }

    throw new Error(
      'signInWithEmailAndPassword should be handled on client side',
    );
  }

  async signInAnonymously(): Promise<FirebaseUser> {
    // Note: Anonymous sign-in is also typically handled on client side
    // For server-side, we create an anonymous user record
    try {
      if (!this.isFirebaseConfigured()) {
        console.warn('Using mock Firebase user for development');
        return this.createMockUser();
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

  private isFirebaseConfigured(): boolean {
    const projectId = this.configService.get<string>('FIREBASE_PROJECT_ID');
    const privateKey = this.configService.get<string>('FIREBASE_PRIVATE_KEY');
    const clientEmail = this.configService.get<string>('FIREBASE_CLIENT_EMAIL');

    return !(
      !projectId ||
      projectId === 'your-firebase-project-id' ||
      !privateKey ||
      privateKey.includes('YOUR_PRIVATE_KEY') ||
      !clientEmail ||
      clientEmail.includes('your-service-account')
    );
  }

  private createMockUser(email?: string): FirebaseUser {
    return {
      uid: `mock-${Date.now()}`,
      email: email || 'guest@carecircle.dev',
      displayName: email ? 'Mock User' : 'Guest User',
      emailVerified: false,
      disabled: false,
    };
  }
}
