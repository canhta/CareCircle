import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './common/database/prisma.module';
import { IdentityAccessModule } from './identity-access/identity-access.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    PrismaModule,
    IdentityAccessModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
