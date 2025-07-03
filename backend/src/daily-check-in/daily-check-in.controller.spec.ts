import { Test, TestingModule } from '@nestjs/testing';
import { DailyCheckInController } from './daily-check-in.controller';

describe('DailyCheckInController', () => {
  let controller: DailyCheckInController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [DailyCheckInController],
    }).compile();

    controller = module.get<DailyCheckInController>(DailyCheckInController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
