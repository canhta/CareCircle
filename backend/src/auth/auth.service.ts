import { Injectable, ConflictException } from '@nestjs/common';
import { UserService } from '../user/user.service';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';
import { User } from '@prisma/client';

export interface LoginResponse {
  access_token: string;
  refresh_token: string;
  user: Omit<User, 'password'>;
}

export interface RegisterDto {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  phone?: string;
}

export interface LoginDto {
  email: string;
  password: string;
}

@Injectable()
export class AuthService {
  constructor(
    private userService: UserService,
    private prisma: PrismaService,
  ) {}

  async register(registerDto: RegisterDto): Promise<User> {
    const { email, password, ...userData } = registerDto;

    // Check if user already exists
    const existingUser = await this.userService.findUserByEmail(email);
    if (existingUser) {
      throw new ConflictException('User with this email already exists');
    }

    // Hash password
    const saltRounds = 12;

    const hashedPassword = await bcrypt.hash(password, saltRounds);

    // Create user
    const user = await this.userService.createUser({
      email,

      password: hashedPassword,
      ...userData,
    });

    return user;
  }

  async validateUser(email: string, password: string): Promise<User | null> {
    const user = await this.userService.findUserByEmail(email);
    if (!user || !user.password) {
      return null;
    }

    // Check if user is active
    if (!user.isActive) {
      return null;
    }

    // Verify password

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return null;
    }

    return user;
  }

  async login(user: User): Promise<{ user: Omit<User, 'password'> }> {
    // Update last login
    await this.userService.updateLastLogin(user.id);

    // Remove password from response
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { password, ...userWithoutPassword } = user;

    return {
      user: userWithoutPassword,
    };
  }

  async googleLogin(googleUser: {
    email: string;
    firstName: string;
    lastName: string;
    picture?: string;
    googleId: string;
  }): Promise<User> {
    const { email, firstName, lastName, picture, googleId } = googleUser;

    let user = await this.userService.findUserByEmail(email);

    if (!user) {
      // Create new user from Google profile
      user = await this.userService.createUser({
        email,
        firstName,
        lastName,
        avatar: picture,
        googleId,
        emailVerified: true, // Google emails are pre-verified
      });
    } else if (!user.googleId) {
      // Link existing user to Google
      user = await this.userService.updateUser(user.id, {
        googleId,
        avatar: picture || user.avatar,
      });
    }

    // Update last login
    await this.userService.updateLastLogin(user.id);

    return user;
  }

  async appleLogin(appleUser: {
    email: string;
    firstName?: string;
    lastName?: string;
    appleId: string;
  }): Promise<User> {
    const { email, firstName, lastName, appleId } = appleUser;

    let user = await this.userService.findUserByEmail(email);

    if (!user) {
      // Create new user from Apple profile
      user = await this.userService.createUser({
        email,
        firstName: firstName || 'Apple',
        lastName: lastName || 'User',
        appleId,
        emailVerified: true, // Apple emails are pre-verified
      });
    } else if (!user.appleId) {
      // Link existing user to Apple
      user = await this.userService.updateUser(user.id, {
        appleId,
      });
    }

    // Update last login
    await this.userService.updateLastLogin(user.id);

    return user;
  }
}
