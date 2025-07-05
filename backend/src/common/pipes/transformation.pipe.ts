import {
  PipeTransform,
  Injectable,
  ArgumentMetadata,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import {
  TransformableObject,
  TransformableQueryParams,
  FilterQueryParams,
} from '../interfaces/transformation.interfaces';

@Injectable()
export class TransformationPipe implements PipeTransform {
  private readonly logger = new Logger(TransformationPipe.name);

  transform(value: unknown, metadata: ArgumentMetadata): unknown {
    if (!value) {
      return value;
    }

    try {
      switch (metadata.type) {
        case 'body':
          return this.transformBody(value as TransformableObject);
        case 'query':
          return this.transformQuery(value as TransformableQueryParams);
        case 'param':
          return this.transformParam(value, metadata);
        default:
          return value;
      }
    } catch (error) {
      this.logger.error(`Transformation error: ${error.message}`, error.stack);
      throw new BadRequestException(`Invalid data format: ${error.message}`);
    }
  }

  private transformBody(body: TransformableObject): TransformableObject {
    if (typeof body !== 'object' || body === null) {
      return body;
    }

    const transformed: TransformableObject = { ...body };

    // Transform common fields
    Object.keys(transformed).forEach((key) => {
      const value = transformed[key];

      // Transform date strings to Date objects
      if (this.isDateString(value)) {
        transformed[key] = new Date(value as string);
      }

      // Transform string numbers to actual numbers
      if (this.isNumericString(value)) {
        transformed[key] = Number(value);
      }

      // Transform string booleans to actual booleans
      if (this.isBooleanString(value)) {
        transformed[key] = (value as string).toLowerCase() === 'true';
      }

      // Trim string values
      if (typeof value === 'string') {
        transformed[key] = value.trim();
      }

      // Transform arrays recursively
      if (Array.isArray(value)) {
        transformed[key] = value.map((item) =>
          typeof item === 'object' && item !== null
            ? this.transformBody(item as TransformableObject)
            : item,
        );
      }

      // Transform nested objects recursively
      if (
        typeof value === 'object' &&
        value !== null &&
        !Array.isArray(value)
      ) {
        transformed[key] = this.transformBody(value as TransformableObject);
      }
    });

    return transformed;
  }

  private transformQuery(
    query: TransformableQueryParams,
  ): TransformableQueryParams {
    const transformed: TransformableQueryParams = { ...query };

    Object.keys(transformed).forEach((key) => {
      const value = transformed[key];

      // Transform pagination parameters
      if (['page', 'limit', 'offset', 'take', 'skip'].includes(key)) {
        transformed[key] = this.parseInteger(value, key);
      }

      // Transform sort parameters
      if (key === 'sortBy' && typeof value === 'string') {
        transformed[key] = value.split(',').map((s) => s.trim());
      }

      // Transform filter parameters
      if (key.startsWith('filter.')) {
        const filterKey = key.replace('filter.', '');
        if (!transformed.filters) {
          transformed.filters = {};
        }

        // Ensure the value is of the correct type for FilterQueryParams
        if (
          typeof value === 'string' ||
          typeof value === 'number' ||
          typeof value === 'boolean'
        ) {
          transformed.filters[filterKey] = value;
        }
        delete transformed[key];
      }

      // Transform date range parameters
      if (['startDate', 'endDate', 'fromDate', 'toDate'].includes(key)) {
        if (this.isDateString(value)) {
          transformed[key] = new Date(value as string);
        }
      }

      // Transform boolean query parameters
      if (this.isBooleanString(value)) {
        transformed[key] = (value as string).toLowerCase() === 'true';
      }
    });

    return transformed;
  }

  private transformParam(param: unknown, metadata: ArgumentMetadata): unknown {
    const paramName = metadata.data;

    // Transform ID parameters to ensure they're strings
    if (
      typeof paramName === 'string' &&
      paramName.toLowerCase().includes('id')
    ) {
      return String(param);
    }

    // Transform numeric parameters
    if (
      typeof paramName === 'string' &&
      ['page', 'limit', 'offset'].includes(paramName)
    ) {
      return this.parseInteger(param, paramName);
    }

    return param;
  }

  private parseInteger(value: unknown, fieldName: string): number {
    if (typeof value === 'number') {
      return Math.floor(value);
    }

    const parsed = parseInt(String(value), 10);
    if (isNaN(parsed)) {
      throw new BadRequestException(`${fieldName} must be a valid integer`);
    }
    return parsed;
  }

  private isDateString(value: unknown): boolean {
    if (typeof value !== 'string') {
      return false;
    }

    // Check for ISO date format
    const isoDateRegex = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{3})?Z?$/;
    if (isoDateRegex.test(value)) {
      return !isNaN(Date.parse(value));
    }

    // Check for simple date format
    const simpleDateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (simpleDateRegex.test(value)) {
      return !isNaN(Date.parse(value));
    }

    return false;
  }

  private isNumericString(value: unknown): boolean {
    return (
      typeof value === 'string' &&
      !isNaN(Number(value)) &&
      !isNaN(parseFloat(value))
    );
  }

  private isBooleanString(value: unknown): boolean {
    return (
      typeof value === 'string' &&
      ['true', 'false'].includes(value.toLowerCase())
    );
  }
}
