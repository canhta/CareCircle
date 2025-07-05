export * from './request.interfaces';
export * from './response.interfaces';
export * from './error.interfaces';
export * from './models.interfaces';
export * from './daily-check-in.interfaces';
export * from './notification.interfaces';
export * from './health-data.interfaces';
export * from './analytics.interfaces';
export * from './ai.interfaces';
export * from './notification-tracking.interfaces';
export * from './user.interfaces';
export * from './notification-behavior.interfaces';

/**
 * Default page size for pagination
 */
export const DEFAULT_PAGE_SIZE = 20;

/**
 * Maximum allowed page size for pagination
 */
export const MAX_PAGE_SIZE = 100;

/**
 * Default timeout for requests in milliseconds
 */
export const DEFAULT_TIMEOUT = 30000; // 30 seconds
