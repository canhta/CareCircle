import {
  IsEmail,
  IsString,
  IsOptional,
  IsBoolean,
  IsEnum,
} from 'class-validator';
import { Gender, Language } from '@prisma/client';

export class GuestLoginDto {
  @IsString()
  deviceId: string;
}

export class ConvertGuestDto {
  @IsOptional()
  @IsEmail()
  email?: string;

  @IsOptional()
  @IsString()
  phoneNumber?: string;

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
