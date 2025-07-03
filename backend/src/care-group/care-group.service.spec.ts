import { Test, TestingModule } from '@nestjs/testing';
import { CareGroupService } from './care-group.service';

describe('CareGroupService', () => {
  let service: CareGroupService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [CareGroupService],
    }).compile();

    service = module.get<CareGroupService>(CareGroupService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
