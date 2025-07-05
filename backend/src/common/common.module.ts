import { Module, Global, MiddlewareConsumer, NestModule } from '@nestjs/common';
import { APP_FILTER, APP_INTERCEPTOR, APP_PIPE, APP_GUARD } from '@nestjs/core';
import { GlobalExceptionFilter } from './filters/global-exception.filter';
import { DomainExceptionFilter } from './filters/domain-exception.filter';
import { LoggingInterceptor } from './interceptors/logging.interceptor';
import { CustomCacheInterceptor } from './interceptors/cache.interceptor';
import { TimeoutInterceptor } from './interceptors/timeout.interceptor';
import { TransactionInterceptor } from './interceptors/transaction.interceptor';
import { CustomValidationPipe } from './pipes/validation.pipe';
import { TransformationPipe } from './pipes/transformation.pipe';
import { RequestContextMiddleware } from './middleware/request-context.middleware';
import { SecurityHeadersMiddleware } from './middleware/security-headers.middleware';
import { PHIAccessGuard } from './guards/phi-access.guard';
import { RolesGuard } from './guards/roles.guard';
import { IPRestrictionGuard } from './guards/ip-restriction.guard';
import { AuditService } from './services/audit.service';
import { EncryptionService } from './services/encryption.service';
import { ComplianceService } from './services/compliance.service';
import { MetricsService } from './services/metrics.service';
import { PrismaModule } from '../prisma/prisma.module';

@Global()
@Module({
  imports: [PrismaModule],
  providers: [
    // Global Exception Filters
    {
      provide: APP_FILTER,
      useClass: GlobalExceptionFilter,
    },
    {
      provide: APP_FILTER,
      useClass: DomainExceptionFilter,
    },
    // Global Interceptors
    {
      provide: APP_INTERCEPTOR,
      useClass: LoggingInterceptor,
    },
    {
      provide: APP_INTERCEPTOR,
      useClass: CustomCacheInterceptor,
    },
    {
      provide: APP_INTERCEPTOR,
      useClass: TimeoutInterceptor,
    },
    {
      provide: APP_INTERCEPTOR,
      useClass: TransactionInterceptor,
    },
    // Global Pipes
    {
      provide: APP_PIPE,
      useClass: CustomValidationPipe,
    },
    {
      provide: APP_PIPE,
      useClass: TransformationPipe,
    },
    // Guards (available for injection, not global)
    PHIAccessGuard,
    RolesGuard,
    IPRestrictionGuard,
    // Services
    AuditService,
    EncryptionService,
    ComplianceService,
    MetricsService,
  ],
  exports: [
    AuditService,
    EncryptionService,
    ComplianceService,
    MetricsService,
    PHIAccessGuard,
    RolesGuard,
    IPRestrictionGuard,
  ],
})
export class CommonModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(SecurityHeadersMiddleware, RequestContextMiddleware)
      .forRoutes('*');
  }
}
