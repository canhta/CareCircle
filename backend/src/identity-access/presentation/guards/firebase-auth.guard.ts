import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
  Logger,
  ForbiddenException,
} from '@nestjs/common';
import { DecodedIdToken } from 'firebase-admin/auth';
import { FirebaseAuthService } from '../../infrastructure/services/firebase-auth.service';
import { UserService } from '../../application/services/user.service';

export interface FirebaseUserPayload {
  id: string;
  email?: string;
  isGuest: boolean;
  firebaseUid: string;
  decodedToken: DecodedIdToken;
}

@Injectable()
export class FirebaseAuthGuard implements CanActivate {
  private readonly logger = new Logger(FirebaseAuthGuard.name);

  constructor(
    private readonly firebaseAuthService: FirebaseAuthService,
    private readonly userService: UserService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<{
      headers: { authorization?: string };
      user?: FirebaseUserPayload;
    }>();
    const token = this.extractTokenFromHeader(request);

    if (!token) {
      this.logger.warn('Authentication attempt without token');
      throw new UnauthorizedException(
        'Authorization header with Bearer token is required',
      );
    }

    try {
      // Verify Firebase ID token
      const decodedToken = await this.firebaseAuthService.verifyIdToken(token);

      // Validate token claims
      this.validateTokenClaims(decodedToken);

      // Find or create user in our database
      let user = await this.userService.findById(decodedToken.uid);
      if (!user) {
        this.logger.log(
          `Creating new user for Firebase UID: ${decodedToken.uid}`,
        );
        // For valid Firebase tokens, create user automatically
        // This handles the case where Firebase authentication succeeded
        // but the user doesn't exist in our database yet
        user = await this.userService.createFromFirebaseToken(decodedToken);
      }

      // User account validation could be added here in the future
      // For now, all existing users are considered active

      // Attach user info to request
      request.user = {
        id: user.id,
        email: user.email,
        isGuest: user.isGuest,
        firebaseUid: decodedToken.uid,
        decodedToken,
      };

      this.logger.debug(`Authentication successful for user: ${user.id}`);
      return true;
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      const errorStack = error instanceof Error ? error.stack : undefined;
      this.logger.error(`Authentication failed: ${errorMessage}`, errorStack);

      if (error instanceof ForbiddenException) {
        throw error;
      }

      // Provide specific error messages for different failure types
      if (errorMessage.includes('expired')) {
        throw new UnauthorizedException('Token has expired');
      }
      if (errorMessage.includes('invalid')) {
        throw new UnauthorizedException('Invalid token format');
      }
      if (errorMessage.includes('Firebase')) {
        throw new UnauthorizedException('Firebase token verification failed');
      }

      throw new UnauthorizedException('Authentication failed');
    }
  }

  private validateTokenClaims(decodedToken: DecodedIdToken): void {
    // Validate required token claims
    if (!decodedToken.uid) {
      throw new UnauthorizedException('Token missing required uid claim');
    }

    // Check token expiration (Firebase SDK handles this, but double-check)
    const now = Math.floor(Date.now() / 1000);
    if (decodedToken.exp && decodedToken.exp < now) {
      throw new UnauthorizedException('Token has expired');
    }

    // Validate token was issued recently (not too old)
    if (decodedToken.iat && now - decodedToken.iat > 86400) {
      // 24 hours
      this.logger.warn(
        `Old token used: issued ${now - decodedToken.iat} seconds ago`,
      );
    }

    // Validate audience if configured
    if (decodedToken.aud && process.env.FIREBASE_PROJECT_ID) {
      if (decodedToken.aud !== process.env.FIREBASE_PROJECT_ID) {
        throw new UnauthorizedException('Token audience mismatch');
      }
    }
  }

  private extractTokenFromHeader(request: {
    headers: { authorization?: string };
  }): string | undefined {
    const authHeader = request.headers.authorization;

    if (!authHeader) {
      return undefined;
    }

    const [type, token] = authHeader.split(' ');

    if (type !== 'Bearer') {
      this.logger.warn(`Invalid authorization type: ${type}`);
      return undefined;
    }

    if (!token || token.length < 10) {
      this.logger.warn('Invalid token format');
      return undefined;
    }

    return token;
  }
}
