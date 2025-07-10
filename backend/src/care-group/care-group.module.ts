import { Module } from '@nestjs/common';
import { PrismaModule } from '../common/database/prisma.module';

// Domain Repositories
import { CareGroupRepository } from './domain/repositories/care-group.repository';
import { CareGroupMemberRepository } from './domain/repositories/care-group-member.repository';
import { CareTaskRepository } from './domain/repositories/care-task.repository';
import { CareActivityRepository } from './domain/repositories/care-activity.repository';
import { CareRecipientRepository } from './domain/repositories/care-recipient.repository';

// Infrastructure Repositories
import { PrismaCareGroupRepository } from './infrastructure/repositories/prisma-care-group.repository';
import { PrismaCareGroupMemberRepository } from './infrastructure/repositories/prisma-care-group-member.repository';
import { PrismaCareTaskRepository } from './infrastructure/repositories/prisma-care-task.repository';
import { PrismaCareActivityRepository } from './infrastructure/repositories/prisma-care-activity.repository';
import { PrismaCareRecipientRepository } from './infrastructure/repositories/prisma-care-recipient.repository';

// Application Services
import { CareGroupService } from './application/services/care-group.service';
import { CareTaskService } from './application/services/care-task.service';
import { CareActivityService } from './application/services/care-activity.service';
import { CareRecipientService } from './application/services/care-recipient.service';

// Presentation Controllers
import { CareGroupController } from './presentation/controllers/care-group.controller';

@Module({
  imports: [PrismaModule],
  controllers: [CareGroupController],
  providers: [
    // Application Services
    CareGroupService,
    CareTaskService,
    CareActivityService,
    CareRecipientService,

    // Repository Implementations
    {
      provide: CareGroupRepository,
      useClass: PrismaCareGroupRepository,
    },
    {
      provide: CareGroupMemberRepository,
      useClass: PrismaCareGroupMemberRepository,
    },
    {
      provide: CareTaskRepository,
      useClass: PrismaCareTaskRepository,
    },
    {
      provide: CareActivityRepository,
      useClass: PrismaCareActivityRepository,
    },
    {
      provide: CareRecipientRepository,
      useClass: PrismaCareRecipientRepository,
    },
  ],
  exports: [
    CareGroupService,
    CareTaskService,
    CareActivityService,
    CareRecipientService,
    CareGroupRepository,
    CareGroupMemberRepository,
    CareTaskRepository,
    CareActivityRepository,
    CareRecipientRepository,
  ],
})
export class CareGroupModule {}
