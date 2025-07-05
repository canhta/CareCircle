import {
  PipeTransform,
  Injectable,
  ArgumentMetadata,
  BadRequestException,
  Logger,
} from '@nestjs/common';

@Injectable()
export class TransformationPipe implements PipeTransform {
  private readonly logger = new Logger(TransformationPipe.name);

  transform(value: any, metadata: ArgumentMetadata) {
    if (!value) {
      return value;
    }

    try {
      switch (metadata.type) {
        case 'body':
          return this.transformBody(value);
        case 'query':
          return this.transformQuery(value);
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

  private transformBody(body: any): any {
    if (typeof body !== 'object') {
      return body;
    }

    const transformed = { ...body };

    // Transform common fields
    Object.keys(transformed).forEach((key) => {
      const value = transformed[key];

      // Transform date strings to Date objects
      if (this.isDateString(value)) {
        transformed[key] = new Date(value);
      }

      // Transform string numbers to actual numbers
      if (this.isNumericString(value)) {
        transformed[key] = Number(value);
      }

      // Transform string booleans to actual booleans
      if (this.isBooleanString(value)) {
        transformed[key] = value.toLowerCase() === 'true';
      }

      // Trim string values
      if (typeof value === 'string') {
        transformed[key] = value.trim();
      }

      // Transform arrays recursively
      if (Array.isArray(value)) {
        transformed[key] = value.map((item) =>
          typeof item === 'object' ? this.transformBody(item) : item,
        );
      }

      // Transform nested objects recursively
      if (
        typeof value === 'object' &&
        value !== null &&
        !Array.isArray(value)
      ) {
        transformed[key] = this.transformBody(value);
      }
    });

    return transformed;
  }

  private transformQuery(query: any): any {
    const transformed = { ...query };

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
        transformed.filters[filterKey] = value;
        delete transformed[key];
      }

      // Transform date range parameters
      if (['startDate', 'endDate', 'fromDate', 'toDate'].includes(key)) {
        if (this.isDateString(value)) {
          transformed[key] = new Date(value);
        }
      }

      // Transform boolean query parameters
      if (this.isBooleanString(value)) {
        transformed[key] = value.toLowerCase() === 'true';
      }
    });

    return transformed;
  }

  private transformParam(param: any, metadata: ArgumentMetadata): any {
    const paramName = metadata.data;

    // Transform ID parameters to ensure they're strings
    if (paramName && paramName.toLowerCase().includes('id')) {
      return String(param);
    }

    // Transform numeric parameters
    if (paramName && ['page', 'limit', 'offset'].includes(paramName)) {
      return this.parseInteger(param, paramName);
    }

    return param;
  }

  private parseInteger(value: any, fieldName: string): number {
    const parsed = parseInt(value, 10);
    if (isNaN(parsed)) {
      throw new BadRequestException(`${fieldName} must be a valid integer`);
    }
    return parsed;
  }

  private isDateString(value: any): boolean {
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

  private isNumericString(value: any): boolean {
    return (
      typeof value === 'string' &&
      !isNaN(Number(value)) &&
      !isNaN(parseFloat(value))
    );
  }

  private isBooleanString(value: any): boolean {
    return (
      typeof value === 'string' &&
      ['true', 'false'].includes(value.toLowerCase())
    );
  }
}
