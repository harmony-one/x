import { Test, TestingModule } from '@nestjs/testing';
import { DeepgramService } from './deepgram.service';

describe('DeepgramService', () => {
  let service: DeepgramService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [DeepgramService],
    }).compile();

    service = module.get<DeepgramService>(DeepgramService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
