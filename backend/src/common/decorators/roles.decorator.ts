import { SetMetadata } from '@nestjs/common';

// System roles
export enum SystemRole {
  SUPER_ADMIN = 'SUPER_ADMIN',
  ADMIN = 'ADMIN',
  HEALTHCARE_PROVIDER = 'HEALTHCARE_PROVIDER',
  USER = 'USER',
  GUEST = 'GUEST',
}

// Permission types
export enum Permission {
  // User management
  CREATE_USER = 'CREATE_USER',
  READ_USER = 'READ_USER',
  UPDATE_USER = 'UPDATE_USER',
  DELETE_USER = 'DELETE_USER',

  // Health records
  CREATE_HEALTH_RECORD = 'CREATE_HEALTH_RECORD',
  READ_HEALTH_RECORD = 'READ_HEALTH_RECORD',
  UPDATE_HEALTH_RECORD = 'UPDATE_HEALTH_RECORD',
  DELETE_HEALTH_RECORD = 'DELETE_HEALTH_RECORD',

  // Prescriptions
  CREATE_PRESCRIPTION = 'CREATE_PRESCRIPTION',
  READ_PRESCRIPTION = 'READ_PRESCRIPTION',
  UPDATE_PRESCRIPTION = 'UPDATE_PRESCRIPTION',
  DELETE_PRESCRIPTION = 'DELETE_PRESCRIPTION',

  // Care groups
  CREATE_CARE_GROUP = 'CREATE_CARE_GROUP',
  READ_CARE_GROUP = 'READ_CARE_GROUP',
  UPDATE_CARE_GROUP = 'UPDATE_CARE_GROUP',
  DELETE_CARE_GROUP = 'DELETE_CARE_GROUP',
  MANAGE_CARE_GROUP_MEMBERS = 'MANAGE_CARE_GROUP_MEMBERS',

  // Notifications
  SEND_NOTIFICATION = 'SEND_NOTIFICATION',
  READ_NOTIFICATION = 'READ_NOTIFICATION',
  MANAGE_NOTIFICATION_TEMPLATES = 'MANAGE_NOTIFICATION_TEMPLATES',

  // Analytics
  READ_ANALYTICS = 'READ_ANALYTICS',
  READ_SYSTEM_METRICS = 'READ_SYSTEM_METRICS',

  // Administration
  MANAGE_SUBSCRIPTIONS = 'MANAGE_SUBSCRIPTIONS',
  ACCESS_AUDIT_LOGS = 'ACCESS_AUDIT_LOGS',
  MANAGE_SYSTEM_SETTINGS = 'MANAGE_SYSTEM_SETTINGS',

  // AI Services
  USE_AI_INSIGHTS = 'USE_AI_INSIGHTS',
  MANAGE_AI_SETTINGS = 'MANAGE_AI_SETTINGS',
}

// Role-based permissions mapping
export const ROLE_PERMISSIONS: Record<SystemRole, Permission[]> = {
  [SystemRole.SUPER_ADMIN]: Object.values(Permission),

  [SystemRole.ADMIN]: [
    Permission.CREATE_USER,
    Permission.READ_USER,
    Permission.UPDATE_USER,
    Permission.READ_HEALTH_RECORD,
    Permission.READ_PRESCRIPTION,
    Permission.READ_CARE_GROUP,
    Permission.SEND_NOTIFICATION,
    Permission.READ_NOTIFICATION,
    Permission.MANAGE_NOTIFICATION_TEMPLATES,
    Permission.READ_ANALYTICS,
    Permission.READ_SYSTEM_METRICS,
    Permission.MANAGE_SUBSCRIPTIONS,
    Permission.ACCESS_AUDIT_LOGS,
    Permission.USE_AI_INSIGHTS,
  ],

  [SystemRole.HEALTHCARE_PROVIDER]: [
    Permission.READ_USER,
    Permission.CREATE_HEALTH_RECORD,
    Permission.READ_HEALTH_RECORD,
    Permission.UPDATE_HEALTH_RECORD,
    Permission.CREATE_PRESCRIPTION,
    Permission.READ_PRESCRIPTION,
    Permission.UPDATE_PRESCRIPTION,
    Permission.READ_CARE_GROUP,
    Permission.SEND_NOTIFICATION,
    Permission.READ_NOTIFICATION,
    Permission.READ_ANALYTICS,
    Permission.USE_AI_INSIGHTS,
  ],

  [SystemRole.USER]: [
    Permission.READ_USER,
    Permission.UPDATE_USER,
    Permission.CREATE_HEALTH_RECORD,
    Permission.READ_HEALTH_RECORD,
    Permission.UPDATE_HEALTH_RECORD,
    Permission.DELETE_HEALTH_RECORD,
    Permission.CREATE_PRESCRIPTION,
    Permission.READ_PRESCRIPTION,
    Permission.UPDATE_PRESCRIPTION,
    Permission.DELETE_PRESCRIPTION,
    Permission.CREATE_CARE_GROUP,
    Permission.READ_CARE_GROUP,
    Permission.UPDATE_CARE_GROUP,
    Permission.DELETE_CARE_GROUP,
    Permission.MANAGE_CARE_GROUP_MEMBERS,
    Permission.READ_NOTIFICATION,
    Permission.USE_AI_INSIGHTS,
  ],

  [SystemRole.GUEST]: [Permission.READ_USER],
};

// Metadata keys
export const ROLES_KEY = 'roles';
export const PERMISSIONS_KEY = 'permissions';

/**
 * Decorator to require specific roles
 */
export const Roles = (...roles: SystemRole[]) => SetMetadata(ROLES_KEY, roles);

/**
 * Decorator to require specific permissions
 */
export const RequirePermissions = (...permissions: Permission[]) =>
  SetMetadata(PERMISSIONS_KEY, permissions);

/**
 * Convenience decorators for common role combinations
 */
export const AdminOnly = () => Roles(SystemRole.SUPER_ADMIN, SystemRole.ADMIN);

export const HealthcareProviderOrAdmin = () =>
  Roles(
    SystemRole.SUPER_ADMIN,
    SystemRole.ADMIN,
    SystemRole.HEALTHCARE_PROVIDER,
  );

export const AuthenticatedUser = () =>
  Roles(
    SystemRole.SUPER_ADMIN,
    SystemRole.ADMIN,
    SystemRole.HEALTHCARE_PROVIDER,
    SystemRole.USER,
  );

/**
 * Convenience decorators for common permission combinations
 */
export const CanReadHealthRecords = () =>
  RequirePermissions(Permission.READ_HEALTH_RECORD);

export const CanWriteHealthRecords = () =>
  RequirePermissions(
    Permission.CREATE_HEALTH_RECORD,
    Permission.UPDATE_HEALTH_RECORD,
  );

export const CanManagePrescriptions = () =>
  RequirePermissions(
    Permission.CREATE_PRESCRIPTION,
    Permission.READ_PRESCRIPTION,
    Permission.UPDATE_PRESCRIPTION,
  );

export const CanManageCareGroups = () =>
  RequirePermissions(
    Permission.CREATE_CARE_GROUP,
    Permission.READ_CARE_GROUP,
    Permission.UPDATE_CARE_GROUP,
    Permission.MANAGE_CARE_GROUP_MEMBERS,
  );

export const CanAccessAnalytics = () =>
  RequirePermissions(Permission.READ_ANALYTICS);

export const CanAccessAuditLogs = () =>
  RequirePermissions(Permission.ACCESS_AUDIT_LOGS);

export const CanUseAI = () => RequirePermissions(Permission.USE_AI_INSIGHTS);
