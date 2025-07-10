import { Module } from '@nestjs/common';
import { PrismaModule } from '../common/database/prisma.module';

// Domain Repositories
import { CareGroupRepository } from './domain/repositories/care-group.repository';
import { CareGroupMemberRepository } from './domain/repositories/care-group-member.repository';

// Infrastructure Repositories
import { PrismaCareGroupRepository } from './infrastructure/repositories/prisma-care-group.repository';
import { PrismaCareGroupMemberRepository } from './infrastructure/repositories/prisma-care-group-member.repository';

// Application Services
import { CareGroupService } from './application/services/care-group.service';

// Presentation Controllers
import { CareGroupController } from './presentation/controllers/care-group.controller';

@Module({
  imports: [PrismaModule],
  controllers: [CareGroupController],
  providers: [
    // Application Services
    CareGroupService,

    // Repository Implementations
    {
      provide: CareGroupRepository,
      useClass: PrismaCareGroupRepository,
    },
    {
      provide: CareGroupMemberRepository,
      useClass: PrismaCareGroupMemberRepository,
    },
  ],
  exports: [
    CareGroupService,
    CareGroupRepository,
    CareGroupMemberRepository,
  ],
})
export class CareGroupModule {}
