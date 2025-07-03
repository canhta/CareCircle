import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { UserModule } from './user/user.module';
import { AuthModule } from './auth/auth.module';
import { HealthRecordModule } from './health-record/health-record.module';
import { PrescriptionModule } from './prescription/prescription.module';
import { CareGroupModule } from './care-group/care-group.module';
import { DailyCheckInModule } from './daily-check-in/daily-check-in.module';
import { NotificationModule } from './notification/notification.module';
import { DocumentModule } from './document/document.module';
import appConfig from './config/app.config';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
      load: [appConfig],
    }),
    PrismaModule,
    UserModule,
    AuthModule,
    HealthRecordModule,
    PrescriptionModule,
    CareGroupModule,
    DailyCheckInModule,
    NotificationModule,
    DocumentModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
