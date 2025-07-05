import { CareRole } from '@prisma/client';

/**
 * Interface representing a care group membership
 */
export interface CareGroupMembership {
  id: string;
  careGroupId: string;
  userId: string;
  role: CareRole;
  joinedAt: Date;
  isActive: boolean;
  canViewHealth: boolean;
  canReceiveAlerts: boolean;
  canManageSettings: boolean;
}

/**
 * Interface for the decorated method parameter
 */
export interface CareGroupMethodDecorator {
  target: object;
  propertyName: string;
  descriptor: PropertyDescriptor;
}

/**
 * Interface for user authentication with care group context
 */
export interface AuthUserWithCareGroup {
  sub: string;
  email: string;
  careGroupMembership?: CareGroupMembership;
}

/**
 * Interface for request with care group context
 */
export interface RequestWithCareGroup {
  user: AuthUserWithCareGroup;
  params: Record<string, string>;
  body: Record<string, unknown>;
  careGroupMembership?: CareGroupMembership;
}
