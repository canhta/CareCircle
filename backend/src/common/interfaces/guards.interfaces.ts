/**
 * Interfaces for guard functionality
 */

import { Request } from 'express';
import { SystemRole, Permission } from '../decorators/roles.decorator';
import { PHIAccessMetadata } from '../decorators/phi-access.decorator';

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

/**
 * IP and user data for request objects
 */
export type RequestIPData = {
  user?: {
    id?: string;
    sub?: string;
    [key: string]: unknown;
  };
  ip: string;
  connection?: {
    remoteAddress?: string;
  };
  socket?: {
    remoteAddress?: string;
  };
  correlationId?: string;
  headers: Record<string, string | string[] | undefined>;
  method: string;
  url: string;
  get(name: string): string | string[] | undefined;
};

/**
 * IP audit data
 */
export interface IPAuditData {
  userId: string;
  ip: string;
  url: string;
  method: string;
  timestamp: Date;
  result: 'ALLOWED' | 'BLOCKED';
  details?: {
    [key: string]: unknown;
  };
}

/**
 * PHI access audit data
 */
export interface PHIAccessAuditData {
  userId: string;
  action: string;
  resource: string;
  details: {
    purpose?: string;
    dataTypes?: string[];
    level?: string;
    [key: string]: unknown;
  };
  ip?: string;
  userAgent?: string;
  correlationId: string;
  timestamp: Date;
}
