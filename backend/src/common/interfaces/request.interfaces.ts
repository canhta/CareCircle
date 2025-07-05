import { Request } from 'express';
import { User } from '@prisma/client';

/**
 * Interface for user data in authenticated requests
 */
export interface AuthUser extends Omit<User, 'password'> {
  isAuthenticated: boolean; // Add a property to distinguish from base type
  sub: string; // User ID from JWT token
}

/**
 * Type for a request with the authenticated user
 */
export type RequestWithUser = Request & {
  user: AuthUser;
};

/**
 * Pagination parameters commonly used in queries
 */
export interface PaginationOptions {
  page: number;
  limit: number;
  skip: number;
}

/**
 * Convert string pagination parameters to a pagination options object
 */
export function parsePaginationParams(
  page?: string | number,
  limit?: string | number,
): PaginationOptions {
  const parsedPage =
    typeof page === 'string' ? parseInt(page, 10) : Number(page) || 1;
  const parsedLimit =
    typeof limit === 'string' ? parseInt(limit, 10) : Number(limit) || 20;

  return {
    page: Math.max(1, parsedPage),
    limit: Math.max(1, Math.min(100, parsedLimit)),
    skip:
      (Math.max(1, parsedPage) - 1) * Math.max(1, Math.min(100, parsedLimit)),
  };
}

/**
 * Base interface for paginated responses
 */
export interface PaginatedResponse<T> {
  data: T[];
  meta: {
    page: number;
    limit: number;
    totalItems: number;
    totalPages: number;
  };
}
