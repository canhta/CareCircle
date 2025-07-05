import {
  PipeTransform,
  Injectable,
  ArgumentMetadata,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import { validate, ValidationError } from 'class-validator';
import { plainToClass } from 'class-transformer';

@Injectable()
export class CustomValidationPipe implements PipeTransform<any> {
  private readonly logger = new Logger(CustomValidationPipe.name);

  async transform(value: any, { metatype }: ArgumentMetadata) {
    if (!metatype || !this.toValidate(metatype)) {
      return value;
    }

    const object = plainToClass(metatype, value);
    const errors = await validate(object, {
      whitelist: true, // Strip properties that don't have decorators
      forbidNonWhitelisted: true, // Throw error if non-whitelisted properties are present
      transform: true, // Transform the object to the target type
      validateCustomDecorators: true, // Validate custom decorators
    });

    if (errors.length > 0) {
      const errorMessages = this.formatValidationErrors(errors);
      this.logger.warn(`Validation failed: ${JSON.stringify(errorMessages)}`);

      throw new BadRequestException({
        message: 'Validation failed',
        errors: errorMessages,
        statusCode: 400,
      });
    }

    return object;
  }

  private toValidate(metatype: Function): boolean {
    const types: Function[] = [String, Boolean, Number, Array, Object];
    return !types.includes(metatype);
  }

  private formatValidationErrors(errors: ValidationError[]): any {
    const result = {};

    errors.forEach((error) => {
      if (error.children && error.children.length > 0) {
        // Handle nested validation errors
        result[error.property] = this.formatValidationErrors(error.children);
      } else {
        // Handle direct validation errors
        result[error.property] = Object.values(error.constraints || {});
      }
    });

    return result;
  }
}
