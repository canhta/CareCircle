import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';

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
import { JwtAuthGuard } from './presentation/guards/jwt-auth.guard';
import { FirebaseAuthGuard } from './presentation/guards/firebase-auth.guard';

@Module({
  imports: [
    ConfigModule,
    JwtModule.registerAsync({
      useFactory: () => ({
        secret: process.env.JWT_SECRET,
        signOptions: { expiresIn: process.env.JWT_EXPIRES_IN || '7d' },
      }),
    }),
  ],
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
    JwtAuthGuard,
    FirebaseAuthGuard,
  ],
  exports: [
    AuthService,
    UserService,
    PermissionService,
    JwtAuthGuard,
    FirebaseAuthGuard,
  ],
})
export class IdentityAccessModule {}
