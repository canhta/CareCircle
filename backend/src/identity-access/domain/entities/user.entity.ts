import {
  AuthMethodType,
  Gender,
  Language,
  Role,
  DataAccessLevel,
  Permission,
} from '@prisma/client';

export interface UnitPreferences {
  weight: 'kg' | 'lb';
  height: 'cm' | 'ft';
  temperature: 'c' | 'f';
  glucose: 'mmol/L' | 'mg/dL';
}

export interface EmergencyContact {
  name: string;
  relationship: string;
  phoneNumber: string;
  isEmergencyContact: boolean;
  canAccessHealthData: boolean;
}

export class UserAccount {
  constructor(
    public readonly id: string,
    public email?: string,
    public phoneNumber?: string,
    public isEmailVerified: boolean = false,
    public isPhoneVerified: boolean = false,
    public isGuest: boolean = false,
    public deviceId?: string,
    public readonly createdAt: Date = new Date(),
    public lastLoginAt: Date = new Date(),
    public readonly updatedAt: Date = new Date(),
  ) {}

  static create(data: {
    id?: string;
    email?: string;
    phoneNumber?: string;
    isGuest?: boolean;
    deviceId?: string;
  }): UserAccount {
    return new UserAccount(
      data.id || crypto.randomUUID(),
      data.email,
      data.phoneNumber,
      false,
      false,
      data.isGuest || false,
      data.deviceId,
    );
  }

  updateLastLogin(): void {
    this.lastLoginAt = new Date();
  }

  verifyEmail(): void {
    this.isEmailVerified = true;
  }

  verifyPhone(): void {
    this.isPhoneVerified = true;
  }

  convertFromGuest(email?: string, phoneNumber?: string): void {
    if (this.isGuest) {
      this.isGuest = false;
      if (email) this.email = email;
      if (phoneNumber) this.phoneNumber = phoneNumber;
    }
  }
}

export class UserProfile {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public displayName: string,
    public firstName?: string,
    public lastName?: string,
    public dateOfBirth?: Date,
    public gender?: Gender,
    public language: Language = Language.ENGLISH,
    public photoUrl?: string,
    public useElderMode: boolean = false,
    public preferredUnits: UnitPreferences = {
      weight: 'kg',
      height: 'cm',
      temperature: 'c',
      glucose: 'mmol/L',
    },
    public emergencyContact?: EmergencyContact,
    public readonly createdAt: Date = new Date(),
    public readonly updatedAt: Date = new Date(),
  ) {}

  static create(data: {
    userId: string;
    displayName: string;
    firstName?: string;
    lastName?: string;
    dateOfBirth?: Date;
    gender?: Gender;
    language?: Language;
  }): UserProfile {
    return new UserProfile(
      crypto.randomUUID(),
      data.userId,
      data.displayName,
      data.firstName,
      data.lastName,
      data.dateOfBirth,
      data.gender,
      data.language || Language.ENGLISH,
    );
  }

  updateProfile(
    updates: Partial<{
      displayName: string;
      firstName: string;
      lastName: string;
      dateOfBirth: Date;
      gender: Gender;
      language: Language;
      photoUrl: string;
      useElderMode: boolean;
      preferredUnits: UnitPreferences;
      emergencyContact: EmergencyContact;
    }>,
  ): void {
    Object.assign(this, updates);
  }
}

export class AuthMethod {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public readonly type: AuthMethodType,
    public readonly identifier: string,
    public isVerified: boolean = false,
    public lastUsed: Date = new Date(),
    public readonly createdAt: Date = new Date(),
  ) {}

  static create(data: {
    userId: string;
    type: AuthMethodType;
    identifier: string;
    isVerified?: boolean;
  }): AuthMethod {
    return new AuthMethod(
      crypto.randomUUID(),
      data.userId,
      data.type,
      data.identifier,
      data.isVerified || false,
    );
  }

  verify(): void {
    this.isVerified = true;
  }

  updateLastUsed(): void {
    this.lastUsed = new Date();
  }
}

export class PermissionSet {
  constructor(
    public readonly id: string,
    public readonly userId: string,
    public roles: Role[] = [Role.USER],
    public customPermissions: Permission[] = [],
    public dataAccessLevel: DataAccessLevel = DataAccessLevel.BASIC,
    public isAdmin: boolean = false,
    public readonly createdAt: Date = new Date(),
    public readonly updatedAt: Date = new Date(),
  ) {}

  static create(data: {
    userId: string;
    roles?: Role[];
    dataAccessLevel?: DataAccessLevel;
  }): PermissionSet {
    return new PermissionSet(
      crypto.randomUUID(),
      data.userId,
      data.roles || [Role.USER],
      [],
      data.dataAccessLevel || DataAccessLevel.BASIC,
    );
  }

  addRole(role: Role): void {
    if (!this.roles.includes(role)) {
      this.roles.push(role);
    }
  }

  removeRole(role: Role): void {
    this.roles = this.roles.filter((r) => r !== role);
  }

  hasRole(role: Role): boolean {
    return this.roles.includes(role);
  }

  grantPermission(permission: Permission): void {
    if (!this.customPermissions.includes(permission)) {
      this.customPermissions.push(permission);
    }
  }

  revokePermission(permission: Permission): void {
    this.customPermissions = this.customPermissions.filter(
      (p) => p !== permission,
    );
  }

  hasPermission(permission: Permission): boolean {
    return this.customPermissions.includes(permission);
  }

  setDataAccessLevel(level: DataAccessLevel): void {
    this.dataAccessLevel = level;
  }

  makeAdmin(): void {
    this.isAdmin = true;
    this.addRole(Role.SYSTEM_ADMIN);
  }

  removeAdmin(): void {
    this.isAdmin = false;
    this.removeRole(Role.SYSTEM_ADMIN);
  }
}
