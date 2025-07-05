import { SetMetadata } from '@nestjs/common';
import { CareRole } from '@prisma/client';
import { CareGroupMethodDecorator } from '../../common/interfaces/care-group.interfaces';

// Role-based permission decorator
export const CARE_GROUP_ROLES_KEY = 'careGroupRoles';
export const CareGroupRoles = (...roles: CareRole[]) =>
  SetMetadata(CARE_GROUP_ROLES_KEY, roles);

// Permission-based access decorator
export const CARE_GROUP_PERMISSIONS_KEY = 'careGroupPermissions';
export type CareGroupPermission =
  | 'viewHealth'
  | 'receiveAlerts'
  | 'manageSettings'
  | 'manageMembers'
  | 'viewMembers';

export const RequireCareGroupPermissions = (
  ...permissions: CareGroupPermission[]
) => SetMetadata(CARE_GROUP_PERMISSIONS_KEY, permissions);

// Resource ownership decorator
export const CARE_GROUP_RESOURCE_KEY = 'careGroupResource';
export type CareGroupResource = 'careGroup' | 'member' | 'invitation';

export const CareGroupResource = (resource: CareGroupResource) =>
  SetMetadata(CARE_GROUP_RESOURCE_KEY, resource);

// Combined decorator for common use cases
export const CareGroupAccess = (
  roles: CareRole[] = [],
  permissions: CareGroupPermission[] = [],
  resource?: CareGroupResource,
) => {
  return (
    target: object,
    propertyName: string,
    descriptor: PropertyDescriptor,
  ) => {
    if (roles.length > 0) {
      CareGroupRoles(...roles)(target, propertyName, descriptor);
    }
    if (permissions.length > 0) {
      RequireCareGroupPermissions(...permissions)(
        target,
        propertyName,
        descriptor,
      );
    }
    if (resource) {
      CareGroupResource(resource)(target, propertyName, descriptor);
    }
  };
};
