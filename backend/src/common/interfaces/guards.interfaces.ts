/**
 * Interfaces for guard functionality
 */

import { Request } from 'express';
import { SystemRole, Permission } from '../decorators/roles.decorator';

/**
 * User with roles information
 */
export interface UserWithRoles {
  id: string;
  email: string;
  isActive: boolean;
  roles: SystemRole[] | SystemRole;
  sub?: string;
  [key: string]: unknown;
}

/**
 * Authentication failure details
 */
export interface AuthFailureDetails {
  reason?: string;
  requiredRoles?: SystemRole[];
  userRoles?: SystemRole[] | SystemRole;
  requiredPermissions?: Permission[];
  userPermissions?: Permission[];
  ip?: string;
  userAgent?: string;
  [key: string]: unknown;
}

/**
 * Typed request object for use in guards
 */
export interface GuardRequest extends Request {
  user?: UserWithRoles;
}
