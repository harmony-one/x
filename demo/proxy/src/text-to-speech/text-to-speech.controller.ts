import { Controller, Post, Get } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { TextToSpeechService } from './text-to-speech.service';

@Controller('text-to-speech')
export class TextToSpeechController {
  constructor(
    private configService: ConfigService,
    private ttsService: TextToSpeechService,
  ) {}

  @Get('google')
  async synthesize() {
    return this.ttsService.googleSyntesize('hello world');
  }
}
