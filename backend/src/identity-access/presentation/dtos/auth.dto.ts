import {
  IsEmail,
  IsString,
  IsOptional,
  IsBoolean,
  IsEnum,
  IsNotEmpty,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Gender, Language } from '@prisma/client';

export class FirebaseLoginDto {
  @ApiProperty({
    description: 'Firebase ID token from email/password authentication',
    example: 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjE2NzAyN...',
  })
  @IsString()
  @IsNotEmpty()
  idToken: string;
}

export class FirebaseRegisterDto {
  @ApiProperty({
    description: 'Firebase ID token from email/password authentication',
    example: 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjE2NzAyN...',
  })
  @IsString()
  @IsNotEmpty()
  idToken: string;

  @ApiPropertyOptional({
    description: 'Display name for the user',
    example: 'John Doe',
  })
  @IsOptional()
  @IsString()
  displayName?: string;

  @ApiPropertyOptional({
    description: 'First name of the user',
    example: 'John',
  })
  @IsOptional()
  @IsString()
  firstName?: string;

  @ApiPropertyOptional({
    description: 'Last name of the user',
    example: 'Doe',
  })
  @IsOptional()
  @IsString()
  lastName?: string;
}

export class GuestLoginDto {
  @ApiProperty({
    description: 'Device identifier for guest user',
    example: 'device-12345-abcde',
  })
  @IsString()
  @IsNotEmpty()
  deviceId: string;

  @ApiProperty({
    description: 'Firebase ID token from anonymous authentication',
    example: 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjE2NzAyN...',
  })
  @IsString()
  @IsNotEmpty()
  idToken: string;
}

export class ConvertGuestDto {
  @ApiPropertyOptional({
    description: 'Email address for the converted account',
    example: 'user@example.com',
  })
  @IsOptional()
  @IsEmail()
  email?: string;

  @ApiPropertyOptional({
    description: 'Phone number for the converted account',
    example: '+1234567890',
  })
  @IsOptional()
  @IsString()
  phoneNumber?: string;

  @ApiPropertyOptional({
    description: 'Display name for the converted account',
    example: 'John Doe',
  })
  @IsOptional()
  @IsString()
  displayName?: string;
}

export class UpdateProfileDto {
  @IsOptional()
  @IsString()
  displayName?: string;

  @IsOptional()
  @IsString()
  firstName?: string;

  @IsOptional()
  @IsString()
  lastName?: string;

  @IsOptional()
  dateOfBirth?: Date;

  @IsOptional()
  @IsEnum(Gender)
  gender?: Gender;

  @IsOptional()
  @IsEnum(Language)
  language?: Language;

  @IsOptional()
  @IsString()
  photoUrl?: string;

  @IsOptional()
  @IsBoolean()
  useElderMode?: boolean;

  @IsOptional()
  preferredUnits?: {
    weight: 'kg' | 'lb';
    height: 'cm' | 'ft';
    temperature: 'c' | 'f';
    glucose: 'mmol/L' | 'mg/dL';
  };

  @IsOptional()
  emergencyContact?: {
    name: string;
    relationship: string;
    phoneNumber: string;
    isEmergencyContact: boolean;
    canAccessHealthData: boolean;
  };
}

export class AuthResponseDto {
  @ApiProperty({
    description: 'User account information',
    example: {
      id: 'firebase-uid-12345',
      email: 'user@example.com',
      phoneNumber: '+1234567890',
      isEmailVerified: true,
      isPhoneVerified: false,
      isGuest: false,
      createdAt: '2024-01-01T00:00:00.000Z',
      lastLoginAt: '2024-01-01T12:00:00.000Z',
    },
  })
  user: {
    id: string;
    email?: string;
    phoneNumber?: string;
    isEmailVerified: boolean;
    isPhoneVerified: boolean;
    isGuest: boolean;
    createdAt: Date;
    lastLoginAt: Date;
  };

  @ApiPropertyOptional({
    description: 'User profile information (optional)',
    example: {
      id: 'profile-id-12345',
      displayName: 'John Doe',
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: '1990-01-01',
      gender: 'MALE',
      language: 'EN',
      photoUrl: 'https://example.com/photo.jpg',
      useElderMode: false,
      preferredUnits: {},
      emergencyContact: {},
    },
  })
  profile?: {
    id: string;
    displayName: string;
    firstName?: string;
    lastName?: string;
    dateOfBirth?: Date;
    gender?: Gender;
    language: Language;
    photoUrl?: string;
    useElderMode: boolean;
    preferredUnits: any;
    emergencyContact?: any;
  };
}

export class ProfileResponseDto {
  id: string;
  displayName: string;
  firstName?: string;
  lastName?: string;
  dateOfBirth?: Date;
  gender?: Gender;
  language: Language;
  photoUrl?: string;
  useElderMode: boolean;
  preferredUnits: any;
  emergencyContact?: any;
  createdAt: Date;
  updatedAt: Date;
}

export class OAuthLoginDto {
  @ApiProperty({
    description: 'Firebase ID token from OAuth provider (Google/Apple)',
    example: 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjE2NzAyN...',
  })
  @IsString()
  @IsNotEmpty()
  idToken: string;

  @ApiPropertyOptional({
    description: 'OAuth access token (optional)',
    example: 'ya29.a0AfH6SMC...',
  })
  @IsOptional()
  @IsString()
  accessToken?: string;

  @ApiPropertyOptional({
    description: 'OAuth provider identifier',
    example: 'google.com',
    enum: ['google.com', 'apple.com'],
  })
  @IsOptional()
  @IsString()
  providerId?: string;
}

export class LinkOAuthProviderDto {
  @ApiProperty({
    description: 'OAuth provider identifier',
    example: 'google.com',
    enum: ['google.com', 'apple.com'],
  })
  @IsString()
  @IsNotEmpty()
  providerId: string;

  @ApiProperty({
    description: 'Firebase ID token from OAuth provider',
    example: 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjE2NzAyN...',
  })
  @IsString()
  @IsNotEmpty()
  idToken: string;

  @ApiProperty({
    description: 'Provider-specific user data',
    example: {
      uid: 'google-uid-12345',
      email: 'user@gmail.com',
      displayName: 'John Doe',
      photoURL: 'https://lh3.googleusercontent.com/...',
    },
  })
  providerData: {
    uid: string;
    email?: string;
    displayName?: string;
    photoURL?: string;
  };
}
