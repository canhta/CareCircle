import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { ConfigModule } from '@nestjs/config';
import { CareGroupService } from './care-group.service';
import { CareGroupController } from './care-group.controller';
import { CareGroupInvitationService } from './care-group-invitation.service';
import { CareGroupDashboardService } from './care-group-dashboard.service';
import { DeepLinkService } from './deep-link.service';
import { CareGroupRolesGuard } from './guards/care-group-roles.guard';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule, JwtModule, ConfigModule],
  providers: [
    CareGroupService,
    CareGroupInvitationService,
    CareGroupDashboardService,
    DeepLinkService,
    CareGroupRolesGuard,
  ],
  controllers: [CareGroupController],
  exports: [
    CareGroupService,
    CareGroupInvitationService,
    CareGroupDashboardService,
    DeepLinkService,
  ],
})
export class CareGroupModule {}
