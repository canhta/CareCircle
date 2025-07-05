/**
 * Common interfaces for transformation pipe
 */

/**
 * Interface for objects that can be transformed
 */
export interface TransformableObject {
  [key: string]: unknown;
}

/**
 * Interface for paginated query parameters
 */
export interface PaginationQueryParams {
  page?: number | string;
  limit?: number | string;
  offset?: number | string;
  take?: number | string;
  skip?: number | string;
}

/**
 * Interface for date range query parameters
 */
export interface DateRangeQueryParams {
  startDate?: string | Date;
  endDate?: string | Date;
  fromDate?: string | Date;
  toDate?: string | Date;
}

/**
 * Interface for sort parameters
 */
export interface SortQueryParams {
  sortBy?: string | string[];
  order?: 'asc' | 'desc';
}

/**
 * Interface for filter parameters
 */
export interface FilterQueryParams {
  [key: string]: string | number | boolean;
}

/**
 * Combined query parameters interface
 */
export interface TransformableQueryParams
  extends PaginationQueryParams,
    DateRangeQueryParams,
    SortQueryParams {
  filters?: FilterQueryParams;
  [key: string]: unknown;
}
