import { Test, TestingModule } from '@nestjs/testing';
import { DailyCheckInService } from './daily-check-in.service';

describe('DailyCheckInService', () => {
  let service: DailyCheckInService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [DailyCheckInService],
    }).compile();

    service = module.get<DailyCheckInService>(DailyCheckInService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
