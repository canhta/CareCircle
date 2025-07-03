import { Module } from '@nestjs/common';
import { DailyCheckInService } from './daily-check-in.service';
import { DailyCheckInController } from './daily-check-in.controller';

@Module({
  providers: [DailyCheckInService],
  controllers: [DailyCheckInController],
})
export class DailyCheckInModule {}
