/**
 * Interfaces for user related functionality
 */

import { User } from '@prisma/client';

/**
 * Interface for authenticated user response
 */
export interface AuthenticatedUser {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  phone?: string | null;
  dateOfBirth?: Date | null;
  gender?: string | null;
  timezone?: string | null;
  avatar?: string | null;
  emergencyContact?: string | null;
  googleId?: string | null;
  appleId?: string | null;
  isActive: boolean;
  emailVerified: boolean;
  lastLoginAt?: Date | null;
  dataProcessingConsent: boolean;
  marketingConsent: boolean;
  analyticsConsent: boolean;
  healthDataSharingConsent: boolean;
  consentVersion?: string | null;
  consentDate?: Date | null;
  createdAt: Date;
  updatedAt: Date;
}

/**
 * Interface for Google user profile
 */
export interface GoogleUserProfile {
  id: string;
  name: {
    givenName: string;
    familyName: string;
  };
  emails: Array<{ value: string; verified: boolean }>;
  photos: Array<{ value: string }>;
}

/**
 * Interface for Google authentication data
 */
export interface GoogleAuthData {
  googleId: string;
  email: string;
  firstName: string;
  lastName: string;
  picture?: string;
}

/**
 * Interface for Apple authentication data
 */
export interface AppleAuthData {
  email: string;
  firstName?: string;
  lastName?: string;
  appleId: string;
}

/**
 * Interface for user consent data
 */
export interface UserConsentData {
  dataProcessingConsent?: boolean;
  marketingConsent?: boolean;
  analyticsConsent?: boolean;
  healthDataSharingConsent?: boolean;
  consentVersion?: string;
  consentDate?: Date;
}
