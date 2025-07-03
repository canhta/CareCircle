import { User } from '@prisma/client';

export interface AuthenticatedRequest extends Request {
  user: Omit<User, 'password'>;
}

export interface GoogleOAuthRequest extends Request {
  user: {
    googleId: string;
    email: string;
    firstName: string;
    lastName: string;
    picture?: string;
  };
}
