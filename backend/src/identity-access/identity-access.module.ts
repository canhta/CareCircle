import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

// Domain Layer
import { UserRepository } from './domain/repositories/user.repository';
import { AuthMethodRepository } from './domain/repositories/auth-method.repository';
import { PermissionRepository } from './domain/repositories/permission.repository';

// Application Layer
import { AuthService } from './application/services/auth.service';
import { UserService } from './application/services/user.service';
import { PermissionService } from './application/services/permission.service';

// Infrastructure Layer
import { PrismaUserRepository } from './infrastructure/repositories/prisma-user.repository';
import { PrismaAuthMethodRepository } from './infrastructure/repositories/prisma-auth-method.repository';
import { PrismaPermissionRepository } from './infrastructure/repositories/prisma-permission.repository';
import { FirebaseAuthService } from './infrastructure/services/firebase-auth.service';

// Presentation Layer
import { AuthController } from './presentation/controllers/auth.controller';
import { UserController } from './presentation/controllers/user.controller';

// Guards and Middleware
import { FirebaseAuthGuard } from './presentation/guards/firebase-auth.guard';

@Module({
  imports: [ConfigModule],
  controllers: [AuthController, UserController],
  providers: [
    // Application Services
    AuthService,
    UserService,
    PermissionService,

    // Infrastructure Services
    FirebaseAuthService,

    // Repository Implementations
    {
      provide: UserRepository,
      useClass: PrismaUserRepository,
    },
    {
      provide: AuthMethodRepository,
      useClass: PrismaAuthMethodRepository,
    },
    {
      provide: PermissionRepository,
      useClass: PrismaPermissionRepository,
    },

    // Guards
    FirebaseAuthGuard,
  ],
  exports: [
    AuthService,
    UserService,
    PermissionService,
    FirebaseAuthGuard,
    FirebaseAuthService,
  ],
})
export class IdentityAccessModule {}
