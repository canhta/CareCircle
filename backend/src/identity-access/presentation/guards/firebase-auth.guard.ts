import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { FirebaseAuthService } from '../../infrastructure/services/firebase-auth.service';
import { UserService } from '../../application/services/user.service';

export interface FirebaseUserPayload {
  id: string;
  email?: string;
  isGuest: boolean;
  firebaseUid: string;
  decodedToken: any;
}

@Injectable()
export class FirebaseAuthGuard implements CanActivate {
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
      throw new UnauthorizedException('No token provided');
    }

    try {
      // Verify Firebase ID token
      const decodedToken = await this.firebaseAuthService.verifyIdToken(token);

      // Find or create user in our database
      let user = await this.userService.findById(decodedToken.uid);
      if (!user) {
        // For valid Firebase tokens, create user automatically
        // This handles the case where Firebase authentication succeeded
        // but the user doesn't exist in our database yet
        user = await this.userService.createFromFirebaseToken(decodedToken);
      }

      // Attach user info to request
      request.user = {
        id: user.id,
        email: user.email,
        isGuest: user.isGuest,
        firebaseUid: decodedToken.uid,
        decodedToken,
      };

      return true;
    } catch {
      throw new UnauthorizedException('Invalid token');
    }
  }

  private extractTokenFromHeader(request: {
    headers: { authorization?: string };
  }): string | undefined {
    const [type, token] = request.headers.authorization?.split(' ') ?? [];
    return type === 'Bearer' ? token : undefined;
  }
}
