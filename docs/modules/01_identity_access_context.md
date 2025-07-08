# Identity & Access Context (IAC)

**Module Number: 1** - First module to implement  
**Implementation Guide: [Firebase Authentication Implementation](./01a_firebase_auth_implementation.md)**

## Module Overview

The Identity & Access Context (IAC) is the foundational module for the CareCircle platform that handles all aspects of user authentication, profile management, and permission control. As the first module to implement, it establishes the security boundaries for the entire system.

### Responsibilities

- User authentication and authorization
- Profile management and user data handling
- Permission and role management
- Multi-factor authentication
- Session management
- Account recovery and security
- Guest mode functionality
- Audit logging for security events

### Role in Overall Architecture

This context is a prerequisite for all other contexts, providing the core identity services that other contexts depend on. It establishes the security boundary for the application and ensures that only authorized users can access sensitive health information and functionality.

## Technical Specification

### Key Data Models and Interfaces

#### Domain Entities

1. **User Account**

   ```typescript
   interface UserAccount {
     id: string;
     email?: string;
     phoneNumber?: string;
     authProviders: AuthProvider[];
     isEmailVerified: boolean;
     isPhoneVerified: boolean;
     isGuest: boolean;
     deviceId?: string; // For guest mode tracking
     createdAt: Date;
     lastLoginAt: Date;
   }
   ```

2. **User Profile**

   ```typescript
   interface UserProfile {
     id: string;
     userId: string;
     displayName: string;
     firstName?: string;
     lastName?: string;
     dateOfBirth?: Date;
     gender?: Gender;
     language: Language;
     photoUrl?: string;
     useElderMode: boolean;
     preferredUnits: UnitPreferences;
     emergencyContact?: EmergencyContact;
   }
   ```

3. **Permission Set**

   ```typescript
   interface PermissionSet {
     id: string;
     userId: string;
     roles: Role[];
     customPermissions: Permission[];
     dataAccessLevel: DataAccessLevel;
     isAdmin: boolean;
   }
   ```

4. **Authentication Method**
   ```typescript
   interface AuthMethod {
     id: string;
     userId: string;
     type: AuthMethodType; // Email, Phone, Google, Apple, etc.
     identifier: string; // Email, phone number, etc.
     isVerified: boolean;
     lastUsed: Date;
   }
   ```

#### Value Objects

```typescript
enum AuthProvider {
  EMAIL = "email",
  PHONE = "phone",
  GOOGLE = "google",
  APPLE = "apple",
  FACEBOOK = "facebook",
  ANONYMOUS = "anonymous",
}

enum Gender {
  MALE = "male",
  FEMALE = "female",
  OTHER = "other",
  PREFER_NOT_TO_SAY = "prefer_not_to_say",
}

enum Language {
  ENGLISH = "en",
  VIETNAMESE = "vi",
}

enum Role {
  USER = "user",
  CAREGIVER = "caregiver",
  FAMILY_ADMIN = "family_admin",
  SYSTEM_ADMIN = "system_admin",
}

enum DataAccessLevel {
  NONE = "none",
  BASIC = "basic",
  STANDARD = "standard",
  FULL = "full",
}

interface UnitPreferences {
  weight: "kg" | "lb";
  height: "cm" | "ft";
  temperature: "c" | "f";
  glucose: "mmol/L" | "mg/dL";
}

interface EmergencyContact {
  name: string;
  relationship: string;
  phoneNumber: string;
  isEmergencyContact: boolean;
  canAccessHealthData: boolean;
}
```

### Key APIs

#### Authentication API

```typescript
interface AuthenticationService {
  // Email authentication
  registerWithEmailAndPassword(
    email: string,
    password: string
  ): Promise<UserCredential>;
  signInWithEmailAndPassword(
    email: string,
    password: string
  ): Promise<UserCredential>;

  // Phone authentication
  verifyPhoneNumber(
    phoneNumber: string,
    callbacks: PhoneAuthCallbacks
  ): Promise<void>;
  signInWithPhoneAuthCredential(
    credential: PhoneAuthCredential
  ): Promise<UserCredential>;

  // Social authentication
  signInWithGoogle(): Promise<UserCredential>;
  signInWithApple(): Promise<UserCredential>;

  // Guest authentication
  signInAnonymously(): Promise<UserCredential>;
  convertAnonymousToRegistered(
    credential: AuthCredential
  ): Promise<UserCredential>;

  // Session management
  getCurrentUser(): User | null;
  signOut(): Promise<void>;
  refreshToken(): Promise<string>;

  // Account recovery
  sendPasswordResetEmail(email: string): Promise<void>;
  confirmPasswordReset(code: string, newPassword: string): Promise<void>;

  // Multi-factor authentication
  enableMultiFactorAuth(user: User, phoneNumber: string): Promise<void>;
  verifyMultiFactorCode(
    user: User,
    verificationId: string,
    code: string
  ): Promise<void>;
}
```

#### User Profile API

```typescript
interface UserProfileService {
  getProfile(userId: string): Promise<UserProfile>;
  updateProfile(
    userId: string,
    profile: Partial<UserProfile>
  ): Promise<UserProfile>;
  setProfilePicture(userId: string, imageFile: File): Promise<string>;
  deleteProfilePicture(userId: string): Promise<void>;
  getEmergencyContacts(userId: string): Promise<EmergencyContact[]>;
  updateEmergencyContact(
    userId: string,
    contact: EmergencyContact
  ): Promise<EmergencyContact>;
}
```

#### Permission Management API

```typescript
interface PermissionService {
  getUserRoles(userId: string): Promise<Role[]>;
  assignRole(userId: string, role: Role): Promise<void>;
  removeRole(userId: string, role: Role): Promise<void>;
  hasPermission(userId: string, permission: Permission): Promise<boolean>;
  grantPermission(userId: string, permission: Permission): Promise<void>;
  revokePermission(userId: string, permission: Permission): Promise<void>;
  getDataAccessLevel(userId: string): Promise<DataAccessLevel>;
  setDataAccessLevel(userId: string, level: DataAccessLevel): Promise<void>;
}
```

### Dependencies and Interactions

- **Firebase Authentication**: Core dependency for identity management
- **Firestore Database**: For storing user profiles and extended data
- **Redis**: For session management and token storage
- **Notification Context**: For sending verification and security alerts
- **Health Data Context**: Permissions in IAC control access to health data
- **Care Group Context**: Roles in IAC affect permissions in care groups
- **Subscription Context**: Subscription status affects feature access permissions

### Backend Implementation Notes

1. **Firebase Authentication Integration**

   - Utilize Firebase Admin SDK for server-side operations
   - Implement custom claims for role-based access control
   - Set up security rules for Firestore based on authentication state

2. **Guest Mode Implementation**

   - Store device identifier securely to prevent multiple guest accounts
   - Implement data migration strategy for guest-to-registered user conversion
   - Apply appropriate data access restrictions for guest users

3. **Multi-Factor Authentication**

   - Use Firebase's multi-factor authentication capabilities
   - Store backup authentication methods securely
   - Implement progressive security based on operation sensitivity

4. **Session Management**

   - Implement token refresh mechanism
   - Store session metadata for activity tracking
   - Handle concurrent sessions across devices

5. **Audit Logging**
   - Track authentication events
   - Log access to sensitive data
   - Implement anomaly detection for security events

### Mobile Implementation Notes

1. **Secure Storage**

   - Use platform-specific secure storage (Keychain for iOS, EncryptedSharedPreferences for Android)
   - Implement secure credential caching for offline authentication

2. **Biometric Authentication**

   - Integrate with local authentication APIs
   - Implement fallback mechanisms for biometric failures
   - Store biometric verification status securely

3. **Authentication UI**

   - Create consistent authentication flows across platforms
   - Implement error handling with user-friendly messages
   - Support both light and dark mode for authentication screens

4. **Offline Authentication**
   - Cache authentication tokens securely
   - Implement token refresh on reconnection
   - Handle expired credentials during offline periods

## Implementation Tasks

### Backend Implementation Requirements

1. Set up Firebase Authentication project and configure settings
2. Implement Firebase Admin SDK integration in NestJS
3. Create user repository and domain services
4. Build role-based access control system with custom Firebase claims
5. Implement authentication middleware for API protection
6. Develop guest mode authentication flow with device tracking
7. Create multi-factor authentication implementation
8. Build account recovery mechanisms with secure token handling
9. Implement session management with Redis for token storage
10. Create audit logging service for authentication events
11. Develop health check endpoints for authentication services
12. Implement rate limiting for authentication endpoints

### Mobile Implementation Requirements

1. Integrate Firebase Authentication SDK
2. Implement secure credential storage using platform security features
3. Create login/registration screens with form validation
4. Build biometric authentication integration
5. Implement social login options (Google, Apple)
6. Create profile management UI with photo upload capability
7. Develop permission request UI for sensitive operations
8. Build token management and refresh system
9. Implement offline authentication mechanisms
10. Create account recovery flow with verification
11. Develop Elder Mode UI adaptations for authentication screens
12. Create guest mode experience with conversion prompts

## References

### Libraries and Services

- **Firebase Authentication**: Authentication service for user identity management

  - Documentation: [Firebase Auth](https://firebase.google.com/docs/auth)
  - Features: Email/password auth, OAuth providers, phone auth, anonymous auth

- **@nestjs/passport**: NestJS authentication library

  - Documentation: [NestJS Passport](https://docs.nestjs.com/security/authentication)
  - Features: Authentication strategies, guards, custom decorators

- **flutter_secure_storage**: Secure storage for Flutter applications

  - Package: [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
  - Features: Encrypted storage, biometric protection, key rotation

- **local_auth**: Biometric authentication for Flutter
  - Package: [local_auth](https://pub.dev/packages/local_auth)
  - Features: Fingerprint, face ID, PIN fallback

### Standards and Best Practices

- **OWASP Authentication Best Practices**

  - Multi-factor authentication
  - Rate limiting and account lockout
  - Secure password hashing

- **OAuth 2.0 and OpenID Connect**
  - Token-based authentication flow
  - Scope-based permissions
  - Refresh token rotation
