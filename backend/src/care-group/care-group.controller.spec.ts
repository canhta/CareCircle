import { Test, TestingModule } from '@nestjs/testing';
import { CareGroupController } from './care-group.controller';

describe('CareGroupController', () => {
  let controller: CareGroupController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [CareGroupController],
    }).compile();

    controller = module.get<CareGroupController>(CareGroupController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
