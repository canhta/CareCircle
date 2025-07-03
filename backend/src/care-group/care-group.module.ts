import { Module } from '@nestjs/common';
import { CareGroupService } from './care-group.service';
import { CareGroupController } from './care-group.controller';

@Module({
  providers: [CareGroupService],
  controllers: [CareGroupController],
})
export class CareGroupModule {}
